Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2CGLkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:40:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397Ab2CGLkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:40:45 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] edac: Don't initialize csrow's first_page & friends when not needed
Date: Wed,  7 Mar 2012 08:40:36 -0300
Message-Id: <1331120438-27523-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost all edac	drivers	initialize first_page, last_page and
page_mask. Those vars are used inside the EDAC core, in	order to
calculate the csrow affected by	an error, by using the routine
edac_mc_find_csrow_by_page().

However, very few drivers actually use it:
        e752x_edac.c
        e7xxx_edac.c
        i3000_edac.c
        i82443bxgx_edac.c
        i82860_edac.c
        i82875p_edac.c
        i82975x_edac.c
        r82600_edac.c

There also a few other drivers that have their own calculus
formula internally using those vars.

All the others are just wasting time by initializing those
data.

While initializing data without using them won't cause any troubles, as
those information is stored at the wrong place (at csrows structure), it
is better to remove what is unused, in order to simplify the next patch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c   |   38 ++------------------------------------
 drivers/edac/i3200_edac.c   |    5 -----
 drivers/edac/i5000_edac.c   |    5 -----
 drivers/edac/i5100_edac.c   |    2 --
 drivers/edac/i5400_edac.c   |    5 -----
 drivers/edac/i7300_edac.c   |    5 +----
 drivers/edac/i7core_edac.c  |    5 -----
 drivers/edac/mv64x60_edac.c |    1 -
 drivers/edac/ppc4xx_edac.c  |    7 -------
 drivers/edac/sb_edac.c      |    2 --
 drivers/edac/tile_edac.c    |    2 --
 drivers/edac/x38_edac.c     |    5 -----
 12 files changed, 3 insertions(+), 79 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3e7bddc..b1b1551 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -715,25 +715,6 @@ static inline u64 input_addr_to_sys_addr(struct mem_ctl_info *mci,
 				     input_addr_to_dram_addr(mci, input_addr));
 }
 
-/*
- * Find the minimum and maximum InputAddr values that map to the given @csrow.
- * Pass back these values in *input_addr_min and *input_addr_max.
- */
-static void find_csrow_limits(struct mem_ctl_info *mci, int csrow,
-			      u64 *input_addr_min, u64 *input_addr_max)
-{
-	struct amd64_pvt *pvt;
-	u64 base, mask;
-
-	pvt = mci->pvt_info;
-	BUG_ON((csrow < 0) || (csrow >= pvt->csels[0].b_cnt));
-
-	get_cs_base_and_mask(pvt, csrow, 0, &base, &mask);
-
-	*input_addr_min = base & ~mask;
-	*input_addr_max = base | mask;
-}
-
 /* Map the Error address to a PAGE and PAGE OFFSET. */
 static inline void error_address_to_page_and_offset(u64 error_address,
 						    u32 *page, u32 *offset)
@@ -2166,7 +2147,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 {
 	struct csrow_info *csrow;
 	struct amd64_pvt *pvt = mci->pvt_info;
-	u64 input_addr_min, input_addr_max, sys_addr, base, mask;
+	u64 base, mask;
 	u32 val;
 	int i, j, empty = 1;
 	enum mem_type mtype;
@@ -2194,14 +2175,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 
 		empty = 0;
 		csrow->nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
-		find_csrow_limits(mci, i, &input_addr_min, &input_addr_max);
-		sys_addr = input_addr_to_sys_addr(mci, input_addr_min);
-		csrow->first_page = (u32) (sys_addr >> PAGE_SHIFT);
-		sys_addr = input_addr_to_sys_addr(mci, input_addr_max);
-		csrow->last_page = (u32) (sys_addr >> PAGE_SHIFT);
-
 		get_cs_base_and_mask(pvt, i, 0, &base, &mask);
-		csrow->page_mask = ~mask;
 		/* 8 bytes of resolution */
 
 		mtype = amd64_determine_memory_type(pvt, i);
@@ -2221,15 +2195,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 		}
 
 		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
-		debugf1("    input_addr_min: 0x%lx input_addr_max: 0x%lx\n",
-			(unsigned long)input_addr_min,
-			(unsigned long)input_addr_max);
-		debugf1("    sys_addr: 0x%lx  page_mask: 0x%lx\n",
-			(unsigned long)sys_addr, csrow->page_mask);
-		debugf1("    nr_pages: %u  first_page: 0x%lx "
-			"last_page: 0x%lx\n",
-			(unsigned)csrow->nr_pages,
-			csrow->first_page, csrow->last_page);
+		debugf1("    nr_pages: %u\n", csrow->nr_pages);
 	}
 
 	return empty;
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index 38d1e87..8086693 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -332,7 +332,6 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
-	unsigned long last_page;
 	u16 drbs[I3200_CHANNELS][I3200_RANKS_PER_CHANNEL];
 	bool stacked;
 	void __iomem *window;
@@ -377,7 +376,6 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	 * cumulative; the last one will contain the total memory
 	 * contained in all ranks.
 	 */
