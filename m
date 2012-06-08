Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950Ab2FHO4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:56:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59687 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab2FHO43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:56:29 -0400
Date: Fri, 8 Jun 2012 07:56:18 -0700
From: tip-bot for Donald Dutile <ddutile@redhat.com>
Message-ID: <tip-6f5cf52114dd87f9ed091678f7dfc8ff21bbe2b3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        chrisw@redhat.com, ddutile@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        chrisw@redhat.com, ddutile@redhat.com, tglx@linutronix.de
In-Reply-To: <1338845342-12464-3-git-send-email-ddutile@redhat.com>
References: <1338845342-12464-3-git-send-email-ddutile@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] iommu/dmar: Reserve mmio space used by the IOMMU,
  if the BIOS forgets to
Git-Commit-ID: 6f5cf52114dd87f9ed091678f7dfc8ff21bbe2b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 08 Jun 2012 07:56:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f5cf52114dd87f9ed091678f7dfc8ff21bbe2b3
Gitweb:     http://git.kernel.org/tip/6f5cf52114dd87f9ed091678f7dfc8ff21bbe2b3
Author:     Donald Dutile <ddutile@redhat.com>
AuthorDate: Mon, 4 Jun 2012 17:29:02 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Jun 2012 12:15:43 +0200

iommu/dmar: Reserve mmio space used by the IOMMU, if the BIOS forgets to

Intel-iommu initialization doesn't currently reserve the memory
used for the IOMMU registers. This can allow the pci resource
allocator to assign a device BAR to the same address as the
IOMMU registers. This can cause some not so nice side affects
when the driver ioremap's that region.

Introduced two helper functions to map & unmap the IOMMU
registers as well as simplify the init and exit paths.

Signed-off-by: Donald Dutile <ddutile@redhat.com>
Acked-by: Chris Wright <chrisw@redhat.com>
Cc: iommu@lists.linux-foundation.org
Cc: suresh.b.siddha@intel.com
Cc: dwmw2@infradead.org
Link: http://lkml.kernel.org/r/1338845342-12464-3-git-send-email-ddutile@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/iommu/dmar.c        |  111 ++++++++++++++++++++++++++++++++----------
 include/linux/intel-iommu.h |    2 +
 2 files changed, 86 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 1e5a10d..9ab6ebf 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -570,14 +570,89 @@ int __init detect_intel_iommu(void)
 }
 
 
+static void unmap_iommu(struct intel_iommu *iommu)
+{
+	iounmap(iommu->reg);
+	release_mem_region(iommu->reg_phys, iommu->reg_size);
+}
+
+/**
+ * map_iommu: map the iommu's registers
+ * @iommu: the iommu to map
+ * @phys_addr: the physical address of the base resgister
+ * 
+ * Memory map the iommu's registers.  Start w/ a single page, and
+ * possibly expand if that turns out to be insufficent.  
+ */
+static int map_iommu(struct intel_iommu *iommu, u64 phys_addr)
+{
+	int map_size, err=0;
+
+	iommu->reg_phys = phys_addr;
+	iommu->reg_size = VTD_PAGE_SIZE;
+
+	if (!request_mem_region(iommu->reg_phys, iommu->reg_size, iommu->name)) {
+		pr_err("IOMMU: can't reserve memory\n");
+		err = -EBUSY;
+		goto out;
+	}
+
+	iommu->reg = ioremap(iommu->reg_phys, iommu->reg_size);
+	if (!iommu->reg) {
+		pr_err("IOMMU: can't map the region\n");
+		err = -ENOMEM;
+		goto release;
+	}
+
+	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
+	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
+
+	if (iommu->cap == (uint64_t)-1 && iommu->ecap == (uint64_t)-1) {
+		err = -EINVAL;
+		warn_invalid_dmar(phys_addr, " returns all ones");
+		goto unmap;
+	}
+
+	/* the registers might be more than one page */
+	map_size = max_t(int, ecap_max_iotlb_offset(iommu->ecap),
+			 cap_max_fault_reg_offset(iommu->cap));
+	map_size = VTD_PAGE_ALIGN(map_size);
+	if (map_size > iommu->reg_size) {
+		iounmap(iommu->reg);
+		release_mem_region(iommu->reg_phys, iommu->reg_size);
+		iommu->reg_size = map_size;
+		if (!request_mem_region(iommu->reg_phys, iommu->reg_size,
+					iommu->name)) {
+			pr_err("IOMMU: can't reserve memory\n");
+			err = -EBUSY;
+			goto out;
+		}
+		iommu->reg = ioremap(iommu->reg_phys, iommu->reg_size);
+		if (!iommu->reg) {
+			pr_err("IOMMU: can't map the region\n");
+			err = -ENOMEM;
+			goto release;
+		}
+	}
+	err = 0;
+	goto out;
+
+unmap:
+	iounmap(iommu->reg);
+release:
+	release_mem_region(iommu->reg_phys, iommu->reg_size);
+out:
+	return err;
+}
+
 int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;
