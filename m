Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab1LENfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:35:23 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:53447
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932416Ab1LENfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:17 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGEK-01-IQ4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/22] iommu/amd: Add stat counter for IOMMUv2 events
Date: Mon, 5 Dec 2011 14:34:31 +0100
Message-ID: <1323092077-25501-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some interesting statistic counters for events when
IOMMUv2 is active.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 7bd1565..88b16c0 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -359,6 +359,11 @@ DECLARE_STATS_COUNTER(domain_flush_single);
 DECLARE_STATS_COUNTER(domain_flush_all);
 DECLARE_STATS_COUNTER(alloced_io_mem);
 DECLARE_STATS_COUNTER(total_map_requests);
+DECLARE_STATS_COUNTER(complete_ppr);
+DECLARE_STATS_COUNTER(invalidate_iotlb);
+DECLARE_STATS_COUNTER(invalidate_iotlb_all);
+DECLARE_STATS_COUNTER(pri_requests);
+
 
 static struct dentry *stats_dir;
 static struct dentry *de_fflush;
@@ -393,6 +398,10 @@ static void amd_iommu_stats_init(void)
 	amd_iommu_stats_add(&domain_flush_all);
 	amd_iommu_stats_add(&alloced_io_mem);
 	amd_iommu_stats_add(&total_map_requests);
+	amd_iommu_stats_add(&complete_ppr);
+	amd_iommu_stats_add(&invalidate_iotlb);
+	amd_iommu_stats_add(&invalidate_iotlb_all);
+	amd_iommu_stats_add(&pri_requests);
 }
 
 #endif
@@ -509,6 +518,8 @@ static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u32 head)
 	volatile u64 *raw;
 	int i;
 
+	INC_STATS_COUNTER(pri_requests);
+
 	raw = (u64 *)(iommu->ppr_log + head);
 
 	/*
@@ -3356,6 +3367,8 @@ out:
 static int __amd_iommu_flush_page(struct protection_domain *domain, int pasid,
 				  u64 address)
 {
+	INC_STATS_COUNTER(invalidate_iotlb);
+
 	return __flush_pasid(domain, pasid, address, false);
 }
 
@@ -3376,6 +3389,8 @@ EXPORT_SYMBOL(amd_iommu_flush_page);
 
 static int __amd_iommu_flush_tlb(struct protection_domain *domain, int pasid)
 {
+	INC_STATS_COUNTER(invalidate_iotlb_all);
+
 	return __flush_pasid(domain, pasid, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
 			     true);
 }
@@ -3495,6 +3510,8 @@ int amd_iommu_complete_ppr(struct pci_dev *pdev, int pasid,
 	struct amd_iommu *iommu;
 	struct iommu_cmd cmd;
 
+	INC_STATS_COUNTER(complete_ppr);
+
 	dev_data = get_dev_data(&pdev->dev);
 	iommu    = amd_iommu_rlookup_table[dev_data->devid];
 
-- 
1.7.5.4


