Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1DGNa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:30:26 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:12264
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633Ab1DGNaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:30:20 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAAU8-01-CQG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 9/9] x86/amd-iommu: Flush all internal TLBs when IOMMUs are enabled
Date: Thu, 7 Apr 2011 15:30:04 +0200
Message-ID: <1302183004-4081-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
References: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old code only flushed a DTE or a domain TLB before it is
actually used by the IOMMU driver. While this is efficient
and works when done right it is more likely to introduce new
bugs when changing code (which happened in the past).
This patch adds code to flush all DTEs and all domain TLBs
in each IOMMU right after it is enabled (at boot and after
resume). This reduces the complexity of the driver and makes
it less likely to introduce stale-TLB bugs in the future.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_proto.h |    2 -
 arch/x86/kernel/amd_iommu.c            |   75 ++++++++++++++-----------------
 arch/x86/kernel/amd_iommu_init.c       |   11 ++++-
 3 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index 916bc81..1223c0f 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -24,8 +24,6 @@ struct amd_iommu;
 extern int amd_iommu_init_dma_ops(void);
 extern int amd_iommu_init_passthrough(void);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
-extern void amd_iommu_flush_all_domains(void);
-extern void amd_iommu_flush_all_devices(void);
 extern void amd_iommu_apply_erratum_63(u16 devid);
 extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
 extern int amd_iommu_init_devices(void);
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 3557f22..bcf58ea 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -539,6 +539,40 @@ static int iommu_flush_dte(struct amd_iommu *iommu, u16 devid)
 	return iommu_queue_command(iommu, &cmd);
 }
 
+static void iommu_flush_dte_all(struct amd_iommu *iommu)
+{
+	u32 devid;
+
+	for (devid = 0; devid <= 0xffff; ++devid)
+		iommu_flush_dte(iommu, devid);
+
+	iommu_completion_wait(iommu);
+}
+
+/*
+ * This function uses heavy locking and may disable irqs for some time. But
+ * this is no issue because it is only called during resume.
+ */
+static void iommu_flush_tlb_all(struct amd_iommu *iommu)
+{
+	u32 dom_id;
+
+	for (dom_id = 0; dom_id <= 0xffff; ++dom_id) {
+		struct iommu_cmd cmd;
+		build_inv_iommu_pages(&cmd, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
+				      dom_id, 1);
+		iommu_queue_command(iommu, &cmd);
+	}
+
+	iommu_completion_wait(iommu);
+}
+
+void iommu_flush_all_caches(struct amd_iommu *iommu)
+{
+	iommu_flush_dte_all(iommu);
+	iommu_flush_tlb_all(iommu);
+}
+
 /*
  * Command send function for invalidating a device table entry
  */
@@ -631,47 +665,6 @@ static void domain_flush_devices(struct protection_domain *domain)
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
 
-static void iommu_flush_all_domain_devices(void)
-{
-	struct protection_domain *domain;
-	unsigned long flags;
-
-	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
-
-	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
-		domain_flush_devices(domain);
-		domain_flush_complete(domain);
-	}
-
-	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
-}
-
-void amd_iommu_flush_all_devices(void)
-{
-	iommu_flush_all_domain_devices();
-}
-
-/*
- * This function uses heavy locking and may disable irqs for some time. But
- * this is no issue because it is only called during resume.
- */
-void amd_iommu_flush_all_domains(void)
-{
-	struct protection_domain *domain;
-	unsigned long flags;
-
-	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
-
-	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
-		spin_lock(&domain->lock);
-		domain_flush_tlb_pde(domain);
-		domain_flush_complete(domain);
-		spin_unlock(&domain->lock);
-	}
-
-	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
-}
-
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 246d727..8848dda 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -180,6 +180,12 @@ static u32 dev_table_size;	/* size of the device table */
 static u32 alias_table_size;	/* size of the alias table */
 static u32 rlookup_table_size;	/* size if the rlookup table */
 
+/*
+ * This function flushes all internal caches of
+ * the IOMMU used by this driver.
+ */
+extern void iommu_flush_all_caches(struct amd_iommu *iommu);
+
 static inline void update_last_devid(u16 devid)
 {
 	if (devid > amd_iommu_last_bdf)
@@ -1244,6 +1250,7 @@ static void enable_iommus(void)
 		iommu_set_exclusion_range(iommu);
 		iommu_init_msi(iommu);
 		iommu_enable(iommu);
+		iommu_flush_all_caches(iommu);
 	}
 }
 
@@ -1274,8 +1281,8 @@ static void amd_iommu_resume(void)
 	 * we have to flush after the IOMMUs are enabled because a
 	 * disabled IOMMU will never execute the commands we send
 	 */
-	amd_iommu_flush_all_devices();
-	amd_iommu_flush_all_domains();
+	for_each_iommu(iommu)
+		iommu_flush_all_caches(iommu);
 }
 
 static int amd_iommu_suspend(void)
-- 
1.7.1


