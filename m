Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab0DHTB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:01:29 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:64098 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab0DHTBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:01:24 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>, David.Woodhouse@intel.com
Cc: fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/6] pci/dmar: Print out iommu seq_id
Date: Thu,  8 Apr 2010 11:58:23 -0700
Message-Id: <1270753107-15881-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BBE27DF.00F0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

more info on system with more than one IOMMU

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/dmar.c           |    3 ++-
 drivers/pci/intel-iommu.c    |    9 ++++++---
 drivers/pci/intr_remapping.c |    6 +++---
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 3bd013f..d2f66a6 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -810,7 +810,8 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	}
 
 	ver = readl(iommu->reg + DMAR_VER_REG);
-	pr_info("IOMMU %llx: ver %d:%d cap %llx ecap %llx\n",
+	pr_info("IOMMU %d: reg_base_addr %llx ver %d:%d cap %llx ecap %llx\n",
+		iommu->seq_id,
 		(unsigned long long)drhd->reg_base_addr,
 		DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
 		(unsigned long long)iommu->cap,
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 4173125..83ac214 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1154,7 +1154,8 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	unsigned long nlongs;
 
 	ndomains = cap_ndoms(iommu->cap);
-	pr_debug("Number of Domains supportd <%ld>\n", ndomains);
+	pr_debug("IOMMU %d: Number of Domains supportd <%ld>\n", iommu->seq_id,
+			ndomains);
 	nlongs = BITS_TO_LONGS(ndomains);
 
 	spin_lock_init(&iommu->lock);
@@ -2333,14 +2334,16 @@ int __init init_dmars(void)
 			 */
 			iommu->flush.flush_context = __iommu_flush_context;
 			iommu->flush.flush_iotlb = __iommu_flush_iotlb;
-			printk(KERN_INFO "IOMMU 0x%Lx: using Register based "
+			printk(KERN_INFO "IOMMU %d 0x%Lx: using Register based "
 			       "invalidation\n",
+				iommu->seq_id,
 			       (unsigned long long)drhd->reg_base_addr);
 		} else {
 			iommu->flush.flush_context = qi_flush_context;
 			iommu->flush.flush_iotlb = qi_flush_iotlb;
-			printk(KERN_INFO "IOMMU 0x%Lx: using Queued "
+			printk(KERN_INFO "IOMMU %d 0x%Lx: using Queued "
 			       "invalidation\n",
+				iommu->seq_id,
 			       (unsigned long long)drhd->reg_base_addr);
 		}
 	}
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 6ee98a5..1315ac6 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -832,9 +832,9 @@ static int ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
 				return -1;
 			}
 
-			printk(KERN_INFO "IOAPIC id %d under DRHD base"
-			       " 0x%Lx\n", scope->enumeration_id,
-			       drhd->address);
+			printk(KERN_INFO "IOAPIC id %d under DRHD base "
+			       " 0x%Lx IOMMU %d\n", scope->enumeration_id,
+			       drhd->address, iommu->seq_id);
 
 			ir_parse_one_ioapic_scope(scope, iommu);
 		} else if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_HPET) {
-- 
1.6.4.2

