Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1IXHft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 03:35:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32612 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab1IXHfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 03:35:48 -0400
X-AuditID: cbfee612-b7b08ae000004454-4f-4e7d8852838e
Date: Sat, 24 Sep 2011 07:35:46 +0000 (GMT)
From: =?euc-kr?B?wbaw5sij?= <pullip.cho@samsung.com>
Subject: [PATCH 3/4] iommu/exynos: Add iommu driver for Exynos4 Platforms
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=C1=B6=B0=E6=C8=A3?= <pullip.cho@samsung.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        =?euc-kr?Q?=C0=CC=BB=F3=C7=F6?= <sanghyun75.lee@samsung.com>,
        =?euc-kr?Q?=B1=E8=B1=B9=C1=F8?= <kgene.kim@samsung.com>,
        =?euc-kr?Q?=B1=E8=BF=B5=B6=F4?= <younglak1004.kim@samsung.com>,
        "ohad@wizery.com" <ohad@wizery.com>
Reply-to: pullip.cho@samsung.com
MIME-version: 1.0
X-MTR: 20110924073440400@pullip.cho
Msgkey: 20110924073440400@pullip.cho
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110924072254035@pullip.cho
X-ParentMTR: 20110924073001548@pullip.cho
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <5525949.50001316849744994.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8O7Zwrn008740

This is the System MMU driver and IOMMU API implementation for
Exynos4 SOC platforms. Exynos4 platforms has more than 10 System
MMUs dedicated for each multimedia accellerators.

Signed-off-by: KyongHo Cho 
---
drivers/iommu/Kconfig        |   14 +
drivers/iommu/Makefile       |    1 +
drivers/iommu/exynos_iommu.c |  859 ++++++++++++++++++++++++++++++++++++++++++
3 files changed, 874 insertions(+), 0 deletions(-)
create mode 100644 drivers/iommu/exynos_iommu.c

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index b57b3fa..1c754cd 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -107,4 +107,18 @@ config INTR_REMAP
  To use x2apic mode in the CPU's which support x2APIC enhancements or
  to support platforms with CPU's having > 8 bit APIC ID, say Y.

