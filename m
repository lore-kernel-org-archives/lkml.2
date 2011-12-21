Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1LUMk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:40:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab1LUMiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:09 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=GcvDnHA-DdUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=XHTfvITCulBSqVXkfigA:9 a=ggt8OashdldsYY4cPuEA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=FppV1tn6q4sNyh1k:21 a=d-HqKnyn4jY3wHd2:21 a=TZtSkLqfzo_4Skg9v3oA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123804.992614557@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/16] ftrace: Allocate the mcount record pages as groups
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-Allocate-the-mcount-record-pages-as-groups.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Allocate the mcount record pages as a group of pages as big
as can be allocated and waste no more than a single page.

Grouping the mcount pages as much as possible helps with cache
locality, as we do not need to redirect with descriptors as we
cross from page to page. It also allows us to do more with the
records later on (sort them with bigger benefits).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |  179 +++++++++++++++++++++++++++++++++++----------=
----
 1 files changed, 128 insertions(+), 51 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index be6888f..2e72188 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -983,12 +983,13 @@ static DEFINE_MUTEX(ftrace_regex_lock);
=20
 struct ftrace_page {
 	struct ftrace_page	*next;
+	struct dyn_ftrace	*records;
 	int			index;
-	struct dyn_ftrace	records[];
+	int			size;
 };
=20
-#define ENTRIES_PER_PAGE \
-  ((PAGE_SIZE - sizeof(struct ftrace_page)) / sizeof(struct dyn_ftrace))
+#define ENTRY_SIZE sizeof(struct dyn_ftrace)
+#define ENTRIES_PER_PAGE (PAGE_SIZE / ENTRY_SIZE)
=20
 /* estimate from running different kernels */
 #define NR_TO_INIT		10000