-	last_page = -1UL;
 	for (i = 0; i < mci->nr_csrows; i++) {
 		unsigned long nr_pages;
 		struct csrow_info *csrow = &mci->csrows[i];
@@ -389,9 +387,6 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 		if (nr_pages == 0)
 			continue;
 
-		csrow->first_page = last_page + 1;
-		last_page += nr_pages;
-		csrow->last_page = last_page;
 		csrow->nr_pages = nr_pages;
 
 		for (j = 0; j < nr_channels; j++) {
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index e612f1e..f00f684 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1263,11 +1263,6 @@ static int i5000_init_csrows(struct mem_ctl_info *mci)
 		if (!MTR_DIMMS_PRESENT(mtr) && !MTR_DIMMS_PRESENT(mtr1))
 			continue;
 
-		/* FAKE OUT VALUES, FIXME */
-		p_csrow->first_page = 0 + csrow * 20;
-		p_csrow->last_page = 9 + csrow * 20;
-		p_csrow->page_mask = 0xFFF;
-
 		csrow_megs = 0;
 		for (channel = 0; channel < pvt->maxch; channel++) {
 			csrow_megs += pvt->dimm_info[csrow][channel].megabytes;
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 50e6d6a..6a53661 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -862,8 +862,6 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 		 * FIXME: these two are totally bogus -- I don't see how to
 		 * map them correctly to this structure...
 		 */
-		mci->csrows[i].first_page = total_pages;
-		mci->csrows[i].last_page = total_pages + npages - 1;
 		mci->csrows[i].nr_pages = npages;
 		mci->csrows[i].csrow_idx = i;
 		mci->csrows[i].mci = mci;
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 229aff5..4a23813 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1180,11 +1180,6 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 		if (!MTR_DIMMS_PRESENT(mtr))
 			continue;
 
-		/* FAKE OUT VALUES, FIXME */
-		p_csrow->first_page = 0 + csrow * 20;
-		p_csrow->last_page = 9 + csrow * 20;
-		p_csrow->page_mask = 0xFFF;
-
 		csrow_megs = 0;
 		for (channel = 0; channel < pvt->maxch; channel++) {
 			csrow_megs += pvt->dimm_info[csrow][channel].megabytes;
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 07a5927..df6cd59 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -778,7 +778,7 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 	int rc = -ENODEV;
 	int mtr;
 	int ch, branch, slot, channel;
-	u32 last_page = 0, nr_pages;
+	u32 nr_pages;
 	struct dimm_info *dimm;
 
 	pvt = mci->pvt_info;
@@ -828,9 +828,6 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 
 				/* Update per_csrow memory count */
 				p_csrow->nr_pages += nr_pages;
-				p_csrow->first_page = last_page;
-				last_page += nr_pages;
-				p_csrow->last_page = last_page;
 
 				rc = 0;
 			}
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index e325314..dd45ef8 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -599,7 +599,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	struct pci_dev *pdev;
 	int i, j;
 	int csrow = 0;
-	unsigned long last_page = 0;
 	enum edac_type mode;
 	enum mem_type mtype;
 	struct dimm_info *dimm;
@@ -716,12 +715,8 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			npages = MiB_TO_PAGES(size);
 
 			csr = &mci->csrows[csrow];
-			csr->first_page = last_page + 1;
-			last_page += npages;
-			csr->last_page = last_page;
 			csr->nr_pages = npages;
 
-			csr->page_mask = 0;
 			csr->csrow_idx = csrow;
 			csr->nr_channels = 1;
 
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 12d7fe0..d2e3c39 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -668,7 +668,6 @@ static void mv64x60_init_csrows(struct mem_ctl_info *mci,
 	csrow = &mci->csrows[0];
 	dimm = csrow->channels[0].dimm;
 	csrow->nr_pages = pdata->total_mem >> PAGE_SHIFT;
-	csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
 	dimm->grain = 8;
 
 	dimm->mtype = (ctl & MV64X60_SDRAM_REGISTERED) ? MEM_RDDR : MEM_DDR;
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 00efc5f..13dbbbe 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -897,7 +897,6 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 	enum edac_type edac_mode;
 	int row, j;
 	u32 mbxcf, size;
-	static u32 ppc4xx_last_page;
 
 	/* Establish the memory type and width */
 
@@ -959,10 +958,6 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 			goto done;
 		}
 
-		csi->first_page = ppc4xx_last_page;
-		csi->last_page	= csi->first_page + csi->nr_pages - 1;
-		csi->page_mask	= 0;
-
 		/*
 		 * It's unclear exactly what grain should be set to
 		 * here. The SDRAM_ECCES register allows resolution of
@@ -984,8 +979,6 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 			dimm->dtype	= dtype;
 
 			dimm->edac_mode	= edac_mode;
-
-		ppc4xx_last_page += csi->nr_pages;
 		}
 	}
 
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 773a69c..b595628 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -641,8 +641,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 				 * csrows.
 				 */
 				csr = &mci->csrows[csrow];
-				csr->first_page = last_page;
-				csr->last_page = last_page + npages - 1;
 				csr->nr_pages = npages;
 				csr->csrow_idx = csrow;
 				csr->nr_channels = 1;
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index db7d2ae..ba0917b 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -110,9 +110,7 @@ static int __devinit tile_edac_init_csrows(struct mem_ctl_info *mci)
 		return -1;
 	}
 
-	csrow->first_page = 0;
 	csrow->nr_pages = mem_info.mem_size >> PAGE_SHIFT;
-	csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
 	dimm->grain = TILE_EDAC_ERROR_GRAIN;
 	dimm->dtype = DEV_UNKNOWN;
 
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 52c8d69..7be10dd 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -319,7 +319,6 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
-	unsigned long last_page;
 	u16 drbs[X38_CHANNELS][X38_RANKS_PER_CHANNEL];
 	bool stacked;
 	void __iomem *window;
@@ -363,7 +362,6 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	 * cumulative; the last one will contain the total memory
 	 * contained in all ranks.
 	 */
-	last_page = -1UL;
 	for (i = 0; i < mci->nr_csrows; i++) {
 		unsigned long nr_pages;
 		struct csrow_info *csrow = &mci->csrows[i];
@@ -375,9 +373,6 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 		if (nr_pages == 0)
 			continue;
 
-		csrow->first_page = last_page + 1;
-		last_page += nr_pages;
-		csrow->last_page = last_page;
 		csrow->nr_pages = nr_pages;
 
 		for (j = 0; j < x38_channel_num; j++) {
-- 
1.7.8

