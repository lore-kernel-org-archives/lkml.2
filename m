Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab2KZWpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:45:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:34358 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203Ab2KZWpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:45:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,323,1352102400"; 
   d="scan'208";a="252850199"
Subject: [patch] x86, apic: cleanup cfg->domain setup for legacy interrupts
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, bp@alien8.de,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 26 Nov 2012 14:49:36 -0800
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1353970176.21070.51.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Had this cleanup patch (tested before by me and Boris aswell) for a
while. Forgot to post this earlier. Thanks.
---8<---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, apic: cleanup cfg->domain setup for legacy interrupts

Issues that need to be handled:
* Handle PIC interrupts on any CPU irrespective of the apic mode
* In the apic lowest priority logical flat delivery mode, be prepared to
  handle the interrupt on any CPU irrespective of what the IO-APIC RTE says.
* Because of above, when the IO-APIC starts handling the legacy PIC interrupt,
  use the same vector that is being used by the PIC while programming the
  corresponding IO-APIC RTE.

Start with all the cpu's in the legacy PIC interrupts cfg->domain.

By the time IO-APIC starts taking over the PIC interrupts, apic driver
model is finalized. So depend on the assign_irq_vector() to update the
cfg->domain and retain the same vector that was used by PIC before.

For the logical apic flat mode, cfg->domain is updated (during the first
call to assign_irq_vector()) to contain all the possible online cpu's (0xff).
Vector used for the legacy PIC interrupt doesn't change when the IO-APIC
starts handling the interrupt. Any interrupt migration after that
doesn't change the cfg->domain or the vector used.

For other apic modes like physical mode, cfg->domain is updated
(during the first call to assign_irq_vector()) to the boot cpu (cpu-0),
with the same vector that is being used by the PIC. When that interrupt is
migrated to a different cpu, cfg->domin and the vector assigned will change
accordingly.

Tested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c265593..0c1f366 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -234,11 +234,11 @@ int __init arch_early_irq_init(void)
 		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_KERNEL, node);
 		/*
 		 * For legacy IRQ's, start with assigning irq0 to irq15 to
-		 * IRQ0_VECTOR to IRQ15_VECTOR on cpu 0.
+		 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
 		 */
 		if (i < legacy_pic->nr_legacy_irqs) {
 			cfg[i].vector = IRQ0_VECTOR + i;
-			cpumask_set_cpu(0, cfg[i].domain);
+			cpumask_setall(cfg[i].domain);
 		}
 	}
 
@@ -1141,7 +1141,8 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 			 * allocation for the members that are not used anymore.
 			 */
 			cpumask_andnot(cfg->old_domain, cfg->domain, tmp_mask);
-			cfg->move_in_progress = 1;
+			cfg->move_in_progress =
+			   cpumask_intersects(cfg->old_domain, cpu_online_mask);
 			cpumask_and(cfg->domain, cfg->domain, tmp_mask);
 			break;
 		}
@@ -1172,8 +1173,9 @@ next:
 		current_vector = vector;
 		current_offset = offset;
 		if (cfg->vector) {
-			cfg->move_in_progress = 1;
 			cpumask_copy(cfg->old_domain, cfg->domain);
+			cfg->move_in_progress =
+			   cpumask_intersects(cfg->old_domain, cpu_online_mask);
 		}
 		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
@@ -1241,12 +1243,6 @@ void __setup_vector_irq(int cpu)
 		cfg = irq_get_chip_data(irq);
 		if (!cfg)
 			continue;
-		/*
-		 * If it is a legacy IRQ handled by the legacy PIC, this cpu
-		 * will be part of the irq_cfg's domain.
-		 */
-		if (irq < legacy_pic->nr_legacy_irqs && !IO_APIC_IRQ(irq))
-			cpumask_set_cpu(cpu, cfg->domain);
 
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			continue;
@@ -1356,16 +1352,6 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	if (!IO_APIC_IRQ(irq))
 		return;
 
-	/*
-	 * For legacy irqs, cfg->domain starts with cpu 0. Now that IO-APIC
-	 * can handle this irq and the apic driver is finialized at this point,
-	 * update the cfg->domain.
-	 */
-	if (irq < legacy_pic->nr_legacy_irqs &&
-	    cpumask_equal(cfg->domain, cpumask_of(0)))
-		apic->vector_allocation_domain(0, cfg->domain,
-					       apic->target_cpus());
-
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 


