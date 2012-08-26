Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2HZBjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 21:39:13 -0400
Received: from cat.he.net ([216.218.139.2]:45111 "HELO cat.he.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753408Ab2HZBjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 21:39:10 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2012 21:39:10 EDT
From: ecashin@cat.he.net
Message-Id: <1345944687.24968@cat.he.net>
Date: Sat, 25 Aug 2012 18:31:27 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/14] aoe: kernel thread handles I/O completions for
 simple locking
In-Reply-To: <20120824142257.cbfb21a6.akpm@linux-foundation.org>
References: <cover.1345743800.git.ecashin@coraid.com>
	<752ecb77a67b4ba55e8f3ebddd745491aacc8818.1345743801.git.ecashin@coraid.com>
	<20120824142257.cbfb21a6.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ed Cashin <ecashin@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012 14:22:57 -0700, Andrew Morton wrote:

> On Fri, 17 Aug 2012 21:24:08 -0400
> Ed Cashin <ecashin@coraid.com> wrote:
...
> > +#ifdef PF_NOFREEZE
> 
> PF_NOFREEZE can never be undefined.
> 
> > +	current->flags |= PF_NOFREEZE;
> > +#endif
> > +	set_user_nice(current, -10);
> > +	sigfillset(&blocked);
> > +	sigprocmask(SIG_BLOCK, &blocked, NULL);
> > +	flush_signals(current);
> 
> This is a kernel thread - it shouldn't need to fiddle with signals.
> 
> > +	complete(&k->rendez);
> 
> That's odd.  Why do a complete() before we even start?  A code comment
> is needed if this is indeed correct.

There is a whole class of races that goes away when the code starting
a thread waits for the thread to be running before proceeding, and that's
what this rendezvous is for.  I've added a comment that will appear next
time I send the patchset.

(More comments below.)

> > +	do {
> > +		__set_current_state(TASK_UNINTERRUPTIBLE);
> 
> I think this statement is simply unneeded.
> 
> > +		spin_lock_irq(k->lock);
> > +		more = k->fn();
> > +		if (!more) {
> > +			add_wait_queue(k->waitq, &wait);
> > +			__set_current_state(TASK_INTERRUPTIBLE);
> > +		}
> > +		spin_unlock_irq(k->lock);
> > +		if (!more) {
> > +			schedule();
> > +			remove_wait_queue(k->waitq, &wait);
> > +		} else
> > +			cond_resched();
> 
> Here we can do a cond_resched() when in state TASK_INTERRUPTIBLE.  Such
> a schedule() will never return unless some other thread flips this task
> into state TASK_RUNNING.  But if another thread does that, we should
> have been on that waitqueue!
> 
> It seems all confused and racy.

When we do a cond_resched, it's only when "more" is non-zero, in which
case, we did not set the state to TASK_INTERRUPTIBLE.  I do like
your suggestions, though.

Please check out the (post-patchset) changes below that I plan to
incorporate into the patchset for resubmission, and let me know if
you see a race now that your suggestions have been incorporated.

It seems to work just as well in the testing I did with the changes
below incorporated.

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index d91b8d0..97d05fa 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1075,20 +1075,13 @@ kthread(void *vp)
 {
 	struct ktstate *k;
 	DECLARE_WAITQUEUE(wait, current);
-	sigset_t blocked;
 	int more;
 
 	k = vp;
-#ifdef PF_NOFREEZE
 	current->flags |= PF_NOFREEZE;
-#endif
 	set_user_nice(current, -10);
-	sigfillset(&blocked);
-	sigprocmask(SIG_BLOCK, &blocked, NULL);
-	flush_signals(current);
-	complete(&k->rendez);
+	complete(&k->rendez);	/* tell spawner we're running */
 	do {
-		__set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_lock_irq(k->lock);
 		more = k->fn();
 		if (!more) {
@@ -1102,8 +1095,7 @@ kthread(void *vp)
 		} else
 			cond_resched();
 	} while (!kthread_should_stop());
-	__set_current_state(TASK_RUNNING);
-	complete(&k->rendez);
+	complete(&k->rendez);	/* tell spawner we're stopping */
 	return 0;
 }
 
@@ -1122,10 +1114,10 @@ aoe_ktstart(struct ktstate *k)
 	init_completion(&k->rendez);
 	task = kthread_run(kthread, k, k->name);
 	if (task == NULL || IS_ERR(task))
-		return -EFAULT;
+		return -ENOMEM;
 	k->task = task;
-	wait_for_completion(&k->rendez);
-	init_completion(&k->rendez);	/* for exit */
+	wait_for_completion(&k->rendez); /* allow kthread to start */
+	init_completion(&k->rendez);	/* for waiting for exit later */
 	return 0;
 }
 
