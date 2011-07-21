Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1GUQFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:05:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab1GUQEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:04:14 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] dlm: use workqueue for callbacks
Date: Thu, 21 Jul 2011 11:04:06 -0500
Message-Id: <1311264247-28129-10-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of creating our own kthread (dlm_astd) to deliver
callbacks for all lockspaces, use a per-lockspace workqueue
to deliver the callbacks.  This eliminates complications and
slowdowns from many lockspaces sharing the same thread.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/ast.c          |  262 +++++++++++++++++++++----------------------------
 fs/dlm/ast.h          |   15 ++--
 fs/dlm/dlm_internal.h |    9 ++-
 fs/dlm/lock.c         |   24 +++---
 fs/dlm/lockspace.c    |   43 ++++----
 fs/dlm/recoverd.c     |   12 +--
 fs/dlm/user.c         |   12 +-
 7 files changed, 172 insertions(+), 205 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index abc49f2..4f29add 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -14,17 +14,9 @@
 #include "dlm_internal.h"
 #include "lock.h"
 #include "user.h"
-#include "ast.h"
-
-#define WAKE_ASTS  0
-
-static uint64_t			ast_seq_count;
-static struct list_head		ast_queue;
-static spinlock_t		ast_queue_lock;
-static struct task_struct *	astd_task;
-static unsigned long		astd_wakeflags;
-static struct mutex		astd_running;
 
+static uint64_t			dlm_cb_seq;
+static spinlock_t		dlm_cb_seq_spin;
 
 static void dlm_dump_lkb_callbacks(struct dlm_lkb *lkb)
 {
@@ -57,21 +49,13 @@ static void dlm_dump_lkb_callbacks(struct dlm_lkb *lkb)
 	}
 }
 
-void dlm_del_ast(struct dlm_lkb *lkb)
-{
-	spin_lock(&ast_queue_lock);
-	if (!list_empty(&lkb->lkb_astqueue))
-		list_del_init(&lkb->lkb_astqueue);
-	spin_unlock(&ast_queue_lock);
-}
-
 int dlm_add_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 			 int status, uint32_t sbflags, uint64_t seq)
 {
 	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
 	uint64_t prev_seq;
 	int prev_mode;
-	int i;
+	int i, rv;
 
 	for (i = 0; i < DLM_CALLBACKS_SIZE; i++) {
 		if (lkb->lkb_callbacks[i].seq)
@@ -100,7 +84,8 @@ int dlm_add_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 					  mode,
 					  (unsigned long long)prev_seq,
 					  prev_mode);
-				return 0;
+				rv = 0;
+				goto out;
 			}
 		}
 
@@ -109,6 +94,7 @@ int dlm_add_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 		lkb->lkb_callbacks[i].mode = mode;
 		lkb->lkb_callbacks[i].sb_status = status;
 		lkb->lkb_callbacks[i].sb_flags = (sbflags & 0x000000FF);
+		rv = 0;
 		break;
 	}
 
@@ -117,21 +103,24 @@ int dlm_add_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 			  lkb->lkb_id, (unsigned long long)seq,
 			  flags, mode, status, sbflags);
 		dlm_dump_lkb_callbacks(lkb);
-		return -1;
+		rv = -1;
+		goto out;
 	}
-
-	return 0;
+ out:
+	return rv;
 }
 
 int dlm_rem_lkb_callback(struct dlm_ls *ls, struct dlm_lkb *lkb,
 			 struct dlm_callback *cb, int *resid)
 {
-	int i;
+	int i, rv;
 
 	*resid = 0;
 
-	if (!lkb->lkb_callbacks[0].seq)
-		return -ENOENT;
+	if (!lkb->lkb_callbacks[0].seq) {
+		rv = -ENOENT;
+		goto out;
+	}
 
 	/* oldest undelivered cb is callbacks[0] */
 
@@ -163,7 +152,8 @@ int dlm_rem_lkb_callback(struct dlm_ls *ls, struct dlm_lkb *lkb,
 				  cb->mode,
 				  (unsigned long long)lkb->lkb_last_cast.seq,
 				  lkb->lkb_last_cast.mode);
-			return 0;
+			rv = 0;
+			goto out;
 		}
 	}
 
