Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab0DGMsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:48:04 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:20567 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab0DGMr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:47:59 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i87h6bh2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJK-02-96G-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/12] x86/amd-iommu: Protect IOMMU-API map/unmap path
Date: Wed, 7 Apr 2010 14:46:39 +0200
Message-ID: <1270644409-10123-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:55.0773 (UTC) FILETIME=[679FBCD0:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a mutex to lock page table updates in
the IOMMU-API path. We can't use the spin_lock here because
this patch might sleep.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 ++
 arch/x86/kernel/amd_iommu.c            |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index ba19ad4..5e46e78 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -21,6 +21,7 @@
 #define _ASM_X86_AMD_IOMMU_TYPES_H
 
 #include <linux/types.h>
+#include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
@@ -237,6 +238,7 @@ struct protection_domain {
 	struct list_head list;  /* for list of all protection domains */
 	struct list_head dev_list; /* List of all devices in this domain */
 	spinlock_t lock;	/* mostly used to lock the page table*/
+	struct mutex api_lock;	/* protect page tables in the iommu-api path */
 	u16 id;			/* the domain id written to the device table */
 	int mode;		/* paging mode (0-6 levels) */
 	u64 *pt_root;		/* page table root pointer */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 2c4a501..b97f2f1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2327,6 +2327,7 @@ static struct protection_domain *protection_domain_alloc(void)
 		return NULL;
 
 	spin_lock_init(&domain->lock);
+	mutex_init(&domain->api_lock);
 	domain->id = domain_id_alloc();
 	if (!domain->id)
 		goto out_err;
@@ -2456,6 +2457,8 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 	iova  &= PAGE_MASK;
 	paddr &= PAGE_MASK;
 
+	mutex_lock(&domain->api_lock);
+
 	for (i = 0; i < npages; ++i) {
 		ret = iommu_map_page(domain, iova, paddr, prot, PM_MAP_4k);
 		if (ret)
@@ -2465,6 +2468,8 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 		paddr += PAGE_SIZE;
 	}
 
+	mutex_unlock(&domain->api_lock);
+
 	return 0;
 }
 
@@ -2477,12 +2482,16 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 
 	iova  &= PAGE_MASK;
 
+	mutex_lock(&domain->api_lock);
+
 	for (i = 0; i < npages; ++i) {
 		iommu_unmap_page(domain, iova, PM_MAP_4k);
 		iova  += PAGE_SIZE;
 	}
 
 	iommu_flush_tlb_pde(domain);
+
+	mutex_unlock(&domain->api_lock);
 }
 
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
-- 
1.7.0.4


