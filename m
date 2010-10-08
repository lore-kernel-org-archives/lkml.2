Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab0JHRej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:34:39 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36963 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759208Ab0JHRdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:33:49 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 10/11] ppc/iommu: add routines to pseries iommu to map tces 1-1
Date: Fri,  8 Oct 2010 10:33:11 -0700
Message-Id: <1286559192-10898-11-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
References: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/platforms/pseries/iommu.c |   98 ++++++++++++++++++++++++++++++++
 1 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 8ec81df..451d2d1 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -270,6 +270,104 @@ static unsigned long tce_get_pSeriesLP(struct iommu_table *tbl, long tcenum)
 	return tce_ret;
 }
 
+/* this is compatable with cells for the device tree property */
+struct dynamic_dma_window_prop {
+	__be32	liobn;		/* tce table number */
+	__be32	dma_base[2];	/* address hi,lo */
+	__be32	tce_shift;	/* ilog2(tce_page_size) */
+	__be32	window_shift;	/* ilog2(tce_window_size) */
+};
+
+static int tce_clearrange_multi_pSeriesLP(unsigned long start_pfn,
+					unsigned long num_pfn, void *arg)
+{
+	struct dynamic_dma_window_prop *maprange = arg;
+	int rc;
+	u64 tce_size, num_tce, dma_offset;
+	u32 tce_shift;
+
+	tce_shift = be32_to_cpu(maprange->tce_shift);
+	tce_size = 1ULL << tce_shift;
+	num_tce = num_pfn << PAGE_SHIFT;
+	dma_offset = start_pfn << PAGE_SHIFT;
+
+	/* round back to the beginning of the tce page size */
+	num_tce += dma_offset & (tce_size - 1);
+	dma_offset &= ~(tce_size - 1);
+
+	/* covert to number of tces */
+	num_tce |= tce_size - 1;
+	num_tce >>= tce_shift;
+
+	rc = plpar_tce_stuff(maprange->liobn, dma_offset, 0, num_tce);
+
+	return rc;
+}
+
+static int tce_setrange_multi_pSeriesLP(unsigned long start_pfn,
+					unsigned long num_pfn, void *arg)
+{
+	struct dynamic_dma_window_prop *maprange = arg;
+	u64 *tcep, tce_size, num_tce, dma_offset, next, proto_tce;
+	u32 tce_shift;
+	long rc = 0;
+	long l, limit;
+
+	local_irq_disable();	/* to protect tcep and the page behind it */
+	tcep = __get_cpu_var(tce_page);
+
+	if (!tcep) {
+		tcep = (u64 *)__get_free_page(GFP_ATOMIC);
+		if (!tcep) {
+			local_irq_enable();
+			return -ENOMEM;
+		}
+		__get_cpu_var(tce_page) = tcep;
+	}
+
+	proto_tce = TCE_PCI_READ | TCE_PCI_WRITE;
+
+	tce_shift = be32_to_cpu(maprange->tce_shift);
+	tce_size = 1ULL << tce_shift;
+	next = start_pfn << PAGE_SHIFT;
+	num_tce = num_pfn << PAGE_SHIFT;
+
+	/* round back to the beginning of the tce page size */
+	num_tce += next & (tce_size - 1);
+	next &= ~(tce_size - 1);
+
+	/* covert to number of tces */
+	num_tce |= tce_size - 1;
+	num_tce >>= maprange->tce_shift;
+
+	/* We can map max one pageful of TCEs at a time */
+	do {
+		/*
+		 * Set up the page with TCE data, looping through and setting
+		 * the values.
+		 */
+		limit = min_t(long, num_tce, 4096/TCE_ENTRY_SIZE);
+		dma_offset = next;
+
+		for (l = 0; l < limit; l++) {
+			tcep[l] = proto_tce | dma_offset;
+			next += tce_size;
+		}
+
+		rc = plpar_tce_put_indirect((u64)maprange->liobn,
+					    (u64)dma_offset,
+					    (u64)virt_to_abs(tcep),
+					    limit);
+
+		num_tce -= limit;
+	} while (num_tce > 0 && !rc);
+
+	/* error cleanup: caller will clear whole range */
+
+	local_irq_enable();
+	return rc;
+}
+
 #ifdef CONFIG_PCI
 static void iommu_table_setparms(struct pci_controller *phb,
 				 struct device_node *dn,
-- 
1.7.1

