Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab2ERNKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:10:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11861 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933716Ab2ERNKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:51 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=vtn8VZ8Iq8IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=dVW6b4_sYD-S1S0I4HEA:9 a=O6WzSfPRFDS1T_FDX2wA:7 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=03M0YNMOOjPWqnN9:21 a=7hUC2adEOBBtWhlt:21 a=ONm2cgO-hwG1IKnxad4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131047.555079390@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 02/15] ring-buffer: Make removal of ring buffer pages atomic
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Make-removal-of-ring-buffer-pages-atomic.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

This patch adds the capability to remove pages from a ring buffer
without destroying any existing data in it.

This is done by removing the pages after the tail page. This makes sure
that first all the empty pages in the ring buffer are removed. If the
head page is one in the list of pages to be removed, then the page after
the removed ones is made the head page. This removes the oldest data
from the ring buffer and keeps the latest data around to be read.

To do this in a non-racey manner, tracing is stopped for a very short
time while the pages to be removed are identified and unlinked from the
ring buffer. The pages are freed after the tracing is restarted to
minimize the time needed to stop tracing.

The context in which the pages from the per-cpu ring buffer are removed
runs on the respective CPU. This minimizes the events not traced to only
NMI trace contexts.

Link: http://lkml.kernel.org/r/1336096792-25373-1-git-send-email-vnagarnaik=
@google.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Laurent Chavey <chavey@google.com>
Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |  265 ++++++++++++++++++++++++++++++++++------=
----
 kernel/trace/trace.c       |   20 +---
 2 files changed, 209 insertions(+), 76 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2d5eb33..27ac37e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -23,6 +23,8 @@
 #include <asm/local.h>
 #include "trace.h"
=20
+static void update_pages_handler(struct work_struct *work);
+
 /*
  * The ring buffer header is special. We must manually up keep it.
  */
@@ -470,12 +472,15 @@ struct ring_buffer_per_cpu {
 	/* ring buffer pages to update, > 0 to add, < 0 to remove */
 	int				nr_pages_to_update;
 	struct list_head		new_pages; /* new pages to add */
+	struct work_struct		update_pages_work;
+	struct completion		update_completion;
 };
