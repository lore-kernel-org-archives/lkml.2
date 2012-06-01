Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab2FAJMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:12:36 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:53028 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab2FAJMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:12:33 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 06/27] xen, smpboot: Use generic SMP booting infrastructure
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Fri, 01 Jun 2012 14:41:43 +0530
Message-ID: <20120601091136.31979.36213.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060109-8256-0000-0000-000002C1CB1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert xen to use the generic framework to boot secondary CPUs.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/xen/smp.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 602d6b7..46c96f9 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -58,13 +58,12 @@ static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void __cpuinit cpu_bringup(void)
+void __cpuinit xen_cpu_pre_starting(void *unused)
 {
 	int cpu;
 
 	cpu_init();
 	touch_softlockup_watchdog();
-	preempt_disable();
 
 	xen_enable_sysenter();
 	xen_enable_syscall();
@@ -75,25 +74,11 @@ static void __cpuinit cpu_bringup(void)
 	set_cpu_sibling_map(cpu);
 
 	xen_setup_cpu_clockevents();
-
-	notify_cpu_starting(cpu);
-
-	set_cpu_online(cpu, true);
-
-	this_cpu_write(cpu_state, CPU_ONLINE);
-
-	wmb();
-
-	/* We can take interrupts now: we're officially "up". */
-	local_irq_enable();
-
-	wmb();			/* make sure everything is out */
 }
 
 static void __cpuinit cpu_bringup_and_idle(void)
 {
-	cpu_bringup();
-	cpu_idle();
+	smpboot_start_secondary(NULL);
 }
 
 static int xen_smp_intr_init(unsigned int cpu)
@@ -515,6 +500,8 @@ static const struct smp_ops xen_smp_ops __initconst = {
 	.smp_prepare_cpus = xen_smp_prepare_cpus,
 	.smp_cpus_done = xen_smp_cpus_done,
 
+	.cpu_pre_starting = xen_cpu_pre_starting,
+
 	.cpu_up = xen_cpu_up,
 	.cpu_die = xen_cpu_die,
 	.cpu_disable = xen_cpu_disable,

