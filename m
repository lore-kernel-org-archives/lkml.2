Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2HPHnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:43:16 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51999 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab2HPHmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:42:52 -0400
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH v2 1/2] iommu/shmobile: Add iommu driver for Renesas IPMMU modules
Date: Thu, 16 Aug 2012 16:42:03 +0900
Message-Id: <1345102924-22045-2-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1345102924-22045-1-git-send-email-hdk@igel.co.jp>
References: <1345102924-22045-1-git-send-email-hdk@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the Renesas IPMMU driver and IOMMU API implementation.

The IPMMU module supports the MMU function and the PMB function.  The
MMU function provides address translation by pagetable compatible with
ARMv6.  The PMB function provides address translation including
tile-linear translation.  This patch implements the MMU function.

The iommu driver does not register a platform driver directly because:
- the register space of the MMU function and the PMB function
  have a common register (used for settings flush), so they should ideally
  have a way to appropriately share this register.
- the MMU function uses the IOMMU API while the PMB function does not.
- the two functions may be used independently.

Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
---
 arch/arm/mach-shmobile/Kconfig              |    6 +
 arch/arm/mach-shmobile/Makefile             |    3 +
 arch/arm/mach-shmobile/include/mach/ipmmu.h |   10 +
 arch/arm/mach-shmobile/ipmmu.c              |  130 ++++++++++
 drivers/iommu/Kconfig                       |   35 +++
 drivers/iommu/Makefile                      |    1 +
 drivers/iommu/shmobile-iommu.c              |  342 +++++++++++++++++++++++++++
 7 files changed, 527 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-shmobile/include/mach/ipmmu.h
 create mode 100644 arch/arm/mach-shmobile/ipmmu.c
 create mode 100644 drivers/iommu/shmobile-iommu.c

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 4cacc2d..1add9bd 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -210,6 +210,12 @@ endmenu
 config SH_CLK_CPG
 	bool
 
+config SHMOBILE_IPMMU
+	bool "IPMMU/IPMMUI driver"
+	default n
+	help
+	  This enables build of the IPMMU/IPMMUI driver.
+
 source "drivers/sh/Kconfig"
 
 endif
diff --git a/arch/arm/mach-shmobile/Makefile b/arch/arm/mach-shmobile/Makefile
index 0df5ae6..1e72199 100644
--- a/arch/arm/mach-shmobile/Makefile
+++ b/arch/arm/mach-shmobile/Makefile
@@ -60,3 +60,6 @@ obj-$(CONFIG_MACH_KZM9G)	+= board-kzm9g.o
 # Framework support
 obj-$(CONFIG_SMP)		+= $(smp-y)
 obj-$(CONFIG_GENERIC_GPIO)	+= $(pfc-y)