=20
 struct ring_buffer {
 	unsigned			flags;
 	int				cpus;
 	atomic_t			record_disabled;
+	atomic_t			resize_disabled;
 	cpumask_var_t			cpumask;
=20
 	struct lock_class_key		*reader_lock_key;
@@ -1048,6 +1053,8 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, in=
t nr_pages, int cpu)
 	raw_spin_lock_init(&cpu_buffer->reader_lock);
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock =3D (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+	INIT_WORK(&cpu_buffer->update_pages_work, update_pages_handler);
+	init_completion(&cpu_buffer->update_completion);
=20
 	bpage =3D kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
@@ -1235,32 +1242,123 @@ void ring_buffer_set_clock(struct ring_buffer *buf=
fer,
=20
 static void rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer);
=20
+static inline unsigned long rb_page_entries(struct buffer_page *bpage)
+{
+	return local_read(&bpage->entries) & RB_WRITE_MASK;
+}
+
+static inline unsigned long rb_page_write(struct buffer_page *bpage)
+{
+	return local_read(&bpage->write) & RB_WRITE_MASK;
+}
+
 static void
-rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
+rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pa=
ges)
 {
-	struct buffer_page *bpage;
-	struct list_head *p;
-	unsigned i;
+	struct list_head *tail_page, *to_remove, *next_page;
+	struct buffer_page *to_remove_page, *tmp_iter_page;
+	struct buffer_page *last_page, *first_page;
+	unsigned int nr_removed;
+	unsigned long head_bit;
+	int page_entries;
+
+	head_bit =3D 0;
=20
 	raw_spin_lock_irq(&cpu_buffer->reader_lock);
-	rb_head_page_deactivate(cpu_buffer);
+	atomic_inc(&cpu_buffer->record_disabled);
+	/*
+	 * We don't race with the readers since we have acquired the reader
+	 * lock. We also don't race with writers after disabling recording.
+	 * This makes it easy to figure out the first and the last page to be
+	 * removed from the list. We unlink all the pages in between including
+	 * the first and last pages. This is done in a busy loop so that we
+	 * lose the least number of traces.
+	 * The pages are freed after we restart recording and unlock readers.
+	 */
+	tail_page =3D &cpu_buffer->tail_page->list;
=20
-	for (i =3D 0; i < nr_pages; i++) {
-		if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
-			goto out;
-		p =3D cpu_buffer->pages->next;
-		bpage =3D list_entry(p, struct buffer_page, list);
-		list_del_init(&bpage->list);
-		free_buffer_page(bpage);
+	/*
+	 * tail page might be on reader page, we remove the next page
+	 * from the ring buffer
+	 */
+	if (cpu_buffer->tail_page =3D=3D cpu_buffer->reader_page)
+		tail_page =3D rb_list_head(tail_page->next);
+	to_remove =3D tail_page;
+
+	/* start of pages to remove */
+	first_page =3D list_entry(rb_list_head(to_remove->next),
+				struct buffer_page, list);
+
+	for (nr_removed =3D 0; nr_removed < nr_pages; nr_removed++) {
+		to_remove =3D rb_list_head(to_remove)->next;
+		head_bit |=3D (unsigned long)to_remove & RB_PAGE_HEAD;
 	}
-	if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
-		goto out;
=20
-	rb_reset_cpu(cpu_buffer);
-	rb_check_pages(cpu_buffer);
+	next_page =3D rb_list_head(to_remove)->next;
=20
-out:
+	/*
+	 * Now we remove all pages between tail_page and next_page.
+	 * Make sure that we have head_bit value preserved for the
+	 * next page
+	 */
+	tail_page->next =3D (struct list_head *)((unsigned long)next_page |
+						head_bit);
+	next_page =3D rb_list_head(next_page);
+	next_page->prev =3D tail_page;
+
+	/* make sure pages points to a valid page in the ring buffer */
+	cpu_buffer->pages =3D next_page;
+
+	/* update head page */
+	if (head_bit)
+		cpu_buffer->head_page =3D list_entry(next_page,
+						struct buffer_page, list);
+
+	/*
+	 * change read pointer to make sure any read iterators reset
+	 * themselves
+	 */
+	cpu_buffer->read =3D 0;
+
+	/* pages are removed, resume tracing and then free the pages */
+	atomic_dec(&cpu_buffer->record_disabled);
 	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
+
+	RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages));
+
+	/* last buffer page to remove */
+	last_page =3D list_entry(rb_list_head(to_remove), struct buffer_page,
+				list);
+	tmp_iter_page =3D first_page;
+
+	do {
+		to_remove_page =3D tmp_iter_page;
+		rb_inc_page(cpu_buffer, &tmp_iter_page);
+
+		/* update the counters */
+		page_entries =3D rb_page_entries(to_remove_page);
+		if (page_entries) {
+			/*
+			 * If something was added to this page, it was full
+			 * since it is not the tail page. So we deduct the
+			 * bytes consumed in ring buffer from here.
+			 * No need to update overruns, since this page is
+			 * deleted from ring buffer and its entries are
+			 * already accounted for.
+			 */
+			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+		}
+
+		/*
+		 * We have already removed references to this list item, just
+		 * free up the buffer_page and its page
+		 */
+		free_buffer_page(to_remove_page);
+		nr_removed--;
+
+	} while (to_remove_page !=3D last_page);
+
+	RB_WARN_ON(cpu_buffer, nr_removed);
 }
=20
 static void
@@ -1272,6 +1370,8 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffe=
r,
 	unsigned i;
=20
 	raw_spin_lock_irq(&cpu_buffer->reader_lock);
+	/* stop the writers while inserting pages */
+	atomic_inc(&cpu_buffer->record_disabled);
 	rb_head_page_deactivate(cpu_buffer);
=20
 	for (i =3D 0; i < nr_pages; i++) {
@@ -1286,19 +1386,27 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buf=
fer,
 	rb_check_pages(cpu_buffer);
=20
 out:
+	atomic_dec(&cpu_buffer->record_disabled);
 	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
 }
