Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab1LOQKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:10:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34419 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758943Ab1LOQK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:10:28 -0500
Message-ID: <1323965362.18942.71.camel@twins>
Subject: Re: Re: [patch] ARM: smpboot: Enable interrupts after marking CPU
 online/active
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dima Zavin <dima@android.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frank Rowand <frank.rowand@am.sony.com>,
        amit kachhap <amit.kachhap@linaro.org>,
        Colin Cross <ccross@android.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        chaos.youn@samsung.com, LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 Dec 2011 17:09:22 +0100
In-Reply-To: <alpine.LFD.2.02.1112140124480.3020@ionos>
References: <20110908215314.829452535@linutronix.de>
	 <CADGdYn6V_eQJZ4=irMbSS7XJj4MJVeALxcrWdD7o2bGs1sEJZQ@mail.gmail.com>
	 <20110913133258.GA6267@n2100.arm.linux.org.uk>
	 <CAKfTPtCWuiOM5+sOwdh1FzXZb1EFT__tVEpRPY5suGOxpYTdQQ@mail.gmail.com>
	 <20110913175312.GB6267@n2100.arm.linux.org.uk>
	 <20110923084001.GP17169@n2100.arm.linux.org.uk>
	 <01d501cc84d6$62720890$275619b0$%kim@samsung.com>
	 <alpine.LFD.2.02.1110071354310.3240@ionos>
	 <CAPz4a6CkOXp6LHX2hFYVBhXWT4rhCUzLyYTLbO7g8u_jYcHt7Q@mail.gmail.com>
	 <CAPz4a6C7md+k8pCz6mJtB-v_1h-faGxQZkOqU9vHUtcG-jrYVQ@mail.gmail.com>
	 <4EC2DF93.2050904@codeaurora.org>
	 <alpine.LFD.2.02.1111152259430.4902@ionos>
	 <CAPz4a6BwzAmE=08pCfhK5of0vEV+uPaf8D-9U_MnW5_vAe6NFw@mail.gmail.com>
	 <alpine.LFD.2.02.1112140124480.3020@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the note that we really should clean up the cpu hotplug code,
there's far too much code duplication in the arch/ implementations. The
below patch looks like it might actually work.

Thomas, others, please have a very close look because I might have
thought too hard and missed the obvious :-)

---
Subject: hotplug, sched: cpu_active vs __cpu_up

Stepan found:

CPU0		CPUn

_cpu_up()
  __cpu_up()

		boostrap()
		  notify_cpu_starting()
		  set_cpu_online()
		  while (!cpu_active())
		    cpu_relax()


<PREEMPT-out>

smp_call_function(.wait=1)
  /* we find cpu_online() is true */
  arch_send_call_function_ipi_mask()

  /* wait-forever-more */

<PREEMPT-in>
		  local_irq_enable()

  cpu_notify(CPU_ONLINE)
    sched_cpu_active()
      set_cpu_active()

Now the purpose of cpu_active is mostly with bringing down a cpu, where
we mark it !active to avoid the load-balancer from moving tasks to it
while we tear down the cpu. This is required because we only update the
sched_domain tree after we brought the cpu-down. And this is needed so
that some tasks can still run while we bring it down, we just don't want
new tasks to appear.

On cpu-up however the sched_domain tree doesn't yet include the new cpu,
so its invisible to the load-balancer, regardless of the active state.
So instead of setting the active state after we boot the new cpu (and
consequently having to wait for it before enabling interrupts) set the
cpu active before we set it online and avoid the whole mess.

Reported-by: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/arm/kernel/smp.c     |    7 -------
 arch/hexagon/kernel/smp.c |    2 --
 arch/s390/kernel/smp.c    |    6 ------
 arch/x86/kernel/smpboot.c |   13 -------------
 kernel/sched/core.c       |    2 +-
 5 files changed, 1 insertion(+), 29 deletions(-)

--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -337,13 +337,6 @@ asmlinkage void __cpuinit secondary_star
 	 */
 	percpu_timer_setup();
 
-	while (!cpu_active(cpu))
-		cpu_relax();
-
-	/*
-	 * cpu_active bit is set, so it's safe to enalbe interrupts
-	 * now.
-	 */
 	local_irq_enable();
 	local_fiq_enable();
 
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -179,8 +179,6 @@ void __cpuinit start_secondary(void)
 	printk(KERN_INFO "%s cpu %d\n", __func__, current_thread_info()->cpu);
 
 	set_cpu_online(cpu, true);
-	while (!cpumask_test_cpu(cpu, cpu_active_mask))
-		cpu_relax();
 	local_irq_enable();
 
 	cpu_idle();
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -518,12 +518,6 @@ int __cpuinit start_secondary(void *cpuv
 	S390_lowcore.restart_psw.addr =
 		PSW_ADDR_AMODE | (unsigned long) psw_restart_int_handler;
 	__ctl_set_bit(0, 28); /* Enable lowcore protection */
-	/*
-	 * Wait until the cpu which brought this one up marked it
-	 * active before enabling interrupts.
-	 */
-	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
-		cpu_relax();
 	local_irq_enable();
 	/* cpu_idle will call schedule for us */
 	cpu_idle();
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -291,19 +291,6 @@ notrace static void __cpuinit start_seco
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	x86_platform.nmi_init();
 
-	/*
-	 * Wait until the cpu which brought this one up marked it
-	 * online before enabling interrupts. If we don't do that then
-	 * we can end up waking up the softirq thread before this cpu
-	 * reached the active state, which makes the scheduler unhappy
-	 * and schedule the softirq thread on the wrong cpu. This is
-	 * only observable with forced threaded interrupts, but in
-	 * theory it could also happen w/o them. It's just way harder
-	 * to achieve.
-	 */
-	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
-		cpu_relax();
-
 	/* enable local interrupts */
 	local_irq_enable();
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5390,7 +5390,7 @@ static int __cpuinit sched_cpu_active(st
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_ONLINE:
+	case CPU_STARTING:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;

