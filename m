Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2HTN6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:58:50 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:53207
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429Ab2HTN4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:56:21 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M9241I-02-F0K-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/19] x86, apic: Move irq_remapping_enabled checks into IRQ-remapping code
Date: Mon, 20 Aug 2012 15:55:47 +0200
Message-ID: <1345470965-24410-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the three easy to move checks in the x86' apic.c file
into the IRQ-remapping code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/apic/apic.c   |    9 +++------
 drivers/iommu/irq_remapping.c |   11 +++++++++--
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 24deb30..41681b3 100644
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
index 151690d..283a43f 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -82,7 +82,9 @@ int __init irq_remapping_enable(void)
 
 void irq_remapping_disable(void)
 {
-	if (!remap_ops || !remap_ops->disable)
+	if (!irq_remapping_enabled ||
+	    !remap_ops ||
+	    !remap_ops->disable)
 		return;
 
 	remap_ops->disable();
@@ -90,7 +92,9 @@ void irq_remapping_disable(void)
 
 int irq_remapping_reenable(int mode)
 {
-	if (!remap_ops || !remap_ops->reenable)
+	if (!irq_remapping_enabled ||
+	    !remap_ops ||
+	    !remap_ops->reenable)
 		return 0;
 
 	return remap_ops->reenable(mode);
@@ -98,6 +102,9 @@ int irq_remapping_reenable(int mode)
 
 int __init irq_remap_enable_fault_handling(void)
 {
+	if (!irq_remapping_enabled)
+		return 0;
+
 	if (!remap_ops || !remap_ops->enable_faulting)
 		return -ENODEV;
 
-- 
1.7.9.5


