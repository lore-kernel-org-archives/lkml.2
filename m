Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251Ab1FWSSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:18:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:34296 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257Ab1FWRgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 085/247] sched: suppress RCU lockdep splat in task_fork_fair
Date: Thu, 23 Jun 2011 13:32:33 -0400
Message-Id: <1308850515-15242-26-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b0a0f667a349247bd7f05f806b662a25653822bc upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched_fair.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3a0f7ba..b0f68035 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3592,8 +3592,11 @@ static void task_fork_fair(struct task_struct *p)
 
 	update_rq_clock(rq);
 
-	if (unlikely(task_cpu(p) != this_cpu))
+	if (unlikely(task_cpu(p) != this_cpu)) {
+		rcu_read_lock();
 		__set_task_cpu(p, this_cpu);
+		rcu_read_unlock();
+	}
 
 	update_curr(cfs_rq);
 
-- 
1.7.4.4

