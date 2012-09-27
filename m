Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2I0TG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 15:06:59 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:50390 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2I0TG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 15:06:57 -0400
Message-ID: <5064A3A5.5070607@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2012 00:36:13 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: paulmck@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@amd64.org>,
        Fengguang Wu <fengguang.wu@intel.com>, hpa@zytor.com, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: WARNING: at kernel/rcutree.c:1558 rcu_do_batch+0x386/0x3a0(),
 during CPU hotplug
References: <5007F8FA.7000203@linux.vnet.ibm.com> <20120719171550.GL2507@linux.vnet.ibm.com> <505081C4.2050600@linux.vnet.ibm.com> <20120912153114.GQ4257@linux.vnet.ibm.com> <50517D9C.1020201@linux.vnet.ibm.com> <5051D5FC.2070004@linux.vnet.ibm.com> <5062CC65.6080908@linux.vnet.ibm.com> <5063C104.20406@linux.vnet.ibm.com>
In-Reply-To: <5063C104.20406@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12092719-3864-0000-0000-000004D24F99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 08:29 AM, Michael Wang wrote:
> On 09/26/2012 05:35 PM, Srivatsa S. Bhat wrote:
>> On 09/13/2012 06:17 PM, Srivatsa S. Bhat wrote:
>>> On 09/13/2012 12:00 PM, Michael Wang wrote:
>>>> On 09/12/2012 11:31 PM, Paul E. McKenney wrote:
>>>>> On Wed, Sep 12, 2012 at 06:06:20PM +0530, Srivatsa S. Bhat wrote:
>>>>>> On 07/19/2012 10:45 PM, Paul E. McKenney wrote:
>>>>>>> On Thu, Jul 19, 2012 at 05:39:30PM +0530, Srivatsa S. Bhat wrote:
>>>>>>>> Hi Paul,
>>>>>>>>
>>>>>>>> While running a CPU hotplug stress test on v3.5-rc7+
>>>>>>>> (mainline commit 8a7298b7805ab) I hit this warning.
>>>>>>>> I haven't tried to debug this yet...
>>>>>>>>
>>>>>>>> Line number 1550 maps to:
>>>>>>>>
>>>>>>>> WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
>>>>>>>>
>>>>>>>> inside rcu_do_batch().
>>>>>>>
>>>>>>> Hello, Srivatsa,
>>>>>>>
>>>>>>> I believe that you need commit a16b7a69 (Prevent __call_rcu() from
>>>>>>> invoking RCU core on offline CPUs), which is currently in -tip, queued
>>>>>>> for 3.6.  Please see below for the patch.
>>>>>>>
>>>>>>> Does this help?
>>>>>>>
>>>>>>
>>>>>> Hi Paul,
>>>>>>
>>>>>> I am hitting the cpu_is_offline() warning in rcu_do_batch() (see 2 of the
>>>>>> examples below) occasionally while testing CPU hotplug on Thomas' smp/hotplug
>>>>>> branch in -tip. It does contain the commit that you had mentioned above.
>>>>>>
>>>>>> The stack trace suggests that we are not hitting this from the __call_rcu()
>>>>>> path. So I guess this needs a different fix?
>>>>>
>>>>> So there was an interrupt from stop_machine_stop().  Because RCU complained
>>>>> about offline, I presume that this was on exit from stop_machine_stop().
>>>>> (Otherwise, on entry to stop_machine_stop(), the CPU has not yet marked
>>>>> itself offline, right?)
>>>>>
>>>
>>> Yes, that's my understanding too.
>>>
>>>>> So my question is:  Why didn't the CPU shut off all interrupts before
>>>>> coming out of stop_machine_stop()?
>>>>>
>>>>> Or am I confused about what is really happening here?
>>>>
>>
>> The interesting thing is that in every single instance of an interrupt hitting
>> an offline CPU, the IP points to the statement : local_irq_restore(flags)
>> in stop_machine_cpu_stop(). And the most common case of such an interrupt is the
>> APIC timer interrupt (though I have also seen a few instances of do_IRQ() (device
>> interrupts) in some of my stacktraces).
>>
>> So, I'm inclined to conclude that the functions responsible for clearing interrupts
>> during CPU offline, such as clear_local_APIC() and friends are not doing their
>> job properly..
> 
> Agree, "we try to shut down apic but failed", that's may be the reason.
> 
> I think we need some help from the experts on apic code now(or don't do
> any job in do_IRQ if cpu is offline, but a bad solution)...
> 

