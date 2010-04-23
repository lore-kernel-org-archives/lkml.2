Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0DWOrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:47:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab0DWOrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:47:21 -0400
Date: Fri, 23 Apr 2010 10:41:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] blk-cgroup: Fix RCU correctness warning in
	cfq_init_queue()
Message-ID: <20100423144138.GA5026@redhat.com>
References: <20100422155452.GD3228@redhat.com> <20100422231556.GW2524@linux.vnet.ibm.com> <20100422235555.GA12004@redhat.com> <20100423001751.GX2524@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423001751.GX2524@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 05:17:51PM -0700, Paul E. McKenney wrote:
> On Thu, Apr 22, 2010 at 07:55:55PM -0400, Vivek Goyal wrote:
> > On Thu, Apr 22, 2010 at 04:15:56PM -0700, Paul E. McKenney wrote:
> > > On Thu, Apr 22, 2010 at 11:54:52AM -0400, Vivek Goyal wrote:
> > > > With RCU correctness on, We see following warning. This patch fixes it.
> > > 
> > > This is in initialization code, so that there cannot be any concurrent
> > > updates, correct?  If so, looks good.
> > > 
> > 
> > I think theoritically two instances of cfq_init_queue() can be running
> > in parallel (for two different devices), and they both can call
> > blkiocg_add_blkio_group(). But then we use a spin lock to protect
> > blkio_cgroup.
> > 
> > spin_lock_irqsave(&blkcg->lock, flags);
> > 
> > So I guess two parallel updates should be fine.
> 
> OK, in that case, would it be possible add this spinlock to the condition
> checked by css_id()'s rcu_dereference_check()?

Hi Paul,

I think adding these spinlock to condition checked might become little
messy. And the reason being that this lock is subsystem (controller)
specific and maintained by controller. Now if any controller implements
a lock and we add that lock in css_id() rcu_dereference_check(), it will
look ugly.

So probably a better way is to make sure that css_id() is always called
under rcu read lock so that we don't hit this warning?

>  At first glance, css_id()
> needs to gain access to the blkio_cgroup structure that references
> the cgroup_subsys_state structure passed to css_id().
> 
> This means that there is only one blkio_cgroup structure referencing
> a given cgroup_subsys_state structure, right?  Otherwise, we could still
> have concurrent access.

Yes. In fact css object is embedded in blkio_cgroup structure. So we take
a rcu_read_lock() so that data structures associated with cgroup subsystem
don't go away and then take controller specific blkio_cgroup spin lock to
make sure multiple writers don't end up modifying a list at the same time.

Am I missing something.

Thanks
Vivek
 

> > > (Just wanting to make sure that we are not papering over a real error!)
> > > 
> > > 							Thanx, Paul
> > > 
> > > > [  103.790505] ===================================================
> > > > [  103.790509] [ INFO: suspicious rcu_dereference_check() usage. ]
> > > > [  103.790511] ---------------------------------------------------
> > > > [  103.790514] kernel/cgroup.c:4432 invoked rcu_dereference_check() without protection!
> > > > [  103.790517]
> > > > [  103.790517] other info that might help us debug this:
> > > > [  103.790519]
> > > > [  103.790521]
> > > > [  103.790521] rcu_scheduler_active = 1, debug_locks = 1
> > > > [  103.790524] 4 locks held by bash/4422:
> > > > [  103.790526]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8114befa>] sysfs_write_file+0x3c/0x144
> > > > [  103.790537]  #1:  (s_active#102){.+.+.+}, at: [<ffffffff8114bfa5>] sysfs_write_file+0xe7/0x144
> > > > [  103.790544]  #2:  (&q->sysfs_lock){+.+.+.}, at: [<ffffffff812263b1>] queue_attr_store+0x49/0x8f
> > > > [  103.790552]  #3:  (&(&blkcg->lock)->rlock){......}, at: [<ffffffff8122e4db>] blkiocg_add_blkio_group+0x2b/0xad
> > > > [  103.790560]
> > > > [  103.790561] stack backtrace:
> > > > [  103.790564] Pid: 4422, comm: bash Not tainted 2.6.34-rc4-blkio-second-crash #81
> > > > [  103.790567] Call Trace:
> > > > [  103.790572]  [<ffffffff81068f57>] lockdep_rcu_dereference+0x9d/0xa5
> > > > [  103.790577]  [<ffffffff8107fac1>] css_id+0x44/0x57
> > > > [  103.790581]  [<ffffffff8122e503>] blkiocg_add_blkio_group+0x53/0xad
> > > > [  103.790586]  [<ffffffff81231936>] cfq_init_queue+0x139/0x32c
> > > > [  103.790591]  [<ffffffff8121f2d0>] elv_iosched_store+0xbf/0x1bf
> > > > [  103.790595]  [<ffffffff812263d8>] queue_attr_store+0x70/0x8f
> > > > [  103.790599]  [<ffffffff8114bfa5>] ? sysfs_write_file+0xe7/0x144
> > > > [  103.790603]  [<ffffffff8114bfc6>] sysfs_write_file+0x108/0x144
> > > > [  103.790609]  [<ffffffff810f527f>] vfs_write+0xae/0x10b
> > > > [  103.790612]  [<ffffffff81069863>] ? trace_hardirqs_on_caller+0x10c/0x130
> > > > [  103.790616]  [<ffffffff810f539c>] sys_write+0x4a/0x6e
> > > > [  103.790622]  [<ffffffff81002b5b>] system_call_fastpath+0x16/0x1b
> > > > [  103.790625]
> > > > 
> > > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > > ---
> > > >  block/cfq-iosched.c |    2 ++
> > > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > > > index 002a5b6..9386bf8 100644
> > > > --- a/block/cfq-iosched.c
> > > > +++ b/block/cfq-iosched.c
> > > > @@ -3741,8 +3741,10 @@ static void *cfq_init_queue(struct request_queue *q)
> > > >  	 * to make sure that cfq_put_cfqg() does not try to kfree root group
> > > >  	 */
> > > >  	atomic_set(&cfqg->ref, 1);
> > > > +	rcu_read_lock();
> > > >  	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd,
> > > >  					0);
> > > > +	rcu_read_unlock();
> > > >  #endif
> > > >  	/*
> > > >  	 * Not strictly needed (since RB_ROOT just clears the node and we
> > > > -- 
> > > > 1.6.2.5
> > > > 
