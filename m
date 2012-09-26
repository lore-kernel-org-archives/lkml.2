Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2IZOri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:47:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:25317 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab2IZOrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:47:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,490,1344236400"; 
   d="scan'208";a="198097347"
Subject: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the irq
 affinity mask
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        chuansheng.liu@intel.com
In-Reply-To: <1348681092.19514.10.camel@cliu38-desktop-build>
References: <1348681092.19514.10.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Sep 2012 07:45:22 +0800
Message-ID: <1348703122.19514.17.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When one CPU is going offline, and fixup_irqs() will re-set the
irq affinity in some cases, we should clean the offlining CPU from
the irq affinity.

The reason is setting offlining CPU as of the affinity is useless.
Moreover, the smp_affinity value will be confusing when the
offlining CPU come back again.

Example:
For irq 93 with 4 CPUS, the default affinity f(1111),
normal cases: 4 CPUS will receive the irq93 interrupts.

When echo 0 > /sys/devices/system/cpu/cpu3/online, just CPU0,1,2 will
receive the interrupts.

But after the CPU3 is online again, we will not set affinity,the result
will be:
the smp_affinity is f, but still just CPU0,1,2 can receive the interrupts.

So we should clean the offlining CPU from irq affinity mask
in fixup_irqs().

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/irq.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d44f782..ead0807 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -239,10 +239,13 @@ void fixup_irqs(void)
 	struct irq_desc *desc;
 	struct irq_data *data;
 	struct irq_chip *chip;
+	int cpu = smp_processor_id();
 
 	for_each_irq_desc(irq, desc) {
 		int break_affinity = 0;
 		int set_affinity = 1;
+		bool set_ret = false;
+
 		const struct cpumask *affinity;
 
 		if (!desc)
@@ -256,7 +259,8 @@ void fixup_irqs(void)
 		data = irq_desc_get_irq_data(desc);
 		affinity = data->affinity;
 		if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
-		    cpumask_subset(affinity, cpu_online_mask)) {
+		    cpumask_subset(affinity, cpu_online_mask) ||
+		    !cpumask_test_cpu(cpu, data->affinity)) {
 			raw_spin_unlock(&desc->lock);
 			continue;
 		}
@@ -277,9 +281,18 @@ void fixup_irqs(void)
 		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
 			chip->irq_mask(data);
 
-		if (chip->irq_set_affinity)
-			chip->irq_set_affinity(data, affinity, true);
-		else if (!(warned++))
+		if (chip->irq_set_affinity) {
+			struct cpumask mask;
+			cpumask_copy(&mask, affinity);
+			cpumask_clear_cpu(cpu, &mask);
+			switch (chip->irq_set_affinity(data, &mask, true)) {
+			case IRQ_SET_MASK_OK:
+				cpumask_copy(data->affinity, &mask);
+			case IRQ_SET_MASK_OK_NOCOPY:
+				set_ret = true;
+			}
+		}
+		if ((!set_ret) && !(warned++))
 			set_affinity = 0;
 
 		/*
-- 
1.7.0.4



