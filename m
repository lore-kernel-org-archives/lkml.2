Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab0EFGuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:50:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48907 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab0EFGuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:50:13 -0400
Date: Thu, 6 May 2010 08:49:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [GIT PULL] Additional RCU fixes for 2.6.34
Message-ID: <20100506064959.GJ1172@elte.hu>
References: <20100506002838.GA31818@linux.vnet.ibm.com>
 <20100506062250.GC1172@elte.hu>
 <20100506062552.GN27497@kernel.dk>
 <20100506063948.GG1172@elte.hu>
 <20100506064336.GP27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506064336.GP27497@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, May 06 2010, Ingo Molnar wrote:
> > 
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Thu, May 06 2010, Ingo Molnar wrote:
> > > > 
> > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > Hello, Ingo,
> > > > > 
> > > > > Here are three more RCU-lockdep fixes for 2.6.34:
> > > > > 
> > > > > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> > > > > 
> > > > > 							Thanx, Paul
> > > > > 
> > > > > ------------------>
> > > > > Vivek Goyal <vgoyal@redhat.com> (1)
> > > > > 	blk-cgroup: Fix RCU correctness warning in cfq_init_queue()
> > > > > 
> > > > > Paul E. McKenney <paulmck@linux.vnet.ibm.com> (2)
> > > > > 	vfs: fix RCU-lockdep false positive due to /proc access
> > > > > 	memcg: css_id() must be called under rcu_read_lock()
> > > > > 
> > > > >  block/cfq-iosched.c      |    2 ++
> > > > >  include/linux/fdtable.h  |    3 ++-
> > > > >  include/linux/rcupdate.h |   11 +++++++++++
> > > > >  kernel/rcupdate.c        |   11 +++++++++++
> > > > >  mm/memcontrol.c          |   21 ++++++++++++++++-----
> > > > >  5 files changed, 42 insertions(+), 6 deletions(-)
> > > > 
> > > > Pulled, thanks Paul!
> > > > 
> > > > Jens, is that blk-cgroup fix from Vivek fine to you via this route?
> > > 
> > > Sure, I did think it was a bit odd to funnel it through that route, but it's 
> > > no big deal.
> > 
> > I havent pushed the tree out yet, wanted to wait for your feedback before 
> > doing anything permanent. You can still apply it to the block tree.
> > 
> > You were Cc:-ed 3 days ago to this patch, when RCU fixes got posted. These are 
> > basically the leftover PROVE_RCU fix patches that didnt get picked up by 
> > subsystem trees.
> 
> Yes I read it then, and Paul said he'd applied it. So I didn't touch it, it 
> was trivial enough that the path to the kernel wasn't that big of a problem. 
> And it didn't cause me any merge issues, so no harm done.
> 
> I can easily pull it in since I have a fix or two for .34 left yet, but if 
> you already have it stashed and ready to submit, lets just leave it there.

Yeah, please apply it to the block tree (i have just zapped it from my local 
tree), we really want subsystem patches to go via their respective trees. I've 
attached the latest patch below.

Thanks!

	Ingo

------------------->
From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 22 Apr 2010 11:54:52 -0400
Subject: [PATCH] blk-cgroup: Fix RCU correctness warning in cfq_init_queue()

It is necessary to be in an RCU read-side critical section when invoking
css_id(), so this patch adds one to blkiocg_add_blkio_group().  This is
actually a false positive, because this is called at initialization time
and hence always refers to the root cgroup, which cannot go away.

[  103.790505] ===================================================
[  103.790509] [ INFO: suspicious rcu_dereference_check() usage. ]
[  103.790511] ---------------------------------------------------
[  103.790514] kernel/cgroup.c:4432 invoked rcu_dereference_check() without protection!
[  103.790517]
[  103.790517] other info that might help us debug this:
[  103.790519]
[  103.790521]
[  103.790521] rcu_scheduler_active = 1, debug_locks = 1
[  103.790524] 4 locks held by bash/4422:
[  103.790526]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8114befa>] sysfs_write_file+0x3c/0x144
[  103.790537]  #1:  (s_active#102){.+.+.+}, at: [<ffffffff8114bfa5>] sysfs_write_file+0xe7/0x144
[  103.790544]  #2:  (&q->sysfs_lock){+.+.+.}, at: [<ffffffff812263b1>] queue_attr_store+0x49/0x8f
[  103.790552]  #3:  (&(&blkcg->lock)->rlock){......}, at: [<ffffffff8122e4db>] blkiocg_add_blkio_group+0x2b/0xad
[  103.790560]
[  103.790561] stack backtrace:
[  103.790564] Pid: 4422, comm: bash Not tainted 2.6.34-rc4-blkio-second-crash #81
[  103.790567] Call Trace:
[  103.790572]  [<ffffffff81068f57>] lockdep_rcu_dereference+0x9d/0xa5
[  103.790577]  [<ffffffff8107fac1>] css_id+0x44/0x57
[  103.790581]  [<ffffffff8122e503>] blkiocg_add_blkio_group+0x53/0xad
[  103.790586]  [<ffffffff81231936>] cfq_init_queue+0x139/0x32c
[  103.790591]  [<ffffffff8121f2d0>] elv_iosched_store+0xbf/0x1bf
[  103.790595]  [<ffffffff812263d8>] queue_attr_store+0x70/0x8f
[  103.790599]  [<ffffffff8114bfa5>] ? sysfs_write_file+0xe7/0x144
[  103.790603]  [<ffffffff8114bfc6>] sysfs_write_file+0x108/0x144
[  103.790609]  [<ffffffff810f527f>] vfs_write+0xae/0x10b
[  103.790612]  [<ffffffff81069863>] ? trace_hardirqs_on_caller+0x10c/0x130
[  103.790616]  [<ffffffff810f539c>] sys_write+0x4a/0x6e
[  103.790622]  [<ffffffff81002b5b>] system_call_fastpath+0x16/0x1b
[  103.790625]

Located-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 block/cfq-iosched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 838834b..5f127cf 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3694,8 +3694,10 @@ static void *cfq_init_queue(struct request_queue *q)
 	 * to make sure that cfq_put_cfqg() does not try to kfree root group
 	 */
 	atomic_set(&cfqg->ref, 1);
+	rcu_read_lock();
 	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd,
 					0);
+	rcu_read_unlock();
 #endif
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
