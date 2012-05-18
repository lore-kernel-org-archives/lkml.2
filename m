Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031267Ab2ERX0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:26:08 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:64838 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031273Ab2ERX0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:26:02 -0400
Subject: [PATCH 2/2] iommu: Request IOMMU CSR space
To: David Woodhouse <dwmw2@infradead.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>
Date: Fri, 18 May 2012 17:18:37 -0600
Message-ID: <20120518231837.31187.29401.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20120518231238.31187.44571.stgit@bhelgaas.mtv.corp.google.com>
References: <20120518231238.31187.44571.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request the IOMMU CSR MMIO region to keep anybody else from claiming it
while we're using it.

The bug referenced below is a crash that happened when we assigned an
address in the IOMMU CSR area to a PCI BAR.  This patch just changes
the IOMMU driver, which only helps when the driver is present, so a
BIOS change is also necessary.  But the driver should claim the space
it uses in any event.

Reference: https://bugzilla.novell.com/show_bug.cgi?id=760440
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/iommu/dmar.c        |   41 ++++++++++++++++++++++++++++++++---------
 include/linux/intel-iommu.h |    2 ++
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 35c1e17..e4ac23a 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -581,6 +581,7 @@ int __init detect_intel_iommu(void)
 int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;
+	struct resource *res;
 	int map_size;
 	u32 ver;
 	static int iommu_allocated = 0;
@@ -599,11 +600,20 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	iommu->seq_id = iommu_allocated++;
 	sprintf (iommu->name, "dmar%d", iommu->seq_id);
 
-	iommu->reg = ioremap(drhd->reg_base_addr, VTD_PAGE_SIZE);
-	if (!iommu->reg) {
-		printk(KERN_ERR "IOMMU: can't map the region\n");
+	iommu->reg_base = drhd->reg_base_addr;
+	iommu->reg_size = VTD_PAGE_SIZE;
+	res = request_mem_region(iommu->reg_base, iommu->reg_size, iommu->name);
+	if (!res) {
+		printk(KERN_ERR "IOMMU: can't request [mem %#010llx-%#010llx]\n",
+		       iommu->reg_base, iommu->reg_base + iommu->reg_size - 1);
 		goto error;
 	}
+
+	iommu->reg = ioremap(iommu->reg_base, iommu->reg_size);
+	if (!iommu->reg) {
+		printk(KERN_ERR "IOMMU: can't map %pR\n", res);
+		goto err_release;
+	}
 	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
 	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
 
@@ -637,17 +647,26 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	map_size = VTD_PAGE_ALIGN(map_size);
 	if (map_size > VTD_PAGE_SIZE) {
 		iounmap(iommu->reg);
-		iommu->reg = ioremap(drhd->reg_base_addr, map_size);
+		release_mem_region(iommu->reg_base, iommu->reg_size);
+		iommu->reg_size = map_size;
+		res = request_mem_region(iommu->reg_base, iommu->reg_size,
+					 iommu->name);
+		if (!res) {
+			printk(KERN_ERR "IOMMU: can't request [mem %#010llx-%#010llx]\n",
+				iommu->reg_base,
+				iommu->reg_base + iommu->reg_size - 1);
+			goto error;
+		}
+		iommu->reg = ioremap(iommu->reg_base, iommu->reg_size);
 		if (!iommu->reg) {
-			printk(KERN_ERR "IOMMU: can't map the region\n");
+			printk(KERN_ERR "IOMMU: can't map %pR\n", res);
 			goto error;
 		}
 	}
 
 	ver = readl(iommu->reg + DMAR_VER_REG);
-	pr_info("IOMMU %d: reg_base_addr %llx ver %d:%d cap %llx ecap %llx\n",
-		iommu->seq_id,
-		(unsigned long long)drhd->reg_base_addr,
+	pr_info("IOMMU %d: %pR ver %d:%d cap %llx ecap %llx\n",
+		iommu->seq_id, res,
 		DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
 		(unsigned long long)iommu->cap,
 		(unsigned long long)iommu->ecap);
@@ -659,6 +678,8 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 
  err_unmap:
 	iounmap(iommu->reg);
+ err_release:
+	release_mem_region(iommu->reg_base, iommu->reg_size);
  error:
 	kfree(iommu);
 	return -1;
@@ -671,8 +692,10 @@ void free_iommu(struct intel_iommu *iommu)
 
 	free_dmar_iommu(iommu);
 
-	if (iommu->reg)
+	if (iommu->reg) {
 		iounmap(iommu->reg);
+		release_mem_region(iommu->reg_base, iommu->reg_size);
+	}
 	kfree(iommu);
 }
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index e6ca56d..911ded0 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -308,6 +308,8 @@ enum {
 
 struct intel_iommu {
 	void __iomem	*reg; /* Pointer to hardware regs, virtual addr */
+	phys_addr_t	reg_base;
+	resource_size_t reg_size;
 	u64		cap;
 	u64		ecap;
 	u32		gcmd; /* Holds TE, EAFL. Don't need SRTP, SFL, WBF */

