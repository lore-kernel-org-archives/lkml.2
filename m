Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab0LJUdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:33:03 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48041 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950Ab0LJUdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:33:01 -0500
Date: Fri, 10 Dec 2010 12:32:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
Message-ID: <20101210203257.GI2125@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1290852958.git.npiggin@kernel.dk>
 <20101207215653.GA25864@dastard>
 <AANLkTinwDr7Xga_gk4vjZ2MgGYGXhxka2JvOAVwfvKQ8@mail.gmail.com>
 <20101208033212.GF29333@dastard>
 <20101208042816.GA32766@dastard>
 <20101208070909.GB14846@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101208070909.GB14846@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 06:09:09PM +1100, Nick Piggin wrote:
> On Wed, Dec 08, 2010 at 03:28:16PM +1100, Dave Chinner wrote:
> > On Wed, Dec 08, 2010 at 02:32:12PM +1100, Dave Chinner wrote:
> > > On Wed, Dec 08, 2010 at 12:47:42PM +1100, Nick Piggin wrote:
> > > > On Wed, Dec 8, 2010 at 8:56 AM, Dave Chinner <david@fromorbit.com> wrote:
> > > > > On Sat, Nov 27, 2010 at 09:15:58PM +1100, Nick Piggin wrote:
> > > > >>
> > > > >> git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git vfs-scale-working
> > > > >>
> > > > >> Here is an new set of vfs patches for review, not that there was much interest
> > > > >> last time they were posted. It is structured like:
> > > > >>
> > > > >> * preparation patches
> > > > >> * introduce new locks to take over dcache_lock, then remove it
> > > > >> * cleaning up and reworking things for new locks
> > > > >> * rcu-walk path walking
> > > > >> * start on some fine grained locking steps
> > > > >
> > > > > Stress test doing:
> > > > >
> > > > >        single thread 50M inode create
> > > > >        single thread rm -rf
> > > > >        2-way 50M inode create
> > > > >        2-way rm -rf
> > > > >        4-way 50M inode create
> > > > >        4-way rm -rf
> > > > >        8-way 50M inode create
> > > > >        8-way rm -rf
> > > > >        8-way 250M inode create
> > > > >        8-way rm -rf
> > > > >
> > > > > Failed about 5 minutes into the "4-way rm -rf" (~3 hours into the test)
> > > > > with a CPU stuck spinning on here:
> > > > >
> > > > > [37372.084012] NMI backtrace for cpu 5
> > > > > [37372.084012] CPU 5
> > > > > [37372.084012] Modules linked in:
> > > > > [37372.084012]
> > > > > [37372.084012] Pid: 15214, comm: rm Not tainted 2.6.37-rc4-dgc+ #797 /Bochs
> > > > > [37372.084012] RIP: 0010:[<ffffffff810643c4>]  [<ffffffff810643c4>] __ticket_spin_lock+0x14/0x20
> > > > > [37372.084012] RSP: 0018:ffff880114643c98  EFLAGS: 00000213
> > > > > [37372.084012] RAX: 0000000000008801 RBX: ffff8800687be6c0 RCX: ffff8800c4eb2688
> > > > > [37372.084012] RDX: ffff880114643d38 RSI: ffff8800dfd4ea80 RDI: ffff880114643d14
> > > > > [37372.084012] RBP: ffff880114643c98 R08: 0000000000000003 R09: 0000000000000000
> > > > > [37372.084012] R10: 0000000000000000 R11: dead000000200200 R12: ffff880114643d14
> > > > > [37372.084012] R13: ffff880114643cb8 R14: ffff880114643d38 R15: ffff8800687be71c
> > > > > [37372.084012] FS:  00007fd6d7c93700(0000) GS:ffff8800dfd40000(0000) knlGS:0000000000000000
> > > > > [37372.084012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > > > [37372.084012] CR2: 0000000000bbd108 CR3: 0000000107146000 CR4: 00000000000006e0
> > > > > [37372.084012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > [37372.084012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > > [37372.084012] Process rm (pid: 15214, threadinfo ffff880114642000, task ffff88011b16f890)
> > > > > [37372.084012] Stack:
> > > > > [37372.084012]  ffff880114643ca8 ffffffff81ad044e ffff880114643cf8 ffffffff81167ae7
> > > > > [37372.084012]  0000000000000000 ffff880114643d38 000000000000000e ffff88011901d800
> > > > > [37372.084012]  ffff8800cdb7cf5c ffff88011901d8e0 0000000000000000 0000000000000000
> > > > > [37372.084012] Call Trace:
> > > > > [37372.084012]  [<ffffffff81ad044e>] _raw_spin_lock+0xe/0x20
> > > > > [37372.084012]  [<ffffffff81167ae7>] shrink_dentry_list+0x47/0x370
> > > > > [37372.084012]  [<ffffffff81167f5e>] __shrink_dcache_sb+0x14e/0x1e0
> > > > > [37372.084012]  [<ffffffff81168456>] shrink_dcache_parent+0x276/0x2d0
> > > > > [37372.084012]  [<ffffffff81ad044e>] ? _raw_spin_lock+0xe/0x20
> > > > > [37372.084012]  [<ffffffff8115daa2>] dentry_unhash+0x42/0x80
> > > > > [37372.084012]  [<ffffffff8115db48>] vfs_rmdir+0x68/0x100
> > > > > [37372.084012]  [<ffffffff8115fd93>] do_rmdir+0x113/0x130
> > > > > [37372.084012]  [<ffffffff8114f5ad>] ? filp_close+0x5d/0x90
> > > > > [37372.084012]  [<ffffffff8115fde5>] sys_unlinkat+0x35/0x40
> > > > > [37372.084012]  [<ffffffff8103a002>] system_call_fastpath+0x16/0x1b
> > > > 
> > > > OK good, with any luck, that's the same bug.
> > > > 
> > > > Is this XFS?
> > > 
> > > Yes.
> > > 
> > > > Is there any concurrent activity happening on the same dentries?
> > > 
> > > Not from an application perspective.
> > > 
> > > > Ie. are the rm -rf threads running on the same directories,
> > > 
> > > No, each thread operating on a different directory.
> 
> This is probably fixed by the same patch as the lockdep splat trace.
> 
> 
> > > > or is there any reclaim happening in the background?
> > > 
> > > IIRC, kswapd was consuming about 5-10% of a CPU during parallel
> > > unlink tests. Mainly reclaiming XFS inodes, I think, but there may
> > > be dentry cache reclaim going as well.
> > 
> > Turns out that the kswapd peaks are upwards of 50% of a CPU for a
> > few seconds, then idle for 10-15s. Typical perf top output of kswapd
> > while it is active during unlinks is:
> > 
> >              samples  pcnt function                    DSO
> >              _______ _____ ___________________________ _________________
> > 
> >             17168.00 10.2% __call_rcu                  [kernel.kallsyms]
> >             13223.00  7.8% kmem_cache_free             [kernel.kallsyms]
> >             12917.00  7.6% down_write                  [kernel.kallsyms]
> >             12665.00  7.5% xfs_iunlock                 [kernel.kallsyms]
> >             10493.00  6.2% xfs_reclaim_inode_grab      [kernel.kallsyms]
> >              9314.00  5.5% __lookup_tag                [kernel.kallsyms]
> >              9040.00  5.4% radix_tree_delete           [kernel.kallsyms]
> >              8694.00  5.1% is_bad_inode                [kernel.kallsyms]
> >              7639.00  4.5% __ticket_spin_lock          [kernel.kallsyms]
> >              6821.00  4.0% _raw_spin_unlock_irqrestore [kernel.kallsyms]
> >              5484.00  3.2% __d_drop                    [kernel.kallsyms]
> >              5114.00  3.0% xfs_reclaim_inode           [kernel.kallsyms]
> >              4626.00  2.7% __rcu_process_callbacks     [kernel.kallsyms]
> >              3556.00  2.1% up_write                    [kernel.kallsyms]
> >              3206.00  1.9% _cond_resched               [kernel.kallsyms]
> >              3129.00  1.9% xfs_qm_dqdetach             [kernel.kallsyms]
> >              2327.00  1.4% radix_tree_tag_clear        [kernel.kallsyms]
> >              2327.00  1.4% call_rcu_sched              [kernel.kallsyms]
> >              2262.00  1.3% __ticket_spin_unlock        [kernel.kallsyms]
> >              2215.00  1.3% xfs_ilock                   [kernel.kallsyms]
> >              2200.00  1.3% radix_tree_gang_lookup_tag  [kernel.kallsyms]
> >              1982.00  1.2% xfs_reclaim_inodes_ag       [kernel.kallsyms]
> >              1736.00  1.0% xfs_trans_unlocked_item     [kernel.kallsyms]
> >              1707.00  1.0% __ticket_spin_trylock       [kernel.kallsyms]
> >              1688.00  1.0% xfs_perag_get_tag           [kernel.kallsyms]
> >              1660.00  1.0% flat_send_IPI_mask          [kernel.kallsyms]
> >              1538.00  0.9% xfs_inode_item_destroy      [kernel.kallsyms]
> >              1312.00  0.8% __shrink_dcache_sb          [kernel.kallsyms]
> >               940.00  0.6% xfs_perag_put               [kernel.kallsyms]
> > 
> > So there is some dentry cache reclaim going on. 
> > 
> > FWIW, it appears there is quite a lot of RCU freeing overhead (~15%
> > more CPU time) in the work kswapd is doing during these unlinks, too.
> > I just had a look at kswapd when a 8-way create is running - it's running at
> > 50-60% of a cpu for seconds at a time. I caught this while it was doing pure
> > XFS inode cache reclaim (~10s sample, kswapd reclaimed ~1M inodes):
> > 
> >              samples  pcnt function                    DSO
> >              _______ _____ ___________________________ _________________
> > 
> >             27171.00  9.0% __call_rcu                  [kernel.kallsyms]
> >             21491.00  7.1% down_write                  [kernel.kallsyms]
> >             20916.00  6.9% xfs_reclaim_inode           [kernel.kallsyms]
> >             20313.00  6.7% radix_tree_delete           [kernel.kallsyms]
> >             15828.00  5.3% kmem_cache_free             [kernel.kallsyms]
> >             15819.00  5.2% xfs_idestroy_fork           [kernel.kallsyms]
> >             14893.00  4.9% is_bad_inode                [kernel.kallsyms]
> >             14666.00  4.9% _raw_spin_unlock_irqrestore [kernel.kallsyms]
> >             14191.00  4.7% xfs_reclaim_inode_grab      [kernel.kallsyms]
> >             14105.00  4.7% xfs_iunlock                 [kernel.kallsyms]
> >             10916.00  3.6% __ticket_spin_lock          [kernel.kallsyms]
> >             10125.00  3.4% xfs_iflush_cluster          [kernel.kallsyms]
> >              8221.00  2.7% xfs_qm_dqdetach             [kernel.kallsyms]
> >              7639.00  2.5% xfs_trans_unlocked_item     [kernel.kallsyms]
> >              7028.00  2.3% xfs_synchronize_times       [kernel.kallsyms]
> >              6974.00  2.3% up_write                    [kernel.kallsyms]
> >              5870.00  1.9% call_rcu_sched              [kernel.kallsyms]
> >              5634.00  1.9% _cond_resched               [kernel.kallsyms]
> > 
> > Which is showing a similar amount of RCU overhead as the unlink as above.
> > And this while it was doing dentry cache reclaim (~10s sample):
> > 
> >             35921.00 15.7% __d_drop                      [kernel.kallsyms]
> >             30056.00 13.1% __ticket_spin_trylock         [kernel.kallsyms]
> >             29066.00 12.7% __ticket_spin_lock            [kernel.kallsyms]
> >             19043.00  8.3% __call_rcu                    [kernel.kallsyms]
> >             10098.00  4.4% iput                          [kernel.kallsyms]
> >              7013.00  3.1% __shrink_dcache_sb            [kernel.kallsyms]
> >              6774.00  3.0% __percpu_counter_add          [kernel.kallsyms]
> >              6708.00  2.9% radix_tree_tag_set            [kernel.kallsyms]
> >              5362.00  2.3% xfs_inactive                  [kernel.kallsyms]
> >              5130.00  2.2% __ticket_spin_unlock          [kernel.kallsyms]
> >              4884.00  2.1% call_rcu_sched                [kernel.kallsyms]
> >              4621.00  2.0% dentry_lru_del                [kernel.kallsyms]
> >              3735.00  1.6% bit_waitqueue                 [kernel.kallsyms]
> >              3727.00  1.6% dentry_iput                   [kernel.kallsyms]
> >              3473.00  1.5% shrink_icache_memory          [kernel.kallsyms]
> >              3279.00  1.4% kfree                         [kernel.kallsyms]
> >              3101.00  1.4% xfs_perag_get                 [kernel.kallsyms]
> >              2516.00  1.1% kmem_cache_free               [kernel.kallsyms]
> >              2272.00  1.0% shrink_dentry_list            [kernel.kallsyms]
> > 
> > I've never really seen any signficant dentry cache reclaim overhead
> > in profiles of these workloads before, so this was a bit of a
> > surprise....
> 
> call_rcu shouldn't be doing much, except for disabling irqs and linking
> the object into the list. I have a patch somewhere to reduce the irq
> disable overhead a bit, but it really shouldn't be doing a lot of work.

Could you please enable CONFIG_RCU_TRACE, mount debugfs somewhere, and
look at rcu/rcudata?  There will be a "ql=" number printed for each
CPU, and if that number is too large, __call_rcu() does take what it
considers to be corrective action, which can incur some overhead.

If this is the problem, then increasing the value of the qhimark module
parameter might help.

If this is not the problem, I could make a patch that disables some of
__call_rcu()'s grace-period acceleration code if you are willing to try
it out.

> Sometimes you find that touching the rcu head field needs to get a
> cacheline exclusive, so a bit of work gets transferred there....
> 
> But it may also be something going a bit wrong in RCU. I blew it up
> once already, after the files_lock splitup that enabled all CPUs to
> create and destroy files :)

I would certainly like the opportunity to fix any bugs that might be
in RCU...  ;-)

							Thanx, Paul
