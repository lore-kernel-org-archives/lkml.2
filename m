Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031263Ab2CUOfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:35:15 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42155 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030742Ab2CUOfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:35:01 -0400
From: Borislav Petkov <bp@amd64.org>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] perf: Add persistent event facilities
Date: Wed, 21 Mar 2012 15:34:55 +0100
Message-Id: <1332340496-21658-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1332340496-21658-1-git-send-email-bp@amd64.org>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a barebones implementation for registering persistent events with
perf. For that, we don't destroy the buffers when they're unmapped;
also, we map them read-only so that multiple agents can access them.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/perf_event.h |   24 ++++++++++-
 kernel/events/Makefile     |    2 +-
 kernel/events/core.c       |   25 +++++++++--
 kernel/events/internal.h   |    2 +
 kernel/events/persistent.c |   98 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 145 insertions(+), 6 deletions(-)
 create mode 100644 kernel/events/persistent.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index abb2776be1ba..9743ba46e12d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -223,8 +223,9 @@ struct perf_event_attr {
 
 				exclude_host   :  1, /* don't count in host   */
 				exclude_guest  :  1, /* don't count in guest  */
+				persistent     :  1, /* always-on event */
 
-				__reserved_1   : 43;
+				__reserved_1   : 42;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -944,6 +945,14 @@ struct perf_output_handle {
 	int				page;
 };
 
+/* Persistent events descriptor */
+struct pers_event_desc {
+	struct perf_event_attr *pattr;
+	struct perf_event *event;
+	const char *dfs_name;
+	struct dentry *dfs_entry;
+};
+
 #ifdef CONFIG_PERF_EVENTS
 
 extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
@@ -1149,6 +1158,11 @@ extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
+extern int perf_add_persistent_on_cpu(int cpu, struct pers_event_desc *desc,
+				      struct dentry *dfs_dr, unsigned nr_pages);
+extern void perf_rm_persistent_on_cpu(int cpu, struct pers_event_desc *desc);
+extern int perf_persistent_open(struct inode *inode, struct file *file);
+extern const struct file_operations perf_pers_fops;
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
@@ -1187,6 +1201,14 @@ static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
+extern int perf_add_persistent_on_cpu(int cpu, struct pers_event_desc *desc,
+					 struct perf_event_attr *pattr,
+					 struct dentry *dfs_dir,
+					 unsigned nr_pages);		{ return -EINVAL; }
+extern void perf_rm_persistent_on_cpu(int cpu,
+				      struct pers_event_desc *desc)	{ }
+static inline int
+perf_persistent_open(struct inode *inode, struct file *file)		{ return -1; }
 #endif
 
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 22d901f9caf4..0d2267fb4336 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,5 +2,5 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y := core.o ring_buffer.o callchain.o
+obj-y := core.o ring_buffer.o callchain.o persistent.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1b5c081d8b9f..9a39dc6755f4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2770,8 +2770,6 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
-
 static void free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending);
@@ -3423,7 +3421,7 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-static void ring_buffer_put(struct ring_buffer *rb)
+void ring_buffer_put(struct ring_buffer *rb)
 {
 	struct perf_event *event, *n;
 	unsigned long flags;
@@ -3452,6 +3450,11 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
+	if (event->attr.persistent) {
+		atomic_dec(&event->mmap_count);
+		return;
+	}
+
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
 		unsigned long size = perf_data_size(event->rb);
 		struct user_struct *user = event->mmap_user;
@@ -3495,7 +3498,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (event->cpu == -1 && event->attr.inherit)
 		return -EINVAL;
 
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!(vma->vm_flags & VM_SHARED) && !event->attr.persistent)
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
@@ -3606,6 +3609,16 @@ static const struct file_operations perf_fops = {
 	.fasync			= perf_fasync,
 };
 
