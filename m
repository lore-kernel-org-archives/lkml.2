Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab2FAJPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:15:52 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:35084 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131Ab2FAJNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:13:41 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 11/27] sh, smpboot: Use generic SMP booting infrastructure
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org
Date: Fri, 01 Jun 2012 14:42:43 +0530
Message-ID: <20120601091238.31979.80347.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060109-2674-0000-0000-000004C07F4C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert sh to use the generic framework to boot secondary CPUs.

Notes:
Postpone enabling local interrupts to after completing bringup of
secondary CPU.

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/sh/kernel/smp.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 8e0fde0..d7f7faf 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -179,6 +179,11 @@ void native_play_dead(void)
 
 asmlinkage void __cpuinit start_secondary(void)
 {
+	smpboot_start_secondary(NULL);
+}
+
+void __cpuinit __cpu_pre_starting(void *unused)
+{
 	unsigned int cpu = smp_processor_id();
 	struct mm_struct *mm = &init_mm;
 
@@ -190,23 +195,17 @@ asmlinkage void __cpuinit start_secondary(void)
 	local_flush_tlb_all();
 
 	per_cpu_trap_init();
+}
 
-	preempt_disable();
-
-	notify_cpu_starting(cpu);
-
-	local_irq_enable();
+void __cpuinit __cpu_pre_online(void *unused)
+{
+	unsigned int cpu = smp_processor_id();
 
 	/* Enable local timers */
 	local_timer_setup(cpu);
 	calibrate_delay();
 
 	smp_store_cpu_info(cpu);
-
-	set_cpu_online(cpu, true);
-	per_cpu(cpu_state, cpu) = CPU_ONLINE;
-
-	cpu_idle();
 }
 
 extern struct {

