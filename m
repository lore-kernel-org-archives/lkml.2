Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab1DWQ3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:29:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35049 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab1DWQ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:29:08 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 02/18] perf: Add persistent event facilities
Date: Sat, 23 Apr 2011 18:28:04 +0200
Message-Id: <1303576100-425-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a barebones implementation for registering persistent events with
perf. For that, we don't destroy the buffers when they're unmapped and
we map them read-only so that multiple agents can access them.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/perf_event.h |   22 ++++++++++++++++-
 kernel/events/Makefile     |    2 +-
 kernel/events/core.c       |   30 ++++++++++++++++++----
 kernel/events/persistent.c |   56 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+), 8 deletions(-)
 create mode 100644 kernel/events/persistent.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ee9f1e7..37bfae1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -216,8 +216,9 @@ struct perf_event_attr {
 				precise_ip     :  2, /* skid constraint       */
 				mmap_data      :  1, /* non-exec mmap data    */
 				sample_id_all  :  1, /* sample_type all events */
+				persistent     :  1, /* event always on */
 
-				__reserved_1   : 45;
+				__reserved_1   : 44;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -1159,6 +1160,15 @@ extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
+extern struct perf_buffer *
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags);
+extern void perf_buffer_put(struct perf_buffer *buffer);
+extern struct perf_event *
+perf_enable_persistent_event(struct perf_event_attr *attr,
+			     int cpu, unsigned bufsz);
+extern void perf_disable_persistent_event(struct perf_event *event, int cpu);
+extern int perf_persistent_open(struct inode *inode, struct file *file);
+extern const struct file_operations perf_pers_fops;
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1193,6 +1203,16 @@ static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
+static inline struct perf_buffer *
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)	{ return NULL; }
+static inline void perf_buffer_put(struct perf_buffer *buffer)		{}
+static inline struct perf_event *
+perf_enable_persistent_event(struct perf_event_attr *attr, int cpu,
+			     unsigned bufsz)				{ return -EINVAL; }
+static inline void
+perf_disable_persistent_event(struct perf_event *event, int cpu)	{}
+static inline int
+perf_persistent_open(struct inode *inode, struct file *file)		{ return -1; }
 #endif
 
 #define perf_output_put(handle, x) \
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 26c00e4..e2d4d8e 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,4 +2,4 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y += core.o
+obj-y += core.o persistent.o
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 8e81a98..4a0c398 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2898,7 +2898,7 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void perf_buffer_put(struct perf_buffer *buffer);
+void perf_buffer_put(struct perf_buffer *buffer);
 
 static void free_event(struct perf_event *event)
 {
@@ -3458,7 +3458,7 @@ static void *perf_mmap_alloc_page(int cpu)
 	return page_address(page);
 }
 
-static struct perf_buffer *
+struct perf_buffer *
 perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
@@ -3575,7 +3575,7 @@ static void perf_buffer_free(struct perf_buffer *buffer)
 	schedule_work(&buffer->work);
 }
 
-static struct perf_buffer *
+struct perf_buffer *
 perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
@@ -3676,7 +3676,7 @@ static struct perf_buffer *perf_buffer_get(struct perf_event *event)
 	return buffer;
 }
 
-static void perf_buffer_put(struct perf_buffer *buffer)
+void perf_buffer_put(struct perf_buffer *buffer)
 {
 	if (!atomic_dec_and_test(&buffer->refcount))
 		return;
@@ -3695,6 +3695,11 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
+	if (event->attr.persistent) {
+		atomic_dec(&event->mmap_count);
+		return;
+	}
+
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
 		unsigned long size = perf_data_size(event->buffer);
 		struct user_struct *user = event->mmap_user;
@@ -3737,7 +3742,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (event->cpu == -1 && event->attr.inherit)
 		return -EINVAL;
 
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!(vma->vm_flags & VM_SHARED) && !event->attr.persistent)
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
@@ -3846,6 +3851,16 @@ static const struct file_operations perf_fops = {
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
@@ -6702,7 +6717,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	mutex_unlock(&ctx->mutex);
 
 	return event;
-
 err_free:
 	free_event(event);
 err:
@@ -6756,6 +6770,10 @@ __perf_event_exit_task(struct perf_event *child_event,
 		raw_spin_unlock_irq(&child_ctx->lock);
 	}
 
+	/* do not remove persistent events on task exit */
+	if (child_event->attr.persistent)
+		return;
+
 	perf_remove_from_context(child_event);
 
 	/*
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
new file mode 100644
index 0000000..495ff87
--- /dev/null
+++ b/kernel/events/persistent.c
@@ -0,0 +1,56 @@
+#include <linux/perf_event.h>
+
+/*
+ * Pass in the @event pointer which receives the allocated event from
+ * perf on success. Check return code before touching @event further.
+ *
+ * @attr: perf attr template
+ * @cpu: on which cpu
+ * @nr_pages: perf buffer size in pages
+ *
+ */
+struct perf_event *perf_enable_persistent_event(struct perf_event_attr *attr,
+						int cpu, unsigned nr_pages)
+{
+	struct perf_buffer *buffer;
+	struct perf_event *ev;
+
+	ev = perf_event_create_kernel_counter(attr, cpu, NULL, NULL);
+	if (IS_ERR(ev))
+		return ev;
+
+	buffer = perf_buffer_alloc(nr_pages, 0, cpu, PERF_BUFFER_WRITABLE);
+	if (IS_ERR(buffer))
+		goto err;
+
+	rcu_assign_pointer(ev->buffer, buffer);
+	perf_event_enable(ev);
+
+	return ev;
+
+err:
+	perf_event_release_kernel(ev);
+	return ERR_PTR(-EINVAL);
+}
+
+void perf_disable_persistent_event(struct perf_event *event, int cpu)
+{
+	if (!event)
+		return;
+
+	perf_event_disable(event);
+
+	if (event->buffer) {
+		perf_buffer_put(event->buffer);
+		rcu_assign_pointer(event->buffer, NULL);
+	}
+
+	perf_event_release_kernel(event);
+}
+
+int perf_persistent_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+
+	return 0;
+}
-- 
1.7.4.rc2

