Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967678Ab2EQTT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 15:19:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:44102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab2EQTT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 15:19:57 -0400
Message-ID: <1337282386.4281.77.camel@twins>
Subject: Re: lockdep false positive in double_lock_balance()?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roland Dreier <roland@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        rostedt <rostedt@goodmis.org>
Date: Thu, 17 May 2012 21:19:46 +0200
In-Reply-To: <1337198420-5062-1-git-send-email-roland@kernel.org>
References: <1335314100-532-1-git-send-email-roland@kernel.org>
	 <alpine.LSU.2.00.1204251411460.4188@eggly.anvils>
	 <1337198420-5062-1-git-send-email-roland@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 13:00 -0700, Roland Dreier wrote:
> Hi scheduler hackers,
> 
> I'm very occasionally seeing the lockdep warning below on our boxes
> running 2.6.39 (PREEMPT=n, so "unfair" _double_lock_balance()).  I
> think I see the explanation, and it's probably not even worth fixing:
> 
> On the unlock side, we have:

<snip>

> while on the lock side we have:

<snip>

> So it seems we have the following (purely lockdep-related) race:
> 
>     unlock:				lock:
> 
> 					if (unlikely(!raw_spin_trylock(&busiest->lock))) { //fail to lock
> 
>     raw_spin_unlock(&busiest->lock);
> 
> 						if (busiest < this_rq) { //not true
> 						} else
> 							raw_spin_lock_nested(&busiest->lock,
> 									      SINGLE_DEPTH_NESTING);
> 
>     lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_); //too late
> 
> where we end up trying to take a second lock with SINGLE_DEPTH_NESTING
> before we've promoted our first lock to subclass 0.

*phew* you actually made me think there ;-)

Anyway, it all sounds very plausible, which is what threw me, but its
wrong :-)

The race you describe exists, except that's not how lockdep works. Both
cpu's would have a different task (one would hope to presume) and the
held lock stack is per task. So even if busiest_rq on cpu1 (lock case)
is the same lock as this_rq on cpu0 (unlock case), they're in different
stacks with different states.

> So does this make sense?

Almost :-)

> Here's the actual lockdep warning:

> [89945.640512]  [<ffffffff8103fa1a>] double_lock_balance+0x5a/0x90
> [89945.640568]  [<ffffffff8104c546>] push_rt_task+0xc6/0x290

this is the clue.. if you look at that code you'll find the
double_lock_balance() in question is the one in find_lock_lowest_rq()
[yay for inlining].

Now find_lock_lowest_rq() has a bug.. it fails to use
double_unlock_balance() in one exit path, if this results in a retry in
push_rt_task() we'll call double_lock_balance() again, at which point
we'll run into said issue.

Presumably this is all rather rare..

Something like this should fix it I think..


---
 kernel/sched/rt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c5565c3..b649108 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1556,7 +1556,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 				     task_running(rq, task) ||
 				     !task->on_rq)) {
 
-				raw_spin_unlock(&lowest_rq->lock);
+				double_unlock_balance(rq, lowest_rq);
 				lowest_rq = NULL;
 				break;
 			}