+const struct file_operations perf_pers_fops = {
+	.llseek		= no_llseek,
+	.open		= perf_persistent_open,
+	.poll		= perf_poll,
+	.unlocked_ioctl	= perf_ioctl,
+	.compat_ioctl	= perf_ioctl,
+	.mmap		= perf_mmap,
+	.fasync		= perf_fasync,
+};
+
 /*
  * Perf event wakeup
  *
@@ -6319,6 +6332,10 @@ __perf_event_exit_task(struct perf_event *child_event,
 		raw_spin_unlock_irq(&child_ctx->lock);
 	}
 
+	/* do not remove persistent events on task exit */
+	if (child_event->attr.persistent)
+		return;
+
 	perf_remove_from_context(child_event);
 
 	/*
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index b0b107f90afc..d4e6181d5faf 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -37,6 +37,8 @@ struct ring_buffer {
 extern void rb_free(struct ring_buffer *rb);
 extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
+extern void ring_buffer_put(struct ring_buffer *rb);
+
 extern void perf_event_wakeup(struct perf_event *event);
 
 extern void
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
new file mode 100644
index 000000000000..e6f146532e34
--- /dev/null
+++ b/kernel/events/persistent.c
@@ -0,0 +1,98 @@
+#include <linux/debugfs.h>
+#include <linux/perf_event.h>
+
+#include "internal.h"
+
+/*
+ * Create and enable the perf event described by @attr.
+ *
+ * Returns the @event pointer which receives the allocated event from
+ * perf on success. Make sure to check return code before touching @event
+ * any further.
+ *
+ * @attr: perf attr template
+ * @cpu: on which cpu
+ * @nr_pages: perf buffer size in pages
+ *
+ */
+static struct perf_event *perf_add_persistent(struct perf_event_attr *attr,
+					      int cpu, unsigned nr_pages)
+{
+	struct ring_buffer *buffer;
+	struct perf_event *event;
+
+	event = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
+	if (IS_ERR(event))
+		return event;
+
+	buffer = rb_alloc(nr_pages, 0, cpu, RING_BUFFER_WRITABLE);
+	if (!buffer)
+		goto err;
+
+	rcu_assign_pointer(event->rb, buffer);
+	perf_event_enable(event);
+
+	return event;
+
+err:
+	perf_event_release_kernel(event);
+	return ERR_PTR(-EINVAL);
+}
+
+static void perf_rm_persistent(struct perf_event *event, int cpu)
+{
+	if (!event)
+		return;
+
+	perf_event_disable(event);
+
+	if (event->rb) {
+		ring_buffer_put(event->rb);
+		rcu_assign_pointer(event->rb, NULL);
+	}
+
+	perf_event_release_kernel(event);
+}
+
+static struct dentry *perf_add_debugfs_entry(struct pers_event_desc *d,
+					     struct dentry *dir)
+{
+	return debugfs_create_file(d->dfs_name, S_IRUGO | S_IWUSR,
+				   dir, d->event, &perf_pers_fops);
+}
+
+int perf_add_persistent_on_cpu(int cpu, struct pers_event_desc *desc,
+			       struct dentry *dir, unsigned nr_pages)
+{
+	int err = -EINVAL;
+
+	desc->event = perf_add_persistent(desc->pattr, cpu, nr_pages);
+	if (IS_ERR(desc->event)) {
+		printk(KERN_ERR "Error enabling persistent event on cpu %d\n", cpu);
+		return err;
+	}
+
+	desc->dfs_entry = perf_add_debugfs_entry(desc, dir);
+	if (!desc->dfs_entry) {
+		printk(KERN_ERR "Error adding debugfs entry on cpu %d\n", cpu);
+		goto disable;
+	}
+	return 0;
+
+disable:
+	perf_rm_persistent(desc->event, cpu);
+	return err;
+}
+
+void perf_rm_persistent_on_cpu(int cpu, struct pers_event_desc *desc)
+{
+	debugfs_remove(desc->dfs_entry);
+	perf_rm_persistent(desc->event, cpu);
+}
+
+int perf_persistent_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+
+	return 0;
+}
-- 
1.7.9.3.362.g71319

