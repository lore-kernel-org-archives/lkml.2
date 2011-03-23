Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab1CWKGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:06:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65002 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab1CWKGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=mchg8yL92Gp95296ClGoPsCuSqVoEXqnRK2G5eXzip13BDWhj6orIJi9OJd9hk70Yx
         5/TMnMd1gnieONEvQ/oArroASjFWeDMEwUkfT/fEw/3EQsu6sTO058PwReUmrE5+U0aJ
         7ZiwoouzxlNH/SVloCwrrZgt8EA/+tXOheOrU=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/20] job control: Job control stop notifications should always go to the real parent
Date: Wed, 23 Mar 2011 11:06:04 +0100
Message-Id: <1300874766-12941-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300874766-12941-1-git-send-email-tj@kernel.org>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stopped notifications in do_signal_stop() and exit_signals() are
always for the completion of job control.  The one in do_signal_stop()
may be delivered to the ptracer if PTRACE_ATTACH races with
notification and the one in exit_signals() if task exits while
ptraced.

In both cases, the notifications are meaningless and confusing to the
ptracer as it never accesses the group stop state while the real
parent would miss notifications for the events it is watching.

Make sure these notifications always go to the real parent by calling
do_notify_parent_cld_stop() with %false @for_ptrace.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 69d6054..9f10b24 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1898,10 +1898,18 @@ retry:
 		__set_current_state(TASK_STOPPED);
 		spin_unlock_irq(&current->sighand->siglock);
 
+		/*
+		 * Notify the parent of the group stop completion.  Because
+		 * we're not holding either the siglock or tasklist_lock
+		 * here, ptracer may attach inbetween; however, this is for
+		 * group stop and should always be delivered to the real
+		 * parent of the group leader.  The new ptracer will get
+		 * its notification when this task transitions into
+		 * TASK_TRACED.
+		 */
 		if (notify) {
 			read_lock(&tasklist_lock);
-			do_notify_parent_cldstop(current, task_ptrace(current),
-						 notify);
+			do_notify_parent_cldstop(current, false, notify);
 			read_unlock(&tasklist_lock);
 		}
 
@@ -2182,9 +2190,13 @@ void exit_signals(struct task_struct *tsk)
 out:
 	spin_unlock_irq(&tsk->sighand->siglock);
 
+	/*
+	 * If group stop has completed, deliver the notification.  This
+	 * should always go to the real parent of the group leader.
+	 */
 	if (unlikely(group_stop)) {
 		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(tsk, task_ptrace(tsk), group_stop);
+		do_notify_parent_cldstop(tsk, false, group_stop);
 		read_unlock(&tasklist_lock);
 	}
 }
-- 
1.7.1

