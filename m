Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697Ab0HFOeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:34:17 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41748 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab0HFOeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:34:12 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 3/9] perf_events: Export an assortment of functions
Date: Fri,  6 Aug 2010 16:25:07 +0200
Message-Id: <1281104713-23141-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281104713-23141-1-git-send-email-bp@amd64.org>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... for other in-kernel users.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/perf_event.h |   19 +++++++++++++++++++
 kernel/perf_event.c        |   19 +++++++++----------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 937495c..ea2b91c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -14,6 +14,7 @@
 #ifndef _LINUX_PERF_EVENT_H
 #define _LINUX_PERF_EVENT_H
 
+#include <linux/poll.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <asm/byteorder.h>
@@ -1019,6 +1020,15 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+extern struct perf_buffer *
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags);
+extern void perf_buffer_put(struct perf_buffer *buffer);
+extern unsigned int perf_poll(struct file *file, poll_table *wait);
+extern long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+extern int perf_mmap(struct file *file, struct vm_area_struct *vma);
+extern int perf_fasync(int fd, struct file *filp, int on);
+extern int perf_release(struct inode *inode, struct file *file);
+
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1056,6 +1066,15 @@ static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
+extern struct perf_buffer *
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)	{ return NULL; }
+static inline void perf_buffer_put(struct perf_buffer *buffer)		{}
+static inline unsigned int perf_poll(struct file *file, poll_table *wait) { return 0; }
+static inline long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg) { return -ENOTTY; }
+static inline int perf_mmap(struct file *file, struct vm_area_struct *vma) { return -EINVAL; }
+static inline int perf_fasync(int fd, struct file *filp, int on) { return 0; }
+static inline int perf_release(struct inode *inode, struct file *file) { return -EINVAL; }
+
 #endif
 
 #define perf_output_put(handle, x) \
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c772a3d..8ff5292 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -14,7 +14,6 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/file.h>
-#include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
 #include <linux/sysfs.h>
@@ -1881,7 +1880,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void perf_pending_sync(struct perf_event *event);
-static void perf_buffer_put(struct perf_buffer *buffer);
+void perf_buffer_put(struct perf_buffer *buffer);
 
 static void free_event(struct perf_event *event)
 {
@@ -1953,7 +1952,7 @@ EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 /*
  * Called when the last reference to the file is gone.
  */
-static int perf_release(struct inode *inode, struct file *file)
+int perf_release(struct inode *inode, struct file *file)
 {
 	struct perf_event *event = file->private_data;
 
@@ -2121,7 +2120,7 @@ perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	return perf_read_hw(event, buf, count);
 }
 
-static unsigned int perf_poll(struct file *file, poll_table *wait)
+unsigned int perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_event *event = file->private_data;
 	struct perf_buffer *buffer;
@@ -2239,7 +2238,7 @@ static int perf_event_set_output(struct perf_event *event,
 				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
 
-static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct perf_event *event = file->private_data;
 	void (*func)(struct perf_event *);
@@ -2424,7 +2423,7 @@ static void *perf_mmap_alloc_page(int cpu)
 	return page_address(page);
 }
 
-static struct perf_buffer *
+struct perf_buffer *
 perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
@@ -2541,7 +2540,7 @@ static void perf_buffer_free(struct perf_buffer *buffer)
 	schedule_work(&buffer->work);
 }
 
-static struct perf_buffer *
+struct perf_buffer *
 perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
@@ -2642,7 +2641,7 @@ static struct perf_buffer *perf_buffer_get(struct perf_event *event)
 	return buffer;
 }
 
-static void perf_buffer_put(struct perf_buffer *buffer)
+void perf_buffer_put(struct perf_buffer *buffer)
 {
 	if (!atomic_dec_and_test(&buffer->refcount))
 		return;
@@ -2683,7 +2682,7 @@ static const struct vm_operations_struct perf_mmap_vmops = {
 	.page_mkwrite	= perf_mmap_fault,
 };
 
-static int perf_mmap(struct file *file, struct vm_area_struct *vma)
+int perf_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct perf_event *event = file->private_data;
 	unsigned long user_locked, user_lock_limit;
@@ -2785,7 +2784,7 @@ unlock:
 	return ret;
 }
 
-static int perf_fasync(int fd, struct file *filp, int on)
+int perf_fasync(int fd, struct file *filp, int on)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct perf_event *event = filp->private_data;
-- 
1.7.1

