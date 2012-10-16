Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab2JPWbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:31:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39124 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab2JPWaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:30:25 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: gregkh@linuxfoundation.org
Cc: xiaobing.tu@intel.com, ccross@android.com, davej@redhat.com,
        akpm@linux-foundation.org, mingo@elte.hu, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, di.zhang@intel.com, xindong.ma@intel.com,
        alex.zuo@intel.com,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 2/4] Staging: android: binder: Add some tracepoints
Date: Tue, 16 Oct 2012 15:29:53 -0700
Message-Id: <1350426595-18059-2-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1350426595-18059-1-git-send-email-arve@android.com>
References: <20121016071101.GA5172@kroah.com>
 <1350426595-18059-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracepoints:
- ioctl entry and exit
- Main binder lock: lock, locked and unlock
- Command and return buffer opcodes
- Transaction: create and receive
- Transaction buffer: create and free
- Object and file descriptor transfer
- binder_update_page_range

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/Makefile       |    2 +
 drivers/staging/android/binder.c       |   91 +++++++--
 drivers/staging/android/binder_trace.h |  327 ++++++++++++++++++++++++++++++++
 3 files changed, 400 insertions(+), 20 deletions(-)
 create mode 100644 drivers/staging/android/binder_trace.h

diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index e16fcd5..b35a631 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -1,3 +1,5 @@
+ccflags-y += -I$(src)			# needed for trace events
+
 obj-$(CONFIG_ANDROID_BINDER_IPC)	+= binder.o
 obj-$(CONFIG_ASHMEM)			+= ashmem.o
 obj-$(CONFIG_ANDROID_LOGGER)		+= logger.o
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 9e852d0..b7cfcdb 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -35,8 +35,9 @@
 #include <linux/slab.h>
 
 #include "binder.h"
+#include "binder_trace.h"
 
-static DEFINE_MUTEX(binder_lock);
+static DEFINE_MUTEX(binder_main_lock);
 static DEFINE_MUTEX(binder_deferred_lock);
 static DEFINE_MUTEX(binder_mmap_lock);
 
@@ -411,6 +412,19 @@ static long task_close_fd(struct binder_proc *proc, unsigned int fd)
 	return retval;
 }
 
