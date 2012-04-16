Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2DPUMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:12:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2DPUMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:12:22 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: [EDAC PATCH v13 5/7] edac: rewrite edac_align_ptr()
Date: Mon, 16 Apr 2012 17:12:11 -0300
Message-Id: <1334607133-30039-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The edac_align_ptr() function is used to prepare data for a single
memory allocation kzalloc() call. It counts how many bytes are needed
by some data structure.

Using it as-is is not that trivial, as the quantity of memory elements
reserved is not there, but, instead, it is on a next call.

In order to avoid mistakes when using it, move the number of allocated
elements into it, making easier to use it.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_device.c |   27 +++++++++++----------------
 drivers/edac/edac_mc.c     |   19 +++++++++++++------
 drivers/edac/edac_module.h |    2 +-
 drivers/edac/edac_pci.c    |    7 ++++---
 4 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 4b15459..cb397d9 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -79,7 +79,7 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 	unsigned total_size;
 	unsigned count;
 	unsigned instance, block, attr;
-	void *pvt;
+	void *pvt, *p;
 	int err;
 
 	debugf4("%s() instances=%d blocks=%d\n",
@@ -92,35 +92,30 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 	 * to be at least as stringent as what the compiler would
 	 * provide if we could simply hardcode everything into a single struct.
 	 */
-	dev_ctl = (struct edac_device_ctl_info *)NULL;
+	p = NULL;
+	dev_ctl = edac_align_ptr(&p, sizeof(*dev_ctl), 1);
 
 	/* Calc the 'end' offset past end of ONE ctl_info structure
 	 * which will become the start of the 'instance' array
 	 */
-	dev_inst = edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
+	dev_inst = edac_align_ptr(&p, sizeof(*dev_inst), nr_instances);
 
 	/* Calc the 'end' offset past the instance array within the ctl_info
 	 * which will become the start of the block array
 	 */
-	dev_blk = edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
+	count = nr_instances * nr_blocks;
+	dev_blk = edac_align_ptr(&p, sizeof(*dev_blk), count);
 
 	/* Calc the 'end' offset past the dev_blk array
 	 * which will become the start of the attrib array, if any.
 	 */
-	count = nr_instances * nr_blocks;
-	dev_attrib = edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
-
-	/* Check for case of when an attribute array is specified */
-	if (nr_attrib > 0) {
-		/* calc how many nr_attrib we need */
+	/* calc how many nr_attrib we need */
+	if (nr_attrib > 0)
 		count *= nr_attrib;
+	dev_attrib = edac_align_ptr(&p, sizeof(*dev_attrib), count);
 
-		/* Calc the 'end' offset past the attributes array */
-		pvt = edac_align_ptr(&dev_attrib[count], sz_private);
-	} else {
-		/* no attribute array specificed */
-		pvt = edac_align_ptr(dev_attrib, sz_private);
-	}
+	/* Calc the 'end' offset past the attributes array */
+	pvt = edac_align_ptr(&p, sz_private, 1);
 
 	/* 'pvt' now points to where the private data area is.
 	 * At this point 'pvt' (like dev_inst,dev_blk and dev_attrib)
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index ffedae9..98de5d1 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -108,9 +108,12 @@ EXPORT_SYMBOL_GPL(edac_mem_types);
  * If 'size' is a constant, the compiler will optimize this whole function
  * down to either a no-op or the addition of a constant to the value of 'ptr'.
  */
-void *edac_align_ptr(void *ptr, unsigned size)
+void *edac_align_ptr(void **p, unsigned size, int quant)
 {
 	unsigned align, r;
+	void *ptr = *p;
+
+	*p += size * quant;
 
 	/* Here we assume that the alignment of a "long long" is the most
 	 * stringent alignment that the compiler will ever provide by default.
@@ -132,6 +135,8 @@ void *edac_align_ptr(void *ptr, unsigned size)
 	if (r == 0)
 		return (char *)ptr;
 
+	*p += align - r;
+
 	return (void *)(((unsigned long)ptr) + align - r);
 }
 
@@ -154,6 +159,7 @@ void *edac_align_ptr(void *ptr, unsigned size)
 struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 				unsigned nr_chans, int edac_index)
 {
+	void *ptr;
 	struct mem_ctl_info *mci;
 	struct csrow_info *csi, *csrow;
 	struct rank_info *chi, *chp, *chan;
@@ -168,11 +174,12 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	 * stringent as what the compiler would provide if we could simply
 	 * hardcode everything into a single struct.
 	 */
-	mci = (struct mem_ctl_info *)0;
-	csi = edac_align_ptr(&mci[1], sizeof(*csi));
-	chi = edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
-	dimm = edac_align_ptr(&chi[nr_chans * nr_csrows], sizeof(*dimm));
-	pvt = edac_align_ptr(&dimm[nr_chans * nr_csrows], sz_pvt);
+	ptr = 0;
+	mci = edac_align_ptr(&ptr, sizeof(*mci), 1);
+	csi = edac_align_ptr(&ptr, sizeof(*csi), nr_csrows);
+	chi = edac_align_ptr(&ptr, sizeof(*chi), nr_csrows * nr_chans);
+	dimm = edac_align_ptr(ptr, sizeof(*dimm), nr_csrows * nr_chans);
+	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
 	size = ((unsigned long)pvt) + sz_pvt;
 
 	mci = kzalloc(size, GFP_KERNEL);
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 00f81b4..0be4b01 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -50,7 +50,7 @@ extern void edac_device_reset_delay_period(struct edac_device_ctl_info
 					   *edac_dev, unsigned long value);
 extern void edac_mc_reset_delay_period(int value);
 
-extern void *edac_align_ptr(void *ptr, unsigned size);
+extern void *edac_align_ptr(void **p, unsigned size, int quant);
 
 /*
  * EDAC PCI functions
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 63af1c5..9016560 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -42,13 +42,14 @@ struct edac_pci_ctl_info *edac_pci_alloc_ctl_info(unsigned int sz_pvt,
 						const char *edac_pci_name)
 {
 	struct edac_pci_ctl_info *pci;
-	void *pvt;
+	void *p, *pvt;
 	unsigned int size;
 
 	debugf1("%s()\n", __func__);
 
-	pci = (struct edac_pci_ctl_info *)0;
-	pvt = edac_align_ptr(&pci[1], sz_pvt);
+	p = 0;
+	pci = edac_align_ptr(&p, sizeof(*pci), 1);
+	pvt = edac_align_ptr(&p, 1, sz_pvt);
 	size = ((unsigned long)pvt) + sz_pvt;
 
 	/* Alloc the needed control struct memory */
-- 
1.7.8

