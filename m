Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946052Ab2ERNN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:13:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11861 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933720Ab2ERNKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:52 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=fWvGgbttJuYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=iS_OOktIWzmYcxqy30kA:9 a=R24E7WSJHg-cdPbQIvUA:7 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=xC8rZwNW_HSX2fhxIdEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131047.939973680@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 03/15] ring-buffer: Make addition of pages in ring buffer atomic
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0003-ring-buffer-Make-addition-of-pages-in-ring-buffer-at.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

This patch adds the capability to add new pages to a ring buffer
atomically while write operations are going on. This makes it possible
to expand the ring buffer size without reinitializing the ring buffer.

The new pages are attached between the head page and its previous page.

Link: http://lkml.kernel.org/r/1336096792-25373-2-git-send-email-vnagarnaik=
@google.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Laurent Chavey <chavey@google.com>
Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |  102 +++++++++++++++++++++++++++++++++-------=
----
 1 file changed, 77 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 27ac37e..d673ef0 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1252,7 +1252,7 @@ static inline unsigned long rb_page_write(struct buff=
er_page *bpage)
 	return local_read(&bpage->write) & RB_WRITE_MASK;
 }
=20
-static void
+static int
 rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pa=
ges)
 {
 	struct list_head *tail_page, *to_remove, *next_page;
@@ -1359,46 +1359,97 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buf=
fer, unsigned int nr_pages)
 	} while (to_remove_page !=3D last_page);
=20
 	RB_WARN_ON(cpu_buffer, nr_removed);
+
+	return nr_removed =3D=3D 0;
 }
=20
-static void
-rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
-		struct list_head *pages, unsigned nr_pages)
+static int
+rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct buffer_page *bpage;
-	struct list_head *p;
-	unsigned i;
+	struct list_head *pages =3D &cpu_buffer->new_pages;
+	int retries, success;
=20
 	raw_spin_lock_irq(&cpu_buffer->reader_lock);
-	/* stop the writers while inserting pages */
-	atomic_inc(&cpu_buffer->record_disabled);
-	rb_head_page_deactivate(cpu_buffer);
+	/*
+	 * We are holding the reader lock, so the reader page won't be swapped
+	 * in the ring buffer. Now we are racing with the writer trying to
+	 * move head page and the tail page.
+	 * We are going to adapt the reader page update process where:
+	 * 1. We first splice the start and end of list of new pages between
+	 *    the head page and its previous page.
+	 * 2. We cmpxchg the prev_page->next to point from head page to the
+	 *    start of new pages list.
+	 * 3. Finally, we update the head->prev to the end of new list.
+	 *
+	 * We will try this process 10 times, to make sure that we don't keep
+	 * spinning.
+	 */
+	retries =3D 10;
+	success =3D 0;
+	while (retries--) {
+		struct list_head *head_page, *prev_page, *r;
+		struct list_head *last_page, *first_page;
+		struct list_head *head_page_with_bit;
=20
-	for (i =3D 0; i < nr_pages; i++) {
-		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
-			goto out;
-		p =3D pages->next;
-		bpage =3D list_entry(p, struct buffer_page, list);
-		list_del_init(&bpage->list);
-		list_add_tail(&bpage->list, cpu_buffer->pages);
+		head_page =3D &rb_set_head_page(cpu_buffer)->list;
+		prev_page =3D head_page->prev;
+
+		first_page =3D pages->next;
+		last_page  =3D pages->prev;
+
+		head_page_with_bit =3D (struct list_head *)
+				     ((unsigned long)head_page | RB_PAGE_HEAD);
+
+		last_page->next =3D head_page_with_bit;
+		first_page->prev =3D prev_page;
+
+		r =3D cmpxchg(&prev_page->next, head_page_with_bit, first_page);
+
+		if (r =3D=3D head_page_with_bit) {
+			/*
+			 * yay, we replaced the page pointer to our new list,
+			 * now, we just have to update to head page's prev
+			 * pointer to point to end of list
+			 */
+			head_page->prev =3D last_page;
+			success =3D 1;
+			break;
+		}
 	}
-	rb_reset_cpu(cpu_buffer);
-	rb_check_pages(cpu_buffer);
=20
-out:
-	atomic_dec(&cpu_buffer->record_disabled);
+	if (success)
+		INIT_LIST_HEAD(pages);
+	/*
+	 * If we weren't successful in adding in new pages, warn and stop
+	 * tracing
+	 */
+	RB_WARN_ON(cpu_buffer, !success);
 	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
+
+	/* free pages if they weren't inserted */
+	if (!success) {
+		struct buffer_page *bpage, *tmp;
+		list_for_each_entry_safe(bpage, tmp, &cpu_buffer->new_pages,
+					 list) {
+			list_del_init(&bpage->list);
+			free_buffer_page(bpage);
+		}
+	}
+	return success;
 }
=20
 static void rb_update_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
+	int success;
+
 	if (cpu_buffer->nr_pages_to_update > 0)
-		rb_insert_pages(cpu_buffer, &cpu_buffer->new_pages,
-				cpu_buffer->nr_pages_to_update);
+		success =3D rb_insert_pages(cpu_buffer);
 	else
-		rb_remove_pages(cpu_buffer, -cpu_buffer->nr_pages_to_update);
+		success =3D rb_remove_pages(cpu_buffer,
+					-cpu_buffer->nr_pages_to_update);
=20
-	cpu_buffer->nr_pages +=3D cpu_buffer->nr_pages_to_update;
+	if (success)
+		cpu_buffer->nr_pages +=3D cpu_buffer->nr_pages_to_update;
 }
=20
 static void update_pages_handler(struct work_struct *work)
@@ -3772,6 +3823,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->commit_page =3D cpu_buffer->head_page;
=20
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	INIT_LIST_HEAD(&cpu_buffer->new_pages);
 	local_set(&cpu_buffer->reader_page->write, 0);
 	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpYAAoJEIy3vGnGbaoAHokQAJMvLiM+0ORPK5N+/hu3UbwJ
h/u/ssw79sML19c6DiAmo5/VVVRbUhpuOM4KsjAKQAv8fqnHfaA/86a8UZFPJf0k
GHA6BNA6sGlbFbiaAre/oZh4hzIDR7wjda8eW+BIah9mUZH/G3MW3mB2XmK52tNd
/HnYrrhhMZ3IiNwX68ydWKlqVVS7kcD/MOK4hysjIZC2n2HHqY1AzJY3OMUeBz3e
qvrYolncZsMgi3jdRHVl8eizSQohHheH6+LhTxukm3ZjfXOUmE63SIb014mZpsCh
7s77/dUAVpBmjUvxGVi95JJr5fzT2SFRekaGQJUuvg2KVN2IZVwIOSWnFRdl4STf
6UWgHnOmjF7+5RPnZVZ6ZAcPEXWl7ROmK/0dgZoCwoe+tEk2T3FOcDccc7qijpYP
7/F5/2QtedoJ5kzIaHGRJF33gs5d/Hv9NRAikw6TJ5CuKS7yqWpcRtE9ddpY9JHt
dh7NF6P6WODx8fmYpP+my27C19pz3lJ/qzvtogOKnU56m5/makjKqb8eq+/zweYu
L/p4aOdRLEg5yJkzfwBlgvTprV1dEXMBR/ghIqBf0zplymfWk+nUqD68wAPRYq8W
tpuybNrLxGQ8obO7A/IYLODSOgjdxHx9b2XfpSlSXx6a+AvDrwChBrFwOVvlQckS
gWUf92wnN/rr/BSu2fMD
=JAp1
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
