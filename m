Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab2KZX5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:57:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44859 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594Ab2KZX5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:57:33 -0500
Date: Mon, 26 Nov 2012 15:57:01 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-29c574c0aba8dc0736e19eb9b24aad28cc5c9098@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        bp@alien8.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, bp@alien8.de,
        hpa@linux.intel.com
In-Reply-To: <1353970176.21070.51.camel@sbsiddha-desk.sc.intel.com>
References: <1353970176.21070.51.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, apic: Cleanup cfg->
 domain setup for legacy interrupts
Git-Commit-ID: 29c574c0aba8dc0736e19eb9b24aad28cc5c9098
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 26 Nov 2012 15:57:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29c574c0aba8dc0736e19eb9b24aad28cc5c9098
Gitweb:     http://git.kernel.org/tip/29c574c0aba8dc0736e19eb9b24aad28cc5c9098
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 26 Nov 2012 14:49:36 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 26 Nov 2012 15:43:25 -0800

x86, apic: Cleanup cfg->domain setup for legacy interrupts

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
Link: http://lkml.kernel.org/r/1353970176.21070.51.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

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
 
