Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab2DYSuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:50:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600Ab2DYStc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:49:32 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=ur5Ksv2_SrMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=UH1ysNmooa84iRmNPgkA:9 a=SycXC-uzOr1Dp8WNwpcA:7 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=d7rd_WlCeNB6n6gP:21 a=e1hr79UB0Z5uFdGe:21 a=Bdy1WWwddcQEiRNlmVAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120425184930.512466346@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 25 Apr 2012 14:48:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 3/5] ring-buffer: Add per_cpu ring buffer control files
References: <20120425184830.325105778@goodmis.org>
Content-Disposition: inline; filename=0003-ring-buffer-Add-per_cpu-ring-buffer-control-files.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

Add a debugfs entry under per_cpu/ folder for each cpu called
buffer_size_kb to control the ring buffer size for each CPU
independently.

If the global file buffer_size_kb is used to set size, the individual
ring buffers will be adjusted to the given size. The buffer_size_kb will
report the common size to maintain backward compatibility.

If the buffer_size_kb file under the per_cpu/ directory is used to
change buffer size for a specific CPU, only the size of the respective
ring buffer is updated. When tracing/buffer_size_kb is read, it reports
'X' to indicate that sizes of per_cpu ring buffers are not equivalent.

Link: http://lkml.kernel.org/r/1328212844-11889-1-git-send-email-vnagarnaik=
@google.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Justin Teravest <teravest@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    6 +-
 kernel/trace/ring_buffer.c  |  248 ++++++++++++++++++++++++---------------=
----
 kernel/trace/trace.c        |  190 ++++++++++++++++++++++++++-------
 kernel/trace/trace.h        |    2 +-
 4 files changed, 297 insertions(+), 149 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 7be2e88..6c8835f 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -96,9 +96,11 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, =
struct lock_class_key *k
 	__ring_buffer_alloc((size), (flags), &__key);	\
 })
=20
+#define RING_BUFFER_ALL_CPUS -1
+
 void ring_buffer_free(struct ring_buffer *buffer);
=20
-int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
+int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size, int=
 cpu);
=20
 void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val);
=20
@@ -129,7 +131,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts=
);
 void ring_buffer_iter_reset(struct ring_buffer_iter *iter);
 int ring_buffer_iter_empty(struct ring_buffer_iter *iter);
