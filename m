Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab1BPB5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:57:38 -0500
Received: from kroah.org ([198.145.64.141]:49267 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758564Ab1BPBvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:03 2011
Message-Id: <20110216014703.456525302@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [092/115] sched: suppress RCU lockdep splat in task_fork_fair
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: b0a0f667a349247bd7f05f806b662a25653822bc upstream

> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> /home/greearb/git/linux.wireless-testing/kernel/sched.c:618 invoked rcu_dereference_check() without protection!
>
> other info that might help us debug this:
>
> rcu_scheduler_active = 1, debug_locks = 1
> 1 lock held by ifup/23517:
>   #0:  (&rq->lock){-.-.-.}, at: [<c042f782>] task_fork_fair+0x3b/0x108
>
> stack backtrace:
> Pid: 23517, comm: ifup Not tainted 2.6.36-rc6-wl+ #5
> Call Trace:
>   [<c075e219>] ? printk+0xf/0x16
>   [<c0455842>] lockdep_rcu_dereference+0x74/0x7d
>   [<c0426854>] task_group+0x6d/0x79
>   [<c042686e>] set_task_rq+0xe/0x57
>   [<c042f79e>] task_fork_fair+0x57/0x108
>   [<c042e965>] sched_fork+0x82/0xf9
>   [<c04334b3>] copy_process+0x569/0xe8e
>   [<c0433ef0>] do_fork+0x118/0x262
>   [<c076302f>] ? do_page_fault+0x16a/0x2cf
>   [<c044b80c>] ? up_read+0x16/0x2a
>   [<c04085ae>] sys_clone+0x1b/0x20
>   [<c04030a5>] ptregs_clone+0x15/0x30
>   [<c0402f1c>] ? sysenter_do_call+0x12/0x38

Here a newly created task is having its runqueue assigned.  The new task
is not yet on the tasklist, so cannot go away.  This is therefore a false
positive, suppress with an RCU read-side critical section.

Reported-by: Ben Greear <greearb@candelatech.com
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Ben Greear <greearb@candelatech.com
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_fair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1992,8 +1992,11 @@ static void task_fork_fair(struct task_s
 
 	update_rq_clock(rq);
 
-	if (unlikely(task_cpu(p) != this_cpu))
+	if (unlikely(task_cpu(p) != this_cpu)) {
+		rcu_read_lock();
 		__set_task_cpu(p, this_cpu);
+		rcu_read_unlock();
+	}
 
 	update_curr(cfs_rq);
 


