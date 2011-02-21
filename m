Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1BUQUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:20:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab1BUQUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:20:31 -0500
Date: Mon, 21 Feb 2011 17:11:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: [pseudo patch] ptrace should respect the group stop
Message-ID: <20110221161140.GA24336@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110214173012.GA18742@htj.dyndns.org> <AANLkTinntVGcOdZSS3gWz39eq3EDiMxXgYfc6+M1Z0iE@mail.gmail.com> <20110221151619.GM31267@htj.dyndns.org> <20110221152855.GA20769@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221152855.GA20769@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21, Oleg Nesterov wrote:
>
> On 02/21, Tejun Heo wrote:
> >
> > That preciesly is what is being discussed.  IIUC, Oleg and Roland are
> > saying that the tracee should enter group stop but not ptrace trap at
> > that point and then transition into ptrace trap on the first PTRACE
> > call.
>
> Actually I am not saying this (at least now, probably I did).
>
> Once again. We have the bug with arch_ptrace_stop_needed(), but lets
> ignore it to simplify the discussion.
>
> Suppose that the tracee calls do_signal_stop() and participates in the
> group stop. To me, it doesn't really matter (in the context of this
> discussion) if it stops in TASK_STOPPED or TASK_TRACED (and where it
> stops).
>
> However, I am starting to agree that TASK_TRACED looks more clean.
>
> What is important, I think ptrace should respect SIGNAL_STOP_STOPPED.
> IOW, when the tracee is group-stopped (TASK_STOPPED or TASK_TRACED,
> doesn't matter), ptrace_resume() should not wake it up, but merely
> do set_task_state(TASK_STATE) and make it resumeable by SIGCONT.

IOW. I mean something like the (uncompiled, incomplete) patch below as
as the initial approximation.

Oleg.

--- x/kernel/ptrace.c
+++ x/kernel/ptrace.c
@@ -38,15 +38,15 @@ void __ptrace_link(struct task_struct *c
 }
 
 /*
- * Turn a tracing stop into a normal stop now, since with no tracer there
- * would be no way to wake it up with SIGCONT or SIGKILL.  If there was a
- * signal sent that would resume the child, but didn't because it was in
- * TASK_TRACED, resume it now.
- * Requires that irqs be disabled.
+ * NEW COMMENT
  */
-static void ptrace_untrace(struct task_struct *child)
+static void ptrace_wake_up(struct task_struct *child)
 {
-	spin_lock(&child->sighand->siglock);
+	unsigned long flags;
+
+	if (!lock_task_sighand(child, &flags))
+		return;
+
 	if (task_is_traced(child)) {
 		/*
 		 * If the group stop is completed or in progress,
@@ -56,9 +56,9 @@ static void ptrace_untrace(struct task_s
 		    child->signal->group_stop_count)
 			__set_task_state(child, TASK_STOPPED);
 		else
-			signal_wake_up(child, 1);
+			wake_up_state(child, TASK_TRACED);
 	}
-	spin_unlock(&child->sighand->siglock);
+	unlock_task_sighand(tsk, &flags);
 }
 
 /*
@@ -76,7 +76,7 @@ void __ptrace_unlink(struct task_struct 
 	list_del_init(&child->ptrace_entry);
 
 	if (task_is_traced(child))
-		ptrace_untrace(child);
+		ptrace_wake_up(child);
 }
 
 /*
@@ -312,8 +312,6 @@ int ptrace_detach(struct task_struct *ch
 	if (child->ptrace) {
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
-		if (!child->exit_state)
-			wake_up_state(child, TASK_TRACED | TASK_STOPPED);
 	}
 	write_unlock_irq(&tasklist_lock);
 
@@ -514,7 +512,7 @@ static int ptrace_resume(struct task_str
 	}
 
 	child->exit_code = data;
-	wake_up_process(child);
+	ptrace_wake_up(child);
 
 	return 0;
 }
--- x/kernel/signal.c
+++ x/kernel/signal.c
@@ -1644,8 +1644,11 @@ static void ptrace_stop(int exit_code, i
 	 * If there is a group stop in progress,
 	 * we must participate in the bookkeeping.
 	 */
-	if (current->signal->group_stop_count > 0)
-		--current->signal->group_stop_count;
+	if (current->signal->group_stop_count) {
+		// XXX: this is not enough, we can race with detach
+		if (!--current->signal->group_stop_count)
+			current->signal->flags = SIGNAL_STOP_STOPPED;
+	}
 
 	current->last_siginfo = info;
 	current->exit_code = exit_code;
@@ -1825,6 +1828,9 @@ static int ptrace_signal(int signr, sigi
 	if (sigismember(&current->blocked, signr)) {
 		specific_send_sig_info(signr, info, current);
 		signr = 0;
+	} else if (sig_kernel_stop(signr)) {
+		// XXX: not exactly right but anyway better
+		current->signal->flags |= SIGNAL_STOP_DEQUEUED;
 	}
 
 	return signr;