=20
-unsigned long ring_buffer_size(struct ring_buffer *buffer);
+unsigned long ring_buffer_size(struct ring_buffer *buffer, int cpu);
=20
 void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu);
 void ring_buffer_reset(struct ring_buffer *buffer);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index cf8d11e..2d5eb33 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -449,6 +449,7 @@ struct ring_buffer_per_cpu {
 	raw_spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
 	struct lock_class_key		lock_key;
+	unsigned int			nr_pages;
 	struct list_head		*pages;
 	struct buffer_page		*head_page;	/* read from head */
 	struct buffer_page		*tail_page;	/* write to tail */
@@ -466,10 +467,12 @@ struct ring_buffer_per_cpu {
 	unsigned long			read_bytes;
 	u64				write_stamp;
 	u64				read_stamp;
+	/* ring buffer pages to update, > 0 to add, < 0 to remove */
+	int				nr_pages_to_update;
+	struct list_head		new_pages; /* new pages to add */
 };
=20
 struct ring_buffer {
-	unsigned			pages;
 	unsigned			flags;
 	int				cpus;
 	atomic_t			record_disabled;
@@ -963,14 +966,10 @@ static int rb_check_pages(struct ring_buffer_per_cpu =
*cpu_buffer)
 	return 0;
 }
=20
-static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
-			     unsigned nr_pages)
+static int __rb_allocate_pages(int nr_pages, struct list_head *pages, int =
cpu)
 {
+	int i;
 	struct buffer_page *bpage, *tmp;
-	LIST_HEAD(pages);
-	unsigned i;
-
-	WARN_ON(!nr_pages);
=20
 	for (i =3D 0; i < nr_pages; i++) {
 		struct page *page;
@@ -981,15 +980,13 @@ static int rb_allocate_pages(struct ring_buffer_per_c=
pu *cpu_buffer,
 		 */
 		bpage =3D kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 				    GFP_KERNEL | __GFP_NORETRY,
-				    cpu_to_node(cpu_buffer->cpu));
+				    cpu_to_node(cpu));
 		if (!bpage)
 			goto free_pages;
=20
-		rb_check_bpage(cpu_buffer, bpage);
+		list_add(&bpage->list, pages);
=20
-		list_add(&bpage->list, &pages);
-
-		page =3D alloc_pages_node(cpu_to_node(cpu_buffer->cpu),
+		page =3D alloc_pages_node(cpu_to_node(cpu),
 					GFP_KERNEL | __GFP_NORETRY, 0);
 		if (!page)
 			goto free_pages;
@@ -997,6 +994,27 @@ static int rb_allocate_pages(struct ring_buffer_per_cp=
u *cpu_buffer,
 		rb_init_page(bpage->page);
 	}
=20
+	return 0;
+
+free_pages:
+	list_for_each_entry_safe(bpage, tmp, pages, list) {
+		list_del_init(&bpage->list);
+		free_buffer_page(bpage);
+	}
+
+	return -ENOMEM;
+}
+
+static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
+			     unsigned nr_pages)
+{
+	LIST_HEAD(pages);
+
+	WARN_ON(!nr_pages);
+
+	if (__rb_allocate_pages(nr_pages, &pages, cpu_buffer->cpu))
+		return -ENOMEM;
+
 	/*
 	 * The ring buffer page list is a circular list that does not
 	 * start and end with a list head. All page list items point to
@@ -1005,20 +1023,15 @@ static int rb_allocate_pages(struct ring_buffer_per=
_cpu *cpu_buffer,
 	cpu_buffer->pages =3D pages.next;
 	list_del(&pages);
=20
+	cpu_buffer->nr_pages =3D nr_pages;
+
 	rb_check_pages(cpu_buffer);
=20
 	return 0;
-
- free_pages:
-	list_for_each_entry_safe(bpage, tmp, &pages, list) {
-		list_del_init(&bpage->list);
-		free_buffer_page(bpage);
-	}
-	return -ENOMEM;
 }
=20
 static struct ring_buffer_per_cpu *
-rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
+rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
@@ -1052,7 +1065,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, in=
t cpu)
=20
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
=20
-	ret =3D rb_allocate_pages(cpu_buffer, buffer->pages);
+	ret =3D rb_allocate_pages(cpu_buffer, nr_pages);
 	if (ret < 0)
 		goto fail_free_reader;
=20
@@ -1113,7 +1126,7 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long=
 size, unsigned flags,
 {
 	struct ring_buffer *buffer;
 	int bsize;
-	int cpu;
+	int cpu, nr_pages;
=20
 	/* keep it in its own cache line */
 	buffer =3D kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
@@ -1124,14 +1137,14 @@ struct ring_buffer *__ring_buffer_alloc(unsigned lo=
ng size, unsigned flags,
 	if (!alloc_cpumask_var(&buffer->cpumask, GFP_KERNEL))
 		goto fail_free_buffer;
=20
-	buffer->pages =3D DIV_ROUND_UP(size, BUF_PAGE_SIZE);
+	nr_pages =3D DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	buffer->flags =3D flags;
 	buffer->clock =3D trace_clock_local;
 	buffer->reader_lock_key =3D key;
=20
 	/* need at least two pages */
-	if (buffer->pages < 2)
-		buffer->pages =3D 2;
+	if (nr_pages < 2)
+		nr_pages =3D 2;
=20
 	/*
 	 * In case of non-hotplug cpu, if the ring-buffer is allocated
@@ -1154,7 +1167,7 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long=
 size, unsigned flags,
=20
 	for_each_buffer_cpu(buffer, cpu) {
 		buffer->buffers[cpu] =3D
-			rb_allocate_cpu_buffer(buffer, cpu);
+			rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
 		if (!buffer->buffers[cpu])
 			goto fail_free_buffers;
 	}
@@ -1276,6 +1289,18 @@ out:
 	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
 }
=20
+static void update_pages_handler(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	if (cpu_buffer->nr_pages_to_update > 0)
+		rb_insert_pages(cpu_buffer, &cpu_buffer->new_pages,
+				cpu_buffer->nr_pages_to_update);
+	else
+		rb_remove_pages(cpu_buffer, -cpu_buffer->nr_pages_to_update);
+	cpu_buffer->nr_pages +=3D cpu_buffer->nr_pages_to_update;
+	/* reset this value */
+	cpu_buffer->nr_pages_to_update =3D 0;
+}
+
 /**
  * ring_buffer_resize - resize the ring buffer
  * @buffer: the buffer to resize.
@@ -1285,14 +1310,12 @@ out:
  *
  * Returns -1 on failure.
  */
-int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
+int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
+			int cpu_id)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	unsigned nr_pages, rm_pages, new_pages;
-	struct buffer_page *bpage, *tmp;
-	unsigned long buffer_size;
-	LIST_HEAD(pages);
-	int i, cpu;
+	unsigned nr_pages;
+	int cpu;
=20
 	/*
 	 * Always succeed at resizing a non-existent buffer:
@@ -1302,15 +1325,11 @@ int ring_buffer_resize(struct ring_buffer *buffer, =
unsigned long size)
=20
 	size =3D DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	size *=3D BUF_PAGE_SIZE;
-	buffer_size =3D buffer->pages * BUF_PAGE_SIZE;
=20
 	/* we need a minimum of two pages */
 	if (size < BUF_PAGE_SIZE * 2)
 		size =3D BUF_PAGE_SIZE * 2;