=20
-static void update_pages_handler(struct ring_buffer_per_cpu *cpu_buffer)
+static void rb_update_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	if (cpu_buffer->nr_pages_to_update > 0)
 		rb_insert_pages(cpu_buffer, &cpu_buffer->new_pages,
 				cpu_buffer->nr_pages_to_update);
 	else
 		rb_remove_pages(cpu_buffer, -cpu_buffer->nr_pages_to_update);
+
 	cpu_buffer->nr_pages +=3D cpu_buffer->nr_pages_to_update;
-	/* reset this value */
-	cpu_buffer->nr_pages_to_update =3D 0;
+}
+
+static void update_pages_handler(struct work_struct *work)
+{
+	struct ring_buffer_per_cpu *cpu_buffer =3D container_of(work,
+			struct ring_buffer_per_cpu, update_pages_work);
+	rb_update_pages(cpu_buffer);
+	complete(&cpu_buffer->update_completion);
 }
=20
 /**
@@ -1308,14 +1416,14 @@ static void update_pages_handler(struct ring_buffer=
_per_cpu *cpu_buffer)
  *
  * Minimum size is 2 * BUF_PAGE_SIZE.
  *
- * Returns -1 on failure.
+ * Returns 0 on success and < 0 on failure.
  */
 int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 			int cpu_id)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned nr_pages;
-	int cpu;
+	int cpu, err =3D 0;
=20
 	/*
 	 * Always succeed at resizing a non-existent buffer:
@@ -1330,15 +1438,18 @@ int ring_buffer_resize(struct ring_buffer *buffer, =
unsigned long size,
 	if (size < BUF_PAGE_SIZE * 2)
 		size =3D BUF_PAGE_SIZE * 2;
=20
-	atomic_inc(&buffer->record_disabled);
+	nr_pages =3D DIV_ROUND_UP(size, BUF_PAGE_SIZE);
=20
-	/* Make sure all writers are done with this buffer. */
-	synchronize_sched();
+	/*
+	 * Don't succeed if resizing is disabled, as a reader might be
+	 * manipulating the ring buffer and is expecting a sane state while
+	 * this is true.
+	 */
+	if (atomic_read(&buffer->resize_disabled))
+		return -EBUSY;
=20
+	/* prevent another thread from changing buffer sizes */
 	mutex_lock(&buffer->mutex);
-	get_online_cpus();
-
-	nr_pages =3D DIV_ROUND_UP(size, BUF_PAGE_SIZE);
=20
 	if (cpu_id =3D=3D RING_BUFFER_ALL_CPUS) {
 		/* calculate the pages to update */
@@ -1347,33 +1458,67 @@ int ring_buffer_resize(struct ring_buffer *buffer, =
unsigned long size,
=20
 			cpu_buffer->nr_pages_to_update =3D nr_pages -
 							cpu_buffer->nr_pages;
-
 			/*
 			 * nothing more to do for removing pages or no update
 			 */
 			if (cpu_buffer->nr_pages_to_update <=3D 0)
 				continue;
-
 			/*
 			 * to add pages, make sure all new pages can be
 			 * allocated without receiving ENOMEM
 			 */
 			INIT_LIST_HEAD(&cpu_buffer->new_pages);
 			if (__rb_allocate_pages(cpu_buffer->nr_pages_to_update,
-						&cpu_buffer->new_pages, cpu))
+						&cpu_buffer->new_pages, cpu)) {
 				/* not enough memory for new pages */
-				goto no_mem;
+				err =3D -ENOMEM;
+				goto out_err;
+			}
+		}
+
+		get_online_cpus();
+		/*
+		 * Fire off all the required work handlers
+		 * Look out for offline CPUs
+		 */
+		for_each_buffer_cpu(buffer, cpu) {
+			cpu_buffer =3D buffer->buffers[cpu];
+			if (!cpu_buffer->nr_pages_to_update ||
+			    !cpu_online(cpu))
+				continue;
+
+			schedule_work_on(cpu, &cpu_buffer->update_pages_work);
+		}
+		/*
+		 * This loop is for the CPUs that are not online.
+		 * We can't schedule anything on them, but it's not necessary
+		 * since we can change their buffer sizes without any race.
+		 */
+		for_each_buffer_cpu(buffer, cpu) {
+			cpu_buffer =3D buffer->buffers[cpu];
+			if (!cpu_buffer->nr_pages_to_update ||
+			    cpu_online(cpu))
+				continue;
+
+			rb_update_pages(cpu_buffer);
 		}
