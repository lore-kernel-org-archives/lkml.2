Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203Ab1EMPqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:46:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52886 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023Ab1EMPqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=KaN/HJC5AKhdA97YNtbLaqT+8OumQ7GrJ1JYDhgOMJpRsrrrafb7WIJPJ928xHYLbI
         dZBPOJJij99ti9ISIERhj5DA3IONaa+10eXaMLSFtf9YlqBpsXg1at02lokJYFPlOKpO
         p0jF9dDNpGvsxJ83bQaOgLYiqJ5AUbEpCsFRM=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 9/9] ptrace: make TRAPPING wait interruptible
Date: Fri, 13 May 2011 17:46:20 +0200
Message-Id: <1305301580-9924-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305301580-9924-1-git-send-email-tj@kernel.org>
References: <1305301580-9924-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With JOBCTL_TRAPPING waits moved to wait_task_stopped() and
ptrace_check_attach(), and both using full syscall retries after wait,
TRAPPING wait can switch to interruptible sleeps.

As all transitions are interlocked and all cancellation events
(supposedly) clear TRAPPING, this doesn't change the actual behavior
but it makes the TRAPPING wait mechanism much more forgiving when
something goes wrong and allows using TRAPPING waits across freezing
points.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/ptrace.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 03349b5..6e79eab 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -27,7 +27,7 @@
 static int ptrace_trapping_sleep_fn(void *flags)
 {
 	schedule();
-	return 0;
+	return signal_pending(current);
 }
 
 /**
@@ -44,7 +44,11 @@ static int ptrace_trapping_sleep_fn(void *flags)
  * to make sure no transition is in progress before proceeding.
  *
  * This function checks whether @child is TRAPPING and, if so, waits for
- * the transition to complete.
+ * the transition to complete.  Interruptible sleep is used for waiting and
+ * %true will be returned regardless of why it is woken up.  On %true
+ * return, callers should ensure that the whole operation is restarted
+ * using the syscall restart mechanism so that operations like freezing or
+ * killing don't get blocked by TRAPPING waits.
  *
  * CONTEXT:
  * read_lock(&tasklist_lock) and spin_lock_irq(&child->sighand->siglock).
@@ -66,7 +70,7 @@ bool ptrace_wait_trapping(struct task_struct *child)
 	get_task_struct(child);
 	read_unlock(&tasklist_lock);
 	wait_on_bit(&child->jobctl, ilog2(JOBCTL_TRAPPING),
-		    ptrace_trapping_sleep_fn, TASK_UNINTERRUPTIBLE);
+		    ptrace_trapping_sleep_fn, TASK_INTERRUPTIBLE);
 	put_task_struct(child);
 	return true;
 }
-- 
1.7.1