+
+# IPMMU/IPMMUI
+obj-$(CONFIG_SHMOBILE_IPMMU)	+= ipmmu.o
diff --git a/arch/arm/mach-shmobile/include/mach/ipmmu.h b/arch/arm/mach-shmobile/include/mach/ipmmu.h
new file mode 100644
index 0000000..afbd9eb
--- /dev/null
+++ b/arch/arm/mach-shmobile/include/mach/ipmmu.h
@@ -0,0 +1,10 @@
+#ifdef CONFIG_SHMOBILE_IPMMU
+void ipmmu_tlb_flush(void);
+void ipmmu_tlb_set(unsigned long phys, int size, int asid);
+void ipmmu_add_device(struct device *dev);
+int ipmmu_iommu_init(struct device *dev);
+#else
+static inline void ipmmu_add_device(struct device *dev)
+{
+}
+#endif
diff --git a/arch/arm/mach-shmobile/ipmmu.c b/arch/arm/mach-shmobile/ipmmu.c
new file mode 100644
index 0000000..c6a11fb
--- /dev/null
+++ b/arch/arm/mach-shmobile/ipmmu.c
@@ -0,0 +1,130 @@
+/*
+ * IPMMU/IPMMUI
+ * Copyright (C) 2012  Hideki EIRAKU
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/export.h>
+#include <mach/ipmmu.h>
+
+#define IMCTR1 0x000
+#define IMCTR2 0x004
+#define IMASID 0x010
+#define IMTTBR 0x014
+#define IMTTBCR 0x018
+
+#define IMCTR1_TLBEN (1 << 0)
+#define IMCTR1_FLUSH (1 << 1)
+
+static void __iomem *ipmmu_base;
+static int tlb_enabled;
+
+void __attribute__((weak)) ipmmu_add_device(struct device *dev)
+{
+}
+
+void ipmmu_tlb_flush(void)
+{
+	if (!ipmmu_base)
+		return;
+	if (tlb_enabled)
+		iowrite32(IMCTR1_FLUSH | IMCTR1_TLBEN, ipmmu_base + IMCTR1);
+	else
+		iowrite32(IMCTR1_FLUSH, ipmmu_base + IMCTR1);
+}
+
+void ipmmu_tlb_set(unsigned long phys, int size, int asid)
+{
+	if (!ipmmu_base)
+		return;
+	switch (size) {
+	default:
+		tlb_enabled = 0;
+		break;
+	case 0x2000:
+		iowrite32(1, ipmmu_base + IMTTBCR);
+		tlb_enabled = 1;
+		break;
+	case 0x1000:
+		iowrite32(2, ipmmu_base + IMTTBCR);
+		tlb_enabled = 1;
+		break;
+	case 0x800:
+		iowrite32(3, ipmmu_base + IMTTBCR);
+		tlb_enabled = 1;
+		break;
+	case 0x400:
+		iowrite32(4, ipmmu_base + IMTTBCR);
+		tlb_enabled = 1;
+		break;
+	case 0x200:
+		iowrite32(5, ipmmu_base + IMTTBCR);
+		tlb_enabled = 1;
+		break;
+	case 0x100:
+		iowrite32(6, ipmmu_base + IMTTBCR);
+		tlb_enabled = 1;
+		break;
+	case 0x80:
+		iowrite32(7, ipmmu_base + IMTTBCR);
+		tlb_enabled = 1;
+		break;
+	}
+	iowrite32(phys, ipmmu_base + IMTTBR);
+	iowrite32(asid, ipmmu_base + IMASID);
+}
+
+int __attribute__((weak)) ipmmu_iommu_init(struct device *dev)
+{
+	return 0;
+}
+
+static int __devinit ipmmu_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "cannot get platform resources\n");
+		return -ENOENT;
+	}
+	ipmmu_base = ioremap_nocache(res->start, resource_size(res));
+	if (!ipmmu_base) {
+		dev_err(&pdev->dev, "ioremap_nocache failed\n");
+		return -ENOMEM;
+	}
+	iowrite32(0x0, ipmmu_base + IMCTR1); /* disable TLB */
+	iowrite32(0x0, ipmmu_base + IMCTR2); /* disable PMB */
+	ipmmu_iommu_init(&pdev->dev);
+	return 0;
+}
+
+static struct platform_driver ipmmu_driver = {
+	.probe = ipmmu_probe,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "ipmmu",
+	},
+};
+
+static int __init ipmmu_init(void)
+{
+	return platform_driver_register(&ipmmu_driver);
+}
+subsys_initcall(ipmmu_init);
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 9f69b56..4d501b3 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -187,4 +187,39 @@ config EXYNOS_IOMMU_DEBUG
 
 	  Say N unless you need kernel log message for IOMMU debugging
 
+config SHMOBILE_IOMMU
+	bool "IOMMU for Renesas IPMMU/IPMMUI"
+	default n
+	depends on SHMOBILE_IPMMU
+	select IOMMU_API
+	select ARM_DMA_USE_IOMMU
+
+choice
+	prompt "IPMMU/IPMMUI 1st level page table size"
+	default SHMOBILE_IOMMU_L1SIZE_8192
+	depends on SHMOBILE_IOMMU
+
+	config SHMOBILE_IOMMU_L1SIZE_8192
+		bool "8192 bytes (2 GiB address space)"
+
+	config SHMOBILE_IOMMU_L1SIZE_4096
+		bool "4096 bytes (1 GiB address space)"
+
+	config SHMOBILE_IOMMU_L1SIZE_2048
+		bool "2048 bytes (512 MiB address space)"
+
+	config SHMOBILE_IOMMU_L1SIZE_1024
+		bool "1024 bytes (256 MiB address space)"
+
+	config SHMOBILE_IOMMU_L1SIZE_512
+		bool "512 bytes (128 MiB address space)"
+
+	config SHMOBILE_IOMMU_L1SIZE_256
+		bool "256 bytes (64 MiB address space)"
+
+	config SHMOBILE_IOMMU_L1SIZE_128
+		bool "128 bytes (32 MiB address space)"
+
+endchoice
+
 endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 14a4d5f..62cf917 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
 obj-$(CONFIG_TEGRA_IOMMU_GART) += tegra-gart.o
 obj-$(CONFIG_TEGRA_IOMMU_SMMU) += tegra-smmu.o
 obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