@@ -176,171 +166,147 @@ int dlm_rem_lkb_callback(struct dlm_ls *ls, struct dlm_lkb *lkb,
 		memcpy(&lkb->lkb_last_bast, cb, sizeof(struct dlm_callback));
 		lkb->lkb_last_bast_time = ktime_get();
 	}
-
-	return 0;
+	rv = 0;
+ out:
+	return rv;
 }
 
-void dlm_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
-		 uint32_t sbflags)
+void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
+		uint32_t sbflags)
 {
-	uint64_t seq;
+	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
+	uint64_t new_seq, prev_seq;
 	int rv;
 
-	spin_lock(&ast_queue_lock);
-
-	seq = ++ast_seq_count;
+	spin_lock(&dlm_cb_seq_spin);
+	new_seq = ++dlm_cb_seq;
+	spin_unlock(&dlm_cb_seq_spin);
 
 	if (lkb->lkb_flags & DLM_IFL_USER) {
-		spin_unlock(&ast_queue_lock);
-		dlm_user_add_ast(lkb, flags, mode, status, sbflags, seq);
+		dlm_user_add_ast(lkb, flags, mode, status, sbflags, new_seq);
 		return;
 	}
 
-	rv = dlm_add_lkb_callback(lkb, flags, mode, status, sbflags, seq);
-	if (rv < 0) {
-		spin_unlock(&ast_queue_lock);
-		return;
-	}
+	mutex_lock(&lkb->lkb_cb_mutex);
+	prev_seq = lkb->lkb_callbacks[0].seq;
 
-	if (list_empty(&lkb->lkb_astqueue)) {
+	rv = dlm_add_lkb_callback(lkb, flags, mode, status, sbflags, new_seq);
+	if (rv < 0)
+		goto out;
+
+	if (!prev_seq) {
 		kref_get(&lkb->lkb_ref);
-		list_add_tail(&lkb->lkb_astqueue, &ast_queue);
-	}
-	spin_unlock(&ast_queue_lock);
 
-	set_bit(WAKE_ASTS, &astd_wakeflags);
-	wake_up_process(astd_task);
+		if (test_bit(LSFL_CB_DELAY, &ls->ls_flags)) {
+			mutex_lock(&ls->ls_cb_mutex);
+			list_add(&lkb->lkb_cb_list, &ls->ls_cb_delay);
+			mutex_unlock(&ls->ls_cb_mutex);
+		} else {
+			queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
+		}
+	}
+ out:
+	mutex_unlock(&lkb->lkb_cb_mutex);
 }
 
