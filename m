Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031746Ab2COQ2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:28:11 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:52123
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031695Ab2COQ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:28:06 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0XPQG-02-PI2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] iommu/amd: Move interrupt setup code into seperate function
Date: Thu, 15 Mar 2012 17:27:44 +0100
Message-ID: <1331828864-25213-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331828864-25213-1-git-send-email-joerg.roedel@amd.com>
References: <1331828864-25213-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For interrupt remapping the enablement of the IOMMU MSI
interrupt needs to be deferred because the IOMMU itself will
be initialized before the io-apics are up and running. So
the code to setup the MSI is moved seperated from the
hardware-setup routine now.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 182b80b..8b026bf 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -196,6 +196,8 @@ static u32 rlookup_table_size;	/* size if the rlookup table */
  */
 extern void iommu_flush_all_caches(struct amd_iommu *iommu);
 
+static int __init amd_iommu_enable_interrupts(void);
+
 static inline void update_last_devid(u16 devid)
 {
 	if (devid > amd_iommu_last_bdf)
@@ -1383,7 +1385,6 @@ static void enable_iommus(void)
 		iommu_enable_ppr_log(iommu);
 		iommu_enable_gt(iommu);
 		iommu_set_exclusion_range(iommu);
-		iommu_init_msi(iommu);
 		iommu_enable(iommu);
 		iommu_flush_all_caches(iommu);
 	}
@@ -1411,6 +1412,8 @@ static void amd_iommu_resume(void)
 
 	/* re-load the hardware */
 	enable_iommus();
+
+	amd_iommu_enable_interrupts();
 }
 
 static int amd_iommu_suspend(void)
@@ -1595,6 +1598,21 @@ free:
 	return ret;
 }
 
+static int __init amd_iommu_enable_interrupts(void)
+{
+	struct amd_iommu *iommu;
+	int ret = 0;
+
+	for_each_iommu(iommu) {
+		ret = iommu_init_msi(iommu);
+		if (ret)
+			goto out;
+	}
+
+out:
+	return ret;
+}
+
 /*
  * This is the core init function for AMD IOMMU hardware in the system.
  * This function is called from the generic x86 DMA layer initialization
@@ -1612,6 +1630,10 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto out;
 
+	ret = amd_iommu_enable_interrupts();
+	if (ret)
+		goto free;
+
 	if (iommu_pass_through)
 		ret = amd_iommu_init_passthrough();
 	else
-- 
1.7.5.4