=20
-	if (size =3D=3D buffer_size)
-		return size;
-
 	atomic_inc(&buffer->record_disabled);
=20
 	/* Make sure all writers are done with this buffer. */
@@ -1321,68 +1340,56 @@ int ring_buffer_resize(struct ring_buffer *buffer, =
unsigned long size)
=20
 	nr_pages =3D DIV_ROUND_UP(size, BUF_PAGE_SIZE);
=20
-	if (size < buffer_size) {
-
-		/* easy case, just free pages */
-		if (RB_WARN_ON(buffer, nr_pages >=3D buffer->pages))
-			goto out_fail;
-
-		rm_pages =3D buffer->pages - nr_pages;
-
+	if (cpu_id =3D=3D RING_BUFFER_ALL_CPUS) {
+		/* calculate the pages to update */
 		for_each_buffer_cpu(buffer, cpu) {
 			cpu_buffer =3D buffer->buffers[cpu];
-			rb_remove_pages(cpu_buffer, rm_pages);
-		}
-		goto out;
-	}
=20
-	/*
-	 * This is a bit more difficult. We only want to add pages
-	 * when we can allocate enough for all CPUs. We do this
-	 * by allocating all the pages and storing them on a local
-	 * link list. If we succeed in our allocation, then we
-	 * add these pages to the cpu_buffers. Otherwise we just free
-	 * them all and return -ENOMEM;
-	 */
-	if (RB_WARN_ON(buffer, nr_pages <=3D buffer->pages))
-		goto out_fail;
+			cpu_buffer->nr_pages_to_update =3D nr_pages -
+							cpu_buffer->nr_pages;
=20
-	new_pages =3D nr_pages - buffer->pages;
+			/*
+			 * nothing more to do for removing pages or no update
+			 */
+			if (cpu_buffer->nr_pages_to_update <=3D 0)
+				continue;
=20
-	for_each_buffer_cpu(buffer, cpu) {
-		for (i =3D 0; i < new_pages; i++) {
-			struct page *page;
 			/*
-			 * __GFP_NORETRY flag makes sure that the allocation
-			 * fails gracefully without invoking oom-killer and
-			 * the system is not destabilized.
+			 * to add pages, make sure all new pages can be
+			 * allocated without receiving ENOMEM
 			 */
-			bpage =3D kzalloc_node(ALIGN(sizeof(*bpage),
-						  cache_line_size()),
-					    GFP_KERNEL | __GFP_NORETRY,
-					    cpu_to_node(cpu));
-			if (!bpage)
-				goto free_pages;
-			list_add(&bpage->list, &pages);
-			page =3D alloc_pages_node(cpu_to_node(cpu),
-						GFP_KERNEL | __GFP_NORETRY, 0);
-			if (!page)
-				goto free_pages;
-			bpage->page =3D page_address(page);
-			rb_init_page(bpage->page);
+			INIT_LIST_HEAD(&cpu_buffer->new_pages);
+			if (__rb_allocate_pages(cpu_buffer->nr_pages_to_update,
+						&cpu_buffer->new_pages, cpu))
+				/* not enough memory for new pages */
+				goto no_mem;
 		}
-	}
=20
-	for_each_buffer_cpu(buffer, cpu) {
-		cpu_buffer =3D buffer->buffers[cpu];
-		rb_insert_pages(cpu_buffer, &pages, new_pages);
-	}
+		/* wait for all the updates to complete */
+		for_each_buffer_cpu(buffer, cpu) {
+			cpu_buffer =3D buffer->buffers[cpu];
+			if (cpu_buffer->nr_pages_to_update) {
+				update_pages_handler(cpu_buffer);
+			}
+		}
+	} else {
+		cpu_buffer =3D buffer->buffers[cpu_id];
+		if (nr_pages =3D=3D cpu_buffer->nr_pages)
+			goto out;
=20
-	if (RB_WARN_ON(buffer, !list_empty(&pages)))
-		goto out_fail;
+		cpu_buffer->nr_pages_to_update =3D nr_pages -
+						cpu_buffer->nr_pages;
+
+		INIT_LIST_HEAD(&cpu_buffer->new_pages);
+		if (cpu_buffer->nr_pages_to_update > 0 &&
+			__rb_allocate_pages(cpu_buffer->nr_pages_to_update,
+						&cpu_buffer->new_pages, cpu_id))
+			goto no_mem;
+
+		update_pages_handler(cpu_buffer);
+	}
=20
  out:
-	buffer->pages =3D nr_pages;
 	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
=20
@@ -1390,25 +1397,24 @@ int ring_buffer_resize(struct ring_buffer *buffer, =
unsigned long size)
=20
 	return size;
=20
- free_pages:
-	list_for_each_entry_safe(bpage, tmp, &pages, list) {
-		list_del_init(&bpage->list);
-		free_buffer_page(bpage);
+ no_mem:
+	for_each_buffer_cpu(buffer, cpu) {
+		struct buffer_page *bpage, *tmp;
+		cpu_buffer =3D buffer->buffers[cpu];
+		/* reset this number regardless */
+		cpu_buffer->nr_pages_to_update =3D 0;
+		if (list_empty(&cpu_buffer->new_pages))
+			continue;
+		list_for_each_entry_safe(bpage, tmp, &cpu_buffer->new_pages,
+					list) {
+			list_del_init(&bpage->list);
+			free_buffer_page(bpage);
+		}
 	}
 	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
 	atomic_dec(&buffer->record_disabled);
 	return -ENOMEM;
-
-	/*
-	 * Something went totally wrong, and we are too paranoid
-	 * to even clean up the mess.
-	 */
- out_fail:
-	put_online_cpus();
-	mutex_unlock(&buffer->mutex);
-	atomic_dec(&buffer->record_disabled);
-	return -1;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
=20
@@ -1510,7 +1516,7 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cp=
u_buffer)
 	 * assign the commit to the tail.
 	 */
  again:
-	max_count =3D cpu_buffer->buffer->pages * 100;
+	max_count =3D cpu_buffer->nr_pages * 100;
=20
 	while (cpu_buffer->commit_page !=3D cpu_buffer->tail_page) {
 		if (RB_WARN_ON(cpu_buffer, !(--max_count)))
@@ -3588,9 +3594,18 @@ EXPORT_SYMBOL_GPL(ring_buffer_read);
  * ring_buffer_size - return the size of the ring buffer (in bytes)
  * @buffer: The ring buffer.
  */
-unsigned long ring_buffer_size(struct ring_buffer *buffer)
+unsigned long ring_buffer_size(struct ring_buffer *buffer, int cpu)
 {
-	return BUF_PAGE_SIZE * buffer->pages;
+	/*
+	 * Earlier, this method returned
+	 *	BUF_PAGE_SIZE * buffer->nr_pages
+	 * Since the nr_pages field is now removed, we have converted this to
+	 * return the per cpu buffer value.
+	 */
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	return BUF_PAGE_SIZE * buffer->buffers[cpu]->nr_pages;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_size);
=20
@@ -3765,8 +3780,11 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_=
a,
 	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
 		goto out;
=20
+	cpu_buffer_a =3D buffer_a->buffers[cpu];
+	cpu_buffer_b =3D buffer_b->buffers[cpu];
+
 	/* At least make sure the two buffers are somewhat the same */
-	if (buffer_a->pages !=3D buffer_b->pages)
+	if (cpu_buffer_a->nr_pages !=3D cpu_buffer_b->nr_pages)
 		goto out;
=20
 	ret =3D -EAGAIN;
@@ -3780,9 +3798,6 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	if (atomic_read(&buffer_b->record_disabled))
 		goto out;
=20
-	cpu_buffer_a =3D buffer_a->buffers[cpu];
-	cpu_buffer_b =3D buffer_b->buffers[cpu];
-
 	if (atomic_read(&cpu_buffer_a->record_disabled))
 		goto out;
=20
@@ -4071,6 +4086,8 @@ static int rb_cpu_notify(struct notifier_block *self,
 	struct ring_buffer *buffer =3D
 		container_of(self, struct ring_buffer, cpu_notify);
 	long cpu =3D (long)hcpu;
+	int cpu_i, nr_pages_same;
+	unsigned int nr_pages;
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
@@ -4078,8 +4095,23 @@ static int rb_cpu_notify(struct notifier_block *self,
 		if (cpumask_test_cpu(cpu, buffer->cpumask))
 			return NOTIFY_OK;
=20
+		nr_pages =3D 0;
+		nr_pages_same =3D 1;
+		/* check if all cpu sizes are same */
+		for_each_buffer_cpu(buffer, cpu_i) {
+			/* fill in the size from first enabled cpu */
+			if (nr_pages =3D=3D 0)
+				nr_pages =3D buffer->buffers[cpu_i]->nr_pages;
+			if (nr_pages !=3D buffer->buffers[cpu_i]->nr_pages) {
+				nr_pages_same =3D 0;
+				break;
+			}
+		}
+		/* allocate minimum pages, user can later expand it */
+		if (!nr_pages_same)
+			nr_pages =3D 2;
 		buffer->buffers[cpu] =3D
-			rb_allocate_cpu_buffer(buffer, cpu);
+			rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
 		if (!buffer->buffers[cpu]) {
 			WARN(1, "failed to allocate ring buffer on CPU %ld\n",
 			     cpu);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bbcde54..f11a285 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -838,7 +838,8 @@ __acquires(kernel_lock)
=20
 		/* If we expanded the buffers, make sure the max is expanded too */
 		if (ring_buffer_expanded && type->use_max_tr)
-			ring_buffer_resize(max_tr.buffer, trace_buf_size);
+			ring_buffer_resize(max_tr.buffer, trace_buf_size,
+						RING_BUFFER_ALL_CPUS);
=20
 		/* the test is responsible for initializing and enabling */
 		pr_info("Testing tracer %s: ", type->name);
@@ -854,7 +855,8 @@ __acquires(kernel_lock)
=20
 		/* Shrink the max buffer again */
 		if (ring_buffer_expanded && type->use_max_tr)
-			ring_buffer_resize(max_tr.buffer, 1);
+			ring_buffer_resize(max_tr.buffer, 1,
+						RING_BUFFER_ALL_CPUS);
=20
 		printk(KERN_CONT "PASSED\n");
 	}
@@ -3053,7 +3055,14 @@ int tracer_init(struct tracer *t, struct trace_array=
 *tr)
 	return t->init(tr);
 }
=20
-static int __tracing_resize_ring_buffer(unsigned long size)
+static void set_buffer_entries(struct trace_array *tr, unsigned long val)
+{
+	int cpu;
+	for_each_tracing_cpu(cpu)
+		tr->data[cpu]->entries =3D val;
+}
+
+static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
 {
 	int ret;
=20
@@ -3064,19 +3073,32 @@ static int __tracing_resize_ring_buffer(unsigned lo=
ng size)
 	 */
 	ring_buffer_expanded =3D 1;
=20
-	ret =3D ring_buffer_resize(global_trace.buffer, size);
+	ret =3D ring_buffer_resize(global_trace.buffer, size, cpu);
 	if (ret < 0)
 		return ret;
=20
 	if (!current_trace->use_max_tr)
 		goto out;
=20
-	ret =3D ring_buffer_resize(max_tr.buffer, size);
+	ret =3D ring_buffer_resize(max_tr.buffer, size, cpu);
 	if (ret < 0) {
-		int r;
+		int r =3D 0;
+
+		if (cpu =3D=3D RING_BUFFER_ALL_CPUS) {
+			int i;
+			for_each_tracing_cpu(i) {
+				r =3D ring_buffer_resize(global_trace.buffer,
+						global_trace.data[i]->entries,
+						i);
+				if (r < 0)
+					break;
+			}
+		} else {
+			r =3D ring_buffer_resize(global_trace.buffer,
+						global_trace.data[cpu]->entries,
+						cpu);
+		}
=20
-		r =3D ring_buffer_resize(global_trace.buffer,
-				       global_trace.entries);
 		if (r < 0) {
 			/*
 			 * AARGH! We are left with different
@@ -3098,14 +3120,21 @@ static int __tracing_resize_ring_buffer(unsigned lo=
ng size)
 		return ret;
 	}
=20
-	max_tr.entries =3D size;
+	if (cpu =3D=3D RING_BUFFER_ALL_CPUS)
+		set_buffer_entries(&max_tr, size);
+	else
+		max_tr.data[cpu]->entries =3D size;
+
  out:
-	global_trace.entries =3D size;
+	if (cpu =3D=3D RING_BUFFER_ALL_CPUS)
+		set_buffer_entries(&global_trace, size);
+	else
+		global_trace.data[cpu]->entries =3D size;
=20
 	return ret;
 }
=20
-static ssize_t tracing_resize_ring_buffer(unsigned long size)
+static ssize_t tracing_resize_ring_buffer(unsigned long size, int cpu_id)
 {
 	int cpu, ret =3D size;
=20
@@ -3121,12 +3150,19 @@ static ssize_t tracing_resize_ring_buffer(unsigned =
long size)
 			atomic_inc(&max_tr.data[cpu]->disabled);
 	}
=20
-	if (size !=3D global_trace.entries)
-		ret =3D __tracing_resize_ring_buffer(size);
+	if (cpu_id !=3D RING_BUFFER_ALL_CPUS) {
+		/* make sure, this cpu is enabled in the mask */
+		if (!cpumask_test_cpu(cpu_id, tracing_buffer_mask)) {
+			ret =3D -EINVAL;
+			goto out;
+		}
+	}
=20
+	ret =3D __tracing_resize_ring_buffer(size, cpu_id);
 	if (ret < 0)
 		ret =3D -ENOMEM;
=20
+out:
 	for_each_tracing_cpu(cpu) {
 		if (global_trace.data[cpu])
 			atomic_dec(&global_trace.data[cpu]->disabled);
@@ -3157,7 +3193,8 @@ int tracing_update_buffers(void)
=20
 	mutex_lock(&trace_types_lock);
 	if (!ring_buffer_expanded)
-		ret =3D __tracing_resize_ring_buffer(trace_buf_size);
+		ret =3D __tracing_resize_ring_buffer(trace_buf_size,
+						RING_BUFFER_ALL_CPUS);
 	mutex_unlock(&trace_types_lock);
=20
 	return ret;
@@ -3181,7 +3218,8 @@ static int tracing_set_tracer(const char *buf)
 	mutex_lock(&trace_types_lock);
=20
 	if (!ring_buffer_expanded) {
-		ret =3D __tracing_resize_ring_buffer(trace_buf_size);
+		ret =3D __tracing_resize_ring_buffer(trace_buf_size,
+						RING_BUFFER_ALL_CPUS);
 		if (ret < 0)
 			goto out;
 		ret =3D 0;
@@ -3207,8 +3245,8 @@ static int tracing_set_tracer(const char *buf)
 		 * The max_tr ring buffer has some state (e.g. ring->clock) and
 		 * we want preserve it.
 		 */
-		ring_buffer_resize(max_tr.buffer, 1);
-		max_tr.entries =3D 1;
+		ring_buffer_resize(max_tr.buffer, 1, RING_BUFFER_ALL_CPUS);
+		set_buffer_entries(&max_tr, 1);
 	}
 	destroy_trace_option_files(topts);
=20
@@ -3216,10 +3254,17 @@ static int tracing_set_tracer(const char *buf)
=20
 	topts =3D create_trace_option_files(current_trace);
 	if (current_trace->use_max_tr) {
-		ret =3D ring_buffer_resize(max_tr.buffer, global_trace.entries);
-		if (ret < 0)
-			goto out;
-		max_tr.entries =3D global_trace.entries;
+		int cpu;
+		/* we need to make per cpu buffer sizes equivalent */
+		for_each_tracing_cpu(cpu) {
+			ret =3D ring_buffer_resize(max_tr.buffer,
+						global_trace.data[cpu]->entries,
+						cpu);
+			if (ret < 0)
+				goto out;
+			max_tr.data[cpu]->entries =3D
+					global_trace.data[cpu]->entries;
+		}
 	}
=20
 	if (t->init) {
@@ -3721,30 +3766,82 @@ out_err:
 	goto out;
 }
=20
+struct ftrace_entries_info {
+	struct trace_array	*tr;
+	int			cpu;
+};
+
+static int tracing_entries_open(struct inode *inode, struct file *filp)
+{
+	struct ftrace_entries_info *info;
+
+	if (tracing_disabled)
+		return -ENODEV;
+
+	info =3D kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->tr =3D &global_trace;
+	info->cpu =3D (unsigned long)inode->i_private;
+
+	filp->private_data =3D info;
+
+	return 0;
+}
+
 static ssize_t
 tracing_entries_read(struct file *filp, char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
-	struct trace_array *tr =3D filp->private_data;
-	char buf[96];
-	int r;
+	struct ftrace_entries_info *info =3D filp->private_data;
+	struct trace_array *tr =3D info->tr;
+	char buf[64];
+	int r =3D 0;
+	ssize_t ret;
=20
 	mutex_lock(&trace_types_lock);
-	if (!ring_buffer_expanded)
-		r =3D sprintf(buf, "%lu (expanded: %lu)\n",
-			    tr->entries >> 10,
-			    trace_buf_size >> 10);
-	else
-		r =3D sprintf(buf, "%lu\n", tr->entries >> 10);
+
+	if (info->cpu =3D=3D RING_BUFFER_ALL_CPUS) {
+		int cpu, buf_size_same;
+		unsigned long size;
+
+		size =3D 0;
+		buf_size_same =3D 1;
+		/* check if all cpu sizes are same */
+		for_each_tracing_cpu(cpu) {
+			/* fill in the size from first enabled cpu */
+			if (size =3D=3D 0)
+				size =3D tr->data[cpu]->entries;
+			if (size !=3D tr->data[cpu]->entries) {
+				buf_size_same =3D 0;
+				break;
+			}
+		}
+
+		if (buf_size_same) {
+			if (!ring_buffer_expanded)
+				r =3D sprintf(buf, "%lu (expanded: %lu)\n",
+					    size >> 10,
+					    trace_buf_size >> 10);
+			else
+				r =3D sprintf(buf, "%lu\n", size >> 10);
+		} else
+			r =3D sprintf(buf, "X\n");
+	} else
+		r =3D sprintf(buf, "%lu\n", tr->data[info->cpu]->entries >> 10);
+
 	mutex_unlock(&trace_types_lock);
=20
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+	ret =3D simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+	return ret;
 }
=20
 static ssize_t
 tracing_entries_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
+	struct ftrace_entries_info *info =3D filp->private_data;
 	unsigned long val;
 	int ret;
=20
@@ -3759,7 +3856,7 @@ tracing_entries_write(struct file *filp, const char _=
_user *ubuf,
 	/* value is in KB */
 	val <<=3D 10;
=20
-	ret =3D tracing_resize_ring_buffer(val);
+	ret =3D tracing_resize_ring_buffer(val, info->cpu);
 	if (ret < 0)
 		return ret;
=20
@@ -3768,6 +3865,16 @@ tracing_entries_write(struct file *filp, const char =
__user *ubuf,
 	return cnt;
 }
=20
+static int
+tracing_entries_release(struct inode *inode, struct file *filp)
+{
+	struct ftrace_entries_info *info =3D filp->private_data;
+
+	kfree(info);
+
+	return 0;
+}
+
 static ssize_t
 tracing_total_entries_read(struct file *filp, char __user *ubuf,
 				size_t cnt, loff_t *ppos)
@@ -3779,7 +3886,7 @@ tracing_total_entries_read(struct file *filp, char __=
user *ubuf,
=20
 	mutex_lock(&trace_types_lock);
 	for_each_tracing_cpu(cpu) {
-		size +=3D tr->entries >> 10;
+		size +=3D tr->data[cpu]->entries >> 10;
 		if (!ring_buffer_expanded)
 			expanded_size +=3D trace_buf_size >> 10;
 	}
@@ -3813,7 +3920,7 @@ tracing_free_buffer_release(struct inode *inode, stru=
ct file *filp)
 	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
 		tracing_off();
 	/* resize the ring buffer to 0 */
-	tracing_resize_ring_buffer(0);
+	tracing_resize_ring_buffer(0, RING_BUFFER_ALL_CPUS);
=20
 	return 0;
 }
@@ -4012,9 +4119,10 @@ static const struct file_operations tracing_pipe_fop=
s =3D {
 };
=20
 static const struct file_operations tracing_entries_fops =3D {
-	.open		=3D tracing_open_generic,
+	.open		=3D tracing_entries_open,
 	.read		=3D tracing_entries_read,
 	.write		=3D tracing_entries_write,
+	.release	=3D tracing_entries_release,
 	.llseek		=3D generic_file_llseek,
 };
=20
@@ -4466,6 +4574,9 @@ static void tracing_init_debugfs_percpu(long cpu)
=20
 	trace_create_file("stats", 0444, d_cpu,
 			(void *) cpu, &tracing_stats_fops);
+
+	trace_create_file("buffer_size_kb", 0444, d_cpu,
+			(void *) cpu, &tracing_entries_fops);
 }
=20
 #ifdef CONFIG_FTRACE_SELFTEST
@@ -4795,7 +4906,7 @@ static __init int tracer_init_debugfs(void)
 			(void *) TRACE_PIPE_ALL_CPU, &tracing_pipe_fops);
=20
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
-			&global_trace, &tracing_entries_fops);
+			(void *) RING_BUFFER_ALL_CPUS, &tracing_entries_fops);
=20
 	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
 			&global_trace, &tracing_total_entries_fops);
@@ -5056,7 +5167,6 @@ __init static int tracer_alloc_buffers(void)
 		WARN_ON(1);
 		goto out_free_cpumask;
 	}
