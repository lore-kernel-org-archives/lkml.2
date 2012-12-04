Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab2LDKpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:45:00 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36091 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452Ab2LDKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:44:34 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, zach.pfeffer@linaro.org, Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 1/2] Staging: android: binder: Add support for 32bit binder calls in a 64bit kernel
Date: Tue,  4 Dec 2012 10:44:13 +0000
Message-Id: <1354617854-25296-2-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com>
References: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Android's IPC, Binder, does not support calls from a 32-bit userspace
in a 64 bit kernel. This patch adds support for syscalls coming from a
32-bit userspace in a 64-bit kernel.

Most of the changes were applied to types that change sizes between
32 and 64 bit world. This will also fix some of the issues around
checking the size of an incoming transaction package in the ioctl
switch. Since  the transaction's ioctl number are generated using
_IOC(dir,type,nr,size), a different userspace size will generate
a different ioctl number, thus switching by _IOC_NR is a better
solution.

The patch has been successfully tested on ARMv8 AEM and Versatile
Express V2P-CA9.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/staging/android/binder.c |  298 ++++++++++++++++++++------------------
 drivers/staging/android/binder.h |   56 +++----
 2 files changed, 190 insertions(+), 164 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 5d4610b..efba042 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -223,8 +223,8 @@ struct binder_node {
 	int internal_strong_refs;
 	int local_weak_refs;
 	int local_strong_refs;
-	void __user *ptr;
-	void __user *cookie;
+	userptr32_t ptr;
+	userptr32_t cookie;
 	unsigned has_strong_ref:1;
 	unsigned pending_strong_ref:1;
 	unsigned has_weak_ref:1;
@@ -237,7 +237,7 @@ struct binder_node {
 
 struct binder_ref_death {
 	struct binder_work work;
-	void __user *cookie;
+	userptr32_t cookie;
 };
 
 struct binder_ref {
@@ -312,7 +312,7 @@ struct binder_proc {
 	int requested_threads;
 	int requested_threads_started;
 	int ready_threads;
-	long default_priority;
+	int default_priority;
 	struct dentry *debugfs_entry;
 };
 
@@ -354,8 +354,8 @@ struct binder_transaction {
 	struct binder_buffer *buffer;
 	unsigned int	code;
 	unsigned int	flags;
-	long	priority;
-	long	saved_priority;
+	int	priority;
+	int	saved_priority;
 	kuid_t	sender_euid;
 };
 
@@ -411,17 +411,17 @@ static long task_close_fd(struct binder_proc *proc, unsigned int fd)
 	return retval;
 }
 
-static void binder_set_nice(long nice)
+static void binder_set_nice(int nice)
 {
-	long min_nice;
+	int min_nice;
 	if (can_nice(current, nice)) {
 		set_user_nice(current, nice);
 		return;
 	}
 	min_nice = 20 - current->signal->rlim[RLIMIT_NICE].rlim_cur;
 	binder_debug(BINDER_DEBUG_PRIORITY_CAP,
-		     "binder: %d: nice value %ld not allowed use "
-		     "%ld instead\n", current->pid, nice, min_nice);
+		     "binder: %d: nice value %d not allowed use "
+		     "%d instead\n", current->pid, nice, min_nice);
 	set_user_nice(current, min_nice);
 	if (min_nice < 20)
 		return;
@@ -497,13 +497,13 @@ static void binder_insert_allocated_buffer(struct binder_proc *proc,
 }
 
 static struct binder_buffer *binder_buffer_lookup(struct binder_proc *proc,
-						  void __user *user_ptr)
+						  userptr32_t user_ptr)
 {
 	struct rb_node *n = proc->allocated_buffers.rb_node;
 	struct binder_buffer *buffer;
 	struct binder_buffer *kern_ptr;
 
-	kern_ptr = user_ptr - proc->user_buffer_offset
+	kern_ptr = (void *)(unsigned long)user_ptr - proc->user_buffer_offset
 		- offsetof(struct binder_buffer, data);
 
 	while (n) {
@@ -641,8 +641,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		return NULL;
 	}
 
-	size = ALIGN(data_size, sizeof(void *)) +
-		ALIGN(offsets_size, sizeof(void *));
+	size = ALIGN(data_size, sizeof(userptr32_t)) +
+		ALIGN(offsets_size, sizeof(userptr32_t));
 
 	if (size < data_size || size < offsets_size) {
 		binder_user_error("binder: %d: got transaction with invalid "
@@ -793,8 +793,8 @@ static void binder_free_buf(struct binder_proc *proc,
 
 	buffer_size = binder_buffer_size(proc, buffer);
 
-	size = ALIGN(buffer->data_size, sizeof(void *)) +
-		ALIGN(buffer->offsets_size, sizeof(void *));
+	size = ALIGN(buffer->data_size, sizeof(userptr32_t)) +
+		ALIGN(buffer->offsets_size, sizeof(userptr32_t));
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
 		     "binder: %d: binder_free_buf %p size %zd buffer"
@@ -842,7 +842,7 @@ static void binder_free_buf(struct binder_proc *proc,
 }
 
 static struct binder_node *binder_get_node(struct binder_proc *proc,
-					   void __user *ptr)
+					   userptr32_t ptr)
 {
 	struct rb_node *n = proc->nodes.rb_node;
 	struct binder_node *node;
@@ -861,8 +861,8 @@ static struct binder_node *binder_get_node(struct binder_proc *proc,
 }
 
 static struct binder_node *binder_new_node(struct binder_proc *proc,
-					   void __user *ptr,
-					   void __user *cookie)
+					   userptr32_t ptr,
+					   userptr32_t cookie)
 {
 	struct rb_node **p = &proc->nodes.rb_node;
 	struct rb_node *parent = NULL;
@@ -894,7 +894,7 @@ static struct binder_node *binder_new_node(struct binder_proc *proc,
 	INIT_LIST_HEAD(&node->work.entry);
 	INIT_LIST_HEAD(&node->async_todo);
 	binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-		     "binder: %d:%d node %d u%p c%p created\n",
+		     "binder: %d:%d node %d u%x c%x created\n",
 		     proc->pid, current->pid, node->debug_id,
 		     node->ptr, node->cookie);
 	return node;
@@ -1220,9 +1220,9 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 
 static void binder_transaction_buffer_release(struct binder_proc *proc,
 					      struct binder_buffer *buffer,
-					      size_t *failed_at)
+					      uint32_t *failed_at)
 {
-	size_t *offp, *off_end;
+	uint32_t *offp, *off_end;
 	int debug_id = buffer->debug_id;
 
 	binder_debug(BINDER_DEBUG_TRANSACTION,
@@ -1233,18 +1233,19 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 	if (buffer->target_node)
 		binder_dec_node(buffer->target_node, 1, 0);
 
-	offp = (size_t *)(buffer->data + ALIGN(buffer->data_size, sizeof(void *)));
+	offp = (uint32_t *)(buffer->data +
+			    ALIGN(buffer->data_size, sizeof(userptr32_t)));
 	if (failed_at)
 		off_end = failed_at;
 	else
-		off_end = (void *)offp + buffer->offsets_size;
+		off_end = (uint32_t *)offp + (buffer->offsets_size/4);
 	for (; offp < off_end; offp++) {
 		struct flat_binder_object *fp;
 		if (*offp > buffer->data_size - sizeof(*fp) ||
 		    buffer->data_size < sizeof(*fp) ||
-		    !IS_ALIGNED(*offp, sizeof(void *))) {
+		    !IS_ALIGNED(*offp, sizeof(userptr32_t))) {
 			pr_err("binder: transaction release %d bad"
-					"offset %zd, size %zd\n", debug_id,
+					"offset %x, size %zd\n", debug_id,
 					*offp, buffer->data_size);
 			continue;
 		}
@@ -1255,11 +1256,11 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			struct binder_node *node = binder_get_node(proc, fp->binder);
 			if (node == NULL) {
 				pr_err("binder: transaction release %d"
-				       " bad node %p\n", debug_id, fp->binder);
+				       " bad node %x\n", debug_id, fp->binder);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_TRANSACTION,
-				     "        node %d u%p\n",
+				     "        node %d u%x\n",
 				     node->debug_id, node->ptr);
 			binder_dec_node(node, fp->type == BINDER_TYPE_BINDER, 0);
 		} break;
@@ -1268,7 +1269,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
 				pr_err("binder: transaction release %d"
-				       " bad handle %ld\n", debug_id,
+				       " bad handle %d\n", debug_id,
 				       fp->handle);
 				break;
 			}
@@ -1280,14 +1281,14 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 
 		case BINDER_TYPE_FD:
 			binder_debug(BINDER_DEBUG_TRANSACTION,
-				     "        fd %ld\n", fp->handle);
+				     "        fd %d\n", fp->handle);
 			if (failed_at)
 				task_close_fd(proc, fp->handle);
 			break;
 
 		default:
 			pr_err("binder: transaction release %d bad "
-			       "object type %lx\n", debug_id, fp->type);
+			       "object type %x\n", debug_id, fp->type);
 			break;
 		}
 	}