+obj-$(CONFIG_SHMOBILE_IOMMU) += shmobile-iommu.o
diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
new file mode 100644
index 0000000..3a84286
--- /dev/null
+++ b/drivers/iommu/shmobile-iommu.c
@@ -0,0 +1,342 @@
+/*
+ * IOMMU for IPMMU/IPMMUI
+ * Copyright (C) 2012  Hideki EIRAKU
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/dmapool.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/iommu.h>
+#include <linux/dma-mapping.h>
+#include <mach/ipmmu.h>
+#include <asm/dma-iommu.h>
+
+#ifdef CONFIG_SHMOBILE_IOMMU_L1SIZE_8192
+#define L1_SIZE 8192
+#endif
+#ifdef CONFIG_SHMOBILE_IOMMU_L1SIZE_4096
+#define L1_SIZE 4096
+#endif
+#ifdef CONFIG_SHMOBILE_IOMMU_L1SIZE_2048
+#define L1_SIZE 2048
+#endif
+#ifdef CONFIG_SHMOBILE_IOMMU_L1SIZE_1024
+#define L1_SIZE 1024
+#endif
+#ifdef CONFIG_SHMOBILE_IOMMU_L1SIZE_512
+#define L1_SIZE 512
+#endif
+#ifdef CONFIG_SHMOBILE_IOMMU_L1SIZE_256
+#define L1_SIZE 256
+#endif
+#ifdef CONFIG_SHMOBILE_IOMMU_L1SIZE_128
+#define L1_SIZE 128
+#endif
+#define L1_LEN (L1_SIZE / 4)
+#define L1_ALIGN L1_SIZE
+#define L2_SIZE 0x400
+#define L2_LEN (L2_SIZE / 4)
+#define L2_ALIGN L2_SIZE
+
+struct shmobile_iommu_priv_pgtable {
+	uint32_t *pgtable;
+	dma_addr_t handle;
+};
+
+struct shmobile_iommu_priv {
+	struct shmobile_iommu_priv_pgtable l1, l2[L1_LEN];
+	spinlock_t map_lock;
+	atomic_t active;
+};
+
+static struct dma_iommu_mapping *iommu_mapping;
+static struct device *ipmmu_devices;
+static struct dma_pool *l1pool, *l2pool;
+static spinlock_t lock;
+static DEFINE_SPINLOCK(lock_add);
+static struct shmobile_iommu_priv *attached;
+static int num_attached_devices;
+
+static int shmobile_iommu_domain_init(struct iommu_domain *domain)
+{
+	struct shmobile_iommu_priv *priv;
+	int i;
+
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	priv->l1.pgtable = dma_pool_alloc(l1pool, GFP_KERNEL,
+					  &priv->l1.handle);
+	if (!priv->l1.pgtable) {
+		kfree(priv);
+		return -ENOMEM;
+	}
+	for (i = 0; i < L1_LEN; i++)
+		priv->l2[i].pgtable = NULL;
+	memset(priv->l1.pgtable, 0, L1_SIZE);
+	spin_lock_init(&priv->map_lock);
+	atomic_set(&priv->active, 0);
+	domain->priv = priv;
+	return 0;
+}
+
+static void shmobile_iommu_domain_destroy(struct iommu_domain *domain)
+{
+	struct shmobile_iommu_priv *priv = domain->priv;
+	int i;
+
+	for (i = 0; i < L1_LEN; i++) {
+		if (priv->l2[i].pgtable)
+			dma_pool_free(l2pool, priv->l2[i].pgtable,
+				      priv->l2[i].handle);
+	}
+	dma_pool_free(l1pool, priv->l1.pgtable, priv->l1.handle);
+	kfree(priv);
+	domain->priv = NULL;
+}
+
+static int shmobile_iommu_attach_device(struct iommu_domain *domain,
+					struct device *dev)
+{
+	struct shmobile_iommu_priv *priv = domain->priv;
+	int ret = -EBUSY;
+
+	spin_lock(&lock);
+	if (attached != priv) {
+		if (attached)
+			goto err;
+		atomic_set(&priv->active, 1);
+		ipmmu_tlb_set(priv->l1.handle, L1_SIZE, 0);
+		wmb();
+		ipmmu_tlb_flush();
+		attached = priv;
+		num_attached_devices = 0;
+	}
+	num_attached_devices++;
+	ret = 0;
+err:
+	spin_unlock(&lock);
+	return ret;
+}
+
+static void shmobile_iommu_detach_device(struct iommu_domain *domain,
+					 struct device *dev)
+{
+	struct shmobile_iommu_priv *priv = domain->priv;
+
+	spin_lock(&lock);
+	atomic_set(&priv->active, 0);
+	num_attached_devices--;
+	if (!num_attached_devices) {
+		ipmmu_tlb_set(0, 0, 0);
+		ipmmu_tlb_flush();
+		attached = NULL;
+	}
+	spin_unlock(&lock);
+}
+
+static int
+l2alloc(struct shmobile_iommu_priv *priv, unsigned int l1index)
+{
+	if (!priv->l2[l1index].pgtable) {
+		priv->l2[l1index].pgtable = dma_pool_alloc(l2pool, GFP_KERNEL,
+						&priv->l2[l1index].handle);
+		if (!priv->l2[l1index].pgtable)
+			return -ENOMEM;
+		memset(priv->l2[l1index].pgtable, 0, L2_SIZE);
+	}
+	priv->l1.pgtable[l1index] = priv->l2[l1index].handle | 0x1;
+	return 0;
+}
+
+static int shmobile_iommu_map(struct iommu_domain *domain, unsigned long iova,
+			      phys_addr_t paddr, size_t size, int prot)
+{
+	struct shmobile_iommu_priv *priv = domain->priv;
+	unsigned int l1index, l2index, i;
+	int ret;
+
+	l1index = iova >> 20;
+	switch (size) {
+	case 0x1000:
+		l2index = (iova >> 12) & 0xff;
+		spin_lock(&priv->map_lock);
+		ret = l2alloc(priv, l1index);
+		if (!ret)
+			priv->l2[l1index].pgtable[l2index] = paddr | 0xff2;
+		spin_unlock(&priv->map_lock);
+		break;
+	case 0x10000:
+		l2index = (iova >> 12) & 0xf0;
+		spin_lock(&priv->map_lock);
+		ret = l2alloc(priv, l1index);
+		if (!ret) {
+			for (i = 0; i < 0x10; i++)
+				priv->l2[l1index].pgtable[l2index + i] =
+					paddr | 0xff1;
+		}
+		spin_unlock(&priv->map_lock);
+		break;
+	case 0x100000:
+		spin_lock(&priv->map_lock);
+		priv->l1.pgtable[l1index] = paddr | 0xc02;
+		spin_unlock(&priv->map_lock);
+		ret = 0;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	if (!ret && atomic_read(&priv->active)) {
+		wmb();
+		ipmmu_tlb_flush();
+	}
+	return ret;
+}
+
+static size_t shmobile_iommu_unmap(struct iommu_domain *domain,
+				   unsigned long iova, size_t size)
+{
+	struct shmobile_iommu_priv *priv = domain->priv;
+	unsigned int l1index, l2index, i;
+
+	l1index = iova >> 20;
+	switch (size) {
+	case 0x1000:
+		l2index = (iova >> 12) & 0xff;
+		spin_lock(&priv->map_lock);
+		if (priv->l2[l1index].pgtable)
+			priv->l2[l1index].pgtable[l2index] = 0;
+		spin_unlock(&priv->map_lock);
+		break;
+	case 0x10000:
+		l2index = (iova >> 12) & 0xf0;
+		spin_lock(&priv->map_lock);
+		if (priv->l2[l1index].pgtable) {
+			for (i = 0; i < 0x10; i++)
+				priv->l2[l1index].pgtable[l2index + i] = 0;
+		}
+		spin_unlock(&priv->map_lock);
+		break;
+	case 0x100000:
+		spin_lock(&priv->map_lock);
+		priv->l1.pgtable[l1index] = 0;
+		spin_unlock(&priv->map_lock);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (atomic_read(&priv->active)) {
+		wmb();
+		ipmmu_tlb_flush();
+	}
+	return size;
+}
+
+static phys_addr_t shmobile_iommu_iova_to_phys(struct iommu_domain *domain,
+					       unsigned long iova)
+{
+	struct shmobile_iommu_priv *priv = domain->priv;
+	uint32_t l1entry = 0, l2entry = 0;
+	unsigned int l1index, l2index;
+
+	l1index = iova >> 20;
+	l2index = (iova >> 12) & 0xff;
+	spin_lock(&priv->map_lock);
+	if (priv->l2[l1index].pgtable)
+		l2entry = priv->l2[l1index].pgtable[l2index];
+	else
+		l1entry = priv->l1.pgtable[l1index];
+	spin_unlock(&priv->map_lock);
+	switch (l2entry & 3) {
+	case 1:
+		return (l2entry & ~0xffff) | (iova & 0xffff);
+	case 2:
+		return (l2entry & ~0xfff) | (iova & 0xfff);
+	default:
+		if ((l1entry & 3) == 2)
+			return (l1entry & ~0xfffff) | (iova & 0xfffff);
+		return 0;
+	}
+}
+
+static struct iommu_ops shmobile_iommu_ops = {
+	.domain_init = shmobile_iommu_domain_init,
+	.domain_destroy = shmobile_iommu_domain_destroy,
+	.attach_dev = shmobile_iommu_attach_device,
+	.detach_dev = shmobile_iommu_detach_device,
+	.map = shmobile_iommu_map,
+	.unmap = shmobile_iommu_unmap,
+	.iova_to_phys = shmobile_iommu_iova_to_phys,
+	.pgsize_bitmap = 0x111000,
+};
+
+static int shmobile_iommu_attach_all_devices(void)
+{
+	struct device *dev;
+	int ret = 0;
+
+	spin_lock(&lock_add);
+	iommu_mapping = arm_iommu_create_mapping(&platform_bus_type, 0x0,
+						 L1_LEN << 20, 0);
+	if (IS_ERR_OR_NULL(iommu_mapping)) {
+		ret = PTR_ERR(iommu_mapping);
+		goto err;
+	}
+	for (dev = ipmmu_devices; dev; dev = dev->archdata.iommu) {
+		if (arm_iommu_attach_device(dev, iommu_mapping))
+			pr_err("arm_iommu_attach_device failed\n");
+	}
+err:
+	spin_unlock(&lock_add);
+	return 0;
+}
+
+void ipmmu_add_device(struct device *dev)
+{
+	spin_lock(&lock_add);
+	dev->archdata.iommu = ipmmu_devices;
+	ipmmu_devices = dev;
+	if (!IS_ERR_OR_NULL(iommu_mapping)) {
+		if (arm_iommu_attach_device(dev, iommu_mapping))
+			pr_err("arm_iommu_attach_device failed\n");
+	}
+	spin_unlock(&lock_add);
+}
+
+int ipmmu_iommu_init(struct device *dev)
+{
+	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	l1pool = dma_pool_create("shmobile-iommu-pgtable1", dev,
+				 L1_SIZE, L1_ALIGN, 0);
+	if (!l1pool)
+		goto nomem_pool1;
+	l2pool = dma_pool_create("shmobile-iommu-pgtable2", dev,
+				 L2_SIZE, L2_ALIGN, 0);
+	if (!l2pool)
+		goto nomem_pool2;
+	spin_lock_init(&lock);
+	attached = NULL;
+	bus_set_iommu(&platform_bus_type, &shmobile_iommu_ops);
+	if (shmobile_iommu_attach_all_devices())
+		pr_err("shmobile_iommu_attach_all_devices failed\n");
+	return 0;
+nomem_pool2:
+	dma_pool_destroy(l1pool);
+nomem_pool1:
+	return -ENOMEM;
+}
-- 
1.7.0.4

