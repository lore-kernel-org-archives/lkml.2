Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2JQRij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:38:39 -0400
Received: from [216.32.181.185] ([216.32.181.185]:2462 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757419Ab2JQRig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:38:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z551bizc8kzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 3/3 v3] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
Date: Wed, 17 Oct 2012 23:02:50 +0530
Message-ID: <1350495170-4593-4-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1350495170-4593-1-git-send-email-Varun.Sethi@freescale.com>
References: <1350495170-4593-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is a brief description of the PAMU hardware:
PAMU determines what action to take and whether to authorize the action on
the basis of the memory address, a Logical IO Device Number (LIODN), and
PAACT table (logically) indexed by LIODN and address. Hardware devices which
need to access memory must provide an LIODN in addition to the memory address.

Peripheral Access Authorization and Control Tables (PAACTs) are the primary
data structures used by PAMU. A PAACT is a table of peripheral access
authorization and control entries (PAACE).Each PAACE defines the range of
I/O bus address space that is accessible by the LIOD and the associated access
capabilities.

There are two types of PAACTs: primary PAACT (PPAACT) and secondary PAACT 
(SPAACT).A given physical I/O device may be able to act as one or more
independent logical I/O devices (LIODs). Each such logical I/O device is
assigned an identifier called logical I/O device number (LIODN). A LIODN is
allocated a contiguous portion of the I/O bus address space called the DSA window
for performing DSA operations. The DSA window may optionally be divided into
multiple sub-windows, each of which may be used to map to a region in system
storage space. The first sub-window is referred to as the primary sub-window
and the remaining are called secondary sub-windows.

This patch provides the PAMU driver (fsl_pamu.c) and the corresponding IOMMU
API implementation (fsl_pamu_domain.c). The PAMU hardware driver (fsl_pamu.c)
has been derived from the work done by Ashish Kalra and Timur Tabi
(timur@freescale.com).

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
changes in v3:
- Addressed comments by Kumar Gala
- dynamic fspi allocation
- fixed alignment check in map and unmap
operations.

 drivers/iommu/Kconfig           |    8 +
 drivers/iommu/Makefile          |    1 +
 drivers/iommu/fsl_pamu.c        | 1063 +++++++++++++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu.h        |  401 +++++++++++++++
 drivers/iommu/fsl_pamu_domain.c |  996 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu_domain.h |   96 ++++
 6 files changed, 2565 insertions(+), 0 deletions(-)
 create mode 100644 drivers/iommu/fsl_pamu.c
 create mode 100644 drivers/iommu/fsl_pamu.h
 create mode 100644 drivers/iommu/fsl_pamu_domain.c
 create mode 100644 drivers/iommu/fsl_pamu_domain.h

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index e39f9db..f712da2 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -17,6 +17,14 @@ config OF_IOMMU
        def_bool y
        depends on OF
 
+config FSL_PAMU
+	bool "Freescale IOMMU support"
+	depends on PPC_E500MC
+	select IOMMU_API
+	select GENERIC_ALLOCATOR
+	help
+	  Freescale PAMU support.
+
 # MSM IOMMU support
 config MSM_IOMMU
 	bool "MSM IOMMU Support"
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 14a4d5f..a565ebe 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
 obj-$(CONFIG_TEGRA_IOMMU_GART) += tegra-gart.o
 obj-$(CONFIG_TEGRA_IOMMU_SMMU) += tegra-smmu.o
 obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
