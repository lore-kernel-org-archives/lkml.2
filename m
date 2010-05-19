Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0ESOsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:48:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab0ESOso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:48:44 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dlm: fix ast ordering for user locks
Date: Wed, 19 May 2010 09:48:33 -0500
Message-Id: <1274280513-14860-3-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7fe2b3190b8b299409f13cf3a6f85c2bd371f8bb fixed possible
misordering of completion asts (casts) and blocking asts (basts)
for kernel locks.  This patch does the same for locks taken by
user space applications.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/user.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 8b6e73c..b627285 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -215,6 +215,7 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int mode)
 	if (!ast_type) {
 		kref_get(&lkb->lkb_ref);
 		list_add_tail(&lkb->lkb_astqueue, &proc->asts);
+		lkb->lkb_ast_first = type;
 		wake_up_interruptible(&proc->wait);
 	}
 	if (type == AST_COMP && (ast_type & AST_COMP))
@@ -223,7 +224,6 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int mode)
 
 	eol = lkb_is_endoflife(lkb, ua->lksb.sb_status, type);
 	if (eol) {
-		lkb->lkb_ast_type &= ~AST_BAST;
 		lkb->lkb_flags |= DLM_IFL_ENDOFLIFE;
 	}
 
@@ -706,7 +706,7 @@ static int device_close(struct inode *inode, struct file *file)
 }
 
 static int copy_result_to_user(struct dlm_user_args *ua, int compat, int type,
-			       int bmode, char __user *buf, size_t count)
+			       int mode, char __user *buf, size_t count)
 {
 #ifdef CONFIG_COMPAT
 	struct dlm_lock_result32 result32;
@@ -733,7 +733,7 @@ static int copy_result_to_user(struct dlm_user_args *ua, int compat, int type,
 	if (type == AST_BAST) {
 		result.user_astaddr = ua->bastaddr;
 		result.user_astparam = ua->bastparam;
-		result.bast_mode = bmode;
+		result.bast_mode = mode;
 	} else {
 		result.user_astaddr = ua->castaddr;
 		result.user_astparam = ua->castparam;
@@ -801,7 +801,9 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	struct dlm_user_proc *proc = file->private_data;
 	struct dlm_lkb *lkb;
 	DECLARE_WAITQUEUE(wait, current);
-	int error, type=0, bmode=0, removed = 0;
+	int error = 0, removed;
+	int ret_type, ret_mode;
+	int bastmode, castmode, do_bast, do_cast;
 
 	if (count == sizeof(struct dlm_device_version)) {
 		error = copy_version_to_user(buf, count);
@@ -820,6 +822,8 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 #endif
 		return -EINVAL;
 
+ try_another:
+
 	/* do we really need this? can a read happen after a close? */
 	if (test_bit(DLM_PROC_FLAGS_CLOSING, &proc->flags))
 		return -EINVAL;
@@ -855,13 +859,55 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 
 	lkb = list_entry(proc->asts.next, struct dlm_lkb, lkb_astqueue);
 
-	if (lkb->lkb_ast_type & AST_COMP) {
-		lkb->lkb_ast_type &= ~AST_COMP;
-		type = AST_COMP;
-	} else if (lkb->lkb_ast_type & AST_BAST) {
-		lkb->lkb_ast_type &= ~AST_BAST;
-		type = AST_BAST;
-		bmode = lkb->lkb_bastmode;
+	removed = 0;
+	ret_type = 0;
+	ret_mode = 0;
+	do_bast = lkb->lkb_ast_type & AST_BAST;
+	do_cast = lkb->lkb_ast_type & AST_COMP;
+	bastmode = lkb->lkb_bastmode;
+	castmode = lkb->lkb_castmode;
+
+	/* when both are queued figure out which to do first and
+	   switch first so the other goes in the next read */
+
+	if (do_cast && do_bast) {
+		if (lkb->lkb_ast_first == AST_COMP) {
+			ret_type = AST_COMP;
+			ret_mode = castmode;
+			lkb->lkb_ast_type &= ~AST_COMP;
+			lkb->lkb_ast_first = AST_BAST;
+		} else {
+			ret_type = AST_BAST;
+			ret_mode = bastmode;
+			lkb->lkb_ast_type &= ~AST_BAST;
+			lkb->lkb_ast_first = AST_COMP;
+		}
+	} else {
+		ret_type = lkb->lkb_ast_first;
+		ret_mode = (ret_type == AST_COMP) ? castmode : bastmode;
+		lkb->lkb_ast_type &= ~ret_type;
+		lkb->lkb_ast_first = 0;
+	}
+
+	/* if we're doing a bast but the bast is unnecessary, then
+	   switch to do nothing or do a cast if that was needed next */
+
+	if ((ret_type == AST_BAST) &&
+	    dlm_modes_compat(bastmode, lkb->lkb_castmode_done)) {
+		ret_type = 0;
+		ret_mode = 0;
+
+		if (do_cast) {
+			ret_type = AST_COMP;
+			ret_mode = castmode;
+			lkb->lkb_ast_type &= ~AST_COMP;
+			lkb->lkb_ast_first = 0;
+		}
+	}
+
+	if (lkb->lkb_ast_first != lkb->lkb_ast_type) {
+		log_print("device_read %x ast_first %x ast_type %x",
+			  lkb->lkb_id, lkb->lkb_ast_first, lkb->lkb_ast_type);
 	}
 
 	if (!lkb->lkb_ast_type) {
@@ -870,15 +916,29 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	}
 	spin_unlock(&proc->asts_spin);
 
-	error = copy_result_to_user(lkb->lkb_ua,
-			 	test_bit(DLM_PROC_FLAGS_COMPAT, &proc->flags),
-				type, bmode, buf, count);
+	if (ret_type) {
+		error = copy_result_to_user(lkb->lkb_ua,
+				test_bit(DLM_PROC_FLAGS_COMPAT, &proc->flags),
+				ret_type, ret_mode, buf, count);
+
+		if (ret_type == AST_COMP)
+			lkb->lkb_castmode_done = castmode;
+		if (ret_type == AST_BAST)
+			lkb->lkb_bastmode_done = bastmode;
+	}
 
 	/* removes reference for the proc->asts lists added by
 	   dlm_user_add_ast() and may result in the lkb being freed */
+
 	if (removed)
 		dlm_put_lkb(lkb);
 
+	/* the bast that was queued was eliminated (see unnecessary above),
+	   leaving nothing to return */
+
+	if (!ret_type)
+		goto try_another;
+
 	return error;
 }
 
-- 
1.6.6

