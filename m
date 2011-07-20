Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1GTBMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 21:12:00 -0400
Received: from mail.candelatech.com ([208.74.158.172]:57499 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1GTBL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 21:11:59 -0400
Message-ID: <4E262B15.5000907@candelatech.com>
Date: Tue, 19 Jul 2011 18:10:45 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, edt@aei.ca
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads trainwreck
References: <20110720001738.GA16369@linux.vnet.ibm.com>
In-Reply-To: <20110720001738.GA16369@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2011 05:17 PM, Paul E. McKenney wrote:
> Hello!
>
> This patch set contains fixes for a trainwreck involving RCU, the
> scheduler, and threaded interrupts.  This trainwreck involved RCU failing
> to properly protect one of its bit fields, use of RCU by the scheduler
> from portions of irq_exit() where in_irq() returns false, uses of the
> scheduler by RCU colliding with uses of RCU by the scheduler, threaded
> interrupts exercising the problematic portions of irq_exit() more heavily,
> and so on.  The patches are as follows:
>
> 1.	Properly protect current->rcu_read_unlock_special().
> 	Lack of protection was causing RCU to recurse on itself, which
> 	in turn resulted in deadlocks involving RCU and the scheduler.
> 	This affects only RCU_BOOST=y configurations.
> 2.	Streamline code produced by __rcu_read_unlock().  This one is
> 	an innocent bystander that is being carried due to conflicts
> 	with other patches.  (A later version will likely merge it
> 	with #3 below.)
> 3.	Make __rcu_read_unlock() delay counting the per-task
> 	->rcu_read_lock_nesting variable to zero until all cleanup for the
> 	just-ended RCU read-side critical section has completed.  This
> 	prevents a number of other cases that could result in deadlock
> 	due to self recursion.	This affects only TREE_PREEMPT_RCU=y
> 	configurations.
> 4.	Make scheduler_ipi() correctly identify itself as being
> 	in_irq() when it needs to do anything that might involve RCU,
> 	thus enabling RCU to avoid yet another class of potential
> 	self-recursions and deadlocks.	This affects PREEMPT_RCU=y
> 	configurations.
> 5.	Make irq_exit() inform RCU when it is invoking the scheduler
> 	in situations where in_irq() would return false, thus
> 	allowing RCU to correctly avoid self-recursion.  This affects
> 	TREE_PREEMPT_RCU=y configurations.
> 6.	Make __lock_task_sighand() execute the entire RCU read-side
> 	critical section with irqs disabled.  (An experimental patch at
> 	http://marc.info/?l=linux-kernel&m=131110647222185 might possibly
> 	make it legal to have an RCU read-side critical section where
> 	the rcu_read_unlock() is executed with interrupts disabled,
> 	but where some protion of the RCU read-side critical section
> 	was preemptible.)  This affects TREE_PREEMPT_RCU=y configurations.
>
> TINY_PREEMPT_RCU will also need a few of these changes, but in the
> meantime this patch stack helps organize things better for testing.
> These are also available from the following subject-to-rebase git branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

I pulled these in, and see this bug on startup (my user-space app appears to be unloading
the bridge module here).  Don't recall seeing it before,
not sure if it's related to your changes or other changes since I last pulled
-rc7 a few days back:

BUG: scheduling while atomic: rmmod/1870/0x00000005
Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ipt_MASQUERADE iptable_nat nf_nat bridge(-) stp llc nfs lockd fscache auth_rpcgss 
nfs_acl sunrpc ipv6 kvm_intel kvm uinput i5k_amb i5000_edac edac_core e1000e ioatdma iTCO_wdt shpchp iTCO_vendor_support i2c_i801 dca pcspkr microcode floppy 
radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
Pid: 1870, comm: rmmod Not tainted 3.0.0-rc7+ #23
Call Trace:
  [<ffffffff8103e89f>] __schedule_bug+0x5c/0x60
  [<ffffffff81428bfc>] schedule+0xa0/0x617
  [<ffffffff8105c96d>] ? prepare_to_wait+0x71/0x7c
  [<ffffffff8109607f>] synchronize_rcu_expedited+0x1b1/0x1c2
  [<ffffffff8105c72b>] ? wake_up_bit+0x25/0x25
  [<ffffffff81049f82>] ? local_bh_enable_ip+0x9/0xb
  [<ffffffff81376f33>] synchronize_net+0x25/0x2e
  [<ffffffff81379dee>] rollback_registered_many+0x122/0x216
  [<ffffffff81379ef8>] unregister_netdevice_many+0x16/0x62
  [<ffffffffa0320e1c>] br_net_exit+0x6d/0x7d [bridge]
  [<ffffffff81373f9d>] ops_exit_list+0x25/0x4e
  [<ffffffff813740ff>] unregister_pernet_operations+0x83/0xb1
  [<ffffffff81374191>] unregister_pernet_subsys+0x20/0x31
  [<ffffffffa03293e0>] br_deinit+0x34/0x50 [bridge]
  [<ffffffff81071f4a>] sys_delete_module+0x1a6/0x20a
  [<ffffffff810f77d9>] ? path_put+0x1d/0x22
  [<ffffffff8108c57c>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff8142f892>] system_call_fastpath+0x16/0x1b
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0




-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
