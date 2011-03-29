Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1C2Oqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:46:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54738 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1C2Oqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N+P2xjBU1B7WzNyowH2E9mL4Zb8bx3djsSmnVT1unoA/h7ZyxZlA5ntZlHxBga+gXs
         DcZMkLB+5DZlJJ5tsFeFI/Co5Nm5NeUuL7eqrbOlNBbPIKf31GYZ0/H/DV8zegGc3/Ft
         HQ3Ukzhpgyl+nUCHFalVIyWx/uwI2YEi+K5tA=
Date: Tue, 29 Mar 2011 16:46:48 +0200
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: [PATCH 2/3] signal, ptrace: Add SIGTRAP signal_wake_up()
Message-ID: <20110329144648.GB29865@htj.dyndns.org>
References: <20110329144603.GA29865@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329144603.GA29865@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace needs the ability to kick tasks in STOPPED or TRACED states and
was selectively using %SIGKILL when calling signal_wake_up() to
achieve it.

Add %SIGTRAP wake up mode to signal_wake_up() which wakes up tasks in
interruptible sleep, stopped or traced state and use it in
__ptrace_unlink() and ptrace_attach().

Although this changes the used wakeup mask, it doesn't cause any
behavior change as the target task is already known to be in specific
states.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/ptrace.c |    8 +++-----
 kernel/signal.c |    7 +++++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index ec8cce6..3989a7e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -86,12 +86,10 @@ void __ptrace_unlink(struct task_struct *child)
 
 	/*
 	 * If transition to TASK_STOPPED is pending or in TASK_TRACED, kick
-	 * @child in the butt.  Note that %SIGKILL wake up should be used
-	 * iff @child is in TASK_TRACED; otherwise, we might unduly disrupt
-	 * TASK_KILLABLE sleeps.
+	 * @child in the butt.
 	 */
 	if (child->group_stop & GROUP_STOP_PENDING || task_is_traced(child))
-		signal_wake_up(child, task_is_traced(child) ? SIGKILL : 0);
+		signal_wake_up(child, SIGTRAP);
 
 	spin_unlock(&child->sighand->siglock);
 }
@@ -243,7 +241,7 @@ static int ptrace_attach(struct task_struct *task)
 	 */
 	if (task_is_stopped(task)) {
 		task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
-		signal_wake_up(task, SIGKILL);
+		signal_wake_up(task, SIGTRAP);
 		wait_trap = true;
 	}
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 837070c..ff63459 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -631,6 +631,9 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
  *		should be brought in to deliver the signal.  When @t is in
  *		kernel, wake it up iff it's in interruptible sleep.
  *
+ * %SIGTRAP	Used by ptrace.  In addition to the usual kicking,
+ *		interrupt STOPPED and TRACED sleeps.
+ *
  * %SIGKILL	@t is being killed.  In addition to the usual kicking,
  *		interrupt KILLABLE, STOPPED and TRACED sleeps using
  *		%TASK_WAKEKILL.
@@ -649,6 +652,10 @@ void signal_wake_up(struct task_struct *t, int sig_type)
 		mask = TASK_INTERRUPTIBLE;
 		break;
 
+	case SIGTRAP:
+		mask = TASK_INTERRUPTIBLE | __TASK_STOPPED | __TASK_TRACED;
+		break;
+
 	case SIGKILL:
 		/*
 		 * For SIGKILL, we want to wake it up in the stopped /
-- 
1.7.1

