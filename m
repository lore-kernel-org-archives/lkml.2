Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1GTLXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 07:23:45 -0400
Received: from mail001.aei.ca ([206.123.6.130]:39166 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab1GTLXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 07:23:43 -0400
From: Ed Tomlinson <edt@aei.ca>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH tip/core/urgent 1/7] rcu: decrease rcu_report_exp_rnp coupling with scheduler
Date: Wed, 20 Jul 2011 07:23:32 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc7-crc+; KDE/4.6.5; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org,
        greearb@candelatech.com
References: <20110720001738.GA16369@linux.vnet.ibm.com> <1311129618.5345.2.camel@twins> <20110720045414.GC2400@linux.vnet.ibm.com>
In-Reply-To: <20110720045414.GC2400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107200723.33819.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 July 2011 00:54:15 Paul E. McKenney wrote:
> On Wed, Jul 20, 2011 at 04:40:18AM +0200, Peter Zijlstra wrote:
> > On Tue, 2011-07-19 at 17:18 -0700, Paul E. McKenney wrote:
> > > +++ b/kernel/rcutree_plugin.h
> > > @@ -696,8 +696,10 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
> > >         raw_spin_lock_irqsave(&rnp->lock, flags);
> > >         for (;;) {
> > >                 if (!sync_rcu_preempt_exp_done(rnp))
> > > +                       raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > >                         break;
> > 
> > I bet that'll all work much better if you wrap it in curly braces like:
> > 
> > 		if (!sync_rcu_preempt_exp_done(rnp)) {
> > 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > 			break;
> > 		}
> > 
> > That might also explain those explosions Ed and Ben have been seeing.
> 
> Indeed.  Must be the call of the snake.  :-(
> 
> Thank you for catching this!
> 
> > >                 if (rnp->parent == NULL) {
> > > +                       raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > >                         wake_up(&sync_rcu_preempt_exp_wq);
> > >                         break;
> > >                 }
> > > @@ -707,7 +709,6 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
> > >                 raw_spin_lock(&rnp->lock); /* irqs already disabled */
> > >                 rnp->expmask &= ~mask;
> > >         }
> > > -       raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > >  } 
> 
> So this time I am testing the exact patch series before resending.
> In the meantime, here is the updated version of this patch.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: decrease rcu_report_exp_rnp coupling with scheduler
> 
> PREEMPT_RCU read-side critical sections blocking an expedited grace
> period invoke rcu_report_exp_rnp().  When the last such critical section
> has completed, rcu_report_exp_rnp() invokes the scheduler to wake up the
> task that invoked synchronize_rcu_expedited() -- needlessly holding the
> root rcu_node structure's lock while doing so, thus needlessly providing
> a way for RCU and the scheduler to deadlock.
> 
> This commit therefore releases the root rcu_node structure's lock before
> calling wake_up().
> 
> Reported-by: Ed Tomlinson <edt@aei.ca>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 75113cb..6abef3c 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -695,9 +695,12 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
>  
>  	raw_spin_lock_irqsave(&rnp->lock, flags);
>  	for (;;) {
> -		if (!sync_rcu_preempt_exp_done(rnp))
> +		if (!sync_rcu_preempt_exp_done(rnp)) {
> +			raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  			break;
> +		}
>  		if (rnp->parent == NULL) {
> +			raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  			wake_up(&sync_rcu_preempt_exp_wq);
>  			break;
>  		}
> @@ -707,7 +710,6 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
>  		raw_spin_lock(&rnp->lock); /* irqs already disabled */
>  		rnp->expmask &= ~mask;
>  	}
> -	raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  }
>  
>  /*

Paul/Peter,

With all 7 fixes applied with the above version of patch 1, I get a warning during boot:

[    3.443140] EXT4-fs (sdc3): mounted filesystem with ordered data mode. Opts: (null)
[    3.456097] VFS: Mounted root (ext4 filesystem) readonly on device 8:35.
[    3.469734] devtmpfs: mounted
[    3.478488] Freeing unused kernel memory: 628k freed
[    3.488590] Write protecting the kernel read-only data: 10240k
[    3.500809] Freeing unused kernel memory: 468k freed
[    3.514158] Freeing unused kernel memory: 1240k freed
[    3.552337] ------------[ cut here ]------------
[    3.553004] ------------[ cut here ]------------
[    3.553004] WARNING: at kernel/rcutree_plugin.h:414 __rcu_read_unlock+0xc9/0x120()
[    3.553004] Hardware name: System Product Name
[    3.553004] Modules linked in:
[    3.553004] Pid: 1, comm: init Not tainted 3.0.0-rcr-crc+ #342
[    3.553004] Call Trace:
[    3.553004]  [<ffffffff8104b00f>] warn_slowpath_common+0x7f/0xc0
[    3.553004]  [<ffffffff8104b06a>] warn_slowpath_null+0x1a/0x20
[    3.553004]  [<ffffffff810bb479>] __rcu_read_unlock+0xc9/0x120
[    3.553004]  [<ffffffff8157d6b1>] __atomic_notifier_call_chain+0x91/0xb0
[    3.553004]  [<ffffffff8157d620>] ? notifier_call_chain+0x80/0x80
[    3.553004]  [<ffffffff812c5860>] ? bit_putcs+0x5b0/0x5b0
[    3.553004]  [<ffffffff8157d6e6>] atomic_notifier_call_chain+0x16/0x20
[    3.553004]  [<ffffffff813203c9>] notify_write+0x29/0x30
[    3.553004]  [<ffffffff81322024>] vt_console_print+0x164/0x3b0
[    3.553004]  [<ffffffff8104b29e>] __call_console_drivers+0x8e/0xb0
[    3.553004]  [<ffffffff8104b30a>] _call_console_drivers+0x4a/0x80
[    3.553004]  [<ffffffff8104b9ed>] console_unlock+0xfd/0x210
[    3.553004]  [<ffffffff8104c246>] vprintk+0x3f6/0x530
[    3.553004]  [<ffffffff810bb479>] ? __rcu_read_unlock+0xc9/0x120
[    3.553004]  [<ffffffff8157585c>] printk+0x41/0x45
[    3.553004]  [<ffffffff810bb479>] ? __rcu_read_unlock+0xc9/0x120
[    3.553004]  [<ffffffff8104afcd>] warn_slowpath_common+0x3d/0xc0
[    3.553004]  [<ffffffff8104b06a>] warn_slowpath_null+0x1a/0x20
[    3.553004]  [<ffffffff810bb479>] __rcu_read_unlock+0xc9/0x120
[    3.553004]  [<ffffffff8103fed8>] cpuacct_charge+0xc8/0xe0
[    3.553004]  [<ffffffff8103fe58>] ? cpuacct_charge+0x48/0xe0
[    3.553004]  [<ffffffff810326b7>] ? task_of+0x97/0xd0
[    3.553004]  [<ffffffff81040ef5>] update_curr+0x1a5/0x210
[    3.553004]  [<ffffffff81576d78>] ? preempt_schedule_irq+0x68/0xa0
[    3.553004]  [<ffffffff810419e0>] put_prev_task_fair+0x110/0x120
[    3.553004]  [<ffffffff81575f3a>] schedule+0x1da/0xc50
[    3.553004]  [<ffffffff81576d72>] ? preempt_schedule_irq+0x62/0xa0
[    3.553004]  [<ffffffff81576d78>] preempt_schedule_irq+0x68/0xa0
[    3.553004]  [<ffffffff8157a316>] retint_kernel+0x26/0x30
[    3.553004]  [<ffffffff810da494>] ? ftrace_likely_update+0x14/0x20
[    3.553004]  [<ffffffff810bb4ab>] __rcu_read_unlock+0xfb/0x120
[    3.553004]  [<ffffffff810f8190>] find_get_page+0x170/0x190
[    3.553004]  [<ffffffff810f8020>] ? find_get_pages+0x280/0x280
[    3.553004]  [<ffffffff81180a30>] __find_get_block_slow+0x40/0x130
[    3.553004]  [<ffffffff81180d5f>] __find_get_block+0xdf/0x210
[    3.553004]  [<ffffffff8157d541>] ? sub_preempt_count+0x51/0x60
[    3.553004]  [<ffffffff81184c5e>] __getblk+0x11e/0x300
[    3.553004]  [<ffffffff81184e55>] __breadahead+0x15/0x60
[    3.553004]  [<ffffffff811e5e9e>] __ext4_get_inode_loc+0x36e/0x3f0
[    3.553004]  [<ffffffff811e7dfe>] ext4_iget+0x7e/0x870
[    3.553004]  [<ffffffff8129247e>] ? do_raw_spin_lock+0xde/0x1c0
[    3.553004]  [<ffffffff811f25e5>] ext4_lookup+0xb5/0x150
[    3.553004]  [<ffffffff8115a5c3>] d_alloc_and_lookup+0xc3/0x100
[    3.553004]  [<ffffffff8115cd00>] do_lookup+0x260/0x480
[    3.553004]  [<ffffffff8157d541>] ? sub_preempt_count+0x51/0x60
[    3.553004]  [<ffffffff8115dc58>] link_path_walk+0x248/0x930
[    3.553004]  [<ffffffff812925f6>] ? __raw_spin_lock_init+0x36/0x60
[    3.553004]  [<ffffffff81160417>] path_openat+0x107/0x4f0
[    3.553004]  [<ffffffff8108b392>] ? lock_release_non_nested+0xb2/0x330
[    3.553004]  [<ffffffff81160979>] do_filp_open+0x49/0x100
[    3.553004]  [<ffffffff8129247e>] ? do_raw_spin_lock+0xde/0x1c0
[    3.553004]  [<ffffffff81579a3c>] ? _raw_spin_unlock+0x5c/0x70
[    3.553004]  [<ffffffff8116db4a>] ? alloc_fd+0xfa/0x140
[    3.553004]  [<ffffffff8114d892>] do_sys_open+0x172/0x220
[    3.553004]  [<ffffffff8114d980>] sys_open+0x20/0x30
[    3.553004]  [<ffffffff815814eb>] system_call_fastpath+0x16/0x1b
[    3.553004] ---[ end trace 9137bd8a48443ea9 ]---
[    3.553004] WARNING: at kernel/rcutree_plugin.h:414 __rcu_read_unlock+0xc9/0x120()
[    3.553004] Hardware name: System Product Name
[    3.553004] Modules linked in:
[    3.553004] Pid: 1, comm: init Tainted: G        W   3.0.0-rcr-crc+ #342
[    3.553004] Call Trace:
[    3.553004]  [<ffffffff8104b00f>] warn_slowpath_common+0x7f/0xc0
[    3.553004]  [<ffffffff8104b06a>] warn_slowpath_null+0x1a/0x20
[    3.553004]  [<ffffffff810bb479>] __rcu_read_unlock+0xc9/0x120
[    3.553004]  [<ffffffff8103fed8>] cpuacct_charge+0xc8/0xe0
[    3.553004]  [<ffffffff8103fe58>] ? cpuacct_charge+0x48/0xe0
[    3.553004]  [<ffffffff810326b7>] ? task_of+0x97/0xd0
[    3.553004]  [<ffffffff81040ef5>] update_curr+0x1a5/0x210
[    3.553004]  [<ffffffff81576d78>] ? preempt_schedule_irq+0x68/0xa0
[    3.553004]  [<ffffffff810419e0>] put_prev_task_fair+0x110/0x120
[    3.553004]  [<ffffffff81575f3a>] schedule+0x1da/0xc50
[    3.553004]  [<ffffffff81576d72>] ? preempt_schedule_irq+0x62/0xa0
[    3.553004]  [<ffffffff81576d78>] preempt_schedule_irq+0x68/0xa0
[    3.553004]  [<ffffffff8157a316>] retint_kernel+0x26/0x30
[    3.553004]  [<ffffffff810da494>] ? ftrace_likely_update+0x14/0x20
[    3.553004]  [<ffffffff810bb4ab>] __rcu_read_unlock+0xfb/0x120
[    3.553004]  [<ffffffff810f8190>] find_get_page+0x170/0x190
[    3.553004]  [<ffffffff810f8020>] ? find_get_pages+0x280/0x280
[    3.553004]  [<ffffffff81180a30>] __find_get_block_slow+0x40/0x130
[    3.553004]  [<ffffffff81180d5f>] __find_get_block+0xdf/0x210
[    3.553004]  [<ffffffff8157d541>] ? sub_preempt_count+0x51/0x60
[    3.553004]  [<ffffffff81184c5e>] __getblk+0x11e/0x300
[    3.553004]  [<ffffffff81184e55>] __breadahead+0x15/0x60
[    3.553004]  [<ffffffff811e5e9e>] __ext4_get_inode_loc+0x36e/0x3f0
[    3.553004]  [<ffffffff811e7dfe>] ext4_iget+0x7e/0x870
[    3.553004]  [<ffffffff8129247e>] ? do_raw_spin_lock+0xde/0x1c0
[    3.553004]  [<ffffffff811f25e5>] ext4_lookup+0xb5/0x150
[    3.553004]  [<ffffffff8115a5c3>] d_alloc_and_lookup+0xc3/0x100
[    3.553004]  [<ffffffff8115cd00>] do_lookup+0x260/0x480
[    3.553004]  [<ffffffff8157d541>] ? sub_preempt_count+0x51/0x60
[    3.553004]  [<ffffffff8115dc58>] link_path_walk+0x248/0x930
[    3.553004]  [<ffffffff812925f6>] ? __raw_spin_lock_init+0x36/0x60
[    3.553004]  [<ffffffff81160417>] path_openat+0x107/0x4f0
[    3.553004]  [<ffffffff8108b392>] ? lock_release_non_nested+0xb2/0x330
[    3.553004]  [<ffffffff81160979>] do_filp_open+0x49/0x100
[    3.553004]  [<ffffffff8129247e>] ? do_raw_spin_lock+0xde/0x1c0
[    3.553004]  [<ffffffff81579a3c>] ? _raw_spin_unlock+0x5c/0x70
[    3.553004]  [<ffffffff8116db4a>] ? alloc_fd+0xfa/0x140
[    3.553004]  [<ffffffff8114d892>] do_sys_open+0x172/0x220
[    3.553004]  [<ffffffff8114d980>] sys_open+0x20/0x30
[    3.553004]  [<ffffffff815814eb>] system_call_fastpath+0x16/0x1b
[    3.553004] ---[ end trace 9137bd8a48443eaa ]---
INIT: version 2.88 booting
G
   OpenRC 0.8.3 is starting up Gentoo Linux (x86_64)

RCU settings are:grep RCU .config
# RCU Subsystem
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
 
and threadirqs are enabled by boot.

Hope this helps,
Ed
