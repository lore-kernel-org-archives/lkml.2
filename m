Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030213Ab2CPGYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 02:24:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:59928 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab2CPGYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 02:24:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="78254193"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Topic: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Index: AQHNApjzi0/xEwnEYkaFcv+3MH+BBZZscbWQ
Date: Fri, 16 Mar 2012 06:24:05 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
 <1331808391.18960.160.camel@twins>
In-Reply-To: <1331808391.18960.160.camel@twins>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Thursday, March 15, 2012 6:47 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de
> Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
> 
> On Thu, 2012-03-15 at 00:11 +0000, Liu, Chuansheng wrote:
> >
> > > -----Original Message-----
> > > From: Peter Zijlstra [mailto:peterz@infradead.org]
> > > Sent: Wednesday, March 14, 2012 5:43 PM
> > > To: Liu, Chuansheng
> > > Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de
> > > Subject: RE: [PATCH] Fix the race between smp_call_function and CPU
> > > booting
> > >
> > > On Wed, 2012-03-14 at 06:27 +0000, Liu, Chuansheng wrote:
> > > > On the unplug case, after set the CPU to !active, we do not need
> > > > IPI handling for the corresponding CPU before it is set to
> > > > offline. I did not find any impact that limiting the
> > > > smp_call_function just after CPU is active.
> > >
> > > Have a look at Alpha, it's flush_tlb_mm() can use
> > > smp_call_function(), in the !active,online case you very much still need to
> tlb flush that cpu.
> > >
> > > The fact that it works on a limited use case on x86 doesn't say
> > > anything much at all.
> 
> > Thanks your pointing out, do you have any other perfect solution for this
> issue?
> > As for the stress test result, advancing the setting active before
> > setting online broken something either.
> 
> I'm not sure I understand.. are you saying that commit
> 5fbd036b552f633abb394a319f7c62a5c86a9cd7 in tip/master broke
> something?
Yes. I did the stress test, the commit 5fbd036b552f633abb394a319f7c62a5c86a9cd7
broken something as below traces:
[  721.989553] WARNING: at /root/r3_ics/hardware/intel/linux-2.6/arch/x86/kernel/smp.c:118 native_smp_send_reschedule+0x50/0x60()
[  722.000923] Hardware name: Medfield
[  722.004401] Modules linked in: atomisp lm3554 mt9m114 mt9e013 videobuf_vmalloc videobuf_core mac80211 cfg80211 compat btwilink st_drv
[  722.016408] Pid: 18865, comm: workqueue_trust Not tainted 3.0.8-137166-g2639a16-dirty #1
[  722.024486] Call Trace:
[  722.026939]  [<c1252287>] warn_slowpath_common+0x77/0x130
[  722.032321]  [<c121df70>] ? native_smp_send_reschedule+0x50/0x60
[  722.038314]  [<c121df70>] ? native_smp_send_reschedule+0x50/0x60
[  722.044316]  [<c1252362>] warn_slowpath_null+0x22/0x30
[  722.049445]  [<c121df70>] native_smp_send_reschedule+0x50/0x60
[  722.055268]  [<c124bacf>] try_to_wake_up+0x17f/0x390
[  722.060225]  [<c124bd34>] wake_up_process+0x14/0x20
[  722.065091]  [<c1277107>] kthread_stop+0x37/0x100
[  722.069789]  [<c126f5e0>] destroy_worker+0x50/0x90
[  722.074573]  [<c18c1b4d>] trustee_thread+0x3e3/0x4bf
[  722.079524]  [<c1277410>] ? wake_up_bit+0x90/0x90
[  722.084224]  [<c18c176a>] ? wait_trustee_state+0x91/0x91
[  722.089520]  [<c1276fc4>] kthread+0x74/0x80
[  722.093694]  [<c1276f50>] ? __init_kthread_worker+0x30/0x30
[  722.099264]  [<c18c7cfa>] kernel_thread_helper+0x6/0x10
[  722.104474] ---[ end trace fa5bcc15ece677c6 ]---


Based on your patch, I did a little modification, how do you think of that?
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index cdeb727..d616ed5 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -295,13 +295,6 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
         */
        percpu_timer_setup();
 
-       while (!cpu_active(cpu))
-               cpu_relax();
-
-       /*
-        * cpu_active bit is set, so it's safe to enalbe interrupts
-        * now.
-        */
        local_irq_enable();
        local_fiq_enable();
 
diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index c871a2c..0123c63 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -179,8 +179,6 @@ void __cpuinit start_secondary(void)
        printk(KERN_INFO "%s cpu %d\n", __func__, current_thread_info()->cpu);
 
        set_cpu_online(cpu, true);
-       while (!cpumask_test_cpu(cpu, cpu_active_mask))
-               cpu_relax();
        local_irq_enable();
 
        cpu_idle();
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 2398ce6..b0e28c4 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -550,12 +550,6 @@ int __cpuinit start_secondary(void *cpuvoid)
        S390_lowcore.restart_psw.addr =
                PSW_ADDR_AMODE | (unsigned long) psw_restart_int_handler;
        __ctl_set_bit(0, 28); /* Enable lowcore protection */
-       /*
-        * Wait until the cpu which brought this one up marked it
-        * active before enabling interrupts.
-        */
-       while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
-               cpu_relax();
        local_irq_enable();
        /* cpu_idle will call schedule for us */
        cpu_idle();
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..58f7816 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -291,19 +291,6 @@ notrace static void __cpuinit start_secondary(void *unused)
        per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
        x86_platform.nmi_init();
 
-       /*
-        * Wait until the cpu which brought this one up marked it
-        * online before enabling interrupts. If we don't do that then
-        * we can end up waking up the softirq thread before this cpu
-        * reached the active state, which makes the scheduler unhappy
-        * and schedule the softirq thread on the wrong cpu. This is
-        * only observable with forced threaded interrupts, but in
-        * theory it could also happen w/o them. It's just way harder
-        * to achieve.
-        */
-       while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
-               cpu_relax();
-
        /* enable local interrupts */
        local_irq_enable();
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2060c6e..6bf1fd3 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -640,8 +640,10 @@ void set_cpu_present(unsigned int cpu, bool present)
 
 void set_cpu_online(unsigned int cpu, bool online)
 {
-       if (online)
+       if (online) {
                cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
+               cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
+       }
        else
                cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b342f57..ef97881 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5381,7 +5381,6 @@ static int __cpuinit sched_cpu_active(struct notifier_block *nfb,
                                      unsigned long action, void *hcpu)
 {
        switch (action & ~CPU_TASKS_FROZEN) {
-       case CPU_ONLINE:
        case CPU_DOWN_FAILED:
                set_cpu_active((long)hcpu, true);
                return NOTIFY_OK;

