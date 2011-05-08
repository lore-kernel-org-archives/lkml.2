Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1EHNgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 09:36:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab1EHNgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 09:36:48 -0400
Date: Sun, 8 May 2011 15:35:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH ptrace] ptrace: fix signal->wait_chldexit usage in
	task_clear_group_stop_trapping()
Message-ID: <20110508133543.GA4820@redhat.com>
References: <20110506095222.GB8824@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506095222.GB8824@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06, Tejun Heo wrote:
>
> GROUP_STOP_TRAPPING waiting mechanism piggybacks on
> signal->wait_chldexit which is primarily used to implement waiting for
> wait(2) and friends.  When do_wait() waits on signal->wait_chldexit,
> it uses a custom wake up callback, child_wait_callback(), which
> expects the child task which is waking up the parent to be passed in
> as @key to filter out spurious wakeups.
>
> task_clear_group_stop_trapping() used __wake_up_sync() which uses NULL
> @key causing the following oops if the parent was doing do_wait().
>
>   BUG: unable to handle kernel NULL pointer dereference at 00000000000002d8
>   IP: [<ffffffff810499f9>] child_wait_callback+0x29/0x80

Argh! Shame on me. Somehow I convinced myself that this needs the cleanup
but safe because we are not going to wake up the TASK_INTTERRUPTIBLE tasks
sleeping in do_wait(). Somehow I forgot that wait_queue_t->func() is called
anyway without checking "mode". I even specially mentioned this should be
safe during the review ;)

> I still think it's a mistake to piggyback on wait_chldexit for this.

Agreed. Previously I thought we should teach __wake_up_parent() to wake
up the TASK_UNINTERRUPTIBLE tasks, now I think this is not needed.

> Given the relative low frequency of ptrace use, we would be much
> better off leaving already complex wait_chldexit alone and using bit
> waitqueue.

Well, I don't think so. wait_on_bit() looks as unnecessary complication
to me. See below.

> --- work.orig/kernel/signal.c
> +++ work/kernel/signal.c
> @@ -238,8 +238,8 @@ static void task_clear_group_stop_trappi
>  {
>  	if (unlikely(task->group_stop & GROUP_STOP_TRAPPING)) {
>  		task->group_stop &= ~GROUP_STOP_TRAPPING;
> -		__wake_up_sync(&task->parent->signal->wait_chldexit,
> -			       TASK_UNINTERRUPTIBLE, 1);
> +		__wake_up_sync_key(&task->parent->signal->wait_chldexit,
> +				   TASK_UNINTERRUPTIBLE, 1, task);
>  	}
>  }

I believe this is correct and should fix the problem.


But. Why do we need signal->wait_chldexit or bit waitqueue at all?
Previously this was needed because wait_event(!GROUP_STOP_TRAPPING)
was called from ptrace_check_attach(), and the tracer can do anything
after ptrace_attach() which sets GROUP_STOP_TRAPPING.

With the current code we know that GROUP_STOP_TRAPPING means: the
tracer can't go away from ptrace_attach() until we clear this bit.

How about the patch below instead?


Hmm. This is minor and off-topic, but perhaps it makes sense to move
the code which sets/waits GROUP_STOP_TRAPPING from ptrace_attach() to
the separate function, it can be called outside of tasklist_lock and
cred_guard_mutex.

And. Could you remind why ptrace_attach() does signal_wake_up() instead
of wake_up_state(TASK_STOPPED) ? OK, in general we shouldn't set
GROUP_STOP_PENDING without TIF_SIGPENDING, but in this case?

Oleg.

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -256,9 +256,16 @@ unlock_tasklist:
 unlock_creds:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
-	if (wait_trap)
-		wait_event(current->signal->wait_chldexit,
-			   !(task->group_stop & GROUP_STOP_TRAPPING));
+	if (wait_trap) {
+		for (;;) {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			if (!(task->group_stop & GROUP_STOP_TRAPPING))
+				break;
+			schedule();
+		}
+		__set_current_state(TASK_RUNNING);
+	}
+
 	return retval;
 }
 
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -238,8 +238,7 @@ static void task_clear_group_stop_trappi
 {
 	if (unlikely(task->group_stop & GROUP_STOP_TRAPPING)) {
 		task->group_stop &= ~GROUP_STOP_TRAPPING;
-		__wake_up_sync(&task->parent->signal->wait_chldexit,
-			       TASK_UNINTERRUPTIBLE, 1);
+		wake_up_process(task->parent);
 	}
 }
 

