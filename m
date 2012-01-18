Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2ARKT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:19:26 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55250 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193Ab2ARKTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:19:21 -0500
Message-ID: <4F169C94.5030406@linux.vnet.ibm.com>
Date: Wed, 18 Jan 2012 15:49:00 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com> <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com> <4F10BDF7.8030306@linux.vnet.ibm.com> <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com> <4F10EB5B.5060804@linux.vnet.ibm.com> <1326766892.16150.21.camel@sbsiddha-desk.sc.intel.com> <4F1544EA.5060907@linux.vnet.ibm.com> <1326856624.5291.20.camel@sbsiddha-mobl2>
In-Reply-To: <1326856624.5291.20.camel@sbsiddha-mobl2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011810-3864-0000-0000-000001035FC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 08:47 AM, Suresh Siddha wrote:

> On Tue, 2012-01-17 at 15:22 +0530, Srivatsa S. Bhat wrote:
>> Thanks for the patch, but unfortunately it doesn't fix the problem!
>> Exactly the same stack traces are seen during a CPU Hotplug stress test.
>> (I didn't even have to stress it - it is so fragile that just a script
>> to offline all cpus except the boot cpu was good enough to reproduce the
>> problem easily.)
> 
> hmm, that's weird. with the patch, sched_ilb_notifier() should have
> cleared the cpu going offline from the nohz.idle_cpus_mask. And this
> should have happened after that cpu is removed from active mask. So
> no-one else should add that cpu back to the nohz.idle_cpus_mask and this
> should prevent the issue from happening.
> 
> I could reproduce the problem easily with out the patch but when I
> applied the patch I couldn't recreate the issue. Srivatsa, can you
> please re-check the kernel you tested indeed has the fix?
> 


I rechecked, and just to be sure, I compiled a fresh kernel with top
commit 6a48897 (3.3 merge window) and your patch applied on top of that
(Note that your patch applied with a bit of line fuzzing). And still I could
easily reproduce the issue with CPU hotplug stress test (a script to
offline/online cpus wildly.) Here is the script, for your reference:

#! /bin/bash

NUMBER_OF_CPUS=`ls -d /sys/devices/system/cpu/cpu[0-9]* | wc -l`

cd /sys/devices/system/cpu

while [ 1 ]
do
        for ((i=1; i < NUMBER_OF_CPUS; i++ ))
        do
                state=`cat cpu$i/online`
                if [ $state -eq 0 ]
                then
                        echo 1 > cpu$i/online
                else
                        echo 0 > cpu$i/online
                fi
        done
done

> re-Reviewing the code/patch also doesn't give me a hint.
> 
>> I have a few questions regarding the synchronization with CPU Hotplug.
>> What guarantees that the code which selects and IPIs the new ilb is totally
>> race-free with respect to CPU hotplug and we will never IPI an offline CPU?
> 
> So, nohz_balancer_kick() gets called only from interrupts disabled.
> During that time (from selecting the ilb_cpu to sending the IPI), no cpu
> can go offline. As the offline happens from the stop-machine process
> context with interrupts disabled.
>

> Only thing we need to make sure is the offlined cpu shouldn't be part of
> the nohz.idle_cpus_mask and for post 3.2 code, posted patch ensures
> that.
>

> For 3.2 and before, when a cpu exits tickless idle, it gets removed from
> the nohz.idle_cpus_mask (and also from the nohz.load_balancer). And if
> the cpu is not in the active mask (while going offline), subsequent
> calls to select_nohz_load_balancer() ensures that the cpu going down
> doesn't update the nohz structures. So I thought 3.2 shouldn't exhibit
> this problem.
> 
> 
>> (As demonstrated above, this issue is in 3.2-rc7
>> as well.)
> 
> hmm, don't think we ran into this before 3.2. So, what am I missing from
> the above? I will try to reproduce it on 3.2 too.
> 


Sorry, I think I wasn't very clear about this. I was trying to make a
distinction between the 2 things here: !cpu_active(cpu) vs cpu_is_offline(cpu)

The warning in native_smp_send_reschedule() is for cpu_is_offline(cpu). And I
didn't hit this warning in 3.2.

However, as mentioned in my previous post, I added a warning for
!cpu_active(cpu) as well within native_smp_send_reschedule() just to check
if we could end up choosing a CPU that is going to be offline soon, as the new
ilb. And I hit this particular warning (which *I* added for debugging) in 3.2.

But reading your explanation above (thanks a lot for that btw!), I now
understand that even if we happen to choose a soon-to-be-offline CPU as the
new ilb, that CPU cannot go offline until we are done with
smp_send_reschedule() because of the stop-machine code that you pointed out.
IOW, I think adding a warning for !cpu_active(cpu) was not the right thing to
do, because it wouldn't cause any harm anyway.

