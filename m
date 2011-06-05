Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1FECrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 22:47:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:40479 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab1FECrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 22:47:39 -0400
Date: Sun, 5 Jun 2011 11:47:29 +0900
To: konrad.wilk@oracle.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] swiotlb: Export io_tlb_nslabs as swiotlb_nslabs and
 use it.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1306946564-30481-2-git-send-email-konrad.wilk@oracle.com>
References: <1306946564-30481-1-git-send-email-konrad.wilk@oracle.com>
	<1306946564-30481-2-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110605114548K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 05 Jun 2011 11:47:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Jun 2011 12:42:44 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> By default the io_tlb_nslabs is set to zero, and gets set to
> whatever value is passed in via swiotlb_init_with_tbl function.
> The default value passed in is 64MB. However, if the user provides
> the 'swiotlb=<nslabs>' the default value is ignored and
> the value provided by the user is used... Except when the SWIOTLB
> is used under Xen - there the default value of 64MB is used and
> the Xen-SWIOTLB has no mechanism to get the 'io_tlb_nslabs' filled
> out by setup_io_tlb_npages functions. This patch exports the
> value that is potentially set by setup_io_tlb_npages and renames
> it to swiotlb_nslabs.
> 
> CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/swiotlb-xen.c |    7 +++-
>  include/linux/swiotlb.h   |    5 +++
>  lib/swiotlb.c             |   78 ++++++++++++++++++++++----------------------
>  3 files changed, 49 insertions(+), 41 deletions(-)

Hmm, exporting the internal valuable and all the renaming look
overdoing?

Why can't we simply do like this?

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 65ea21a..6e8c15a 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -147,9 +147,15 @@ void __init xen_swiotlb_init(int verbose)
 {
 	unsigned long bytes;
 	int rc;
-
-	xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
-	xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
+	unsigned long nr_tbl;
+
+	nr_tbl = swioltb_nr_tbl();
+	if (nr_tbl)
+		xen_io_tlb_nslabs = nr_tbl;
+	else {
+		xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
+		xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
+	}
 
 	bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
 
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 8c0e349..445702c 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -24,6 +24,7 @@ extern int swiotlb_force;
 
 extern void swiotlb_init(int verbose);
 extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
+extern unsigned long swioltb_nr_tbl(void);
 
 /*
  * Enumeration for sync targets
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 93ca08b..99093b3 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -110,6 +110,11 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
+unsigned long swioltb_nr_tbl(void)
+{
+	return io_tlb_nslabs;
+}
+
 /* Note that this doesn't work with highmem page */
 static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 				      volatile void *address)
