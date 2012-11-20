Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2KTNNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:13:13 -0500
Received: from 8bytes.org ([85.214.48.195]:58220 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199Ab2KTNNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:13:06 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 01/19] x86, apic: Move irq_remapping_enabled checks into IRQ-remapping code
Date: Tue, 20 Nov 2012 14:12:38 +0100
Message-Id: <1353417176-18945-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353417176-18945-1-git-send-email-joro@8bytes.org>
References: <1353417176-18945-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Nov 20 14:13:04 2012
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ab81e022975919999284
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the three easy to move checks in the x86' apic.c file
into the IRQ-remapping code.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/apic.c   |    9 +++------
 drivers/iommu/irq_remapping.c |   11 +++++++++--
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b17416e..69cba83 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1444,8 +1444,7 @@ void __init bsp_end_local_APIC_setup(void)
 	 * Now that local APIC setup is completed for BP, configure the fault
 	 * handling for interrupt remapping.
 	 */
-	if (irq_remapping_enabled)
-		irq_remap_enable_fault_handling();
+	irq_remap_enable_fault_handling();
 
 }
 
@@ -2218,8 +2217,7 @@ static int lapic_suspend(void)
 	local_irq_save(flags);
 	disable_local_APIC();
 
-	if (irq_remapping_enabled)
-		irq_remapping_disable();
+	irq_remapping_disable();
 
 	local_irq_restore(flags);
 	return 0;
@@ -2287,8 +2285,7 @@ static void lapic_resume(void)
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
-	if (irq_remapping_enabled)
-		irq_remapping_reenable(x2apic_mode);
+	irq_remapping_reenable(x2apic_mode);
 
 	local_irq_restore(flags);
 }
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index faf85d6..19381b9 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -87,7 +87,9 @@ int __init irq_remapping_enable(void)
 
 void irq_remapping_disable(void)
 {
-	if (!remap_ops || !remap_ops->disable)
+	if (!irq_remapping_enabled ||
+	    !remap_ops ||
+	    !remap_ops->disable)
 		return;
 
 	remap_ops->disable();
@@ -95,7 +97,9 @@ void irq_remapping_disable(void)
 
 int irq_remapping_reenable(int mode)
 {
-	if (!remap_ops || !remap_ops->reenable)
+	if (!irq_remapping_enabled ||
+	    !remap_ops ||
+	    !remap_ops->reenable)
 		return 0;
 
 	return remap_ops->reenable(mode);
@@ -103,6 +107,9 @@ int irq_remapping_reenable(int mode)
 
 int __init irq_remap_enable_fault_handling(void)
 {
+	if (!irq_remapping_enabled)
+		return 0;
+
 	if (!remap_ops || !remap_ops->enable_faulting)
 		return -ENODEV;
 
-- 
1.7.9.5


