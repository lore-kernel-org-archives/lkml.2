Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab1D0XDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:03:45 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48402 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab1D0XDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:03:44 -0400
Date: Wed, 27 Apr 2011 16:03:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jim Schutt <jaschut@sandia.gov>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mcelog stalls on 2.6.39-rc5
Message-ID: <20110427230333.GD2135@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DB87585.3010607@sandia.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB87585.3010607@sandia.gov>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:59:01PM -0600, Jim Schutt wrote:
> Hi,
> 
> Testing 2.6.39-rc5 is giving me the following stall:
> 
>     [ 5767.731001] INFO: rcu_sched_state detected stall on CPU 1 (t=60001 jiffies)
>     [ 5767.732001] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 1} (detected by 0, t=60002 jiffies)
>     [ 5947.763001] INFO: rcu_sched_state detected stall on CPU 1 (t=240032 jiffies)
>     [ 5947.764001] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 1} (detected by 0, t=240034 jiffies)
>     [ 6024.489362] libceph: mon0 172.17.40.34:6789 socket closed
>     [ 6121.281139] INFO: task mcelog:6513 blocked for more than 120 seconds.
>     [ 6121.287575] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     [ 6121.295397]  ffff880177aefce8 0000000000000082 ffffffff810339b6 ffff880226d35a40
>     [ 6121.302840]  ffff88018226c3b0 ffff88018226c3b0 0000000000011e80 ffff880226d35a40
>     [ 6121.310284]  ffff88018226c760 ffff880177aefe80 ffff880177aefd18 ffffffff813af047
>     [ 6121.317725] Call Trace:
>     [ 6121.320176]  [<ffffffff810339b6>] ? calc_load_account_idle+0xe/0x1d
>     [ 6121.326437]  [<ffffffff813af047>] schedule+0x159/0x193
>     [ 6121.331569]  [<ffffffff813af449>] schedule_timeout+0x36/0xe2
>     [ 6121.337223]  [<ffffffff810ad9eb>] ? trace_hardirqs_on+0x9/0x20
>     [ 6121.343047]  [<ffffffff813aee2b>] do_wait_for_common+0x97/0xe3
>     [ 6121.348967]  [<ffffffff8103e8fa>] ? try_to_wake_up+0x200/0x200
>     [ 6121.354794]  [<ffffffff8107a4bf>] ? __raw_spin_lock_irq+0x17/0x2f
>     [ 6121.360878]  [<ffffffff813af2a9>] wait_for_common+0x36/0x4d
>     [ 6121.366441]  [<ffffffff813af378>] wait_for_completion+0x1d/0x1f
>     [ 6121.372356]  [<ffffffff8109ae6d>] synchronize_sched+0x40/0x49
>     [ 6121.378096]  [<ffffffff810635b8>] ? find_get_pid+0x1b/0x1b
>     [ 6121.383574]  [<ffffffff81015fe5>] mce_read+0x17f/0x25d
>     [ 6121.388707]  [<ffffffff81111af5>] ? rw_verify_area+0xac/0xdb
>     [ 6121.394358]  [<ffffffff811121f1>] vfs_read+0xa9/0xe1
>     [ 6121.399317]  [<ffffffff8111248d>] sys_read+0x4c/0x70
>     [ 6121.404278]  [<ffffffff813b6deb>] system_call_fastpath+0x16/0x1b
>     [ 6127.795001] INFO: rcu_sched_state detected stall on CPU 1 (t=420064 jiffies)
>     [ 6127.796001] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 1} (detected by 0, t=420066 jiffies)
>     [ 6241.410171] INFO: task mcelog:6513 blocked for more than 120 seconds.
> 
> Reverting commit a4dd99250dc makes the stalls go away:
> 
>     rcu: create new rcu_access_index() and use in mce
> 
>     The MCE subsystem needs to sample an RCU-protected index outside of
>     any protection for that index.  If this was a pointer, we would use
>     rcu_access_pointer(), but there is no corresponding rcu_access_index().
>     This commit therefore creates an rcu_access_index() and applies it
>     to MCE.
> 
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>     Tested-by: Zdenek Kabelac <zkabelac@redhat.com>

Wow!  This is just instructions, just wrapping the access in
ACCESS_ONCE().

Was the original RCU CPU stall repeatable?

							Thanx, Paul

> Here's some bits from my config that might be relevant:
> 
> # RCU Subsystem
> CONFIG_TREE_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_RCU_TRACE is not set
> CONFIG_RCU_FANOUT=64
> # CONFIG_RCU_FANOUT_EXACT is not set
> # CONFIG_RCU_FAST_NO_HZ is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_PREEMPT_NOTIFIERS=y
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> CONFIG_X86_MCE_AMD=y
> CONFIG_X86_MCE_THRESHOLD=y
> # CONFIG_X86_MCE_INJECT is not set
> CONFIG_EDAC_DECODE_MCE=y
> # CONFIG_EDAC_MCE_INJ is not set
> CONFIG_EDAC_MCE=y
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_DETECTOR=y
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
> 
> Please let me know if there is anything I can do to help sort this out.
> 
> -- Jim
> 
