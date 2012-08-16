Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab2HPRp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:45:59 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52300 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668Ab2HPRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:45:33 -0400
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH -v2 3/4] perf: Add persistent event facilities
Date: Thu, 16 Aug 2012 19:45:22 +0200
Message-Id: <1345139123-15212-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1345139123-15212-1-git-send-email-bp@amd64.org>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a barebones implementation for registering persistent events with
perf. For that, we don't destroy the buffers when they're unmapped;
also, we map them read-only so that multiple agents can access them.

Also, we allocate event buffer at event allocation time and not at mmap
time so that we can log samples into it regardless of whether there are
readers in userspace.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/perf_event.h |   7 +++
 kernel/events/Makefile     |   2 +-
 kernel/events/core.c       |  13 ++---
 kernel/events/internal.h   |   2 +
 kernel/events/persistent.c | 129 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 146 insertions(+), 7 deletions(-)
 create mode 100644 kernel/events/persistent.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 252aab74e64d..95073ac4186f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1312,6 +1312,10 @@ extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
+extern struct perf_event *perf_add_persistent_on_cpu(unsigned int,
+						     struct perf_event_desc *,
+						     unsigned nr_pages);
+extern void perf_rm_persistent_event(struct perf_event_desc *desc);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
@@ -1350,6 +1354,9 @@ static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
+static inline struct perf_event *perf_add_persistent_on_cpu
+(unsigned int cpu, struct perf_event_desc *desc, unsigned nr_pages)	{ return NULL; }
+static inline void perf_rm_persistent_event(struct perf_event_desc *)	{ }
 #endif
 
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d147b2f..70990d5a2037 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,7 +2,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y := core.o ring_buffer.o callchain.o
+obj-y := core.o ring_buffer.o callchain.o persistent.o
 
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_UPROBES) += uprobes.o
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 95026f2b3d55..e59579d442ca 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2854,8 +2854,6 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
-
 static void free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending);
@@ -3225,8 +3223,6 @@ unlock:
 	return ret;
 }
 
-static const struct file_operations perf_fops;
-
 static struct perf_event *perf_fget_light(int fd, int *fput_needed)
 {
 	struct file *file;
@@ -3517,7 +3513,7 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-static void ring_buffer_put(struct ring_buffer *rb)
+void ring_buffer_put(struct ring_buffer *rb)
 {
 	struct perf_event *event, *n;
 	unsigned long flags;
@@ -3546,6 +3542,11 @@ static void perf_mmap_close(struct vm_area_struct *vma)
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
@@ -3694,7 +3695,7 @@ static int perf_fasync(int fd, struct file *filp, int on)
 	return 0;
 }
 
-static const struct file_operations perf_fops = {
+const struct file_operations perf_fops = {
 	.llseek			= no_llseek,
 	.release		= perf_release,
 	.read			= perf_read,
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index a096c19f2c2a..a13834f26d93 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -37,6 +37,7 @@ struct ring_buffer {
 extern void rb_free(struct ring_buffer *rb);
 extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
+extern void ring_buffer_put(struct ring_buffer *rb);
 extern void perf_event_wakeup(struct perf_event *event);
 
 extern void
@@ -134,4 +135,5 @@ static inline void put_recursion_context(int *recursion, int rctx)
 	recursion[rctx]--;
 }
 
+extern const struct file_operations perf_fops;
 #endif /* _KERNEL_EVENTS_INTERNAL_H */
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
new file mode 100644
index 000000000000..33d45396dc02
--- /dev/null
+++ b/kernel/events/persistent.c
@@ -0,0 +1,129 @@
+#include <linux/slab.h>
+#include <linux/file.h>
+#include <linux/debugfs.h>
+#include <linux/perf_event.h>
+#include <linux/anon_inodes.h>
+#include <linux/ftrace_event.h>
+
+#include "../trace/trace.h"
+#include "internal.h"
+
+#include <asm/mce.h>
+
+static int pers_open_generic(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t
+pers_event_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct perf_event_desc *d = filp->private_data;
+	struct trace_seq *s;
+	int r;
+
+	if (*ppos)
+		return 0;
+
+	s = kzalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+	trace_seq_printf(s, "%d\n", d->fd);
+
+	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	kfree(s);
+	return r;
+}
+
+static const struct file_operations persistent_fops = {
+	.open = pers_open_generic,
+	.read = pers_event_read,
+	.llseek = default_llseek,
+};
+
+/*
+ * Create and enable the persistent version of the perf event described by
+ * @desc->pattr.
+ *
+ * Returns the @event pointer which receives the allocated event from
+ * perf on success. Make sure to check return code before touching @event
+ * any further.
+ *
+ * @cpu: on which cpu
+ * @desc: perf event descriptor
+ * @nr_pages: size in pages
+ */
+struct perf_event
+*perf_add_persistent_on_cpu(unsigned int cpu, struct perf_event_desc *desc,
+			    unsigned nr_pages)
+{
+	struct perf_event *event = ERR_PTR(-EINVAL);
+	struct file *event_file = NULL;
+	struct ring_buffer *buf;
+	struct dentry *dentry;
+	int event_fd;
+
+	event_fd = get_unused_fd_flags(O_RDWR);
+	if (event_fd < 0)
+		return NULL;
+
+	dentry = trace_add_file(desc->dir_name, desc->fname, 0444,
+				desc, &persistent_fops);
+	if (!dentry) {
+		pr_err("Error adding trace file %s\n", desc->fname);
+		goto err_trace_file;
+	}
+
+	desc->dentry = dentry;
+
+	event_file = anon_inode_getfile("[pers_event]", &perf_fops, event, O_RDWR);
+	if (IS_ERR(event_file))
+		goto err_inode;
+
+	event = perf_event_create_kernel_counter(desc->pattr, cpu, NULL, NULL, NULL);
+	if (IS_ERR(event))
+		goto err_inode;
+
+	buf = rb_alloc(nr_pages, 0, cpu, RING_BUFFER_WRITABLE);
+	if (!buf)
+		goto err_counter;
+
+	rcu_assign_pointer(event->rb, buf);
+	fd_install(event_fd, event_file);
+	event->filp = event_file;
+	desc->fd = event_fd;
+
+	perf_event_enable(event);
+
+	return event;
+
+ err_counter:
+	perf_event_release_kernel(event);
+
+ err_inode:
+	trace_remove_file(desc->dentry);
+
+ err_trace_file:
+	put_unused_fd(event_fd);
+	return event;
+}
+
+void perf_rm_persistent_event(struct perf_event_desc *desc)
+{
+	struct perf_event *event = desc->event;
+
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
-- 
1.7.11.rc1