@@ -1421,14 +1422,10 @@ static void ftrace_hash_rec_enable(struct ftrace_op=
s *ops,
=20
 static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
 {
-	if (ftrace_pages->index =3D=3D ENTRIES_PER_PAGE) {
-		if (!ftrace_pages->next) {
-			/* allocate another page */
-			ftrace_pages->next =3D
-				(void *)get_zeroed_page(GFP_KERNEL);
-			if (!ftrace_pages->next)
-				return NULL;
-		}
+	if (ftrace_pages->index =3D=3D ftrace_pages->size) {
+		/* We should have allocated enough */
+		if (WARN_ON(!ftrace_pages->next))
+			return NULL;
 		ftrace_pages =3D ftrace_pages->next;
 	}
=20
@@ -2005,47 +2002,106 @@ static int ftrace_update_code(struct module *mod)
 	return 0;
 }
=20
-static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
+static int ftrace_allocate_records(struct ftrace_page *pg, int count)
 {
-	struct ftrace_page *pg;
+	int order;
 	int cnt;
-	int i;
=20
-	/* allocate a few pages */
-	ftrace_pages_start =3D (void *)get_zeroed_page(GFP_KERNEL);
-	if (!ftrace_pages_start)
-		return -1;
+	if (WARN_ON(!count))
+		return -EINVAL;
+
+	order =3D get_count_order(DIV_ROUND_UP(count, ENTRIES_PER_PAGE));
=20
 	/*
-	 * Allocate a few more pages.
-	 *
-	 * TODO: have some parser search vmlinux before
-	 *   final linking to find all calls to ftrace.
-	 *   Then we can:
-	 *    a) know how many pages to allocate.
-	 *     and/or
-	 *    b) set up the table then.
-	 *
-	 *  The dynamic code is still necessary for
-	 *  modules.
+	 * We want to fill as much as possible. No more than a page
+	 * may be empty.
 	 */
+	while ((PAGE_SIZE << order) / ENTRY_SIZE >=3D count + ENTRIES_PER_PAGE)
+		order--;
=20
-	pg =3D ftrace_pages =3D ftrace_pages_start;
+ again:
+	pg->records =3D (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
=20
-	cnt =3D num_to_init / ENTRIES_PER_PAGE;
-	pr_info("ftrace: allocating %ld entries in %d pages\n",
-		num_to_init, cnt + 1);
+	if (!pg->records) {
+		/* if we can't allocate this size, try something smaller */
+		if (!order)
+			return -ENOMEM;
+		order >>=3D 1;
+		goto again;
+	}
=20
-	for (i =3D 0; i < cnt; i++) {
-		pg->next =3D (void *)get_zeroed_page(GFP_KERNEL);
+	cnt =3D (PAGE_SIZE << order) / ENTRY_SIZE;
+	pg->size =3D cnt;
=20
-		/* If we fail, we'll try later anyway */
-		if (!pg->next)
+	if (cnt > count)
+		cnt =3D count;
+
+	return cnt;
+}
+
+static struct ftrace_page *
+ftrace_allocate_pages(unsigned long num_to_init)
+{
+	struct ftrace_page *start_pg;
+	struct ftrace_page *pg;
+	int order;
+	int cnt;
+
+	if (!num_to_init)
+		return 0;
+
+	start_pg =3D pg =3D kzalloc(sizeof(*pg), GFP_KERNEL);
+	if (!pg)
+		return NULL;
+
+	/*
+	 * Try to allocate as much as possible in one continues
+	 * location that fills in all of the space. We want to
+	 * waste as little space as possible.
+	 */
+	for (;;) {
+		cnt =3D ftrace_allocate_records(pg, num_to_init);
+		if (cnt < 0)
+			goto free_pages;
+
+		num_to_init -=3D cnt;
+		if (!num_to_init)
 			break;
=20
+		pg->next =3D kzalloc(sizeof(*pg), GFP_KERNEL);
+		if (!pg->next)
+			goto free_pages;
+
 		pg =3D pg->next;
 	}
=20
+	return start_pg;
+
+ free_pages:
+	while (start_pg) {
+		order =3D get_count_order(pg->size / ENTRIES_PER_PAGE);
+		free_pages((unsigned long)pg->records, order);
+		start_pg =3D pg->next;
+		kfree(pg);
+		pg =3D start_pg;
+	}
+	pr_info("ftrace: FAILED to allocate memory for functions\n");
+	return NULL;
+}
+
+static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
+{
+	int cnt;
+
+	if (!num_to_init) {
+		pr_info("ftrace: No functions to be traced?\n");
+		return -1;
+	}
+
+	cnt =3D num_to_init / ENTRIES_PER_PAGE;
+	pr_info("ftrace: allocating %ld entries in %d pages\n",
+		num_to_init, cnt + 1);
+
 	return 0;
 }
=20
@@ -3520,30 +3576,45 @@ static int ftrace_process_locs(struct module *mod,
 			       unsigned long *start,
 			       unsigned long *end)
 {
+	struct ftrace_page *pg;
+	unsigned long count;
 	unsigned long *p;
 	unsigned long addr;
 	unsigned long flags =3D 0; /* Shut up gcc */
+	int ret =3D -ENOMEM;
+
+	count =3D end - start;
+
+	if (!count)
+		return 0;
+
+	pg =3D ftrace_allocate_pages(count);
+	if (!pg)
+		return -ENOMEM;
=20
 	mutex_lock(&ftrace_lock);
+
 	/*
 	 * Core and each module needs their own pages, as
 	 * modules will free them when they are removed.
 	 * Force a new page to be allocated for modules.
 	 */
-	if (mod) {
+	if (!mod) {
+		WARN_ON(ftrace_pages || ftrace_pages_start);
+		/* First initialization */
+		ftrace_pages =3D ftrace_pages_start =3D pg;
+	} else {
 		if (!ftrace_pages)
-			return -ENOMEM;
+			goto out;
=20
-		/*
-		 * If the last page was full, it will be
-		 * allocated anyway.
-		 */
-		if (ftrace_pages->index !=3D ENTRIES_PER_PAGE) {
-			ftrace_pages->next =3D (void *)get_zeroed_page(GFP_KERNEL);
-			if (!ftrace_pages->next)
-				return -ENOMEM;
-			ftrace_pages =3D ftrace_pages->next;
+		if (WARN_ON(ftrace_pages->next)) {
+			/* Hmm, we have free pages? */
+			while (ftrace_pages->next)
+				ftrace_pages =3D ftrace_pages->next;
 		}
+
+		ftrace_pages->next =3D pg;
+		ftrace_pages =3D pg;
 	}
=20
 	p =3D start;
@@ -3557,7 +3628,8 @@ static int ftrace_process_locs(struct module *mod,
 		 */
 		if (!addr)
 			continue;
-		ftrace_record_ip(addr);
+		if (!ftrace_record_ip(addr))
+			break;
 	}
=20
 	/*
@@ -3573,9 +3645,11 @@ static int ftrace_process_locs(struct module *mod,
 	ftrace_update_code(mod);
 	if (!mod)
 		local_irq_restore(flags);
+	ret =3D 0;
+ out:
 	mutex_unlock(&ftrace_lock);
=20
-	return 0;
+	return ret;
 }
=20
 #ifdef CONFIG_MODULES
@@ -3587,6 +3661,7 @@ void ftrace_release_mod(struct module *mod)
 	struct dyn_ftrace *rec;
 	struct ftrace_page **last_pg;
 	struct ftrace_page *pg;
+	int order;
=20
 	mutex_lock(&ftrace_lock);
=20
@@ -3613,7 +3688,9 @@ void ftrace_release_mod(struct module *mod)
 				ftrace_pages =3D next_to_ftrace_page(last_pg);
=20
 			*last_pg =3D pg->next;
-			free_page((unsigned long)pg);
+			order =3D get_count_order(pg->size / ENTRIES_PER_PAGE);
+			free_pages((unsigned long)pg->records, order);
+			kfree(pg);
 		} else
 			last_pg =3D &pg->next;
 	}
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMtAAoJEIy3vGnGbaoAAk8P/1YG33dGKS/mQ9INWPed+mKD
SENrPp9i7cQn1rlOhwAviUhIDtmWmBT5B/tlpIHRYVWjgHZuuJPR2WTXvf1Qamue
UEk5ThGdAoQJRF9mYvENM38T+rm9t4P4EAqpXQ05HoUjy5uCcYXGd1KSmncAgw0b
5G64ZYVtZmVwm5lfX63W7oraEr+cx9wCC2m7gAhIjhwm+QnaWN5dj+fOkppldoFb
tR8wgsyHz2n1W0zarQohuNhG2T1t0r+pw9ncp9z2qejyN6zU0lXk204enjqorwSr
NXqkuw2Ok2b3L5kQ2p+h+Tjf7uxXzmuSFYz/DH6DdnL2B59oWB9DqJYQ1x1sjeQy
h6zdo6vVBnuIuOtcvRmyJcx1iLy7cGt4w3SkuOYxLHlFR5CpeP3OcHtF7E5Xlqwg
hpLHhFPBGz11w57DOUtSvZgFR7B/+NTG2TKRd+tXBXF249ARdcgg3hGSyot4GOVX
ntun0aq9jqRfY4dYH3nJkSSQOrupyaA/5JaDntlAVWByvKgSetNz2tL9IGrZg9M2
6DcYmqRuGRGNkEmXICa63ZoT7K5VGW71AxBFxZD9rLPW38BNAvtg7NnkpOQ1KRsQ
+3owZz+tQ1hRw/vUQFnUUobBz0yBXw4fI5zInvqn2EheYbQ1bewcZilwpt/W1+6i
JvR86p0YnCsvWxpo+UAk
=hNZt
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