-static void process_asts(void)
+void dlm_callback_work(struct work_struct *work)
 {
-	struct dlm_ls *ls = NULL;
-	struct dlm_rsb *r = NULL;
-	struct dlm_lkb *lkb;
+	struct dlm_lkb *lkb = container_of(work, struct dlm_lkb, lkb_cb_work);
+	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
 	void (*castfn) (void *astparam);
 	void (*bastfn) (void *astparam, int mode);
 	struct dlm_callback callbacks[DLM_CALLBACKS_SIZE];
 	int i, rv, resid;
 
-repeat:
-	spin_lock(&ast_queue_lock);
-	list_for_each_entry(lkb, &ast_queue, lkb_astqueue) {
-		r = lkb->lkb_resource;
-		ls = r->res_ls;
+	memset(&callbacks, 0, sizeof(callbacks));
 
-		if (dlm_locking_stopped(ls))
-			continue;
-
-		/* we remove from astqueue list and remove everything in
-		   lkb_callbacks before releasing the spinlock so empty
-		   lkb_astqueue is always consistent with empty lkb_callbacks */
-
-		list_del_init(&lkb->lkb_astqueue);
-
-		castfn = lkb->lkb_astfn;
-		bastfn = lkb->lkb_bastfn;
+	mutex_lock(&lkb->lkb_cb_mutex);
+	if (!lkb->lkb_callbacks[0].seq) {
+		/* no callback work exists, shouldn't happen */
+		log_error(ls, "dlm_callback_work %x no work", lkb->lkb_id);
+		dlm_print_lkb(lkb);
+		dlm_dump_lkb_callbacks(lkb);
+	}
 
-		memset(&callbacks, 0, sizeof(callbacks));
+	for (i = 0; i < DLM_CALLBACKS_SIZE; i++) {
+		rv = dlm_rem_lkb_callback(ls, lkb, &callbacks[i], &resid);
+		if (rv < 0)
+			break;
+	}
 
-		for (i = 0; i < DLM_CALLBACKS_SIZE; i++) {
-			rv = dlm_rem_lkb_callback(ls, lkb, &callbacks[i], &resid);
-			if (rv < 0)
-				break;
-		}
-		spin_unlock(&ast_queue_lock);
+	if (resid) {
+		/* cbs remain, loop should have removed all, shouldn't happen */
+		log_error(ls, "dlm_callback_work %x resid %d", lkb->lkb_id,
+			  resid);
+		dlm_print_lkb(lkb);
+		dlm_dump_lkb_callbacks(lkb);
+	}
+	mutex_unlock(&lkb->lkb_cb_mutex);
 
-		if (resid) {
-			/* shouldn't happen, for loop should have removed all */
-			log_error(ls, "callback resid %d lkb %x",
-				  resid, lkb->lkb_id);
-		}
+	castfn = lkb->lkb_astfn;
+	bastfn = lkb->lkb_bastfn;
 
-		for (i = 0; i < DLM_CALLBACKS_SIZE; i++) {
-			if (!callbacks[i].seq)
-				break;
-			if (callbacks[i].flags & DLM_CB_SKIP) {
-				continue;
-			} else if (callbacks[i].flags & DLM_CB_BAST) {
-				bastfn(lkb->lkb_astparam, callbacks[i].mode);
-			} else if (callbacks[i].flags & DLM_CB_CAST) {
-				lkb->lkb_lksb->sb_status = callbacks[i].sb_status;
-				lkb->lkb_lksb->sb_flags = callbacks[i].sb_flags;
-				castfn(lkb->lkb_astparam);
-			}
+	for (i = 0; i < DLM_CALLBACKS_SIZE; i++) {
+		if (!callbacks[i].seq)
+			break;
+		if (callbacks[i].flags & DLM_CB_SKIP) {
+			continue;
+		} else if (callbacks[i].flags & DLM_CB_BAST) {
+			bastfn(lkb->lkb_astparam, callbacks[i].mode);
+		} else if (callbacks[i].flags & DLM_CB_CAST) {
+			lkb->lkb_lksb->sb_status = callbacks[i].sb_status;
+			lkb->lkb_lksb->sb_flags = callbacks[i].sb_flags;
+			castfn(lkb->lkb_astparam);
 		}
-
-		/* removes ref for ast_queue, may cause lkb to be freed */
-		dlm_put_lkb(lkb);
-
-		cond_resched();
-		goto repeat;
 	}
-	spin_unlock(&ast_queue_lock);
-}
-
-static inline int no_asts(void)
-{
-	int ret;
 
-	spin_lock(&ast_queue_lock);
-	ret = list_empty(&ast_queue);
-	spin_unlock(&ast_queue_lock);
-	return ret;
+	/* undo kref_get from dlm_add_callback, may cause lkb to be freed */
+	dlm_put_lkb(lkb);
 }
 
-static int dlm_astd(void *data)
+int dlm_callback_start(struct dlm_ls *ls)
 {
-	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (!test_bit(WAKE_ASTS, &astd_wakeflags))
-			schedule();
-		set_current_state(TASK_RUNNING);
-
-		mutex_lock(&astd_running);
-		if (test_and_clear_bit(WAKE_ASTS, &astd_wakeflags))
-			process_asts();
-		mutex_unlock(&astd_running);
+	ls->ls_callback_wq = alloc_workqueue("dlm_callback",
+					     WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
+	if (!ls->ls_callback_wq) {
+		log_print("can't start dlm_callback workqueue");
+		return -ENOMEM;
 	}
 	return 0;
 }
 
-void dlm_astd_wake(void)
+void dlm_callback_stop(struct dlm_ls *ls)
 {
-	if (!no_asts()) {
-		set_bit(WAKE_ASTS, &astd_wakeflags);
-		wake_up_process(astd_task);
-	}
+	if (ls->ls_callback_wq)
+		destroy_workqueue(ls->ls_callback_wq);
 }
 
-int dlm_astd_start(void)
+void dlm_callback_suspend(struct dlm_ls *ls)
 {
-	struct task_struct *p;
-	int error = 0;
-
-	INIT_LIST_HEAD(&ast_queue);
-	spin_lock_init(&ast_queue_lock);
-	mutex_init(&astd_running);
-
-	p = kthread_run(dlm_astd, NULL, "dlm_astd");
-	if (IS_ERR(p))
-		error = PTR_ERR(p);
-	else
-		astd_task = p;
-	return error;
-}
+	set_bit(LSFL_CB_DELAY, &ls->ls_flags);
 
-void dlm_astd_stop(void)
-{
-	kthread_stop(astd_task);
+	if (ls->ls_callback_wq)
+		flush_workqueue(ls->ls_callback_wq);
 }
 
-void dlm_astd_suspend(void)
+void dlm_callback_resume(struct dlm_ls *ls)
 {
-	mutex_lock(&astd_running);
-}
+	struct dlm_lkb *lkb, *safe;
+	int count = 0;
 
-void dlm_astd_resume(void)
-{
-	mutex_unlock(&astd_running);
+	clear_bit(LSFL_CB_DELAY, &ls->ls_flags);
+
+	if (!ls->ls_callback_wq)
+		return;
+
+	mutex_lock(&ls->ls_cb_mutex);
+	list_for_each_entry_safe(lkb, safe, &ls->ls_cb_delay, lkb_cb_list) {
+		list_del_init(&lkb->lkb_cb_list);
+		queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
+		count++;
+	}
+	mutex_unlock(&ls->ls_cb_mutex);
+
+	log_debug(ls, "dlm_callback_resume %d", count);
 }
 
diff --git a/fs/dlm/ast.h b/fs/dlm/ast.h
index 8aa89c9..757b551 100644
--- a/fs/dlm/ast.h
+++ b/fs/dlm/ast.h
@@ -18,14 +18,15 @@ int dlm_add_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
                          int status, uint32_t sbflags, uint64_t seq);
 int dlm_rem_lkb_callback(struct dlm_ls *ls, struct dlm_lkb *lkb,
                          struct dlm_callback *cb, int *resid);
-void dlm_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
-		 uint32_t sbflags);
+void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
+                uint32_t sbflags);
 
