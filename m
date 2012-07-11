Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab2GKNjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:39:22 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:39631
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757631Ab2GKNjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:17 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700LD-01-AXD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/27] iommu/amd: Move informational prinks out of iommu_enable
Date: Wed, 11 Jul 2012 15:38:51 +0200
Message-ID: <1342013952-10174-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function will be called before the PCI subsystem is
initialized. Therefore dev_name doen't work and IOMMU
information can't be printed to the klog as before. Move the
code to print that information to a later point where PCI
initializtion has already happened.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |   44 ++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index fa6ca8b..bcdcaac 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -312,23 +312,6 @@ static void iommu_set_inv_tlb_timeout(struct amd_iommu *iommu, int timeout)
 /* Function to enable the hardware */
 static void iommu_enable(struct amd_iommu *iommu)
 {
-	static const char * const feat_str[] = {
-		"PreF", "PPR", "X2APIC", "NX", "GT", "[5]",
-		"IA", "GA", "HE", "PC", NULL
-	};
-	int i;
-
-	printk(KERN_INFO "AMD-Vi: Enabling IOMMU at %s cap 0x%hx",
-	       dev_name(&iommu->dev->dev), iommu->cap_ptr);
-
-	if (iommu->cap & (1 << IOMMU_CAP_EFR)) {
-		printk(KERN_CONT " extended features: ");
-		for (i = 0; feat_str[i]; ++i)
-			if (iommu_feature(iommu, (1ULL << i)))
-				printk(KERN_CONT " %s", feat_str[i]);
-	}
-	printk(KERN_CONT "\n");
-
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
 
@@ -1096,6 +1079,31 @@ static int iommu_init_pci(struct amd_iommu *iommu)
 	return pci_enable_device(iommu->dev);
 }
 
+static void print_iommu_info(void)
+{
+	static const char * const feat_str[] = {
+		"PreF", "PPR", "X2APIC", "NX", "GT", "[5]",
+		"IA", "GA", "HE", "PC"
+	};
+	struct amd_iommu *iommu;
+
+	for_each_iommu(iommu) {
+		int i;
+
+		pr_info("AMD-Vi: Found IOMMU at %s cap 0x%hx\n",
+			dev_name(&iommu->dev->dev), iommu->cap_ptr);
+
+		if (iommu->cap & (1 << IOMMU_CAP_EFR)) {
+			pr_info("AMD-Vi:  Extended features: ");
+			for (i = 0; ARRAY_SIZE(feat_str); ++i) {
+				if (iommu_feature(iommu, (1ULL << i)))
+					pr_cont(" %s", feat_str[i]);
+			}
+		}
+		pr_cont("\n");
+	}
+}
+
 static int amd_iommu_init_pci(void)
 {
 	struct amd_iommu *iommu;
@@ -1112,6 +1120,8 @@ static int amd_iommu_init_pci(void)
 
 	ret = amd_iommu_init_devices();
 
+	print_iommu_info();
+
 	return ret;
 }
 
-- 
1.7.9.5


