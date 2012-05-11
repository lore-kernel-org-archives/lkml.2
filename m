Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab2EKPRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:17:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab2EKPRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:17:30 -0400
Message-ID: <4FAD2D63.5010208@redhat.com>
Date: Fri, 11 May 2012 17:16:51 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, rob@landley.net, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, a.p.zijlstra@chello.nl, johnstul@us.ibm.com,
        arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/5] Fix soft-lookup in stop machine on secondary cpu
 bring up
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com> <1336559102-28103-2-git-send-email-imammedo@redhat.com> <alpine.LFD.2.02.1205111234460.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205111234460.3231@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 01:45 PM, Thomas Gleixner wrote:
> On Wed, 9 May 2012, Igor Mammedov wrote:
>
>> When bringing up cpuX1, it could stall in start_secondary
>> before setting cpu_callin_mask for more than 5 sec. That forces
>> do_boot_cpu() to give up on waiting and go to error return path
>> printing messages:
>>    pr_err("CPU%d: Stuck ??\n", cpuX1);
>> or
>>    pr_err("CPU%d: Not responding.\n", cpuX1);
>> and native_cpu_up returns early with -EIO. However AP may continue
>> its boot process till it reaches check_tsc_sync_target(), where
>> it will wait for boot cpu to run cpu_up...=>check_tsc_sync_source.
>> That will never happen since cpu_up have returned with error before.
>>
>> Now we need to note that cpuX1 is marked as active in smp_callin
>> before it stuck in check_tsc_sync_target. And when another cpuX2
>> is being onlined, start_secondary on it will call
>>    smp_callin
>>      ->  smp_store_cpu_info
>>        ->  identify_secondary_cpu
>>          ->  mtrr_ap_init
>>            ->  set_mtrr_from_inactive_cpu
>>              ->  stop_machine_from_inactive_cpu
>> where it's going to schedule stop_machine work on all ACTIVE cpus
>>    smdata.num_threads = num_active_cpus() + 1;
>> and wait till they all complete it before continuing. As was noted
>> before cpuX1 was marked as active but can't execute any work since
>> it's not completed initialization and stuck in check_tsc_sync_target.
>> As result system soft lockups in stop_machine_cpu_stop.
>>
>> backtrace from reproducer:
>>
>> PID: 3324   TASK: ffff88007c00ae20  CPU: other cpus   COMMAND: "migration/1"
>>      [exception RIP: stop_machine_cpu_stop+131]
>> ...
>>   #0 [ffff88007b4d7de8] cpu_stopper_thread at ffffffff810c66bd
>>   #1 [ffff88007b4d7ee8] kthread at ffffffff8107871e
>>   #2 [ffff88007b4d7f48] kernel_thread_helper at ffffffff8154af24
>>
>> PID: 0      TASK: ffff88007c029710  CPU: 2   COMMAND: "swapper/2"
>>      [exception RIP: check_tsc_sync_target+33]
>> ...
>>   #0 [ffff88007c025f30] start_secondary at ffffffff81539876
>>
>> PID: 0      TASK: ffff88007c041710  CPU: 3   COMMAND: "swapper/3"
>>      [exception RIP: stop_machine_cpu_stop+131]
>> ...
>>   #0 [ffff88007c04be50] stop_machine_from_inactive_cpu at ffffffff810c6b2f
>>   #1 [ffff88007c04bee0] mtrr_ap_init at ffffffff8102e963
>>   #2 [ffff88007c04bf10] identify_secondary_cpu at ffffffff81536799
>>   #3 [ffff88007c04bf20] smp_store_cpu_info at ffffffff815396d5
>>   #4 [ffff88007c04bf30] start_secondary at ffffffff81539800
>>
>> Could be fixed by not marking being onlined cpu as active too early.
>
> This explanation is completely useless. What's fixed by what. And is
> it fixed or could it be fixed?
What's fixed:
  above mentioned hang in stop_machine_from_inactive_cpu() because even if
  a cpu failed to set cpu_callin_mask in time and boot cpu marked it as
  not present + removed from some maps, with this move, a failed cpu won't
  set cpu_active_mask before it completes check_tsc_sync_target().
  And with patches [2,3,4]/5 it will not set cpu_active_mask at all
  so making itself unavailable to the rest of kernel.

> This also want's an explanation why moving the cpu_starting notifier
> does not hurt any assumptions of the code which has notifiers
> registered for CPU_STARTING.
I've checked in kernel users [sched, kvm, pmu] before moving it here.
It looked safe. However I might have missed something.

>In fact your change can result in
> CPU_ONLINE notifier being called _BEFORE_ CPU_STARTING. Do you really
> think that's correct?
That's certainly is not correct, it asks for a barrier after
cpu_starting and before setting cpu_online_mask.

> Aside of that your whole patch series tackles the wrong aspect.
patch series tries to prevent a failed to boot cpu wreck havoc on
running kernel. How wrong is that?
What should be fixed instead?

> Why the heck do you need extra magic in check_tsc_sync_target() ?
Because it's plainly racy. patch 2/5 describes/fixes race condition in
check_tsc_sync_target().

> If the booting CPU fails to set the callin map within 5 seconds then
> it should not even reach check_tsc_sync_target() at all.
Why it shouldn't reach check_tsc_sync_target () at all. There is nothing
that prevents it and guaranties such behavior.
For example: it happens when kernel is running inside guest on overloaded host.
And it seems on baremetal as well: https://lkml.org/lkml/2012/5/9/336

> And just for the record, the new CPU can run into the very same
> timeout problem, when the boot CPU fails to set the callout mask.
Yes, it can.
I've tried to fix only what was reproducible on my test system, so I
haven't touched this.
That might result in panic in smp_callin():
    panic("%s: CPU%d started up but did not get a callout!\n"

> This whole stuff is a complete trainwreck already and I don't want to
> see anything like your "fixing the symptoms" hackery near it, really.
Fixing slow to respond cpu might be not option, so we need to gracefully
abort failed cpu_online operation instead of hanging in stop_machine or
crashing in scheduler[https://lkml.org/lkml/2012/5/9/137].

>
> This whole stuff needs a proper rewrite and not some more braindamaged
> bandaids. And if we apply bandaids for the time being, then certainly
> not bandaids like the mess you created.
Rewrite will need to deal with failed to boot in time cpu as well.
So if rewrite is not near completion, then maybe for a time being bandaids
would be needed.
Any ideas/suggestions for "right bandaids" instead of braindamaged ones?

> Thanks,
>
> 	tglx


-- 
-----
  Thanks,
    Igor
