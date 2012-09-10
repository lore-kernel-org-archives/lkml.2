Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab2IJT45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:56:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17191 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2IJT4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:56:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 05/10] xen/swiotlb: Move the error strings to its own function.
Date: Mon, 10 Sep 2012 15:46:02 -0400
Message-Id: <1347306367-28669-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That way we can more easily reuse those errors when using the
late SWIOTLB init.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/swiotlb-xen.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index a2aad6e..701b103 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -154,11 +154,33 @@ static unsigned long xen_set_nslabs(unsigned long nr_tbl)
 
 	return xen_io_tlb_nslabs << IO_TLB_SHIFT;
 }
+
+enum xen_swiotlb_err {
+	XEN_SWIOTLB_UNKNOWN = 0,
+	XEN_SWIOTLB_ENOMEM,
+	XEN_SWIOTLB_EFIXUP
+};
+
+static const char *xen_swiotlb_error(enum xen_swiotlb_err err)
+{
+	switch (err) {
+	case XEN_SWIOTLB_ENOMEM:
+		return "Cannot allocate Xen-SWIOTLB buffer\n";
+	case XEN_SWIOTLB_EFIXUP:
+		return "Failed to get contiguous memory for DMA from Xen!\n"\
+		    "You either: don't have the permissions, do not have"\
+		    " enough free memory under 4GB, or the hypervisor memory"\
+		    " is too fragmented!";
+	default:
+		break;
+	}
+	return "";
+}
 void __init xen_swiotlb_init(int verbose)
 {
 	unsigned long bytes;
 	int rc = -ENOMEM;
-	char *m = NULL;
+	enum xen_swiotlb_err m_ret = XEN_SWIOTLB_UNKNOWN;
 	unsigned int repeat = 3;
 
 	xen_io_tlb_nslabs = swiotlb_nr_tbl();
@@ -169,7 +191,7 @@ retry:
 	 */
 	xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
 	if (!xen_io_tlb_start) {
-		m = "Cannot allocate Xen-SWIOTLB buffer!\n";
+		m_ret = XEN_SWIOTLB_ENOMEM;
 		goto error;
 	}
 	xen_io_tlb_end = xen_io_tlb_start + bytes;
@@ -181,10 +203,7 @@ retry:
 			       xen_io_tlb_nslabs);
 	if (rc) {
 		free_bootmem(__pa(xen_io_tlb_start), PAGE_ALIGN(bytes));
-		m = "Failed to get contiguous memory for DMA from Xen!\n"\
-		    "You either: don't have the permissions, do not have"\
-		    " enough free memory under 4GB, or the hypervisor memory"\
-		    "is too fragmented!";
+		m_ret = XEN_SWIOTLB_EFIXUP;
 		goto error;
 	}
 	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
@@ -199,8 +218,8 @@ error:
 		      (xen_io_tlb_nslabs << IO_TLB_SHIFT) >> 20);
 		goto retry;
 	}
-	xen_raw_printk("%s (rc:%d)", m, rc);
-	panic("%s (rc:%d)", m, rc);
+	xen_raw_printk("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
+	panic("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
 }
 
 void *
-- 
1.7.7.6

