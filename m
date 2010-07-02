Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab0GBRRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:17:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45459 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab0GBRRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:17:51 -0400
MIME-Version: 1.0
In-Reply-To: <4C2CEF5D.8060609@redhat.com>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop> 
	<1277136847-13266-11-git-send-email-stefano@stabellini.net> 
	<4C2CEF5D.8060609@redhat.com>
From: Stefano Stabellini <stefano@stabellini.net>
Date: Fri, 2 Jul 2010 18:17:29 +0100
Message-ID: <AANLkTilZN48w9ODpbOQfPzgTH4wGOfAhCMgaGnO9goHu@mail.gmail.com>
Subject: Re: [PATCH 11/13] Use xen_vcpuop_clockevent, xen_clocksource and xen 
	wallclock.
To: ddutile@redhat.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Stefano.Stabellini@eu.citrix.com, sheng@linux.intel.com,
       jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 8:41 PM, Don Dutile <ddutile@redhat.com> wrote:
> stefano@stabellini.net wrote:
>> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>
>> Use xen_vcpuop_clockevent instead of hpet and APIC timers as main
>> clockevent device on all vcpus, use the xen wallclock time as wallclock
>> instead of rtc and use xen_clocksource as clocksource.
>> The pv clock algorithm needs to work correctly for the xen_clocksource
>> and xen wallclock to be usable, only modern Xen versions offer a
>> reliable pv clock in HVM guests (XENFEAT_hvm_safe_pvclock).
>>
>> Using the hpet as clocksource means a VMEXIT every time we read/write to
>> the hpet mmio addresses, pvclock give us a better rating without
>> VMEXITs. Same goes for the xen wallclock and xen_vcpuop_clockevent
>>
>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> ---
>>  arch/x86/xen/enlighten.c         |   14 +--------
>>  arch/x86/xen/suspend.c           |    4 ++
>>  arch/x86/xen/time.c              |   59 ++++++++++++++++++++++++++++++++++---
>>  arch/x86/xen/xen-ops.h           |    7 +---
>>  include/xen/interface/features.h |    3 ++
>>  5 files changed, 65 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>> index 90bac21..bcd98a9 100644
>> --- a/arch/x86/xen/enlighten.c
>> +++ b/arch/x86/xen/enlighten.c
>> @@ -933,10 +933,6 @@ static const struct pv_init_ops xen_init_ops __initdata = {
>>       .patch = xen_patch,
>>  };
>>
>> -static const struct pv_time_ops xen_time_ops __initdata = {
>> -     .sched_clock = xen_sched_clock,
>> -};
>> -
>>  static const struct pv_cpu_ops xen_cpu_ops __initdata = {
>>       .cpuid = xen_cpuid,
>>
>> @@ -1074,7 +1070,6 @@ asmlinkage void __init xen_start_kernel(void)
>>       /* Install Xen paravirt ops */
>>       pv_info = xen_info;
>>       pv_init_ops = xen_init_ops;
>> -     pv_time_ops = xen_time_ops;
>>       pv_cpu_ops = xen_cpu_ops;
>>       pv_apic_ops = xen_apic_ops;
>>
>> @@ -1082,13 +1077,7 @@ asmlinkage void __init xen_start_kernel(void)
>>       x86_init.oem.arch_setup = xen_arch_setup;
>>       x86_init.oem.banner = xen_banner;
>>
>> -     x86_init.timers.timer_init = xen_time_init;
>> -     x86_init.timers.setup_percpu_clockev = x86_init_noop;
>> -     x86_cpuinit.setup_percpu_clockev = x86_init_noop;
>> -
>> -     x86_platform.calibrate_tsc = xen_tsc_khz;
>> -     x86_platform.get_wallclock = xen_get_wallclock;
>> -     x86_platform.set_wallclock = xen_set_wallclock;
>> +     xen_init_time_ops();
>>
>>       /*
>>        * Set up some pagetable state before starting to set any ptes.
>> @@ -1330,4 +1319,5 @@ void __init xen_hvm_guest_init(void)
>>       register_cpu_notifier(&xen_hvm_cpu_notifier);
>>       have_vcpu_info_placement = 0;
>>       x86_init.irqs.intr_init = xen_init_IRQ;
>> +     xen_hvm_init_time_ops();
>>  }
>> diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
>> index 6ff9665..0774c67 100644
>> --- a/arch/x86/xen/suspend.c
>> +++ b/arch/x86/xen/suspend.c
>> @@ -28,8 +28,12 @@ void xen_pre_suspend(void)
>>
>>  void xen_hvm_post_suspend(int suspend_cancelled)
>>  {
>> +     int cpu;
>>       xen_hvm_init_shared_info();
>>       xen_callback_vector();
>> +     for_each_online_cpu(cpu) {
>> +             xen_setup_runstate_info(cpu);
>> +     }
>>  }
>>
>
> As I found out on older xen (non 'modern Xen version' ;-) )
> w/o XENFEAT_hvm_safe_pvclock, the above patch should look like:
>
>        if (xen_feature(XENFEAT_hvm_safe_pvclock)) {
>                int cpu;
>                for_each_online_cpu(cpu) {
>                        xen_setup_runstate_info(cpu);
>                }
>        }
>

Thank you for testing my series and for the patch, I'll include it in
the next version.
