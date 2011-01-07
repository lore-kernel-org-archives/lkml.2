Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1AGCgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:36:10 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13381 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1AGCf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:35:29 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/6] MIPS: Octeon: Enable per-CPU IRQs on all CPUs.
Date: Thu,  6 Jan 2011 18:35:02 -0800
Message-Id: <1294367707-2593-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>
References: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 07 Jan 2011 02:35:29.0376 (UTC) FILETIME=[8C6D0E00:01CBAE13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot use on_each_cpu() from low-level irq code, as it ends up
being run with interrupts disabled (a no-no).  Instead use some direct
IPI message bits to enable and disable the MIPS CPU interrupts.

Also, enable the irq on all CPUs for MIPS CPU interrupts.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/cavium-octeon/octeon-irq.c |   30 +++++++++++++++++++++++++++---
 arch/mips/cavium-octeon/smp.c        |   10 ++++++++++
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index ce7500c..023cf04 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -56,7 +56,7 @@ static void octeon_irq_core_eoi(unsigned int irq)
 	set_c0_status(0x100 << bit);
 }
 
-static void octeon_irq_core_enable(unsigned int irq)
+static void octeon_irq_core_enable_local(unsigned int irq)
 {
 	unsigned long flags;
 	unsigned int bit = irq - OCTEON_IRQ_SW0;
@@ -83,16 +83,40 @@ static void octeon_irq_core_disable_local(unsigned int irq)
 	local_irq_restore(flags);
 }
 
+extern void octeon_send_ipi_single(int cpu, unsigned int action);
+
 static void octeon_irq_core_disable(unsigned int irq)
 {
 #ifdef CONFIG_SMP
-	on_each_cpu((void (*)(void *)) octeon_irq_core_disable_local,
-		    (void *) (long) irq, 1);
+	unsigned int bit = irq - OCTEON_IRQ_SW0;
+	int cpu;
+	for_each_online_cpu(cpu) {
+		if (cpu == smp_processor_id())
+			octeon_irq_core_disable_local(irq);
+		else
+			octeon_send_ipi_single(cpu, 0x100 << bit);
+	}
 #else
 	octeon_irq_core_disable_local(irq);
 #endif
 }
 
+static void octeon_irq_core_enable(unsigned int irq)
+{
+#ifdef CONFIG_SMP
+	unsigned int bit = irq - OCTEON_IRQ_SW0;
+	int cpu;
+	for_each_online_cpu(cpu) {
+		if (cpu == smp_processor_id())
+			octeon_irq_core_enable_local(irq);
+		else
+			octeon_send_ipi_single(cpu, 0x10000 << bit);
+	}
+#else
+	octeon_irq_core_enable_local(irq);
+#endif
+}
+
 static struct irq_chip octeon_irq_chip_core = {
 	.name = "Core",
 	.enable = octeon_irq_core_enable,
diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index 391cefe..92d819b 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -48,6 +48,16 @@ static irqreturn_t mailbox_interrupt(int irq, void *dev_id)
 	/* Check if we've been told to flush the icache */
 	if (action & SMP_ICACHE_FLUSH)
 		asm volatile ("synci 0($0)\n");
+	if (action & 0xff00) {
+		/* Disable MIPS CPU irq*/
+		unsigned int mask = action & 0xff00;
+		clear_c0_status(mask);
+	}
+	if (action & 0xff0000) {
+		/* Enable MIPS CPU irq*/
+		unsigned int mask = (action >> 8) & 0xff00;
+		set_c0_status(mask);
+	}
 	return IRQ_HANDLED;
 }
 
-- 
1.7.2.3

