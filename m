Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1CPRLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:11:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab1CPRL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:11:26 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] dlm: record full callback state
Date: Wed, 16 Mar 2011 11:42:01 -0500
Message-Id: <1300293723-29693-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change how callbacks are recorded for locks.  Previously, information
about multiple callbacks was combined into a couple of variables that
indicated what the end result should be.  In some situations, we
could not tell from this combined state what the exact sequence of
callbacks were, and would end up either delivering the callbacks in
the wrong order, or suppress redundant callbacks incorrectly.  This
new approach records all the data for each callback, leaving no
uncertainty about what needs to be delivered.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/ast.c          |  257 +++++++++++++++++++++++++++++++++++++-----------
 fs/dlm/ast.h          |    7 +-
 fs/dlm/debug_fs.c     |    4 +-
 fs/dlm/dlm_internal.h |   35 ++++---
 fs/dlm/lock.c         |   38 ++++----
 fs/dlm/rcom.c         |    4 +-
 fs/dlm/user.c         |  185 ++++++++++++-----------------------
 fs/dlm/user.h         |    3 +-
 8 files changed, 311 insertions(+), 222 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 4314f0d..abc49f2 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -18,6 +18,7 @@
 
 #define WAKE_ASTS  0
 
+static uint64_t			ast_seq_count;
 static struct list_head		ast_queue;
 static spinlock_t		ast_queue_lock;
 static struct task_struct *	astd_task;
@@ -25,40 +26,186 @@ static unsigned long		astd_wakeflags;
 static struct mutex		astd_running;
 
 
+static void dlm_dump_lkb_callbacks(struct dlm_lkb *lkb)
+{
+	int i;
+
+	log_print("last_bast %x %llu flags %x mode %d sb %d %x",
+		  lkb->lkb_id,
+		  (unsigned long long)lkb->lkb_last_bast.seq,
+		  lkb->lkb_last_bast.flags,
+		  lkb->lkb_last_bast.mode,
+		  lkb->lkb_last_bast.sb_status,
+		  lkb->lkb_last_bast.sb_flags);
+
+	log_print("last_cast %x %llu flags %x mode %d sb %d %x",
+		  lkb->lkb_id,
+		  (unsigned long long)lkb->lkb_last_cast.seq,
+		  lkb->lkb_last_cast.flags,
+		  lkb->lkb_last_cast.mode,
+		  lkb->lkb_last_cast.sb_status,
+		  lkb->lkb_last_cast.sb_flags);
+
+	for (i = 0; i < DLM_CALLBACKS_SIZE; i++) {
+		log_print("cb %x %llu flags %x mode %d sb %d %x",
+			  lkb->lkb_id,
+			  (unsigned long long)lkb->lkb_callbacks[i].seq,
+			  lkb->lkb_callbacks[i].flags,
+			  lkb->lkb_callbacks[i].mode,
+			  lkb->lkb_callbacks[i].sb_status,
+			  lkb->lkb_callbacks[i].sb_flags);
+	}
+}
+
 void dlm_del_ast(struct dlm_lkb *lkb)
 {
 	spin_lock(&ast_queue_lock);
-	if (lkb->lkb_ast_type & (AST_COMP | AST_BAST))
-		list_del(&lkb->lkb_astqueue);
+	if (!list_empty(&lkb->lkb_astqueue))
+		list_del_init(&lkb->lkb_astqueue);
 	spin_unlock(&ast_queue_lock);
 }
 
