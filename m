Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab1HaDKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 23:10:44 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31788 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1HaDKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 23:10:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: thellstrom@vmware.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com,
        j.glisse@redhat.com, thomas@shipmail.org, airlied@redhat.com,
        airlied@linux.ie, alexdeucher@gmail.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/7] swiotlb: Expose swiotlb_nr_tlb function to modules as swiotlb_enabled
Date: Tue, 30 Aug 2011 22:41:49 -0400
Message-Id: <1314758512-19285-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314758512-19285-1-git-send-email-konrad.wilk@oracle.com>
References: <1314758512-19285-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E5DA61C.005E:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a mechanism to detect whether SWIOTLB is enabled or not.
And as such, we might as well wrap it within an 'swiotlb_enabled()'
function that will call the swiotlb_nr_tlb.

We also fix the spelling - it was swioltb instead of
swiotlb.

CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/swiotlb-xen.c |    2 +-
 include/linux/swiotlb.h   |    7 ++++++-
 lib/swiotlb.c             |    5 +++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 6e8c15a..cbcd8cc 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -149,7 +149,7 @@ void __init xen_swiotlb_init(int verbose)
 	int rc;
 	unsigned long nr_tbl;
 
-	nr_tbl = swioltb_nr_tbl();
+	nr_tbl = swiotlb_nr_tbl();
 	if (nr_tbl)
 		xen_io_tlb_nslabs = nr_tbl;
 	else {
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 445702c..014ff53 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -24,7 +24,12 @@ extern int swiotlb_force;
 
 extern void swiotlb_init(int verbose);
 extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
-extern unsigned long swioltb_nr_tbl(void);
+extern unsigned long swiotlb_nr_tbl(void);
+
+static inline bool swiotlb_enabled(void)
+{
+	return !!swiotlb_nr_tbl();
+}
 
 /*
  * Enumeration for sync targets
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 99093b3..058935e 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -110,11 +110,11 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
-unsigned long swioltb_nr_tbl(void)
+unsigned long swiotlb_nr_tbl(void)
 {
 	return io_tlb_nslabs;
 }
-
+EXPORT_SYMBOL_GPL(swiotlb_nr_tbl);
 /* Note that this doesn't work with highmem page */
 static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 				      volatile void *address)
@@ -321,6 +321,7 @@ void __init swiotlb_free(void)
 		free_bootmem_late(__pa(io_tlb_start),
 				  PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
 	}
+	io_tlb_nslabs = 0;
 }
 
 static int is_swiotlb_buffer(phys_addr_t paddr)
-- 
1.7.4.1

