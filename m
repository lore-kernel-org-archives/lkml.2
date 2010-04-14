Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab0DOH3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:29:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:49115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384Ab0DOH3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:34 -0400
Subject: Re: INFO: suspicious rcu_dereference_check() usage - 
 include/linux/cgroup.h:492 invoked rcu_dereference_check() without 
 protection!
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Paris <eparis@parisplace.org>
Cc: paulmck@linux.vnet.ibm.com, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1271098032.4807.137.camel@twins>
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com>
	 <20100311032843.GE6767@linux.vnet.ibm.com>
	 <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
	 <1271098032.4807.137.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 12:47:38 +0200
Message-ID: <1271242058.32749.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 20:47 +0200, Peter Zijlstra wrote:
> On Mon, 2010-04-12 at 14:44 -0400, Eric Paris wrote:
> > On Wed, Mar 10, 2010 at 11:28 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> 
> > I know you indicated this was fixed in mainline and I see that set of
> > commits objects, but I'm seeing the below spew from linux-next today.
> > 
> > tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > tag: next-20100412
> > commit: bbeecf185fe464ccd7ee97ce6d3646ad686995b4
> > 
> > [    0.035602] ===================================================
> > [    0.036003] [ INFO: suspicious rcu_dereference_check() usage. ]
> > [    0.037006] ---------------------------------------------------
> > [    0.038004] include/linux/cgroup.h:533 invoked
> > rcu_dereference_check() without protection!
> > [    0.039003]
> > [    0.039004] other info that might help us debug this:
> > [    0.039004]
> > [    0.040003]
> > [    0.040004] rcu_scheduler_active = 1, debug_locks = 0
> > [    0.041004] no locks held by swapper/0.
> > [    0.042003]
> > [    0.042004] stack backtrace:
> > [    0.043005] Pid: 0, comm: swapper Not tainted 2.6.34-rc3-next-20100412+ #65
> > [    0.044003] Call Trace:
> > [    0.045015]  [<ffffffff8108584f>] lockdep_rcu_dereference+0xaf/0xc0
> > [    0.046010]  [<ffffffff81044812>] set_task_cpu+0x2d2/0x370
> 
> Oh, right, I still have to sort that out.
> 
> I need to figure out how all that scheduler and cgroup muck interact to
> fix this.

I think the below should cure this..


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3acf694..2e06d87 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -323,6 +323,15 @@ static inline struct task_group *task_group(struct task_struct *p)
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
+	/*
+	 * Strictly speaking this rcu_read_lock() is not needed since the
+	 * task_group is tied to the cgroup, which in turn can never go away
+	 * as long as there are tasks attached to it.
+	 *
+	 * However since task_group() uses task_subsys_state() which is an
+	 * rcu_dereference() user, this quiets CONFIG_PROVE_RCU.
+	 */
+	rcu_read_lock();
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
 	p->se.parent = task_group(p)->se[cpu];
@@ -332,6 +341,7 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
 	p->rt.parent = task_group(p)->rt_se[cpu];
 #endif
+	rcu_read_unlock();
 }
 
 #else


