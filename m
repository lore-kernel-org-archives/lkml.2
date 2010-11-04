Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab0KDPio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:38:44 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41877 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0KDPin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:38:43 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 02/20] perf: Add persistent event facilities
Date: Thu,  4 Nov 2010 16:36:38 +0100
Message-Id: <1288885016-18295-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add barebones implementation for registering persistent events with
perf.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/perf_event.h |   20 +++++++++++++++
 kernel/events/Makefile     |    2 +-
 kernel/events/core.c       |   19 +++++++++++---
 kernel/events/persistent.c |   59 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 95 insertions(+), 5 deletions(-)
 create mode 100644 kernel/events/persistent.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 716f99b..e3e16d5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1019,6 +1019,15 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+extern struct perf_buffer *
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags);
+extern void perf_buffer_put(struct perf_buffer *buffer);
+extern int perf_enable_persistent_event(struct perf_event **event,
+					struct perf_event_attr *attr,
+					int cpu, unsigned bufsz);
+extern void perf_disable_persistent_event(struct perf_event *event, int cpu);
+extern int perf_persistent_open(struct inode *inode, struct file *file);
+extern const struct file_operations perf_pers_fops;
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1056,6 +1065,17 @@ static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
+static inline struct perf_buffer *
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)	{ return NULL; }
+static inline void perf_buffer_put(struct perf_buffer *buffer)		{}
+static inline int
+perf_enable_persistent_event(struct perf_event **event,
+			     struct perf_event_attr *attr, int cpu,
+			     unsigned bufsz)				{ return -EINVAL; }
+static inline void
+perf_disable_persistent_event(struct perf_event *event, int cpu)	{}
+static inline int
+perf_persistent_open(struct inode *inode, struct file *file)		{ return -1; }
 #endif
 
 #define perf_output_put(handle, x) \
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 5445cbf..6ef034a 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,4 +2,4 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_perf_event.o = -pg
 endif
 
-obj-y += core.o
+obj-y += core.o persistent.o
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b98bed3..8d2cfd3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1899,7 +1899,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void perf_pending_sync(struct perf_event *event);
-static void perf_buffer_put(struct perf_buffer *buffer);
+void perf_buffer_put(struct perf_buffer *buffer);
 
 static void free_event(struct perf_event *event)
 {
@@ -2440,7 +2440,7 @@ static void *perf_mmap_alloc_page(int cpu)
 	return page_address(page);
 }
 
-static struct perf_buffer *
+struct perf_buffer *
 perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
@@ -2557,7 +2557,7 @@ static void perf_buffer_free(struct perf_buffer *buffer)
 	schedule_work(&buffer->work);
 }
 
-static struct perf_buffer *
+struct perf_buffer *
 perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
@@ -2658,7 +2658,7 @@ static struct perf_buffer *perf_buffer_get(struct perf_event *event)
 	return buffer;
 }
 
-static void perf_buffer_put(struct perf_buffer *buffer)
+void perf_buffer_put(struct perf_buffer *buffer)
 {
 	if (!atomic_dec_and_test(&buffer->refcount))
 		return;
@@ -2828,6 +2828,17 @@ static const struct file_operations perf_fops = {
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
+	.release	= perf_release,
+};
+
 /*
  * Perf event wakeup
  *
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
new file mode 100644
index 0000000..f7d27a2
--- /dev/null
+++ b/kernel/events/persistent.c
@@ -0,0 +1,59 @@
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
+int perf_enable_persistent_event(struct perf_event **event,
+				 struct perf_event_attr *attr, int cpu,
+				 unsigned nr_pages)
+{
+	struct perf_buffer *buffer;
+	struct perf_event *ev;
+
+	ev = perf_event_create_kernel_counter(attr, cpu, -1, NULL);
+	if (IS_ERR(ev))
+		return -EINVAL;
+
+	buffer = perf_buffer_alloc(nr_pages, 0, cpu, 0);
+	if (IS_ERR(buffer))
+		goto err;
+
+	rcu_assign_pointer(ev->buffer, buffer);
+	perf_event_enable(ev);
+	*event = ev;
+
+	return 0;
+
+err:
+	perf_event_release_kernel(ev);
+	return -EINVAL;
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
+;
-- 
1.7.3.1