-void dlm_add_ast(struct dlm_lkb *lkb, int type, int mode)
+int dlm_add_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
+			 int status, uint32_t sbflags, uint64_t seq)
 {
+	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
+	uint64_t prev_seq;
+	int prev_mode;
+	int i;
+
+	for (i = 0; i < DLM_CALLBACKS_SIZE; i++) {
+		if (lkb->lkb_callbacks[i].seq)
+			continue;
+
+		/*
+		 * Suppress some redundant basts here, do more on removal.
+		 * Don't even add a bast if the callback just before it
+		 * is a bast for the same mode or a more restrictive mode.
+		 * (the addional > PR check is needed for PR/CW inversion)
+		 */
+
+		if ((i > 0) && (flags & DLM_CB_BAST) &&
+		    (lkb->lkb_callbacks[i-1].flags & DLM_CB_BAST)) {
+
+			prev_seq = lkb->lkb_callbacks[i-1].seq;
+			prev_mode = lkb->lkb_callbacks[i-1].mode;
+
+			if ((prev_mode == mode) ||
+			    (prev_mode > mode && prev_mode > DLM_LOCK_PR)) {
+
+				log_debug(ls, "skip %x add bast %llu mode %d "
+					  "for bast %llu mode %d",
+					  lkb->lkb_id,
+					  (unsigned long long)seq,
+					  mode,
+					  (unsigned long long)prev_seq,
+					  prev_mode);
+				return 0;
+			}
+		}
+
+		lkb->lkb_callbacks[i].seq = seq;
+		lkb->lkb_callbacks[i].flags = flags;
+		lkb->lkb_callbacks[i].mode = mode;
+		lkb->lkb_callbacks[i].sb_status = status;
+		lkb->lkb_callbacks[i].sb_flags = (sbflags & 0x000000FF);
+		break;
+	}
+
+	if (i == DLM_CALLBACKS_SIZE) {
+		log_error(ls, "no callbacks %x %llu flags %x mode %d sb %d %x",
+			  lkb->lkb_id, (unsigned long long)seq,
+			  flags, mode, status, sbflags);
+		dlm_dump_lkb_callbacks(lkb);
+		return -1;
+	}
+
+	return 0;
+}
+
+int dlm_rem_lkb_callback(struct dlm_ls *ls, struct dlm_lkb *lkb,
+			 struct dlm_callback *cb, int *resid)
+{
+	int i;
+
+	*resid = 0;
+
+	if (!lkb->lkb_callbacks[0].seq)
+		return -ENOENT;
+
+	/* oldest undelivered cb is callbacks[0] */
+
+	memcpy(cb, &lkb->lkb_callbacks[0], sizeof(struct dlm_callback));
+	memset(&lkb->lkb_callbacks[0], 0, sizeof(struct dlm_callback));
+
+	/* shift others down */
+
+	for (i = 1; i < DLM_CALLBACKS_SIZE; i++) {
+		if (!lkb->lkb_callbacks[i].seq)
+			break;
+		memcpy(&lkb->lkb_callbacks[i-1], &lkb->lkb_callbacks[i],
+		       sizeof(struct dlm_callback));
+		memset(&lkb->lkb_callbacks[i], 0, sizeof(struct dlm_callback));
+		(*resid)++;
+	}
+
+	/* if cb is a bast, it should be skipped if the blocking mode is
+	   compatible with the last granted mode */
+
+	if ((cb->flags & DLM_CB_BAST) && lkb->lkb_last_cast.seq) {
+		if (dlm_modes_compat(cb->mode, lkb->lkb_last_cast.mode)) {
+			cb->flags |= DLM_CB_SKIP;
+
+			log_debug(ls, "skip %x bast %llu mode %d "
+				  "for cast %llu mode %d",
+				  lkb->lkb_id,
+				  (unsigned long long)cb->seq,
+				  cb->mode,
+				  (unsigned long long)lkb->lkb_last_cast.seq,
+				  lkb->lkb_last_cast.mode);
+			return 0;
+		}
+	}
+
+	if (cb->flags & DLM_CB_CAST) {
+		memcpy(&lkb->lkb_last_cast, cb, sizeof(struct dlm_callback));
+		lkb->lkb_last_cast_time = ktime_get();
+	}
+
+	if (cb->flags & DLM_CB_BAST) {
+		memcpy(&lkb->lkb_last_bast, cb, sizeof(struct dlm_callback));
+		lkb->lkb_last_bast_time = ktime_get();
+	}
+
+	return 0;
+}
+
+void dlm_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
+		 uint32_t sbflags)
+{
+	uint64_t seq;
+	int rv;
+
+	spin_lock(&ast_queue_lock);
+
+	seq = ++ast_seq_count;
+
 	if (lkb->lkb_flags & DLM_IFL_USER) {
-		dlm_user_add_ast(lkb, type, mode);
+		spin_unlock(&ast_queue_lock);
+		dlm_user_add_ast(lkb, flags, mode, status, sbflags, seq);
 		return;
 	}
 
-	spin_lock(&ast_queue_lock);
-	if (!(lkb->lkb_ast_type & (AST_COMP | AST_BAST))) {
+	rv = dlm_add_lkb_callback(lkb, flags, mode, status, sbflags, seq);
+	if (rv < 0) {
+		spin_unlock(&ast_queue_lock);
+		return;
+	}
+
+	if (list_empty(&lkb->lkb_astqueue)) {
 		kref_get(&lkb->lkb_ref);
 		list_add_tail(&lkb->lkb_astqueue, &ast_queue);
-		lkb->lkb_ast_first = type;
 	}
-
-	/* sanity check, this should not happen */
-
-	if ((type == AST_COMP) && (lkb->lkb_ast_type & AST_COMP))
-		log_print("repeat cast %d castmode %d lock %x %s",
-			  mode, lkb->lkb_castmode,
-			  lkb->lkb_id, lkb->lkb_resource->res_name);
-
-	lkb->lkb_ast_type |= type;
-	if (type == AST_BAST)
-		lkb->lkb_bastmode = mode;
-	else
-		lkb->lkb_castmode = mode;
 	spin_unlock(&ast_queue_lock);
 
 	set_bit(WAKE_ASTS, &astd_wakeflags);
@@ -72,7 +219,8 @@ static void process_asts(void)
 	struct dlm_lkb *lkb;
 	void (*castfn) (void *astparam);
 	void (*bastfn) (void *astparam, int mode);
-	int type, first, bastmode, castmode, do_bast, do_cast, last_castmode;
+	struct dlm_callback callbacks[DLM_CALLBACKS_SIZE];
+	int i, rv, resid;
 
 repeat:
 	spin_lock(&ast_queue_lock);
@@ -83,54 +231,45 @@ repeat:
 		if (dlm_locking_stopped(ls))
 			continue;
 
-		list_del(&lkb->lkb_astqueue);
-		type = lkb->lkb_ast_type;
-		lkb->lkb_ast_type = 0;
-		first = lkb->lkb_ast_first;
-		lkb->lkb_ast_first = 0;
-		bastmode = lkb->lkb_bastmode;
-		castmode = lkb->lkb_castmode;
+		/* we remove from astqueue list and remove everything in
+		   lkb_callbacks before releasing the spinlock so empty
+		   lkb_astqueue is always consistent with empty lkb_callbacks */
+
+		list_del_init(&lkb->lkb_astqueue);
+
 		castfn = lkb->lkb_astfn;
 		bastfn = lkb->lkb_bastfn;
-		spin_unlock(&ast_queue_lock);
 
-		do_cast = (type & AST_COMP) && castfn;
-		do_bast = (type & AST_BAST) && bastfn;
+		memset(&callbacks, 0, sizeof(callbacks));
 
-		/* Skip a bast if its blocking mode is compatible with the
-		   granted mode of the preceding cast. */
+		for (i = 0; i < DLM_CALLBACKS_SIZE; i++) {
+			rv = dlm_rem_lkb_callback(ls, lkb, &callbacks[i], &resid);
+			if (rv < 0)
+				break;
+		}
+		spin_unlock(&ast_queue_lock);
 
-		if (do_bast) {
-			if (first == AST_COMP)
-				last_castmode = castmode;
-			else
-				last_castmode = lkb->lkb_castmode_done;
-			if (dlm_modes_compat(bastmode, last_castmode))
-				do_bast = 0;
+		if (resid) {
+			/* shouldn't happen, for loop should have removed all */
+			log_error(ls, "callback resid %d lkb %x",
+				  resid, lkb->lkb_id);
 		}
 
-		if (first == AST_COMP) {
-			if (do_cast)
-				castfn(lkb->lkb_astparam);
-			if (do_bast)
-				bastfn(lkb->lkb_astparam, bastmode);
-		} else if (first == AST_BAST) {
-			if (do_bast)
-				bastfn(lkb->lkb_astparam, bastmode);
-			if (do_cast)
+		for (i = 0; i < DLM_CALLBACKS_SIZE; i++) {
+			if (!callbacks[i].seq)
+				break;
+			if (callbacks[i].flags & DLM_CB_SKIP) {
+				continue;
+			} else if (callbacks[i].flags & DLM_CB_BAST) {
+				bastfn(lkb->lkb_astparam, callbacks[i].mode);
+			} else if (callbacks[i].flags & DLM_CB_CAST) {
+				lkb->lkb_lksb->sb_status = callbacks[i].sb_status;
+				lkb->lkb_lksb->sb_flags = callbacks[i].sb_flags;
 				castfn(lkb->lkb_astparam);
-		} else {
-			log_error(ls, "bad ast_first %d ast_type %d",
-				  first, type);
+			}
 		}
 
-		if (do_cast)
-			lkb->lkb_castmode_done = castmode;
-		if (do_bast)
-			lkb->lkb_bastmode_done = bastmode;
-
-		/* this removes the reference added by dlm_add_ast
-		   and may result in the lkb being freed */
+		/* removes ref for ast_queue, may cause lkb to be freed */
 		dlm_put_lkb(lkb);
 
 		cond_resched();
diff --git a/fs/dlm/ast.h b/fs/dlm/ast.h
index bcb1aab..8aa89c9 100644
--- a/fs/dlm/ast.h
+++ b/fs/dlm/ast.h
@@ -13,8 +13,13 @@
 #ifndef __ASTD_DOT_H__
 #define __ASTD_DOT_H__
 
-void dlm_add_ast(struct dlm_lkb *lkb, int type, int mode);
 void dlm_del_ast(struct dlm_lkb *lkb);
+int dlm_add_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
+                         int status, uint32_t sbflags, uint64_t seq);
+int dlm_rem_lkb_callback(struct dlm_ls *ls, struct dlm_lkb *lkb,
+                         struct dlm_callback *cb, int *resid);
+void dlm_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
+		 uint32_t sbflags);
 
 void dlm_astd_wake(void);
 int dlm_astd_start(void);
diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 6b42ba8..5977923 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -257,12 +257,12 @@ static int print_format3_lock(struct seq_file *s, struct dlm_lkb *lkb,
 			lkb->lkb_status,
 			lkb->lkb_grmode,
 			lkb->lkb_rqmode,
-			lkb->lkb_bastmode,
+			lkb->lkb_last_bast.mode,
 			rsb_lookup,
 			lkb->lkb_wait_type,
 			lkb->lkb_lvbseq,
 			(unsigned long long)ktime_to_ns(lkb->lkb_timestamp),
-			(unsigned long long)ktime_to_ns(lkb->lkb_time_bast));
+			(unsigned long long)ktime_to_ns(lkb->lkb_last_bast_time));
 	return rv;
 }
 
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index f632b58..b942049 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -192,11 +192,6 @@ struct dlm_args {
  * lkb is a process copy, the nodeid specifies the lock master.
  */
 
-/* lkb_ast_type */
-
-#define AST_COMP		1
-#define AST_BAST		2
-
 /* lkb_status */
 
 #define DLM_LKSTS_WAITING	1
@@ -217,6 +212,20 @@ struct dlm_args {
 #define DLM_IFL_USER		0x00000001
 #define DLM_IFL_ORPHAN		0x00000002
 
+#define DLM_CALLBACKS_SIZE	6
+
+#define DLM_CB_CAST		0x00000001
+#define DLM_CB_BAST		0x00000002
+#define DLM_CB_SKIP		0x00000004
+
+struct dlm_callback {
+	uint64_t		seq;
+	uint32_t		flags;		/* DLM_CBF_ */
+	int			sb_status;	/* copy to lksb status */
+	uint8_t			sb_flags;	/* copy to lksb flags */
+	int8_t			mode; /* rq mode of bast, gr mode of cast */
+};
+
 struct dlm_lkb {
 	struct dlm_rsb		*lkb_resource;	/* the rsb */
 	struct kref		lkb_ref;
@@ -236,13 +245,6 @@ struct dlm_lkb {
 
 	int8_t			lkb_wait_type;	/* type of reply waiting for */
 	int8_t			lkb_wait_count;
-	int8_t			lkb_ast_type;	/* type of ast queued for */
-	int8_t			lkb_ast_first;	/* type of first ast queued */
-
-	int8_t			lkb_bastmode;	/* req mode of queued bast */
-	int8_t			lkb_castmode;	/* gr mode of queued cast */
-	int8_t			lkb_bastmode_done; /* last delivered bastmode */
-	int8_t			lkb_castmode_done; /* last delivered castmode */
 
 	struct list_head	lkb_idtbl_list;	/* lockspace lkbtbl */
 	struct list_head	lkb_statequeue;	/* rsb g/c/w list */
@@ -251,10 +253,15 @@ struct dlm_lkb {
 	struct list_head	lkb_astqueue;	/* need ast to be sent */
 	struct list_head	lkb_ownqueue;	/* list of locks for a process */
 	struct list_head	lkb_time_list;
-	ktime_t			lkb_time_bast;	/* for debugging */
 	ktime_t			lkb_timestamp;
 	unsigned long		lkb_timeout_cs;
 
+	struct dlm_callback	lkb_callbacks[DLM_CALLBACKS_SIZE];
+	struct dlm_callback	lkb_last_cast;
+	struct dlm_callback	lkb_last_bast;
+	ktime_t			lkb_last_cast_time;	/* for debugging */
+	ktime_t			lkb_last_bast_time;	/* for debugging */
+
 	char			*lkb_lvbptr;
 	struct dlm_lksb		*lkb_lksb;      /* caller's status block */
 	void			(*lkb_astfn) (void *astparam);
@@ -544,8 +551,6 @@ struct dlm_user_args {
 					  (dlm_user_proc) on the struct file,
 					  the process's locks point back to it*/
 	struct dlm_lksb		lksb;
-	int			old_mode;
-	int			update_user_lvb;
 	struct dlm_lksb __user	*user_lksb;
 	void __user		*castparam;
 	void __user		*castaddr;
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 64e5f3e..04b8c44 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -160,10 +160,10 @@ static const int __quecvt_compat_matrix[8][8] = {
 void dlm_print_lkb(struct dlm_lkb *lkb)
 {
 	printk(KERN_ERR "lkb: nodeid %d id %x remid %x exflags %x flags %x\n"
-	       "     status %d rqmode %d grmode %d wait_type %d ast_type %d\n",
+	       "     status %d rqmode %d grmode %d wait_type %d\n",
 	       lkb->lkb_nodeid, lkb->lkb_id, lkb->lkb_remid, lkb->lkb_exflags,
 	       lkb->lkb_flags, lkb->lkb_status, lkb->lkb_rqmode,
-	       lkb->lkb_grmode, lkb->lkb_wait_type, lkb->lkb_ast_type);
+	       lkb->lkb_grmode, lkb->lkb_wait_type);
 }
 
 static void dlm_print_rsb(struct dlm_rsb *r)
@@ -305,10 +305,7 @@ static void queue_cast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rv)
 		rv = -EDEADLK;
 	}
 
-	lkb->lkb_lksb->sb_status = rv;
-	lkb->lkb_lksb->sb_flags = lkb->lkb_sbflags;
-
-	dlm_add_ast(lkb, AST_COMP, lkb->lkb_grmode);
+	dlm_add_ast(lkb, DLM_CB_CAST, lkb->lkb_grmode, rv, lkb->lkb_sbflags);
 }
 
 static inline void queue_cast_overlap(struct dlm_rsb *r, struct dlm_lkb *lkb)
@@ -319,13 +316,10 @@ static inline void queue_cast_overlap(struct dlm_rsb *r, struct dlm_lkb *lkb)
 
 static void queue_bast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rqmode)
 {
-	lkb->lkb_time_bast = ktime_get();
-
 	if (is_master_copy(lkb)) {
-		lkb->lkb_bastmode = rqmode; /* printed by debugfs */
 		send_bast(r, lkb, rqmode);
 	} else {
-		dlm_add_ast(lkb, AST_BAST, rqmode);
+		dlm_add_ast(lkb, DLM_CB_BAST, rqmode, 0, 0);
 	}
 }
 
@@ -600,6 +594,7 @@ static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 	INIT_LIST_HEAD(&lkb->lkb_ownqueue);
 	INIT_LIST_HEAD(&lkb->lkb_rsb_lookup);
 	INIT_LIST_HEAD(&lkb->lkb_time_list);
+	INIT_LIST_HEAD(&lkb->lkb_astqueue);
 
 	get_random_bytes(&bucket, sizeof(bucket));
 	bucket &= (ls->ls_lkbtbl_size - 1);
@@ -2819,9 +2814,9 @@ static void send_args(struct dlm_rsb *r, struct dlm_lkb *lkb,
 	   not from lkb fields */
 
 	if (lkb->lkb_bastfn)
-		ms->m_asts |= AST_BAST;
+		ms->m_asts |= DLM_CB_BAST;
 	if (lkb->lkb_astfn)
-		ms->m_asts |= AST_COMP;
+		ms->m_asts |= DLM_CB_CAST;
 
 	/* compare with switch in create_message; send_remove() doesn't
 	   use send_args() */
@@ -3122,8 +3117,8 @@ static int receive_request_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	lkb->lkb_grmode = DLM_LOCK_IV;
 	lkb->lkb_rqmode = ms->m_rqmode;
 
-	lkb->lkb_bastfn = (ms->m_asts & AST_BAST) ? &fake_bastfn : NULL;
-	lkb->lkb_astfn = (ms->m_asts & AST_COMP) ? &fake_astfn : NULL;
+	lkb->lkb_bastfn = (ms->m_asts & DLM_CB_BAST) ? &fake_bastfn : NULL;
+	lkb->lkb_astfn = (ms->m_asts & DLM_CB_CAST) ? &fake_astfn : NULL;
 
 	if (lkb->lkb_exflags & DLM_LKF_VALBLK) {
 		/* lkb was just created so there won't be an lvb yet */
@@ -4412,8 +4407,8 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	lkb->lkb_grmode = rl->rl_grmode;
 	/* don't set lkb_status because add_lkb wants to itself */
 
-	lkb->lkb_bastfn = (rl->rl_asts & AST_BAST) ? &fake_bastfn : NULL;
-	lkb->lkb_astfn = (rl->rl_asts & AST_COMP) ? &fake_astfn : NULL;
+	lkb->lkb_bastfn = (rl->rl_asts & DLM_CB_BAST) ? &fake_bastfn : NULL;
+	lkb->lkb_astfn = (rl->rl_asts & DLM_CB_CAST) ? &fake_astfn : NULL;
 
 	if (lkb->lkb_exflags & DLM_LKF_VALBLK) {
 		int lvblen = rc->rc_header.h_length - sizeof(struct dlm_rcom) -
@@ -4589,7 +4584,6 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 	error = set_lock_args(mode, &ua->lksb, flags, namelen, timeout_cs,
 			      fake_astfn, ua, fake_bastfn, &args);
 	lkb->lkb_flags |= DLM_IFL_USER;
-	ua->old_mode = DLM_LOCK_IV;
 
 	if (error) {
 		__put_lkb(ls, lkb);
@@ -4658,7 +4652,6 @@ int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	ua->bastparam = ua_tmp->bastparam;
 	ua->bastaddr = ua_tmp->bastaddr;
 	ua->user_lksb = ua_tmp->user_lksb;
-	ua->old_mode = lkb->lkb_grmode;
 
 	error = set_lock_args(mode, &ua->lksb, flags, 0, timeout_cs,
 			      fake_astfn, ua, fake_bastfn, &args);
@@ -4917,8 +4910,9 @@ void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 	}
 
 	list_for_each_entry_safe(lkb, safe, &proc->asts, lkb_astqueue) {
-		lkb->lkb_ast_type = 0;
-		list_del(&lkb->lkb_astqueue);
+		memset(&lkb->lkb_callbacks, 0,
+		       sizeof(struct dlm_callback) * DLM_CALLBACKS_SIZE);
+		list_del_init(&lkb->lkb_astqueue);
 		dlm_put_lkb(lkb);
 	}
 
@@ -4958,7 +4952,9 @@ static void purge_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 
 	spin_lock(&proc->asts_spin);
 	list_for_each_entry_safe(lkb, safe, &proc->asts, lkb_astqueue) {
-		list_del(&lkb->lkb_astqueue);
+		memset(&lkb->lkb_callbacks, 0,
+		       sizeof(struct dlm_callback) * DLM_CALLBACKS_SIZE);
+		list_del_init(&lkb->lkb_astqueue);
 		dlm_put_lkb(lkb);
 	}
 	spin_unlock(&proc->asts_spin);
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 3c83a49..f10a50f 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -321,9 +321,9 @@ static void pack_rcom_lock(struct dlm_rsb *r, struct dlm_lkb *lkb,
 	rl->rl_wait_type = cpu_to_le16(lkb->lkb_wait_type);
 
 	if (lkb->lkb_bastfn)
-		rl->rl_asts |= AST_BAST;
+		rl->rl_asts |= DLM_CB_BAST;
 	if (lkb->lkb_astfn)
-		rl->rl_asts |= AST_COMP;
+		rl->rl_asts |= DLM_CB_CAST;
 
 	rl->rl_namelen = cpu_to_le16(r->res_length);
 	memcpy(rl->rl_name, r->res_name, r->res_length);
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 66d6c16..d5ab3fe 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -24,6 +24,7 @@
 #include "lock.h"
 #include "lvb_table.h"
 #include "user.h"
+#include "ast.h"
 
 static const char name_prefix[] = "dlm";
 static const struct file_operations device_fops;
@@ -152,19 +153,16 @@ static void compat_output(struct dlm_lock_result *res,
    not related to the lifetime of the lkb struct which is managed
    entirely by refcount. */
 
-static int lkb_is_endoflife(struct dlm_lkb *lkb, int sb_status, int type)
+static int lkb_is_endoflife(int mode, int status)
 {
-	switch (sb_status) {
+	switch (status) {
 	case -DLM_EUNLOCK:
 		return 1;
 	case -DLM_ECANCEL:
 	case -ETIMEDOUT:
 	case -EDEADLK:
-		if (lkb->lkb_grmode == DLM_LOCK_IV)
-			return 1;
-		break;
 	case -EAGAIN:
-		if (type == AST_COMP && lkb->lkb_grmode == DLM_LOCK_IV)
+		if (mode == DLM_LOCK_IV)
 			return 1;
 		break;
 	}
@@ -174,12 +172,13 @@ static int lkb_is_endoflife(struct dlm_lkb *lkb, int sb_status, int type)
 /* we could possibly check if the cancel of an orphan has resulted in the lkb
    being removed and then remove that lkb from the orphans list and free it */
 
-void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int mode)
+void dlm_user_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode,
+		      int status, uint32_t sbflags, uint64_t seq)
 {
 	struct dlm_ls *ls;
 	struct dlm_user_args *ua;
 	struct dlm_user_proc *proc;
-	int eol = 0, ast_type;
+	int rv;
 
 	if (lkb->lkb_flags & (DLM_IFL_ORPHAN | DLM_IFL_DEAD))
 		return;
@@ -200,49 +199,29 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int mode)
 	ua = lkb->lkb_ua;
 	proc = ua->proc;
 
-	if (type == AST_BAST && ua->bastaddr == NULL)
+	if ((flags & DLM_CB_BAST) && ua->bastaddr == NULL)
 		goto out;
 
+	if ((flags & DLM_CB_CAST) && lkb_is_endoflife(mode, status))
+		lkb->lkb_flags |= DLM_IFL_ENDOFLIFE;
+
 	spin_lock(&proc->asts_spin);
 
-	ast_type = lkb->lkb_ast_type;
-	lkb->lkb_ast_type |= type;
-	if (type == AST_BAST)
-		lkb->lkb_bastmode = mode;
-	else
-		lkb->lkb_castmode = mode;
+	rv = dlm_add_lkb_callback(lkb, flags, mode, status, sbflags, seq);
+	if (rv < 0) {
+		spin_unlock(&proc->asts_spin);
+		goto out;
+	}
 
-	if (!ast_type) {
+	if (list_empty(&lkb->lkb_astqueue)) {
 		kref_get(&lkb->lkb_ref);
 		list_add_tail(&lkb->lkb_astqueue, &proc->asts);
-		lkb->lkb_ast_first = type;
 		wake_up_interruptible(&proc->wait);
 	}
-	if (type == AST_COMP && (ast_type & AST_COMP))
-		log_debug(ls, "ast overlap %x status %x %x",
-			  lkb->lkb_id, ua->lksb.sb_status, lkb->lkb_flags);
-
-	eol = lkb_is_endoflife(lkb, ua->lksb.sb_status, type);
-	if (eol) {
-		lkb->lkb_flags |= DLM_IFL_ENDOFLIFE;
-	}
-
-	/* We want to copy the lvb to userspace when the completion
-	   ast is read if the status is 0, the lock has an lvb and
-	   lvb_ops says we should.  We could probably have set_lvb_lock()
-	   set update_user_lvb instead and not need old_mode */
-
-	if ((lkb->lkb_ast_type & AST_COMP) &&
-	    (lkb->lkb_lksb->sb_status == 0) &&
-	    lkb->lkb_lksb->sb_lvbptr &&
-	    dlm_lvb_operations[ua->old_mode + 1][lkb->lkb_grmode + 1])
-		ua->update_user_lvb = 1;
-	else
-		ua->update_user_lvb = 0;
-
 	spin_unlock(&proc->asts_spin);
 
-	if (eol) {
+	if (lkb->lkb_flags & DLM_IFL_ENDOFLIFE) {
+		/* N.B. spin_lock locks_spin, not asts_spin */
 		spin_lock(&proc->locks_spin);
 		if (!list_empty(&lkb->lkb_ownqueue)) {
 			list_del_init(&lkb->lkb_ownqueue);
@@ -705,8 +684,9 @@ static int device_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int copy_result_to_user(struct dlm_user_args *ua, int compat, int type,
-			       int mode, char __user *buf, size_t count)
+static int copy_result_to_user(struct dlm_user_args *ua, int compat,
+			       uint32_t flags, int mode, int copy_lvb,
+			       char __user *buf, size_t count)
 {
 #ifdef CONFIG_COMPAT
 	struct dlm_lock_result32 result32;
@@ -730,7 +710,7 @@ static int copy_result_to_user(struct dlm_user_args *ua, int compat, int type,
 	   notes that a new blocking AST address and parameter are set even if
 	   the conversion fails, so maybe we should just do that. */
 
-	if (type == AST_BAST) {
+	if (flags & DLM_CB_BAST) {
 		result.user_astaddr = ua->bastaddr;
 		result.user_astparam = ua->bastparam;
 		result.bast_mode = mode;
@@ -750,8 +730,7 @@ static int copy_result_to_user(struct dlm_user_args *ua, int compat, int type,
 	/* copy lvb to userspace if there is one, it's been updated, and
 	   the user buffer has space for it */
 
-	if (ua->update_user_lvb && ua->lksb.sb_lvbptr &&
-	    count >= len + DLM_USER_LVB_LEN) {
+	if (copy_lvb && ua->lksb.sb_lvbptr && count >= len + DLM_USER_LVB_LEN) {
 		if (copy_to_user(buf+len, ua->lksb.sb_lvbptr,
 				 DLM_USER_LVB_LEN)) {
 			error = -EFAULT;
@@ -801,13 +780,12 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	struct dlm_user_proc *proc = file->private_data;
 	struct dlm_lkb *lkb;
 	DECLARE_WAITQUEUE(wait, current);
-	int error = 0, removed;
-	int ret_type, ret_mode;
-	int bastmode, castmode, do_bast, do_cast;
+	struct dlm_callback cb;
+	int rv, resid, copy_lvb = 0;
 
 	if (count == sizeof(struct dlm_device_version)) {
-		error = copy_version_to_user(buf, count);
-		return error;
+		rv = copy_version_to_user(buf, count);
+		return rv;
 	}
 
 	if (!proc) {
@@ -854,92 +832,57 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 		}
 	}
 
-	/* there may be both completion and blocking asts to return for
-	   the lkb, don't remove lkb from asts list unless no asts remain */
+	/* if we empty lkb_callbacks, we don't want to unlock the spinlock
+	   without removing lkb_astqueue; so empty lkb_astqueue is always
+	   consistent with empty lkb_callbacks */
 
 	lkb = list_entry(proc->asts.next, struct dlm_lkb, lkb_astqueue);
 
-	removed = 0;
-	ret_type = 0;
-	ret_mode = 0;
-	do_bast = lkb->lkb_ast_type & AST_BAST;
-	do_cast = lkb->lkb_ast_type & AST_COMP;
-	bastmode = lkb->lkb_bastmode;
-	castmode = lkb->lkb_castmode;
-
-	/* when both are queued figure out which to do first and
-	   switch first so the other goes in the next read */
-
-	if (do_cast && do_bast) {
-		if (lkb->lkb_ast_first == AST_COMP) {
-			ret_type = AST_COMP;
-			ret_mode = castmode;
-			lkb->lkb_ast_type &= ~AST_COMP;
-			lkb->lkb_ast_first = AST_BAST;
-		} else {
-			ret_type = AST_BAST;
-			ret_mode = bastmode;
-			lkb->lkb_ast_type &= ~AST_BAST;
-			lkb->lkb_ast_first = AST_COMP;
-		}
-	} else {
-		ret_type = lkb->lkb_ast_first;
-		ret_mode = (ret_type == AST_COMP) ? castmode : bastmode;
-		lkb->lkb_ast_type &= ~ret_type;
-		lkb->lkb_ast_first = 0;
+	rv = dlm_rem_lkb_callback(lkb->lkb_resource->res_ls, lkb, &cb, &resid);
+	if (rv < 0) {
+		/* this shouldn't happen; lkb should have been removed from
+		   list when resid was zero */
+		log_print("dlm_rem_lkb_callback empty %x", lkb->lkb_id);
+		list_del_init(&lkb->lkb_astqueue);
+		spin_unlock(&proc->asts_spin);
+		/* removes ref for proc->asts, may cause lkb to be freed */
+		dlm_put_lkb(lkb);
+		goto try_another;
 	}
+	if (!resid)
+		list_del_init(&lkb->lkb_astqueue);
+	spin_unlock(&proc->asts_spin);
 
-	/* if we're doing a bast but the bast is unnecessary, then
-	   switch to do nothing or do a cast if that was needed next */
-
-	if ((ret_type == AST_BAST) &&
-	    dlm_modes_compat(bastmode, lkb->lkb_castmode_done)) {
-		ret_type = 0;
-		ret_mode = 0;
-
-		if (do_cast) {
-			ret_type = AST_COMP;
-			ret_mode = castmode;
-			lkb->lkb_ast_type &= ~AST_COMP;
-			lkb->lkb_ast_first = 0;
-		}
+	if (cb.flags & DLM_CB_SKIP) {
+		/* removes ref for proc->asts, may cause lkb to be freed */
+		if (!resid)
+			dlm_put_lkb(lkb);
+		goto try_another;
 	}
 
-	if (lkb->lkb_ast_first != lkb->lkb_ast_type) {
-		log_print("device_read %x ast_first %x ast_type %x",
-			  lkb->lkb_id, lkb->lkb_ast_first, lkb->lkb_ast_type);
-	}
+	if (cb.flags & DLM_CB_CAST) {
+		int old_mode, new_mode;
 
-	if (!lkb->lkb_ast_type) {
-		list_del(&lkb->lkb_astqueue);
-		removed = 1;
-	}
-	spin_unlock(&proc->asts_spin);
+		old_mode = lkb->lkb_last_cast.mode;
+		new_mode = cb.mode;
 
-	if (ret_type) {
-		error = copy_result_to_user(lkb->lkb_ua,
-				test_bit(DLM_PROC_FLAGS_COMPAT, &proc->flags),
-				ret_type, ret_mode, buf, count);
+		if (!cb.sb_status && lkb->lkb_lksb->sb_lvbptr &&
+		    dlm_lvb_operations[old_mode + 1][new_mode + 1])
+			copy_lvb = 1;
 
-		if (ret_type == AST_COMP)
-			lkb->lkb_castmode_done = castmode;
-		if (ret_type == AST_BAST)
-			lkb->lkb_bastmode_done = bastmode;
+		lkb->lkb_lksb->sb_status = cb.sb_status;
+		lkb->lkb_lksb->sb_flags = cb.sb_flags;
 	}
 
-	/* removes reference for the proc->asts lists added by
-	   dlm_user_add_ast() and may result in the lkb being freed */
+	rv = copy_result_to_user(lkb->lkb_ua,
+				 test_bit(DLM_PROC_FLAGS_COMPAT, &proc->flags),
+				 cb.flags, cb.mode, copy_lvb, buf, count);
 
-	if (removed)
+	/* removes ref for proc->asts, may cause lkb to be freed */
+	if (!resid)
 		dlm_put_lkb(lkb);
 
-	/* the bast that was queued was eliminated (see unnecessary above),
-	   leaving nothing to return */
-
-	if (!ret_type)
-		goto try_another;
-
-	return error;
+	return rv;
 }
 
 static unsigned int device_poll(struct file *file, poll_table *wait)
diff --git a/fs/dlm/user.h b/fs/dlm/user.h
index f196091..00499ab 100644
--- a/fs/dlm/user.h
+++ b/fs/dlm/user.h
@@ -9,7 +9,8 @@
 #ifndef __USER_DOT_H__
 #define __USER_DOT_H__
 
-void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int mode);
+void dlm_user_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode,
+                      int status, uint32_t sbflags, uint64_t seq);
 int dlm_user_init(void);
 void dlm_user_exit(void);
 int dlm_device_deregister(struct dlm_ls *ls);
-- 
1.7.1.1

