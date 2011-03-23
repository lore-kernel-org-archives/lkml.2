Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab1CWKIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:08:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65002 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab1CWKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PE6Pe3AEOPi9yiLs7A4XUCDNNP7jIlBXbhoYwQyyodKFK2PdRZqOC56VjwnXfpkTPw
         /C9B18o6QzS2nimqX5jFGhwla3vdfB74VgR2Pg/f9E8lr15KhCqq4mA4YQWJ4nqB6Fce
         ubffOk6CSDRwr8Cryzw/vUH3NxDKNC1E4fu2M=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/20] job control: Add @for_ptrace to do_notify_parent_cldstop()
Date: Wed, 23 Mar 2011 11:06:03 +0100
Message-Id: <1300874766-12941-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300874766-12941-1-git-send-email-tj@kernel.org>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, do_notify_parent_cldstop() determines whether the
notification is for the real parent or ptracer.  Move the decision to
the caller by adding @for_ptrace parameter to
do_notify_parent_cldstop().  All the callers are updated to pass
task_ptrace(target_task), so this patch doesn't cause any behavior
difference.

While at it, add function comment to do_notify_parent_cldstop().

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 2f2c8f6..69d6054 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1595,16 +1595,30 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	return ret;
 }
 
-static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
+/**
+ * do_notify_parent_cldstop - notify parent of stopped/continued state change
+ * @tsk: task reporting the state change
+ * @for_ptracer: the notification is for ptracer
+ * @why: CLD_{CONTINUED|STOPPED|TRAPPED} to report
+ *
+ * Notify @tsk's parent that the stopped/continued state has changed.  If
+ * @for_ptracer is %false, @tsk's group leader notifies to its real parent.
+ * If %true, @tsk reports to @tsk->parent which should be the ptracer.
+ *
+ * CONTEXT:
+ * Must be called with tasklist_lock at least read locked.
+ */
+static void do_notify_parent_cldstop(struct task_struct *tsk,
+				     bool for_ptracer, int why)
 {
 	struct siginfo info;
 	unsigned long flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
 
-	if (task_ptrace(tsk))
+	if (for_ptracer) {
 		parent = tsk->parent;
-	else {
+	} else {
 		tsk = tsk->group_leader;
 		parent = tsk->real_parent;
 	}
@@ -1743,7 +1757,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
-		do_notify_parent_cldstop(current, why);
+		do_notify_parent_cldstop(current, task_ptrace(current), why);
 		/*
 		 * Don't want to allow preemption here, because
 		 * sys_ptrace() needs this task to be inactive.
@@ -1886,7 +1900,8 @@ retry:
 
 		if (notify) {
 			read_lock(&tasklist_lock);
-			do_notify_parent_cldstop(current, notify);
+			do_notify_parent_cldstop(current, task_ptrace(current),
+						 notify);
 			read_unlock(&tasklist_lock);
 		}
 
@@ -1982,6 +1997,7 @@ relock:
 	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
 	 */
 	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
+		struct task_struct *leader;
 		int why;
 
 		if (signal->flags & SIGNAL_CLD_CONTINUED)
@@ -1994,7 +2010,8 @@ relock:
 		spin_unlock_irq(&sighand->siglock);
 
 		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(current->group_leader, why);
+		leader = current->group_leader;
+		do_notify_parent_cldstop(leader, task_ptrace(leader), why);
 		read_unlock(&tasklist_lock);
 		goto relock;
 	}
@@ -2167,7 +2184,7 @@ out:
 
 	if (unlikely(group_stop)) {
 		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(tsk, group_stop);
+		do_notify_parent_cldstop(tsk, task_ptrace(tsk), group_stop);
 		read_unlock(&tasklist_lock);
 	}
 }
-- 
1.7.1