-void dlm_astd_wake(void);
-int dlm_astd_start(void);
-void dlm_astd_stop(void);
-void dlm_astd_suspend(void);
-void dlm_astd_resume(void);
+void dlm_callback_work(struct work_struct *work);
+int dlm_callback_start(struct dlm_ls *ls);
+void dlm_callback_stop(struct dlm_ls *ls);
+void dlm_callback_suspend(struct dlm_ls *ls);
+void dlm_callback_resume(struct dlm_ls *ls);
 
 #endif
 
+
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 6614f33..fe2860c 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -246,13 +246,15 @@ struct dlm_lkb {
 	struct list_head	lkb_statequeue;	/* rsb g/c/w list */
 	struct list_head	lkb_rsb_lookup;	/* waiting for rsb lookup */
 	struct list_head	lkb_wait_reply;	/* waiting for remote reply */
-	struct list_head	lkb_astqueue;	/* need ast to be sent */
 	struct list_head	lkb_ownqueue;	/* list of locks for a process */
 	struct list_head	lkb_time_list;
 	ktime_t			lkb_timestamp;
 	ktime_t			lkb_wait_time;
 	unsigned long		lkb_timeout_cs;
 
+	struct mutex		lkb_cb_mutex;
+	struct work_struct	lkb_cb_work;
+	struct list_head	lkb_cb_list; /* for ls_cb_delay or proc->asts */
 	struct dlm_callback	lkb_callbacks[DLM_CALLBACKS_SIZE];
 	struct dlm_callback	lkb_last_cast;
 	struct dlm_callback	lkb_last_bast;
@@ -504,8 +506,12 @@ struct dlm_ls {
 
 	struct miscdevice       ls_device;
 
+	struct workqueue_struct	*ls_callback_wq;
+
 	/* recovery related */
 
+	struct mutex		ls_cb_mutex;
+	struct list_head	ls_cb_delay; /* save for queue_work later */
 	struct timer_list	ls_timer;
 	struct task_struct	*ls_recoverd_task;
 	struct mutex		ls_recoverd_active;
@@ -542,6 +548,7 @@ struct dlm_ls {
 #define LSFL_RCOM_WAIT		4
 #define LSFL_UEVENT_WAIT	5
 #define LSFL_TIMEWARN		6
+#define LSFL_CB_DELAY		7
 
 /* much of this is just saving user space pointers associated with the
    lock that we pass back to the user lib with an ast */
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 6772e5c..83b5e32 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -305,7 +305,7 @@ static void queue_cast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rv)
 		rv = -EDEADLK;
 	}
 
-	dlm_add_ast(lkb, DLM_CB_CAST, lkb->lkb_grmode, rv, lkb->lkb_sbflags);
+	dlm_add_cb(lkb, DLM_CB_CAST, lkb->lkb_grmode, rv, lkb->lkb_sbflags);
 }
 
 static inline void queue_cast_overlap(struct dlm_rsb *r, struct dlm_lkb *lkb)