-	global_trace.entries =3D ring_buffer_size(global_trace.buffer);
 	if (global_trace.buffer_disabled)
 		tracing_off();
=20
@@ -5069,7 +5179,6 @@ __init static int tracer_alloc_buffers(void)
 		ring_buffer_free(global_trace.buffer);
 		goto out_free_cpumask;
 	}
-	max_tr.entries =3D 1;
 #endif
=20
 	/* Allocate the first page for all buffers */
@@ -5078,6 +5187,11 @@ __init static int tracer_alloc_buffers(void)
 		max_tr.data[i] =3D &per_cpu(max_tr_data, i);
 	}
=20
+	set_buffer_entries(&global_trace, ring_buf_size);
+#ifdef CONFIG_TRACER_MAX_TRACE
+	set_buffer_entries(&max_tr, 1);
+#endif
+
 	trace_init_cmdlines();
=20
 	register_tracer(&nop_trace);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f9d8550..1c8b7c6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -131,6 +131,7 @@ struct trace_array_cpu {
 	atomic_t		disabled;
 	void			*buffer_page;	/* ring buffer spare */
=20
+	unsigned long		entries;
 	unsigned long		saved_latency;
 	unsigned long		critical_start;
 	unsigned long		critical_end;
@@ -152,7 +153,6 @@ struct trace_array_cpu {
  */
 struct trace_array {
 	struct ring_buffer	*buffer;
-	unsigned long		entries;
 	int			cpu;
 	int			buffer_disabled;
 	cycle_t			time_start;
--=20
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmEc6AAoJEIy3vGnGbaoAtYUQAOwxRYaGPbZN/bQDPhj38Rf5
1ESqlohyegc6Yz9a6zHxZAr4q1ljgn4egvAxFqou2JY+gvkfMtZYUJbEaSowZiWg
8x5iqwpk3iEJpLDU0tHiGkmfma7E1KOrG6QMBxrw8XrAw4zsmfcPGLIwWXci0+JX
cSNxUXD7slB+t0miAwAUtd0ttBuB4JGmsJYiB/v8jZ4WwqVIO15jbmM/P37dQgD5
RCIIRl7yiQronpj2NoJpSGcLrHClAOT3wiTNZ9h6fV9jXSFxyv/TvNMUXT2OR4qq
wuflz3NrzF9MtXl/oSHO1CdXZBpILS8OQliW/ngxmjxEqgysyyamkQ8t3WCqx/fd
Rnr0fOWAy7eRZr1m3bXWsS3cTznDfMMP1sHkhpWOJC6AN375c1U7FKpufA5UaALO
gt5Rejszhels2MlaFcyCoFHPoG1Z6BHFeG5uiTAL0xC3OqutEFABoDfEvCJC1TiL
3pDMc8UoEGY8jLohBGyUerPF1KJrnKexmZBPVFJMo3StwtBABFuvsFN8/fANv77F
WwbzGJiHcjN3urOmHWxng+YyEFSa6WwxYvWSCkDGspGwQCuFsxqv99TC9FgGyPjS
bSeiHGicvru7SqiOjla1mk4Z4A/hXI3cYT45/PHPBAmNvSOGtAc/WypX1F+dDeNx
0b0+kwJsb5rGktKgmFiK
=8FZi
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