@@ -1299,7 +1300,7 @@ static void binder_transaction(struct binder_proc *proc,
 {
 	struct binder_transaction *t;
 	struct binder_work *tcomplete;
-	size_t *offp, *off_end;
+	uint32_t *offp, *off_end;
 	struct binder_proc *target_proc;
 	struct binder_thread *target_thread = NULL;
 	struct binder_node *target_node = NULL;
@@ -1437,7 +1438,7 @@ static void binder_transaction(struct binder_proc *proc,
 	if (reply)
 		binder_debug(BINDER_DEBUG_TRANSACTION,
 			     "binder: %d:%d BC_REPLY %d -> %d:%d, "
-			     "data %p-%p size %zd-%zd\n",
+			     "data %x-%x size %d-%d\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_thread->pid,
 			     tr->data.ptr.buffer, tr->data.ptr.offsets,
@@ -1445,7 +1446,7 @@ static void binder_transaction(struct binder_proc *proc,
 	else
 		binder_debug(BINDER_DEBUG_TRANSACTION,
 			     "binder: %d:%d BC_TRANSACTION %d -> "
-			     "%d - node %d, data %p-%p size %zd-%zd\n",
+			     "%d - node %d, data %x-%x size %d-%d\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_node->debug_id,
 			     tr->data.ptr.buffer, tr->data.ptr.offsets,
@@ -1474,35 +1475,36 @@ static void binder_transaction(struct binder_proc *proc,
 	if (target_node)
 		binder_inc_node(target_node, 1, 0, NULL);
 
-	offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size, sizeof(void *)));
+	offp = (uint32_t *)(t->buffer->data +
+			    ALIGN(tr->data_size, sizeof(userptr32_t)));
 
-	if (copy_from_user(t->buffer->data, tr->data.ptr.buffer, tr->data_size)) {
+	if (copy_from_user(t->buffer->data, (void *)(unsigned long)(tr->data.ptr.buffer),  tr->data_size)) {
 		binder_user_error("binder: %d:%d got transaction with invalid "
 			"data ptr\n", proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
-	if (copy_from_user(offp, tr->data.ptr.offsets, tr->offsets_size)) {
+	if (copy_from_user(offp, (void *)(unsigned long)(tr->data.ptr.offsets), tr->offsets_size)) {
 		binder_user_error("binder: %d:%d got transaction with invalid "
 			"offsets ptr\n", proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
-	if (!IS_ALIGNED(tr->offsets_size, sizeof(size_t))) {
+	if (!IS_ALIGNED(tr->offsets_size, sizeof(uint32_t))) {
 		binder_user_error("binder: %d:%d got transaction with "
-			"invalid offsets size, %zd\n",
+			"invalid offsets size, %d\n",
 			proc->pid, thread->pid, tr->offsets_size);
 		return_error = BR_FAILED_REPLY;
 		goto err_bad_offset;
 	}
-	off_end = (void *)offp + tr->offsets_size;
+	off_end = (uint32_t *)offp + (tr->offsets_size/4);
 	for (; offp < off_end; offp++) {
 		struct flat_binder_object *fp;
 		if (*offp > t->buffer->data_size - sizeof(*fp) ||
 		    t->buffer->data_size < sizeof(*fp) ||
-		    !IS_ALIGNED(*offp, sizeof(void *))) {
+		    !IS_ALIGNED(*offp, sizeof(userptr32_t))) {
 			binder_user_error("binder: %d:%d got transaction with "
-				"invalid offset, %zd\n",
+				"invalid offset, %x\n",
 				proc->pid, thread->pid, *offp);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_offset;
@@ -1523,8 +1525,8 @@ static void binder_transaction(struct binder_proc *proc,
 				node->accept_fds = !!(fp->flags & FLAT_BINDER_FLAG_ACCEPTS_FDS);
 			}
 			if (fp->cookie != node->cookie) {
-				binder_user_error("binder: %d:%d sending u%p "
-					"node %d, cookie mismatch %p != %p\n",
+				binder_user_error("binder: %d:%d sending u%x"
+					"node %d, cookie mismatch %x != %x\n",
 					proc->pid, thread->pid,
 					fp->binder, node->debug_id,
 					fp->cookie, node->cookie);
@@ -1544,7 +1546,7 @@ static void binder_transaction(struct binder_proc *proc,
 				       &thread->todo);
 
 			binder_debug(BINDER_DEBUG_TRANSACTION,
-				     "        node %d u%p -> ref %d desc %d\n",
+				     "        node %d u%x -> ref %d desc %d\n",
 				     node->debug_id, node->ptr, ref->debug_id,
 				     ref->desc);
 		} break;
@@ -1554,7 +1556,7 @@ static void binder_transaction(struct binder_proc *proc,
 			if (ref == NULL) {
 				binder_user_error("binder: %d:%d got "
 					"transaction with invalid "
-					"handle, %ld\n", proc->pid,
+					"handle, %d\n", proc->pid,
 					thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_binder_get_ref_failed;
@@ -1568,7 +1570,7 @@ static void binder_transaction(struct binder_proc *proc,
 				fp->cookie = ref->node->cookie;
 				binder_inc_node(ref->node, fp->type == BINDER_TYPE_BINDER, 0, NULL);
 				binder_debug(BINDER_DEBUG_TRANSACTION,
-					     "        ref %d desc %d -> node %d u%p\n",
+					     "        ref %d desc %d -> node %d u%x\n",
 					     ref->debug_id, ref->desc, ref->node->debug_id,
 					     ref->node->ptr);
 			} else {
@@ -1593,13 +1595,13 @@ static void binder_transaction(struct binder_proc *proc,
 
 			if (reply) {
 				if (!(in_reply_to->flags & TF_ACCEPT_FDS)) {
-					binder_user_error("binder: %d:%d got reply with fd, %ld, but target does not allow fds\n",
+					binder_user_error("binder: %d:%d got reply with fd, %d, but target does not allow fds\n",
 						proc->pid, thread->pid, fp->handle);
 					return_error = BR_FAILED_REPLY;
 					goto err_fd_not_allowed;
 				}
 			} else if (!target_node->accept_fds) {
-				binder_user_error("binder: %d:%d got transaction with fd, %ld, but target does not allow fds\n",
+				binder_user_error("binder: %d:%d got transaction with fd, %d, but target does not allow fds\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fd_not_allowed;
@@ -1607,7 +1609,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 			file = fget(fp->handle);
 			if (file == NULL) {
-				binder_user_error("binder: %d:%d got transaction with invalid fd, %ld\n",
+				binder_user_error("binder: %d:%d got transaction with invalid fd, %d\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fget_failed;
@@ -1620,14 +1622,14 @@ static void binder_transaction(struct binder_proc *proc,
 			}
 			task_fd_install(target_proc, target_fd, file);
 			binder_debug(BINDER_DEBUG_TRANSACTION,
-				     "        fd %ld -> %d\n", fp->handle, target_fd);
+				     "        fd %d -> %d\n", fp->handle, target_fd);
 			/* TODO: fput? */
 			fp->handle = target_fd;
 		} break;
 
 		default:
 			binder_user_error("binder: %d:%d got transactio"
-				"n with invalid object type, %lx\n",
+				"n with invalid object type, %x\n",
 				proc->pid, thread->pid, fp->type);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_object_type;
@@ -1683,7 +1685,7 @@ err_dead_binder:
 err_invalid_target_handle:
 err_no_context_mgr_node:
 	binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-		     "binder: %d:%d transaction failed %d, size %zd-%zd\n",
+		     "binder: %d:%d transaction failed %d, size %d-%d\n",
 		     proc->pid, thread->pid, return_error,
 		     tr->data_size, tr->offsets_size);
 
@@ -1702,7 +1704,7 @@ err_no_context_mgr_node:
 }
 
 int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
-			void __user *buffer, int size, signed long *consumed)
+			void __user *buffer, int size, int *consumed)
 {
 	uint32_t cmd;
 	void __user *ptr = buffer + *consumed;
@@ -1717,11 +1719,16 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			proc->stats.bc[_IOC_NR(cmd)]++;
 			thread->stats.bc[_IOC_NR(cmd)]++;
 		}
-		switch (cmd) {
-		case BC_INCREFS:
-		case BC_ACQUIRE:
-		case BC_RELEASE:
-		case BC_DECREFS: {
+		/*
+		 * since  the transaction's IOCTL number are generated using
+		 * _IOC(dir,type,nr,size), a different userspace size will not
+		 * fall through
+		 */
+		switch (_IOC_NR(cmd)) {
+		case _IOC_NR(BC_INCREFS):
+		case _IOC_NR(BC_ACQUIRE):
+		case _IOC_NR(BC_RELEASE):
+		case _IOC_NR(BC_DECREFS): {
 			uint32_t target;
 			struct binder_ref *ref;
 			const char *debug_string;
@@ -1749,20 +1756,20 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 					proc->pid, thread->pid, target);
 				break;
 			}
-			switch (cmd) {
-			case BC_INCREFS:
+			switch (_IOC_NR(cmd)) {
+			case _IOC_NR(BC_INCREFS):
 				debug_string = "IncRefs";
 				binder_inc_ref(ref, 0, NULL);
 				break;
-			case BC_ACQUIRE:
+			case _IOC_NR(BC_ACQUIRE):
 				debug_string = "Acquire";
 				binder_inc_ref(ref, 1, NULL);
 				break;
-			case BC_RELEASE:
+			case _IOC_NR(BC_RELEASE):
 				debug_string = "Release";
 				binder_dec_ref(ref, 1);
 				break;
-			case BC_DECREFS:
+			case _IOC_NR(BC_DECREFS):
 			default:
 				debug_string = "DecRefs";
 				binder_dec_ref(ref, 0);
@@ -1774,22 +1781,26 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				     ref->desc, ref->strong, ref->weak, ref->node->debug_id);
 			break;
 		}
-		case BC_INCREFS_DONE:
-		case BC_ACQUIRE_DONE: {
-			void __user *node_ptr;
-			void *cookie;
+		case _IOC_NR(BC_INCREFS_DONE):
+		case _IOC_NR(BC_ACQUIRE_DONE): {
+			userptr32_t node_ptr;
+			userptr32_t cookie;
 			struct binder_node *node;
 
-			if (get_user(node_ptr, (void * __user *)ptr))
+			if (_IOC_SIZE(cmd) != sizeof(struct binder_ptr_cookie)) {
+				pr_err("binder: tranzaction structure size differs\n");
 				return -EFAULT;
-			ptr += sizeof(void *);
-			if (get_user(cookie, (void * __user *)ptr))
+			}
+			if (get_user(node_ptr, (userptr32_t __user *)ptr))
+				return -EFAULT;
+			ptr += sizeof(userptr32_t);
+			if (get_user(cookie, (userptr32_t __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(void *);
+			ptr += sizeof(userptr32_t);
 			node = binder_get_node(proc, node_ptr);
 			if (node == NULL) {
 				binder_user_error("binder: %d:%d "
-					"%s u%p no match\n",
+					"%s u%x no match\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
 					"BC_INCREFS_DONE" :
@@ -1798,8 +1809,8 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				break;
 			}
 			if (cookie != node->cookie) {
-				binder_user_error("binder: %d:%d %s u%p node %d"
-					" cookie mismatch %p != %p\n",
+				binder_user_error("binder: %d:%d %s u%x node %d"
+					" cookie mismatch %x != %x\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
 					"BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
@@ -1836,37 +1847,37 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				     node->debug_id, node->local_strong_refs, node->local_weak_refs);
 			break;
 		}
-		case BC_ATTEMPT_ACQUIRE:
+		case _IOC_NR(BC_ATTEMPT_ACQUIRE):
 			pr_err("binder: BC_ATTEMPT_ACQUIRE not supported\n");
 			return -EINVAL;
-		case BC_ACQUIRE_RESULT:
+		case _IOC_NR(BC_ACQUIRE_RESULT):
 			pr_err("binder: BC_ACQUIRE_RESULT not supported\n");
 			return -EINVAL;
 
-		case BC_FREE_BUFFER: {
-			void __user *data_ptr;
+		case _IOC_NR(BC_FREE_BUFFER): {
+			userptr32_t data_ptr;
 			struct binder_buffer *buffer;
 
-			if (get_user(data_ptr, (void * __user *)ptr))
+			if (get_user(data_ptr, (userptr32_t  __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(void *);
+			ptr += sizeof(userptr32_t);
 
 			buffer = binder_buffer_lookup(proc, data_ptr);
 			if (buffer == NULL) {
 				binder_user_error("binder: %d:%d "
-					"BC_FREE_BUFFER u%p no match\n",
+					"BC_FREE_BUFFER u%x no match\n",
 					proc->pid, thread->pid, data_ptr);
 				break;
 			}
 			if (!buffer->allow_user_free) {
 				binder_user_error("binder: %d:%d "
-					"BC_FREE_BUFFER u%p matched "
+					"BC_FREE_BUFFER u%x matched "
 					"unreturned buffer\n",
 					proc->pid, thread->pid, data_ptr);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_FREE_BUFFER,
-				     "binder: %d:%d BC_FREE_BUFFER u%p found buffer %d for %s transaction\n",
+				     "binder: %d:%d BC_FREE_BUFFER u%x found buffer %d for %s transaction\n",
 				     proc->pid, thread->pid, data_ptr, buffer->debug_id,
 				     buffer->transaction ? "active" : "finished");
 
@@ -1886,10 +1897,14 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			break;
 		}
 
-		case BC_TRANSACTION:
-		case BC_REPLY: {
+		case _IOC_NR(BC_TRANSACTION):
+		case _IOC_NR(BC_REPLY): {
 			struct binder_transaction_data tr;
 
+			if (_IOC_SIZE(cmd) != sizeof(tr)) {
+				pr_err("binder: tranzaction structure size differs\n");
+				return -EFAULT;
+			}
 			if (copy_from_user(&tr, ptr, sizeof(tr)))
 				return -EFAULT;
 			ptr += sizeof(tr);
@@ -1897,7 +1912,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			break;
 		}
 
-		case BC_REGISTER_LOOPER:
+		case _IOC_NR(BC_REGISTER_LOOPER):
 			binder_debug(BINDER_DEBUG_THREADS,
 				     "binder: %d:%d BC_REGISTER_LOOPER\n",
 				     proc->pid, thread->pid);
@@ -1919,7 +1934,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			}
 			thread->looper |= BINDER_LOOPER_STATE_REGISTERED;
 			break;
-		case BC_ENTER_LOOPER:
+		case _IOC_NR(BC_ENTER_LOOPER):
 			binder_debug(BINDER_DEBUG_THREADS,
 				     "binder: %d:%d BC_ENTER_LOOPER\n",
 				     proc->pid, thread->pid);
@@ -1932,26 +1947,26 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			}
 			thread->looper |= BINDER_LOOPER_STATE_ENTERED;
 			break;
-		case BC_EXIT_LOOPER:
+		case _IOC_NR(BC_EXIT_LOOPER):
 			binder_debug(BINDER_DEBUG_THREADS,
 				     "binder: %d:%d BC_EXIT_LOOPER\n",
 				     proc->pid, thread->pid);
 			thread->looper |= BINDER_LOOPER_STATE_EXITED;
 			break;
 
-		case BC_REQUEST_DEATH_NOTIFICATION:
-		case BC_CLEAR_DEATH_NOTIFICATION: {
+		case _IOC_NR(BC_REQUEST_DEATH_NOTIFICATION):
+		case _IOC_NR(BC_CLEAR_DEATH_NOTIFICATION): {
 			uint32_t target;
-			void __user *cookie;
+			userptr32_t cookie;
 			struct binder_ref *ref;
 			struct binder_ref_death *death;
 
 			if (get_user(target, (uint32_t __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(uint32_t);
-			if (get_user(cookie, (void __user * __user *)ptr))
+			if (get_user(cookie, (userptr32_t __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(void *);
+			ptr += sizeof(userptr32_t);
 			ref = binder_get_ref(proc, target);
 			if (ref == NULL) {
 				binder_user_error("binder: %d:%d %s "
@@ -1965,7 +1980,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			}
 
 			binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
-				     "binder: %d:%d %s %p ref %d desc %d s %d w %d for node %d\n",
+				     "binder: %d:%d %s %x ref %d desc %d s %d w %d for node %d\n",
 				     proc->pid, thread->pid,
 				     cmd == BC_REQUEST_DEATH_NOTIFICATION ?
 				     "BC_REQUEST_DEATH_NOTIFICATION" :
@@ -2019,7 +2034,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 						"d BC_CLEAR_DEATH_NOTIFI"
 						"CATION death notificat"
 						"ion cookie mismatch "
-						"%p != %p\n",
+						"%x != %x\n",
 						proc->pid, thread->pid,
 						death->cookie, cookie);
 					break;
@@ -2039,14 +2054,13 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				}
 			}
 		} break;
-		case BC_DEAD_BINDER_DONE: {
+		case _IOC_NR(BC_DEAD_BINDER_DONE): {
 			struct binder_work *w;
-			void __user *cookie;
+			userptr32_t cookie;
 			struct binder_ref_death *death = NULL;
-			if (get_user(cookie, (void __user * __user *)ptr))
+			if (get_user(cookie, (userptr32_t __user *)ptr))
 				return -EFAULT;
-
-			ptr += sizeof(void *);
+			ptr += sizeof(userptr32_t);
 			list_for_each_entry(w, &proc->delivered_death, entry) {
 				struct binder_ref_death *tmp_death = container_of(w, struct binder_ref_death, work);
 				if (tmp_death->cookie == cookie) {
@@ -2055,11 +2069,11 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				}
 			}
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "binder: %d:%d BC_DEAD_BINDER_DONE %p found %p\n",
+				     "binder: %d:%d BC_DEAD_BINDER_DONE %x found %p\n",
 				     proc->pid, thread->pid, cookie, death);
 			if (death == NULL) {
 				binder_user_error("binder: %d:%d BC_DEAD"
-					"_BINDER_DONE %p not found\n",
+					"_BINDER_DONE %x not found\n",
 					proc->pid, thread->pid, cookie);
 				break;
 			}
@@ -2112,7 +2126,7 @@ static int binder_has_thread_work(struct binder_thread *thread)
 static int binder_thread_read(struct binder_proc *proc,
 			      struct binder_thread *thread,
 			      void  __user *buffer, int size,
-			      signed long *consumed, int non_block)
+			      int *consumed, int non_block)
 {
 	void __user *ptr = buffer + *consumed;
 	void __user *end = buffer + size;
@@ -2251,22 +2265,22 @@ retry:
 				if (put_user(cmd, (uint32_t __user *)ptr))
 					return -EFAULT;
 				ptr += sizeof(uint32_t);
-				if (put_user(node->ptr, (void * __user *)ptr))
+				if (put_user((unsigned long)node->ptr, (userptr32_t __user *)ptr))
 					return -EFAULT;
-				ptr += sizeof(void *);
-				if (put_user(node->cookie, (void * __user *)ptr))
+				ptr += sizeof(userptr32_t);
+				if (put_user((unsigned long)node->cookie, (userptr32_t __user *)ptr))
 					return -EFAULT;
-				ptr += sizeof(void *);
+				ptr += sizeof(userptr32_t);
 
 				binder_stat_br(proc, thread, cmd);
 				binder_debug(BINDER_DEBUG_USER_REFS,
-					     "binder: %d:%d %s %d u%p c%p\n",
+					     "binder: %d:%d %s %d u%x c%x\n",
 					     proc->pid, thread->pid, cmd_name, node->debug_id, node->ptr, node->cookie);
 			} else {
 				list_del_init(&w->entry);
 				if (!weak && !strong) {
 					binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-						     "binder: %d:%d node %d u%p c%p deleted\n",
+						     "binder: %d:%d node %d u%x c%x deleted\n",
 						     proc->pid, thread->pid, node->debug_id,
 						     node->ptr, node->cookie);
 					rb_erase(&node->rb_node, &proc->nodes);
@@ -2274,7 +2288,7 @@ retry:
 					binder_stats_deleted(BINDER_STAT_NODE);
 				} else {
 					binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-						     "binder: %d:%d node %d u%p c%p state unchanged\n",
+						     "binder: %d:%d node %d u%x c%x state unchanged\n",
 						     proc->pid, thread->pid, node->debug_id, node->ptr,
 						     node->cookie);
 				}
@@ -2294,11 +2308,11 @@ retry:
 			if (put_user(cmd, (uint32_t __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(uint32_t);
-			if (put_user(death->cookie, (void * __user *)ptr))
+			if (put_user((unsigned long)death->cookie, (userptr32_t __user *)ptr))
 				return -EFAULT;
-			ptr += sizeof(void *);
+			ptr += sizeof(userptr32_t);
 			binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
-				     "binder: %d:%d %s %p\n",
+				     "binder: %d:%d %s %x\n",
 				      proc->pid, thread->pid,
 				      cmd == BR_DEAD_BINDER ?
 				      "BR_DEAD_BINDER" :
@@ -2333,8 +2347,8 @@ retry:
 				binder_set_nice(target_node->min_priority);
 			cmd = BR_TRANSACTION;
 		} else {
-			tr.target.ptr = NULL;
-			tr.cookie = NULL;
+			tr.target.ptr = 0;
+			tr.cookie = 0;
 			cmd = BR_REPLY;
 		}
 		tr.code = t->code;
@@ -2349,13 +2363,14 @@ retry:
 			tr.sender_pid = 0;
 		}
 
-		tr.data_size = t->buffer->data_size;
-		tr.offsets_size = t->buffer->offsets_size;
-		tr.data.ptr.buffer = (void *)t->buffer->data +
-					proc->user_buffer_offset;
-		tr.data.ptr.offsets = tr.data.ptr.buffer +
+		tr.data_size = (userptr32_t)t->buffer->data_size;
+		tr.offsets_size = (userptr32_t)t->buffer->offsets_size;
+		tr.data.ptr.buffer = (unsigned long)((void *)t->buffer->data +
+					proc->user_buffer_offset);
+
+		tr.data.ptr.offsets = (userptr32_t)(tr.data.ptr.buffer +
 					ALIGN(t->buffer->data_size,
-					    sizeof(void *));
+					    sizeof(userptr32_t)));
 
 		if (put_user(cmd, (uint32_t __user *)ptr))
 			return -EFAULT;
@@ -2367,7 +2382,7 @@ retry:
 		binder_stat_br(proc, thread, cmd);
 		binder_debug(BINDER_DEBUG_TRANSACTION,
 			     "binder: %d:%d %s %d %d:%d, cmd %d"
-			     "size %zd-%zd ptr %p-%p\n",
+			     "size %zd-%zd ptr %x-%x\n",
 			     proc->pid, thread->pid,
 			     (cmd == BR_TRANSACTION) ? "BR_TRANSACTION" :
 			     "BR_REPLY",
@@ -2584,10 +2599,16 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		goto err;
 	}
 
-	switch (cmd) {
-	case BINDER_WRITE_READ: {
+	/*
+	 * since  the transaction's IOCTL number are generated using
+	 * _IOC(dir,type,nr,size), a different userspace size will not
+	 * fall through
+	 */
+	switch (_IOC_NR(cmd)) {
+	case _IOC_NR(BINDER_WRITE_READ): {
 		struct binder_write_read bwr;
 		if (size != sizeof(struct binder_write_read)) {
+			pr_err("binder: BINDER_WRITE_READ transaction size differs\n");
 			ret = -EINVAL;
 			goto err;
 		}
@@ -2596,12 +2617,12 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto err;
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "binder: %d:%d write %ld at %08lx, read %ld at %08lx\n",
+			     "binder: %d:%d write %d at %08x, read %d at %08x\n",
 			     proc->pid, thread->pid, bwr.write_size, bwr.write_buffer,
 			     bwr.read_size, bwr.read_buffer);
 
 		if (bwr.write_size > 0) {
-			ret = binder_thread_write(proc, thread, (void __user *)bwr.write_buffer, bwr.write_size, &bwr.write_consumed);
+			ret = binder_thread_write(proc, thread, (void __user *)(unsigned long)(bwr.write_buffer), bwr.write_size, &bwr.write_consumed);
 			if (ret < 0) {
 				bwr.read_consumed = 0;
 				if (copy_to_user(ubuf, &bwr, sizeof(bwr)))
@@ -2610,7 +2631,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		}
 		if (bwr.read_size > 0) {
-			ret = binder_thread_read(proc, thread, (void __user *)bwr.read_buffer, bwr.read_size, &bwr.read_consumed, filp->f_flags & O_NONBLOCK);
+			ret = binder_thread_read(proc, thread, (void __user *)(unsigned long)(bwr.read_buffer), bwr.read_size, &bwr.read_consumed, filp->f_flags & O_NONBLOCK);
 			if (!list_empty(&proc->todo))
 				wake_up_interruptible(&proc->wait);
 			if (ret < 0) {
@@ -2620,7 +2641,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "binder: %d:%d wrote %ld of %ld, read return %ld of %ld\n",
+			     "binder: %d:%d wrote %d of %d, read return %d of %d\n",
 			     proc->pid, thread->pid, bwr.write_consumed, bwr.write_size,
 			     bwr.read_consumed, bwr.read_size);
 		if (copy_to_user(ubuf, &bwr, sizeof(bwr))) {
@@ -2629,13 +2650,13 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 		break;
 	}
-	case BINDER_SET_MAX_THREADS:
+	case _IOC_NR(BINDER_SET_MAX_THREADS):
 		if (copy_from_user(&proc->max_threads, ubuf, sizeof(proc->max_threads))) {
 			ret = -EINVAL;
 			goto err;
 		}
 		break;
-	case BINDER_SET_CONTEXT_MGR:
+	case _IOC_NR(BINDER_SET_CONTEXT_MGR):
 		if (binder_context_mgr_node != NULL) {
 			pr_err("binder: BINDER_SET_CONTEXT_MGR already set\n");
 			ret = -EBUSY;
@@ -2652,7 +2673,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		} else
 			binder_context_mgr_uid = current->cred->euid;
-		binder_context_mgr_node = binder_new_node(proc, NULL, NULL);
+		binder_context_mgr_node = binder_new_node(proc, 0, 0);
 		if (binder_context_mgr_node == NULL) {
 			ret = -ENOMEM;
 			goto err;
@@ -2662,14 +2683,15 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		binder_context_mgr_node->has_strong_ref = 1;
 		binder_context_mgr_node->has_weak_ref = 1;
 		break;
-	case BINDER_THREAD_EXIT:
+	case _IOC_NR(BINDER_THREAD_EXIT):
 		binder_debug(BINDER_DEBUG_THREADS, "binder: %d:%d exit\n",
 			     proc->pid, thread->pid);
 		binder_free_thread(proc, thread);
 		thread = NULL;
 		break;
-	case BINDER_VERSION:
+	case _IOC_NR(BINDER_VERSION):
 		if (size != sizeof(struct binder_version)) {
+			pr_err("binder: BINDER_VERSION size differs\n");
 			ret = -EINVAL;
 			goto err;
 		}
@@ -2679,6 +2701,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 		break;
 	default:
+		pr_err("binder: IOCTL No. not found\n");
 		ret = -EINVAL;
 		goto err;
 	}
@@ -3074,7 +3097,7 @@ static void print_binder_transaction(struct seq_file *m, const char *prefix,
 				     struct binder_transaction *t)
 {
 	seq_printf(m,
-		   "%s %d: %p from %d:%d to %d:%d code %x flags %x pri %ld r%d",
+		   "%s %d: %p from %d:%d to %d:%d code %x flags %x pri %d r%d",
 		   prefix, t->debug_id, t,
 		   t->from ? t->from->proc->pid : 0,
 		   t->from ? t->from->pid : 0,
@@ -3119,7 +3142,7 @@ static void print_binder_work(struct seq_file *m, const char *prefix,
 		break;
 	case BINDER_WORK_NODE:
 		node = container_of(w, struct binder_node, work);
-		seq_printf(m, "%snode work %d: u%p c%p\n",
+		seq_printf(m, "%snode work %d: u%x c%x\n",
 			   prefix, node->debug_id, node->ptr, node->cookie);
 		break;
 	case BINDER_WORK_DEAD_BINDER:
@@ -3181,7 +3204,7 @@ static void print_binder_node(struct seq_file *m, struct binder_node *node)
 	hlist_for_each_entry(ref, pos, &node->refs, node_entry)
 		count++;
 
-	seq_printf(m, "  node %d: u%p c%p hs %d hw %d ls %d lw %d is %d iw %d",
+	seq_printf(m, "  node %d: u%x c%x hs %d hw %d ls %d lw %d is %d iw %d",
 		   node->debug_id, node->ptr, node->cookie,
 		   node->has_strong_ref, node->has_weak_ref,
 		   node->local_strong_refs, node->local_weak_refs,
@@ -3487,6 +3510,7 @@ static const struct file_operations binder_fops = {
 	.owner = THIS_MODULE,
 	.poll = binder_poll,
 	.unlocked_ioctl = binder_ioctl,
+	.compat_ioctl = binder_ioctl,	/* handler for 32-bit compat layer */
 	.mmap = binder_mmap,
 	.open = binder_open,
 	.flush = binder_flush,
diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index 2f7d195..982b30d 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -26,6 +26,8 @@
 	((((c1)<<24)) | (((c2)<<16)) | (((c3)<<8)) | (c4))
 #define B_TYPE_LARGE 0x85
 
+typedef uint32_t userptr32_t;
+
 enum {
 	BINDER_TYPE_BINDER	= B_PACK_CHARS('s', 'b', '*', B_TYPE_LARGE),
 	BINDER_TYPE_WEAK_BINDER	= B_PACK_CHARS('w', 'b', '*', B_TYPE_LARGE),
@@ -48,17 +50,17 @@ enum {
  */
 struct flat_binder_object {
 	/* 8 bytes for large_flat_header. */
-	unsigned long		type;
-	unsigned long		flags;
+	uint32_t		type;
+	uint32_t		flags;
 
 	/* 8 bytes of data. */
 	union {
-		void __user	*binder;	/* local object */
-		signed long	handle;		/* remote object */
+		userptr32_t	binder;		/* local object */
+		int32_t		handle;		/* remote object */
 	};
 
 	/* extra data associated with local object */
-	void __user		*cookie;
+	userptr32_t		cookie;
 };
 
 /*
@@ -67,18 +69,18 @@ struct flat_binder_object {
  */
 
 struct binder_write_read {
-	signed long	write_size;	/* bytes to write */
-	signed long	write_consumed;	/* bytes consumed by driver */
-	unsigned long	write_buffer;
-	signed long	read_size;	/* bytes to read */
-	signed long	read_consumed;	/* bytes consumed by driver */
-	unsigned long	read_buffer;
+	int32_t		write_size;	/* bytes to write */
+	int32_t		write_consumed;	/* bytes consumed by driver */
+	uint32_t	write_buffer;
+	int32_t		read_size;	/* bytes to read */
+	int32_t		read_consumed;	/* bytes consumed by driver */
+	uint32_t	read_buffer;
 };
 
 /* Use with BINDER_VERSION, driver fills in fields. */
 struct binder_version {
 	/* driver protocol version -- increment with incompatible change */
-	signed long	protocol_version;
+	int32_t		protocol_version;
 };
 
 /* This is the current protocol version. */
@@ -86,7 +88,7 @@ struct binder_version {
 
 #define BINDER_WRITE_READ		_IOWR('b', 1, struct binder_write_read)
 #define	BINDER_SET_IDLE_TIMEOUT		_IOW('b', 3, int64_t)
-#define	BINDER_SET_MAX_THREADS		_IOW('b', 5, size_t)
+#define	BINDER_SET_MAX_THREADS		_IOW('b', 5, uint32_t)
 #define	BINDER_SET_IDLE_PRIORITY	_IOW('b', 6, int)
 #define	BINDER_SET_CONTEXT_MGR		_IOW('b', 7, int)
 #define	BINDER_THREAD_EXIT		_IOW('b', 8, int)
@@ -119,18 +121,18 @@ struct binder_transaction_data {
 	 * identifying the target and contents of the transaction.
 	 */
 	union {
-		size_t	handle;	/* target descriptor of command transaction */
-		void	*ptr;	/* target descriptor of return transaction */
+		uint32_t	handle;	/* target descriptor of command transaction */
+		userptr32_t	ptr;	/* target descriptor of return transaction */
 	} target;
-	void		*cookie;	/* target object cookie */
+	userptr32_t     cookie;	/* target object cookie */
 	unsigned int	code;		/* transaction command */
 
 	/* General information about the transaction. */
 	unsigned int	flags;
 	pid_t		sender_pid;
 	uid_t		sender_euid;
-	size_t		data_size;	/* number of bytes of data */
-	size_t		offsets_size;	/* number of bytes of offsets */
+	uint32_t	data_size;	/* number of bytes of data */
+	uint32_t	offsets_size;	/* number of bytes of offsets */
 
 	/* If this transaction is inline, the data immediately
 	 * follows here; otherwise, it ends with a pointer to
@@ -139,17 +141,17 @@ struct binder_transaction_data {
 	union {
 		struct {
 			/* transaction data */
-			const void __user	*buffer;
+			userptr32_t	buffer;
 			/* offsets from buffer to flat_binder_object structs */
-			const void __user	*offsets;
+			userptr32_t 	offsets;
 		} ptr;
 		uint8_t	buf[8];
 	} data;
 };
 
 struct binder_ptr_cookie {
-	void *ptr;
-	void *cookie;
+	userptr32_t tr;
+	userptr32_t cookie;
 };
 
 struct binder_pri_desc {
@@ -159,8 +161,8 @@ struct binder_pri_desc {
 
 struct binder_pri_ptr_cookie {
 	int priority;
-	void *ptr;
-	void *cookie;
+	userptr32_t ptr;
+	userptr32_t cookie;
 };
 
 enum BinderDriverReturnProtocol {
@@ -235,11 +237,11 @@ enum BinderDriverReturnProtocol {
 	 * stop threadpool thread
 	 */
 
-	BR_DEAD_BINDER = _IOR('r', 15, void *),
+	BR_DEAD_BINDER = _IOR('r', 15, userptr32_t),
 	/*
 	 * void *: cookie
 	 */
-	BR_CLEAR_DEATH_NOTIFICATION_DONE = _IOR('r', 16, void *),
+	BR_CLEAR_DEATH_NOTIFICATION_DONE = _IOR('r', 16, userptr32_t),
 	/*
 	 * void *: cookie
 	 */
@@ -320,7 +322,7 @@ enum BinderDriverCommandProtocol {
 	 * void *: cookie
 	 */
 
-	BC_DEAD_BINDER_DONE = _IOW('c', 16, void *),
+	BC_DEAD_BINDER_DONE = _IOW('c', 16, userptr32_t),
 	/*
 	 * void *: cookie
 	 */
-- 
1.7.9.5