@@ -319,7 +319,7 @@ static void queue_bast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rqmode)
 	if (is_master_copy(lkb)) {
 		send_bast(r, lkb, rqmode);
 	} else {
-		dlm_add_ast(lkb, DLM_CB_BAST, rqmode, 0, 0);
+		dlm_add_cb(lkb, DLM_CB_BAST, rqmode, 0, 0);
 	}
 }
 
@@ -638,7 +638,9 @@ static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 	INIT_LIST_HEAD(&lkb->lkb_ownqueue);
 	INIT_LIST_HEAD(&lkb->lkb_rsb_lookup);
 	INIT_LIST_HEAD(&lkb->lkb_time_list);
-	INIT_LIST_HEAD(&lkb->lkb_astqueue);
+	INIT_LIST_HEAD(&lkb->lkb_cb_list);
+	mutex_init(&lkb->lkb_cb_mutex);
+	INIT_WORK(&lkb->lkb_cb_work, dlm_callback_work);
 
  retry:
 	rv = idr_pre_get(&ls->ls_lkbidr, GFP_NOFS);
@@ -4010,8 +4012,6 @@ static void _receive_message(struct dlm_ls *ls, struct dlm_message *ms)
 	default:
 		log_error(ls, "unknown message type %d", ms->m_type);
 	}
-
-	dlm_astd_wake();
 }
 
 /* If the lockspace is in recovery mode (locking stopped), then normal
@@ -4826,7 +4826,7 @@ int dlm_user_unlock(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 		goto out_put;
 
 	spin_lock(&ua->proc->locks_spin);
-	/* dlm_user_add_ast() may have already taken lkb off the proc list */
+	/* dlm_user_add_cb() may have already taken lkb off the proc list */
 	if (!list_empty(&lkb->lkb_ownqueue))
 		list_move(&lkb->lkb_ownqueue, &ua->proc->unlocking);
 	spin_unlock(&ua->proc->locks_spin);
@@ -4963,7 +4963,7 @@ static int unlock_proc_lock(struct dlm_ls *ls, struct dlm_lkb *lkb)
 
 /* We have to release clear_proc_locks mutex before calling unlock_proc_lock()
    (which does lock_rsb) due to deadlock with receiving a message that does
-   lock_rsb followed by dlm_user_add_ast() */
+   lock_rsb followed by dlm_user_add_cb() */
 
 static struct dlm_lkb *del_proc_lock(struct dlm_ls *ls,
 				     struct dlm_user_proc *proc)
@@ -4986,7 +4986,7 @@ static struct dlm_lkb *del_proc_lock(struct dlm_ls *ls,
 	return lkb;
 }
 
-/* The ls_clear_proc_locks mutex protects against dlm_user_add_asts() which
+/* The ls_clear_proc_locks mutex protects against dlm_user_add_cb() which
    1) references lkb->ua which we free here and 2) adds lkbs to proc->asts,
    which we clear here. */
 
@@ -5028,10 +5028,10 @@ void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 		dlm_put_lkb(lkb);
 	}
 
