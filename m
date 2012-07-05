Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab2GEMqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:46:16 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:51562
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932439Ab2GEMhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:01 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPF-02-6NH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/28] iommu/amd: Introduce early_amd_iommu_init routine
Date: Thu, 5 Jul 2012 14:36:27 +0200
Message-ID: <1341491808-23083-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the code to parse the ACPI table and setup
relevant data structures into a new function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c      |    1 -
 drivers/iommu/amd_iommu_init.c |   38 +++++++++++++++++++++++---------------
 2 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a2e418c..cfa01c4 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -382,7 +382,6 @@ DECLARE_STATS_COUNTER(invalidate_iotlb);
 DECLARE_STATS_COUNTER(invalidate_iotlb_all);
 DECLARE_STATS_COUNTER(pri_requests);
 
-
 static struct dentry *stats_dir;
 static struct dentry *de_fflush;
 
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index e6782fa..1b23235 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1494,17 +1494,14 @@ static void __init free_on_init_error(void)
  * After everything is set up the IOMMUs are enabled and the necessary
  * hotplug and suspend notifiers are registered.
  */
-int __init amd_iommu_init_hardware(void)
+static int __init early_amd_iommu_init(void)
 {
 	struct acpi_table_header *ivrs_base;
 	acpi_size ivrs_size;
 	acpi_status status;
 	int i, ret = 0;
 
-	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
-		return -ENODEV;
-
-	if (amd_iommu_disabled || !amd_iommu_detected)
+	if (!amd_iommu_detected)
 		return -ENODEV;
 
 	if (amd_iommu_dev_table != NULL) {
@@ -1591,16 +1588,6 @@ int __init amd_iommu_init_hardware(void)
 	if (ret)
 		goto free;
 
-	ret = amd_iommu_init_pci();
-	if (ret)
-		goto free;
-
-	enable_iommus();
-
-	amd_iommu_init_notifier();
-
-	register_syscore_ops(&amd_iommu_syscore_ops);
-
 out:
 	/* Don't leak any ACPI memory */
 	early_acpi_os_unmap_memory((char *)ivrs_base, ivrs_size);
@@ -1614,6 +1601,27 @@ free:
 	goto out;
 }
 
+int amd_iommu_init_hardware(void)
+{
+	int ret = 0;
+
+	ret = early_amd_iommu_init();
+	if (ret)
+		return ret;
+
+	ret = amd_iommu_init_pci();
+	if (ret)
+		return ret;
+
+	enable_iommus();
+
+	amd_iommu_init_notifier();
+
+	register_syscore_ops(&amd_iommu_syscore_ops);
+
+	return ret;
+}
+
 static int amd_iommu_enable_interrupts(void)
 {
 	struct amd_iommu *iommu;
-- 
1.7.9.5