=20
 		/* wait for all the updates to complete */
 		for_each_buffer_cpu(buffer, cpu) {
 			cpu_buffer =3D buffer->buffers[cpu];
-			if (cpu_buffer->nr_pages_to_update) {
-				update_pages_handler(cpu_buffer);
-			}
+			if (!cpu_buffer->nr_pages_to_update ||
+			    !cpu_online(cpu))
+				continue;
+
+			wait_for_completion(&cpu_buffer->update_completion);
+			/* reset this value */
+			cpu_buffer->nr_pages_to_update =3D 0;
 		}
+
+		put_online_cpus();
 	} else {
 		cpu_buffer =3D buffer->buffers[cpu_id];
+
 		if (nr_pages =3D=3D cpu_buffer->nr_pages)
 			goto out;
=20
@@ -1383,38 +1528,47 @@ int ring_buffer_resize(struct ring_buffer *buffer, =
unsigned long size,
 		INIT_LIST_HEAD(&cpu_buffer->new_pages);
 		if (cpu_buffer->nr_pages_to_update > 0 &&
 			__rb_allocate_pages(cpu_buffer->nr_pages_to_update,
-						&cpu_buffer->new_pages, cpu_id))
-			goto no_mem;
+					    &cpu_buffer->new_pages, cpu_id)) {
+			err =3D -ENOMEM;
+			goto out_err;
+		}
=20
-		update_pages_handler(cpu_buffer);
+		get_online_cpus();
+
+		if (cpu_online(cpu_id)) {
+			schedule_work_on(cpu_id,
+					 &cpu_buffer->update_pages_work);
+			wait_for_completion(&cpu_buffer->update_completion);
+		} else
+			rb_update_pages(cpu_buffer);
+
+		put_online_cpus();
+		/* reset this value */
+		cpu_buffer->nr_pages_to_update =3D 0;
 	}
=20
  out:
-	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
-
-	atomic_dec(&buffer->record_disabled);
-
 	return size;
=20
- no_mem:
+ out_err:
 	for_each_buffer_cpu(buffer, cpu) {
 		struct buffer_page *bpage, *tmp;
+
 		cpu_buffer =3D buffer->buffers[cpu];
-		/* reset this number regardless */
 		cpu_buffer->nr_pages_to_update =3D 0;
+
 		if (list_empty(&cpu_buffer->new_pages))
 			continue;
+
 		list_for_each_entry_safe(bpage, tmp, &cpu_buffer->new_pages,
 					list) {
 			list_del_init(&bpage->list);
 			free_buffer_page(bpage);
 		}
 	}
-	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
-	atomic_dec(&buffer->record_disabled);
-	return -ENOMEM;
+	return err;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
=20
@@ -1453,21 +1607,11 @@ rb_iter_head_event(struct ring_buffer_iter *iter)
 	return __rb_page_index(iter->head_page, iter->head);
 }
=20
-static inline unsigned long rb_page_write(struct buffer_page *bpage)
-{
-	return local_read(&bpage->write) & RB_WRITE_MASK;
-}
-
 static inline unsigned rb_page_commit(struct buffer_page *bpage)
 {
 	return local_read(&bpage->page->commit);
 }
=20
-static inline unsigned long rb_page_entries(struct buffer_page *bpage)
-{
-	return local_read(&bpage->entries) & RB_WRITE_MASK;
-}
-
 /* Size is determined by what has been committed */
 static inline unsigned rb_page_size(struct buffer_page *bpage)
 {
@@ -3492,6 +3636,7 @@ ring_buffer_read_prepare(struct ring_buffer *buffer, =
int cpu)
=20
 	iter->cpu_buffer =3D cpu_buffer;
=20
+	atomic_inc(&buffer->resize_disabled);
 	atomic_inc(&cpu_buffer->record_disabled);
=20
 	return iter;
@@ -3555,6 +3700,7 @@ ring_buffer_read_finish(struct ring_buffer_iter *iter)
 	struct ring_buffer_per_cpu *cpu_buffer =3D iter->cpu_buffer;
=20
 	atomic_dec(&cpu_buffer->record_disabled);
+	atomic_dec(&cpu_buffer->buffer->resize_disabled);
 	kfree(iter);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_finish);