+obj-$(CONFIG_FSL_PAMU) += fsl_pamu.o fsl_pamu_domain.o
diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
new file mode 100644
index 0000000..3d9dd43
--- /dev/null
+++ b/drivers/iommu/fsl_pamu.c
@@ -0,0 +1,1063 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright (C) 2012 Freescale Semiconductor, Inc.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/iommu.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/of_platform.h>
+#include <linux/bootmem.h>
+#include <linux/genalloc.h>
+#include <asm/io.h>
+#include <asm/bitops.h>
+
+#include "fsl_pamu.h"
+
+/* PAMU bypass enbale register contains control bits for
+ * enabling bypass mode on each PAMU.
+ */
+#define PAMUBYPENR 0x604
+
+/* define indexes for each operation mapping scenario */
+#define OMI_QMAN        0x00
+#define OMI_FMAN        0x01
+#define OMI_QMAN_PRIV   0x02
+#define OMI_CAAM        0x03
+
+static paace_t *ppaact;
+static paace_t *spaact;
+static struct ome *omt;
+unsigned int max_subwindow_count;
+
+struct gen_pool *spaace_pool;
+
+static paace_t *pamu_get_ppaace(int liodn)
+{
+	if (!ppaact) {
+		pr_err("PPAACT doesn't exist\n");
+		return NULL;
+	}
+
+	return &ppaact[liodn];
+}
+
+/**  Sets validation bit of PACCE
+ *
+ * @parm[in] liodn PAACT index for desired PAACE
+ *
+ * @return Returns 0 upon success else error code < 0 returned
+ */
+int pamu_enable_liodn(int liodn)
+{
+	paace_t *ppaace;
+
+	ppaace = pamu_get_ppaace(liodn);
+	if (!ppaace)
+		return -ENOENT;
+
+	if (!get_bf(ppaace->addr_bitfields, PPAACE_AF_WSE)) {
+		pr_err("liodn %d not configured\n", liodn);
+		return -EINVAL;
+	}
+
+	/* Ensure that all other stores to the ppaace complete first */
+	mb();
+
+	ppaace->addr_bitfields |= PAACE_V_VALID;
+	mb();
+
+	return 0;
+}
+
+/** Clears validation bit of PACCE
+ *
+ * @parm[in]  liodn PAACT index for desired PAACE
+ *
+ * @return Returns 0 upon success else error code < 0 returned
+ */
+int pamu_disable_liodn(int liodn)
+{
+	paace_t *ppaace;
+
+	ppaace = pamu_get_ppaace(liodn);
+	if (!ppaace)
+		return -ENOENT;
+
+	set_bf(ppaace->addr_bitfields, PAACE_AF_V, PAACE_V_INVALID);
+	mb();
+
+	return 0;
+}
+
+
+static unsigned int map_addrspace_size_to_wse(phys_addr_t addrspace_size)
+{
+	BUG_ON((addrspace_size & (addrspace_size - 1)));
+
+	/* window size is 2^(WSE+1) bytes */
+	return __ffs(addrspace_size >> PAMU_PAGE_SHIFT) + PAMU_PAGE_SHIFT - 1;
+}
+
+static unsigned int map_subwindow_cnt_to_wce(u32 subwindow_cnt)
+{
+       /* window count is 2^(WCE+1) bytes */
+       return __ffs(subwindow_cnt) - 1;
+}
+
+static void pamu_setup_default_xfer_to_host_ppaace(paace_t *ppaace)
+{
+	set_bf(ppaace->addr_bitfields, PAACE_AF_PT, PAACE_PT_PRIMARY);
+
+	set_bf(ppaace->domain_attr.to_host.coherency_required, PAACE_DA_HOST_CR,
+	       PAACE_M_COHERENCE_REQ);
+}
+
+static void pamu_setup_default_xfer_to_host_spaace(paace_t *spaace)
+{
+	set_bf(spaace->addr_bitfields, PAACE_AF_PT, PAACE_PT_SECONDARY);
+	set_bf(spaace->domain_attr.to_host.coherency_required, PAACE_DA_HOST_CR,
+	       PAACE_M_COHERENCE_REQ);
+}
+
+static paace_t *pamu_get_spaace(u32 fspi_index, u32 wnum)
+{
+	return &spaact[fspi_index + wnum];
+}
+
+static unsigned long pamu_get_fspi_and_allocate(u32 subwin_cnt)
+{
+	unsigned long spaace_addr;
+
+	spaace_addr = gen_pool_alloc(spaace_pool, subwin_cnt * sizeof(paace_t));
+	if (!spaace_addr)
+		return ULONG_MAX;
+
+	return (spaace_addr - (unsigned long)spaact) / (sizeof(paace_t));
+}
+
+void pamu_free_subwins(int liodn)
+{
+	paace_t *ppaace;
+	u32 subwin_cnt, size;
+
+	ppaace = pamu_get_ppaace(liodn);
+	if (!ppaace)
+		return;
+
+	if (get_bf(ppaace->addr_bitfields, PPAACE_AF_MW)) {
+		subwin_cnt = 1UL << (get_bf(ppaace->impl_attr, PAACE_IA_WCE) + 1);
+		size = (subwin_cnt - 1) * sizeof(paace_t);
+		gen_pool_free(spaace_pool, (unsigned long)&spaact[ppaace->fspi], size);
+		set_bf(ppaace->addr_bitfields, PPAACE_AF_MW, 0);
+	}
+}
+
+/* Function used for updating stash destination for the coresspong LIODN.
+ */
+int  pamu_update_paace_stash(int liodn, u32 subwin, u32 value)
+{
+	paace_t *paace;
+
+	paace = pamu_get_ppaace(liodn);
+	if (!paace) {
+		return -ENOENT;
+	}
+	if (subwin) {
+		paace = pamu_get_spaace(paace->fspi, subwin - 1);
+		if (!paace) {
+			return -ENOENT;
+		}
+	}
+	set_bf(paace->impl_attr, PAACE_IA_CID, value);
+
+	return 0;
+}
+
+/** Sets up PPAACE entry for specified liodn
+ *
+ * @param[in] liodn      Logical IO device number
+ * @param[in] win_addr   starting address of DSA window
+ * @param[in] win-size   size of DSA window
+ * @param[in] omi        Operation mapping index -- if ~omi == 0 then omi not defined
+ * @param[in] rpn        real (true physical) page number
+ * @param[in] stashid    cache stash id for associated cpu -- if ~stashid == 0 then
+ *		         stashid not defined
+ * @param[in] snoopid    snoop id for hardware coherency -- if ~snoopid == 0 then
+ *		         snoopid not defined
+ * @param[in] subwin_cnt number of sub-windows
+ * @param[in] prot	 window permissions
+ *
+ * @return Returns 0 upon success else error code < 0 returned
+ */
+int pamu_config_ppaace(int liodn, phys_addr_t win_addr, phys_addr_t win_size,
+		       u32 omi, unsigned long rpn, u32 snoopid, u32 stashid,
+		       u32 subwin_cnt, int prot)
+{
+	paace_t *ppaace;
+	unsigned long fspi;
+
+	if ((win_size & (win_size - 1)) || win_size < PAMU_PAGE_SIZE) {
+		pr_err("window size too small or not a power of two %llx\n", win_size);
+		return -EINVAL;
+	}
+
+	if (win_addr & (win_size - 1)) {
+		pr_err("window address is not aligned with window size\n");
+		return -EINVAL;
+	}
+
+	ppaace = pamu_get_ppaace(liodn);
+	if (!ppaace) {
+		return -ENOENT;
+	}
+
+	/* window size is 2^(WSE+1) bytes */
+	set_bf(ppaace->addr_bitfields, PPAACE_AF_WSE,
+           map_addrspace_size_to_wse(win_size));
+
+	pamu_setup_default_xfer_to_host_ppaace(ppaace);
+
+	ppaace->wbah = win_addr >> (PAMU_PAGE_SHIFT + 20);
+	set_bf(ppaace->addr_bitfields, PPAACE_AF_WBAL,
+	       (win_addr >> PAMU_PAGE_SHIFT));
+
+	/* set up operation mapping if it's configured */
+	if (omi < OME_NUMBER_ENTRIES) {
+		set_bf(ppaace->impl_attr, PAACE_IA_OTM, PAACE_OTM_INDEXED);
+		ppaace->op_encode.index_ot.omi = omi;
+	} else if (~omi != 0) {
+		pr_err("bad operation mapping index: %d\n", omi);
+		return -EINVAL;
+	}
+
+	/* configure stash id */
+	if (~stashid != 0)
+		set_bf(ppaace->impl_attr, PAACE_IA_CID, stashid);
+
+	/* configure snoop id */
+	if (~snoopid != 0)
+		ppaace->domain_attr.to_host.snpid = snoopid;
+
+	if (subwin_cnt) {
+		/* The first entry is in the primary PAACE instead */
+		fspi = pamu_get_fspi_and_allocate(subwin_cnt - 1);
+		if (fspi == ULONG_MAX) {
+			pr_err("spaace indexes exhausted\n");
+		return -EINVAL;
+		}
+
+		/* window count is 2^(WCE+1) bytes */
+		set_bf(ppaace->impl_attr, PAACE_IA_WCE,
+		       map_subwindow_cnt_to_wce(subwin_cnt));
+		set_bf(ppaace->addr_bitfields, PPAACE_AF_MW, 0x1);
+		ppaace->fspi = fspi;
+	} else {
+		set_bf(ppaace->impl_attr, PAACE_IA_ATM, PAACE_ATM_WINDOW_XLATE);
+		ppaace->twbah = rpn >> 20;
+		set_bf(ppaace->win_bitfields, PAACE_WIN_TWBAL, rpn);
+		set_bf(ppaace->addr_bitfields, PAACE_AF_AP, prot);
+		set_bf(ppaace->impl_attr, PAACE_IA_WCE, 0);
+		set_bf(ppaace->addr_bitfields, PPAACE_AF_MW, 0);
+	}
+	mb();
+
+	return 0;
+}
+
+/** Sets up SPAACE entry for specified subwindow
+ *
+ * @param[in] liodn       Logical IO device number
+ * @param[in] subwin_cnt  number of sub-windows associated with dma-window
+ * @param[in] subwin_addr starting address of subwindow
+ * @param[in] subwin_size size of subwindow
+ * @param[in] omi         Operation mapping index
+ * @param[in] rpn         real (true physical) page number
+ * @param[in] snoopid     snoop id for hardware coherency -- if ~snoopid == 0 then
+ *			  snoopid not defined
+ * @param[in] stashid     cache stash id for associated cpu
+ * @param[in] enable      enable/disable subwindow after reconfiguration
+ * @param[in] prot        sub window permissions
+ *
+ * @return Returns 0 upon success else error code < 0 returned
+ */
+int pamu_config_spaace(int liodn, u32 subwin_cnt, u32 subwin_addr,
+		       phys_addr_t subwin_size, u32 omi, unsigned long rpn,
+		       u32 snoopid, u32 stashid, int enable, int prot)
+{
+	paace_t *paace;
+	unsigned long fspi;
+
+	/* setup sub-windows */
+	if (!subwin_cnt) {
+		pr_err("Invalid subwindow count\n");
+		return -EINVAL;
+	}
+
+	paace = pamu_get_ppaace(liodn);
+	if (subwin_addr > 0 && paace) {
+		fspi = paace->fspi;
+		paace = pamu_get_spaace(fspi, subwin_addr - 1);
+
+		if (paace && !(paace->addr_bitfields & PAACE_V_VALID)) {
+			pamu_setup_default_xfer_to_host_spaace(paace);
+			set_bf(paace->addr_bitfields, SPAACE_AF_LIODN, liodn);
+		}
+	}
+
+	if (!paace)
+		return -ENOENT;
+
+	if (!enable && prot == PAACE_AP_PERMS_DENIED) {
+		if (subwin_addr > 0)
+			set_bf(paace->addr_bitfields, PAACE_AF_V,
+				 PAACE_V_INVALID);
+		else
+			set_bf(paace->addr_bitfields, PAACE_AF_AP,
+				 prot);
+		mb();
+		return 0;
+	}
+
+	if (subwin_size & (subwin_size - 1) || subwin_size < PAMU_PAGE_SIZE) {
+		pr_err("subwindow size out of range, or not a power of 2\n");
+		return -EINVAL;
+	}
+
+	if (rpn == ULONG_MAX) {
+		pr_err("real page number out of range\n");
+		return -EINVAL;
+	}
+
+	/* window size is 2^(WSE+1) bytes */
+	set_bf(paace->win_bitfields, PAACE_WIN_SWSE,
+	       map_addrspace_size_to_wse(subwin_size));
+
+	set_bf(paace->impl_attr, PAACE_IA_ATM, PAACE_ATM_WINDOW_XLATE);
+	paace->twbah = rpn >> 20;
+	set_bf(paace->win_bitfields, PAACE_WIN_TWBAL, rpn);
+	set_bf(paace->addr_bitfields, PAACE_AF_AP, prot);
+
+	/* configure snoop id */
+	if (~snoopid != 0)
+		paace->domain_attr.to_host.snpid = snoopid;
+
+	/* set up operation mapping if it's configured */
+	if (omi < OME_NUMBER_ENTRIES) {
+		set_bf(paace->impl_attr, PAACE_IA_OTM, PAACE_OTM_INDEXED);
+		paace->op_encode.index_ot.omi = omi;
+	} else if (~omi != 0) {
+		pr_err("bad operation mapping index: %d\n", omi);
+		return -EINVAL;
+	}
+
+	if (~stashid != 0)
+		set_bf(paace->impl_attr, PAACE_IA_CID, stashid);
+
+	smp_wmb();
+
+	if (enable)
+		paace->addr_bitfields |= PAACE_V_VALID;
+
+	mb();
+
+	return 0;
+}
+
+void get_ome_index(u32 *omi_index, struct device *dev)
+{
+	if (of_device_is_compatible(dev->of_node, "fsl,qman-portal"))
+		*omi_index = OMI_QMAN;
+	if (of_device_is_compatible(dev->of_node, "fsl,qman"))
+		*omi_index = OMI_QMAN_PRIV;
+}
+
+u32 get_stash_id(u32 stash_dest_hint, u32 vcpu)
+{
+	const u32 *prop;
+	struct device_node *node;
+	u32 cache_level;
+	int len;
+
+	/* Fastpath, exit early if L3/CPC cache is target for stashing */
+	if (stash_dest_hint == IOMMU_ATTR_CACHE_L3) {
+		node = of_find_compatible_node(NULL, NULL,
+				"fsl,p4080-l3-cache-controller");
+		if (node) {
+			prop = of_get_property(node, "cache-stash-id", 0);
+			if (!prop) {
+				pr_err("missing cache-stash-id at %s\n", node->full_name);
+				of_node_put(node);
+				return ~(u32)0;
+			}
+			of_node_put(node);
+			return be32_to_cpup(prop);
+		}
+		return ~(u32)0;
+	}
+
+	for_each_node_by_type(node, "cpu") {
+		prop = of_get_property(node, "reg", &len);
+		if (be32_to_cpup(prop) == vcpu)
+			break;
+	}
+
+	/* find the hwnode that represents the cache */
+	for (cache_level = IOMMU_ATTR_CACHE_L1; cache_level <= IOMMU_ATTR_CACHE_L3; cache_level++) {
+		if (stash_dest_hint == cache_level) {
+			prop = of_get_property(node, "cache-stash-id", 0);
+			if (!prop) {
+				pr_err("missing cache-stash-id at %s\n", node->full_name);
+				of_node_put(node);
+				return ~(u32)0;
+			}
+			of_node_put(node);
+			return be32_to_cpup(prop);
+		}
+
+		prop = of_get_property(node, "next-level-cache", 0);
+		if (!prop) {
+			pr_err("can't find next-level-cache at %s\n",
+			          node->full_name);
+			of_node_put(node);
+			return ~(u32)0;  /* can't traverse any further */
+		}
+		of_node_put(node);
+
+		/* advance to next node in cache hierarchy */
+		node = of_find_node_by_phandle(*prop);
+		if (!node) {
+			pr_err("bad cpu reference %d\n", vcpu);
+			return ~(u32)0;
+		}
+	}
+
+	pr_err("stash dest not found for %d on vcpu %d\n",
+	          stash_dest_hint, vcpu);
+	return ~(u32)0;
+}
+
+#define QMAN_PAACE 1
+#define QMAN_PORTAL_PAACE 2
+#define BMAN_PAACE 3
+
+static void setup_qbman_paace(paace_t *ppaace, int paace_type)
+{
+	switch(paace_type) {
+		case QMAN_PAACE:
+			set_bf(ppaace->impl_attr, PAACE_IA_OTM, PAACE_OTM_INDEXED);
+			ppaace->op_encode.index_ot.omi = OMI_QMAN_PRIV;
+			/* setup QMAN Private data stashing for the L3 cache */
+			set_bf(ppaace->impl_attr, PAACE_IA_CID, get_stash_id(IOMMU_ATTR_CACHE_L3, 0));
+			set_bf(ppaace->domain_attr.to_host.coherency_required, PAACE_DA_HOST_CR,
+			       0);
+			break;
+		case QMAN_PORTAL_PAACE:
+			set_bf(ppaace->impl_attr, PAACE_IA_OTM, PAACE_OTM_INDEXED);
+			ppaace->op_encode.index_ot.omi = OMI_QMAN;
+			/*Set DQRR and Frame stashing for the L3 cache */
+			set_bf(ppaace->impl_attr, PAACE_IA_CID, get_stash_id(IOMMU_ATTR_CACHE_L3, 0));
+			break;
+		case BMAN_PAACE:
+			set_bf(ppaace->domain_attr.to_host.coherency_required, PAACE_DA_HOST_CR,
+			       0);
+			break;
+	}
+}
+
+static void __init setup_omt(struct ome *omt)
+{
+	struct ome *ome;
+
+	/* Configure OMI_QMAN */
+	ome = &omt[OMI_QMAN];
+
+	ome->moe[IOE_READ_IDX] = EOE_VALID | EOE_READ;
+	ome->moe[IOE_EREAD0_IDX] = EOE_VALID | EOE_RSA;
+	ome->moe[IOE_WRITE_IDX] = EOE_VALID | EOE_WRITE;
+	ome->moe[IOE_EWRITE0_IDX] = EOE_VALID | EOE_WWSAO;
+
+	ome->moe[IOE_DIRECT0_IDX] = EOE_VALID | EOE_LDEC;
+	ome->moe[IOE_DIRECT1_IDX] = EOE_VALID | EOE_LDECPE;
+
+	/* Configure OMI_FMAN */
+	ome = &omt[OMI_FMAN];
+	ome->moe[IOE_READ_IDX]  = EOE_VALID | EOE_READI;
+	ome->moe[IOE_WRITE_IDX] = EOE_VALID | EOE_WRITE;
+
+	/* Configure OMI_QMAN private */
+	ome = &omt[OMI_QMAN_PRIV];
+	ome->moe[IOE_READ_IDX]  = EOE_VALID | EOE_READ;
+	ome->moe[IOE_WRITE_IDX] = EOE_VALID | EOE_WRITE;
+	ome->moe[IOE_EREAD0_IDX] = EOE_VALID | EOE_RSA;
+	ome->moe[IOE_EWRITE0_IDX] = EOE_VALID | EOE_WWSA;
+
+	/* Configure OMI_CAAM */
+	ome = &omt[OMI_CAAM];
+	ome->moe[IOE_READ_IDX]  = EOE_VALID | EOE_READI;
+	ome->moe[IOE_WRITE_IDX] = EOE_VALID | EOE_WRITE;
+}
+
+int setup_one_pamu(unsigned long pamu_reg_base, unsigned long pamu_reg_size,
+	           phys_addr_t ppaact_phys, phys_addr_t spaact_phys,
+		   phys_addr_t omt_phys)
+{
+	u32 *pc;
+	struct pamu_mmap_regs *pamu_regs;
+	u32 pc3_val;
+
+	pc3_val = in_be32((u32 *)(pamu_reg_base + PAMU_PC3));
+	max_subwindow_count = 1 << (1 + PAMU_PC3_MWCE(pc3_val));
+
+	pc = (u32 *) (pamu_reg_base + PAMU_PC);
+	pamu_regs = (struct pamu_mmap_regs *)
+		(pamu_reg_base + PAMU_MMAP_REGS_BASE);
+
+	/* set up pointers to corenet control blocks */
+
+	out_be32(&pamu_regs->ppbah, ((u64)ppaact_phys) >> 32);
+	out_be32(&pamu_regs->ppbal, ppaact_phys);
+	ppaact_phys = ppaact_phys + PAACT_SIZE;
+	out_be32(&pamu_regs->pplah, ((u64)ppaact_phys) >> 32);
+	out_be32(&pamu_regs->pplal, ppaact_phys);
+
+	out_be32(&pamu_regs->spbah, ((u64)spaact_phys) >> 32);
+	out_be32(&pamu_regs->spbal, spaact_phys);
+	spaact_phys = spaact_phys + SPAACT_SIZE;
+	out_be32(&pamu_regs->splah, ((u64)spaact_phys) >> 32);
+	out_be32(&pamu_regs->splal, spaact_phys);
+
+	out_be32(&pamu_regs->obah, ((u64)omt_phys) >> 32);
+	out_be32(&pamu_regs->obal, omt_phys);
+	omt_phys = omt_phys + OMT_SIZE;
+	out_be32(&pamu_regs->olah, ((u64)omt_phys) >> 32);
+	out_be32(&pamu_regs->olal, omt_phys);
+
+	/*
+	 * set PAMU enable bit,
+	 * allow ppaact & omt to be cached
+	 * & enable PAMU access violation interrupts.
+	 */
+
+	out_be32((u32 *)(pamu_reg_base + PAMU_PICS),
+			PAMU_ACCESS_VIOLATION_ENABLE);
+	out_be32(pc, PAMU_PC_PE | PAMU_PC_OCE | PAMU_PC_SPCC | PAMU_PC_PPCC);
+	return 0;
+}
+
+static void __init setup_liodns(void)
+{
+	int i, len;
+	paace_t *ppaace;
+	struct device_node *node = NULL;
+	const u32 *prop;
+
+	for_each_node_with_property(node, "fsl,liodn") {
+		prop = of_get_property(node, "fsl,liodn", &len);
+		for (i = 0; i < len / sizeof(u32); i++) {
+			int liodn;
+
+			liodn = be32_to_cpup(&prop[i]);
+			ppaace = pamu_get_ppaace(liodn);
+			pamu_setup_default_xfer_to_host_ppaace(ppaace);
+			/* window size is 2^(WSE+1) bytes */
+			set_bf(ppaace->addr_bitfields, PPAACE_AF_WSE, 35);
+			ppaace->wbah = 0;
+			set_bf(ppaace->addr_bitfields, PPAACE_AF_WBAL, 0);
+			set_bf(ppaace->impl_attr, PAACE_IA_ATM,
+				PAACE_ATM_NO_XLATE);
+			set_bf(ppaace->addr_bitfields, PAACE_AF_AP, 
+				PAACE_AP_PERMS_ALL);
+			if (of_device_is_compatible(node, "fsl,qman-portal"))
+				setup_qbman_paace(ppaace, QMAN_PORTAL_PAACE);
+			if (of_device_is_compatible(node, "fsl,qman"))
+				setup_qbman_paace(ppaace, QMAN_PAACE);
+			if (of_device_is_compatible(node, "fsl,bman"))
+				setup_qbman_paace(ppaace, BMAN_PAACE);
+			mb();
+			pamu_enable_liodn(liodn);
+		}
+	}
+}
+
+irqreturn_t pamu_av_isr(int irq, void *arg)
+{
+	panic("FSL_PAMU: access violation interrupt\n");
+	/* NOTREACHED */
+
+	return IRQ_HANDLED;
+}
+
+#define LAWAR_EN		0x80000000
+#define LAWAR_TARGET_MASK	0x0FF00000
+#define LAWAR_TARGET_SHIFT	20
+#define LAWAR_SIZE_MASK		0x0000003F
+#define LAWAR_CSDID_MASK	0x000FF000
+#define LAWAR_CSDID_SHIFT	12
+
+#define LAW_SIZE_4K		0xb
+
+struct ccsr_law {
+	u32	lawbarh;	/* LAWn base address high */
+	u32	lawbarl;	/* LAWn base address low */
+	u32	lawar;		/* LAWn attributes */
+	u32	reserved;
+};
+
+#define make64(high, low) (((u64)(high) << 32) | (low))
+
+/*
+ * Create a coherence subdomain for a given memory block.
+ */
+static int __init create_csd(phys_addr_t phys, size_t size, u32 csd_port_id)
+{
+	struct device_node *np;
+	const __be32 *iprop;
+	void __iomem *lac = NULL;	/* Local Access Control registers */
+	struct ccsr_law __iomem *law;
+	void __iomem *ccm = NULL;
+	u32 __iomem *csdids;
+	unsigned int i, num_laws, num_csds;
+	u32 law_target = 0;
+	u32 csd_id = 0;
+	int ret = 0;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,corenet-law");
+	if (!np)
+		return -ENODEV;
+
+	iprop = of_get_property(np, "fsl,num-laws", NULL);
+	if (!iprop) {
+		ret = -ENODEV;
+		goto error;
+	}
+
+	num_laws = be32_to_cpup(iprop);
+	if (!num_laws) {
+		ret = -ENODEV;
+		goto error;
+	}
+
+	lac = of_iomap(np, 0);
+	if (!lac) {
+		ret = -ENODEV;
+		goto error;
+	}
+
+	/* LAW registers are at offset 0xC00 */
+	law = lac + 0xC00;
+
+	of_node_put(np);
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,corenet-cf");
+	if (!np) {
+		ret = -ENODEV;
+		goto error;
+	}
+
+	iprop = of_get_property(np, "fsl,ccf-num-csdids", NULL);
+	if (!iprop) {
+		ret = -ENODEV;
+		goto error;
+	}
+
+	num_csds = be32_to_cpup(iprop);
+	if (!num_csds) {
+		ret = -ENODEV;
+		goto error;
+	}
+
+	ccm = of_iomap(np, 0);
+	if (!ccm) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	/* The undocumented CSDID registers are at offset 0x600 */
+	csdids = ccm + 0x600;
+
+	of_node_put(np);
+	np = NULL;
+
+	/* Find an unused coherence subdomain ID */
+	for (csd_id = 0; csd_id < num_csds; csd_id++) {
+		if (!csdids[csd_id])
+			break;
+	}
+
+	/* Store the Port ID in the (undocumented) proper CIDMRxx register */
+	csdids[csd_id] = csd_port_id;
+
+	/* Find the DDR LAW that maps to our buffer. */
+	for (i = 0; i < num_laws; i++) {
+		if (law[i].lawar & LAWAR_EN) {
+			phys_addr_t law_start, law_end;
+
+			law_start = make64(law[i].lawbarh, law[i].lawbarl);
+			law_end = law_start +
+				(2ULL << (law[i].lawar & LAWAR_SIZE_MASK));
+
+			if (law_start <= phys && phys < law_end) {
+				law_target = law[i].lawar & LAWAR_TARGET_MASK;
+				break;
+			}
+		}
+	}
+
+	if (i == 0 || i == num_laws) {
+		/* This should never happen*/
+		ret = -ENOENT;
+		goto error;
+	}
+
+	/* Find a free LAW entry */
+	while (law[--i].lawar & LAWAR_EN) {
+		if (i == 0) {
+			/* No higher priority LAW slots available */
+			ret = -ENOENT;
+			goto error;
+		}
+	}
+
+	law[i].lawbarh = upper_32_bits(phys);
+	law[i].lawbarl = lower_32_bits(phys);
+	wmb();
+	law[i].lawar = LAWAR_EN | law_target | (csd_id << LAWAR_CSDID_SHIFT) |
+		(LAW_SIZE_4K + get_order(size));
+	wmb();
+
+error:
+	if (ccm)
+		iounmap(ccm);
+
+	if (lac)
+		iounmap(lac);
+
+	if (np)
+		of_node_put(np);
+
+	return ret;
+}
+
+/*
+ * Table of SVRs and the corresponding PORT_ID values.
+ *
+ * All future CoreNet-enabled SOCs will have this erratum fixed, so this table
+ * should never need to be updated.  SVRs are guaranteed to be unique, so
+ * there is no worry that a future SOC will inadvertently have one of these
+ * values.
+ */
+static const struct {
+	u32 svr;
+	u32 port_id;
+} port_id_map[] = {
+	{0x82100010, 0xFF000000},	/* P2040 1.0 */
+	{0x82100011, 0xFF000000},	/* P2040 1.1 */
+	{0x82100110, 0xFF000000},	/* P2041 1.0 */
+	{0x82100111, 0xFF000000},	/* P2041 1.1 */
+	{0x82110310, 0xFF000000},	/* P3041 1.0 */
+	{0x82110311, 0xFF000000},	/* P3041 1.1 */
+	{0x82010020, 0xFFF80000},	/* P4040 2.0 */
+	{0x82000020, 0xFFF80000},	/* P4080 2.0 */
+	{0x82210010, 0xFC000000},       /* P5010 1.0 */
+	{0x82210020, 0xFC000000},       /* P5010 2.0 */
+	{0x82200010, 0xFC000000},	/* P5020 1.0 */
+	{0x82050010, 0xFF800000},	/* P5021 1.0 */
+	{0x82040010, 0xFF800000},	/* P5040 1.0 */
+};
+
+#define SVR_SECURITY	0x80000	/* The Security (E) bit */
+
+static int __init fsl_pamu_probe(struct platform_device *pdev)
+{
+	void __iomem *pamu_regs = NULL;
+	void __iomem *guts_regs = NULL;
+	u32 pamubypenr, pamu_counter;
+	unsigned long pamu_reg_off;
+	unsigned long pamu_reg_base;
+	struct device_node *guts_node;
+	u64 size;
+	struct page *p;
+	int ret = 0;
+	int irq;
+	phys_addr_t ppaact_phys;
+	phys_addr_t spaact_phys;
+	phys_addr_t omt_phys;
+	size_t mem_size = 0;
+	unsigned int order = 0;
+	u32 csd_port_id = 0;
+	unsigned i;
+	/*
+	 * enumerate all PAMUs and allocate and setup PAMU tables
+	 * for each of them,
+	 * NOTE : All PAMUs share the same LIODN tables.
+	 */
+
+	pamu_regs = of_iomap(pdev->dev.of_node, 0);
+	if (!pamu_regs) {
+		dev_err(&pdev->dev, "ioremap of PAMU node failed\n");
+		return -ENOMEM;
+	}
+	of_get_address(pdev->dev.of_node, 0, &size, NULL);
+
+	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	if (irq == NO_IRQ) {
+		dev_warn(&pdev->dev, "no interrupts listed in PAMU node\n");
+		goto error;
+	}
+
+	ret = request_irq(irq, pamu_av_isr, IRQF_DISABLED, "pamu", NULL);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "error %i installing ISR for irq %i\n",
+			ret, irq);
+		goto error;
+	}
+
+	guts_node = of_find_compatible_node(NULL, NULL,
+			"fsl,qoriq-device-config-1.0");
+	if (!guts_node) {
+		dev_err(&pdev->dev, "could not find GUTS node %s\n",
+			pdev->dev.of_node->full_name);
+		ret = -ENODEV;
+		goto error;
+	}
+
+	guts_regs = of_iomap(guts_node, 0);
+	of_node_put(guts_node);
+	if (!guts_regs) {
+		dev_err(&pdev->dev, "ioremap of GUTS node failed\n");
+		ret = -ENODEV;
+		goto error;
+	}
+
+	/*
+	 * To simplify the allocation of a coherency domain, we allocate the
+	 * PAACT and the OMT in the same memory buffer.  Unfortunately, this
+	 * wastes more memory compared to allocating the buffers separately.
+	 */
+
+	/* Determine how much memory we need */
+	mem_size = (PAGE_SIZE << get_order(PAACT_SIZE)) +
+		(PAGE_SIZE << get_order(SPAACT_SIZE)) +
+		(PAGE_SIZE << get_order(OMT_SIZE));
+	order = get_order(mem_size);
+
+	p = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	if (!p) {
+		dev_err(&pdev->dev, "unable to allocate PAACT/SPAACT/OMT block\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	ppaact = page_address(p);
+	ppaact_phys = page_to_phys(p);
+
+	/* Make sure the memory is naturally aligned */
+	if (ppaact_phys & ((PAGE_SIZE << order) - 1)) {
+		dev_err(&pdev->dev, "PAACT/OMT block is unaligned\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	spaact = (void *)ppaact + (PAGE_SIZE << get_order(PAACT_SIZE));
+	omt = (void *)spaact + (PAGE_SIZE << get_order(SPAACT_SIZE));
+
+	dev_dbg(&pdev->dev, "ppaact virt=%p phys=0x%llx\n", ppaact,
+		(unsigned long long) ppaact_phys);
+
+	/* Check to see if we need to implement the work-around on this SOC */
+
+	/* Determine the Port ID for our coherence subdomain */
+	for (i = 0; i < ARRAY_SIZE(port_id_map); i++) {
+		if (port_id_map[i].svr == (mfspr(SPRN_SVR) & ~SVR_SECURITY)) {
+			csd_port_id = port_id_map[i].port_id;
+			dev_dbg(&pdev->dev, "found matching SVR %08x\n",
+				port_id_map[i].svr);
+			break;
+		}
+	}
+
+	if (csd_port_id) {
+		dev_dbg(&pdev->dev, "creating coherency subdomain at address "
+			"0x%llx, size %zu, port id 0x%08x", ppaact_phys,
+			mem_size, csd_port_id);
+
+		ret = create_csd(ppaact_phys, mem_size, csd_port_id);
+		if (ret) {
+			dev_err(&pdev->dev, "could not create coherence "
+				"subdomain\n");
+			return ret;
+		}
+	}
+
+	spaact_phys = virt_to_phys(spaact);
+	omt_phys = virt_to_phys(omt);
+
+	spaace_pool = gen_pool_create(ilog2(sizeof(paace_t)), -1);
+	if (!spaace_pool) {
+		ret = -ENOMEM;
+		pr_err("PAMU : failed to allocate spaace gen pool\n");
+		goto error;
+	}
+
+	ret = gen_pool_add(spaace_pool, (unsigned long)spaact, SPAACT_SIZE, -1);
+	if (ret)
+		goto error_genpool;
+
+	pamubypenr = in_be32(guts_regs + PAMUBYPENR);
+
+	for (pamu_reg_off = 0, pamu_counter = 0x80000000; pamu_reg_off < size;
+	     pamu_reg_off += PAMU_OFFSET, pamu_counter >>= 1) {
+
+		pamu_reg_base = (unsigned long) pamu_regs + pamu_reg_off;
+		setup_one_pamu(pamu_reg_base, pamu_reg_off, ppaact_phys,
+				 spaact_phys, omt_phys);
+		/* Disable PAMU bypass for this PAMU */
+		pamubypenr &= ~pamu_counter;
+	}
+
+	setup_omt(omt);
+
+	/* Enable all relevant PAMU(s) */
+	out_be32(guts_regs + PAMUBYPENR, pamubypenr);
+
+	iounmap(pamu_regs);
+	iounmap(guts_regs);
+
+	/* Enable DMA for the LIODNs in the device tree*/
+
+	setup_liodns();
+
+	return 0;
+
+error_genpool:
+	gen_pool_destroy(spaace_pool);
+
+error:
+	if (irq != NO_IRQ)
+		free_irq(irq, 0);
+
+	if (pamu_regs)
+		iounmap(pamu_regs);
+
+	if (guts_regs)
+		iounmap(guts_regs);
+
+	if (ppaact)
+		free_pages((unsigned long)ppaact, order);
+
+	ppaact = NULL;
+
+	return ret;
+}
+
+static const struct of_device_id fsl_of_pamu_ids[] = {
+	{
+		.compatible = "fsl,p4080-pamu",
+	},
+	{
+		.compatible = "fsl,pamu",
+	},
+	{},
+};
+
+static struct platform_driver fsl_of_pamu_driver = {
+	.driver = {
+		.name = "fsl-of-pamu",
+		.owner = THIS_MODULE,
+	},
+	.probe = fsl_pamu_probe,
+};
+
+static __init int fsl_pamu_init(void)
+{
+	struct platform_device *pdev = NULL;
+	struct device_node *np;
+	int ret;
+
+	/*
+	 * The normal OF process calls the probe function at some
+	 * indeterminate later time, after most drivers have loaded.  This is
+	 * too late for us, because PAMU clients (like the Qman driver)
+	 * depend on PAMU being initialized early.
+	 *
+	 * So instead, we "manually" call our probe function by creating the
+	 * platform devices ourselves.
+	 */
+
+	/*
+	 * We assume that there is only one PAMU node in the device tree.  A
+	 * single PAMU node represents all of the PAMU devices in the SOC
+	 * already.   Everything else already makes that assumption, and the
+	 * binding for the PAMU nodes doesn't allow for any parent-child
+	 * relationships anyway.  In other words, support for more than one
+	 * PAMU node would require significant changes to a lot of code.
+	 */
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,pamu");
+	if (!np) {
+		pr_err("fsl-pamu: could not find a PAMU node\n");
+		return -ENODEV;
+	}
+
+	ret = platform_driver_register(&fsl_of_pamu_driver);
+	if (ret) {
+		pr_err("fsl-pamu: could not register driver (err=%i)\n", ret);
+		goto error_driver_register;
+	}
+
+	pdev = platform_device_alloc("fsl-of-pamu", 0);
+	if (!pdev) {
+		pr_err("fsl-pamu: could not allocate device %s\n",
+		       np->full_name);
+		ret = -ENOMEM;
+		goto error_device_alloc;
+	}
+	pdev->dev.of_node = of_node_get(np);
+
+	ret = pamu_domain_init();
+	if (ret)
+		goto error_device_add;
+
+	ret = platform_device_add(pdev);
+	if (ret) {
+		pr_err("fsl-pamu: could not add device %s (err=%i)\n",
+		       np->full_name, ret);
+		goto error_device_add;
+	}
+
+	return 0;
+
+error_device_add:
+	of_node_put(pdev->dev.of_node);
+	pdev->dev.of_node = NULL;
+
+	platform_device_put(pdev);
+
+error_device_alloc:
+	platform_driver_unregister(&fsl_of_pamu_driver);
+
+error_driver_register:
+	of_node_put(np);
+
+	return ret;
+}
+subsys_initcall(fsl_pamu_init);
diff --git a/drivers/iommu/fsl_pamu.h b/drivers/iommu/fsl_pamu.h
new file mode 100644
index 0000000..81eb9af
--- /dev/null
+++ b/drivers/iommu/fsl_pamu.h
@@ -0,0 +1,401 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright (C) 2012 Freescale Semiconductor, Inc.
+ *
+ */
+
+#ifndef __FSL_PAMU_H
+#define __FSL_PAMU_H
+
+
+/* Bit Field macros
+ * 	v = bit field variable; m = mask, m##_SHIFT = shift, x = value to load
+ */
+#define set_bf(v, m, x)		(v = ((v) & ~(m)) | (((x) << (m##_SHIFT)) & (m)))
+#define get_bf(v, m)		(((v) & (m)) >> (m##_SHIFT))
+
+/* PAMU CCSR space */
+#define PAMU_PGC 0x00000000     /* Allows all peripheral accesses */
+#define PAMU_PE 0x40000000      /* enable PAMU                    */
+
+/* PAMU_OFFSET to the next pamu space in ccsr */
+#define PAMU_OFFSET 0x1000
+
+#define PAMU_MMAP_REGS_BASE 0
+
+struct pamu_mmap_regs {
+	u32 ppbah;
+	u32 ppbal;
+	u32 pplah;
+	u32 pplal;
+	u32 spbah;
+	u32 spbal;
+	u32 splah;
+	u32 splal;
+	u32 obah;
+	u32 obal;
+	u32 olah;
+	u32 olal;
+};
+
+/* PAMU Error Registers */
+#define PAMU_POES1 0x0040
+#define PAMU_POES2 0x0044
+#define PAMU_POEAH 0x0048
+#define PAMU_POEAL 0x004C
+#define PAMU_AVS1  0x0050
+#define PAMU_AVS1_AV    0x1
+#define PAMU_AVS1_OTV   0x6
+#define PAMU_AVS1_APV   0x78
+#define PAMU_AVS1_WAV   0x380
+#define PAMU_AVS1_LAV   0x1c00
+#define PAMU_AVS1_GCV   0x2000
+#define PAMU_AVS1_PDV   0x4000
+#define PAMU_AV_MASK    (PAMU_AVS1_AV | PAMU_AVS1_OTV | PAMU_AVS1_APV | PAMU_AVS1_WAV \
+			| PAMU_AVS1_LAV | PAMU_AVS1_GCV | PAMU_AVS1_PDV)
+#define PAMU_AVS1_LIODN_SHIFT 16
+#define PAMU_LAV_LIODN_NOT_IN_PPAACT 0x400
+
+#define PAMU_AVS2  0x0054
+#define PAMU_AVAH  0x0058
+#define PAMU_AVAL  0x005C
+#define PAMU_EECTL 0x0060
+#define PAMU_EEDIS 0x0064
+#define PAMU_EEINTEN 0x0068
+#define PAMU_EEDET 0x006C
+#define PAMU_EEATTR 0x0070
+#define PAMU_EEAHI 0x0074
+#define PAMU_EEALO 0x0078
+#define PAMU_EEDHI 0X007C
+#define PAMU_EEDLO 0x0080
+#define PAMU_EECC  0x0084
+
+/* PAMU Revision Registers */
+#define PAMU_PR1 0x0BF8
+#define PAMU_PR2 0x0BFC
+
+/* PAMU Capabilities Registers */
+#define PAMU_PC1 0x0C00
+#define PAMU_PC2 0x0C04
+#define PAMU_PC3 0x0C08
+#define PAMU_PC4 0x0C0C
+
+/* PAMU Control Register */
+#define PAMU_PC 0x0C10
+
+/* PAMU control defs */
+#define PAMU_CONTROL 0x0C10
+#define PAMU_PC_PGC 0x80000000 /* 1 = PAMU Gate Closed : block all
+peripheral access, 0 : may allow peripheral access */
+
+#define PAMU_PC_PE   0x40000000 /* 0 = PAMU disabled, 1 = PAMU enabled */
+#define PAMU_PC_SPCC 0x00000010 /* sPAACE cache enable */
+#define PAMU_PC_PPCC 0x00000001 /* pPAACE cache enable */
+#define PAMU_PC_OCE  0x00001000 /* OMT cache enable */
+
+#define PAMU_PFA1 0x0C14
+#define PAMU_PFA2 0x0C18
+
+#define PAMU_PC3_MWCE(X) (((X) >> 21) & 0xf)
+
+/* PAMU Interrupt control and Status Register */
+#define PAMU_PICS 0x0C1C
+#define PAMU_ACCESS_VIOLATION_STAT   0x8
+#define PAMU_ACCESS_VIOLATION_ENABLE 0x4
+
+/* PAMU Debug Registers */
+#define PAMU_PD1 0x0F00
+#define PAMU_PD2 0x0F04
+#define PAMU_PD3 0x0F08
+#define PAMU_PD4 0x0F0C
+
+#define PAACE_AP_PERMS_DENIED  0x0
+#define PAACE_AP_PERMS_QUERY   0x1
+#define PAACE_AP_PERMS_UPDATE  0x2
+#define PAACE_AP_PERMS_ALL     0x3
+
+#define PAACE_DD_TO_HOST       0x0
+#define PAACE_DD_TO_IO         0x1
+#define PAACE_PT_PRIMARY       0x0
+#define PAACE_PT_SECONDARY     0x1
+#define PAACE_V_INVALID        0x0
+#define PAACE_V_VALID          0x1
+#define PAACE_MW_SUBWINDOWS    0x1
+
+#define PAACE_WSE_4K           0xB
+#define PAACE_WSE_8K           0xC
+#define PAACE_WSE_16K          0xD
+#define PAACE_WSE_32K          0xE
+#define PAACE_WSE_64K          0xF
+#define PAACE_WSE_128K         0x10
+#define PAACE_WSE_256K         0x11
+#define PAACE_WSE_512K         0x12
+#define PAACE_WSE_1M           0x13
+#define PAACE_WSE_2M           0x14
+#define PAACE_WSE_4M           0x15
+#define PAACE_WSE_8M           0x16
+#define PAACE_WSE_16M          0x17
+#define PAACE_WSE_32M          0x18
+#define PAACE_WSE_64M          0x19
+#define PAACE_WSE_128M         0x1A
+#define PAACE_WSE_256M         0x1B
+#define PAACE_WSE_512M         0x1C
+#define PAACE_WSE_1G           0x1D
+#define PAACE_WSE_2G           0x1E
+#define PAACE_WSE_4G           0x1F
+
+#define PAACE_DID_PCI_EXPRESS_1 0x00
+#define PAACE_DID_PCI_EXPRESS_2 0x01
+#define PAACE_DID_PCI_EXPRESS_3 0x02
+#define PAACE_DID_PCI_EXPRESS_4 0x03
+#define PAACE_DID_LOCAL_BUS     0x04
+#define PAACE_DID_SRIO          0x0C
+#define PAACE_DID_MEM_1         0x10
+#define PAACE_DID_MEM_2         0x11
+#define PAACE_DID_MEM_3         0x12
+#define PAACE_DID_MEM_4         0x13
+#define PAACE_DID_MEM_1_2       0x14
+#define PAACE_DID_MEM_3_4       0x15
+#define PAACE_DID_MEM_1_4       0x16
+#define PAACE_DID_BM_SW_PORTAL  0x18
+#define PAACE_DID_PAMU          0x1C
+#define PAACE_DID_CAAM          0x21
+#define PAACE_DID_QM_SW_PORTAL  0x3C
+#define PAACE_DID_CORE0_INST    0x80
+#define PAACE_DID_CORE0_DATA    0x81
+#define PAACE_DID_CORE1_INST    0x82
+#define PAACE_DID_CORE1_DATA    0x83
+#define PAACE_DID_CORE2_INST    0x84
+#define PAACE_DID_CORE2_DATA    0x85
+#define PAACE_DID_CORE3_INST    0x86
+#define PAACE_DID_CORE3_DATA    0x87
+#define PAACE_DID_CORE4_INST    0x88
+#define PAACE_DID_CORE4_DATA    0x89
+#define PAACE_DID_CORE5_INST    0x8A
+#define PAACE_DID_CORE5_DATA    0x8B
+#define PAACE_DID_CORE6_INST    0x8C
+#define PAACE_DID_CORE6_DATA    0x8D
+#define PAACE_DID_CORE7_INST    0x8E
+#define PAACE_DID_CORE7_DATA    0x8F
+#define PAACE_DID_BROADCAST     0xFF
+
+#define PAACE_ATM_NO_XLATE      0x00
+#define PAACE_ATM_WINDOW_XLATE  0x01
+#define PAACE_ATM_PAGE_XLATE    0x02
+#define PAACE_ATM_WIN_PG_XLATE  \
+                ( PAACE_ATM_WINDOW_XLATE | PAACE_ATM_PAGE_XLATE )
+#define PAACE_OTM_NO_XLATE      0x00
+#define PAACE_OTM_IMMEDIATE     0x01
+#define PAACE_OTM_INDEXED       0x02
+#define PAACE_OTM_RESERVED      0x03
+
+#define PAACE_M_COHERENCE_REQ   0x01
+
+#define PAACE_PID_0             0x0
+#define PAACE_PID_1             0x1
+#define PAACE_PID_2             0x2
+#define PAACE_PID_3             0x3
+#define PAACE_PID_4             0x4
+#define PAACE_PID_5             0x5
+#define PAACE_PID_6             0x6
+#define PAACE_PID_7             0x7
+
+#define PAACE_TCEF_FORMAT0_8B   0x00
+#define PAACE_TCEF_FORMAT1_RSVD 0x01
+
+#define PAACE_NUMBER_ENTRIES    0xFF
+
+#define	OME_NUMBER_ENTRIES      16
+
+#define SPAACE_NUMBER_ENTRIES   0x8000
+
+/* PAACE Bit Field Defines */
+#define PPAACE_AF_WBAL			0xfffff000
+#define PPAACE_AF_WBAL_SHIFT		12
+#define PPAACE_AF_WSE			0x00000fc0
+#define PPAACE_AF_WSE_SHIFT		6
+#define PPAACE_AF_MW			0x00000020
+#define PPAACE_AF_MW_SHIFT		5
+
+#define SPAACE_AF_LIODN			0xffff0000
+#define SPAACE_AF_LIODN_SHIFT		16
+
+#define PAACE_AF_AP			0x00000018
+#define PAACE_AF_AP_SHIFT		3
+#define PAACE_AF_DD			0x00000004
+#define PAACE_AF_DD_SHIFT		2
+#define PAACE_AF_PT			0x00000002
+#define PAACE_AF_PT_SHIFT		1
+#define PAACE_AF_V			0x00000001
+#define PAACE_AF_V_SHIFT		0
+
+#define PAACE_DA_HOST_CR		0x80
+#define PAACE_DA_HOST_CR_SHIFT		7
+
+#define PAACE_IA_CID			0x00FF0000
+#define PAACE_IA_CID_SHIFT		16
+#define PAACE_IA_WCE			0x000000F0
+#define PAACE_IA_WCE_SHIFT		4
+#define PAACE_IA_ATM			0x0000000C
+#define PAACE_IA_ATM_SHIFT		2
+#define PAACE_IA_OTM			0x00000003
+#define PAACE_IA_OTM_SHIFT		0
+
+#define PAACE_WIN_TWBAL			0xfffff000
+#define PAACE_WIN_TWBAL_SHIFT		12
+#define PAACE_WIN_SWSE			0x00000fc0
+#define PAACE_WIN_SWSE_SHIFT		6
+
+/* PAMU Data Structures */
+/* primary / secondary paact structure */
+typedef struct paace_t {
+	/* PAACE Offset 0x00 */
+	u32 wbah;				/* only valid for Primary PAACE */
+	u32 addr_bitfields;		/* See P/S PAACE_AF_* */
+
+	/* PAACE Offset 0x08 */
+	/* Interpretation of first 32 bits dependent on DD above */
+	union {
+		struct {
+			/* Destination ID, see PAACE_DID_* defines */
+			u8 did;
+			/* Partition ID */
+			u8 pid;
+			/* Snoop ID */
+			u8 snpid;
+			/* coherency_required : 1 reserved : 7 */
+			u8 coherency_required; /* See PAACE_DA_* */
+		} to_host;
+		struct {
+			/* Destination ID, see PAACE_DID_* defines */
+			u8  did;
+			u8  reserved1;
+			u16 reserved2;
+		} to_io;
+	} domain_attr;
+
+	/* Implementation attributes + window count + address & operation translation modes */
+	u32 impl_attr;			/* See PAACE_IA_* */
+
+	/* PAACE Offset 0x10 */
+	/* Translated window base address */
+	u32 twbah;
+	u32 win_bitfields;			/* See PAACE_WIN_* */
+
+	/* PAACE Offset 0x18 */
+	/* first secondary paace entry */
+	u32 fspi;				/* only valid for Primary PAACE */
+	union {
+		struct {
+			u8 ioea;
+			u8 moea;
+			u8 ioeb;
+			u8 moeb;
+		} immed_ot;
+		struct {
+			u16 reserved;
+			u16 omi;
+		} index_ot;
+	} op_encode;
+
+	/* PAACE Offsets 0x20-0x38 */
+	u32 reserved[8];			/* not currently implemented */
+} paace_t;
+
+/* OME : Operation mapping entry
+ * MOE : Mapped Operation Encodings
+ * The operation mapping table is table containing operation mapping entries (OME).
+ * The index of a particular OME is programmed in the PAACE entry for translation
+ * in bound I/O operations corresponding to an LIODN. The OMT is used for translation
+ * specifically in case of the indexed translation mode. Each OME contains a 128
+ * byte mapped operation encoding (MOE), where each byte represents an MOE. 
+ */
+#define NUM_MOE 128
+struct ome {
+	u8 moe[NUM_MOE];
+} __attribute__((packed));
+
+#define PAACT_SIZE              (sizeof(paace_t) * PAACE_NUMBER_ENTRIES)
+#define OMT_SIZE                (sizeof(struct ome) * OME_NUMBER_ENTRIES)
+#define SPAACT_SIZE             (sizeof(paace_t) * SPAACE_NUMBER_ENTRIES)
+
+#define PAMU_PAGE_SHIFT 12
+#define PAMU_PAGE_SIZE  4096ULL
+
+#define IOE_READ        0x00
+#define IOE_READ_IDX    0x00
+#define IOE_WRITE       0x81
+#define IOE_WRITE_IDX   0x01
+#define IOE_EREAD0      0x82    /* Enhanced read type 0 */
+#define IOE_EREAD0_IDX  0x02    /* Enhanced read type 0 */
+#define IOE_EWRITE0     0x83    /* Enhanced write type 0 */
+#define IOE_EWRITE0_IDX 0x03    /* Enhanced write type 0 */
+#define IOE_DIRECT0     0x84    /* Directive type 0 */
+#define IOE_DIRECT0_IDX 0x04    /* Directive type 0 */
+#define IOE_EREAD1      0x85    /* Enhanced read type 1 */
+#define IOE_EREAD1_IDX  0x05    /* Enhanced read type 1 */
+#define IOE_EWRITE1     0x86    /* Enhanced write type 1 */
+#define IOE_EWRITE1_IDX 0x06    /* Enhanced write type 1 */
+#define IOE_DIRECT1     0x87    /* Directive type 1 */
+#define IOE_DIRECT1_IDX 0x07    /* Directive type 1 */
+#define IOE_RAC         0x8c    /* Read with Atomic clear */
+#define IOE_RAC_IDX     0x0c    /* Read with Atomic clear */
+#define IOE_RAS         0x8d    /* Read with Atomic set */
+#define IOE_RAS_IDX     0x0d    /* Read with Atomic set */
+#define IOE_RAD         0x8e    /* Read with Atomic decrement */
+#define IOE_RAD_IDX     0x0e    /* Read with Atomic decrement */
+#define IOE_RAI         0x8f    /* Read with Atomic increment */
+#define IOE_RAI_IDX     0x0f    /* Read with Atomic increment */
+
+#define EOE_READ        0x00
+#define EOE_WRITE       0x01
+#define EOE_RAC         0x0c    /* Read with Atomic clear */
+#define EOE_RAS         0x0d    /* Read with Atomic set */
+#define EOE_RAD         0x0e    /* Read with Atomic decrement */
+#define EOE_RAI         0x0f    /* Read with Atomic increment */
+#define EOE_LDEC        0x10    /* Load external cache */
+#define EOE_LDECL       0x11    /* Load external cache with stash lock */
+#define EOE_LDECPE      0x12    /* Load external cache with preferred exclusive */
+#define EOE_LDECPEL     0x13    /* Load external cache with preferred exclusive and lock */
+#define EOE_LDECFE      0x14    /* Load external cache with forced exclusive */
+#define EOE_LDECFEL     0x15    /* Load external cache with forced exclusive and lock */
+#define EOE_RSA         0x16    /* Read with stash allocate */
+#define EOE_RSAU        0x17    /* Read with stash allocate and unlock */
+#define EOE_READI       0x18    /* Read with invalidate */
+#define EOE_RWNITC      0x19    /* Read with no intention to cache */
+#define EOE_WCI         0x1a    /* Write cache inhibited */
+#define EOE_WWSA        0x1b    /* Write with stash allocate */
+#define EOE_WWSAL       0x1c    /* Write with stash allocate and lock */
+#define EOE_WWSAO       0x1d    /* Write with stash allocate only */
+#define EOE_WWSAOL      0x1e    /* Write with stash allocate only and lock */
+#define EOE_VALID       0x80
+
+/* Function prototypes */
+int pamu_domain_init(void);
+int pamu_enable_liodn(int liodn);
+int pamu_disable_liodn(int liodn);
+void pamu_free_subwins(int liodn);
+int pamu_config_ppaace(int liodn, phys_addr_t win_addr, phys_addr_t win_size,
+		       u32 omi, unsigned long rpn, u32 snoopid, uint32_t stashid,
+		       u32 subwin_cnt, int prot);
+int pamu_config_spaace(int liodn, u32 subwin_cnt, u32 subwin_addr,
+		       phys_addr_t subwin_size, u32 omi, unsigned long rpn,
+		       uint32_t snoopid, u32 stashid, int enable, int prot);
+
+u32 get_stash_id(u32 stash_dest_hint, u32 vcpu);
+void get_ome_index(u32 *omi_index, struct device *dev);
+int  pamu_update_paace_stash(int liodn, u32 subwin, u32 value);
+
+#endif  /* __FSL_PAMU_H */
diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
new file mode 100644
index 0000000..16f1b78
--- /dev/null
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -0,0 +1,996 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright (C) 2012 Freescale Semiconductor, Inc.
+ * Author: Varun Sethi <varun.sethi@freescale.com>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/iommu.h>
+#include <linux/notifier.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/of_platform.h>
+#include <linux/bootmem.h>
+#include <linux/err.h>
+#include <asm/io.h>
+#include <asm/bitops.h>
+
+#include "fsl_pamu_domain.h"
+
+/* This bitmap advertises the page sizes supported by PAMU hardware
+ * to the IOMMU API.
+ */
+#define FSL_PAMU_PGSIZES	(~0xFFFUL)
+
+/* global spinlock that needs to be held while
+ * configuring PAMU.
+ */
+DEFINE_SPINLOCK(iommu_lock);
+
+struct kmem_cache *fsl_pamu_domain_cache;
+struct kmem_cache *iommu_devinfo_cache;
+DEFINE_SPINLOCK(device_domain_lock);
+
+static inline void free_devinfo_mem(void *vaddr)
+{
+	kmem_cache_free(iommu_devinfo_cache, vaddr);
+}
+
+static inline int iommu_devinfo_cache_init(void)
+{
+	int ret = 0;
+
+	iommu_devinfo_cache = kmem_cache_create("iommu_devinfo",
+					 sizeof(struct device_domain_info),
+					 0,
+					 SLAB_HWCACHE_ALIGN,
+					 NULL);
+	if (!iommu_devinfo_cache) {
+		pr_err("Couldn't create devinfo cache\n");
+		ret = -ENOMEM;
+	}
+
+	return ret;
+}
+
+static inline int iommu_domain_cache_init(void)
+{
+	int ret = 0;
+
+	fsl_pamu_domain_cache = kmem_cache_create("fsl_pamu_domain",
+					 sizeof(struct fsl_dma_domain),
+					 0,
+					 SLAB_HWCACHE_ALIGN,
+
+					 NULL);
+	if (!fsl_pamu_domain_cache) {
+		pr_err("Couldn't create fsl iommu_domain cache\n");
+		ret = -ENOMEM;
+	}
+
+	return ret;
+}
+
+int __init iommu_init_mempool(void)
+{
+	int ret;
+
+	ret = iommu_domain_cache_init();
+	if (ret)
+		return ret;
+
+	ret = iommu_devinfo_cache_init();
+	if (!ret)
+		return ret;
+
+	kmem_cache_destroy(fsl_pamu_domain_cache);
+
+	return 0;
+}
+
+
+static int reconfig_win(int liodn, struct fsl_dma_domain *domain)
+{
+	int ret;
+
+	spin_lock(&iommu_lock);
+	ret = pamu_config_ppaace(liodn, domain->mapped_iova,
+				 domain->mapped_size,
+				 -1,
+				 domain->paddr >> PAMU_PAGE_SHIFT,
+				 domain->snoop_id, domain->stash_id,
+				 0, domain->prot);
+	spin_unlock(&iommu_lock);
+	if (ret) {
+		pr_err("PAMU PAACE configuration failed for liodn %d\n",
+			 liodn);
+	}
+	return ret;
+}
+
+static void update_domain_subwin(struct fsl_dma_domain *dma_domain,
+				unsigned long iova, size_t size,
+				phys_addr_t paddr, int prot, int status)
+{
+	struct iommu_domain *domain = dma_domain->iommu_domain;
+	u32 subwin_cnt = dma_domain->subwin_cnt;
+	dma_addr_t geom_size = dma_domain->geom_size;
+	u32 subwin_size;
+	u32 mapped_subwin;
+	u32 mapped_subwin_cnt;
+	struct dma_subwindow *sub_win_ptr;
+	int i;
+
+	subwin_size = geom_size >> ilog2(subwin_cnt);
+	mapped_subwin = (iova - domain->geometry.aperture_start)
+				 >> ilog2(subwin_size);
+	sub_win_ptr = &dma_domain->sub_win_arr[mapped_subwin];
+	mapped_subwin_cnt = (size < subwin_size) ? 1 :
+				size >> ilog2(subwin_size);
+	for (i = 0; i < mapped_subwin_cnt; i++) {
+		if (status) {
+			sub_win_ptr[i].paddr = paddr;
+			sub_win_ptr[i].size = (size < subwin_size) ?
+						 size : subwin_size;
+			paddr += subwin_size;
+			sub_win_ptr[i].iova = iova;
+			iova += subwin_size;
+		}
+		sub_win_ptr[i].valid = status;
+		sub_win_ptr[i].prot = prot;
+	}
+
+	dma_domain->mapped_subwin = mapped_subwin;
+	dma_domain->mapped_subwin_cnt =  mapped_subwin_cnt;
+}
+
+static int reconfig_subwin(int liodn, struct fsl_dma_domain *dma_domain)
+{
+	u32 subwin_cnt = dma_domain->subwin_cnt;
+	int ret = 0;
+	u32 mapped_subwin;
+	u32 mapped_subwin_cnt;
+	struct dma_subwindow *sub_win_ptr;
+	unsigned long rpn;
+	int i;
+
+	mapped_subwin = dma_domain->mapped_subwin;
+	mapped_subwin_cnt = dma_domain->mapped_subwin_cnt;
+	sub_win_ptr = &dma_domain->sub_win_arr[mapped_subwin];
+
+	for (i = 0; i < mapped_subwin_cnt; i++) {
+		rpn = sub_win_ptr[i].paddr >> PAMU_PAGE_SHIFT,
+	
+		spin_lock(&iommu_lock);
+		ret = pamu_config_spaace(liodn, subwin_cnt, mapped_subwin,
+					 sub_win_ptr[i].size,
+					 -1, 
+					 rpn, dma_domain->snoop_id,
+					 dma_domain->stash_id, 
+					 (mapped_subwin == 0 &&
+					 !dma_domain->enabled) ?
+					 0 : sub_win_ptr[i].valid,
+					 sub_win_ptr[i].prot);
+		spin_unlock(&iommu_lock);
+		if (ret) {
+			pr_err("PAMU SPAACE configuration failed for liodn %d\n",liodn);
+			return ret;
+		}
+		mapped_subwin++;
+	}
+
+	return ret;
+}
+
+static phys_addr_t get_phys_addr(struct fsl_dma_domain *dma_domain, unsigned long iova)
+{
+	u32 subwin_cnt = dma_domain->subwin_cnt;
+
+	if (subwin_cnt) {
+		int i;
+		struct dma_subwindow *sub_win_ptr = 
+					&dma_domain->sub_win_arr[0];
+
+		for (i = 0; i < subwin_cnt; i++) {
+			if (sub_win_ptr[i].valid &&
+			    iova >= sub_win_ptr[i].iova &&
+			    iova < (sub_win_ptr[i].iova +
+			    sub_win_ptr[i].size - 1))
+				return (sub_win_ptr[i].paddr + (iova &
+					(sub_win_ptr[i].size - 1)));
+		}
+	} else {
+		return (dma_domain->paddr + (iova & (dma_domain->mapped_size - 1)));
+	}
+
+	return 0;
+}
+
+static int map_liodn(int liodn, struct fsl_dma_domain *dma_domain)
+{
+	u32 subwin_cnt = dma_domain->subwin_cnt;
+	unsigned long rpn;
+	int ret = 0, i;
+
+	if (subwin_cnt) {
+		struct dma_subwindow *sub_win_ptr = 
+					&dma_domain->sub_win_arr[0];
+		for (i = 0; i < subwin_cnt; i++) {
+			if (sub_win_ptr[i].valid) {
+				rpn = sub_win_ptr[i].paddr >>
+					 PAMU_PAGE_SHIFT,
+				spin_lock(&iommu_lock);
+				ret = pamu_config_spaace(liodn, subwin_cnt, i,
+							 sub_win_ptr[i].size,
+							 -1,
+							 rpn,
+							 dma_domain->snoop_id,
+							 dma_domain->stash_id,
+							 (i > 0) ? 1 : 0,
+							 sub_win_ptr[i].prot);
+				spin_unlock(&iommu_lock);
+				if (ret) {
+					pr_err("PAMU SPAACE configuration failed for liodn %d\n",
+						 liodn);
+					return ret;
+				}
+			}
+		}
+	} else {
+
+		rpn = dma_domain->paddr >> PAMU_PAGE_SHIFT;
+		spin_lock(&iommu_lock);
+		ret = pamu_config_ppaace(liodn, dma_domain->mapped_iova,
+					 dma_domain->mapped_size,
+					 -1,
+					 rpn,
+					dma_domain->snoop_id, dma_domain->stash_id,
+					0, dma_domain->prot);
+		spin_unlock(&iommu_lock);
+		if (ret) {
+			pr_err("PAMU PAACE configuration failed for liodn %d\n",
+				liodn);
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+static int update_liodn(int liodn, struct fsl_dma_domain *dma_domain)
+{
+	int ret;
+
+	if (dma_domain->subwin_cnt) {
+		ret = reconfig_subwin(liodn, dma_domain);
+		if (ret)
+			pr_err("Subwindow reconfiguration failed for liodn %d\n", liodn);
+	} else {
+		ret = reconfig_win(liodn, dma_domain);
+		if (ret)
+			pr_err("Window reconfiguration failed for liodn %d\n", liodn);
+	}
+
+	return ret;
+}
+
+static int update_liodn_stash(int liodn, struct fsl_dma_domain *dma_domain,
+				 u32 val)
+{
+	int ret = 0, i;
+
+	spin_lock(&iommu_lock);
+	if (!dma_domain->subwin_cnt) {
+		ret = pamu_update_paace_stash(liodn, 0, val);
+		if (ret) {
+			pr_err("Failed to update PAACE field for liodn %d\n ", liodn);
+			spin_unlock(&iommu_lock);
+			return ret;
+		}
+	} else {
+		for (i = 0; i < dma_domain->subwin_cnt; i++) {
+			ret = pamu_update_paace_stash(liodn, i, val);
+			if (ret) {
+				pr_err("Failed to update SPAACE %d field for liodn %d\n ", i, liodn);
+				spin_unlock(&iommu_lock);
+				return ret;
+			}
+		}
+	}
+	spin_unlock(&iommu_lock);
+
+	return ret;
+}
+
+static int configure_liodn(int liodn, struct device *dev,
+			   struct fsl_dma_domain *dma_domain,
+			   struct iommu_domain_geometry *geom_attr,
+			   u32 subwin_cnt)
+{
+	phys_addr_t window_addr, window_size;
+	phys_addr_t subwin_size;
+	int ret = 0, i;
+	u32 omi_index = -1;
+
+	/* Configure the omi_index at the geometry setup time.
+	 * This is a static value which depends on the type of
+	 * device and would not change thereafter.
+	 */
+	get_ome_index(&omi_index, dev);
+
+	window_addr = geom_attr->aperture_start;
+	window_size = geom_attr->aperture_end - geom_attr->aperture_start;
+
+	spin_lock(&iommu_lock);
+	ret = pamu_disable_liodn(liodn);
+	if (!ret)
+		ret = pamu_config_ppaace(liodn, window_addr, window_size, omi_index,
+					 0, dma_domain->snoop_id,
+					 dma_domain->stash_id, subwin_cnt, 0);
+	spin_unlock(&iommu_lock);
+	if (ret) {
+		pr_err("PAMU PAACE configuration failed for liodn %d\n", liodn);
+		return ret;
+	}
+
+	if (subwin_cnt) {
+		subwin_size = window_size >> ilog2(subwin_cnt);
+		for (i = 0; i < subwin_cnt; i++) {
+			spin_lock(&iommu_lock);
+			ret = pamu_config_spaace(liodn, subwin_cnt, i, subwin_size,
+						 omi_index, 0,
+						 dma_domain->snoop_id,
+						 dma_domain->stash_id, 0, 0);
+			spin_unlock(&iommu_lock);
+			if (ret) {
+				pr_err("PAMU SPAACE configuration failed for liodn %d\n", liodn);
+				return ret;
+			}
+		}
+	}
+
+	return ret;
+}
+
+static int check_size(u64 size, unsigned long iova)
+{
+	if ((size & (size - 1)) || size < PAMU_PAGE_SIZE) {
+		pr_err("%s: size too small or not a power of two\n", __func__);
+		return -EINVAL;
+	}
+
+	if (iova & (size - 1)) {
+		pr_err("%s: address is not aligned with window size\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static inline int check_size_align(u64 size, u64 subwin_size)
+{
+	return ((size < subwin_size) ? ((size & (size - 1)) ||
+					 size < PAMU_PAGE_SIZE) :
+					(size & (subwin_size -1)));
+}
+
+
+static struct fsl_dma_domain *iommu_alloc_dma_domain(void)
+{
+	struct fsl_dma_domain *domain;
+
+	domain = kmem_cache_zalloc(fsl_pamu_domain_cache, GFP_KERNEL);
+	if (!domain)
+		return NULL;
+
+	domain->stash_id = -1;
+	domain->snoop_id = -1;
+
+	INIT_LIST_HEAD(&domain->devices);
+
+	spin_lock_init(&domain->domain_lock);
+
+	return domain;
+}
+
+static inline struct fsl_dma_domain *find_domain(struct device *dev)
+{
+	return dev->archdata.iommu_domain;
+}
+
+static void remove_domain_ref(struct device_domain_info *info, u32 subwin_cnt)
+{
+		list_del(&info->link);
+		spin_lock(&iommu_lock);
+		if (subwin_cnt)
+			pamu_free_subwins(info->liodn);
+		pamu_disable_liodn(info->liodn);
+		spin_unlock(&iommu_lock);
+		spin_lock(&device_domain_lock);
+		info->dev->archdata.iommu_domain = NULL;
+		free_devinfo_mem(info);
+		spin_unlock(&device_domain_lock);
+}
+
+static void destroy_domain(struct fsl_dma_domain *dma_domain)
+{
+	struct device_domain_info *info;
+
+	while (!list_empty(&dma_domain->devices)) {
+		info = list_entry(dma_domain->devices.next,
+			struct device_domain_info, link);
+		remove_domain_ref(info, dma_domain->subwin_cnt);
+	}
+}
+
+static void detach_domain(struct device *dev, struct fsl_dma_domain *dma_domain)
+{
+	struct device_domain_info *info;
+	struct list_head *entry, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dma_domain->domain_lock, flags);
+	if (!list_empty(&dma_domain->devices)) {
+		list_for_each_safe(entry, tmp, &dma_domain->devices) {
+			info = list_entry(entry, struct device_domain_info, link);
+			if (info->dev == dev)
+				remove_domain_ref(info, dma_domain->subwin_cnt);
+		}
+	}
+	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+}
+
+static void attach_domain(struct fsl_dma_domain *dma_domain, int liodn, struct device *dev)
+{
+	struct device_domain_info *info;
+	struct fsl_dma_domain *old_domain;
+
+	spin_lock(&device_domain_lock);
+	/* Check here if the device is already attached to domain or not.
+	 * If the device is already attached to a domain detach it.
+	 */
+	old_domain = find_domain(dev);
+	if (old_domain && old_domain != dma_domain) {
+		spin_unlock(&device_domain_lock);
+		detach_domain(dev, old_domain);
+		spin_lock(&device_domain_lock);
+	}
+
+	info = kmem_cache_zalloc(iommu_devinfo_cache, GFP_KERNEL);
+
+	info->dev = dev;
+	info->liodn = liodn;
+	info->domain = dma_domain;
+
+	list_add(&info->link, &dma_domain->devices);
+	/* In case of devices with multiple LIODNs just store
+	 * the info for the first LIODN as all
+	 * LIODNs share the same domain
+	 */
+	if (old_domain && old_domain != dma_domain)
+		dev->archdata.iommu_domain = info;
+	spin_unlock(&device_domain_lock);
+
+}
+
+static phys_addr_t fsl_pamu_iova_to_phys(struct iommu_domain *domain,
+					    unsigned long iova)
+{
+	struct fsl_dma_domain *dma_domain = domain->priv;
+
+	if ((iova < domain->geometry.aperture_start) ||
+		iova > (domain->geometry.aperture_end))
+		return 0;
+
+	return get_phys_addr(dma_domain, iova);
+}
+
+static int fsl_pamu_domain_has_cap(struct iommu_domain *domain,
+				      unsigned long cap)
+{
+	if (cap == IOMMU_CAP_CACHE_COHERENCY)
+		return 1;
+
+	return 0;
+}
+
+static void fsl_pamu_domain_destroy(struct iommu_domain *domain)
+{
+	struct fsl_dma_domain *dma_domain = domain->priv;
+
+	domain->priv = NULL;
+
+	destroy_domain(dma_domain);
+
+	dma_domain->enabled = 0;
+	dma_domain->valid = 0;
+	dma_domain->mapped = 0;
+
+	kmem_cache_free(fsl_pamu_domain_cache, dma_domain);
+}
+
+static int fsl_pamu_domain_init(struct iommu_domain *domain)
+{
+	struct fsl_dma_domain *dma_domain;
+
+	dma_domain = iommu_alloc_dma_domain();
+	if (!dma_domain) {
+		pr_err("dma_domain allocation failed\n");
+		return -ENOMEM;
+	}
+	domain->priv = dma_domain;
+	dma_domain->iommu_domain = domain;
+	/* defaul geometry = 1MB */
+	domain->geometry.aperture_start = 0;
+	domain->geometry.aperture_end   = 0x100000;
+	domain->geometry.subwindows = 0;
+	domain->geometry.force_aperture = true;
+
+	return 0;
+}
+
+static int configure_domain(struct fsl_dma_domain *dma_domain,
+			    struct iommu_domain_geometry *geom_attr,
+			    u32 subwin_cnt)
+{
+	struct device_domain_info *info;
+	int ret = 0;
+
+	list_for_each_entry(info, &dma_domain->devices, link) {
+		ret = configure_liodn(info->liodn, info->dev, dma_domain,
+				      geom_attr, subwin_cnt);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int update_domain_stash(struct fsl_dma_domain *dma_domain, u32 val)
+{
+	struct device_domain_info *info;
+	int ret = 0;
+
+	list_for_each_entry(info, &dma_domain->devices, link) {
+		ret = update_liodn_stash(info->liodn, dma_domain, val);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int update_domain_mapping(struct fsl_dma_domain *domain)
+{
+	struct device_domain_info *info;
+	int ret = 0;
+
+	list_for_each_entry(info, &domain->devices, link) {
+		ret = update_liodn(info->liodn, domain);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
+static int fsl_pamu_map(struct iommu_domain *domain,
+			   unsigned long iova, phys_addr_t paddr,
+			   size_t size, int iommu_prot)
+{
+	struct fsl_dma_domain *dma_domain = domain->priv;
+	struct iommu_domain_geometry *geom_attr = &domain->geometry;
+	int prot = 0;
+	unsigned long flags;
+	int ret = 0;
+
+
+	if (iommu_prot & IOMMU_READ)
+		prot |= PAACE_AP_PERMS_QUERY;
+	if (iommu_prot & IOMMU_WRITE)
+		prot |= PAACE_AP_PERMS_UPDATE;
+
+	spin_lock_irqsave(&dma_domain->domain_lock, flags);
+	if (dma_domain->valid) {
+		if (dma_domain->subwin_cnt) {
+			u32 align_check, subwin_size;
+			dma_addr_t geom_size = dma_domain->geom_size;
+
+			subwin_size = geom_size >> ilog2(dma_domain->subwin_cnt);
+			align_check = check_size(subwin_size, iova) ||
+					check_size_align(size, subwin_size);
+			if ((iova >= geom_attr->aperture_start &&
+				iova < geom_attr->aperture_end - 1 &&
+				size <= geom_size) &&
+				!align_check) {
+				update_domain_subwin(dma_domain, iova, size, paddr, prot, 1);
+			} else {
+				pr_err("Mismatch between geometry and mapping\n");
+				ret = -EINVAL;
+			}
+		} else {
+			ret = check_size(size, iova);
+			if (!ret && !dma_domain->enabled) {
+				dma_domain->mapped_iova = iova;
+				dma_domain->mapped_size = size;
+				dma_domain->paddr = paddr;
+				dma_domain->prot = prot;
+			} else {
+				pr_err("Can't create mapping, %s\n",
+					 (ret) ? "Invalid size" : "DMA enabled");
+				ret = ret ? ret : -EBUSY;
+			}
+		}
+
+		if (!ret) {
+			ret = update_domain_mapping(dma_domain);
+			if (!ret)
+				dma_domain->mapped = 1;
+		}
+	} else {
+		pr_err("Set domain geometry before creating the mapping\n");
+		ret = -ENODEV;
+	}
+	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+
+	return ret;
+}
+
+static size_t fsl_pamu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
+{
+	struct fsl_dma_domain *dma_domain = domain->priv;
+	struct iommu_domain_geometry *geom_attr = &domain->geometry;
+	size_t ret = size;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dma_domain->domain_lock, flags);
+	if (dma_domain->valid && dma_domain->mapped) {
+		if (dma_domain->subwin_cnt) {
+			u32 align_check, subwin_size;
+			dma_addr_t geom_size = dma_domain->geom_size;
+
+			subwin_size = geom_size >> ilog2(dma_domain->subwin_cnt);
+			align_check = check_size(subwin_size, iova) ||
+					check_size_align(size, subwin_size);
+			if ((iova >= geom_attr->aperture_start &&
+				iova < geom_attr->aperture_end - 1 &&
+				size <= geom_size) &&
+				!align_check) {
+				update_domain_subwin(dma_domain, iova, size, 0,
+						      PAACE_AP_PERMS_DENIED, 0);
+			} else {
+				pr_err("Invalid address/size alignment\n");
+				ret = -EINVAL;
+			}
+		} else {
+			if (!dma_domain->enabled) {
+				u64 max_addr, unmap_range;
+				size_t domain_size;
+				unsigned long domain_iova;
+
+				unmap_range = iova + size;
+				domain_iova = dma_domain->mapped_iova;
+				domain_size = dma_domain->mapped_size;
+				max_addr = domain_iova + domain_size;
+
+				if ((domain_iova != iova &&
+					(max_addr < unmap_range ||
+					 max_addr > unmap_range)) ||
+					 size > domain_size ||
+					 iova < domain_iova) {
+					pr_err("Invalid size/address parameters for unmap\n");
+					ret = -EINVAL;
+				} else {
+					domain_size -= size;
+					if (iova == domain_iova)
+						domain_iova += size;
+					ret = check_size(domain_size, domain_iova);
+					if (!ret) {
+						dma_domain->mapped_iova = domain_iova;
+						dma_domain->mapped_size = domain_size;
+						if (!domain_size)
+							dma_domain->mapped = 0;
+					}
+				}
+			} else {
+				pr_err("Can't update mapping with DMA enabled\n");
+				ret = -EBUSY;
+			}
+		}
+		if (ret == size)
+			update_domain_mapping(dma_domain);
+	} else {
+		pr_err("Can't unmap an invalid domain\n");
+		ret = -ENODEV;
+	}
+	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+
+	return ret;
+}
+
+static int handle_attach_device(struct fsl_dma_domain *dma_domain,
+				 struct device *dev, const u32 *liodn,
+				 int num)
+{
+	unsigned long flags;
+	struct iommu_domain *domain = dma_domain->iommu_domain;
+	int ret = 0;
+	int i;
+
+	spin_lock_irqsave(&dma_domain->domain_lock, flags);
+	for (i = 0; i < num; i++) {
+		attach_domain(dma_domain, liodn[i], dev);
+		if (dma_domain->valid) {
+			ret = configure_liodn(liodn[i], dev, dma_domain,
+					      &domain->geometry,
+					      dma_domain->subwin_cnt);
+			if (ret)
+				break;
+			if (dma_domain->mapped) {
+				ret = map_liodn(liodn[i], dma_domain);
+				if (ret)
+					break;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+
+	return ret;
+}
+
+static int fsl_pamu_attach_device(struct iommu_domain *domain,
+				  struct device *dev)
+{
+	struct fsl_dma_domain *dma_domain = domain->priv;
+	const u32 *prop;
+	u32 prop_cnt;
+	int len, ret = 0;
+
+	prop = of_get_property(dev->of_node, "fsl,liodn", &len);
+	if (prop) {
+		prop_cnt = len / sizeof(u32);
+		ret = handle_attach_device(dma_domain, dev,
+					 prop, prop_cnt);
+	} else {
+		pr_err("missing fsl,liodn property at %s\n",
+		          dev->of_node->full_name);
+			ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static void fsl_pamu_detach_device(struct iommu_domain *domain,
+				      struct device *dev)
+{
+	struct fsl_dma_domain *dma_domain = domain->priv;
+	const u32 *prop;
+	int len;
+
+	prop = of_get_property(dev->of_node, "fsl,liodn", &len);
+	if (prop)
+		detach_domain(dev, dma_domain);
+	else
+		pr_err("missing fsl,liodn property at %s\n",
+		          dev->of_node->full_name);
+}
+
+static int get_subwin_cnt(dma_addr_t geom_size, u32 subwin, u32 *subwin_cnt)
+{
+
+	switch (subwin) {
+		case 0:
+			/* We can't support geometry size > 1MB*/
+			if (geom_size != 1024 * 1024)
+				return 0;
+			*subwin_cnt = 256;
+			break;
+		case 1:
+			/* No subwindows only a single PAMU window */
+			*subwin_cnt = 0;
+			break;
+		default:
+			if (subwin > max_subwindow_count ||
+			   (subwin & (subwin - 1)))
+				return 0;
+			*subwin_cnt = subwin;
+	}
+	return 1;
+} 
+
+static  int configure_domain_geometry(struct iommu_domain *domain, void *data)
+{
+	int ret = 0;
+	struct iommu_domain_geometry *geom_attr = data;
+	struct fsl_dma_domain *dma_domain = domain->priv;
+	dma_addr_t geom_size;
+	u32 subwin_cnt;
+	unsigned long flags;
+
+	geom_size = geom_attr->aperture_end - geom_attr->aperture_start;
+
+	if (check_size(geom_size, geom_attr->aperture_start) ||
+		!geom_attr->force_aperture ||
+		!get_subwin_cnt(geom_size, geom_attr->subwindows,
+		&subwin_cnt)) {
+			pr_err("Invalid PAMU geometry attributes\n");
+			return -EINVAL;
+		}
+
+	spin_lock_irqsave(&dma_domain->domain_lock, flags);
+	if (dma_domain->enabled) {
+		pr_err("Can't set geometry attributes as domain is active\n");
+		spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+		return  -EBUSY;
+	}
+	ret = configure_domain(dma_domain, geom_attr, subwin_cnt);
+	if (!ret) {
+		if (subwin_cnt) {
+			if (dma_domain->sub_win_arr)
+				kfree(dma_domain->sub_win_arr);
+			dma_domain->sub_win_arr = kmalloc(sizeof(struct dma_subwindow) *
+							  subwin_cnt, GFP_KERNEL);
+			if (!dma_domain->sub_win_arr) {
+				spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+				return -ENOMEM;
+			}
+		}
+		memcpy(&domain->geometry, geom_attr,
+			 sizeof(struct iommu_domain_geometry));
+		dma_domain->geom_size = geom_size;
+		dma_domain->subwin_cnt = subwin_cnt;
+		dma_domain->valid = 1;
+	}
+	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+
+	return ret;
+}
+
+static int configure_domain_stash(struct fsl_dma_domain *dma_domain, void *data)
+{
+	struct iommu_stash_attribute *stash_attr = data;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&dma_domain->domain_lock, flags);
+
+	memcpy(&dma_domain->dma_stash, stash_attr,
+		 sizeof(struct iommu_stash_attribute));
+
+	dma_domain->stash_id = get_stash_id(stash_attr->cache,
+					    stash_attr->cpu);
+	if (dma_domain->stash_id == ~(u32)0) {
+		pr_err("Invalid stash attributes\n");
+		spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+		return -EINVAL;
+	}
+
+	ret = update_domain_stash(dma_domain, dma_domain->stash_id);
+
+	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+
+	return ret;
+}
+
+static int configure_domain_dma_state(struct fsl_dma_domain *dma_domain, int enable)
+{
+	struct device_domain_info *info;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&dma_domain->domain_lock, flags);
+
+	if (enable && !dma_domain->mapped) {
+		pr_err("Can't enable DMA domain without valid mapping\n");
+		spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+		return -ENODEV;
+	}
+
+	dma_domain->enabled = enable;
+	if (!list_empty(&dma_domain->devices)) {
+		list_for_each_entry(info, &dma_domain->devices,
+					 link) {
+			ret = (enable) ? pamu_enable_liodn(info->liodn):
+				pamu_disable_liodn(info->liodn);
+			if (ret)
+				pr_err("Unable to set dma state for liodn %d",
+					 info->liodn);
+		}
+	}
+	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+
+	return 0;
+}
+
+int fsl_pamu_set_domain_attr(struct iommu_domain *domain,
+				 enum iommu_attr attr_type, void *data)
+{
+	struct fsl_dma_domain *dma_domain = domain->priv;
+	int ret = 0;
+
+
+	switch(attr_type) {
+	case DOMAIN_ATTR_GEOMETRY:
+		ret = configure_domain_geometry(domain, data);
+		break;
+	case DOMAIN_ATTR_STASH:
+		ret = configure_domain_stash(dma_domain, data);
+		break;
+	case DOMAIN_ATTR_ENABLE:
+		ret = configure_domain_dma_state(dma_domain, *(int *)data);
+		break;
+	default:
+		pr_err("Unsupported attribute type\n");
+		ret = -EINVAL;
+		break;
+	};
+
+	return ret;
+}
+
+int fsl_pamu_get_domain_attr(struct iommu_domain *domain,
+				 enum iommu_attr attr_type, void *data)
+{
+	struct fsl_dma_domain *dma_domain = domain->priv;
+	int ret = 0;
+
+
+	switch(attr_type) {
+	case DOMAIN_ATTR_STASH:
+		memcpy((struct iommu_stash_attribute *) data, &dma_domain->dma_stash,
+				 sizeof(struct iommu_stash_attribute));
+		break;
+	case DOMAIN_ATTR_ENABLE:
+		*(int *)data = dma_domain->enabled;
+		break;
+	default:
+		pr_err("Unsupported attribute type\n");
+		ret = -EINVAL;
+		break;
+	};
+
+	return ret;
+}
+
+static struct iommu_ops fsl_pamu_ops = {
+	.domain_init	= fsl_pamu_domain_init,
+	.domain_destroy = fsl_pamu_domain_destroy,
+	.attach_dev	= fsl_pamu_attach_device,
+	.detach_dev	= fsl_pamu_detach_device,
+	.map		= fsl_pamu_map,
+	.unmap		= fsl_pamu_unmap,
+	.iova_to_phys	= fsl_pamu_iova_to_phys,
+	.domain_has_cap = fsl_pamu_domain_has_cap,
+	.domain_set_attr = fsl_pamu_set_domain_attr,
+	.domain_get_attr = fsl_pamu_get_domain_attr,
+	.pgsize_bitmap	= FSL_PAMU_PGSIZES,
+};
+
+int pamu_domain_init()
+{
+	int ret = 0;
+
+	ret = iommu_init_mempool();
+	if (ret)
+		return ret;
+
+	bus_set_iommu(&platform_bus_type, &fsl_pamu_ops);
+
+	return ret;
+}
diff --git a/drivers/iommu/fsl_pamu_domain.h b/drivers/iommu/fsl_pamu_domain.h
new file mode 100644
index 0000000..840e5b6
--- /dev/null
+++ b/drivers/iommu/fsl_pamu_domain.h
@@ -0,0 +1,96 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright (C) 2012 Freescale Semiconductor, Inc.
+ *
+ */
+
+#ifndef __FSL_PAMU_DOMAIN_H
+#define __FSL_PAMU_DOMAIN_H
+
+#include "fsl_pamu.h"
+
+struct dma_subwindow {
+	unsigned long iova;
+	phys_addr_t paddr;
+	size_t size;
+	int valid;
+	int prot;
+};
+
+struct fsl_dma_domain {
+	/* mapped_iova and mapped_size are used in case there are
+	 * no subwindows associated with the domain. These are
+	 * updated on each iommu_map/iommu_unmap call. Based
+	 * on these values the corresponding PPAACE entry is
+	 * updated.
+	 */
+	unsigned long			mapped_iova;
+	size_t	 			mapped_size;
+	/* physical address mapping */
+	u64				paddr;
+	/* mapped_subwin/mapped_subwin_cnt are only valid if
+	 * the domain geometry has subwindows. These fields
+	 * are updated on each iommu_map/iommu_unmap call.
+	 * Based on these values the corresponding SPAACE
+	 * entries are updated.
+	 */
+	u32 				mapped_subwin;
+	u32				mapped_subwin_cnt;
+	/* Access permission associated with the domain */
+	int				prot;
+	/* number of subwindows assocaited with this domain */
+	u32				subwin_cnt;
+	/* sub_win_arr contains information of the configured
+	 * subwindows for a domain.
+	 */
+	struct dma_subwindow		*sub_win_arr;
+	/* list of devices associated with the domain */
+	struct list_head 		devices;
+	/* dma_domain states:
+	 * valid - Geometry attribute has been configured.
+	 * mapped - A particular mapping has been created
+	 * within the configured geometry. Domain has to
+	 * be in the valid state before any DMA mapping
+	 * can be created in it.
+	 * enabled - DMA has been enabled for the given
+	 * domain. This translates to setting of the
+	 * valid bit for the primary PAACE in the PAMU
+	 * PAACT table. Domain should be valid and have
+	 * a valid mapping before DMA can be enabled for it.
+	 *
+	 */
+	int				valid;
+	int				mapped;
+	int				enabled;
+	/* stash_id obtained from the stash attribute details */
+	u32				stash_id;
+	struct iommu_stash_attribute	dma_stash;
+	u32				snoop_id;
+	dma_addr_t			geom_size;
+	struct iommu_domain		*iommu_domain;
+	spinlock_t			domain_lock;
+};
+
+/* domain-device relationship */
+struct device_domain_info {
+	struct list_head link;	/* link to domain siblings */
+	struct device *dev;
+	u32 liodn;
+	struct fsl_dma_domain *domain; /* pointer to domain */
+};
+
+extern unsigned int max_subwindow_count;
+
+#endif  /* __FSL_PAMU_DOMAIN_H */
-- 
1.7.4.1