Adding Suresh and Venki to CC.

Regards,
Srivatsa S. Bhat

> 
>>
>> Below are results from some of my CPU hotplug tests, in which I had added debug
>> print statements and WARN_ON()s to catch situations where interrupts hit offline
>> CPUs.
>> (Address <ffffffff810cf8aa> corresponds to line no. 481 in kernel/stop_machine.c,
>> ie., local_irq_restore(flags) in stop_machine_cpu_stop()).
>>
>> Regards,
>> Srivatsa S. Bhat
>>
>> ---------------
>>
>> [ 4730.906259] smpboot: Booting Node 1 Processor 6 APIC 0x14
>> [ 4731.018008] SMP alternatives: lockdep: fixing up alternatives
>> [ 4731.023811] smpboot: Booting Node 1 Processor 7 APIC 0x16
>> [ 4731.132009] SMP Apic timer interrupt to offline CPU! 8
>> [ 4731.132009] ------------[ cut here ]------------
>> [ 4731.132009] WARNING: at arch/x86/kernel/apic/apic.c:904 smp_apic_timer_interrupt+0xc9/0xd0()
>> [ 4731.132009] Hardware name: IBM System x -[7870C4Q]-
>> [ 4731.132009] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm cdc_ether crc32c_intel i7core_edac shpchp usbnet pcspkr edac_core microcode tpm_tis mii bnx2 serio_raw lpc_ich mfd_core i2c_i801 pci_hotplug i2c_core tpm ioatdma dca tpm_bios sg button rtc_cmos uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
>> [ 4731.132009] Pid: 12843, comm: migration/8 Not tainted 3.6.0-rc7-warn-cpu-interrupt-0.0.0.28.36b5ec9-default #3
>> [ 4731.132009] Call Trace:
>> [ 4731.132009]  <IRQ>  [<ffffffff81028f99>] ? smp_apic_timer_interrupt+0xc9/0xd0
>> [ 4731.132009]  [<ffffffff81028f99>] ? smp_apic_timer_interrupt+0xc9/0xd0
>> [ 4731.132009]  [<ffffffff810433ea>] warn_slowpath_common+0x7a/0xb0
>> [ 4731.132009]  [<ffffffff81043435>] warn_slowpath_null+0x15/0x20
>> [ 4731.132009]  [<ffffffff81028f99>] smp_apic_timer_interrupt+0xc9/0xd0
>> [ 4731.132009]  [<ffffffff814c662f>] apic_timer_interrupt+0x6f/0x80
>> [ 4731.132009]  <EOI>  [<ffffffff810cf8aa>] ? stop_machine_cpu_stop+0xda/0x130
>> [ 4731.132009]  [<ffffffff810cf7d0>] ? stop_one_cpu_nowait+0x50/0x50
>> [ 4731.132009]  [<ffffffff810cf4e9>] cpu_stopper_thread+0xd9/0x1b0
>> [ 4731.132009]  [<ffffffff814bc98f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
>> [ 4731.132009]  [<ffffffff810cf410>] ? res_counter_init+0x50/0x50
>> [ 4731.132009]  [<ffffffff810ac36d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
>> [ 4731.132009]  [<ffffffff810ac3fd>] ? trace_hardirqs_on+0xd/0x10
>> [ 4731.132009]  [<ffffffff810cf410>] ? res_counter_init+0x50/0x50
>> [ 4731.132009]  [<ffffffff8106df0e>] kthread+0x9e/0xb0
>> [ 4731.132009]  [<ffffffff814c6cc4>] kernel_thread_helper+0x4/0x10
>> [ 4731.132009]  [<ffffffff814bcd30>] ? retint_restore_args+0x13/0x13
>> [ 4731.132009]  [<ffffffff8106de70>] ? __init_kthread_worker+0x70/0x70
>> [ 4731.132009]  [<ffffffff814c6cc0>] ? gs_change+0x13/0x13
>> [ 4731.132009] ---[ end trace 4591bad96b0e5f4b ]---
>> [ 4731.440036] smpboot: CPU 8 is now offline
>> [ 4731.485506] smpboot: CPU 9 is now offline
>> [ 4731.533459] smpboot: CPU 10 is now offline
>> [ 4731.591316] smpboot: CPU 11 is now offline
>> [ 4731.616017] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5
>> [ 4731.729817] smpboot: CPU 12 is now offline
>> [ 4731.748034] CPU 4 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
>> [ 4731.800110] smpboot: CPU 13 is now offline
>>
>>
>> [ 4909.232645] SMP alternatives: lockdep: fixing up alternatives
>> [ 4909.238633] smpboot: Booting Node 1 Processor 7 APIC 0x16
>> [ 4909.350250] smpboot: CPU 8 is now offline
>> [ 4909.395118] Broke affinity for irq 3
>> [ 4909.400743] smpboot: CPU 9 is now offline
>> [ 4909.444681] smpboot: CPU 10 is now offline
>> [ 4909.496011] SMP Apic timer interrupt to offline CPU! 11
>> [ 4909.496011] ------------[ cut here ]------------
>> [ 4909.496011] WARNING: at arch/x86/kernel/apic/apic.c:904 smp_apic_timer_interrupt+0xc9/0xd0()
>> [ 4909.496011] Hardware name: IBM System x -[7870C4Q]-
>> [ 4909.496011] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm cdc_ether crc32c_intel i7core_edac shpchp usbnet pcspkr edac_core microcode tpm_tis mii bnx2 serio_raw lpc_ich mfd_core i2c_i801 pci_hotplug i2c_core tpm ioatdma dca tpm_bios sg button rtc_cmos uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
>> [ 4909.496011] Pid: 10241, comm: migration/11 Tainted: G        W    3.6.0-rc7-warn-cpu-interrupt-0.0.0.28.36b5ec9-default #3
>> [ 4909.496011] Call Trace:
>> [ 4909.496011]  <IRQ>  [<ffffffff81028f99>] ? smp_apic_timer_interrupt+0xc9/0xd0
>> [ 4909.496011]  [<ffffffff81028f99>] ? smp_apic_timer_interrupt+0xc9/0xd0
>> [ 4909.496011]  [<ffffffff810433ea>] warn_slowpath_common+0x7a/0xb0
>> [ 4909.496011]  [<ffffffff81043435>] warn_slowpath_null+0x15/0x20
>> [ 4909.496011]  [<ffffffff81028f99>] smp_apic_timer_interrupt+0xc9/0xd0
>> [ 4909.496011]  [<ffffffff814c662f>] apic_timer_interrupt+0x6f/0x80
>> [ 4909.496011]  <EOI>  [<ffffffff810cf8aa>] ? stop_machine_cpu_stop+0xda/0x130
>> [ 4909.496011]  [<ffffffff810cf7d0>] ? stop_one_cpu_nowait+0x50/0x50
>> [ 4909.496011]  [<ffffffff810cf4e9>] cpu_stopper_thread+0xd9/0x1b0
>> [ 4909.496011]  [<ffffffff814bc98f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
>> [ 4909.496011]  [<ffffffff810cf410>] ? res_counter_init+0x50/0x50
>> [ 4909.496011]  [<ffffffff810ac36d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
>> [ 4909.496011]  [<ffffffff810ac3fd>] ? trace_hardirqs_on+0xd/0x10
>> [ 4909.496011]  [<ffffffff810cf410>] ? res_counter_init+0x50/0x50
>> [ 4909.496011]  [<ffffffff8106df0e>] kthread+0x9e/0xb0
>> [ 4909.496011]  [<ffffffff814c6cc4>] kernel_thread_helper+0x4/0x10
>> [ 4909.496011]  [<ffffffff814bcd30>] ? retint_restore_args+0x13/0x13
>> [ 4909.496011]  [<ffffffff8106de70>] ? __init_kthread_worker+0x70/0x70
>> [ 4909.496011]  [<ffffffff814c6cc0>] ? gs_change+0x13/0x13
>> [ 4909.496011] ---[ end trace 4591bad96b0e5f4c ]---
>> [ 4909.703691] ------------[ cut here ]------------
>> [ 4909.708124] WARNING: at kernel/rcutree.c:1560 rcu_do_batch+0x386/0x3a0()
>> [ 4909.708124] Hardware name: IBM System x -[7870C4Q]-
>> [ 4909.708124] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm cdc_ether crc32c_intel i7core_edac shpchp usbnet pcspkr edac_core microcode tpm_tis mii bnx2 serio_raw lpc_ich mfd_core i2c_i801 pci_hotplug i2c_core tpm ioatdma dca tpm_bios sg button rtc_cmos uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
>> [ 4909.708124] Pid: 10241, comm: migration/11 Tainted: G        W    3.6.0-rc7-warn-cpu-interrupt-0.0.0.28.36b5ec9-default #3
>> [ 4909.708124] Call Trace:
>> [ 4909.708124]  <IRQ>  [<ffffffff810e7336>] ? rcu_do_batch+0x386/0x3a0
>> [ 4909.708124]  [<ffffffff810e7336>] ? rcu_do_batch+0x386/0x3a0
>> [ 4909.708124]  [<ffffffff810433ea>] warn_slowpath_common+0x7a/0xb0
>> [ 4909.708124]  [<ffffffff81043435>] warn_slowpath_null+0x15/0x20
>> [ 4909.708124]  [<ffffffff810e7336>] rcu_do_batch+0x386/0x3a0
>> [ 4909.708124]  [<ffffffff810ac2b0>] ? trace_hardirqs_on_caller+0x70/0x1b0
>> [ 4909.708124]  [<ffffffff810ac3fd>] ? trace_hardirqs_on+0xd/0x10
>> [ 4909.708124]  [<ffffffff810e8c73>] __rcu_process_callbacks+0x1a3/0x200
>> [ 4909.708124]  [<ffffffff810e8d58>] rcu_process_callbacks+0x88/0x240
>> [ 4909.708124]  [<ffffffff8104dcb9>] __do_softirq+0x159/0x400
>> [ 4909.708124]  [<ffffffff814c6dbc>] call_softirq+0x1c/0x30
>> [ 4909.708124]  [<ffffffff81004525>] do_softirq+0x95/0xd0
>> [ 4909.708124]  [<ffffffff8104d785>] irq_exit+0xe5/0x100
>> [ 4909.708124]  [<ffffffff81028f51>] smp_apic_timer_interrupt+0x81/0xd0
>> [ 4909.708124]  [<ffffffff814c662f>] apic_timer_interrupt+0x6f/0x80
>> [ 4909.708124]  <EOI>  [<ffffffff810cf8aa>] ? stop_machine_cpu_stop+0xda/0x130
>> [ 4909.708124]  [<ffffffff810cf7d0>] ? stop_one_cpu_nowait+0x50/0x50
>> [ 4909.708124]  [<ffffffff810cf4e9>] cpu_stopper_thread+0xd9/0x1b0
>> [ 4909.708124]  [<ffffffff814bc98f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
>> [ 4909.708124]  [<ffffffff810cf410>] ? res_counter_init+0x50/0x50
>> [ 4909.708124]  [<ffffffff810ac36d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
>> [ 4909.708124]  [<ffffffff810ac3fd>] ? trace_hardirqs_on+0xd/0x10
>> [ 4909.708124]  [<ffffffff810cf410>] ? res_counter_init+0x50/0x50
>> [ 4909.708124]  [<ffffffff8106df0e>] kthread+0x9e/0xb0
>> [ 4909.708124]  [<ffffffff814c6cc4>] kernel_thread_helper+0x4/0x10
>> [ 4909.708124]  [<ffffffff814bcd30>] ? retint_restore_args+0x13/0x13
>> [ 4909.708124]  [<ffffffff8106de70>] ? __init_kthread_worker+0x70/0x70
>> [ 4909.708124]  [<ffffffff814c6cc0>] ? gs_change+0x13/0x13
>> [ 4909.708124] ---[ end trace 4591bad96b0e5f4d ]---
>> [ 4909.812522] smpboot: CPU 11 is now offline
>>
>>
>> [ 4974.727112] smpboot: CPU 12 is now offline
>> [ 4974.737763] CPU 4 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
>> [ 4974.896043] smpboot: CPU 13 is now offline
>> [ 4974.903566] CPU 5 MCA banks CMCI:2 CMCI:3 CMCI:5
>> [ 4974.968010] SMP Apic timer interrupt to offline CPU! 14
>> [ 4974.968010] ------------[ cut here ]------------
>> [ 4974.968010] WARNING: at arch/x86/kernel/apic/apic.c:904 smp_apic_timer_interrupt+0xc9/0xd0()
>> [ 4974.968010] Hardware name: IBM System x -[7870C4Q]-
>> [ 4974.968010] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm cdc_ether crc32c_intel i7core_edac shpchp usbnet pcspkr edac_core microcode tpm_tis mii bnx2 serio_raw lpc_ich mfd_core i2c_i801 pci_hotplug i2c_core tpm ioatdma dca tpm_bios sg button rtc_cmos uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
>> [ 4974.968010] Pid: 20651, comm: migration/14 Tainted: G        W    3.6.0-rc7-warn-cpu-interrupt-0.0.0.28.36b5ec9-default #3
>> [ 4974.968010] Call Trace:
>> [ 4974.968010]  <IRQ>  [<ffffffff81028f99>] ? smp_apic_timer_interrupt+0xc9/0xd0
>> [ 4974.968010]  [<ffffffff81028f99>] ? smp_apic_timer_interrupt+0xc9/0xd0
>> [ 4974.968010]  [<ffffffff810433ea>] warn_slowpath_common+0x7a/0xb0
>> [ 4974.968010]  [<ffffffff81043435>] warn_slowpath_null+0x15/0x20
>> [ 4974.968010]  [<ffffffff81028f99>] smp_apic_timer_interrupt+0xc9/0xd0
>> [ 4974.968010]  [<ffffffff814c662f>] apic_timer_interrupt+0x6f/0x80
>> [ 4974.968010]  <EOI>  [<ffffffff810cf8aa>] ? stop_machine_cpu_stop+0xda/0x130
>> [ 4974.968010]  [<ffffffff810cf7d0>] ? stop_one_cpu_nowait+0x50/0x50
>> [ 4974.968010]  [<ffffffff810cf4e9>] cpu_stopper_thread+0xd9/0x1b0
>> [ 4974.968010]  [<ffffffff814bc98f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
>> [ 4974.968010]  [<ffffffff810cf410>] ? res_counter_init+0x50/0x50
>> [ 4974.968010]  [<ffffffff810ac36d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
>> [ 4974.968010]  [<ffffffff810ac3fd>] ? trace_hardirqs_on+0xd/0x10
>> [ 4974.968010]  [<ffffffff810cf410>] ? res_counter_init+0x50/0x50
>> [ 4974.968010]  [<ffffffff8106df0e>] kthread+0x9e/0xb0
>> [ 4974.968010]  [<ffffffff814c6cc4>] kernel_thread_helper+0x4/0x10
>> [ 4974.968010]  [<ffffffff814bcd30>] ? retint_restore_args+0x13/0x13
>> [ 4974.968010]  [<ffffffff8106de70>] ? __init_kthread_worker+0x70/0x70
>> [ 4974.968010]  [<ffffffff814c6cc0>] ? gs_change+0x13/0x13
>> [ 4974.968010] ---[ end trace 4591bad96b0e5f4e ]---
>> [ 4975.179145] smpboot: CPU 14 is now offline
>>

