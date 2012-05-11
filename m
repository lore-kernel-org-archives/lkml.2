Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab2EKLpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:45:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:36728 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2EKLp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:45:28 -0400
Date: Fri, 11 May 2012 13:45:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Igor Mammedov <imammedo@redhat.com>
cc: linux-kernel@vger.kernel.org, rob@landley.net, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, a.p.zijlstra@chello.nl, johnstul@us.ibm.com,
        arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/5] Fix soft-lookup in stop machine on secondary cpu
 bring up
In-Reply-To: <1336559102-28103-2-git-send-email-imammedo@redhat.com>
Message-ID: <alpine.LFD.2.02.1205111234460.3231@ionos>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com> <1336559102-28103-2-git-send-email-imammedo@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Igor Mammedov wrote:

> When bringing up cpuX1, it could stall in start_secondary
> before setting cpu_callin_mask for more than 5 sec. That forces
> do_boot_cpu() to give up on waiting and go to error return path
> printing messages:
>   pr_err("CPU%d: Stuck ??\n", cpuX1);
> or
>   pr_err("CPU%d: Not responding.\n", cpuX1);
> and native_cpu_up returns early with -EIO. However AP may continue
> its boot process till it reaches check_tsc_sync_target(), where
> it will wait for boot cpu to run cpu_up...=>check_tsc_sync_source.
> That will never happen since cpu_up have returned with error before.
> 
> Now we need to note that cpuX1 is marked as active in smp_callin
> before it stuck in check_tsc_sync_target. And when another cpuX2
> is being onlined, start_secondary on it will call
>   smp_callin
>     -> smp_store_cpu_info
>       -> identify_secondary_cpu
>         -> mtrr_ap_init
>           -> set_mtrr_from_inactive_cpu
>             -> stop_machine_from_inactive_cpu
> where it's going to schedule stop_machine work on all ACTIVE cpus
>   smdata.num_threads = num_active_cpus() + 1;
> and wait till they all complete it before continuing. As was noted
> before cpuX1 was marked as active but can't execute any work since
> it's not completed initialization and stuck in check_tsc_sync_target.
> As result system soft lockups in stop_machine_cpu_stop.
> 
> backtrace from reproducer:
> 
> PID: 3324   TASK: ffff88007c00ae20  CPU: other cpus   COMMAND: "migration/1"
>     [exception RIP: stop_machine_cpu_stop+131]
> ...
>  #0 [ffff88007b4d7de8] cpu_stopper_thread at ffffffff810c66bd
>  #1 [ffff88007b4d7ee8] kthread at ffffffff8107871e
>  #2 [ffff88007b4d7f48] kernel_thread_helper at ffffffff8154af24
> 
> PID: 0      TASK: ffff88007c029710  CPU: 2   COMMAND: "swapper/2"
>     [exception RIP: check_tsc_sync_target+33]
> ...
>  #0 [ffff88007c025f30] start_secondary at ffffffff81539876
> 
> PID: 0      TASK: ffff88007c041710  CPU: 3   COMMAND: "swapper/3"
>     [exception RIP: stop_machine_cpu_stop+131]
> ...
>  #0 [ffff88007c04be50] stop_machine_from_inactive_cpu at ffffffff810c6b2f
>  #1 [ffff88007c04bee0] mtrr_ap_init at ffffffff8102e963
>  #2 [ffff88007c04bf10] identify_secondary_cpu at ffffffff81536799
>  #3 [ffff88007c04bf20] smp_store_cpu_info at ffffffff815396d5
>  #4 [ffff88007c04bf30] start_secondary at ffffffff81539800
> 
> Could be fixed by not marking being onlined cpu as active too early.

This explanation is completely useless. What's fixed by what. And is
it fixed or could it be fixed?

This also want's an explanation why moving the cpu_starting notifier
does not hurt any assumptions of the code which has notifiers
registered for CPU_STARTING. In fact your change can result in
CPU_ONLINE notifier being called _BEFORE_ CPU_STARTING. Do you really
think that's correct?

Aside of that your whole patch series tackles the wrong aspect.
 
Why the heck do you need extra magic in check_tsc_sync_target() ?

If the booting CPU fails to set the callin map within 5 seconds then
it should not even reach check_tsc_sync_target() at all.

And just for the record, the new CPU can run into the very same
timeout problem, when the boot CPU fails to set the callout mask.

This whole stuff is a complete trainwreck already and I don't want to
see anything like your "fixing the symptoms" hackery near it, really.

This whole stuff needs a proper rewrite and not some more braindamaged
bandaids. And if we apply bandaids for the time being, then certainly
not bandaids like the mess you created.

Thanks,

	tglx