@@ -3662,8 +3808,12 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffe=
r, int cpu)
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
=20
+	atomic_inc(&buffer->resize_disabled);
 	atomic_inc(&cpu_buffer->record_disabled);
=20
+	/* Make sure all commits have finished */
+	synchronize_sched();
+
 	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
=20
 	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
@@ -3679,6 +3829,7 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer=
, int cpu)
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
=20
 	atomic_dec(&cpu_buffer->record_disabled);
+	atomic_dec(&buffer->resize_disabled);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
=20
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d1b3469..dfbd86c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3076,20 +3076,10 @@ static int __tracing_resize_ring_buffer(unsigned lo=
ng size, int cpu)
=20
 static ssize_t tracing_resize_ring_buffer(unsigned long size, int cpu_id)
 {
-	int cpu, ret =3D size;
+	int ret =3D size;
=20
 	mutex_lock(&trace_types_lock);
=20
-	tracing_stop();
-
-	/* disable all cpu buffers */
-	for_each_tracing_cpu(cpu) {
-		if (global_trace.data[cpu])
-			atomic_inc(&global_trace.data[cpu]->disabled);
-		if (max_tr.data[cpu])
-			atomic_inc(&max_tr.data[cpu]->disabled);
-	}
-
 	if (cpu_id !=3D RING_BUFFER_ALL_CPUS) {
 		/* make sure, this cpu is enabled in the mask */
 		if (!cpumask_test_cpu(cpu_id, tracing_buffer_mask)) {
@@ -3103,14 +3093,6 @@ static ssize_t tracing_resize_ring_buffer(unsigned l=
ong size, int cpu_id)
 		ret =3D -ENOMEM;
=20
 out:
-	for_each_tracing_cpu(cpu) {
-		if (global_trace.data[cpu])
-			atomic_dec(&global_trace.data[cpu]->disabled);
-		if (max_tr.data[cpu])
-			atomic_dec(&max_tr.data[cpu]->disabled);
-	}
-
-	tracing_start();
 	mutex_unlock(&trace_types_lock);
=20
 	return ret;
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpXAAoJEIy3vGnGbaoAgjgP/iznfGElJ6VazZ/Npb/5EfWk
a9OODLztrymsZUqQvDoGtSs0Fjx+79RzKUB5f0TXiJNVQbTAQ6rMrFkYwHPakyOc
sww+ZqPHTutjBCGmPTtamuWE2WTGdENWgRXt5gQqthNIeFIXn9SFdlXPCPibdrpZ
oipht1/ASCJhRo79HvcUk0g0BeM8Dl7Bwwe8bHeIlcYAHXl+/x+E1GFNgaHtqgJP
N8jyEj0dd6Ph2WRaz7nAHujkysNsCcwUtDX6UpVd2OrpQ6JNs8/RLSCaDmBKr2oj
tnsPl3gxA05U5r4pT6Wfb6eEK1Q6yKxlw1Fo87esITQcyu7Q0xziKbX3OyojDBD3
cIJBy7lipdFvHVVH2IqxwIgyHejfUvzZ5WidX8Lmtl2J+lYek9answBzteC92CGr
iOs0OyRaQ7xmPDIAevd1JU0pRgGkEcuIk0eHma5m0HXCooBEGdeMbRZEho0baizQ
rIaMuu5CD8xfGGr2xuh3YrT0mdL0N0k12hMB8eIJi+mnT/9yuxb4YEBjzzbIuoRL
6Om9b4dKtXL7xiz6g0ZG+132vJ7XSH2PjVl/7FwoR9U9B9DUMYVEQtGodydD0Am1
mWI078UNGGGMI5bC6b0AmAF5t7SU2JZ5ox5dMI6+qf62tA75pCBLuqJms6cDrh9k
HvrRND7QlAERPZOVAfmA
=Mzyy
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
