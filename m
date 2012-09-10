Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab2IJT6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:58:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17230 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab2IJT47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:56:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 04/10] xen/swiotlb: Move the nr_tbl determination in its own function.
Date: Mon, 10 Sep 2012 15:46:01 -0400
Message-Id: <1347306367-28669-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving the function out of the way to prepare for the late
SWIOTLB init.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/swiotlb-xen.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 1afb4fb..a2aad6e 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -144,25 +144,26 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 	} while (i < nslabs);
 	return 0;
 }
+static unsigned long xen_set_nslabs(unsigned long nr_tbl)
+{
+	if (!nr_tbl) {
+		xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
+		xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
+	} else
+		xen_io_tlb_nslabs = nr_tbl;
 
+	return xen_io_tlb_nslabs << IO_TLB_SHIFT;
+}
 void __init xen_swiotlb_init(int verbose)
 {
 	unsigned long bytes;
 	int rc = -ENOMEM;
-	unsigned long nr_tbl;
 	char *m = NULL;
 	unsigned int repeat = 3;
 
-	nr_tbl = swiotlb_nr_tbl();
-	if (nr_tbl)
-		xen_io_tlb_nslabs = nr_tbl;
-	else {
-		xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
-		xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
-	}
+	xen_io_tlb_nslabs = swiotlb_nr_tbl();
 retry:
-	bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
-
+	bytes = xen_set_nslabs(xen_io_tlb_nslabs);
 	/*
 	 * Get IO TLB memory from any location.
 	 */
-- 
1.7.7.6