+static inline void binder_lock(const char *tag)
+{
+	trace_binder_lock(tag);
+	mutex_lock(&binder_main_lock);
+	trace_binder_locked(tag);
+}
+
+static inline void binder_unlock(const char *tag)
+{
+	trace_binder_unlock(tag);
+	mutex_unlock(&binder_main_lock);
+}
+
 static void binder_set_nice(long nice)
 {
 	long min_nice;
@@ -537,6 +551,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 	if (end <= start)
 		return 0;
 
+	trace_binder_update_page_range(proc, allocate, start, end);
+
 	if (vma)
 		mm = NULL;
 	else
@@ -1461,6 +1477,9 @@ static void binder_transaction(struct binder_proc *proc,
 	t->code = tr->code;
 	t->flags = tr->flags;
 	t->priority = task_nice(current);
+
+	trace_binder_transaction(reply, t, target_node);
+
 	t->buffer = binder_alloc_buf(target_proc, tr->data_size,
 		tr->offsets_size, !reply && (t->flags & TF_ONE_WAY));
 	if (t->buffer == NULL) {
@@ -1471,6 +1490,7 @@ static void binder_transaction(struct binder_proc *proc,
 	t->buffer->debug_id = t->debug_id;
 	t->buffer->transaction = t;
 	t->buffer->target_node = target_node;
+	trace_binder_transaction_alloc_buf(t->buffer);
 	if (target_node)
 		binder_inc_node(target_node, 1, 0, NULL);
 
@@ -1543,6 +1563,7 @@ static void binder_transaction(struct binder_proc *proc,
 			binder_inc_ref(ref, fp->type == BINDER_TYPE_HANDLE,
 				       &thread->todo);
 
+			trace_binder_transaction_node_to_ref(t, node, ref);
 			binder_debug(BINDER_DEBUG_TRANSACTION,
 				     "        node %d u%p -> ref %d desc %d\n",
 				     node->debug_id, node->ptr, ref->debug_id,
@@ -1567,6 +1588,7 @@ static void binder_transaction(struct binder_proc *proc,
 				fp->binder = ref->node->ptr;
 				fp->cookie = ref->node->cookie;
 				binder_inc_node(ref->node, fp->type == BINDER_TYPE_BINDER, 0, NULL);
+				trace_binder_transaction_ref_to_node(t, ref);
 				binder_debug(BINDER_DEBUG_TRANSACTION,
 					     "        ref %d desc %d -> node %d u%p\n",
 					     ref->debug_id, ref->desc, ref->node->debug_id,
@@ -1580,6 +1602,8 @@ static void binder_transaction(struct binder_proc *proc,
 				}
 				fp->handle = new_ref->desc;
 				binder_inc_ref(new_ref, fp->type == BINDER_TYPE_HANDLE, NULL);
+				trace_binder_transaction_ref_to_ref(t, ref,
+								    new_ref);
 				binder_debug(BINDER_DEBUG_TRANSACTION,
 					     "        ref %d desc %d -> ref %d desc %d (node %d)\n",
 					     ref->debug_id, ref->desc, new_ref->debug_id,
@@ -1619,6 +1643,7 @@ static void binder_transaction(struct binder_proc *proc,
 				goto err_get_unused_fd_failed;
 			}
 			task_fd_install(target_proc, target_fd, file);
+			trace_binder_transaction_fd(t, fp->handle, target_fd);
 			binder_debug(BINDER_DEBUG_TRANSACTION,
 				     "        fd %ld -> %d\n", fp->handle, target_fd);
 			/* TODO: fput? */
@@ -1667,6 +1692,7 @@ err_binder_new_node_failed:
 err_bad_object_type:
 err_bad_offset:
 err_copy_data_failed:
+	trace_binder_transaction_failed_buffer_release(t->buffer);
 	binder_transaction_buffer_release(target_proc, t->buffer, offp);
 	t->buffer->transaction = NULL;
 	binder_free_buf(target_proc, t->buffer);
@@ -1712,6 +1738,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 		if (get_user(cmd, (uint32_t __user *)ptr))
 			return -EFAULT;
 		ptr += sizeof(uint32_t);
+		trace_binder_command(cmd);
 		if (_IOC_NR(cmd) < ARRAY_SIZE(binder_stats.bc)) {
 			binder_stats.bc[_IOC_NR(cmd)]++;
 			proc->stats.bc[_IOC_NR(cmd)]++;
@@ -1881,6 +1908,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				else
 					list_move_tail(buffer->target_node->async_todo.next, &thread->todo);
 			}
+			trace_binder_transaction_buffer_release(buffer);
 			binder_transaction_buffer_release(proc, buffer, NULL);
 			binder_free_buf(proc, buffer);
 			break;
@@ -2089,6 +2117,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 void binder_stat_br(struct binder_proc *proc, struct binder_thread *thread,
 		    uint32_t cmd)
 {
+	trace_binder_return(cmd);
 	if (_IOC_NR(cmd) < ARRAY_SIZE(binder_stats.br)) {
 		binder_stats.br[_IOC_NR(cmd)]++;
 		proc->stats.br[_IOC_NR(cmd)]++;
@@ -2152,7 +2181,12 @@ retry:
 	thread->looper |= BINDER_LOOPER_STATE_WAITING;
 	if (wait_for_proc_work)
 		proc->ready_threads++;
-	mutex_unlock(&binder_lock);
+
+	binder_unlock(__func__);
+
+	trace_binder_wait_for_work(wait_for_proc_work,
+				   !!thread->transaction_stack,
+				   !list_empty(&thread->todo));
 	if (wait_for_proc_work) {
 		if (!(thread->looper & (BINDER_LOOPER_STATE_REGISTERED |
 					BINDER_LOOPER_STATE_ENTERED))) {
@@ -2176,7 +2210,9 @@ retry:
 		} else
 			ret = wait_event_interruptible(thread->wait, binder_has_thread_work(thread));
 	}
-	mutex_lock(&binder_lock);
+
+	binder_lock(__func__);
+
 	if (wait_for_proc_work)
 		proc->ready_threads--;
 	thread->looper &= ~BINDER_LOOPER_STATE_WAITING;
@@ -2367,6 +2403,7 @@ retry:
 			return -EFAULT;
 		ptr += sizeof(tr);
 
+		trace_binder_transaction_received(t);
 		binder_stat_br(proc, thread, cmd);
 		binder_debug(BINDER_DEBUG_TRANSACTION,
 			     "binder: %d:%d %s %d %d:%d, cmd %d"
@@ -2520,12 +2557,14 @@ static unsigned int binder_poll(struct file *filp,
 	struct binder_thread *thread = NULL;
 	int wait_for_proc_work;
 
-	mutex_lock(&binder_lock);
+	binder_lock(__func__);
+
 	thread = binder_get_thread(proc);
 
 	wait_for_proc_work = thread->transaction_stack == NULL &&
 		list_empty(&thread->todo) && thread->return_error == BR_OK;
-	mutex_unlock(&binder_lock);
+
+	binder_unlock(__func__);
 
 	if (wait_for_proc_work) {
 		if (binder_has_proc_work(proc, thread))
@@ -2553,11 +2592,13 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	/*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
 
+	trace_binder_ioctl(cmd, arg);
+
 	ret = wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
 	if (ret)
-		return ret;
+		goto err_unlocked;
 
-	mutex_lock(&binder_lock);
+	binder_lock(__func__);
 	thread = binder_get_thread(proc);
 	if (thread == NULL) {
 		ret = -ENOMEM;
@@ -2582,6 +2623,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		if (bwr.write_size > 0) {
 			ret = binder_thread_write(proc, thread, (void __user *)bwr.write_buffer, bwr.write_size, &bwr.write_consumed);
+			trace_binder_write_done(ret);
 			if (ret < 0) {
 				bwr.read_consumed = 0;
 				if (copy_to_user(ubuf, &bwr, sizeof(bwr)))
@@ -2591,6 +2633,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 		if (bwr.read_size > 0) {
 			ret = binder_thread_read(proc, thread, (void __user *)bwr.read_buffer, bwr.read_size, &bwr.read_consumed, filp->f_flags & O_NONBLOCK);
+			trace_binder_read_done(ret);
 			if (!list_empty(&proc->todo))
 				wake_up_interruptible(&proc->wait);
 			if (ret < 0) {
@@ -2666,10 +2709,12 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 err:
 	if (thread)
 		thread->looper &= ~BINDER_LOOPER_STATE_NEED_RETURN;
-	mutex_unlock(&binder_lock);
+	binder_unlock(__func__);
 	wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
 	if (ret && ret != -ERESTARTSYS)
 		pr_info("binder: %d:%d ioctl %x %lx returned %d\n", proc->pid, current->pid, cmd, arg, ret);
+err_unlocked:
+	trace_binder_ioctl_done(ret);
 	return ret;
 }
 
@@ -2815,13 +2860,16 @@ static int binder_open(struct inode *nodp, struct file *filp)
 	INIT_LIST_HEAD(&proc->todo);
 	init_waitqueue_head(&proc->wait);
 	proc->default_priority = task_nice(current);
-	mutex_lock(&binder_lock);
+
+	binder_lock(__func__);
+
 	binder_stats_created(BINDER_STAT_PROC);
 	hlist_add_head(&proc->proc_node, &binder_procs);
 	proc->pid = current->group_leader->pid;
 	INIT_LIST_HEAD(&proc->delivered_death);
 	filp->private_data = proc;
-	mutex_unlock(&binder_lock);
+
+	binder_unlock(__func__);
 
 	if (binder_debugfs_dir_entry_proc) {
 		char strbuf[11];
@@ -3001,7 +3049,7 @@ static void binder_deferred_func(struct work_struct *work)
 
 	int defer;
 	do {
-		mutex_lock(&binder_lock);
+		binder_lock(__func__);
 		mutex_lock(&binder_deferred_lock);
 		if (!hlist_empty(&binder_deferred_list)) {
 			proc = hlist_entry(binder_deferred_list.first,
@@ -3028,7 +3076,7 @@ static void binder_deferred_func(struct work_struct *work)
 		if (defer & BINDER_DEFERRED_RELEASE)
 			binder_deferred_release(proc); /* frees proc */
 
-		mutex_unlock(&binder_lock);
+		binder_unlock(__func__);
 		if (files)
 			put_files_struct(files);
 	} while (proc);
@@ -3369,7 +3417,7 @@ static int binder_state_show(struct seq_file *m, void *unused)
 	int do_lock = !binder_debug_no_lock;
 
 	if (do_lock)
-		mutex_lock(&binder_lock);
+		binder_lock(__func__);
 
 	seq_puts(m, "binder state:\n");
 
@@ -3381,7 +3429,7 @@ static int binder_state_show(struct seq_file *m, void *unused)
 	hlist_for_each_entry(proc, pos, &binder_procs, proc_node)
 		print_binder_proc(m, proc, 1);
 	if (do_lock)
-		mutex_unlock(&binder_lock);
+		binder_unlock(__func__);
 	return 0;
 }
 
@@ -3392,7 +3440,7 @@ static int binder_stats_show(struct seq_file *m, void *unused)
 	int do_lock = !binder_debug_no_lock;
 
 	if (do_lock)
-		mutex_lock(&binder_lock);
+		binder_lock(__func__);
 
 	seq_puts(m, "binder stats:\n");
 
@@ -3401,7 +3449,7 @@ static int binder_stats_show(struct seq_file *m, void *unused)
 	hlist_for_each_entry(proc, pos, &binder_procs, proc_node)
 		print_binder_proc_stats(m, proc);
 	if (do_lock)
-		mutex_unlock(&binder_lock);
+		binder_unlock(__func__);
 	return 0;
 }
 
@@ -3412,13 +3460,13 @@ static int binder_transactions_show(struct seq_file *m, void *unused)
 	int do_lock = !binder_debug_no_lock;
 
 	if (do_lock)
-		mutex_lock(&binder_lock);
+		binder_lock(__func__);
 
 	seq_puts(m, "binder transactions:\n");
 	hlist_for_each_entry(proc, pos, &binder_procs, proc_node)
 		print_binder_proc(m, proc, 0);
 	if (do_lock)
-		mutex_unlock(&binder_lock);
+		binder_unlock(__func__);
 	return 0;
 }
 
@@ -3428,11 +3476,11 @@ static int binder_proc_show(struct seq_file *m, void *unused)
 	int do_lock = !binder_debug_no_lock;
 
 	if (do_lock)
-		mutex_lock(&binder_lock);
+		binder_lock(__func__);
 	seq_puts(m, "binder proc state:\n");
 	print_binder_proc(m, proc, 1);
 	if (do_lock)
-		mutex_unlock(&binder_lock);
+		binder_unlock(__func__);
 	return 0;
 }
 
@@ -3527,4 +3575,7 @@ static int __init binder_init(void)
 
 device_initcall(binder_init);
 
+#define CREATE_TRACE_POINTS
+#include "binder_trace.h"
+
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/android/binder_trace.h b/drivers/staging/android/binder_trace.h
new file mode 100644
index 0000000..82a567c
--- /dev/null
+++ b/drivers/staging/android/binder_trace.h
@@ -0,0 +1,327 @@
+/*
+ * Copyright (C) 2012 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM binder
+
+#if !defined(_BINDER_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _BINDER_TRACE_H
+
+#include <linux/tracepoint.h>
+
+struct binder_buffer;
+struct binder_node;
+struct binder_proc;
+struct binder_ref;
+struct binder_thread;
+struct binder_transaction;
+
+TRACE_EVENT(binder_ioctl,
+	TP_PROTO(unsigned int cmd, unsigned long arg),
+	TP_ARGS(cmd, arg),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cmd)
+		__field(unsigned long, arg)
+	),
+	TP_fast_assign(
+		__entry->cmd = cmd;
+		__entry->arg = arg;
+	),
+	TP_printk("cmd=0x%x arg=0x%lx", __entry->cmd, __entry->arg)
+);
+
+DECLARE_EVENT_CLASS(binder_lock_class,
+	TP_PROTO(const char *tag),
+	TP_ARGS(tag),
+	TP_STRUCT__entry(
+		__field(const char *, tag)
+	),
+	TP_fast_assign(
+		__entry->tag = tag;
+	),
+	TP_printk("tag=%s", __entry->tag)
+);
+
+#define DEFINE_BINDER_LOCK_EVENT(name)	\
+DEFINE_EVENT(binder_lock_class, name,	\
+	TP_PROTO(const char *func), \
+	TP_ARGS(func))
+
+DEFINE_BINDER_LOCK_EVENT(binder_lock);
+DEFINE_BINDER_LOCK_EVENT(binder_locked);
+DEFINE_BINDER_LOCK_EVENT(binder_unlock);
+
+DECLARE_EVENT_CLASS(binder_function_return_class,
+	TP_PROTO(int ret),
+	TP_ARGS(ret),
+	TP_STRUCT__entry(
+		__field(int, ret)
+	),
+	TP_fast_assign(
+		__entry->ret = ret;
+	),
+	TP_printk("ret=%d", __entry->ret)
+);
+
+#define DEFINE_BINDER_FUNCTION_RETURN_EVENT(name)	\
+DEFINE_EVENT(binder_function_return_class, name,	\
+	TP_PROTO(int ret), \
+	TP_ARGS(ret))
+
+DEFINE_BINDER_FUNCTION_RETURN_EVENT(binder_ioctl_done);
+DEFINE_BINDER_FUNCTION_RETURN_EVENT(binder_write_done);
+DEFINE_BINDER_FUNCTION_RETURN_EVENT(binder_read_done);
+
+TRACE_EVENT(binder_wait_for_work,
+	TP_PROTO(bool proc_work, bool transaction_stack, bool thread_todo),
+	TP_ARGS(proc_work, transaction_stack, thread_todo),
+
+	TP_STRUCT__entry(
+		__field(bool, proc_work)
+		__field(bool, transaction_stack)
+		__field(bool, thread_todo)
+	),
+	TP_fast_assign(
+		__entry->proc_work = proc_work;
+		__entry->transaction_stack = transaction_stack;
+		__entry->thread_todo = thread_todo;
+	),
+	TP_printk("proc_work=%d transaction_stack=%d thread_todo=%d",
+		  __entry->proc_work, __entry->transaction_stack,
+		  __entry->thread_todo)
+);
+
+TRACE_EVENT(binder_transaction,
+	TP_PROTO(bool reply, struct binder_transaction *t,
+		 struct binder_node *target_node),
+	TP_ARGS(reply, t, target_node),
+	TP_STRUCT__entry(
+		__field(int, debug_id)
+		__field(int, target_node)
+		__field(int, to_proc)
+		__field(int, to_thread)
+		__field(int, reply)
+		__field(unsigned int, code)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->debug_id = t->debug_id;
+		__entry->target_node = target_node ? target_node->debug_id : 0;
+		__entry->to_proc = t->to_proc->pid;
+		__entry->to_thread = t->to_thread ? t->to_thread->pid : 0;
+		__entry->reply = reply;
+		__entry->code = t->code;
+		__entry->flags = t->flags;
+	),
+	TP_printk("transaction=%d dest_node=%d dest_proc=%d dest_thread=%d reply=%d flags=0x%x code=0x%x",
+		  __entry->debug_id, __entry->target_node,
+		  __entry->to_proc, __entry->to_thread,
+		  __entry->reply, __entry->flags, __entry->code)
+);
+
+TRACE_EVENT(binder_transaction_received,
+	TP_PROTO(struct binder_transaction *t),
+	TP_ARGS(t),
+
+	TP_STRUCT__entry(
+		__field(int, debug_id)
+	),
+	TP_fast_assign(
+		__entry->debug_id = t->debug_id;
+	),
+	TP_printk("transaction=%d", __entry->debug_id)
+);
+
+TRACE_EVENT(binder_transaction_node_to_ref,
+	TP_PROTO(struct binder_transaction *t, struct binder_node *node,
+		 struct binder_ref *ref),
+	TP_ARGS(t, node, ref),
+
+	TP_STRUCT__entry(
+		__field(int, debug_id)
+		__field(int, node_debug_id)
+		__field(void __user *, node_ptr)
+		__field(int, ref_debug_id)
+		__field(uint32_t, ref_desc)
+	),
+	TP_fast_assign(
+		__entry->debug_id = t->debug_id;
+		__entry->node_debug_id = node->debug_id;
+		__entry->node_ptr = node->ptr;
+		__entry->ref_debug_id = ref->debug_id;
+		__entry->ref_desc = ref->desc;
+	),
+	TP_printk("transaction=%d node=%d src_ptr=0x%p ==> dest_ref=%d dest_desc=%d",
+		  __entry->debug_id, __entry->node_debug_id, __entry->node_ptr,
+		  __entry->ref_debug_id, __entry->ref_desc)
+);
+
+TRACE_EVENT(binder_transaction_ref_to_node,
+	TP_PROTO(struct binder_transaction *t, struct binder_ref *ref),
+	TP_ARGS(t, ref),
+
+	TP_STRUCT__entry(
+		__field(int, debug_id)
+		__field(int, ref_debug_id)
+		__field(uint32_t, ref_desc)
+		__field(int, node_debug_id)
+		__field(void __user *, node_ptr)
+	),
+	TP_fast_assign(
+		__entry->debug_id = t->debug_id;
+		__entry->ref_debug_id = ref->debug_id;
+		__entry->ref_desc = ref->desc;
+		__entry->node_debug_id = ref->node->debug_id;
+		__entry->node_ptr = ref->node->ptr;
+	),
+	TP_printk("transaction=%d node=%d src_ref=%d src_desc=%d ==> dest_ptr=0x%p",
+		  __entry->debug_id, __entry->node_debug_id,
+		  __entry->ref_debug_id, __entry->ref_desc, __entry->node_ptr)
+);
+
+TRACE_EVENT(binder_transaction_ref_to_ref,
+	TP_PROTO(struct binder_transaction *t, struct binder_ref *src_ref,
+		 struct binder_ref *dest_ref),
+	TP_ARGS(t, src_ref, dest_ref),
+
+	TP_STRUCT__entry(
+		__field(int, debug_id)
+		__field(int, node_debug_id)
+		__field(int, src_ref_debug_id)
+		__field(uint32_t, src_ref_desc)
+		__field(int, dest_ref_debug_id)
+		__field(uint32_t, dest_ref_desc)
+	),
+	TP_fast_assign(
+		__entry->debug_id = t->debug_id;
+		__entry->node_debug_id = src_ref->node->debug_id;
+		__entry->src_ref_debug_id = src_ref->debug_id;
+		__entry->src_ref_desc = src_ref->desc;
+		__entry->dest_ref_debug_id = dest_ref->debug_id;
+		__entry->dest_ref_desc = dest_ref->desc;
+	),
+	TP_printk("transaction=%d node=%d src_ref=%d src_desc=%d ==> dest_ref=%d dest_desc=%d",
+		  __entry->debug_id, __entry->node_debug_id,
+		  __entry->src_ref_debug_id, __entry->src_ref_desc,
+		  __entry->dest_ref_debug_id, __entry->dest_ref_desc)
+);
+
+TRACE_EVENT(binder_transaction_fd,
+	TP_PROTO(struct binder_transaction *t, int src_fd, int dest_fd),
+	TP_ARGS(t, src_fd, dest_fd),
+
+	TP_STRUCT__entry(
+		__field(int, debug_id)
+		__field(int, src_fd)
+		__field(int, dest_fd)
+	),
+	TP_fast_assign(
+		__entry->debug_id = t->debug_id;
+		__entry->src_fd = src_fd;
+		__entry->dest_fd = dest_fd;
+	),
+	TP_printk("transaction=%d src_fd=%d ==> dest_fd=%d",
+		  __entry->debug_id, __entry->src_fd, __entry->dest_fd)
+);
+
+DECLARE_EVENT_CLASS(binder_buffer_class,
+	TP_PROTO(struct binder_buffer *buf),
+	TP_ARGS(buf),
+	TP_STRUCT__entry(
+		__field(int, debug_id)
+		__field(size_t, data_size)
+		__field(size_t, offsets_size)
+	),
+	TP_fast_assign(
+		__entry->debug_id = buf->debug_id;
+		__entry->data_size = buf->data_size;
+		__entry->offsets_size = buf->offsets_size;
+	),
+	TP_printk("transaction=%d data_size=%zd offsets_size=%zd",
+		  __entry->debug_id, __entry->data_size, __entry->offsets_size)
+);
+
+DEFINE_EVENT(binder_buffer_class, binder_transaction_alloc_buf,
+	TP_PROTO(struct binder_buffer *buffer),
+	TP_ARGS(buffer));
+
+DEFINE_EVENT(binder_buffer_class, binder_transaction_buffer_release,
+	TP_PROTO(struct binder_buffer *buffer),
+	TP_ARGS(buffer));
+
+DEFINE_EVENT(binder_buffer_class, binder_transaction_failed_buffer_release,
+	TP_PROTO(struct binder_buffer *buffer),
+	TP_ARGS(buffer));
+
+TRACE_EVENT(binder_update_page_range,
+	TP_PROTO(struct binder_proc *proc, bool allocate,
+		 void *start, void *end),
+	TP_ARGS(proc, allocate, start, end),
+	TP_STRUCT__entry(
+		__field(int, proc)
+		__field(bool, allocate)
+		__field(size_t, offset)
+		__field(size_t, size)
+	),
+	TP_fast_assign(
+		__entry->proc = proc->pid;
+		__entry->allocate = allocate;
+		__entry->offset = start - proc->buffer;
+		__entry->size = end - start;
+	),
+	TP_printk("proc=%d allocate=%d offset=%zu size=%zu",
+		  __entry->proc, __entry->allocate,
+		  __entry->offset, __entry->size)
+);
+
+TRACE_EVENT(binder_command,
+	TP_PROTO(uint32_t cmd),
+	TP_ARGS(cmd),
+	TP_STRUCT__entry(
+		__field(uint32_t, cmd)
+	),
+	TP_fast_assign(
+		__entry->cmd = cmd;
+	),
+	TP_printk("cmd=0x%x %s",
+		  __entry->cmd,
+		  _IOC_NR(__entry->cmd) < ARRAY_SIZE(binder_command_strings) ?
+			  binder_command_strings[_IOC_NR(__entry->cmd)] :
+			  "unknown")
+);
+
+TRACE_EVENT(binder_return,
+	TP_PROTO(uint32_t cmd),
+	TP_ARGS(cmd),
+	TP_STRUCT__entry(
+		__field(uint32_t, cmd)
+	),
+	TP_fast_assign(
+		__entry->cmd = cmd;
+	),
+	TP_printk("cmd=0x%x %s",
+		  __entry->cmd,
+		  _IOC_NR(__entry->cmd) < ARRAY_SIZE(binder_return_strings) ?
+			  binder_return_strings[_IOC_NR(__entry->cmd)] :
+			  "unknown")
+);
+
+#endif /* _BINDER_TRACE_H */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE binder_trace
+#include <trace/define_trace.h>
-- 
1.7.7.3