+# EXYNOS IOMMU support
+config EXYNOS_IOMMU
+ bool "Exynos IOMMU Support"
+ depends on ARCH_EXYNOS4
+ select IOMMU_API
+ select EXYNOS4_DEV_SYSMMU
+ help
+   Support for the IOMMUs (System MMUs) Samsung Exynos application
+   processor family. This enables H/W multimedia accellerators to view
+   non-linear physical memory chunks as a linear memory in their virtual
+   address spaces.
+
+   If unsure, say N here.
+
endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 4d4d77d..1eb924f 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
+obj-$(CONFIG_EXYNOS_IOMMU) += exynos_iommu.o
diff --git a/drivers/iommu/exynos_iommu.c b/drivers/iommu/exynos_iommu.c
new file mode 100644
index 0000000..fe5b5d8
--- /dev/null
+++ b/drivers/iommu/exynos_iommu.c
@@ -0,0 +1,859 @@
+/* linux/drivers/iommu/exynos_iommu.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include 
+#include 
+#include 
+#include 
+#include 
+#include 
+#include 
+#include 
+#include 
+#include 
+#include 
+
+#include 
+#include 
+
+#include 
+#include 
+#include 
+
+#define CTRL_ENABLE 0x5
+#define CTRL_BLOCK 0x7
+#define CTRL_DISABLE 0x0
+
+enum S5P_SYSMMU_INTERRUPT_TYPE {
+ SYSMMU_PAGEFAULT,
+ SYSMMU_AR_MULTIHIT,
+ SYSMMU_AW_MULTIHIT,
+ SYSMMU_BUSERROR,
+ SYSMMU_AR_SECURITY,
+ SYSMMU_AR_ACCESS,
+ SYSMMU_AW_SECURITY,
+ SYSMMU_AW_PROTECTION, /* 7 */
+ SYSMMU_FAULTS_NUM
+};
+
+static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
+ S5P_PAGE_FAULT_ADDR,
+ S5P_AR_FAULT_ADDR,
+ S5P_AW_FAULT_ADDR,
+ S5P_DEFAULT_SLAVE_ADDR,
+ S5P_AR_FAULT_ADDR,
+ S5P_AR_FAULT_ADDR,
+ S5P_AW_FAULT_ADDR,
+ S5P_AW_FAULT_ADDR
+};
+
+static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
+ "PAGE FAULT",
+ "AR MULTI-HIT FAULT",
+ "AW MULTI-HIT FAULT",
+ "BUS ERROR",
+ "AR SECURITY PROTECTION FAULT",
+ "AR ACCESS PROTECTION FAULT",
+ "AW SECURITY PROTECTION FAULT",
+ "AW ACCESS PROTECTION FAULT"
+};
+
+struct exynos_iommu_domain {
+ struct device *dev;
+ unsigned long *pgtable;
+ spinlock_t lock;
+ spinlock_t pgtablelock;
+};
+
+/* List of sysmmu_platdata */
+static LIST_HEAD(sysmmu_list);
+
+static inline struct sysmmu_platdata *get_sysmmu_data(struct device *owner,
+ struct sysmmu_platdata *start)
+{
+ struct list_head *pos, *head;
+
+ head = (start) ? &start->node : &sysmmu_list;
+
+ list_for_each(pos, head) {
+ struct sysmmu_platdata *mmudata =
+ container_of(pos, struct sysmmu_platdata, node);
+
+ if (pos == &sysmmu_list)
+ return NULL;
+
+ if (mmudata->owner == owner)
+ return mmudata;
+ }
+
+ return NULL;
+}
+
+static inline struct sysmmu_platdata *get_platdata(struct device *dev)
+{
+ return dev_get_platdata(dev);
+}
+
+static inline bool set_sysmmu_active(struct sysmmu_platdata *mmudata)
+{
+ /* return true if the System MMU was not active previously
+    and it needs to be initialized */
+
+ return atomic_inc_return(&mmudata->activations) == 1;
+}
+
+static inline bool set_sysmmu_inactive(struct sysmmu_platdata *mmudata)
+{
+ /* return true if the System MMU is needed to be disabled */
+ int ref;
+
+ ref = atomic_dec_return(&mmudata->activations);
+
+ if (ref == 0)
+ return true;
+
+ if (WARN_ON(ref < 0)) {
+ /* System MMU is already disabled */
+ atomic_set(&mmudata->activations, 0);
+ ref = 0;
+ }
+
+ return false;
+}
+
+static inline bool is_sysmmu_active(struct sysmmu_platdata *mmudata)
+{
+ return atomic_read(&mmudata->activations) != 0;
+}
+
+static inline void sysmmu_block(void __iomem *sfrbase)
+{
+ __raw_writel(CTRL_BLOCK, sfrbase + S5P_MMU_CTRL);
+}
+
+static inline void sysmmu_unblock(void __iomem *sfrbase)
+{
+ __raw_writel(CTRL_ENABLE, sfrbase + S5P_MMU_CTRL);
+}
+
+static inline void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
+{
+ __raw_writel(0x1, sfrbase + S5P_MMU_FLUSH);
+}
+
+static inline void __sysmmu_set_ptbase(void __iomem *sfrbase,
+        unsigned long pgd)
+{
+ if (unlikely(pgd == 0)) {
+ pgd = (unsigned long)ZERO_PAGE(0);
+ __raw_writel(0x20, sfrbase + S5P_MMU_CFG); /* 4KB LV1 */
+ } else {
+ __raw_writel(0x0, sfrbase + S5P_MMU_CFG); /* 16KB LV1 */
+ }
+
+ __raw_writel(pgd, sfrbase + S5P_PT_BASE_ADDR);
+
+ __sysmmu_tlb_invalidate(sfrbase);
+}
+
+static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
+{
+ /* SYSMMU is in blocked when interrupt occurred. */
+ unsigned long addr;
+ struct sysmmu_platdata *mmudata = dev_id;
+ enum S5P_SYSMMU_INTERRUPT_TYPE itype;
+
+ WARN_ON(!is_sysmmu_active(mmudata));
+
+ itype = (enum S5P_SYSMMU_INTERRUPT_TYPE)
+ __ffs(__raw_readl(mmudata->sfrbase + S5P_INT_STATUS));
+
+ BUG_ON(!((itype >= 0) && (itype < 8)));
+
+ dev_alert(mmudata->dev, "SYSTEM MMU FAULT!!!.\n");
+
+ if (!mmudata->domain)
+ return IRQ_NONE;
+
+ addr = __raw_readl(mmudata->sfrbase + fault_reg_offset[itype]);
+
+ if (!report_iommu_fault(mmudata->domain, mmudata->owner, addr, itype)) {
+ __raw_writel(1 << itype, mmudata->sfrbase + S5P_INT_CLEAR);
+ dev_notice(mmudata->dev,
+ "%s is resolved. Retrying translation.\n",
+ sysmmu_fault_name[itype]);
+ sysmmu_unblock(mmudata->sfrbase);
+ } else {
+ dev_notice(mmudata->dev, "%s is not handled.\n",
+ sysmmu_fault_name[itype]);
+ }
+
+ return IRQ_HANDLED;
+}
+
+void exynos_sysmmu_set_tablebase_pgd(struct device *owner, unsigned long pgd)
+{
+ struct sysmmu_platdata *mmudata = NULL;
+
+ while ((mmudata = get_sysmmu_data(owner, mmudata))) {
+ if (is_sysmmu_active(mmudata)) {
+ sysmmu_block(mmudata->sfrbase);
+ __sysmmu_set_ptbase(mmudata->sfrbase, pgd);
+ sysmmu_unblock(mmudata->sfrbase);
+ dev_dbg(mmudata->dev, "New page table base is %p\n",
+ (void *)pgd);
+ } else {
+ dev_dbg(mmudata->dev,
+ "Disabled: Skipping setting page table base.\n");
+ }
+ }
+}
+
+int exynos_sysmmu_enable(struct iommu_domain *domain)
+{
+ struct sysmmu_platdata *mmudata = NULL;
+ bool enabled = false;
+ struct exynos_iommu_domain *priv = domain->priv;
+
+ if (!priv || !priv->dev)
+ return -EINVAL;
+
+ /* There are some devices that control more System MMUs than one such
+ * as MFC.
+ */
+ while ((mmudata = get_sysmmu_data(priv->dev, mmudata))) {
+ enabled = true;
+
+ if (!set_sysmmu_active(mmudata)) {
+ dev_dbg(mmudata->dev, "Already enabled.\n");
+ continue;
+ }
+
+ pm_runtime_get_sync(mmudata->dev);
+
+ clk_enable(mmudata->clk);
+
+ __sysmmu_set_ptbase(mmudata->sfrbase, __pa(priv->pgtable));
+
+ __raw_writel(CTRL_ENABLE, mmudata->sfrbase + S5P_MMU_CTRL);
+
+ mmudata->domain = domain;
+
+ dev_dbg(mmudata->dev, "Enabled.\n");
+ }
+
+ return (enabled) ? 0 : -ENODEV;
+}
+
+void exynos_sysmmu_disable(struct iommu_domain *domain)
+{
+ struct sysmmu_platdata *mmudata = NULL;
+ bool disabled = false;
+ struct exynos_iommu_domain *priv = domain->priv;
+
+ if (!priv || !priv->dev)
+ return;
+
+ while ((mmudata = get_sysmmu_data(priv->dev, mmudata))) {
+ disabled = true;
+
+ if (!set_sysmmu_inactive(mmudata)) {
+ dev_dbg(mmudata->dev,
+ "Inactivation request ignorred\n");
+ continue;
+ }
+
+ __raw_writel(CTRL_DISABLE, mmudata->sfrbase + S5P_MMU_CTRL);
+
+ clk_disable(mmudata->clk);
+
+ pm_runtime_put_sync(mmudata->dev);
+
+ mmudata->domain = NULL;
+
+ dev_dbg(mmudata->dev, "Disabled.\n");
+ }
+
+ BUG_ON(!disabled);
+}
+
+void exynos_sysmmu_tlb_invalidate(struct device *owner)
+{
+ struct sysmmu_platdata *mmudata = NULL;
+
+ while ((mmudata = get_sysmmu_data(owner, mmudata))) {
+ if (is_sysmmu_active(mmudata)) {
+ sysmmu_block(mmudata->sfrbase);
+ __sysmmu_tlb_invalidate(mmudata->sfrbase);
+ sysmmu_unblock(mmudata->sfrbase);
+ } else {
+ dev_dbg(mmudata->dev,
+ "Disabled: Skipping invalidating TLB.\n");
+ }
+ }
+}
+
+static int exynos_sysmmu_probe(struct platform_device *pdev)
+{
+ struct resource *res, *ioarea;
+ int ret;
+ int irq;
+ struct device *dev;
+ void *sfr;
+
+ dev = &pdev->dev;
+ if (!get_platdata(dev) || (get_platdata(dev)->owner == NULL)) {
+ dev_err(dev, "Failed to probing system MMU: "
+ "Owner device is not set.");
+ return -ENXIO;
+ }
+
+ res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+ if (!res) {
+ dev_err(dev,
+ "Failed probing system MMU: failed to get resource.");
+ return -ENOENT;
+ }
+
+ ioarea = request_mem_region(res->start, resource_size(res), pdev->name);
+ if (ioarea == NULL) {
+ dev_err(dev, "Failed probing system MMU: "
+ "failed to request memory region.");
+ return -ENOMEM;
+ }
+
+ sfr = ioremap(res->start, resource_size(res));
+ if (!sfr) {
+ dev_err(dev, "Failed probing system MMU: "
+ "failed to call ioremap().");
+ ret = -ENOENT;
+ goto err_ioremap;
+ }
+
+ irq = platform_get_irq(pdev, 0);
+ if (irq <= 0) {
+ dev_err(dev, "Failed probing system MMU: "
+ "failed to get irq resource.");
+ ret = irq;
+ goto err_irq;
+ }
+
+ if (request_irq(irq, exynos_sysmmu_irq, 0, dev_name(&pdev->dev),
+ dev_get_platdata(dev))) {
+ dev_err(dev, "Failed probing system MMU: "
+ "failed to request irq.");
+ ret = -ENOENT;
+ goto err_irq;
+ }
+
+ get_platdata(dev)->clk = clk_get(dev, "sysmmu");
+
+ if (IS_ERR_OR_NULL(get_platdata(dev)->clk)) {
+ dev_err(dev, "Failed to probing System MMU: "
+ "failed to get clock descriptor");
+ ret = -ENOENT;
+ goto err_clk;
+ }
+
+ get_platdata(dev)->sfrbase = sfr;
+
+ list_add(&get_platdata(dev)->node, &sysmmu_list);
+
+ if (dev->parent)
+ pm_runtime_enable(dev);
+
+ dev_dbg(dev, "Initialized for %s.\n",
+ dev_name(get_platdata(dev)->owner));
+ return 0;
+err_clk:
+ free_irq(irq, dev_get_platdata(dev));
+err_irq:
+ iounmap(get_platdata(dev)->sfrbase);
+err_ioremap:
+ release_resource(ioarea);
+ kfree(ioarea);
+ dev_err(dev, "Probing system MMU failed.");
+ return ret;
+}
+
+static int exynos_sysmmu_remove(struct platform_device *pdev)
+{
+ return 0;
+}
+
+int exynos_sysmmu_runtime_suspend(struct device *dev)
+{
+ if (WARN_ON(is_sysmmu_active(dev_get_platdata(dev))))
+ return -EFAULT;
+
+ return 0;
+}
+
+int exynos_sysmmu_runtime_resume(struct device *dev)
+{
+ if (WARN_ON(is_sysmmu_active(dev_get_platdata(dev))))
+ return -EFAULT;
+
+ return 0;
+}
+
+const struct dev_pm_ops exynos_sysmmu_pm_ops = {
+ .runtime_suspend = exynos_sysmmu_runtime_suspend,
+ .runtime_resume = exynos_sysmmu_runtime_resume,
+};
+
+static struct platform_driver exynos_sysmmu_driver = {
+ .probe = exynos_sysmmu_probe,
+ .remove = exynos_sysmmu_remove,
+ .driver = {
+ .owner = THIS_MODULE,
+ .name = "s5p-sysmmu",
+ .pm = &exynos_sysmmu_pm_ops,
+ }
+};
+
+static int __init exynos_sysmmu_init(void)
+{
+ return platform_driver_register(&exynos_sysmmu_driver);
+}
+arch_initcall(exynos_sysmmu_init);
+
+/* We does not consider super section mapping (16MB) */
+#define S5P_SPAGE_SHIFT 12
+#define S5P_LPAGE_SHIFT 16
+#define S5P_SECTION_SHIFT 20
+
+#define S5P_SPAGE_SIZE (1 << S5P_SPAGE_SHIFT)
+#define S5P_LPAGE_SIZE (1 << S5P_LPAGE_SHIFT)
+#define S5P_SECTION_SIZE (1 << S5P_SECTION_SHIFT)
+
+#define S5P_SPAGE_MASK (~(S5P_SPAGE_SIZE - 1))
+#define S5P_LPAGE_MASK (~(S5P_LPAGE_SIZE - 1))
+#define S5P_SECTION_MASK (~(S5P_SECTION_SIZE - 1))
+
+#define S5P_SPAGE_ORDER (S5P_SPAGE_SHIFT - PAGE_SHIFT)
+#define S5P_LPAGE_ORDER (S5P_LPAGE_SHIFT - S5P_SPAGE_SHIFT)
+#define S5P_SECTION_ORDER (S5P_SECTION_SHIFT - S5P_SPAGE_SHIFT)
+
+#define S5P_LV1TABLE_ENTRIES (1 << (BITS_PER_LONG - S5P_SECTION_SHIFT))
+
+#define S5P_LV2TABLE_ENTRIES (1 << S5P_SECTION_ORDER)
+#define S5P_LV2TABLE_SIZE (S5P_LV2TABLE_ENTRIES * sizeof(long))
+#define S5P_LV2TABLE_MASK (~(S5P_LV2TABLE_SIZE - 1)) /* 0xFFFFFC00 */
+
+#define S5P_SECTION_LV1_ENTRY(entry) ((entry & 0x40003) == 2)
+#define S5P_SUPSECT_LV1_ENTRY(entry) ((entry & 0x40003) == 0x40002)
+#define S5P_PAGE_LV1_ENTRY(entry) ((entry & 3) == 1)
+#define S5P_FAULT_LV1_ENTRY(entry) (((entry & 3) == 0) || (entry & 3) == 3)
+
+#define S5P_LPAGE_LV2_ENTRY(entry) ((entry & 3) == 1)
+#define S5P_SPAGE_LV2_ENTRY(entry) ((entry & 2) == 2)
+#define S5P_FAULT_LV2_ENTRY(entry) ((entry & 3) == 0)
+
+#define MAKE_FAULT_ENTRY(entry) do { entry = 0; } while (0)
+#define MAKE_SECTION_ENTRY(entry, pa) do { entry = pa | 2; } while (0)
+#define MAKE_SUPSECT_ENTRY(entry, pa) do { entry = pa | 0x40002; } while (0)
+#define MAKE_LV2TABLE_ENTRY(entry, pa) do { entry = pa | 1; } while (0)
+
+#define MAKE_LPAGE_ENTRY(entry, pa) do { entry = pa | 1; } while (0)
+#define MAKE_SPAGE_ENTRY(entry, pa) do { entry = pa | 3; } while (0)
+
+#define GET_LV2ENTRY(entry, iova) (\
+ (unsigned long *)phys_to_virt(entry & S5P_LV2TABLE_MASK) +\
+ ((iova & (~S5P_SECTION_MASK)) >> S5P_SPAGE_SHIFT))
+
+/* slab cache for level 2 page tables */
+static struct kmem_cache *l2table_cachep;
+
+static inline void pgtable_flush(void *vastart, void *vaend)
+{
+ dmac_flush_range(vastart, vaend);
+ outer_flush_range(virt_to_phys(vastart),
+ virt_to_phys(vaend));
+}
+
+static int exynos_iommu_fault_handler(struct iommu_domain *domain,
+ struct device *dev, unsigned long iova, int flags)
+{
+ struct exynos_iommu_domain *priv = domain->priv;
+
+ dev_err(priv->dev, "%s occured at %p(Page table base: %p)\n",
+ sysmmu_fault_name[flags], (void *)iova,
+ (void *)(__pa(priv->pgtable)));
+ dev_err(priv->dev, "\t\tGenerating Kernel OOPS...\n");
+ dev_err(priv->dev, "\t\tbecause it is unrecoverable.\n");
+ dev_err(priv->dev,
+ "\t\tSet Fault handler with iommu_set_fault_handler().\n");
+ dev_err(priv->dev, "\t\tto handle System MMU fault.\n");
+
+ BUG();
+
+ return 0;
+}
+
+static int exynos_iommu_domain_init(struct iommu_domain *domain)
+{
+ struct exynos_iommu_domain *priv;
+
+ priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+ if (!priv)
+ return -ENOMEM;
+
+ priv->pgtable = (unsigned long *)__get_free_pages(GFP_KERNEL,
+ (S5P_LV1TABLE_ENTRIES * sizeof(unsigned long)) >> PAGE_SHIFT);
+ if (!priv->pgtable) {
+ kfree(priv);
+ return -ENOMEM;
+ }
+
+ memset(priv->pgtable, 0, S5P_LV1TABLE_ENTRIES * sizeof(unsigned long));
+ pgtable_flush(priv->pgtable, priv->pgtable + S5P_LV1TABLE_ENTRIES);
+
+ spin_lock_init(&priv->lock);
+
+ domain->priv = priv;
+
+ iommu_set_fault_handler(domain, &exynos_iommu_fault_handler);
+
+ return 0;
+}
+
+static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
+{
+ struct exynos_iommu_domain *priv = domain->priv;
+
+ free_pages((unsigned long)priv->pgtable,
+ (S5P_LV1TABLE_ENTRIES * sizeof(unsigned long)) >> PAGE_SHIFT);
+
+ kfree(priv);
+
+ domain->priv = NULL;
+}
+
+static int exynos_iommu_attach_device(struct iommu_domain *domain,
+    struct device *dev)
+{
+ struct exynos_iommu_domain *priv = domain->priv;
+ int ret;
+
+ spin_lock(&priv->lock);
+
+ priv->dev = dev;
+
+ ret = exynos_sysmmu_enable(domain);
+ if (ret)
+ return ret;
+
+ spin_unlock(&priv->lock);
+
+ return 0;
+}
+
+static void exynos_iommu_detach_device(struct iommu_domain *domain,
+     struct device *dev)
+{
+ struct exynos_iommu_domain *priv = domain->priv;
+
+ spin_lock(&priv->lock);
+
+ if (priv->dev == dev) {
+ exynos_sysmmu_disable(domain);
+ priv->dev = NULL;
+ }
+
+ spin_unlock(&priv->lock);
+}
+
+static bool section_available(struct iommu_domain *domain,
+       unsigned long *lv1entry)
+{
+ struct exynos_iommu_domain *priv = domain->priv;
+
+ if (S5P_SECTION_LV1_ENTRY(*lv1entry)) {
+ dev_err(priv->dev, "1MB entry alread exists at 0x%08x\n",
+ (lv1entry - priv->pgtable) * SZ_1M);
+ return false;
+ }
+
+ if (S5P_PAGE_LV1_ENTRY(*lv1entry)) {
+ unsigned long *lv2end, *lv2base;
+
+ lv2base = phys_to_virt(*lv1entry & S5P_LV2TABLE_MASK);
+ lv2end = lv2base + S5P_LV2TABLE_ENTRIES;
+ while (lv2base != lv2end) {
+ if (!S5P_FAULT_LV2_ENTRY(*lv2base)) {
+ dev_err(priv->dev, "Failed to free L2 page "
+ "table for section mapping.\n");
+ return false;
+ }
+ lv2base++;
+ }
+
+ kmem_cache_free(l2table_cachep,
+ phys_to_virt(*lv1entry & S5P_LV2TABLE_MASK));
+
+ MAKE_FAULT_ENTRY(*lv1entry);
+ }
+
+ return true;
+}
+
+static bool write_lpage(unsigned long *head_entry, unsigned long phys_addr)
+{
+ unsigned long *entry, *end;
+
+ entry = head_entry;
+ end = entry + (1 << S5P_LPAGE_ORDER);
+
+ while (entry != end) {
+ if (!S5P_FAULT_LV2_ENTRY(*entry))
+ break;
+
+ MAKE_LPAGE_ENTRY(*entry, phys_addr);
+
+ entry++;
+ }
+
+ if (entry != end) {
+ end = entry;
+ while (entry != head_entry)
+ MAKE_FAULT_ENTRY(*(--entry));
+
+ return false;
+ }
+
+ return true;
+}
+
+static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
+ phys_addr_t paddr, int gfp_order, int prot)
+{
+ struct exynos_iommu_domain *priv = domain->priv;
+ unsigned long *start_entry, *entry, *end_entry;
+ int num_entry;
+ int ret = 0;
+ unsigned long flags;
+
+ BUG_ON(priv->pgtable == NULL);
+
+ spin_lock_irqsave(&priv->pgtablelock, flags);
+
+ start_entry = entry = priv->pgtable + (iova >> S5P_SECTION_SHIFT);
+
+ if (gfp_order >= S5P_SECTION_ORDER) {
+ BUG_ON((paddr | iova) & ~S5P_SECTION_MASK);
+ /* 1MiB mapping */
+
+ num_entry = 1 << (gfp_order - S5P_SECTION_ORDER);
+ end_entry = entry + num_entry;
+
+ while (entry != end_entry) {
+ if (!section_available(domain, entry))
+ break;
+
+ MAKE_SECTION_ENTRY(*entry, paddr);
+
+ paddr += S5P_SECTION_SIZE;
+ entry++;
+ }
+
+ if (entry != end_entry)
+ goto mapping_error;
+
+ pgtable_flush(start_entry, entry);
+ goto mapping_done;
+ }
+
+ if (S5P_FAULT_LV1_ENTRY(*entry)) {
+ unsigned long *l2table;
+
+ l2table = kmem_cache_zalloc(l2table_cachep, GFP_KERNEL);
+ if (!l2table) {
+ ret = -ENOMEM;
+ goto nomem_error;
+ }
+
+ pgtable_flush(entry, entry + S5P_LV2TABLE_ENTRIES);
+
+ MAKE_LV2TABLE_ENTRY(*entry, virt_to_phys(l2table));
+ pgtable_flush(entry, entry + 1);
+ }
+
+ /* 'entry' points level 2 entries, hereafter */
+ entry = GET_LV2ENTRY(*entry, iova);
+
+ start_entry = entry;
+ num_entry = 1 << gfp_order;
+ end_entry = entry + num_entry;
+
+ if (gfp_order >= S5P_LPAGE_ORDER) {
+ /* large page(64KiB) mapping */
+ BUG_ON((paddr | iova) & ~S5P_LPAGE_MASK);
+
+ while (entry != end_entry) {
+ if (!write_lpage(entry, paddr)) {
+ pr_err("%s: Failed to allocate large page"
+ " entry.\n", __func__);
+ break;
+ }
+
+ paddr += S5P_LPAGE_SIZE;
+ entry += (1 << S5P_LPAGE_ORDER);
+ }
+
+ if (entry != end_entry) {
+ entry -= 1 << S5P_LPAGE_ORDER;
+ goto mapping_error;
+ }
+ } else {
+ /* page (4KiB) mapping */
+ while (entry != end_entry && S5P_FAULT_LV2_ENTRY(*entry)) {
+
+ MAKE_SPAGE_ENTRY(*entry, paddr);
+
+ entry++;
+ paddr += S5P_SPAGE_SIZE;
+ }
+
+ if (entry != end_entry) {
+ pr_err("%s: Failed to allocate small page entry.\n",
+ __func__);
+ goto mapping_error;
+ }
+ }
+
+ pgtable_flush(start_entry, entry);
+mapping_error:
+ if (entry != end_entry) {
+ unsigned long *current_entry = entry;
+ while (entry != start_entry)
+ MAKE_FAULT_ENTRY(*(--entry));
+ pgtable_flush(start_entry, current_entry);
+ ret = -EADDRINUSE;
+ }
+
+nomem_error:
+mapping_done:
+ spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+ return 0;
+}
+
+static int exynos_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+    int gfp_order)
+{
+ struct exynos_iommu_domain *priv = domain->priv;
+ unsigned long *entry;
+ int num_entry;
+ unsigned long flags;
+
+ BUG_ON(priv->pgtable == NULL);
+
+ spin_lock_irqsave(&priv->pgtablelock, flags);
+
+ entry = priv->pgtable + (iova >> S5P_SECTION_SHIFT);
+
+ if (gfp_order >= S5P_SECTION_ORDER) {
+ gfp_order -= S5P_SECTION_ORDER;
+ num_entry = 1 << (gfp_order - S5P_SECTION_ORDER);
+ while (num_entry--) {
+ if (S5P_SECTION_LV1_ENTRY(*entry)) {
+ MAKE_FAULT_ENTRY(*entry);
+ } else if (S5P_PAGE_LV1_ENTRY(*entry)) {
+ unsigned long *lv2beg, *lv2end;
+ lv2beg = phys_to_virt(
+ *entry & S5P_LV2TABLE_MASK);
+ lv2end = lv2beg + S5P_LV2TABLE_ENTRIES;
+ while (lv2beg != lv2end) {
+ MAKE_FAULT_ENTRY(*lv2beg);
+ lv2beg++;
+ }
+ }
+ entry++;
+ }
+ } else {
+ entry = GET_LV2ENTRY(*entry, iova);
+
+ BUG_ON(S5P_LPAGE_LV2_ENTRY(*entry) &&
+ (gfp_order < S5P_LPAGE_ORDER));
+
+ num_entry = 1 << gfp_order;
+
+ while (num_entry--) {
+ MAKE_FAULT_ENTRY(*entry);
+ entry++;
+ }
+ }
+
+ if (priv->dev)
+ exynos_sysmmu_tlb_invalidate(priv->dev);
+
+ spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+ return 0;
+}
+
+static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
+   unsigned long iova)
+{
+ struct exynos_iommu_domain *priv = domain->priv;
+ unsigned long *entry;
+ unsigned long offset;
+
+ entry = priv->pgtable + (iova >> S5P_SECTION_SHIFT);
+
+ if (S5P_FAULT_LV1_ENTRY(*entry))
+ return 0;
+
+ offset = iova & ~S5P_SECTION_MASK;
+
+ if (S5P_SECTION_LV1_ENTRY(*entry))
+ return (*entry & S5P_SECTION_MASK) + offset;
+
+ entry = GET_LV2ENTRY(*entry, iova);
+
+ if (S5P_SPAGE_LV2_ENTRY(*entry))
+ return (*entry & S5P_SPAGE_MASK) + (iova & ~S5P_SPAGE_MASK);
+
+ if (S5P_LPAGE_LV2_ENTRY(*entry))
+ return (*entry & S5P_LPAGE_MASK) + (iova & ~S5P_LPAGE_MASK);
+
+ return 0;
+}
+
+static int exynos_iommu_domain_has_cap(struct iommu_domain *domain,
+     unsigned long cap)
+{
+ return 0;
+}
+
+static struct iommu_ops exynos_iommu_ops = {
+ .domain_init = &exynos_iommu_domain_init,
+ .domain_destroy = &exynos_iommu_domain_destroy,
+ .attach_dev = &exynos_iommu_attach_device,
+ .detach_dev = &exynos_iommu_detach_device,
+ .map = &exynos_iommu_map,
+ .unmap = &exynos_iommu_unmap,
+ .iova_to_phys = &exynos_iommu_iova_to_phys,
+ .domain_has_cap = &exynos_iommu_domain_has_cap,
+};
+
+static int __init exynos_iommu_init(void)
+{
+ l2table_cachep = kmem_cache_create("SysMMU Lv2 Tables",
+ S5P_LV2TABLE_SIZE, S5P_LV2TABLE_SIZE, 0, NULL);
+ if (!l2table_cachep)
+ return -ENOMEM;
+
+ register_iommu(&exynos_iommu_ops);
+
+ return 0;
+}
+arch_initcall(exynos_iommu_init);
-- 
1.7.1
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
