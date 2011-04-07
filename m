Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab1DGNab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:30:31 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:55769
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527Ab1DGNaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:30:18 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAAU7-01-CQE-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/9] x86/amd-iommu: Rename iommu_flush_device
Date: Thu, 7 Apr 2011 15:30:03 +0200
Message-ID: <1302183004-4081-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
References: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function operates on a struct device, so give it a name
that represents that. As a side effect a new function is
introduced which operates on am iommu and a device-id. It
will be used again in a later patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 75c7f8c..3557f22 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -530,21 +530,27 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	return wait_on_sem(&sem);
 }
 
+static int iommu_flush_dte(struct amd_iommu *iommu, u16 devid)
+{
+	struct iommu_cmd cmd;
+
+	build_inv_dte(&cmd, devid);
+
+	return iommu_queue_command(iommu, &cmd);
+}
+
 /*
  * Command send function for invalidating a device table entry
  */
-static int iommu_flush_device(struct device *dev)
+static int device_flush_dte(struct device *dev)
 {
 	struct amd_iommu *iommu;
-	struct iommu_cmd cmd;
 	u16 devid;
 
 	devid = get_device_id(dev);
 	iommu = amd_iommu_rlookup_table[devid];
 
-	build_inv_dte(&cmd, devid);
-
-	return iommu_queue_command(iommu, &cmd);
+	return iommu_flush_dte(iommu, devid);
 }
 
 /*
@@ -620,7 +626,7 @@ static void domain_flush_devices(struct protection_domain *domain)
 	spin_lock_irqsave(&domain->lock, flags);
 
 	list_for_each_entry(dev_data, &domain->dev_list, list)
-		iommu_flush_device(dev_data->dev);
+		device_flush_dte(dev_data->dev);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -1424,7 +1430,7 @@ static void do_attach(struct device *dev, struct protection_domain *domain)
 	domain->dev_cnt                 += 1;
 
 	/* Flush the DTE entry */
-	iommu_flush_device(dev);
+	device_flush_dte(dev);
 }
 
 static void do_detach(struct device *dev)
@@ -1447,7 +1453,7 @@ static void do_detach(struct device *dev)
 	clear_dte_entry(devid);
 
 	/* Flush the DTE entry */
-	iommu_flush_device(dev);
+	device_flush_dte(dev);
 }
 
 /*
@@ -1663,7 +1669,7 @@ static int device_change_notifier(struct notifier_block *nb,
 		goto out;
 	}
 
-	iommu_flush_device(dev);
+	device_flush_dte(dev);
 	iommu_completion_wait(iommu);
 
 out:
@@ -2448,7 +2454,7 @@ static void amd_iommu_detach_device(struct iommu_domain *dom,
 	if (!iommu)
 		return;
 
-	iommu_flush_device(dev);
+	device_flush_dte(dev);
 	iommu_completion_wait(iommu);
 }
 
-- 
1.7.1