So the only thing we should be watching out is: sending an IPI to an already
offline CPU (and not one which is yet to go offline). And unfortunately in
the current mainline (even with your patch applied) we still send IPIs to
offline CPUs ! :-(

Here is the log, in case it helps:


[  101.859907] lockdep: fixing up alternatives.
[  101.864370] Booting Node 0 Processor 9 APIC 0x3
[  101.869076] smpboot cpu 9: start_ip = 97000
[  101.884514] Calibrating delay loop (skipped) already calibrated this CPU
[  101.898302] NMI watchdog enabled, takes one hw-pmu counter.
[  101.910463] lockdep: fixing up alternatives.
[  101.915040] Booting Node 0 Processor 10 APIC 0x5
[  101.919912] smpboot cpu 10: start_ip = 97000
[  101.936872] ------------[ cut here ]------------
[  101.940864] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[  101.940864] Hardware name: IBM System x -[7870C4Q]-
[  101.940864] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod bnx2 i7core_edac shpchp ioatdma cdc_ether edac_core usbnet i2c_i801 pci_hotplug dca i2c_core iTCO_wdt iTCO_vendor_support pcspkr mii tpm_tis tpm tpm_bios serio_raw button rtc_cmos sg uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  101.972661] Pid: 6018, comm: migration/9 Tainted: G        W    3.2.0-6a48897_IPI_patched-0.0.0.28.36b5ec9-default #1
[  101.972661] Call Trace:
[  101.972661]  <IRQ>  [<ffffffff81021409>] ? native_smp_send_reschedule+0x59/0x60
[  101.972661]  [<ffffffff8103cfca>] warn_slowpath_common+0x7a/0xb0
[  101.972661]  [<ffffffff8103d015>] warn_slowpath_null+0x15/0x20
[  101.972661]  [<ffffffff81021409>] native_smp_send_reschedule+0x59/0x60
[  101.972661]  [<ffffffff81082de5>] trigger_load_balance+0x185/0x500
[  101.972661]  [<ffffffff81082e1b>] ? trigger_load_balance+0x1bb/0x500
[  101.972661]  [<ffffffff81073e37>] scheduler_tick+0x107/0x170
[  101.972661]  [<ffffffff8104e777>] update_process_times+0x67/0x80
[  101.972661]  [<ffffffff8109c6cf>] tick_sched_timer+0x5f/0xc0
[  101.972661]  [<ffffffff8109c670>] ? tick_nohz_handler+0x100/0x100
[  101.972661]  [<ffffffff8106a8de>] __run_hrtimer+0x12e/0x330
[  101.972661]  [<ffffffff8106ad27>] hrtimer_interrupt+0xc7/0x1f0
[  101.972661]  [<ffffffff81023024>] smp_apic_timer_interrupt+0x64/0xa0
[  101.972661]  [<ffffffff814a30f3>] apic_timer_interrupt+0x73/0x80
[  101.972661]  <EOI>  [<ffffffff810c56ba>] ? stop_machine_cpu_stop+0xda/0x130
[  101.972661]  [<ffffffff810c55e0>] ? stop_one_cpu_nowait+0x50/0x50
[  101.972661]  [<ffffffff810c52f9>] cpu_stopper_thread+0xd9/0x1b0
[  101.972661]  [<ffffffff8149948f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
[  101.972661]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  101.972661]  [<ffffffff810a2b5d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
[  101.972661]  [<ffffffff810a2bed>] ? trace_hardirqs_on+0xd/0x10
[  101.972661]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  101.972661]  [<ffffffff810655be>] kthread+0x9e/0xb0
[  101.972661]  [<ffffffff814a39f4>] kernel_thread_helper+0x4/0x10
[  101.972661]  [<ffffffff81499834>] ? retint_restore_args+0x13/0x13
[  101.972661]  [<ffffffff81065520>] ? __init_kthread_worker+0x70/0x70
[  101.972661]  [<ffffffff814a39f0>] ? gs_change+0x13/0x13
[  101.972661] ---[ end trace 5ad49345f4e941c1 ]---
[  101.935708] Calibrating delay loop (skipped) already calibrated this CPU
[  101.976841] NMI watchdog enabled, takes one hw-pmu counter.
[  102.207744] lockdep: fixing up alternatives.
[  102.212183] Booting Node 0 Processor 11 APIC 0x7
[  102.216953] smpboot cpu 11: start_ip = 97000
[  102.232665] Calibrating delay loop (skipped) already calibrated this CPU
[  102.247822] NMI watchdog enabled, takes one hw-pmu counter.
[  102.263654] lockdep: fixing up alternatives.
[  102.268187] Booting Node 1 Processor 12 APIC 0x11
[  102.273072] smpboot cpu 12: start_ip = 97000
[  102.288903] Calibrating delay loop (skipped) already calibrated this CPU
[  102.300696] NMI watchdog enabled, takes one hw-pmu counter.
[  102.314589] lockdep: fixing up alternatives.
[  102.319049] Booting Node 1 Processor 13 APIC 0x13
[  102.323935] smpboot cpu 13: start_ip = 97000
[  102.340579] ------------[ cut here ]------------
[  102.344574] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[  102.344574] Hardware name: IBM System x -[7870C4Q]-
[  102.344574] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod bnx2 i7core_edac shpchp ioatdma cdc_ether edac_core usbnet i2c_i801 pci_hotplug dca i2c_core iTCO_wdt iTCO_vendor_support pcspkr mii tpm_tis tpm tpm_bios serio_raw button rtc_cmos sg uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  102.344574] Pid: 5945, comm: migration/1 Tainted: G        W    3.2.0-6a48897_IPI_patched-0.0.0.28.36b5ec9-default #1
[  102.344574] Call Trace:
[  102.344574]  <IRQ>  [<ffffffff81021409>] ? native_smp_send_reschedule+0x59/0x60
[  102.344574]  [<ffffffff8103cfca>] warn_slowpath_common+0x7a/0xb0
[  102.344574]  [<ffffffff8103d015>] warn_slowpath_null+0x15/0x20
[  102.344574]  [<ffffffff81021409>] native_smp_send_reschedule+0x59/0x60
[  102.344574]  [<ffffffff81082de5>] trigger_load_balance+0x185/0x500
[  102.344574]  [<ffffffff81082e1b>] ? trigger_load_balance+0x1bb/0x500
[  102.344574]  [<ffffffff81073e37>] scheduler_tick+0x107/0x170
[  102.344574]  [<ffffffff8104e777>] update_process_times+0x67/0x80
[  102.344574]  [<ffffffff8109c6cf>] tick_sched_timer+0x5f/0xc0
[  102.344574]  [<ffffffff8109c670>] ? tick_nohz_handler+0x100/0x100
[  102.344574]  [<ffffffff8106a8de>] __run_hrtimer+0x12e/0x330
[  102.344574]  [<ffffffff8106ad27>] hrtimer_interrupt+0xc7/0x1f0
[  102.344574]  [<ffffffff81023024>] smp_apic_timer_interrupt+0x64/0xa0
[  102.344574]  [<ffffffff814a30f3>] apic_timer_interrupt+0x73/0x80
[  102.344574]  <EOI>  [<ffffffff810c56ba>] ? stop_machine_cpu_stop+0xda/0x130
[  102.344574]  [<ffffffff810c55e0>] ? stop_one_cpu_nowait+0x50/0x50
[  102.344574]  [<ffffffff810c52f9>] cpu_stopper_thread+0xd9/0x1b0
[  102.344574]  [<ffffffff8149948f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
[  102.344574]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  102.344574]  [<ffffffff810a2b5d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
[  102.344574]  [<ffffffff810a2bed>] ? trace_hardirqs_on+0xd/0x10
[  102.344574]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  102.344574]  [<ffffffff810655be>] kthread+0x9e/0xb0
[  102.344574]  [<ffffffff814a39f4>] kernel_thread_helper+0x4/0x10
[  102.344574]  [<ffffffff81499834>] ? retint_restore_args+0x13/0x13
[  102.344574]  [<ffffffff81065520>] ? __init_kthread_worker+0x70/0x70
[  102.344574]  [<ffffffff814a39f0>] ? gs_change+0x13/0x13
[  102.344574] ---[ end trace 5ad49345f4e941c2 ]---
[  102.339643] Calibrating delay loop (skipped) already calibrated this CPU
[  102.350294] NMI watchdog enabled, takes one hw-pmu counter.
[  102.612059] lockdep: fixing up alternatives.
[  102.616608] Booting Node 1 Processor 14 APIC 0x15
[  102.621550] smpboot cpu 14: start_ip = 97000
[  102.637305] Calibrating delay loop (skipped) already calibrated this CPU
[  102.655053] NMI watchdog enabled, takes one hw-pmu counter.
[  102.671266] lockdep: fixing up alternatives.
[  102.675736] Booting Node 1 Processor 15 APIC 0x17
[  102.680599] smpboot cpu 15: start_ip = 97000
[  102.696292] Calibrating delay loop (skipped) already calibrated this CPU
[  102.715012] NMI watchdog enabled, takes one hw-pmu counter.
[  102.754087] CPU 1 is now offline
[  102.760470] CPU 9 MCA banks CMCI:2 CMCI:3 CMCI:5
[  102.781900] CPU 2 is now offline
[  102.789950] CPU 10 MCA banks CMCI:2 CMCI:3 CMCI:5
[  102.810198] CPU 3 is now offline
[  102.818284] CPU 11 MCA banks CMCI:2 CMCI:3 CMCI:5
[  102.837816] CPU 4 is now offline
[  102.843629] CPU 5 MCA banks CMCI:6 CMCI:8
[  102.848689] CPU 12 MCA banks CMCI:2 CMCI:3 CMCI:5
[  102.856038] ------------[ cut here ]------------
[  102.860034] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[  102.860034] Hardware name: IBM System x -[7870C4Q]-
[  102.860034] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod bnx2 i7core_edac shpchp ioatdma cdc_ether edac_core usbnet i2c_i801 pci_hotplug dca i2c_core iTCO_wdt iTCO_vendor_support pcspkr mii tpm_tis tpm tpm_bios serio_raw button rtc_cmos sg uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  102.860034] Pid: 6108, comm: cat Tainted: G        W    3.2.0-6a48897_IPI_patched-0.0.0.28.36b5ec9-default #1
[  102.860034] Call Trace:
[  102.860034]  <IRQ>  [<ffffffff81021409>] ? native_smp_send_reschedule+0x59/0x60
[  102.860034]  [<ffffffff8103cfca>] warn_slowpath_common+0x7a/0xb0
[  102.860034]  [<ffffffff8103d015>] warn_slowpath_null+0x15/0x20
[  102.860034]  [<ffffffff81021409>] native_smp_send_reschedule+0x59/0x60
[  102.860034]  [<ffffffff81082de5>] trigger_load_balance+0x185/0x500
[  102.860034]  [<ffffffff81082e1b>] ? trigger_load_balance+0x1bb/0x500
[  102.860034]  [<ffffffff81073e37>] scheduler_tick+0x107/0x170
[  102.860034]  [<ffffffff8104e777>] update_process_times+0x67/0x80
[  102.860034]  [<ffffffff8109c6cf>] tick_sched_timer+0x5f/0xc0
[  102.860034]  [<ffffffff8109c670>] ? tick_nohz_handler+0x100/0x100
[  102.860034]  [<ffffffff8106a8de>] __run_hrtimer+0x12e/0x330
[  102.860034]  [<ffffffff8106ad27>] hrtimer_interrupt+0xc7/0x1f0
[  102.860034]  [<ffffffff81023024>] smp_apic_timer_interrupt+0x64/0xa0
[  102.860034]  [<ffffffff81198d21>] ? alloc_fd+0x161/0x240
[  102.860034]  [<ffffffff814a30f3>] apic_timer_interrupt+0x73/0x80
[  102.860034]  <EOI>  [<ffffffff81499834>] ? retint_restore_args+0x13/0x13
[  102.860034]  [<ffffffff810a45af>] ? lock_release+0xef/0x140
[  102.860034]  [<ffffffff814994ee>] _raw_spin_unlock+0x1e/0x40
[  102.860034]  [<ffffffff81198d21>] alloc_fd+0x161/0x240
[  102.860034]  [<ffffffff8117834a>] do_sys_open+0x13a/0x1e0
[  102.860034]  [<ffffffff8117842c>] sys_open+0x1c/0x20
[  102.860034]  [<ffffffff814a25b9>] system_call_fastpath+0x16/0x1b
[  102.860034] ---[ end trace 5ad49345f4e941c3 ]---
[  103.082896] CPU 5 is now offline
[  103.088558] CPU 6 MCA banks CMCI:6 CMCI:8
[  103.093662] CPU 13 MCA banks CMCI:2 CMCI:3 CMCI:5
[  103.111169] CPU 6 is now offline
[  103.116628] CPU 7 MCA banks CMCI:6 CMCI:8
[  103.121692] CPU 14 MCA banks CMCI:2 CMCI:3 CMCI:5
[  103.138452] CPU 7 is now offline
[  103.144914] CPU 12 MCA banks CMCI:6 CMCI:8
[  103.149758] CPU 15 MCA banks CMCI:2 CMCI:3 CMCI:5
[  103.163062] CPU 8 is now offline
[  103.179727] CPU 9 is now offline
[  103.194055] CPU 10 is now offline
[  103.208301] CPU 11 is now offline
[  103.220189] Broke affinity for irq 28
[  103.225078] CPU 12 is now offline
[  103.230105] CPU 13 MCA banks CMCI:6 CMCI:8
[  103.243175] CPU 13 is now offline
[  103.249904] CPU 14 MCA banks CMCI:6 CMCI:8
[  103.260233] CPU 14 is now offline
[  103.266841] CPU 15 MCA banks CMCI:6 CMCI:8
[  103.275590] CPU 15 is now offline
[  103.279063] lockdep: fixing up alternatives.
[  103.283469] SMP alternatives: switching to UP code
[  103.308541] lockdep: fixing up alternatives.
[  103.312971] SMP alternatives: switching to SMP code
[  103.321357] Booting Node 0 Processor 1 APIC 0x2
[  103.326024] smpboot cpu 1: start_ip = 97000
[  103.340003] Calibrating delay loop (skipped) already calibrated this CPU
[  103.349334] NMI watchdog enabled, takes one hw-pmu counter.
[  103.365025] lockdep: fixing up alternatives.
[  103.369504] Booting Node 0 Processor 2 APIC 0x4
[  103.374192] smpboot cpu 2: start_ip = 97000
[  103.388176] Calibrating delay loop (skipped) already calibrated this CPU
[  103.397666] NMI watchdog enabled, takes one hw-pmu counter.
[  103.413404] lockdep: fixing up alternatives.
[  103.417862] Booting Node 0 Processor 3 APIC 0x6
[  103.422567] smpboot cpu 3: start_ip = 97000
[  103.438144] Calibrating delay loop (skipped) already calibrated this CPU
[  103.446717] NMI watchdog enabled, takes one hw-pmu counter.
[  103.461218] lockdep: fixing up alternatives.
[  103.465640] Booting Node 1 Processor 4 APIC 0x10
[  103.465642] smpboot cpu 4: start_ip = 97000
[  103.476769] Calibrating delay loop (skipped) already calibrated this CPU
[  103.485894] NMI watchdog enabled, takes one hw-pmu counter.
[  103.499316] lockdep: fixing up alternatives.
[  103.503779] Booting Node 1 Processor 5 APIC 0x12
[  103.508544] smpboot cpu 5: start_ip = 97000
[  103.524071] Calibrating delay loop (skipped) already calibrated this CPU
[  103.533298] NMI watchdog enabled, takes one hw-pmu counter.
[  103.551041] lockdep: fixing up alternatives.
[  103.555526] Booting Node 1 Processor 6 APIC 0x14
[  103.560431] smpboot cpu 6: start_ip = 97000
[  103.572930] Calibrating delay loop (skipped) already calibrated this CPU
[  103.587702] NMI watchdog enabled, takes one hw-pmu counter.
[  103.603090] lockdep: fixing up alternatives.
[  103.607530] Booting Node 1 Processor 7 APIC 0x16
[  103.612295] smpboot cpu 7: start_ip = 97000
[  103.627878] Calibrating delay loop (skipped) already calibrated this CPU
[  103.639610] NMI watchdog enabled, takes one hw-pmu counter.
[  103.655102] lockdep: fixing up alternatives.
[  103.659586] Booting Node 0 Processor 8 APIC 0x1
[  103.664268] smpboot cpu 8: start_ip = 97000
[  103.680600] ------------[ cut here ]------------
[  103.684594] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[  103.684594] Hardware name: IBM System x -[7870C4Q]-
[  103.684594] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod bnx2 i7core_edac shpchp ioatdma cdc_ether edac_core usbnet i2c_i801 pci_hotplug dca i2c_core iTCO_wdt iTCO_vendor_support pcspkr mii tpm_tis tpm tpm_bios serio_raw button rtc_cmos sg uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  103.730409] Pid: 6199, comm: migration/3 Tainted: G        W    3.2.0-6a48897_IPI_patched-0.0.0.28.36b5ec9-default #1
[  103.730409] Call Trace:
[  103.730409]  <IRQ>  [<ffffffff81021409>] ? native_smp_send_reschedule+0x59/0x60
[  103.730409]  [<ffffffff8103cfca>] warn_slowpath_common+0x7a/0xb0
[  103.730409]  [<ffffffff8103d015>] warn_slowpath_null+0x15/0x20
[  103.730409]  [<ffffffff81021409>] native_smp_send_reschedule+0x59/0x60
[  103.730409]  [<ffffffff81082de5>] trigger_load_balance+0x185/0x500
[  103.730409]  [<ffffffff81082e1b>] ? trigger_load_balance+0x1bb/0x500
[  103.730409]  [<ffffffff81073e37>] scheduler_tick+0x107/0x170
[  103.730409]  [<ffffffff8104e777>] update_process_times+0x67/0x80
[  103.730409]  [<ffffffff8109c6cf>] tick_sched_timer+0x5f/0xc0
[  103.730409]  [<ffffffff8109c670>] ? tick_nohz_handler+0x100/0x100
[  103.730409]  [<ffffffff8106a8de>] __run_hrtimer+0x12e/0x330
[  103.730409]  [<ffffffff8106ad27>] hrtimer_interrupt+0xc7/0x1f0
[  103.730409]  [<ffffffff81023024>] smp_apic_timer_interrupt+0x64/0xa0
[  103.730409]  [<ffffffff814a30f3>] apic_timer_interrupt+0x73/0x80
[  103.730409]  <EOI>  [<ffffffff810c56ba>] ? stop_machine_cpu_stop+0xda/0x130
[  103.730409]  [<ffffffff810c55e0>] ? stop_one_cpu_nowait+0x50/0x50
[  103.730409]  [<ffffffff810c52f9>] cpu_stopper_thread+0xd9/0x1b0
[  103.730409]  [<ffffffff8149948f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
[  103.730409]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  103.730409]  [<ffffffff810a2b5d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
[  103.730409]  [<ffffffff810a2bed>] ? trace_hardirqs_on+0xd/0x10
[  103.730409]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  103.730409]  [<ffffffff810655be>] kthread+0x9e/0xb0
[  103.730409]  [<ffffffff814a39f4>] kernel_thread_helper+0x4/0x10
[  103.730409]  [<ffffffff81499834>] ? retint_restore_args+0x13/0x13
[  103.730409]  [<ffffffff81065520>] ? __init_kthread_worker+0x70/0x70
[  103.730409]  [<ffffffff814a39f0>] ? gs_change+0x13/0x13
[  103.730409] ---[ end trace 5ad49345f4e941c4 ]---
[  103.676391] Calibrating delay loop (skipped) already calibrated this CPU
[  103.733199] NMI watchdog enabled, takes one hw-pmu counter.
[  103.949312] lockdep: fixing up alternatives.
[  103.953755] Booting Node 0 Processor 9 APIC 0x3
[  103.958455] smpboot cpu 9: start_ip = 97000
[  103.973999] Calibrating delay loop (skipped) already calibrated this CPU
[  103.987566] NMI watchdog enabled, takes one hw-pmu counter.
[  104.003382] lockdep: fixing up alternatives.
[  104.007844] Booting Node 0 Processor 10 APIC 0x5
[  104.014298] smpboot cpu 10: start_ip = 97000
[  104.029808] Calibrating delay loop (skipped) already calibrated this CPU
[  104.040937] NMI watchdog enabled, takes one hw-pmu counter.
[  104.057170] lockdep: fixing up alternatives.
[  104.061613] Booting Node 0 Processor 11 APIC 0x7
[  104.066383] smpboot cpu 11: start_ip = 97000
[  104.082333] Calibrating delay loop (skipped) already calibrated this CPU
[  104.097278] NMI watchdog enabled, takes one hw-pmu counter.
[  104.114759] lockdep: fixing up alternatives.
[  104.119185] Booting Node 1 Processor 12 APIC 0x11
[  104.124032] smpboot cpu 12: start_ip = 97000
[  104.140931] ------------[ cut here ]------------
[  104.144928] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[  104.144928] Hardware name: IBM System x -[7870C4Q]-
[  104.144928] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod bnx2 i7core_edac shpchp ioatdma cdc_ether edac_core usbnet i2c_i801 pci_hotplug dca i2c_core iTCO_wdt iTCO_vendor_support pcspkr mii tpm_tis tpm tpm_bios serio_raw button rtc_cmos sg uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  104.144928] Pid: 6246, comm: migration/8 Tainted: G        W    3.2.0-6a48897_IPI_patched-0.0.0.28.36b5ec9-default #1
[  104.144928] Call Trace:
[  104.144928]  <IRQ>  [<ffffffff81021409>] ? native_smp_send_reschedule+0x59/0x60
[  104.144928]  [<ffffffff8103cfca>] warn_slowpath_common+0x7a/0xb0
[  104.144928]  [<ffffffff8103d015>] warn_slowpath_null+0x15/0x20
[  104.236219]  [<ffffffff81021409>] native_smp_send_reschedule+0x59/0x60
[  104.236219]  [<ffffffff81082de5>] trigger_load_balance+0x185/0x500
[  104.236219]  [<ffffffff81082e1b>] ? trigger_load_balance+0x1bb/0x500
[  104.236219]  [<ffffffff81073e37>] scheduler_tick+0x107/0x170
[  104.236219]  [<ffffffff8104e777>] update_process_times+0x67/0x80
[  104.236219]  [<ffffffff8109c6cf>] tick_sched_timer+0x5f/0xc0
[  104.236219]  [<ffffffff8109c670>] ? tick_nohz_handler+0x100/0x100
[  104.236219]  [<ffffffff8106a8de>] __run_hrtimer+0x12e/0x330
[  104.236219]  [<ffffffff8106ad27>] hrtimer_interrupt+0xc7/0x1f0
[  104.236219]  [<ffffffff81023024>] smp_apic_timer_interrupt+0x64/0xa0
[  104.236219]  [<ffffffff814a30f3>] apic_timer_interrupt+0x73/0x80
[  104.236219]  <EOI>  [<ffffffff810c56ba>] ? stop_machine_cpu_stop+0xda/0x130
[  104.236219]  [<ffffffff810c55e0>] ? stop_one_cpu_nowait+0x50/0x50
[  104.236219]  [<ffffffff810c52f9>] cpu_stopper_thread+0xd9/0x1b0
[  104.236219]  [<ffffffff8149948f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
[  104.236219]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  104.236219]  [<ffffffff810a2b5d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
[  104.236219]  [<ffffffff810a2bed>] ? trace_hardirqs_on+0xd/0x10
[  104.236219]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  104.236219]  [<ffffffff810655be>] kthread+0x9e/0xb0
[  104.236219]  [<ffffffff814a39f4>] kernel_thread_helper+0x4/0x10
[  104.236219]  [<ffffffff81499834>] ? retint_restore_args+0x13/0x13
[  104.236219]  [<ffffffff81065520>] ? __init_kthread_worker+0x70/0x70
[  104.236219]  [<ffffffff814a39f0>] ? gs_change+0x13/0x13
[  104.236219] ---[ end trace 5ad49345f4e941c5 ]---
[  104.139577] Calibrating delay loop (skipped) already calibrated this CPU
[  104.243898] NMI watchdog enabled, takes one hw-pmu counter.
[  104.414707] lockdep: fixing up alternatives.
[  104.419169] Booting Node 1 Processor 13 APIC 0x13
[  104.424110] smpboot cpu 13: start_ip = 97000
[  104.439830] Calibrating delay loop (skipped) already calibrated this CPU
[  104.451953] NMI watchdog enabled, takes one hw-pmu counter.
[  104.467013] lockdep: fixing up alternatives.
[  104.471457] Booting Node 1 Processor 14 APIC 0x15
[  104.476330] smpboot cpu 14: start_ip = 97000
[  104.492131] Calibrating delay loop (skipped) already calibrated this CPU
[  104.510032] NMI watchdog enabled, takes one hw-pmu counter.
[  104.526274] lockdep: fixing up alternatives.
[  104.530715] Booting Node 1 Processor 15 APIC 0x17
[  104.535578] smpboot cpu 15: start_ip = 97000
[  104.551263] Calibrating delay loop (skipped) already calibrated this CPU
[  104.570011] NMI watchdog enabled, takes one hw-pmu counter.
[  104.606910] CPU 1 is now offline
[  104.612958] CPU 9 MCA banks CMCI:2 CMCI:3 CMCI:5
[  104.620013] ------------[ cut here ]------------
[  104.624007] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[  104.632694] Hardware name: IBM System x -[7870C4Q]-
[  104.632694] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod bnx2 i7core_edac shpchp ioatdma cdc_ether edac_core usbnet i2c_i801 pci_hotplug dca i2c_core iTCO_wdt iTCO_vendor_support pcspkr mii tpm_tis tpm tpm_bios serio_raw button rtc_cmos sg uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  104.632694] Pid: 6329, comm: udevd Tainted: G        W    3.2.0-6a48897_IPI_patched-0.0.0.28.36b5ec9-default #1
[  104.632694] Call Trace:
[  104.632694]  <IRQ>  [<ffffffff81021409>] ? native_smp_send_reschedule+0x59/0x60
[  104.632694]  [<ffffffff8103cfca>] warn_slowpath_common+0x7a/0xb0
[  104.632694]  [<ffffffff8103d015>] warn_slowpath_null+0x15/0x20
[  104.632694]  [<ffffffff81021409>] native_smp_send_reschedule+0x59/0x60
[  104.632694]  [<ffffffff81082de5>] trigger_load_balance+0x185/0x500
[  104.632694]  [<ffffffff81082e1b>] ? trigger_load_balance+0x1bb/0x500
[  104.632694]  [<ffffffff81073e37>] scheduler_tick+0x107/0x170
[  104.632694]  [<ffffffff8104e777>] update_process_times+0x67/0x80
[  104.632694]  [<ffffffff8109c6cf>] tick_sched_timer+0x5f/0xc0
[  104.632694]  [<ffffffff8109c670>] ? tick_nohz_handler+0x100/0x100
[  104.632694]  [<ffffffff8106a8de>] __run_hrtimer+0x12e/0x330
[  104.632694]  [<ffffffff8106ad27>] hrtimer_interrupt+0xc7/0x1f0
[  104.632694]  [<ffffffff81023024>] smp_apic_timer_interrupt+0x64/0xa0
[  104.632694]  [<ffffffff814a30f3>] apic_timer_interrupt+0x73/0x80
[  104.632694]  <EOI>  [<ffffffff810a3fda>] ? lock_acquire+0x13a/0x190
[  104.632694]  [<ffffffff81134b84>] ? zap_pte_range+0x84/0x3b0
[  104.632694]  [<ffffffff81498b4c>] _raw_spin_lock+0x3c/0x50
[  104.632694]  [<ffffffff81134b84>] ? zap_pte_range+0x84/0x3b0
[  104.632694]  [<ffffffff81134b84>] zap_pte_range+0x84/0x3b0
[  104.632694]  [<ffffffff81135773>] unmap_page_range+0x243/0x300
[  104.632694]  [<ffffffff811358fc>] unmap_vmas+0xcc/0x150
[  104.632694]  [<ffffffff8113b27d>] exit_mmap+0x8d/0x120
[  104.632694]  [<ffffffff8103ad1c>] mmput+0x6c/0x150
[  104.632694]  [<ffffffff810400ca>] exit_mm+0x10a/0x140
[  104.632694]  [<ffffffff8149942b>] ? _raw_spin_unlock_irq+0x2b/0x50
[  104.632694]  [<ffffffff813152f3>] ? tty_audit_exit+0x23/0xa0
[  104.632694]  [<ffffffff810428e7>] do_exit+0x157/0x470
[  104.632694]  [<ffffffff810a2b5d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
[  104.632694]  [<ffffffff81042c47>] do_group_exit+0x47/0xc0
[  104.632694]  [<ffffffff81042cd2>] sys_exit_group+0x12/0x20
[  104.632694]  [<ffffffff814a25b9>] system_call_fastpath+0x16/0x1b
[  104.632694] ---[ end trace 5ad49345f4e941c6 ]---
[  104.889588] CPU 2 is now offline
[  104.894956] CPU 10 MCA banks CMCI:2 CMCI:3 CMCI:5
[  104.909813] CPU 3 is now offline
[  104.917505] CPU 11 MCA banks CMCI:2 CMCI:3 CMCI:5
[  104.937367] CPU 4 is now offline
[  104.944280] CPU 5 MCA banks CMCI:6 CMCI:8
[  104.949190] CPU 12 MCA banks CMCI:2 CMCI:3 CMCI:5
[  104.967718] CPU 5 is now offline
[  104.973542] CPU 6 MCA banks CMCI:6 CMCI:8
[  104.978528] CPU 13 MCA banks CMCI:2 CMCI:3 CMCI:5
[  104.996528] CPU 6 is now offline
[  105.001621] CPU 7 MCA banks CMCI:6 CMCI:8
[  105.006747] CPU 14 MCA banks CMCI:2 CMCI:3 CMCI:5
[  105.021426] CPU 7 is now offline
[  105.027310] CPU 12 MCA banks CMCI:6 CMCI:8
[  105.032101] CPU 15 MCA banks CMCI:2 CMCI:3 CMCI:5
[  105.045291] CPU 8 is now offline
[  105.061777] CPU 9 is now offline
[  105.078397] CPU 10 is now offline
[  105.091618] CPU 11 is now offline
[  105.107865] CPU 12 is now offline
[  105.114138] CPU 13 MCA banks CMCI:6 CMCI:8
[  105.127674] CPU 13 is now offline
[  105.133645] CPU 14 MCA banks CMCI:6 CMCI:8
[  105.144174] CPU 14 is now offline
[  105.150421] CPU 15 MCA banks CMCI:6 CMCI:8
[  105.160126] CPU 15 is now offline
[  105.163602] lockdep: fixing up alternatives.
[  105.168014] SMP alternatives: switching to UP code
[  105.192945] lockdep: fixing up alternatives.
[  105.197382] SMP alternatives: switching to SMP code
[  105.205661] Booting Node 0 Processor 1 APIC 0x2
[  105.210360] smpboot cpu 1: start_ip = 97000
[  105.224003] Calibrating delay loop (skipped) already calibrated this CPU
[  105.233600] NMI watchdog enabled, takes one hw-pmu counter.
[  105.240007] ------------[ cut here ]------------
[  105.244004] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[  105.244004] Hardware name: IBM System x -[7870C4Q]-
[  105.244004] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod bnx2 i7core_edac shpchp ioatdma cdc_ether edac_core usbnet i2c_i801 pci_hotplug dca i2c_core iTCO_wdt iTCO_vendor_support pcspkr mii tpm_tis tpm tpm_bios serio_raw button rtc_cmos sg uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  105.244004] Pid: 1736, comm: udevd Tainted: G        W    3.2.0-6a48897_IPI_patched-0.0.0.28.36b5ec9-default #1
[  105.244004] Call Trace:
[  105.244004]  <IRQ>  [<ffffffff81021409>] ? native_smp_send_reschedule+0x59/0x60
[  105.244004]  [<ffffffff8103cfca>] warn_slowpath_common+0x7a/0xb0
[  105.244004]  [<ffffffff8103d015>] warn_slowpath_null+0x15/0x20
[  105.244004]  [<ffffffff81021409>] native_smp_send_reschedule+0x59/0x60
[  105.244004]  [<ffffffff81082de5>] trigger_load_balance+0x185/0x500
[  105.244004]  [<ffffffff81082e1b>] ? trigger_load_balance+0x1bb/0x500
[  105.244004]  [<ffffffff81073e37>] scheduler_tick+0x107/0x170
[  105.244004]  [<ffffffff8104e777>] update_process_times+0x67/0x80
[  105.244004]  [<ffffffff8109c6cf>] tick_sched_timer+0x5f/0xc0
[  105.244004]  [<ffffffff8109c670>] ? tick_nohz_handler+0x100/0x100
[  105.244004]  [<ffffffff8106a8de>] __run_hrtimer+0x12e/0x330
[  105.244004]  [<ffffffff8106ad27>] hrtimer_interrupt+0xc7/0x1f0
[  105.244004]  [<ffffffff81023024>] smp_apic_timer_interrupt+0x64/0xa0
[  105.244004]  [<ffffffff814a30f3>] apic_timer_interrupt+0x73/0x80
[  105.244004]  <EOI>  [<ffffffff81185b56>] ? getname_flags+0x36/0x270
[  105.244004]  [<ffffffff8115d7a0>] ? check_poison_obj+0x40/0x200
[  105.244004]  [<ffffffff81185b56>] ? getname_flags+0x36/0x270
[  105.244004]  [<ffffffff8115db18>] cache_alloc_debugcheck_after+0x1b8/0x270
[  105.244004]  [<ffffffff81185b56>] ? getname_flags+0x36/0x270
[  105.244004]  [<ffffffff81160510>] kmem_cache_alloc+0x160/0x370
[  105.244004]  [<ffffffff81185b56>] getname_flags+0x36/0x270
[  105.244004]  [<ffffffff8118ad06>] user_path_at_empty+0x36/0xb0
[  105.244004]  [<ffffffff810a2b5d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
[  105.244004]  [<ffffffff810a2bed>] ? trace_hardirqs_on+0xd/0x10
[  105.244004]  [<ffffffff8118ad8c>] user_path_at+0xc/0x10
[  105.244004]  [<ffffffff8117eb76>] vfs_fstatat+0x46/0x80
[  105.244004]  [<ffffffff8117ecd6>] vfs_stat+0x16/0x20
[  105.244004]  [<ffffffff8117ecff>] sys_newstat+0x1f/0x50
[  105.244004]  [<ffffffff810a2b5d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
[  105.244004]  [<ffffffff8127c7be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  105.244004]  [<ffffffff814a25b9>] system_call_fastpath+0x16/0x1b
[  105.244004] ---[ end trace 5ad49345f4e941c7 ]---
[  105.522657] lockdep: fixing up alternatives.
[  105.527152] Booting Node 0 Processor 2 APIC 0x4
[  105.531859] smpboot cpu 2: start_ip = 97000
[  105.546905] Calibrating delay loop (skipped) already calibrated this CPU
[  105.555722] NMI watchdog enabled, takes one hw-pmu counter.
[  105.569584] lockdep: fixing up alternatives.
[  105.574017] Booting Node 0 Processor 3 APIC 0x6
[  105.578693] smpboot cpu 3: start_ip = 97000
[  105.592007] Calibrating delay loop (skipped) already calibrated this CPU
[  105.602441] NMI watchdog enabled, takes one hw-pmu counter.
[  105.614230] lockdep: fixing up alternatives.
[  105.618692] Booting Node 1 Processor 4 APIC 0x10
[  105.623492] smpboot cpu 4: start_ip = 97000
[  105.640087] ------------[ cut here ]------------
[  105.644084] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[  105.644084] Hardware name: IBM System x -[7870C4Q]-
[  105.644084] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod bnx2 i7core_edac shpchp ioatdma cdc_ether edac_core usbnet i2c_i801 pci_hotplug dca i2c_core iTCO_wdt iTCO_vendor_support pcspkr mii tpm_tis tpm tpm_bios serio_raw button rtc_cmos sg uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  105.644084] Pid: 6, comm: migration/0 Tainted: G        W    3.2.0-6a48897_IPI_patched-0.0.0.28.36b5ec9-default #1
[  105.644084] Call Trace:
[  105.644084]  <IRQ>  [<ffffffff81021409>] ? native_smp_send_reschedule+0x59/0x60
[  105.644084]  [<ffffffff8103cfca>] warn_slowpath_common+0x7a/0xb0
[  105.644084]  [<ffffffff8103d015>] warn_slowpath_null+0x15/0x20
[  105.644084]  [<ffffffff81021409>] native_smp_send_reschedule+0x59/0x60
[  105.644084]  [<ffffffff81082de5>] trigger_load_balance+0x185/0x500
[  105.644084]  [<ffffffff81082e1b>] ? trigger_load_balance+0x1bb/0x500
[  105.644084]  [<ffffffff81073e37>] scheduler_tick+0x107/0x170
[  105.644084]  [<ffffffff8104e777>] update_process_times+0x67/0x80
[  105.644084]  [<ffffffff8109c6cf>] tick_sched_timer+0x5f/0xc0
[  105.644084]  [<ffffffff8109c670>] ? tick_nohz_handler+0x100/0x100
[  105.644084]  [<ffffffff8106a8de>] __run_hrtimer+0x12e/0x330
[  105.644084]  [<ffffffff8106ad27>] hrtimer_interrupt+0xc7/0x1f0
[  105.644084]  [<ffffffff81023024>] smp_apic_timer_interrupt+0x64/0xa0
[  105.644084]  [<ffffffff814a30f3>] apic_timer_interrupt+0x73/0x80
[  105.644084]  <EOI>  [<ffffffff810c56ba>] ? stop_machine_cpu_stop+0xda/0x130
[  105.644084]  [<ffffffff810c55e0>] ? stop_one_cpu_nowait+0x50/0x50
[  105.644084]  [<ffffffff810c52f9>] cpu_stopper_thread+0xd9/0x1b0
[  105.644084]  [<ffffffff8149948f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
[  105.644084]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  105.644084]  [<ffffffff810a2b5d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
[  105.644084]  [<ffffffff810a2bed>] ? trace_hardirqs_on+0xd/0x10
[  105.644084]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  105.644084]  [<ffffffff810655be>] kthread+0x9e/0xb0
[  105.644084]  [<ffffffff814a39f4>] kernel_thread_helper+0x4/0x10
[  105.644084]  [<ffffffff81499834>] ? retint_restore_args+0x13/0x13
[  105.644084]  [<ffffffff81065520>] ? __init_kthread_worker+0x70/0x70
[  105.644084]  [<ffffffff814a39f0>] ? gs_change+0x13/0x13
[  105.644084] ---[ end trace 5ad49345f4e941c8 ]---
[  105.638988] Calibrating delay loop (skipped) already calibrated this CPU
[  105.899283] NMI watchdog enabled, takes one hw-pmu counter.
[  105.915038] lockdep: fixing up alternatives.
[  105.919475] Booting Node 1 Processor 5 APIC 0x12
[  105.924245] smpboot cpu 5: start_ip = 97000
[  105.940631] ------------[ cut here ]------------
[  105.944627] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[  105.944627] Hardware name: IBM System x -[7870C4Q]-
[  105.944627] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod bnx2 i7core_edac shpchp ioatdma cdc_ether edac_core usbnet i2c_i801 pci_hotplug dca i2c_core iTCO_wdt iTCO_vendor_support pcspkr mii tpm_tis tpm tpm_bios serio_raw button rtc_cmos sg uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  105.944627] Pid: 6428, comm: migration/2 Tainted: G        W    3.2.0-6a48897_IPI_patched-0.0.0.28.36b5ec9-default #1
[  105.944627] Call Trace:
[  105.944627]  <IRQ>  [<ffffffff81021409>] ? native_smp_send_reschedule+0x59/0x60
[  105.944627]  [<ffffffff8103cfca>] warn_slowpath_common+0x7a/0xb0
[  105.944627]  [<ffffffff8103d015>] warn_slowpath_null+0x15/0x20
[  106.034846]  [<ffffffff81021409>] native_smp_send_reschedule+0x59/0x60
[  106.034846]  [<ffffffff81082de5>] trigger_load_balance+0x185/0x500
[  106.034846]  [<ffffffff81082e1b>] ? trigger_load_balance+0x1bb/0x500
[  106.034846]  [<ffffffff81073e37>] scheduler_tick+0x107/0x170
[  106.034846]  [<ffffffff8104e777>] update_process_times+0x67/0x80
[  106.034846]  [<ffffffff8109c6cf>] tick_sched_timer+0x5f/0xc0
[  106.034846]  [<ffffffff8109c670>] ? tick_nohz_handler+0x100/0x100
[  106.034846]  [<ffffffff8106a8de>] __run_hrtimer+0x12e/0x330
[  106.034846]  [<ffffffff8106ad27>] hrtimer_interrupt+0xc7/0x1f0
[  106.034846]  [<ffffffff81023024>] smp_apic_timer_interrupt+0x64/0xa0
[  106.034846]  [<ffffffff814a30f3>] apic_timer_interrupt+0x73/0x80
[  106.034846]  <EOI>  [<ffffffff810c56ba>] ? stop_machine_cpu_stop+0xda/0x130
[  106.034846]  [<ffffffff810c55e0>] ? stop_one_cpu_nowait+0x50/0x50
[  106.034846]  [<ffffffff810c52f9>] cpu_stopper_thread+0xd9/0x1b0
[  106.034846]  [<ffffffff8149948f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
[  106.034846]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  106.034846]  [<ffffffff810a2b5d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
[  106.034846]  [<ffffffff810a2bed>] ? trace_hardirqs_on+0xd/0x10
[  106.034846]  [<ffffffff810c5220>] ? res_counter_init+0x50/0x50
[  106.034846]  [<ffffffff810655be>] kthread+0x9e/0xb0
[  106.034846]  [<ffffffff814a39f4>] kernel_thread_helper+0x4/0x10
[  106.034846]  [<ffffffff81499834>] ? retint_restore_args+0x13/0x13
[  106.034846]  [<ffffffff81065520>] ? __init_kthread_worker+0x70/0x70
[  106.034846]  [<ffffffff814a39f0>] ? gs_change+0x13/0x13
[  106.034846] ---[ end trace 5ad49345f4e941c9 ]---
[  105.939769] Calibrating delay loop (skipped) already calibrated this CPU
[  106.041217] NMI watchdog enabled, takes one hw-pmu counter.
[  106.213412] lockdep: fixing up alternatives.
[  106.217921] Booting Node 1 Processor 6 APIC 0x14
[  106.222769] smpboot cpu 6: start_ip = 97000
[  106.238435] Calibrating delay loop (skipped) already calibrated this CPU
[  106.247789] NMI watchdog enabled, takes one hw-pmu counter.
[  106.263513] lockdep: fixing up alternatives.
[  106.267948] Booting Node 1 Processor 7 APIC 0x16
[  106.272723] smpboot cpu 7: start_ip = 97000
[  106.288103] Calibrating delay loop (skipped) already calibrated this CPU
[  106.297965] NMI watchdog enabled, takes one hw-pmu counter.
[  106.313050] lockdep: fixing up alternatives.
[  106.317523] Booting Node 0 Processor 8 APIC 0x1
[  106.322206] smpboot cpu 8: start_ip = 97000
[  106.337772] Calibrating delay loop (skipped) already calibrated this CPU
[  106.347702] NMI watchdog enabled, takes one hw-pmu counter.
[  106.363043] lockdep: fixing up alternatives.
[  106.367580] Booting Node 0 Processor 9 APIC 0x3
[  106.372315] smpboot cpu 9: start_ip = 97000
[  106.388071] Calibrating delay loop (skipped) already calibrated this CPU
[  106.401878] NMI watchdog enabled, takes one hw-pmu counter.
[  106.418266] lockdep: fixing up alternatives.
[  106.422755] Booting Node 0 Processor 10 APIC 0x5
[  106.422758] smpboot cpu 10: start_ip = 97000
[  106.432548] Calibrating delay loop (skipped) already calibrated this CPU
[  106.444762] NMI watchdog enabled, takes one hw-pmu counter.
[  106.460886] lockdep: fixing up alternatives.
[  106.465317] Booting Node 0 Processor 11 APIC 0x7
[  106.470081] smpboot cpu 11: start_ip = 97000
[  106.485636] Calibrating delay loop (skipped) already calibrated this CPU
[  106.496893] NMI watchdog enabled, takes one hw-pmu counter.
[  106.511748] lockdep: fixing up alternatives.
[  106.516201] Booting Node 1 Processor 12 APIC 0x11
[  106.521093] smpboot cpu 12: start_ip = 97000
[  106.536798] Calibrating delay loop (skipped) already calibrated this CPU
[  106.548584] NMI watchdog enabled, takes one hw-pmu counter.
[  106.563246] lockdep: fixing up alternatives.
[  106.567717] Booting Node 1 Processor 13 APIC 0x13
[  106.572584] smpboot cpu 13: start_ip = 97000
[  106.588291] Calibrating delay loop (skipped) already calibrated this CPU
[  106.600482] NMI watchdog enabled, takes one hw-pmu counter.
[  106.614962] lockdep: fixing up alternatives.
[  106.619398] Booting Node 1 Processor 14 APIC 0x15
[  106.624280] smpboot cpu 14: start_ip = 97000
[  106.640082] Calibrating delay loop (skipped) already calibrated this CPU
[  106.657871] NMI watchdog enabled, takes one hw-pmu counter.
[  106.673572] lockdep: fixing up alternatives.
[  106.678024] Booting Node 1 Processor 15 APIC 0x17
[  106.682912] smpboot cpu 15: start_ip = 97000
[  106.698605] Calibrating delay loop (skipped) already calibrated this CPU
[  106.711375] NMI watchdog enabled, takes one hw-pmu counter.
[  106.748563] CPU 1 is now offline
[  106.754950] CPU 9 MCA banks
[  106.756020] ------------[ cut here ]------------
[  106.756028] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[  106.756031] Hardware name: IBM System x -[7870C4Q]-
[  106.756033] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod bnx2 i7core_edac shpchp ioatdma cdc_ether edac_core usbnet i2c_i801 pci_hotplug dca i2c_core iTCO_wdt iTCO_vendor_support pcspkr mii tpm_tis tpm tpm_bios serio_raw button rtc_cmos sg uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  106.756077] Pid: 1736, comm: udevd Tainted: G        W    3.2.0-6a48897_IPI_patched-0.0.0.28.36b5ec9-default #1
[  106.756079] Call Trace:
[  106.756081]  <IRQ>  [<ffffffff81021409>] ? native_smp_send_reschedule+0x59/0x60
[  106.756090]  [<ffffffff8103cfca>] warn_slowpath_common+0x7a/0xb0
[  106.756094]  [<ffffffff8103d015>] warn_slowpath_null+0x15/0x20
[  106.756098]  [<ffffffff81021409>] native_smp_send_reschedule+0x59/0x60
[  106.756103]  [<ffffffff81082de5>] trigger_load_balance+0x185/0x500
[  106.756107]  [<ffffffff81082e1b>] ? trigger_load_balance+0x1bb/0x500
[  106.756113]  [<ffffffff81073e37>] scheduler_tick+0x107/0x170
[  106.756119]  [<ffffffff8104e777>] update_process_times+0x67/0x80
[  106.756124]  [<ffffffff8109c6cf>] tick_sched_timer+0x5f/0xc0
[  106.756128]  [<ffffffff8109c670>] ? tick_nohz_handler+0x100/0x100
[  106.756133]  [<ffffffff8106a8de>] __run_hrtimer+0x12e/0x330
[  106.756138]  [<ffffffff8106ad27>] hrtimer_interrupt+0xc7/0x1f0
[  106.756142]  [<ffffffff81023024>] smp_apic_timer_interrupt+0x64/0xa0
[  106.756147]  [<ffffffff81193222>] ? try_to_ascend+0x82/0x160
[  106.756153]  [<ffffffff814a30f3>] apic_timer_interrupt+0x73/0x80
[  106.756155]  <EOI>  [<ffffffff810a45a6>] ? lock_release+0xe6/0x140
[  106.756165]  [<ffffffff814994ee>] _raw_spin_unlock+0x1e/0x40
[  106.756169]  [<ffffffff81193222>] try_to_ascend+0x82/0x160
[  106.756172]  [<ffffffff811931ef>] ? try_to_ascend+0x4f/0x160
[  106.756176]  [<ffffffff811937e1>] select_parent+0x111/0x2b0
[  106.756179]  [<ffffffff81193ef3>] ? shrink_dcache_parent+0x33/0x40
[  106.756183]  [<ffffffff81193ef3>] shrink_dcache_parent+0x33/0x40
[  106.756188]  [<ffffffff81186d9d>] vfs_rmdir+0xcd/0x120
[  106.756192]  [<ffffffff8118ac69>] do_rmdir+0x139/0x140
[  106.756197]  [<ffffffff814a25e5>] ? sysret_check+0x22/0x5d
[  106.756201]  [<ffffffff810a2b5d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
[  106.756207]  [<ffffffff8127c7be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  106.756211]  [<ffffffff8118acc1>] sys_rmdir+0x11/0x20
[  106.756215]  [<ffffffff814a25b9>] system_call_fastpath+0x16/0x1b
[  106.756217] ---[ end trace 5ad49345f4e941ca ]---
[  107.000131]  CMCI:2 CMCI:3 CMCI:5

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

