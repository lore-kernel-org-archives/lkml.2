Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab2INEdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 00:33:23 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:47735 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab2INEdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 00:33:20 -0400
Message-ID: <5052B387.40807@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 12:33:11 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: paulmck@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at kernel/rcutree.c:1558 rcu_do_batch+0x386/0x3a0(),
 during CPU hotplug
References: <5007F8FA.7000203@linux.vnet.ibm.com> <20120719171550.GL2507@linux.vnet.ibm.com> <505081C4.2050600@linux.vnet.ibm.com> <20120912153114.GQ4257@linux.vnet.ibm.com> <50517D9C.1020201@linux.vnet.ibm.com> <5051D5FC.2070004@linux.vnet.ibm.com>
In-Reply-To: <5051D5FC.2070004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12091404-2000-0000-0000-0000091C12A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 08:47 PM, Srivatsa S. Bhat wrote:
> On 09/13/2012 12:00 PM, Michael Wang wrote:
>> On 09/12/2012 11:31 PM, Paul E. McKenney wrote:
>>> On Wed, Sep 12, 2012 at 06:06:20PM +0530, Srivatsa S. Bhat wrote:
>>>> On 07/19/2012 10:45 PM, Paul E. McKenney wrote:
>>>>> On Thu, Jul 19, 2012 at 05:39:30PM +0530, Srivatsa S. Bhat wrote:
>>>>>> Hi Paul,
>>>>>>
>>>>>> While running a CPU hotplug stress test on v3.5-rc7+
>>>>>> (mainline commit 8a7298b7805ab) I hit this warning.
>>>>>> I haven't tried to debug this yet...
>>>>>>
>>>>>> Line number 1550 maps to:
>>>>>>
>>>>>> WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
>>>>>>
>>>>>> inside rcu_do_batch().
>>>>>
>>>>> Hello, Srivatsa,
>>>>>
>>>>> I believe that you need commit a16b7a69 (Prevent __call_rcu() from
>>>>> invoking RCU core on offline CPUs), which is currently in -tip, queued
>>>>> for 3.6.  Please see below for the patch.
>>>>>
>>>>> Does this help?
>>>>>
>>>>
>>>> Hi Paul,
>>>>
>>>> I am hitting the cpu_is_offline() warning in rcu_do_batch() (see 2 of the
>>>> examples below) occasionally while testing CPU hotplug on Thomas' smp/hotplug
>>>> branch in -tip. It does contain the commit that you had mentioned above.
>>>>
>>>> The stack trace suggests that we are not hitting this from the __call_rcu()
>>>> path. So I guess this needs a different fix?
>>>
>>> So there was an interrupt from stop_machine_stop().  Because RCU complained
>>> about offline, I presume that this was on exit from stop_machine_stop().
>>> (Otherwise, on entry to stop_machine_stop(), the CPU has not yet marked
>>> itself offline, right?)
>>>
> 
> Yes, that's my understanding too.
> 
>>> So my question is:  Why didn't the CPU shut off all interrupts before
>>> coming out of stop_machine_stop()?
>>>
>>> Or am I confused about what is really happening here?
>>
>> I think Srivatsa may need patch a3716d2e too:
>>
> 
> The changelog of this patch doesn't seem to suggest that it was written to
> address the problem I am facing. Please see my thoughts below..
> 
>> commit a3716d2e5a50a9ed5268ae3d3c2f093968ff236a
>> Author: Paul E. McKenney <paul.mckenney@linaro.org>
>> Date:   Thu Jun 21 09:54:10 2012 -0700
>>
>>     rcu: Prevent offline CPUs from executing RCU core code
>>     
>>     Earlier versions of RCU invoked the RCU core from the CPU_DYING notifier
>>     in order to note a quiescent state for the outgoing CPU.  Because the
>>     CPU is marked "offline" during the execution of the CPU_DYING notifiers,
>>     the RCU core had to tolerate being invoked from an offline CPU.  However,
>>     commit b1420f1c (Make rcu_barrier() less disruptive) left only tracing
>>     code in the CPU_DYING notifier, so the RCU core need no longer execute
>>     on offline CPUs.  This commit therefore enforces this restriction.
>>     
>>     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>
>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>> index 300aba6..84a6f55 100644
>> --- a/kernel/rcutree.c
>> +++ b/kernel/rcutree.c
>> @@ -1892,6 +1892,8 @@ static void rcu_process_callbacks(struct softirq_action *unused)
>>  {
>>         struct rcu_state *rsp;
>>
>> +       if (cpu_is_offline(smp_processor_id()))
>> +               return;
>>         trace_rcu_utilization("Start RCU core");
>>         for_each_rcu_flavor(rsp)
>>                 __rcu_process_callbacks(rsp);
>>
>> With out it, the RCU_SOFTIRQ raised before offline won't
>> have a chance to return.
>>
> 
> I'm sure this would help to get rid of the warning, but IMHO, like Paul pointed out,
> its rather surprising that the CPU going offline got interrupts *after* coming out of
> the stop_machine thing, iow, *after* it was marked offline.. So we need to examine
> *this* issue right?

This may be a clue:

>>>> [   53.917769] do_IRQ: 8.211 No irq handler for vector (irq -1)

I'm not familiar with APIC, but that's not something we expected, correct?

Regards,
Michael Wang

> 
> Regards,
> Srivatsa S. Bhat
> 
>>>>
>>>> [   53.882344] smpboot: CPU 7 is now offline
>>>> [   53.891072] CPU 12 MCA banks CMCI:6 CMCI:8
>>>> [   53.895621] CPU 15 MCA banks CMCI:2 CMCI:3 CMCI:5
>>>> [   53.914738] Broke affinity for irq 81
>>>> [   53.917769] do_IRQ: 8.211 No irq handler for vector (irq -1) 
>>>> [   53.917769] ------------[ cut here ]------------
>>>> [   53.917769] WARNING: at kernel/rcutree.c:1558 rcu_do_batch+0x386/0x3a0()
>>>> [   53.917769] Hardware name: IBM System x -[7870C4Q]-
>>>> [   53.917769] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm cdc_ether usbnet ioatdma lpc_ich mfd_core crc32c_intel microcode mii pcspkr i2c_i801 shpchp i2c_core serio_raw bnx2 tpm_tis dca tpm pci_hotplug i7core_edac tpm_bios edac_core sg rtc_cmos button uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
>>>> [   53.917769] Pid: 47, comm: migration/8 Not tainted 3.6.0-rc1-tglx-hotplug-0.0.0.28.36b5ec9-default #1
>>>> [   53.917769] Call Trace:
>>>> [   53.917769]  <IRQ>  [<ffffffff810e7806>] ? rcu_do_batch+0x386/0x3a0
>>>> [   53.917769]  [<ffffffff810e7806>] ? rcu_do_batch+0x386/0x3a0
>>>> [   53.917769]  [<ffffffff8104338a>] warn_slowpath_common+0x7a/0xb0
>>>> [   53.917769]  [<ffffffff810433d5>] warn_slowpath_null+0x15/0x20
>>>> [   53.917769]  [<ffffffff810e7806>] rcu_do_batch+0x386/0x3a0
>>>> [   53.917769]  [<ffffffff810ac8a0>] ? trace_hardirqs_on_caller+0x70/0x1b0
>>>> [   53.917769]  [<ffffffff810ac9ed>] ? trace_hardirqs_on+0xd/0x10
>>>> [   53.917769]  [<ffffffff810e9143>] __rcu_process_callbacks+0x1a3/0x200
>>>> [   53.917769]  [<ffffffff810e9228>] rcu_process_callbacks+0x88/0x240
>>>> [   53.917769]  [<ffffffff8104dc79>] __do_softirq+0x159/0x400
>>>> [   53.917769]  [<ffffffff814c627c>] call_softirq+0x1c/0x30
>>>> [   53.917769]  [<ffffffff810044f5>] do_softirq+0x95/0xd0
>>>> [   53.917769]  [<ffffffff8104d745>] irq_exit+0xe5/0x100
>>>> [   53.917769]  [<ffffffff81003c14>] do_IRQ+0x64/0xe0
>>>> [   53.917769]  [<ffffffff814bc12f>] common_interrupt+0x6f/0x6f
>>>> [   53.917769]  <EOI>  [<ffffffff810cfe7a>] ? stop_machine_cpu_stop+0xda/0x130
>>>> [   53.917769]  [<ffffffff810cfda0>] ? stop_one_cpu_nowait+0x50/0x50
>>>> [   53.917769]  [<ffffffff810cfab9>] cpu_stopper_thread+0xd9/0x1b0
>>>> [   53.917769]  [<ffffffff814bbe4f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
>>>> [   53.917769]  [<ffffffff810cf9e0>] ? res_counter_init+0x50/0x50
>>>> [   53.917769]  [<ffffffff810ac95d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
>>>> [   53.917769]  [<ffffffff810ac9ed>] ? trace_hardirqs_on+0xd/0x10
>>>> [   53.917769]  [<ffffffff810cf9e0>] ? res_counter_init+0x50/0x50
>>>> [   53.917769]  [<ffffffff8106deae>] kthread+0xde/0xf0
>>>> [   53.917769]  [<ffffffff814c6184>] kernel_thread_helper+0x4/0x10
>>>> [   53.917769]  [<ffffffff814bc1f0>] ? retint_restore_args+0x13/0x13
>>>> [   53.917769]  [<ffffffff8106ddd0>] ? __init_kthread_worker+0x70/0x70
>>>> [   53.917769]  [<ffffffff814c6180>] ? gs_change+0x13/0x13
>>>> [   53.917769] ---[ end trace f60a282810c4ce78 ]---
>>>> [   54.170634] smpboot: CPU 8 is now offline
>>>> [   54.192259] NOHZ: local_softirq_pending 200 
>>>> [   54.197936] smpboot: CPU 9 is now offline
>>>> [   54.219707] NOHZ: local_softirq_pending 200 
>>>> [   54.225795] smpboot: CPU 10 is now offline
>>>>
>>>>
>>>> ---
>>>>
>>>> [  372.482434] smpboot: CPU 11 is now offline
>>>> [  372.534211] smpboot: CPU 12 is now offline
>>>> [  372.539786] CPU 13 MCA banks CMCI:6 CMCI:8
>>>> [  372.582474] smpboot: CPU 13 is now offline
>>>> [  372.591006] CPU 14 MCA banks CMCI:6 CMCI:8
>>>> [  372.629745] ------------[ cut here ]------------
>>>> [  372.633736] WARNING: at kernel/rcutree.c:1558 rcu_do_batch+0x386/0x3a0()
>>>> [  372.633736] Hardware name: IBM System x -[7870C4Q]-
>>>> [  372.633736] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel
>>>> microcode serio_raw tpm_tis i7core_edac cdc_ether usbnet ioatdma mii lpc_ich pcspkr edac_core mfd_core bnx2 shpchp pci_hotplug i2c_i801 i2c_core dca tpm sg tpm_bios rtc_cmos button uhci_hcd ehci_hcd
>>>> usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
>>>> [  372.633736] Pid: 8625, comm: migration/14 Not tainted 3.6.0-rc1-tglx-hotplug-0.0.0.28.36b5ec9-default #1
>>>> [  372.633736] Call Trace:
>>>> [  372.633736]  <IRQ>  [<ffffffff810e7806>] ? rcu_do_batch+0x386/0x3a0
>>>> [  372.633736]  [<ffffffff810e7806>] ? rcu_do_batch+0x386/0x3a0
>>>> [  372.633736]  [<ffffffff8104338a>] warn_slowpath_common+0x7a/0xb0
>>>> [  372.633736]  [<ffffffff810433d5>] warn_slowpath_null+0x15/0x20
>>>> [  372.633736]  [<ffffffff810e7806>] rcu_do_batch+0x386/0x3a0
>>>> [  372.633736]  [<ffffffff810ac8a0>] ? trace_hardirqs_on_caller+0x70/0x1b0
>>>> [  372.633736]  [<ffffffff810ac9ed>] ? trace_hardirqs_on+0xd/0x10
>>>> [  372.633736]  [<ffffffff810e9143>] __rcu_process_callbacks+0x1a3/0x200
>>>> [  372.633736]  [<ffffffff810e9228>] rcu_process_callbacks+0x88/0x240
>>>> [  372.633736]  [<ffffffff8104dc79>] __do_softirq+0x159/0x400
>>>> [  372.633736]  [<ffffffff814c627c>] call_softirq+0x1c/0x30
>>>> [  372.633736]  [<ffffffff810044f5>] do_softirq+0x95/0xd0
>>>> [  372.633736]  [<ffffffff8104d745>] irq_exit+0xe5/0x100
>>>> [  372.633736]  [<ffffffff81028df9>] smp_apic_timer_interrupt+0x69/0xa0
>>>> [  372.633736]  [<ffffffff814c5aef>] apic_timer_interrupt+0x6f/0x80
>>>> [  372.633736]  <EOI>  [<ffffffff810cfe7a>] ? stop_machine_cpu_stop+0xda/0x130
>>>> [  372.633736]  [<ffffffff810cfda0>] ? stop_one_cpu_nowait+0x50/0x50
>>>> [  372.633736]  [<ffffffff810cfab9>] cpu_stopper_thread+0xd9/0x1b0
>>>> [  372.633736]  [<ffffffff814bbe4f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
>>>> [  372.633736]  [<ffffffff810cf9e0>] ? res_counter_init+0x50/0x50
>>>> [  372.633736]  [<ffffffff810ac95d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
>>>> [  372.633736]  [<ffffffff810ac9ed>] ? trace_hardirqs_on+0xd/0x10
>>>> [  372.633736]  [<ffffffff810cf9e0>] ? res_counter_init+0x50/0x50
>>>> [  372.633736]  [<ffffffff8106deae>] kthread+0xde/0xf0
>>>> [  372.633736]  [<ffffffff814c6184>] kernel_thread_helper+0x4/0x10
>>>> [  372.633736]  [<ffffffff814bc1f0>] ? retint_restore_args+0x13/0x13
>>>> [  372.633736]  [<ffffffff8106ddd0>] ? __init_kthread_worker+0x70/0x70
>>>> [  372.633736]  [<ffffffff814c6180>] ? gs_change+0x13/0x13
>>>> [  372.633736] ---[ end trace a4296a31284c846d ]---
>>>> [  372.883063] smpboot: CPU 14 is now offline
>>>> [  372.892721] CPU 15 MCA banks CMCI:6 CMCI:8
>>>> [  372.907250] smpboot: CPU 15 is now offline
>>>> [  372.911545] SMP alternatives: lockdep: fixing up alternatives
>>>> [  372.917292] SMP alternatives: switching to UP code
>>>> [  372.941917] SMP alternatives: lockdep: fixing up alternatives