-	int map_size;
 	u32 ver;
 	static int iommu_allocated = 0;
 	int agaw = 0;
 	int msagaw = 0;
+	int err;
 
 	if (!drhd->reg_base_addr) {
 		warn_invalid_dmar(0, "");
@@ -591,19 +666,13 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	iommu->seq_id = iommu_allocated++;
 	sprintf (iommu->name, "dmar%d", iommu->seq_id);
 
-	iommu->reg = ioremap(drhd->reg_base_addr, VTD_PAGE_SIZE);
-	if (!iommu->reg) {
-		pr_err("IOMMU: can't map the region\n");
+	err = map_iommu(iommu, drhd->reg_base_addr);
+	if (err) {
+		pr_err("IOMMU: failed to map %s\n", iommu->name);
 		goto error;
 	}
-	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
-	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
-
-	if (iommu->cap == (uint64_t)-1 && iommu->ecap == (uint64_t)-1) {
-		warn_invalid_dmar(drhd->reg_base_addr, " returns all ones");
-		goto err_unmap;
-	}
 
+	err = -EINVAL;
 	agaw = iommu_calculate_agaw(iommu);
 	if (agaw < 0) {
 		pr_err("Cannot get a valid agaw for iommu (seq_id = %d)\n",
@@ -621,19 +690,6 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 	iommu->node = -1;
 
-	/* the registers might be more than one page */
-	map_size = max_t(int, ecap_max_iotlb_offset(iommu->ecap),
-		cap_max_fault_reg_offset(iommu->cap));
-	map_size = VTD_PAGE_ALIGN(map_size);
-	if (map_size > VTD_PAGE_SIZE) {
-		iounmap(iommu->reg);
-		iommu->reg = ioremap(drhd->reg_base_addr, map_size);
-		if (!iommu->reg) {
-			pr_err("IOMMU: can't map the region\n");
-			goto error;
-		}
-	}
-
 	ver = readl(iommu->reg + DMAR_VER_REG);
 	pr_info("IOMMU %d: reg_base_addr %llx ver %d:%d cap %llx ecap %llx\n",
 		iommu->seq_id,
@@ -648,10 +704,10 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	return 0;
 
  err_unmap:
-	iounmap(iommu->reg);
+	unmap_iommu(iommu);
  error:
 	kfree(iommu);
-	return -1;
+	return err;
 }
 
 void free_iommu(struct intel_iommu *iommu)
@@ -662,7 +718,8 @@ void free_iommu(struct intel_iommu *iommu)
 	free_dmar_iommu(iommu);
 
 	if (iommu->reg)
-		iounmap(iommu->reg);
+		unmap_iommu(iommu);
+
 	kfree(iommu);
 }
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index e6ca56d..78e2ada 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -308,6 +308,8 @@ enum {
 
 struct intel_iommu {
 	void __iomem	*reg; /* Pointer to hardware regs, virtual addr */
+	u64 		reg_phys; /* physical address of hw register set */
+	u64		reg_size; /* size of hw register set */
 	u64		cap;
 	u64		ecap;
 	u32		gcmd; /* Holds TE, EAFL. Don't need SRTP, SFL, WBF */