-	list_for_each_entry_safe(lkb, safe, &proc->asts, lkb_astqueue) {
+	list_for_each_entry_safe(lkb, safe, &proc->asts, lkb_cb_list) {
 		memset(&lkb->lkb_callbacks, 0,
 		       sizeof(struct dlm_callback) * DLM_CALLBACKS_SIZE);
-		list_del_init(&lkb->lkb_astqueue);
+		list_del_init(&lkb->lkb_cb_list);
 		dlm_put_lkb(lkb);
 	}
 
@@ -5070,10 +5070,10 @@ static void purge_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 	spin_unlock(&proc->locks_spin);
 
 	spin_lock(&proc->asts_spin);
-	list_for_each_entry_safe(lkb, safe, &proc->asts, lkb_astqueue) {
+	list_for_each_entry_safe(lkb, safe, &proc->asts, lkb_cb_list) {
 		memset(&lkb->lkb_callbacks, 0,
 		       sizeof(struct dlm_callback) * DLM_CALLBACKS_SIZE);
-		list_del_init(&lkb->lkb_astqueue);
+		list_del_init(&lkb->lkb_cb_list);
 		dlm_put_lkb(lkb);
 	}
 	spin_unlock(&proc->asts_spin);
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 98a9776..a1d8f1a 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -15,7 +15,6 @@
 #include "lockspace.h"
 #include "member.h"
 #include "recoverd.h"
-#include "ast.h"
 #include "dir.h"
 #include "lowcomms.h"
 #include "config.h"
@@ -24,6 +23,7 @@
 #include "recover.h"
 #include "requestqueue.h"
 #include "user.h"
+#include "ast.h"
 
 static int			ls_count;
 static struct mutex		ls_lock;
@@ -359,17 +359,10 @@ static int threads_start(void)
 {
 	int error;
 
-	/* Thread which process lock requests for all lockspace's */
-	error = dlm_astd_start();
-	if (error) {
-		log_print("cannot start dlm_astd thread %d", error);
-		goto fail;
-	}
-
 	error = dlm_scand_start();
 	if (error) {
 		log_print("cannot start dlm_scand thread %d", error);
-		goto astd_fail;
+		goto fail;
 	}
 
 	/* Thread for sending/receiving messages for all lockspace's */
@@ -383,8 +376,6 @@ static int threads_start(void)
 
  scand_fail:
 	dlm_scand_stop();
- astd_fail:
-	dlm_astd_stop();
  fail:
 	return error;
 }
@@ -393,7 +384,6 @@ static void threads_stop(void)
 {
 	dlm_scand_stop();
 	dlm_lowcomms_stop();
-	dlm_astd_stop();
 }
 
 static int new_lockspace(const char *name, int namelen, void **lockspace,
@@ -514,6 +504,9 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	init_completion(&ls->ls_members_done);
 	ls->ls_members_result = -1;
 
+	mutex_init(&ls->ls_cb_mutex);
+	INIT_LIST_HEAD(&ls->ls_cb_delay);
+
 	ls->ls_recoverd_task = NULL;
 	mutex_init(&ls->ls_recoverd_active);
 	spin_lock_init(&ls->ls_recover_lock);
@@ -547,18 +540,26 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	list_add(&ls->ls_list, &lslist);
 	spin_unlock(&lslist_lock);
 
+	if (flags & DLM_LSFL_FS) {
+		error = dlm_callback_start(ls);
+		if (error) {
+			log_error(ls, "can't start dlm_callback %d", error);
+			goto out_delist;
+		}
+	}
+
 	/* needs to find ls in lslist */
 	error = dlm_recoverd_start(ls);
 	if (error) {
 		log_error(ls, "can't start dlm_recoverd %d", error);
-		goto out_delist;
+		goto out_callback;
 	}
 
 	ls->ls_kobj.kset = dlm_kset;
 	error = kobject_init_and_add(&ls->ls_kobj, &dlm_ktype, NULL,
 				     "%s", ls->ls_name);
 	if (error)
-		goto out_stop;
+		goto out_recoverd;
 	kobject_uevent(&ls->ls_kobj, KOBJ_ADD);
 
 	/* let kobject handle freeing of ls if there's an error */
@@ -572,7 +573,7 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 
 	error = do_uevent(ls, 1);
 	if (error)
-		goto out_stop;
+		goto out_recoverd;
 
 	wait_for_completion(&ls->ls_members_done);
 	error = ls->ls_members_result;
@@ -589,8 +590,10 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	do_uevent(ls, 0);
 	dlm_clear_members(ls);
 	kfree(ls->ls_node_array);
- out_stop:
+ out_recoverd:
 	dlm_recoverd_stop(ls);
+ out_callback:
+	dlm_callback_stop(ls);
  out_delist:
 	spin_lock(&lslist_lock);
 	list_del(&ls->ls_list);
@@ -652,8 +655,6 @@ static int lkb_idr_free(int id, void *p, void *data)
 {
 	struct dlm_lkb *lkb = p;
 
-	dlm_del_ast(lkb);
-
 	if (lkb->lkb_lvbptr && lkb->lkb_flags & DLM_IFL_MSTCPY)
 		dlm_free_lvb(lkb->lkb_lvbptr);
 
@@ -717,12 +718,12 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	dlm_recoverd_stop(ls);
 
+	dlm_callback_stop(ls);
+
 	remove_lockspace(ls);
 
 	dlm_delete_debug_file(ls);
 
-	dlm_astd_suspend();
-
 	kfree(ls->ls_recover_buf);
 
 	/*
@@ -740,8 +741,6 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 	idr_remove_all(&ls->ls_lkbidr);
 	idr_destroy(&ls->ls_lkbidr);
 
-	dlm_astd_resume();
-
 	/*
 	 * Free all rsb's on rsbtbl[] lists
 	 */
diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index fd677c8..774da3c 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -58,13 +58,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	mutex_lock(&ls->ls_recoverd_active);
 
-	/*
-	 * Suspending and resuming dlm_astd ensures that no lkb's from this ls
-	 * will be processed by dlm_astd during recovery.
-	 */
-
-	dlm_astd_suspend();
-	dlm_astd_resume();
+	dlm_callback_suspend(ls);
 
 	/*
 	 * Free non-master tossed rsb's.  Master rsb's are kept on toss
@@ -202,6 +196,8 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	dlm_adjust_timeouts(ls);
 
+	dlm_callback_resume(ls);
+
 	error = enable_locking(ls, rv->seq);
 	if (error) {
 		log_debug(ls, "enable_locking failed %d", error);
@@ -222,8 +218,6 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	dlm_grant_after_purge(ls);
 
-	dlm_astd_wake();
-
 	log_debug(ls, "recover %llx done: %u ms",
 		  (unsigned long long)rv->seq,
 		  jiffies_to_msecs(jiffies - start));
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index e96bf3e..d8ea607 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -213,9 +213,9 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode,
 		goto out;
 	}
 
-	if (list_empty(&lkb->lkb_astqueue)) {
+	if (list_empty(&lkb->lkb_cb_list)) {
 		kref_get(&lkb->lkb_ref);
-		list_add_tail(&lkb->lkb_astqueue, &proc->asts);
+		list_add_tail(&lkb->lkb_cb_list, &proc->asts);
 		wake_up_interruptible(&proc->wait);
 	}
 	spin_unlock(&proc->asts_spin);
@@ -832,24 +832,24 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	}
 
 	/* if we empty lkb_callbacks, we don't want to unlock the spinlock
-	   without removing lkb_astqueue; so empty lkb_astqueue is always
+	   without removing lkb_cb_list; so empty lkb_cb_list is always
 	   consistent with empty lkb_callbacks */
 
-	lkb = list_entry(proc->asts.next, struct dlm_lkb, lkb_astqueue);
+	lkb = list_entry(proc->asts.next, struct dlm_lkb, lkb_cb_list);
 
 	rv = dlm_rem_lkb_callback(lkb->lkb_resource->res_ls, lkb, &cb, &resid);
 	if (rv < 0) {
 		/* this shouldn't happen; lkb should have been removed from
 		   list when resid was zero */
 		log_print("dlm_rem_lkb_callback empty %x", lkb->lkb_id);
-		list_del_init(&lkb->lkb_astqueue);
+		list_del_init(&lkb->lkb_cb_list);
 		spin_unlock(&proc->asts_spin);
 		/* removes ref for proc->asts, may cause lkb to be freed */
 		dlm_put_lkb(lkb);
 		goto try_another;
 	}
 	if (!resid)
-		list_del_init(&lkb->lkb_astqueue);
+		list_del_init(&lkb->lkb_cb_list);
 	spin_unlock(&proc->asts_spin);
 
 	if (cb.flags & DLM_CB_SKIP) {
-- 
1.7.6

