Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2CGMA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:00:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314Ab2CGMAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:00:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] edac: Fix core support for MC's that see DIMMS instead of ranks
Date: Wed,  7 Mar 2012 09:00:15 -0300
Message-Id: <1331121616-27719-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331121616-27719-1-git-send-email-mchehab@redhat.com>
References: <1331121616-27719-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The edac core were written with the idea that memory controllers
are able to directly access csrows, and that the channels are
used inside a csrows select.

This is not true for FB-DIMM and RAMBUS memory controllers.

Also, some recent advanced memory controllers don't present a per-csrows
view. Instead, they view memories as DIMM's, instead of ranks, accessed
via csrow/channel.

So, change the allocation and error report routines to allow
them to work with all types of architectures.

This allowed to remove several hacks on FB-DIMM and RAMBUS
memory controllers.

Compile-tested all platforms (x86_64, i386, tile and several ppc subarchs).

Also, several tests were done on different platforms using different
x86 drivers.

TODO: a multi-rank DIMM's are currently represented by multiple DIMM
entries at struct dimm_info. That means that changing a label for one
rank won't change the same label for the other ranks at the same dimm.
Such bug is there since the beginning of the EDAC, so it is not a big
deal. However, on several drivers, it is possible to fix this issue, but
it should be a per-driver fix, as the csrow => DIMM arrangement may not
be equal for all. So, don't try to fix it here yet.

PS.: I tried to make this patch as short as possible, preceding it with
several other patches that simplified the logic here. Yet, as the
internal API changes, all drivers need changes. The changes are
generally bigger on the drivers for FB-DIMM's.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c      |  139 ++++++---
 drivers/edac/amd76x_edac.c     |   30 ++-
 drivers/edac/cell_edac.c       |   26 ++-
 drivers/edac/cpc925_edac.c     |   25 ++-
 drivers/edac/e752x_edac.c      |   46 ++-
 drivers/edac/e7xxx_edac.c      |   39 ++-
 drivers/edac/edac_core.h       |   48 +--
 drivers/edac/edac_device.c     |   27 +-
 drivers/edac/edac_mc.c         |  657 +++++++++++++++++++++++-----------------
 drivers/edac/edac_mc_sysfs.c   |   64 +++--
 drivers/edac/edac_module.h     |    2 +-
 drivers/edac/edac_pci.c        |    7 +-
 drivers/edac/i3000_edac.c      |   27 ++-
 drivers/edac/i3200_edac.c      |   33 ++-
 drivers/edac/i5000_edac.c      |   58 +++--
 drivers/edac/i5100_edac.c      |  107 +++----
 drivers/edac/i5400_edac.c      |  217 ++++++++------
 drivers/edac/i7300_edac.c      |   81 ++---
 drivers/edac/i7core_edac.c     |  205 +++----------
 drivers/edac/i82443bxgx_edac.c |   28 +-
 drivers/edac/i82860_edac.c     |   44 ++-
 drivers/edac/i82875p_edac.c    |   31 ++-
 drivers/edac/i82975x_edac.c    |   30 ++-
 drivers/edac/mpc85xx_edac.c    |   29 ++-
 drivers/edac/mv64x60_edac.c    |   25 ++-
 drivers/edac/pasemi_edac.c     |   27 +-
 drivers/edac/ppc4xx_edac.c     |   33 ++-
 drivers/edac/r82600_edac.c     |   29 ++-
 drivers/edac/sb_edac.c         |  161 ++++-------
 drivers/edac/tile_edac.c       |   16 +-
 drivers/edac/x38_edac.c        |   30 ++-
 include/linux/edac.h           |  120 +++++++-
 32 files changed, 1389 insertions(+), 1052 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 377eed8..ea7eb9a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1039,6 +1039,37 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	int channel, csrow;
 	u32 page, offset;
 
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
+
+	/*
+	 * Find out which node the error address belongs to. This may be
+	 * different from the node that detected the error.
+	 */
+	src_mci = find_mc_by_sys_addr(mci, sys_addr);
+	if (!src_mci) {
+		amd64_mc_err(mci, "failed to map error addr 0x%lx to a node\n",
+			     (unsigned long)sys_addr);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a node",
+				     NULL);
+		return;
+	}
+
+	/* Now map the sys_addr to a CSROW */
+	csrow = sys_addr_to_csrow(src_mci, sys_addr);
+	if (csrow < 0) {
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a csrow",
+				     NULL);
+		return;
+	}
+
 	/* CHIPKILL enabled */
 	if (pvt->nbcfg & NBCFG_CHIPKILL) {
 		channel = get_channel_from_ecc_syndrome(mci, syndrome);
@@ -1048,9 +1079,15 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 			 * 2 DIMMs is in error. So we need to ID 'both' of them
 			 * as suspect.
 			 */
-			amd64_mc_warn(mci, "unknown syndrome 0x%04x - possible "
-					   "error reporting race\n", syndrome);
-			edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+			amd64_mc_warn(src_mci, "unknown syndrome 0x%04x - "
+				      "possible error reporting race\n",
+				      syndrome);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     page, offset, syndrome,
+					     csrow, -1, -1,
+					     EDAC_MOD_STR,
+					     "unknown syndrome - possible error reporting race",
+					     NULL);
 			return;
 		}
 	} else {
@@ -1065,28 +1102,10 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 		channel = ((sys_addr & BIT(3)) != 0);
 	}
 
-	/*
-	 * Find out which node the error address belongs to. This may be
-	 * different from the node that detected the error.
-	 */
-	src_mci = find_mc_by_sys_addr(mci, sys_addr);
-	if (!src_mci) {
-		amd64_mc_err(mci, "failed to map error addr 0x%lx to a node\n",
-			     (unsigned long)sys_addr);
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
-		return;
-	}
-
-	/* Now map the sys_addr to a CSROW */
-	csrow = sys_addr_to_csrow(src_mci, sys_addr);
-	if (csrow < 0) {
-		edac_mc_handle_ce_no_info(src_mci, EDAC_MOD_STR);
-	} else {
-		error_address_to_page_and_offset(sys_addr, &page, &offset);
-
-		edac_mc_handle_ce(src_mci, page, offset, syndrome, csrow,
-				  channel, EDAC_MOD_STR);
-	}
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci,
+			     page, offset, syndrome,
+			     csrow, channel, -1,
+			     EDAC_MOD_STR, "", NULL);
 }
 
 static int ddr2_cs_size(unsigned i, bool dct_width)
@@ -1568,15 +1587,20 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	u32 page, offset;
 	int nid, csrow, chan = 0;
 
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
+
 	csrow = f1x_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
 
 	if (csrow < 0) {
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a csrow",
+				     NULL);
 		return;
 	}
 
-	error_address_to_page_and_offset(sys_addr, &page, &offset);
-
 	/*
 	 * We need the syndromes for channel detection only when we're
 	 * ganged. Otherwise @chan should already contain the channel at
@@ -1585,16 +1609,10 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	if (dct_ganging_enabled(pvt))
 		chan = get_channel_from_ecc_syndrome(mci, syndrome);
 
-	if (chan >= 0)
-		edac_mc_handle_ce(mci, page, offset, syndrome, csrow, chan,
-				  EDAC_MOD_STR);
-	else
-		/*
-		 * Channel unknown, report all channels on this CSROW as failed.
-		 */
-		for (chan = 0; chan < mci->csrows[csrow].nr_channels; chan++)
-			edac_mc_handle_ce(mci, page, offset, syndrome,
-					  csrow, chan, EDAC_MOD_STR);
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				page, offset, syndrome,
+				csrow, chan, -1,
+				EDAC_MOD_STR, "", NULL);
 }
 
 /*
@@ -1875,7 +1893,12 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 	/* Ensure that the Error Address is VALID */
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     0, 0, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "HW has no ERROR_ADDRESS available",
+				     NULL);
 		return;
 	}
 
@@ -1899,11 +1922,17 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     0, 0, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "HW has no ERROR_ADDRESS available",
+				     NULL);
 		return;
 	}
 
 	sys_addr = get_error_address(m);
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
 
 	/*
 	 * Find out which node the error address belongs to. This may be
@@ -1913,7 +1942,11 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (!src_mci) {
 		amd64_mc_err(mci, "ERROR ADDRESS (0x%lx) NOT mapped to a MC\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     page, offset, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "ERROR ADDRESS NOT mapped to a MC", NULL);
 		return;
 	}
 
@@ -1923,10 +1956,17 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (csrow < 0) {
 		amd64_mc_err(mci, "ERROR_ADDRESS (0x%lx) NOT mapped to CS\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     page, offset, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "ERROR ADDRESS NOT mapped to CS",
+				     NULL);
 	} else {
-		error_address_to_page_and_offset(sys_addr, &page, &offset);
-		edac_mc_handle_ue(log_mci, page, offset, csrow, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     page, offset, 0,
+				     csrow, -1, -1,
+				     EDAC_MOD_STR, "", NULL);
 	}
 }
 
@@ -2187,7 +2227,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 		for (j = 0; j < pvt->channel_count; j++) {
 			csrow->channels[j].dimm->mtype = mtype;
 			csrow->channels[j].dimm->edac_mode = edac_mode;
-			csrow->channels[j].dimm->nr_pages = nr_pages;
+			csrow->channels[j].dimm->nr_pages = nr_pages / pvt->channel_count;
 
 		}
 
@@ -2487,6 +2527,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct amd64_pvt *pvt = NULL;
 	struct amd64_family_type *fam_type = NULL;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	int err = 0, ret;
 	u8 nid = get_node_id(F2);
 
@@ -2521,7 +2562,13 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 		goto err_siblings;
 
 	ret = -ENOMEM;
-	mci = edac_mc_alloc(0, pvt->csels[0].b_cnt, pvt->channel_count, nid);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = pvt->csels[0].b_cnt;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = pvt->channel_count;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(nid, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		goto err_siblings;
 
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index 1532750..4f3e54a 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -29,7 +29,6 @@
 	edac_mc_chipset_printk(mci, level, "amd76x", fmt, ##arg)
 
 #define AMD76X_NR_CSROWS 8
-#define AMD76X_NR_CHANS  1
 #define AMD76X_NR_DIMMS  4
 
 /* AMD 76x register addresses - device 0 function 0 - PCI bridge */
@@ -146,8 +145,10 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors) {
 			row = (info->ecc_mode_status >> 4) & 0xf;
-			edac_mc_handle_ue(mci, mci->csrows[row].first_page, 0,
-					row, mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     mci->csrows[row].first_page, 0, 0,
+					     row, 0, -1,
+					     mci->ctl_name, "", NULL);
 		}
 	}
 
@@ -159,8 +160,10 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors) {
 			row = info->ecc_mode_status & 0xf;
-			edac_mc_handle_ce(mci, mci->csrows[row].first_page, 0,
-					0, row, 0, mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     mci->csrows[row].first_page, 0, 0,
+					     row, 0, -1,
+					     mci->ctl_name, "", NULL);
 		}
 	}
 
@@ -190,7 +193,7 @@ static void amd76x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	u32 mba, mba_base, mba_mask, dms;
 	int index;
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 		dimm = csrow->channels[0].dimm;
 
@@ -232,7 +235,8 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 		EDAC_SECDED,
 		EDAC_SECDED
 	};
-	struct mem_ctl_info *mci = NULL;
+	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	u32 ems;
 	u32 ems_mode;
 	struct amd76x_error_info discard;
@@ -240,11 +244,17 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	debugf0("%s()\n", __func__);
 	pci_read_config_dword(pdev, AMD76X_ECC_MODE_STATUS, &ems);
 	ems_mode = (ems >> 10) & 0x3;
-	mci = edac_mc_alloc(0, AMD76X_NR_CSROWS, AMD76X_NR_CHANS, 0);
 
-	if (mci == NULL) {
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = AMD76X_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = 1;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
+
+	if (mci == NULL)
 		return -ENOMEM;
-	}
 
 	debugf0("%s(): mci = %p\n", __func__, mci);
 	mci->dev = &pdev->dev;
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index 09e1b5d..39616a3 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -48,8 +48,9 @@ static void cell_edac_count_ce(struct mem_ctl_info *mci, int chan, u64 ar)
 	syndrome = (ar & 0x000000001fe00000ul) >> 21;
 
 	/* TODO: Decoding of the error address */
-	edac_mc_handle_ce(mci, csrow->first_page + pfn, offset,
-			  syndrome, 0, chan, "");
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			     csrow->first_page + pfn, offset, syndrome,
+			     0, chan, -1, "", "", NULL);
 }
 
 static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
@@ -69,7 +70,9 @@ static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
 	offset = address & ~PAGE_MASK;
 
 	/* TODO: Decoding of the error address */
-	edac_mc_handle_ue(mci, csrow->first_page + pfn, offset, 0, "");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			     csrow->first_page + pfn, offset, 0,
+			     0, chan, -1, "", "", NULL);
 }
 
 static void cell_edac_check(struct mem_ctl_info *mci)
@@ -156,7 +159,7 @@ static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 			"Initialized on node %d, chanmask=0x%x,"
 			" first_page=0x%lx, nr_pages=0x%x\n",
 			priv->node, priv->chanmask,
-			csrow->first_page, dimm->nr_pages);
+			csrow->first_page, nr_pages);
 		break;
 	}
 }
@@ -165,9 +168,10 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 {
 	struct cbe_mic_tm_regs __iomem	*regs;
 	struct mem_ctl_info		*mci;
+	struct edac_mc_layer		layers[2];
 	struct cell_edac_priv		*priv;
 	u64				reg;
-	int				rc, chanmask;
+	int				rc, chanmask, num_chans;
 
 	regs = cbe_get_cpu_mic_tm_regs(cbe_node_to_cpu(pdev->id));
 	if (regs == NULL)
@@ -192,8 +196,16 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 		in_be64(&regs->mic_fir));
 
 	/* Allocate & init EDAC MC data structure */
-	mci = edac_mc_alloc(sizeof(struct cell_edac_priv), 1,
-			    chanmask == 3 ? 2 : 1, pdev->id);
+	num_chans = chanmask == 3 ? 2 : 1;
+
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = 1;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = num_chans;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(pdev->id, ARRAY_SIZE(layers), layers, false,
+			    sizeof(struct cell_edac_priv));
 	if (mci == NULL)
 		return -ENOMEM;
 	priv = mci->pvt_info;
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 7b764a8..eb6297d 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -336,7 +336,7 @@ static void cpc925_init_csrows(struct mem_ctl_info *mci)
 
 	get_total_mem(pdata);
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		mbmr = __raw_readl(pdata->vbase + REG_MBMR_OFFSET +
 				   0x20 * index);
 		mbbar = __raw_readl(pdata->vbase + REG_MBBAR_OFFSET +
@@ -555,13 +555,18 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 	if (apiexcp & CECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM CECC Fault\n");
 		channel = cpc925_mc_find_channel(mci, syndrome);
-		edac_mc_handle_ce(mci, pfn, offset, syndrome,
-				  csrow, channel, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     pfn, offset, syndrome,
+				     csrow, channel, -1,
+				     mci->ctl_name, "", NULL);
 	}
 
 	if (apiexcp & UECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM UECC Fault\n");
-		edac_mc_handle_ue(mci, pfn, offset, csrow, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     pfn, offset, 0,
+				     csrow, -1, -1,
+				     mci->ctl_name, "", NULL);
 	}
 
 	cpc925_mc_printk(mci, KERN_INFO, "Dump registers:\n");
@@ -933,6 +938,7 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 {
 	static int edac_mc_idx;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	void __iomem *vbase;
 	struct cpc925_mc_pdata *pdata;
 	struct resource *r;
@@ -969,8 +975,15 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	}
 
 	nr_channels = cpc925_mc_get_channels(vbase) + 1;
-	mci = edac_mc_alloc(sizeof(struct cpc925_mc_pdata),
-			CPC925_NR_CSROWS, nr_channels, edac_mc_idx);
+
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = CPC925_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_channels;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
+			    sizeof(struct cpc925_mc_pdata));
 	if (!mci) {
 		cpc925_printk(KERN_ERR, "No memory for mem_ctl_info\n");
 		res = -ENOMEM;
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 310f657..1acce46 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -6,6 +6,9 @@
  *
  * See "enum e752x_chips" below for supported chipsets
  *
+ * Datasheet:
+ *	http://www.intel.in/content/www/in/en/chipsets/e7525-memory-controller-hub-datasheet.html
+ *
  * Written by Tom Zimmerman
  *
  * Contributors:
@@ -350,8 +353,10 @@ static void do_process_ce(struct mem_ctl_info *mci, u16 error_one,
 	channel = !(error_one & 1);
 
 	/* e752x mc reads 34:6 of the DRAM linear address */
-	edac_mc_handle_ce(mci, page, offset_in_page(sec1_add << 4),
-			sec1_syndrome, row, channel, "e752x CE");
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			     page, offset_in_page(sec1_add << 4), sec1_syndrome,
+			     row, channel, -1,
+			     "e752x CE", "", NULL);
 }
 
 static inline void process_ce(struct mem_ctl_info *mci, u16 error_one,
@@ -385,9 +390,12 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
-		edac_mc_handle_ue(mci, block_page,
-				offset_in_page(error_2b << 4),
-				row, "e752x UE from Read");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					block_page,
+					offset_in_page(error_2b << 4), 0,
+					 row, -1, -1,
+					"e752x UE from Read", "", NULL);
+
 	}
 	if (error_one & 0x0404) {
 		error_2b = scrb_add;
@@ -401,9 +409,11 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
-		edac_mc_handle_ue(mci, block_page,
-				offset_in_page(error_2b << 4),
-				row, "e752x UE from Scruber");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					block_page,
+					offset_in_page(error_2b << 4), 0,
+					row, -1, -1,
+					"e752x UE from Scruber", "", NULL);
 	}
 }
 
@@ -426,7 +436,9 @@ static inline void process_ue_no_info_wr(struct mem_ctl_info *mci,
 		return;
 
 	debugf3("%s()\n", __func__);
-	edac_mc_handle_ue_no_info(mci, "e752x UE log memory write");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+			     -1, -1, -1,
+			     "e752x UE log memory write", "", NULL);
 }
 
 static void do_process_ded_retry(struct mem_ctl_info *mci, u16 error,
@@ -1062,7 +1074,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	 * channel operation).  DRB regs are cumulative; therefore DRB7 will
 	 * contain the total memory contained in all eight rows.
 	 */
-	for (last_cumul_size = index = 0; index < mci->nr_csrows; index++) {
+	for (last_cumul_size = index = 0; index < mci->num_csrows; index++) {
 		/* mem_dev 0=x8, 1=x4 */
 		mem_dev = (dra >> (index * 4 + 2)) & 0x3;
 		csrow = &mci->csrows[remap_csrow_index(mci, index)];
@@ -1232,6 +1244,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	u16 pci_data;
 	u8 stat8;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct e752x_pvt *pvt;
 	u16 ddrcsr;
 	int drc_chan;		/* Number of channels 0=1chan,1=2chan */
@@ -1258,11 +1271,16 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	/* Dual channel = 1, Single channel = 0 */
 	drc_chan = dual_channel_active(ddrcsr);
 
-	mci = edac_mc_alloc(sizeof(*pvt), E752X_NR_CSROWS, drc_chan + 1, 0);
-
-	if (mci == NULL) {
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = E752X_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = drc_chan + 1;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+			    false, sizeof(*pvt));
+	if (mci == NULL)
 		return -ENOMEM;
-	}
 
 	debugf3("%s(): init mci\n", __func__);
 	mci->mtype_cap = MEM_FLAG_RDDR;
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 2005d80..f59dc0c 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -10,6 +10,9 @@
  * Based on work by Dan Hollis <goemon at anime dot net> and others.
  *	http://www.anime.net/~goemon/linux-ecc/
  *
+ * Datasheet:
+ *	http://www.intel.com/content/www/us/en/chipsets/e7501-chipset-memory-controller-hub-datasheet.html
+ *
  * Contributors:
  *	Eric Biederman (Linux Networx)
  *	Tom Zimmerman (Linux Networx)
@@ -71,7 +74,7 @@
 #endif				/* PCI_DEVICE_ID_INTEL_7505_1_ERR */
 
 #define E7XXX_NR_CSROWS		8	/* number of csrows */
-#define E7XXX_NR_DIMMS		8	/* FIXME - is this correct? */
+#define E7XXX_NR_DIMMS		8	/* 2 channels, 4 dimms/channel */
 
 /* E7XXX register addresses - device 0 function 0 */
 #define E7XXX_DRB		0x60	/* DRAM row boundary register (8b) */
@@ -216,13 +219,15 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	row = edac_mc_find_csrow_by_page(mci, page);
 	/* convert syndrome to channel */
 	channel = e7xxx_find_channel(syndrome);
-	edac_mc_handle_ce(mci, page, 0, syndrome, row, channel, "e7xxx CE");
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, page, 0, syndrome,
+			     row, channel, -1, "e7xxx CE", "", NULL);
 }
 
 static void process_ce_no_info(struct mem_ctl_info *mci)
 {
 	debugf3("%s()\n", __func__);
-	edac_mc_handle_ce_no_info(mci, "e7xxx CE log register overflow");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
+			     "e7xxx CE log register overflow", "", NULL);
 }
 
 static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
@@ -236,13 +241,17 @@ static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	/* FIXME - should use PAGE_SHIFT */
 	block_page = error_2b >> 6;	/* convert to 4k address */
 	row = edac_mc_find_csrow_by_page(mci, block_page);
-	edac_mc_handle_ue(mci, block_page, 0, row, "e7xxx UE");
+
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, block_page, 0, 0,
+			     row, -1, -1, "e7xxx UE", "", NULL);
 }
 
 static void process_ue_no_info(struct mem_ctl_info *mci)
 {
 	debugf3("%s()\n", __func__);
-	edac_mc_handle_ue_no_info(mci, "e7xxx UE log register overflow");
+
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
+			     "e7xxx UE log register overflow", "", NULL);
 }
 
 static void e7xxx_get_error_info(struct mem_ctl_info *mci,
@@ -365,7 +374,7 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	 * channel operation).  DRB regs are cumulative; therefore DRB7 will
 	 * contain the total memory contained in all eight rows.
 	 */
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		/* mem_dev 0=x8, 1=x4 */
 		mem_dev = (dra >> (index * 4 + 3)) & 0x1;
 		csrow = &mci->csrows[index];
@@ -413,6 +422,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	u16 pci_data;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	struct e7xxx_pvt *pvt = NULL;
 	u32 drc;
 	int drc_chan;
@@ -423,8 +433,21 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	pci_read_config_dword(pdev, E7XXX_DRC, &drc);
 
 	drc_chan = dual_channel_active(drc, dev_idx);
-	mci = edac_mc_alloc(sizeof(*pvt), E7XXX_NR_CSROWS, drc_chan + 1, 0);
-
+	/*
+	 * According with the datasheet, this device has a maximum of
+	 * 4 DIMMS per channel, either single-rank or dual-rank. So, the
+	 * total amount of dimms is 8 (E7XXX_NR_DIMMS).
+	 * That means that the DIMM is mapped as CSROWs, and the channel
+	 * will map the rank. So, an error to either channel should be
+	 * attributed to the same dimm.
+	 */
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = E7XXX_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = drc_chan + 1;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (mci == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index fe90cd4..1d421d3 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -448,8 +448,11 @@ static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
 
 #endif				/* CONFIG_PCI */
 
-extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-					  unsigned nr_chans, int edac_index);
+struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
+				   unsigned n_layers,
+				   struct edac_mc_layer *layers,
+				   bool rev_order,
+				   unsigned sz_pvt);
 extern int edac_mc_add_mc(struct mem_ctl_info *mci);
 extern void edac_mc_free(struct mem_ctl_info *mci);
 extern struct mem_ctl_info *edac_mc_find(int idx);
@@ -457,35 +460,17 @@ extern struct mem_ctl_info *find_mci_by_dev(struct device *dev);
 extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
 extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
 				      unsigned long page);
-
-/*
- * The no info errors are used when error overflows are reported.
- * There are a limited number of error logging registers that can
- * be exausted.  When all registers are exhausted and an additional
- * error occurs then an error overflow register records that an
- * error occurred and the type of error, but doesn't have any
- * further information.  The ce/ue versions make for cleaner
- * reporting logic and function interface - reduces conditional
- * statement clutter and extra function arguments.
- */
-extern void edac_mc_handle_ce(struct mem_ctl_info *mci,
-			      unsigned long page_frame_number,
-			      unsigned long offset_in_page,
-			      unsigned long syndrome, int row, int channel,
-			      const char *msg);
-extern void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci,
-				      const char *msg);
-extern void edac_mc_handle_ue(struct mem_ctl_info *mci,
-			      unsigned long page_frame_number,
-			      unsigned long offset_in_page, int row,
-			      const char *msg);
-extern void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
-				      const char *msg);
-extern void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci, unsigned int csrow,
-				  unsigned int channel0, unsigned int channel1,
-				  char *msg);
-extern void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci, unsigned int csrow,
-				  unsigned int channel, char *msg);
+void edac_mc_handle_error(const enum hw_event_mc_err_type type,
+			  struct mem_ctl_info *mci,
+			  const unsigned long page_frame_number,
+			  const unsigned long offset_in_page,
+			  const unsigned long syndrome,
+			  const int layer0,
+			  const int layer1,
+			  const int layer2,
+			  const char *msg,
+			  const char *other_detail,
+			  const void *mcelog);
 
 /*
  * edac_device APIs
@@ -497,6 +482,7 @@ extern void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
 extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
 				int inst_nr, int block_nr, const char *msg);
 extern int edac_device_alloc_index(void);
+extern const char *edac_layer_name[];
 
 /*
  * edac_pci APIs
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index c3f6743..a9a5b6c 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -80,7 +80,7 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 	unsigned total_size;
 	unsigned count;
 	unsigned instance, block, attr;
-	void *pvt;
+	void *pvt, *p;
 	int err;
 
 	debugf4("%s() instances=%d blocks=%d\n",
@@ -93,35 +93,30 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
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
index c7a565a..843e4c1 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -45,10 +45,25 @@ static void edac_mc_dump_channel(struct rank_info *chan)
 	debugf4("\tchannel = %p\n", chan);
 	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
 	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
+	debugf4("\tchannel->dimm = %p\n", chan->dimm);
+}
 
-	debugf4("\tdimm->ce_count = %d\n", chan->dimm->ce_count);
-	debugf4("\tdimm->label = '%s'\n", chan->dimm->label);
-	debugf4("\tdimm->nr_pages = 0x%x\n", chan->dimm->nr_pages);
+static void edac_mc_dump_dimm(struct dimm_info *dimm)
+{
+	int i;
+
+	debugf4("\tdimm = %p\n", dimm);
+	debugf4("\tdimm->label = '%s'\n", dimm->label);
+	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
+	debugf4("\tdimm location ");
+	for (i = 0; i < dimm->mci->n_layers; i++) {
+		printk(KERN_CONT "%d", dimm->location[i]);
+		if (i < dimm->mci->n_layers - 1)
+			printk(KERN_CONT ".");
+	}
+	printk(KERN_CONT "\n");
+	debugf4("\tdimm->grain = %d\n", dimm->grain);
+	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
 }
 
 static void edac_mc_dump_csrow(struct csrow_info *csrow)
@@ -70,8 +85,10 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 	debugf3("\tmci->edac_ctl_cap = %lx\n", mci->edac_ctl_cap);
 	debugf3("\tmci->edac_cap = %lx\n", mci->edac_cap);
 	debugf4("\tmci->edac_check = %p\n", mci->edac_check);
-	debugf3("\tmci->nr_csrows = %d, csrows = %p\n",
-		mci->nr_csrows, mci->csrows);
+	debugf3("\tmci->num_csrows = %d, csrows = %p\n",
+		mci->num_csrows, mci->csrows);
+	debugf3("\tmci->nr_dimms = %d, dimns = %p\n",
+		mci->tot_dimms, mci->dimms);
 	debugf3("\tdev = %p\n", mci->dev);
 	debugf3("\tmod_name:ctl_name = %s:%s\n", mci->mod_name, mci->ctl_name);
 	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
@@ -110,9 +127,12 @@ EXPORT_SYMBOL_GPL(edac_mem_types);
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
@@ -134,14 +154,31 @@ void *edac_align_ptr(void *ptr, unsigned size)
 	if (r == 0)
 		return (char *)ptr;
 
+	*p += align - r;
+
 	return (void *)(((unsigned long)ptr) + align - r);
 }
 
 /**
- * edac_mc_alloc: Allocate a struct mem_ctl_info structure
- * @size_pvt:	size of private storage needed
- * @nr_csrows:	Number of CWROWS needed for this MC
- * @nr_chans:	Number of channels for the MC
+ * edac_mc_alloc: Allocate and partially fills a struct mem_ctl_info structure
+ * @edac_index:		Memory controller number
+ * @n_layers:		Number of layers at the MC hierarchy
+ * layers:		Describes each layer as seen by the Memory Controller
+ * @rev_order:		Fills csrows/cs channels at the reverse order
+ * @size_pvt:		size of private storage needed
+ *
+ *
+ * FIXME: drivers handle multi-rank memories on different ways: on some
+ * drivers, one multi-rank memory is mapped as one DIMM, while, on others,
+ * a single multi-rank DIMM would be mapped into several "dimms".
+ *
+ * Non-csrow based drivers (like FB-DIMM and RAMBUS ones) will likely report
+ * such DIMMS properly, but the CSROWS-based ones will likely do the wrong
+ * thing, as two chip select values are used for dual-rank memories (and 4, for
+ * quad-rank ones). I suspect that this issue could be solved inside the EDAC
+ * core for SDRAM memories, but it requires further study at JEDEC JESD 21C.
+ *
+ * In summary, solving this issue is not easy, as it requires a lot of testing.
  *
  * Everything is kmalloc'ed as one big chunk - more efficient.
  * Only can be used if all structures have the same lifetime - otherwise
@@ -153,30 +190,64 @@ void *edac_align_ptr(void *ptr, unsigned size)
  *	NULL allocation failed
  *	struct mem_ctl_info pointer
  */
-struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-				unsigned nr_chans, int edac_index)
+struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
+				   unsigned n_layers,
+				   struct edac_mc_layer *layers,
+				   bool rev_order,
+				   unsigned sz_pvt)
 {
+	void *ptr;
 	struct mem_ctl_info *mci;
-	struct csrow_info *csi, *csrow;
+	struct edac_mc_layer *lay;
+	struct csrow_info *csi, *csr;
 	struct rank_info *chi, *chp, *chan;
 	struct dimm_info *dimm;
+	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
 	void *pvt;
-	unsigned size;
-	int row, chn;
+	unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
+	unsigned tot_csrows, tot_cschannels;
+	int i, j;
 	int err;
+	int row, chn;
+
+	BUG_ON(n_layers > EDAC_MAX_LAYERS);
+	/*
+	 * Calculate the total amount of dimms and csrows/cschannels while
+	 * in the old API emulation mode
+	 */
+	tot_dimms = 1;
+	tot_cschannels = 1;
+	tot_csrows = 1;
+	for (i = 0; i < n_layers; i++) {
+		tot_dimms *= layers[i].size;
+		if (layers[i].is_csrow)
+			tot_csrows *= layers[i].size;
+		else
+			tot_cschannels *= layers[i].size;
+	}
 
 	/* Figure out the offsets of the various items from the start of an mc
 	 * structure.  We want the alignment of each item to be at least as
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
+	lay = edac_align_ptr(&ptr, sizeof(*lay), n_layers);
+	csi = edac_align_ptr(&ptr, sizeof(*csi), tot_csrows);
+	chi = edac_align_ptr(&ptr, sizeof(*chi), tot_csrows * tot_cschannels);
+	dimm = edac_align_ptr(&ptr, sizeof(*dimm), tot_dimms);
+	count = 1;
+	for (i = 0; i < n_layers; i++) {
+		count *= layers[i].size;
+		ce_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
+		ue_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
+	}
+	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
 	size = ((unsigned long)pvt) + sz_pvt;
 
+	debugf1("%s(): allocating %u bytes for mci data (%d dimms, %d csrows/channels)\n",
+		__func__, size, tot_dimms, tot_csrows * tot_cschannels);
 	mci = kzalloc(size, GFP_KERNEL);
 	if (mci == NULL)
 		return NULL;
@@ -184,44 +255,99 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	/* Adjust pointers so they point within the memory we just allocated
 	 * rather than an imaginary chunk of memory located at address 0.
 	 */
+	lay = (struct edac_mc_layer *)(((char *)mci) + ((unsigned long)lay));
+	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
 	chi = (struct rank_info *)(((char *)mci) + ((unsigned long)chi));
 	dimm = (struct dimm_info *)(((char *)mci) + ((unsigned long)dimm));
+	for (i = 0; i < n_layers; i++) {
+		mci->ce_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ce_per_layer[i]));
+		mci->ue_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ue_per_layer[i]));
+	}
 	pvt = sz_pvt ? (((char *)mci) + ((unsigned long)pvt)) : NULL;
 
 	/* setup index and various internal pointers */
 	mci->mc_idx = edac_index;
 	mci->csrows = csi;
 	mci->dimms  = dimm;
+	mci->tot_dimms = tot_dimms;
 	mci->pvt_info = pvt;
-	mci->nr_csrows = nr_csrows;
-
-	for (row = 0; row < nr_csrows; row++) {
-		csrow = &csi[row];
-		csrow->csrow_idx = row;
-		csrow->mci = mci;
-		csrow->nr_channels = nr_chans;
-		chp = &chi[row * nr_chans];
-		csrow->channels = chp;
+	mci->n_layers = n_layers;
+	mci->layers = lay;
+	memcpy(mci->layers, layers, sizeof(*lay) * n_layers);
+	mci->num_csrows = tot_csrows;
+	mci->num_cschannel = tot_cschannels;
 
-		for (chn = 0; chn < nr_chans; chn++) {
+	/*
+	 * Fills the csrow struct
+	 */
+	for (row = 0; row < tot_csrows; row++) {
+		csr = &csi[row];
+		csr->csrow_idx = row;
+		csr->mci = mci;
+		csr->nr_channels = tot_cschannels;
+		chp = &chi[row * tot_cschannels];
+		csr->channels = chp;
+
+		for (chn = 0; chn < tot_cschannels; chn++) {
 			chan = &chp[chn];
 			chan->chan_idx = chn;
-			chan->csrow = csrow;
+			chan->csrow = csr;
 		}
 	}
 
 	/*
-	 * By default, assumes that a per-csrow arrangement will be used,
-	 * as most drivers are based on such assumption.
+	 * Fills the dimm struct
 	 */
-	dimm = mci->dimms;
-	for (row = 0; row < mci->nr_csrows; row++) {
-		for (chn = 0; chn < mci->csrows[row].nr_channels; chn++) {
-			mci->csrows[row].channels[chn].dimm = dimm;
-			dimm->csrow = row;
-			dimm->csrow_channel = chn;
-			dimm++;
-			mci->nr_dimms++;
+	memset(&pos, 0, sizeof(pos));
+	row = 0;
+	chn = 0;
+	debugf4("%s: initializing %d dimms\n", __func__, tot_dimms);
+	for (i = 0; i < tot_dimms; i++) {
+		chan = &csi[row].channels[chn];
+		dimm = GET_POS(lay, mci->dimms, n_layers,
+			       pos[0], pos[1], pos[2]);
+		dimm->mci = mci;
+
+		debugf2("%s: %d: dimm%zd (%d:%d:%d): row %d, chan %d\n", __func__,
+			i, (dimm - mci->dimms),
+			pos[0], pos[1], pos[2], row, chn);
+
+		/* Copy DIMM location */
+		for (j = 0; j < n_layers; j++)
+			dimm->location[j] = pos[j];
+
+		/* Link it to the csrows old API data */
+		chan->dimm = dimm;
+		dimm->csrow = row;
+		dimm->cschannel = chn;
+
+		/* Increment csrow location */
+		if (!rev_order) {
+			for (j = n_layers - 1; j >= 0; j--)
+				if (!layers[j].is_csrow)
+					break;
+			chn++;
+			if (chn == tot_cschannels) {
+				chn = 0;
+				row++;
+			}
+		} else {
+			for (j = n_layers - 1; j >= 0; j--)
+				if (layers[j].is_csrow)
+					break;
+			row++;
+			if (row == tot_csrows) {
+				row = 0;
+				chn++;
+			}
+		}
+
+		/* Increment dimm location */
+		for (j = n_layers - 1; j >= 0; j--) {
+			pos[j]++;
+			if (pos[j] < layers[j].size)
+				break;
+			pos[j] = 0;
 		}
 	}
 
@@ -510,7 +636,6 @@ EXPORT_SYMBOL(edac_mc_find);
  * edac_mc_add_mc: Insert the 'mci' structure into the mci global list and
  *                 create sysfs entries associated with mci structure
  * @mci: pointer to the mci structure to be added to the list
- * @mc_idx: A unique numeric identifier to be assigned to the 'mci' structure.
  *
  * Return:
  *	0	Success
@@ -528,13 +653,15 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 
 	if (edac_debug_level >= 4) {
 		int i;
-		for (i = 0; i < mci->nr_csrows; i++) {
+		for (i = 0; i < mci->num_csrows; i++) {
 			int j;
 			edac_mc_dump_csrow(&mci->csrows[i]);
 			for (j = 0; j < mci->csrows[i].nr_channels; j++)
 				edac_mc_dump_channel(&mci->csrows[i].
 						channels[j]);
 		}
+		for (i = 0; i < mci->tot_dimms; i++)
+			edac_mc_dump_dimm(&mci->dimms[i]);
 	}
 #endif
 	mutex_lock(&mem_ctls_mutex);
@@ -659,7 +786,7 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 	debugf1("MC%d: %s(): 0x%lx\n", mci->mc_idx, __func__, page);
 	row = -1;
 
-	for (i = 0; i < mci->nr_csrows; i++) {
+	for (i = 0; i < mci->num_csrows; i++) {
 		struct csrow_info *csrow = &csrows[i];
 		n = 0;
 		for (j = 0; j < csrow->nr_channels; j++) {
@@ -675,9 +802,9 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 			csrow->page_mask);
 
 		if ((page >= csrow->first_page) &&
-		(page <= csrow->last_page) &&
-		((page & csrow->page_mask) ==
-		(csrow->first_page & csrow->page_mask))) {
+		    (page <= csrow->last_page) &&
+		    ((page & csrow->page_mask) ==
+		    (csrow->first_page & csrow->page_mask))) {
 			row = i;
 			break;
 		}
@@ -692,261 +819,249 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 }
 EXPORT_SYMBOL_GPL(edac_mc_find_csrow_by_page);
 
-/* FIXME - setable log (warning/emerg) levels */
-/* FIXME - integrate with evlog: http://evlog.sourceforge.net/ */
-void edac_mc_handle_ce(struct mem_ctl_info *mci,
-		unsigned long page_frame_number,
-		unsigned long offset_in_page, unsigned long syndrome,
-		int row, int channel, const char *msg)
-{
-	unsigned long remapped_page;
-	char *label = NULL;
-	u32 grain;
+const char *edac_layer_name[] = {
+	[EDAC_MC_LAYER_BRANCH] = "branch",
+	[EDAC_MC_LAYER_CHANNEL] = "channel",
+	[EDAC_MC_LAYER_SLOT] = "slot",
+	[EDAC_MC_LAYER_CHIP_SELECT] = "csrow",
+};
+EXPORT_SYMBOL_GPL(edac_layer_name);
 
-	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
+static void edac_increment_ce_error(struct mem_ctl_info *mci,
+				    bool enable_filter,
+				    unsigned pos[EDAC_MAX_LAYERS])
+{
+	int i, index = 0;
 
-	/* FIXME - maybe make panic on INTERNAL ERROR an option */
-	if (row >= mci->nr_csrows || row < 0) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range "
-			"(%d >= %d)\n", row, mci->nr_csrows);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
-		return;
-	}
+	mci->ce_mc++;
 
-	if (channel >= mci->csrows[row].nr_channels || channel < 0) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel out of range "
-			"(%d >= %d)\n", channel,
-			mci->csrows[row].nr_channels);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
+	if (!enable_filter) {
+		mci->ce_noinfo_count++;
 		return;
 	}
 
-	label = mci->csrows[row].channels[channel].dimm->label;
-	grain = mci->csrows[row].channels[channel].dimm->grain;
+	for (i = 0; i < mci->n_layers; i++) {
+		if (pos[i] < 0)
+			break;
+		index += pos[i];
+		mci->ce_per_layer[i][index]++;
 
-	if (edac_mc_get_log_ce())
-		/* FIXME - put in DIMM location */
-		edac_mc_printk(mci, KERN_WARNING,
-			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
-			"0x%lx, row %d, channel %d, label \"%s\": %s\n",
-			page_frame_number, offset_in_page,
-			grain, syndrome, row, channel,
-			label, msg);
+		if (i < mci->n_layers - 1)
+			index *= mci->layers[i + 1].size;
+	}
+}
 
-	mci->ce_count++;
-	mci->csrows[row].ce_count++;
-	mci->csrows[row].channels[channel].dimm->ce_count++;
-	mci->csrows[row].channels[channel].ce_count++;
+static void edac_increment_ue_error(struct mem_ctl_info *mci,
+				    bool enable_filter,
+				    unsigned pos[EDAC_MAX_LAYERS])
+{
+	int i, index = 0;
 
-	if (mci->scrub_mode & SCRUB_SW_SRC) {
-		/*
-		 * Some MC's can remap memory so that it is still available
-		 * at a different address when PCI devices map into memory.
-		 * MC's that can't do this lose the memory where PCI devices
-		 * are mapped.  This mapping is MC dependent and so we call
-		 * back into the MC driver for it to map the MC page to
-		 * a physical (CPU) page which can then be mapped to a virtual
-		 * page - which can then be scrubbed.
-		 */
-		remapped_page = mci->ctl_page_to_phys ?
-			mci->ctl_page_to_phys(mci, page_frame_number) :
-			page_frame_number;
+	mci->ue_mc++;
 
-		edac_mc_scrub_block(remapped_page, offset_in_page, grain);
+	if (!enable_filter) {
+		mci->ce_noinfo_count++;
+		return;
 	}
-}
-EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
 
-void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci, const char *msg)
-{
-	if (edac_mc_get_log_ce())
-		edac_mc_printk(mci, KERN_WARNING,
-			"CE - no information available: %s\n", msg);
+	for (i = 0; i < mci->n_layers; i++) {
+		if (pos[i] < 0)
+			break;
+		index += pos[i];
+		mci->ue_per_layer[i][index]++;
 
-	mci->ce_noinfo_count++;
-	mci->ce_count++;
+		if (i < mci->n_layers - 1)
+			index *= mci->layers[i + 1].size;
+	}
 }
-EXPORT_SYMBOL_GPL(edac_mc_handle_ce_no_info);
 
-void edac_mc_handle_ue(struct mem_ctl_info *mci,
-		unsigned long page_frame_number,
-		unsigned long offset_in_page, int row, const char *msg)
+#define OTHER_LABEL " or "
+void edac_mc_handle_error(const enum hw_event_mc_err_type type,
+			  struct mem_ctl_info *mci,
+			  const unsigned long page_frame_number,
+			  const unsigned long offset_in_page,
+			  const unsigned long syndrome,
+			  const int layer0,
+			  const int layer1,
+			  const int layer2,
+			  const char *msg,
+			  const char *other_detail,
+			  const void *mcelog)
 {
-	int len = EDAC_MC_LABEL_LEN * 4;
-	char labels[len + 1];
-	char *pos = labels;
-	int chan;
-	int chars;
-	char *label = NULL;
+	unsigned long remapped_page;
+	/* FIXME: too much for stack: move it to some pre-alocated area */
+	char detail[80], location[80];
+	char label[(EDAC_MC_LABEL_LEN + 1 + sizeof(OTHER_LABEL)) * mci->tot_dimms];
+	char *p;
+	int row = -1, chan = -1;
+	int pos[EDAC_MAX_LAYERS] = { layer0, layer1, layer2 };
+	int i;
 	u32 grain;
+	bool enable_filter = false;
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
-	/* FIXME - maybe make panic on INTERNAL ERROR an option */
-	if (row >= mci->nr_csrows || row < 0) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range "
-			"(%d >= %d)\n", row, mci->nr_csrows);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
-		return;
-	}
-
-	grain = mci->csrows[row].channels[0].dimm->grain;
-	label = mci->csrows[row].channels[0].dimm->label;
-	chars = snprintf(pos, len + 1, "%s", label);
-	len -= chars;
-	pos += chars;
-
-	for (chan = 1; (chan < mci->csrows[row].nr_channels) && (len > 0);
-		chan++) {
-		label = mci->csrows[row].channels[chan].dimm->label;
-		chars = snprintf(pos, len + 1, ":%s", label);
-		len -= chars;
-		pos += chars;
+	/* Check if the event report is consistent */
+	for (i = 0; i < mci->n_layers; i++) {
+		if (pos[i] >= (int)mci->layers[i].size) {
+			if (type == HW_EVENT_ERR_CORRECTED) {
+				p = "CE";
+				mci->ce_mc++;
+			} else {
+				p = "UE";
+				mci->ue_mc++;
+			}
+			edac_mc_printk(mci, KERN_ERR,
+				       "INTERNAL ERROR: %s value is out of range (%d >= %d)\n",
+				       edac_layer_name[mci->layers[i].type],
+				       pos[i], mci->layers[i].size);
+			/*
+			 * Instead of just returning it, let's use what's
+			 * known about the error. The increment routines and
+			 * the DIMM filter logic will do the right thing by
+			 * pointing the likely damaged DIMMs.
+			 */
+			pos[i] = -1;
+		}
+		if (pos[i] >= 0)
+			enable_filter = true;
 	}
 
-	if (edac_mc_get_log_ue())
-		edac_mc_printk(mci, KERN_EMERG,
-			"UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
-			"labels \"%s\": %s\n", page_frame_number,
-			offset_in_page, grain, row, labels, msg);
-
-	if (edac_mc_get_panic_on_ue())
-		panic("EDAC MC%d: UE page 0x%lx, offset 0x%lx, grain %d, "
-			"row %d, labels \"%s\": %s\n", mci->mc_idx,
-			page_frame_number, offset_in_page,
-			grain, row, labels, msg);
+	/*
+	 * Get the dimm label/grain that applies to the match criteria.
+	 * As the error algorithm may not be able to point to just one memory,
+	 * the logic here will get all possible labels that could pottentially
+	 * be affected by the error.
+	 * On FB-DIMM memory controllers, for uncorrected errors, it is common
+	 * to have only the MC channel and the MC dimm (also called as "rank")
+	 * but the channel is not known, as the memory is arranged in pairs,
+	 * where each memory belongs to a separate channel within the same
+	 * branch.
+	 * It will also get the max grain, over the error match range
+	 */
+	grain = 0;
+	p = label;
+	*p = '\0';
+	for (i = 0; i < mci->tot_dimms; i++) {
+		struct dimm_info *dimm = &mci->dimms[i];
 
-	mci->ue_count++;
-	mci->csrows[row].ue_count++;
-}
-EXPORT_SYMBOL_GPL(edac_mc_handle_ue);
+		if (layer0 >= 0 && layer0 != dimm->location[0])
+			continue;
+		if (layer1 >= 0 && layer1 != dimm->location[1])
+			continue;
+		if (layer2 >= 0 && layer2 != dimm->location[2])
+			continue;
 
-void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci, const char *msg)
-{
-	if (edac_mc_get_panic_on_ue())
-		panic("EDAC MC%d: Uncorrected Error", mci->mc_idx);
+		if (dimm->grain > grain)
+			grain = dimm->grain;
 
-	if (edac_mc_get_log_ue())
-		edac_mc_printk(mci, KERN_WARNING,
-			"UE - no information available: %s\n", msg);
-	mci->ue_noinfo_count++;
-	mci->ue_count++;
-}
-EXPORT_SYMBOL_GPL(edac_mc_handle_ue_no_info);
-
-/*************************************************************
- * On Fully Buffered DIMM modules, this help function is
- * called to process UE events
- */
-void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
-			unsigned int csrow,
-			unsigned int channela,
-			unsigned int channelb, char *msg)
-{
-	int len = EDAC_MC_LABEL_LEN * 4;
-	char labels[len + 1];
-	char *pos = labels;
-	int chars;
-	char *label;
-
-	if (csrow >= mci->nr_csrows) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range (%d >= %d)\n",
-			csrow, mci->nr_csrows);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
-		return;
+		/*
+		 * If the error is memory-controller wide, there's no sense
+		 * on seeking for the affected DIMMs, as everything may be
+		 * affected. Also, don't show errors for non-filled dimm's.
+		 */
+		if (enable_filter && dimm->nr_pages) {
+			if (p != label) {
+				strcpy(p, OTHER_LABEL);
+				p += strlen(OTHER_LABEL);
+			}
+			strcpy(p, dimm->label);
+			p += strlen(p);
+			*p = '\0';
+
+			/*
+			 * get csrow/channel of the dimm, in order to allow
+			 * incrementing the compat API counters
+			 */
+			debugf4("%s: dimm csrows (%d,%d)\n",
+				__func__, dimm->csrow, dimm->cschannel);
+			if (row == -1)
+				row = dimm->csrow;
+			else if (row >= 0 && row != dimm->csrow)
+				row = -2;
+			if (chan == -1)
+				chan = dimm->cschannel;
+			else if (chan >= 0 && chan != dimm->cschannel)
+				chan = -2;
+		}
 	}
-
-	if (channela >= mci->csrows[csrow].nr_channels) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel-a out of range "
-			"(%d >= %d)\n",
-			channela, mci->csrows[csrow].nr_channels);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
-		return;
+	if (!enable_filter) {
+		strcpy(label, "any memory");
+	} else {
+		debugf4("%s: csrow/channel to increment: (%d,%d)\n",
+			__func__, row, chan);
+		if (p == label)
+			strcpy(label, "unknown memory");
+		if (type == HW_EVENT_ERR_CORRECTED) {
+			if (row >= 0) {
+				mci->csrows[row].ce_count++;
+				if (chan >= 0)
+					mci->csrows[row].channels[chan].ce_count++;
+			}
+		} else
+			if (row >= 0)
+				mci->csrows[row].ue_count++;
 	}
 
-	if (channelb >= mci->csrows[csrow].nr_channels) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel-b out of range "
-			"(%d >= %d)\n",
-			channelb, mci->csrows[csrow].nr_channels);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
-		return;
+	/* Fill the RAM location data */
+	p = location;
+	for (i = 0; i < mci->n_layers; i++) {
+		if (pos[i] < 0)
+			continue;
+		p += sprintf(p, "%s %d ",
+			     edac_layer_name[mci->layers[i].type],
+			     pos[i]);
 	}
 
-	mci->ue_count++;
-	mci->csrows[csrow].ue_count++;
-
-	/* Generate the DIMM labels from the specified channels */
-	label = mci->csrows[csrow].channels[channela].dimm->label;
-	chars = snprintf(pos, len + 1, "%s", label);
-	len -= chars;
-	pos += chars;
-
-	chars = snprintf(pos, len + 1, "-%s",
-			mci->csrows[csrow].channels[channelb].dimm->label);
-
-	if (edac_mc_get_log_ue())
-		edac_mc_printk(mci, KERN_EMERG,
-			"UE row %d, channel-a= %d channel-b= %d "
-			"labels \"%s\": %s\n", csrow, channela, channelb,
-			labels, msg);
-
-	if (edac_mc_get_panic_on_ue())
-		panic("UE row %d, channel-a= %d channel-b= %d "
-			"labels \"%s\": %s\n", csrow, channela,
-			channelb, labels, msg);
-}
-EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
+	/* Memory type dependent details about the error */
+	if (type == HW_EVENT_ERR_CORRECTED)
+		snprintf(detail, sizeof(detail),
+			"page 0x%lx offset 0x%lx grain %d syndrome 0x%lx",
+			page_frame_number, offset_in_page,
+			grain, syndrome);
+	else
+		snprintf(detail, sizeof(detail),
+			"page 0x%lx offset 0x%lx grain %d",
+			page_frame_number, offset_in_page, grain);
+
+	if (type == HW_EVENT_ERR_CORRECTED) {
+		if (edac_mc_get_log_ce())
+			edac_mc_printk(mci, KERN_WARNING,
+				       "CE %s on %s (%s%s %s)\n",
+				       msg, label, location,
+				       detail, other_detail);
+		edac_increment_ce_error(mci, enable_filter, pos);
+
+		if (mci->scrub_mode & SCRUB_SW_SRC) {
+			/*
+			 * Some MC's can remap memory so that it is still
+			 * available at a different address when PCI devices
+			 * map into memory.
+			 * MC's that can't do this lose the memory where PCI
+			 * devices are mapped. This mapping is MC dependent
+			 * and so we call back into the MC driver for it to
+			 * map the MC page to a physical (CPU) page which can
+			 * then be mapped to a virtual page - which can then
+			 * be scrubbed.
+			 */
+			remapped_page = mci->ctl_page_to_phys ?
+				mci->ctl_page_to_phys(mci, page_frame_number) :
+				page_frame_number;
+
+			edac_mc_scrub_block(remapped_page,
+					    offset_in_page, grain);
+		}
+	} else {
+		if (edac_mc_get_log_ue())
+			edac_mc_printk(mci, KERN_WARNING,
+				"UE %s on %s (%s%s %s)\n",
+				msg, label, location, detail, other_detail);
 
-/*************************************************************
- * On Fully Buffered DIMM modules, this help function is
- * called to process CE events
- */
-void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
-			unsigned int csrow, unsigned int channel, char *msg)
-{
-	char *label = NULL;
+		if (edac_mc_get_panic_on_ue())
+			panic("UE %s on %s (%s%s %s)\n",
+			      msg, label, location, detail, other_detail);
 
-	/* Ensure boundary values */
-	if (csrow >= mci->nr_csrows) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range (%d >= %d)\n",
-			csrow, mci->nr_csrows);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
-		return;
-	}
-	if (channel >= mci->csrows[csrow].nr_channels) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel out of range (%d >= %d)\n",
-			channel, mci->csrows[csrow].nr_channels);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
-		return;
+		edac_increment_ue_error(mci, enable_filter, pos);
 	}
-
-	label = mci->csrows[csrow].channels[channel].dimm->label;
-
-	if (edac_mc_get_log_ce())
-		/* FIXME - put in DIMM location */
-		edac_mc_printk(mci, KERN_WARNING,
-			"CE row %d, channel %d, label \"%s\": %s\n",
-			csrow, channel, label, msg);
-
-	mci->ce_count++;
-	mci->csrows[csrow].ce_count++;
-	mci->csrows[csrow].channels[channel].dimm->ce_count++;
-	mci->csrows[csrow].channels[channel].ce_count++;
 }
-EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
+EXPORT_SYMBOL_GPL(edac_mc_handle_error);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 875cd01d..a99131a 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -471,9 +471,17 @@ static const struct sysfs_ops dimmfs_ops = {
 /* show/store functions for DIMM Label attributes */
 static ssize_t dimmdev_location_show(struct dimm_info *dimm, char *data)
 {
-	return sprintf(data, "csrow %d, channel %d\n",
-		       dimm->csrow,
-		       dimm->csrow_channel);
+	struct mem_ctl_info *mci = dimm->mci;
+	int i;
+	char *p = data;
+
+	for (i = 0; i <= mci->n_layers; i++) {
+		p += sprintf(p, "%s %d ",
+			     edac_layer_name[mci->layers[i].type],
+			     dimm->location[i]);
+	}
+
+	return p - data;
 }
 
 static ssize_t dimmdev_label_show(struct dimm_info *dimm, char *data)
@@ -599,14 +607,14 @@ err_out:
 static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 					const char *data, size_t count)
 {
-	int row, chan;
-
+	int cnt, row, chan, i;
+	mci->ue_mc = 0;
+	mci->ce_mc = 0;
 	mci->ue_noinfo_count = 0;
 	mci->ce_noinfo_count = 0;
-	mci->ue_count = 0;
-	mci->ce_count = 0;
 
-	for (row = 0; row < mci->nr_csrows; row++) {
+
+	for (row = 0; row < mci->num_csrows; row++) {
 		struct csrow_info *ri = &mci->csrows[row];
 
 		ri->ue_count = 0;
@@ -616,6 +624,13 @@ static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 			ri->channels[chan].ce_count = 0;
 	}
 
+	cnt = 1;
+	for (i = 0; i < mci->n_layers; i++) {
+		cnt *= mci->layers[i].size;
+		memset(mci->ce_per_layer[i], 0, cnt);
+		memset(mci->ue_per_layer[i], 0, cnt);
+	}
+
 	mci->start_time = jiffies;
 	return count;
 }
@@ -673,12 +688,12 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
 /* default attribute files for the MCI object */
 static ssize_t mci_ue_count_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data, "%d\n", mci->ue_count);
+	return sprintf(data, "%d\n", mci->ue_mc);
 }
 
 static ssize_t mci_ce_count_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data, "%d\n", mci->ce_count);
+	return sprintf(data, "%d\n", mci->ce_mc);
 }
 
 static ssize_t mci_ce_noinfo_show(struct mem_ctl_info *mci, char *data)
@@ -705,7 +720,7 @@ static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data)
 {
 	int total_pages, csrow_idx, j;
 
-	for (total_pages = csrow_idx = 0; csrow_idx < mci->nr_csrows;
+	for (total_pages = csrow_idx = 0; csrow_idx < mci->num_csrows;
 	     csrow_idx++) {
 		struct csrow_info *csrow = &mci->csrows[csrow_idx];
 
@@ -1118,7 +1133,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	/* Make directories for each CSROW object under the mc<id> kobject
 	 */
-	for (i = 0; i < mci->nr_csrows; i++) {
+	for (i = 0; i < mci->num_csrows; i++) {
 		int n = 0;
 
 		csrow = &mci->csrows[i];
@@ -1140,11 +1155,24 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	/*
 	 * Make directories for each DIMM object under the mc<id> kobject
 	 */
-	for (j = 0; j < mci->nr_dimms; j++) {
-		/* Only expose populated CSROWs */
-		if (mci->dimms[j].nr_pages == 0)
+	for (j = 0; j < mci->tot_dimms; j++) {
+		struct dimm_info *dimm = &mci->dimms[j];
+		/* Only expose populated DIMMs */
+		if (dimm->nr_pages == 0)
 			continue;
-		err = edac_create_dimm_object(mci, &mci->dimms[j] , j);
+#ifdef CONFIG_EDAC_DEBUG
+		debugf1("%s creating dimm%d, located at ",
+			__func__, j);
+		if (edac_debug_level >= 1) {
+			int lay;
+			for (lay = 0; lay < mci->n_layers; lay++)
+				printk(KERN_CONT "%s %d ",
+					edac_layer_name[mci->layers[lay].type],
+					dimm->location[lay]);
+			printk(KERN_CONT "\n");
+		}
+#endif
+		err = edac_create_dimm_object(mci, dimm, j);
 		if (err) {
 			debugf1("%s() failure: create dimm %d obj\n",
 				__func__, j);
@@ -1197,11 +1225,11 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	/* remove all csrow kobjects */
 	debugf4("%s()  unregister this mci kobj\n", __func__);
-	for (i = 0; i < mci->nr_dimms; i++) {
+	for (i = 0; i < mci->tot_dimms; i++) {
 		debugf0("%s()  unreg dimm-%d\n", __func__, i);
 		kobject_put(&mci->dimms[i].kobj);
 	}
-	for (i = 0; i < mci->nr_csrows; i++) {
+	for (i = 0; i < mci->num_csrows; i++) {
 		int n = 0;
 
 		csrow = &mci->csrows[i];
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 17aabb7..4206401 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -52,7 +52,7 @@ extern void edac_device_reset_delay_period(struct edac_device_ctl_info
 					   *edac_dev, unsigned long value);
 extern void edac_mc_reset_delay_period(int value);
 
-extern void *edac_align_ptr(void *ptr, unsigned size);
+extern void *edac_align_ptr(void **p, unsigned size, int quant);
 
 /*
  * EDAC PCI functions
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 2b378207..f4baa73 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -43,13 +43,14 @@ struct edac_pci_ctl_info *edac_pci_alloc_ctl_info(unsigned int sz_pvt,
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
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index bf8a230..c366002 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -245,7 +245,9 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & I3000_ERRSTS_BITS) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1,
+				     "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
@@ -256,10 +258,15 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, pfn);
 
 	if (info->errsts & I3000_ERRSTS_UE)
-		edac_mc_handle_ue(mci, pfn, offset, row, "i3000 UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     pfn, offset, 0,
+				     row, -1, -1,
+				     "i3000 UE", "", NULL);
 	else
-		edac_mc_handle_ce(mci, pfn, offset, info->derrsyn, row,
-				multi_chan ? channel : 0, "i3000 CE");
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     pfn, offset, info->derrsyn,
+				     row, multi_chan ? channel : 0, -1,
+				     "i3000 CE", "", NULL);
 
 	return 1;
 }
@@ -306,6 +313,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	unsigned long last_cumul_size, nr_pages;
 	int interleaved, nr_channels;
 	unsigned char dra[I3000_RANKS / 2], drb[I3000_RANKS];
@@ -347,7 +355,14 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	interleaved = i3000_is_interleaved(c0dra, c1dra, c0drb, c1drb);
 	nr_channels = interleaved ? 2 : 1;
-	mci = edac_mc_alloc(0, I3000_RANKS / nr_channels, nr_channels, 0);
+
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I3000_RANKS / nr_channels;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_channels;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
@@ -375,7 +390,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	 * If we're in interleaved mode then we're only walking through
 	 * the ranks of controller 0, so we double all the values we see.
 	 */
-	for (last_cumul_size = i = 0; i < mci->nr_csrows; i++) {
+	for (last_cumul_size = i = 0; i < mci->num_csrows; i++) {
 		u8 value;
 		u32 cumul_size;
 		struct csrow_info *csrow = &mci->csrows[i];
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index b3dc867..1233435 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -21,6 +21,7 @@
 
 #define PCI_DEVICE_ID_INTEL_3200_HB    0x29f0
 
+#define I3200_DIMMS		4
 #define I3200_RANKS		8
 #define I3200_RANKS_PER_CHANNEL	4
 #define I3200_CHANNELS		2
@@ -228,21 +229,25 @@ static void i3200_process_error_info(struct mem_ctl_info *mci,
 		return;
 
 	if ((info->errsts ^ info->errsts2) & I3200_ERRSTS_BITS) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1, "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
 	for (channel = 0; channel < nr_channels; channel++) {
 		log = info->eccerrlog[channel];
 		if (log & I3200_ECCERRLOG_UE) {
-			edac_mc_handle_ue(mci, 0, 0,
-				eccerrlog_row(channel, log),
-				"i3200 UE");
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     0, 0, 0,
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "i3000 UE", "", NULL);
 		} else if (log & I3200_ECCERRLOG_CE) {
-			edac_mc_handle_ce(mci, 0, 0,
-				eccerrlog_syndrome(log),
-				eccerrlog_row(channel, log), 0,
-				"i3200 CE");
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     0, 0, eccerrlog_syndrome(log),
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "i3000 UE", "", NULL);
 		}
 	}
 }
@@ -332,6 +337,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	u16 drbs[I3200_CHANNELS][I3200_RANKS_PER_CHANNEL];
 	bool stacked;
 	void __iomem *window;
@@ -346,8 +352,13 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	i3200_get_drbs(window, drbs);
 	nr_channels = how_many_channels(pdev);
 
-	mci = edac_mc_alloc(sizeof(struct i3200_priv), I3200_RANKS,
-		nr_channels, 0);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I3200_DIMMS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_channels;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
@@ -376,7 +387,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	 * cumulative; the last one will contain the total memory
 	 * contained in all ranks.
 	 */
-	for (i = 0; i < mci->nr_csrows; i++) {
+	for (i = 0; i < mci->num_csrows; i++) {
 		unsigned long nr_pages;
 		struct csrow_info *csrow = &mci->csrows[i];
 
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index e8d32e8..564fe09 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -533,13 +533,14 @@ static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
 
 	/* Form out message */
 	snprintf(msg, sizeof(msg),
-		 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d CAS=%d "
-		 "FATAL Err=0x%x (%s))",
-		 branch >> 1, bank, rdwr ? "Write" : "Read", ras, cas,
-		 allErrors, specific);
+		 "Bank=%d RAS=%d CAS=%d FATAL Err=0x%x (%s)",
+		 bank, ras, cas, allErrors, specific);
 
 	/* Call the helper to output message */
-	edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
+	edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 0, 0, 0,
+			     branch >> 1, -1, rank,
+			     rdwr ? "Write error" : "Read error",
+			     msg, NULL);
 }
 
 /*
@@ -633,13 +634,14 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
-			 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d "
-			 "CAS=%d, UE Err=0x%x (%s))",
-			 branch >> 1, bank, rdwr ? "Write" : "Read", ras, cas,
-			 ue_errors, specific);
+			 "Rank=%d Bank=%d RAS=%d CAS=%d, UE Err=0x%x (%s)",
+			 rank, bank, ras, cas, ue_errors, specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				channel >> 1, -1, rank,
+				rdwr ? "Write error" : "Read error",
+				msg, NULL);
 	}
 
 	/* Check correctable errors */
@@ -685,13 +687,16 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
-			 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d "
+			 "Rank=%d Bank=%d RDWR=%s RAS=%d "
 			 "CAS=%d, CE Err=0x%x (%s))", branch >> 1, bank,
 			 rdwr ? "Write" : "Read", ras, cas, ce_errors,
 			 specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_fbd_ce(mci, rank, channel, msg);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+				channel >> 1, channel % 2, rank,
+				rdwr ? "Write error" : "Read error",
+				msg, NULL);
 	}
 
 	if (!misc_messages)
@@ -731,11 +736,12 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
-			 "(Branch=%d Err=%#x (%s))", branch >> 1,
-			 misc_errors, specific);
+			 "Err=%#x (%s)", misc_errors, specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_fbd_ce(mci, 0, 0, msg);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+				branch >> 1, -1, -1,
+				"Misc error", msg, NULL);
 	}
 }
 
@@ -1251,6 +1257,10 @@ static int i5000_init_csrows(struct mem_ctl_info *mci)
 
 	empty = 1;		/* Assume NO memory */
 
+	/*
+	 * TODO: it would be better to not use csrow here, filling
+	 * directly the dimm_info structs, based on branch, channel, dim number
+	 */
 	for (csrow = 0; csrow < max_csrows; csrow++) {
 		p_csrow = &mci->csrows[csrow];
 
@@ -1343,10 +1353,10 @@ static void i5000_get_dimm_and_channel_counts(struct pci_dev *pdev,
 static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[3];
 	struct i5000_pvt *pvt;
 	int num_channels;
 	int num_dimms_per_channel;
-	int num_csrows;
 
 	debugf0("MC: %s: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
 		__FILE__, __func__,
@@ -1372,13 +1382,21 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	i5000_get_dimm_and_channel_counts(pdev, &num_dimms_per_channel,
 					&num_channels);
-	num_csrows = num_dimms_per_channel * 2;
 
-	debugf0("MC: %s(): Number of - Channels= %d  DIMMS= %d  CSROWS= %d\n",
-		__func__, num_channels, num_dimms_per_channel, num_csrows);
+	debugf0("MC: %s(): Number of Branches=2 Channels= %d  DIMMS= %d\n",
+		__func__, num_channels, num_dimms_per_channel);
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
+	layers[0].type = EDAC_MC_LAYER_BRANCH;
+	layers[0].size = 2;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = num_channels;
+	layers[1].is_csrow = false;
+	layers[2].type = EDAC_MC_LAYER_SLOT;
+	layers[2].size = num_dimms_per_channel;
+	layers[2].is_csrow = true;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index d564d68..2eb44d8 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -14,6 +14,11 @@
  * rows for each respective channel are laid out one after another,
  * the first half belonging to channel 0, the second half belonging
  * to channel 1.
+ *
+ * This driver is for DDR2 DIMMs, and it uses chip select to select among the
+ * several ranks. However, instead of showing memories as ranks, it outputs
+ * them as DIMM's. An internal table creates the association between ranks
+ * and DIMM's.
  */
 #include <linux/module.h>
 #include <linux/init.h>
@@ -410,14 +415,6 @@ static int i5100_csrow_to_chan(const struct mem_ctl_info *mci, int csrow)
 	return csrow / priv->ranksperchan;
 }
 
-static unsigned i5100_rank_to_csrow(const struct mem_ctl_info *mci,
-				    int chan, int rank)
-{
-	const struct i5100_priv *priv = mci->pvt_info;
-
-	return chan * priv->ranksperchan + rank;
-}
-
 static void i5100_handle_ce(struct mem_ctl_info *mci,
 			    int chan,
 			    unsigned bank,
@@ -427,21 +424,17 @@ static void i5100_handle_ce(struct mem_ctl_info *mci,
 			    unsigned ras,
 			    const char *msg)
 {
-	const int csrow = i5100_rank_to_csrow(mci, chan, rank);
-	char *label = NULL;
-
-	if (mci->csrows[csrow].channels[0].dimm)
-		label = mci->csrows[csrow].channels[0].dimm->label;
+	char detail[80];
 
-	printk(KERN_ERR
-		"CE chan %d, bank %u, rank %u, syndrome 0x%lx, "
-		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
-		chan, bank, rank, syndrome, cas, ras,
-		csrow, label, msg);
+	/* Form out message */
+	snprintf(detail, sizeof(detail),
+		 "bank %u, cas %u, ras %u\n",
+		 bank, cas, ras);
 
-	mci->ce_count++;
-	mci->csrows[csrow].ce_count++;
-	mci->csrows[csrow].channels[0].ce_count++;
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			     0, 0, syndrome,
+			     chan, rank, -1,
+			     msg, detail, NULL);
 }
 
 static void i5100_handle_ue(struct mem_ctl_info *mci,
@@ -453,20 +446,17 @@ static void i5100_handle_ue(struct mem_ctl_info *mci,
 			    unsigned ras,
 			    const char *msg)
 {
-	const int csrow = i5100_rank_to_csrow(mci, chan, rank);
-	char *label = NULL;
+	char detail[80];
 
-	if (mci->csrows[csrow].channels[0].dimm)
-		label = mci->csrows[csrow].channels[0].dimm->label;
+	/* Form out message */
+	snprintf(detail, sizeof(detail),
+		 "bank %u, cas %u, ras %u\n",
+		 bank, cas, ras);
 
-	printk(KERN_ERR
-		"UE chan %d, bank %u, rank %u, syndrome 0x%lx, "
-		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
-		chan, bank, rank, syndrome, cas, ras,
-		csrow, label, msg);
-
-	mci->ue_count++;
-	mci->csrows[csrow].ue_count++;
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			     0, 0, syndrome,
+			     chan, rank, -1,
+			     msg, detail, NULL);
 }
 
 static void i5100_read_log(struct mem_ctl_info *mci, int chan,
@@ -846,11 +836,10 @@ static void __devinit i5100_init_interleaving(struct pci_dev *pdev,
 static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 {
 	int i;
-	unsigned long total_pages = 0UL;
 	struct i5100_priv *priv = mci->pvt_info;
-	struct dimm_info *dimm;
 
-	for (i = 0; i < mci->nr_csrows; i++) {
+	for (i = 0; i < mci->tot_dimms; i++) {
+		struct dimm_info *dimm;
 		const unsigned long npages = i5100_npages(mci, i);
 		const unsigned chan = i5100_csrow_to_chan(mci, i);
 		const unsigned rank = i5100_csrow_to_rank(mci, i);
@@ -858,40 +847,22 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 		if (!npages)
 			continue;
 
-		/*
-		 * FIXME: these two are totally bogus -- I don't see how to
-		 * map them correctly to this structure...
-		 */
-		mci->csrows[i].csrow_idx = i;
-		mci->csrows[i].mci = mci;
-		mci->csrows[i].nr_channels = 1;
-		mci->csrows[i].channels[0].csrow = mci->csrows + i;
-		total_pages += npages;
+		dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+			       chan, rank, 0);
+
+		dimm->nr_pages = npages;
 
-		dimm = mci->csrows[i].channels[0].dimm;
 		dimm->grain = 32;
 		dimm->dtype = (priv->mtr[chan][rank].width == 4) ?
-			      DEV_X4 : DEV_X8;
+				DEV_X4 : DEV_X8;
 		dimm->mtype = MEM_RDDR2;
 		dimm->edac_mode = EDAC_SECDED;
 		snprintf(dimm->label, sizeof(dimm->label),
-			 "DIMM%u",
-			 i5100_rank_to_slot(mci, chan, rank));
-
-		dimm->nr_pages = npages;
-
-		if (npages) {
-			total_pages += npages;
+			"DIMM%u",
+			i5100_rank_to_slot(mci, chan, rank));
 
-			dimm->grain = 32;
-			dimm->dtype = (priv->mtr[chan][rank].width == 4) ?
-				DEV_X4 : DEV_X8;
-			dimm->mtype = MEM_RDDR2;
-			dimm->edac_mode = EDAC_SECDED;
-			snprintf(dimm->label, sizeof(dimm->label),
-				"DIMM%u",
-				i5100_rank_to_slot(mci, chan, rank));
-		}
+		debugf2("dimm channel %d, rank %d, size %d\n",
+			chan, rank, PAGES_TO_MiB(npages));
 	}
 }
 
@@ -900,6 +871,7 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 {
 	int rc;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i5100_priv *priv;
 	struct pci_dev *ch0mm, *ch1mm;
 	int ret = 0;
@@ -960,7 +932,14 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 		goto bail_ch1;
 	}
 
-	mci = edac_mc_alloc(sizeof(*priv), ranksperch * 2, 1, 0);
+	layers[0].type = EDAC_MC_LAYER_CHANNEL;
+	layers[0].size = 2;
+	layers[0].is_csrow = false;
+	layers[1].type = EDAC_MC_LAYER_SLOT;
+	layers[1].size = ranksperch;
+	layers[1].is_csrow = true;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+			    false, sizeof(*priv));
 	if (!mci) {
 		ret = -ENOMEM;
 		goto bail_disable_ch1;
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 784d6dc..3aa2a1e 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -18,6 +18,10 @@
  * Intel 5400 Chipset Memory Controller Hub (MCH) - Datasheet
  * 	http://developer.intel.com/design/chipsets/datashts/313070.htm
  *
+ * This Memory Controller manages DDR2 FB-DIMMs. It has 2 branches, each with
+ * 2 channels operating in lockstep no-mirror mode. Each channel can have up to
+ * 4 dimm's, each with up to 8GB.
+ *
  */
 
 #include <linux/module.h>
@@ -44,12 +48,10 @@
 	edac_mc_chipset_printk(mci, level, "i5400", fmt, ##arg)
 
 /* Limits for i5400 */
-#define NUM_MTRS_PER_BRANCH	4
+#define MAX_BRANCHES		2
 #define CHANNELS_PER_BRANCH	2
-#define MAX_DIMMS_PER_CHANNEL	NUM_MTRS_PER_BRANCH
-#define	MAX_CHANNELS		4
-/* max possible csrows per channel */
-#define MAX_CSROWS		(MAX_DIMMS_PER_CHANNEL)
+#define DIMMS_PER_CHANNEL	4
+#define	MAX_CHANNELS		(MAX_BRANCHES * CHANNELS_PER_BRANCH)
 
 /* Device 16,
  * Function 0: System Address
@@ -347,16 +349,16 @@ struct i5400_pvt {
 
 	u16 mir0, mir1;
 
-	u16 b0_mtr[NUM_MTRS_PER_BRANCH];	/* Memory Technlogy Reg */
+	u16 b0_mtr[DIMMS_PER_CHANNEL];	/* Memory Technlogy Reg */
 	u16 b0_ambpresent0;			/* Branch 0, Channel 0 */
 	u16 b0_ambpresent1;			/* Brnach 0, Channel 1 */
 
-	u16 b1_mtr[NUM_MTRS_PER_BRANCH];	/* Memory Technlogy Reg */
+	u16 b1_mtr[DIMMS_PER_CHANNEL];	/* Memory Technlogy Reg */
 	u16 b1_ambpresent0;			/* Branch 1, Channel 8 */
 	u16 b1_ambpresent1;			/* Branch 1, Channel 1 */
 
 	/* DIMM information matrix, allocating architecture maximums */
-	struct i5400_dimm_info dimm_info[MAX_CSROWS][MAX_CHANNELS];
+	struct i5400_dimm_info dimm_info[DIMMS_PER_CHANNEL][MAX_CHANNELS];
 
 	/* Actual values for this controller */
 	int maxch;				/* Max channels */
@@ -532,13 +534,15 @@ static void i5400_proccess_non_recoverable_info(struct mem_ctl_info *mci,
 	int ras, cas;
 	int errnum;
 	char *type = NULL;
+	enum hw_event_mc_err_type tp_event = HW_EVENT_ERR_UNCORRECTED;
 
 	if (!allErrors)
 		return;		/* if no error, return now */
 
-	if (allErrors &  ERROR_FAT_MASK)
+	if (allErrors &  ERROR_FAT_MASK) {
 		type = "FATAL";
-	else if (allErrors & FERR_NF_UNCORRECTABLE)
+		tp_event = HW_EVENT_ERR_FATAL;
+	} else if (allErrors & FERR_NF_UNCORRECTABLE)
 		type = "NON-FATAL uncorrected";
 	else
 		type = "NON-FATAL recoverable";
@@ -556,7 +560,7 @@ static void i5400_proccess_non_recoverable_info(struct mem_ctl_info *mci,
 	ras = nrec_ras(info);
 	cas = nrec_cas(info);
 
-	debugf0("\t\tCSROW= %d  Channels= %d,%d  (Branch= %d "
+	debugf0("\t\tDIMM= %d  Channels= %d,%d  (Branch= %d "
 		"DRAM Bank= %d Buffer ID = %d rdwr= %s ras= %d cas= %d)\n",
 		rank, channel, channel + 1, branch >> 1, bank,
 		buf_id, rdwr_str(rdwr), ras, cas);
@@ -566,13 +570,13 @@ static void i5400_proccess_non_recoverable_info(struct mem_ctl_info *mci,
 
 	/* Form out message */
 	snprintf(msg, sizeof(msg),
-		 "%s (Branch=%d DRAM-Bank=%d Buffer ID = %d RDWR=%s "
-		 "RAS=%d CAS=%d %s Err=0x%lx (%s))",
-		 type, branch >> 1, bank, buf_id, rdwr_str(rdwr), ras, cas,
-		 type, allErrors, error_name[errnum]);
+		 "Bank=%d Buffer ID = %d RAS=%d CAS=%d Err=0x%lx (%s)",
+		 bank, buf_id, ras, cas, allErrors, error_name[errnum]);
 
-	/* Call the helper to output message */
-	edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
+	edac_mc_handle_error(tp_event, mci, 0, 0, 0,
+			     branch >> 1, -1, rank,
+			     rdwr ? "Write error" : "Read error",
+			     msg, NULL);
 }
 
 /*
@@ -630,7 +634,7 @@ static void i5400_process_nonfatal_error_info(struct mem_ctl_info *mci,
 		/* Only 1 bit will be on */
 		errnum = find_first_bit(&allErrors, ARRAY_SIZE(error_name));
 
-		debugf0("\t\tCSROW= %d Channel= %d  (Branch %d "
+		debugf0("\t\tDIMM= %d Channel= %d  (Branch %d "
 			"DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
 			rank, channel, branch >> 1, bank,
 			rdwr_str(rdwr), ras, cas);
@@ -642,8 +646,10 @@ static void i5400_process_nonfatal_error_info(struct mem_ctl_info *mci,
 			 branch >> 1, bank, rdwr_str(rdwr), ras, cas,
 			 allErrors, error_name[errnum]);
 
-		/* Call the helper to output message */
-		edac_mc_handle_fbd_ce(mci, rank, channel, msg);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+				     branch >> 1, channel % 2, rank,
+				     rdwr ? "Write error" : "Read error",
+				     msg, NULL);
 
 		return;
 	}
@@ -831,8 +837,8 @@ static int i5400_get_devices(struct mem_ctl_info *mci, int dev_idx)
 /*
  *	determine_amb_present
  *
- *		the information is contained in NUM_MTRS_PER_BRANCH different
- *		registers determining which of the NUM_MTRS_PER_BRANCH requires
+ *		the information is contained in DIMMS_PER_CHANNEL different
+ *		registers determining which of the DIMMS_PER_CHANNEL requires
  *              knowing which channel is in question
  *
  *	2 branches, each with 2 channels
@@ -861,11 +867,11 @@ static int determine_amb_present_reg(struct i5400_pvt *pvt, int channel)
 }
 
 /*
- * determine_mtr(pvt, csrow, channel)
+ * determine_mtr(pvt, dimm, channel)
  *
- * return the proper MTR register as determine by the csrow and desired channel
+ * return the proper MTR register as determine by the dimm and desired channel
  */
-static int determine_mtr(struct i5400_pvt *pvt, int csrow, int channel)
+static int determine_mtr(struct i5400_pvt *pvt, int dimm, int channel)
 {
 	int mtr;
 	int n;
@@ -873,11 +879,11 @@ static int determine_mtr(struct i5400_pvt *pvt, int csrow, int channel)
 	/* There is one MTR for each slot pair of FB-DIMMs,
 	   Each slot pair may be at branch 0 or branch 1.
 	 */
-	n = csrow;
+	n = dimm;
 
-	if (n >= NUM_MTRS_PER_BRANCH) {
-		debugf0("ERROR: trying to access an invalid csrow: %d\n",
-			csrow);
+	if (n >= DIMMS_PER_CHANNEL) {
+		debugf0("ERROR: trying to access an invalid dimm: %d\n",
+			dimm);
 		return 0;
 	}
 
@@ -913,19 +919,19 @@ static void decode_mtr(int slot_row, u16 mtr)
 	debugf2("\t\tNUMCOL: %s\n", numcol_toString[MTR_DIMM_COLS(mtr)]);
 }
 
-static void handle_channel(struct i5400_pvt *pvt, int csrow, int channel,
+static void handle_channel(struct i5400_pvt *pvt, int dimm, int channel,
 			struct i5400_dimm_info *dinfo)
 {
 	int mtr;
 	int amb_present_reg;
 	int addrBits;
 
-	mtr = determine_mtr(pvt, csrow, channel);
+	mtr = determine_mtr(pvt, dimm, channel);
 	if (MTR_DIMMS_PRESENT(mtr)) {
 		amb_present_reg = determine_amb_present_reg(pvt, channel);
 
 		/* Determine if there is a DIMM present in this DIMM slot */
-		if (amb_present_reg & (1 << csrow)) {
+		if (amb_present_reg & (1 << dimm)) {
 			/* Start with the number of bits for a Bank
 			 * on the DRAM */
 			addrBits = MTR_DRAM_BANKS_ADDR_BITS(mtr);
@@ -954,7 +960,7 @@ static void handle_channel(struct i5400_pvt *pvt, int csrow, int channel,
 static void calculate_dimm_size(struct i5400_pvt *pvt)
 {
 	struct i5400_dimm_info *dinfo;
-	int csrow, max_csrows;
+	int dimm, max_dimms;
 	char *p, *mem_buffer;
 	int space, n;
 	int channel;
@@ -968,32 +974,32 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 		return;
 	}
 
-	/* Scan all the actual CSROWS
+	/* Scan all the actual DIMMS
 	 * and calculate the information for each DIMM
-	 * Start with the highest csrow first, to display it first
-	 * and work toward the 0th csrow
+	 * Start with the highest dimm first, to display it first
+	 * and work toward the 0th dimm
 	 */
-	max_csrows = pvt->maxdimmperch;
-	for (csrow = max_csrows - 1; csrow >= 0; csrow--) {
+	max_dimms = pvt->maxdimmperch;
+	for (dimm = max_dimms - 1; dimm >= 0; dimm--) {
 
-		/* on an odd csrow, first output a 'boundary' marker,
+		/* on an odd dimm, first output a 'boundary' marker,
 		 * then reset the message buffer  */
-		if (csrow & 0x1) {
+		if (dimm & 0x1) {
 			n = snprintf(p, space, "---------------------------"
-					"--------------------------------");
+					"-------------------------------");
 			p += n;
 			space -= n;
 			debugf2("%s\n", mem_buffer);
 			p = mem_buffer;
 			space = PAGE_SIZE;
 		}
-		n = snprintf(p, space, "csrow %2d    ", csrow);
+		n = snprintf(p, space, "dimm %2d    ", dimm);
 		p += n;
 		space -= n;
 
 		for (channel = 0; channel < pvt->maxch; channel++) {
-			dinfo = &pvt->dimm_info[csrow][channel];
-			handle_channel(pvt, csrow, channel, dinfo);
+			dinfo = &pvt->dimm_info[dimm][channel];
+			handle_channel(pvt, dimm, channel, dinfo);
 			n = snprintf(p, space, "%4d MB   | ", dinfo->megabytes);
 			p += n;
 			space -= n;
@@ -1005,7 +1011,7 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 
 	/* Output the last bottom 'boundary' marker */
 	n = snprintf(p, space, "---------------------------"
-			"--------------------------------");
+			"-------------------------------");
 	p += n;
 	space -= n;
 	debugf2("%s\n", mem_buffer);
@@ -1013,7 +1019,7 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 	space = PAGE_SIZE;
 
 	/* now output the 'channel' labels */
-	n = snprintf(p, space, "            ");
+	n = snprintf(p, space, "           ");
 	p += n;
 	space -= n;
 	for (channel = 0; channel < pvt->maxch; channel++) {
@@ -1080,7 +1086,7 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 	debugf2("MIR1: limit= 0x%x  WAY1= %u  WAY0= %x\n", limit, way1, way0);
 
 	/* Get the set of MTR[0-3] regs by each branch */
-	for (slot_row = 0; slot_row < NUM_MTRS_PER_BRANCH; slot_row++) {
+	for (slot_row = 0; slot_row < DIMMS_PER_CHANNEL; slot_row++) {
 		int where = MTR0 + (slot_row * sizeof(u16));
 
 		/* Branch 0 set of MTR registers */
@@ -1105,7 +1111,7 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 	/* Read and dump branch 0's MTRs */
 	debugf2("\nMemory Technology Registers:\n");
 	debugf2("   Branch 0:\n");
-	for (slot_row = 0; slot_row < NUM_MTRS_PER_BRANCH; slot_row++)
+	for (slot_row = 0; slot_row < DIMMS_PER_CHANNEL; slot_row++)
 		decode_mtr(slot_row, pvt->b0_mtr[slot_row]);
 
 	pci_read_config_word(pvt->branch_0, AMBPRESENT_0,
@@ -1122,7 +1128,7 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 	} else {
 		/* Read and dump  branch 1's MTRs */
 		debugf2("   Branch 1:\n");
-		for (slot_row = 0; slot_row < NUM_MTRS_PER_BRANCH; slot_row++)
+		for (slot_row = 0; slot_row < DIMMS_PER_CHANNEL; slot_row++)
 			decode_mtr(slot_row, pvt->b1_mtr[slot_row]);
 
 		pci_read_config_word(pvt->branch_1, AMBPRESENT_0,
@@ -1141,7 +1147,7 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 }
 
 /*
- *	i5400_init_csrows	Initialize the 'csrows' table within
+ *	i5400_init_dimms	Initialize the 'dimms' table within
  *				the mci control	structure with the
  *				addressing of memory.
  *
@@ -1149,50 +1155,68 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
  *		0	success
  *		1	no actual memory found on this MC
  */
-static int i5400_init_csrows(struct mem_ctl_info *mci)
+static int i5400_init_dimms(struct mem_ctl_info *mci)
 {
 	struct i5400_pvt *pvt;
-	struct csrow_info *p_csrow;
-	int empty, channel_count;
-	int max_csrows;
+	struct dimm_info *dimm;
+	int ndimms, channel_count;
+	int max_dimms;
 	int mtr;
 	int size_mb;
-	int channel;
-	int csrow;
-	struct dimm_info *dimm;
+	int  channel, slot;
 
 	pvt = mci->pvt_info;
 
 	channel_count = pvt->maxch;
-	max_csrows = pvt->maxdimmperch;
+	max_dimms = pvt->maxdimmperch;
 
-	empty = 1;		/* Assume NO memory */
+	ndimms = 0;
 
-	for (csrow = 0; csrow < max_csrows; csrow++) {
-		p_csrow = &mci->csrows[csrow];
+	/*
+	 * FIXME: remove  pvt->dimm_info[slot][channel] and use the 3
+	 * layers here.
+	 */
+	for (channel = 0; channel < mci->layers[0].size * mci->layers[1].size;
+	     channel++) {
+		for (slot = 0; slot < mci->layers[2].size; slot++) {
+			mtr = determine_mtr(pvt, slot, channel);
 
-		/* use branch 0 for the basis */
-		mtr = determine_mtr(pvt, csrow, 0);
+			/* if no DIMMS on this slot, continue */
+			if (!MTR_DIMMS_PRESENT(mtr))
+				continue;
 
-		/* if no DIMMS on this row, continue */
-		if (!MTR_DIMMS_PRESENT(mtr))
-			continue;
+			dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+				       channel / 2, channel % 2, slot);
 
-		for (channel = 0; channel < pvt->maxch; channel++) {
-			size_mb = pvt->dimm_info[csrow][channel].megabytes;
+			size_mb =  pvt->dimm_info[slot][channel].megabytes;
+
+			debugf2("%s: dimm%zd (branch %d channel %d slot %d): %d.%03d GB\n",
+				__func__, dimm - mci->dimms,
+				channel / 2, channel % 2, slot,
+				size_mb / 1000, size_mb % 1000);
 
-			dimm = p_csrow->channels[channel].dimm;
 			dimm->nr_pages = size_mb << 8;
 			dimm->grain = 8;
 			dimm->dtype = MTR_DRAM_WIDTH(mtr) ? DEV_X8 : DEV_X4;
-			dimm->mtype = MEM_RDDR2;
-			dimm->edac_mode = EDAC_SECDED;
+			dimm->mtype = MEM_FB_DDR2;
+			/*
+			 * The eccc mechanism is SDDC (aka SECC), with
+			 * is similar to Chipkill.
+			 */
+			dimm->edac_mode = MTR_DRAM_WIDTH(mtr) ?
+					  EDAC_S8ECD8ED : EDAC_S4ECD4ED;
+			ndimms++;
 		}
-
-		empty = 0;
 	}
 
-	return empty;
+	/*
+	 * When just one memory is provided, it should be at location (0,0,0).
+	 * With such single-DIMM mode, the SDCC algorithm degrades to SECDEC+.
+	 */
+	if (ndimms == 1)
+		mci->dimms[0].edac_mode = EDAC_SECDED;
+
+	return (ndimms == 0);
 }
 
 /*
@@ -1228,9 +1252,7 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
 	struct i5400_pvt *pvt;
-	int num_channels;
-	int num_dimms_per_channel;
-	int num_csrows;
+	struct edac_mc_layer layers[3];
 
 	if (dev_idx >= ARRAY_SIZE(i5400_devs))
 		return -EINVAL;
@@ -1244,22 +1266,21 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	if (PCI_FUNC(pdev->devfn) != 0)
 		return -ENODEV;
 
-	/* As we don't have a motherboard identification routine to determine
-	 * actual number of slots/dimms per channel, we thus utilize the
-	 * resource as specified by the chipset. Thus, we might have
-	 * have more DIMMs per channel than actually on the mobo, but this
-	 * allows the driver to support up to the chipset max, without
-	 * some fancy mobo determination.
+	/*
+	 * allocate a new MC control structure
+	 *
+	 * This drivers uses the DIMM slot as "csrow" and the rest as "channel".
 	 */
-	num_dimms_per_channel = MAX_DIMMS_PER_CHANNEL;
-	num_channels = MAX_CHANNELS;
-	num_csrows = num_dimms_per_channel;
-
-	debugf0("MC: %s(): Number of - Channels= %d  DIMMS= %d  CSROWS= %d\n",
-		__func__, num_channels, num_dimms_per_channel, num_csrows);
-
-	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
+	layers[0].type = EDAC_MC_LAYER_BRANCH;
+	layers[0].size = MAX_BRANCHES;
+	layers[0].is_csrow = false;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = CHANNELS_PER_BRANCH;
+	layers[1].is_csrow = false;
+	layers[2].type = EDAC_MC_LAYER_SLOT;
+	layers[2].size = DIMMS_PER_CHANNEL;
+	layers[2].is_csrow = true;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
@@ -1270,8 +1291,8 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 
 	pvt = mci->pvt_info;
 	pvt->system_address = pdev;	/* Record this device in our private */
-	pvt->maxch = num_channels;
-	pvt->maxdimmperch = num_dimms_per_channel;
+	pvt->maxch = MAX_CHANNELS;
+	pvt->maxdimmperch = DIMMS_PER_CHANNEL;
 
 	/* 'get' the pci devices we want to reserve for our use */
 	if (i5400_get_devices(mci, dev_idx))
@@ -1293,13 +1314,13 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	/* Set the function pointer to an actual operation function */
 	mci->edac_check = i5400_check_error;
 
-	/* initialize the MC control structure 'csrows' table
+	/* initialize the MC control structure 'dimms' table
 	 * with the mapping and control information */
-	if (i5400_init_csrows(mci)) {
+	if (i5400_init_dimms(mci)) {
 		debugf0("MC: Setting mci->edac_cap to EDAC_FLAG_NONE\n"
-			"    because i5400_init_csrows() returned nonzero "
+			"    because i5400_init_dimms() returned nonzero "
 			"value\n");
-		mci->edac_cap = EDAC_FLAG_NONE;	/* no csrows found */
+		mci->edac_cap = EDAC_FLAG_NONE;	/* no dimms found */
 	} else {
 		debugf1("MC: Enable error reporting now\n");
 		i5400_enable_error_reporting(mci);
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 5e594ae..f9faf96 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -464,17 +464,14 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 				FERR_FAT_FBD, error_reg);
 
 		snprintf(pvt->tmp_prt_buffer, PAGE_SIZE,
-			"FATAL (Branch=%d DRAM-Bank=%d %s "
-			"RAS=%d CAS=%d Err=0x%lx (%s))",
-			branch, bank,
-			is_wr ? "RDWR" : "RD",
-			ras, cas,
-			errors, specific);
-
-		/* Call the helper to output message */
-		edac_mc_handle_fbd_ue(mci, rank, branch << 1,
-				      (branch << 1) + 1,
-				      pvt->tmp_prt_buffer);
+			 "Bank=%d RAS=%d CAS=%d Err=0x%lx (%s))",
+			 bank, ras, cas, errors, specific);
+
+		edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 0, 0, 0,
+				     branch, -1, rank,
+				     is_wr ? "Write error" : "Read error",
+				     pvt->tmp_prt_buffer, NULL);
+
 	}
 
 	/* read in the 1st NON-FATAL error register */
@@ -513,23 +510,14 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 
 		/* Form out message */
 		snprintf(pvt->tmp_prt_buffer, PAGE_SIZE,
-			"Corrected error (Branch=%d, Channel %d), "
-			" DRAM-Bank=%d %s "
-			"RAS=%d CAS=%d, CE Err=0x%lx, Syndrome=0x%08x(%s))",
-			branch, channel,
-			bank,
-			is_wr ? "RDWR" : "RD",
-			ras, cas,
-			errors, syndrome, specific);
-
-		/*
-		 * Call the helper to output message
-		 * NOTE: Errors are reported per-branch, and not per-channel
-		 *	 Currently, we don't know how to identify the right
-		 *	 channel.
-		 */
-		edac_mc_handle_fbd_ce(mci, rank, channel,
-				      pvt->tmp_prt_buffer);
+			 "DRAM-Bank=%d RAS=%d CAS=%d, Err=0x%lx (%s))",
+			 bank, ras, cas, errors, specific);
+
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0,
+				     syndrome,
+				     branch >> 1, channel % 2, rank,
+				     is_wr ? "Write error" : "Read error",
+				     pvt->tmp_prt_buffer, NULL);
 	}
 	return;
 }
@@ -807,13 +795,17 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 			for (ch = 0; ch < MAX_CH_PER_BRANCH; ch++) {
 				int channel = to_channel(ch, branch);
 
-				dinfo = &pvt->dimm_info[slot][channel];
+				dimm = GET_POS(mci->layers, mci->dimms,
+					       mci->n_layers, branch, ch, slot);
 
-				dimm = mci->csrows[slot].channels[branch * MAX_CH_PER_BRANCH + ch].dimm;
+				dinfo = &pvt->dimm_info[slot][channel];
 
 				mtr = decode_mtr(pvt, slot, ch, branch,
 						 dinfo, dimm);
 
+				mci->tot_dimms++;
+				dimm++;
+
 				/* if no DIMMS on this row, continue */
 				if (!MTR_DIMMS_PRESENT(mtr))
 					continue;
@@ -1034,10 +1026,8 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *id)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[3];
 	struct i7300_pvt *pvt;
-	int num_channels;
-	int num_dimms_per_channel;
-	int num_csrows;
 	int rc;
 
 	/* wake up device */
@@ -1054,22 +1044,17 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	if (PCI_FUNC(pdev->devfn) != 0)
 		return -ENODEV;
 
-	/* As we don't have a motherboard identification routine to determine
-	 * actual number of slots/dimms per channel, we thus utilize the
-	 * resource as specified by the chipset. Thus, we might have
-	 * have more DIMMs per channel than actually on the mobo, but this
-	 * allows the driver to support up to the chipset max, without
-	 * some fancy mobo determination.
-	 */
-	num_dimms_per_channel = MAX_SLOTS;
-	num_channels = MAX_CHANNELS;
-	num_csrows = MAX_SLOTS * MAX_CHANNELS;
-
-	debugf0("MC: %s(): Number of - Channels= %d  DIMMS= %d  CSROWS= %d\n",
-		__func__, num_channels, num_dimms_per_channel, num_csrows);
-
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
+	layers[0].type = EDAC_MC_LAYER_BRANCH;
+	layers[0].size = MAX_BRANCHES;
+	layers[0].is_csrow = false;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = MAX_CHANNELS;
+	layers[1].is_csrow = true;
+	layers[2].type = EDAC_MC_LAYER_SLOT;
+	layers[2].size = MAX_SLOTS;
+	layers[2].is_csrow = true;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 1a7246b..139fd57 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -257,7 +257,6 @@ struct i7core_pvt {
 	struct i7core_channel	channel[NUM_CHANS];
 
 	int		ce_count_available;
-	int 		csrow_map[NUM_CHANS][MAX_DIMMS];
 
 			/* ECC corrected errors counts per udimm */
 	unsigned long	udimm_ce_count[MAX_DIMMS];
@@ -492,113 +491,12 @@ static void free_i7core_dev(struct i7core_dev *i7core_dev)
 /****************************************************************************
 			Memory check routines
  ****************************************************************************/
-static struct pci_dev *get_pdev_slot_func(u8 socket, unsigned slot,
-					  unsigned func)
-{
-	struct i7core_dev *i7core_dev = get_i7core_dev(socket);
-	int i;
-
-	if (!i7core_dev)
-		return NULL;
-
-	for (i = 0; i < i7core_dev->n_devs; i++) {
-		if (!i7core_dev->pdev[i])
-			continue;
-
-		if (PCI_SLOT(i7core_dev->pdev[i]->devfn) == slot &&
-		    PCI_FUNC(i7core_dev->pdev[i]->devfn) == func) {
-			return i7core_dev->pdev[i];
-		}
-	}
-
-	return NULL;
-}
-
-/**
- * i7core_get_active_channels() - gets the number of channels and csrows
- * @socket:	Quick Path Interconnect socket
- * @channels:	Number of channels that will be returned
- * @csrows:	Number of csrows found
- *
- * Since EDAC core needs to know in advance the number of available channels
- * and csrows, in order to allocate memory for csrows/channels, it is needed
- * to run two similar steps. At the first step, implemented on this function,
- * it checks the number of csrows/channels present at one socket.
- * this is used in order to properly allocate the size of mci components.
- *
- * It should be noticed that none of the current available datasheets explain
- * or even mention how csrows are seen by the memory controller. So, we need
- * to add a fake description for csrows.
- * So, this driver is attributing one DIMM memory for one csrow.
- */
-static int i7core_get_active_channels(const u8 socket, unsigned *channels,
-				      unsigned *csrows)
-{
-	struct pci_dev *pdev = NULL;
-	int i, j;
-	u32 status, control;
-
-	*channels = 0;
-	*csrows = 0;
-
-	pdev = get_pdev_slot_func(socket, 3, 0);
-	if (!pdev) {
-		i7core_printk(KERN_ERR, "Couldn't find socket %d fn 3.0!!!\n",
-			      socket);
-		return -ENODEV;
-	}
-
-	/* Device 3 function 0 reads */
-	pci_read_config_dword(pdev, MC_STATUS, &status);
-	pci_read_config_dword(pdev, MC_CONTROL, &control);
-
-	for (i = 0; i < NUM_CHANS; i++) {
-		u32 dimm_dod[3];
-		/* Check if the channel is active */
-		if (!(control & (1 << (8 + i))))
-			continue;
-
-		/* Check if the channel is disabled */
-		if (status & (1 << i))
-			continue;
-
-		pdev = get_pdev_slot_func(socket, i + 4, 1);
-		if (!pdev) {
-			i7core_printk(KERN_ERR, "Couldn't find socket %d "
-						"fn %d.%d!!!\n",
-						socket, i + 4, 1);
-			return -ENODEV;
-		}
-		/* Devices 4-6 function 1 */
-		pci_read_config_dword(pdev,
-				MC_DOD_CH_DIMM0, &dimm_dod[0]);
-		pci_read_config_dword(pdev,
-				MC_DOD_CH_DIMM1, &dimm_dod[1]);
-		pci_read_config_dword(pdev,
-				MC_DOD_CH_DIMM2, &dimm_dod[2]);
-
-		(*channels)++;
-
-		for (j = 0; j < 3; j++) {
-			if (!DIMM_PRESENT(dimm_dod[j]))
-				continue;
-			(*csrows)++;
-		}
-	}
-
-	debugf0("Number of active channels on socket %d: %d\n",
-		socket, *channels);
-
-	return 0;
-}
 
 static int get_dimm_config(struct mem_ctl_info *mci)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
-	struct csrow_info *csr;
 	struct pci_dev *pdev;
 	int i, j;
-	int csrow = 0;
 	enum edac_type mode;
 	enum mem_type mtype;
 
@@ -689,13 +587,15 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			(data & REGISTERED_DIMM) ? 'R' : 'U');
 
 		for (j = 0; j < 3; j++) {
-			struct dimm_info *dimm = &mci->dimms[i * 3 + j];
+			struct dimm_info *dimm;
 			u32 banks, ranks, rows, cols;
 			u32 size, npages;
 
 			if (!DIMM_PRESENT(dimm_dod[j]))
 				continue;
 
+			dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+				       i, j, 0);
 			banks = numbank(MC_DOD_NUMBANK(dimm_dod[j]));
 			ranks = numrank(MC_DOD_NUMRANK(dimm_dod[j]));
 			rows = numrow(MC_DOD_NUMROW(dimm_dod[j]));
@@ -704,8 +604,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			/* DDR3 has 8 I/O banks */
 			size = (rows * cols * banks * ranks) >> (20 - 3);
 
-			pvt->channel[i].dimms++;
-
 			debugf0("\tdimm %d %d Mb offset: %x, "
 				"bank: %d, rank: %d, row: %#x, col: %#x\n",
 				j, size,
@@ -714,12 +612,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 
 			npages = MiB_TO_PAGES(size);
 
-			csr = &mci->csrows[csrow];
-			csr->channels[0].dimm = dimm;
-
-			pvt->csrow_map[i][j] = csrow;
-
-			dimm = csr->channels[0].dimm;
 			dimm->nr_pages = npages;
 
 			switch (banks) {
@@ -742,7 +634,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			dimm->grain = 8;
 			dimm->edac_mode = mode;
 			dimm->mtype = mtype;
-			csrow++;
 		}
 
 		pci_read_config_dword(pdev, MC_SAG_CH_0, &value[0]);
@@ -1558,22 +1449,16 @@ error:
 /****************************************************************************
 			Error check routines
  ****************************************************************************/
-static void i7core_rdimm_update_csrow(struct mem_ctl_info *mci,
+static void i7core_rdimm_update_errcount(struct mem_ctl_info *mci,
 				      const int chan,
 				      const int dimm,
 				      const int add)
 {
-	char *msg;
-	struct i7core_pvt *pvt = mci->pvt_info;
-	int row = pvt->csrow_map[chan][dimm], i;
+	int i;
 
 	for (i = 0; i < add; i++) {
-		msg = kasprintf(GFP_KERNEL, "Corrected error "
-				"(Socket=%d channel=%d dimm=%d)",
-				pvt->i7core_dev->socket, chan, dimm);
-
-		edac_mc_handle_fbd_ce(mci, row, 0, msg);
-		kfree (msg);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+				     chan, dimm, -1, "error", "", NULL);
 	}
 }
 
@@ -1614,11 +1499,11 @@ static void i7core_rdimm_update_ce_count(struct mem_ctl_info *mci,
 
 	/*updated the edac core */
 	if (add0 != 0)
-		i7core_rdimm_update_csrow(mci, chan, 0, add0);
+		i7core_rdimm_update_errcount(mci, chan, 0, add0);
 	if (add1 != 0)
-		i7core_rdimm_update_csrow(mci, chan, 1, add1);
+		i7core_rdimm_update_errcount(mci, chan, 1, add1);
 	if (add2 != 0)
-		i7core_rdimm_update_csrow(mci, chan, 2, add2);
+		i7core_rdimm_update_errcount(mci, chan, 2, add2);
 
 }
 
@@ -1739,19 +1624,29 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	char *type, *optype, *err, *msg;
+	enum hw_event_mc_err_type tp_event;
 	unsigned long error = m->status & 0x1ff0000l;
+	bool uncorrected_error = m->mcgstatus & 1ll << 61;
+	bool ripv = m->mcgstatus & 1;
 	u32 optypenum = (m->status >> 4) & 0x07;
 	u32 core_err_cnt = (m->status >> 38) & 0x7fff;
 	u32 dimm = (m->misc >> 16) & 0x3;
 	u32 channel = (m->misc >> 18) & 0x3;
 	u32 syndrome = m->misc >> 32;
 	u32 errnum = find_first_bit(&error, 32);
-	int csrow;
 
-	if (m->mcgstatus & 1)
-		type = "FATAL";
-	else
-		type = "NON_FATAL";
+	if (uncorrected_error) {
+		if (ripv) {
+			type = "FATAL";
+			tp_event = HW_EVENT_ERR_FATAL;
+		} else {
+			type = "NON_FATAL";
+			tp_event = HW_EVENT_ERR_UNCORRECTED;
+		}
+	} else {
+		type = "CORRECTED";
+		tp_event = HW_EVENT_ERR_CORRECTED;
+	}
 
 	switch (optypenum) {
 	case 0:
@@ -1806,25 +1701,23 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 		err = "unknown";
 	}
 
-	/* FIXME: should convert addr into bank and rank information */
 	msg = kasprintf(GFP_ATOMIC,
-		"%s (addr = 0x%08llx, cpu=%d, Dimm=%d, Channel=%d, "
-		"syndrome=0x%08x, count=%d, Err=%08llx:%08llx (%s: %s))\n",
-		type, (long long) m->addr, m->cpu, dimm, channel,
-		syndrome, core_err_cnt, (long long)m->status,
-		(long long)m->misc, optype, err);
+		"addr=0x%08llx cpu=%d count=%d Err=%08llx:%08llx (%s: %s))\n",
+		(long long) m->addr, m->cpu, core_err_cnt,
+		(long long)m->status, (long long)m->misc, optype, err);
 
-	debugf0("%s", msg);
-
-	csrow = pvt->csrow_map[channel][dimm];
-
-	/* Call the helper to output message */
-	if (m->mcgstatus & 1)
-		edac_mc_handle_fbd_ue(mci, csrow, 0,
-				0 /* FIXME: should be channel here */, msg);
-	else if (!pvt->is_registered)
-		edac_mc_handle_fbd_ce(mci, csrow,
-				0 /* FIXME: should be channel here */, msg);
+	/*
+	 * Call the helper to output message
+	 * FIXME: what to do if core_err_cnt > 1? Currently, it generates
+	 * only one event
+	 */
+	if (uncorrected_error || !pvt->is_registered)
+		edac_mc_handle_error(tp_event, mci,
+				     m->addr >> PAGE_SHIFT,
+				     m->addr & ~PAGE_MASK,
+				     syndrome,
+				     channel, dimm, -1,
+				     err, msg, m);
 
 	kfree(msg);
 }
@@ -2243,15 +2136,19 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 {
 	struct mem_ctl_info *mci;
 	struct i7core_pvt *pvt;
-	int rc, channels, csrows;
-
-	/* Check the number of active and not disabled channels */
-	rc = i7core_get_active_channels(i7core_dev->socket, &channels, &csrows);
-	if (unlikely(rc < 0))
-		return rc;
+	int rc;
+	struct edac_mc_layer layers[2];
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), csrows, channels, i7core_dev->socket);
+
+	layers[0].type = EDAC_MC_LAYER_CHANNEL;
+	layers[0].size = NUM_CHANS;
+	layers[0].is_csrow = false;
+	layers[1].type = EDAC_MC_LAYER_SLOT;
+	layers[1].size = MAX_DIMMS;
+	layers[1].is_csrow = true;
+	mci = edac_mc_alloc(i7core_dev->socket, ARRAY_SIZE(layers), layers,
+			    false, sizeof(*pvt));
 	if (unlikely(!mci))
 		return -ENOMEM;
 
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 74166ae..09d39c0 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -156,19 +156,19 @@ static int i82443bxgx_edacmc_process_error_info(struct mem_ctl_info *mci,
 	if (info->eap & I82443BXGX_EAP_OFFSET_SBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_ce(mci, page, pageoffset,
-				/* 440BX/GX don't make syndrome information
-				 * available */
-				0, edac_mc_find_csrow_by_page(mci, page), 0,
-				mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     page, pageoffset, 0,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0, -1, mci->ctl_name, "", NULL);
 	}
 
 	if (info->eap & I82443BXGX_EAP_OFFSET_MBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_ue(mci, page, pageoffset,
-					edac_mc_find_csrow_by_page(mci, page),
-					mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     page, pageoffset, 0,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0, -1, mci->ctl_name, "", NULL);
 	}
 
 	return error_found;
@@ -196,7 +196,7 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 
 	pci_read_config_byte(pdev, I82443BXGX_DRAMC, &dramc);
 	row_high_limit_last = 0;
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 		dimm = csrow->channels[0].dimm;
 
@@ -235,6 +235,7 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	u8 dramc;
 	u32 nbxcfg, ecc_mode;
 	enum mem_type mtype;
@@ -248,8 +249,13 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	if (pci_read_config_dword(pdev, I82443BXGX_NBXCFG, &nbxcfg))
 		return -EIO;
 
-	mci = edac_mc_alloc(0, I82443BXGX_NR_CSROWS, I82443BXGX_NR_CHANS, 0);
-
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I82443BXGX_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = I82443BXGX_NR_CHANS;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (mci == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 48e0ecd..85ed3a6 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -99,6 +99,7 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 				struct i82860_error_info *info,
 				int handle_errors)
 {
+	struct dimm_info *dimm;
 	int row;
 
 	if (!(info->errsts2 & 0x0003))
@@ -108,18 +109,25 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1, "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
 	info->eap >>= PAGE_SHIFT;
 	row = edac_mc_find_csrow_by_page(mci, info->eap);
+	dimm = mci->csrows[row].channels[0].dimm;
 
 	if (info->errsts & 0x0002)
-		edac_mc_handle_ue(mci, info->eap, 0, row, "i82860 UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     info->eap, 0, 0,
+				     dimm->location[0], dimm->location[1], -1,
+				     "i82860 UE", "", NULL);
 	else
-		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row, 0,
-				"i82860 UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     info->eap, 0, info->derrsyn,
+				     dimm->location[0], dimm->location[1], -1,
+				     "i82860 CE", "", NULL);
 
 	return 1;
 }
@@ -152,7 +160,7 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 	 * cumulative; therefore GRA15 will contain the total memory contained
 	 * in all eight rows.
 	 */
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 		dimm = csrow->channels[0].dimm;
 
@@ -179,18 +187,26 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i82860_error_info discard;
 
-	/* RDRAM has channels but these don't map onto the abstractions that
-	   edac uses.
-	   The device groups from the GRA registers seem to map reasonably
-	   well onto the notion of a chip select row.
-	   There are 16 GRA registers and since the name is associated with
-	   the channel and the GRA registers map to physical devices so we are
-	   going to make 1 channel for group.
+	/*
+	 * RDRAM has channels but these don't map onto the csrow abstraction.
+	 * According with the datasheet, there are 2 Rambus channels, supporting
+	 * up to 16 direct RDRAM devices.
+	 * The device groups from the GRA registers seem to map reasonably
+	 * well onto the notion of a chip select row.
+	 * There are 16 GRA registers and since the name is associated with
+	 * the channel and the GRA registers map to physical devices so we are
+	 * going to make 1 channel for group.
 	 */
-	mci = edac_mc_alloc(0, 16, 1, 0);
-
+	layers[0].type = EDAC_MC_LAYER_CHANNEL;
+	layers[0].size = 2;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_SLOT;
+	layers[1].size = 8;
+	layers[1].is_csrow = true;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index dc207dc..471b26a 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -38,7 +38,8 @@
 #endif				/* PCI_DEVICE_ID_INTEL_82875_6 */
 
 /* four csrows in dual channel, eight in single channel */
-#define I82875P_NR_CSROWS(nr_chans) (8/(nr_chans))
+#define I82875P_NR_DIMMS		8
+#define I82875P_NR_CSROWS(nr_chans)	(I82875P_NR_DIMMS / (nr_chans))
 
 /* Intel 82875p register addresses - device 0 function 0 - DRAM Controller */
 #define I82875P_EAP		0x58	/* Error Address Pointer (32b)
@@ -235,7 +236,9 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0081) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1,
+				     "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
@@ -243,11 +246,15 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, info->eap);
 
 	if (info->errsts & 0x0080)
-		edac_mc_handle_ue(mci, info->eap, 0, row, "i82875p UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     info->eap, 0, 0,
+				     row, -1, -1,
+				     "i82875p UE", "", NULL);
 	else
-		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row,
-				multi_chan ? (info->des & 0x1) : 0,
-				"i82875p CE");
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     info->eap, 0, info->derrsyn,
+				     row, multi_chan ? (info->des & 0x1) : 0,
+				     -1, "i82875p CE", "", NULL);
 
 	return 1;
 }
@@ -359,7 +366,7 @@ static void i82875p_init_csrows(struct mem_ctl_info *mci,
 	 * contain the total memory contained in all eight rows.
 	 */
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 
 		value = readb(ovrfl_window + I82875P_DRB + index);
@@ -390,6 +397,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc = -ENODEV;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i82875p_pvt *pvt;
 	struct pci_dev *ovrfl_pdev;
 	void __iomem *ovrfl_window;
@@ -405,9 +413,14 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENODEV;
 	drc = readl(ovrfl_window + I82875P_DRC);
 	nr_chans = dual_channel_active(drc) + 1;
-	mci = edac_mc_alloc(sizeof(*pvt), I82875P_NR_CSROWS(nr_chans),
-			nr_chans, 0);
 
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I82875P_NR_CSROWS(nr_chans);
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_chans;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (!mci) {
 		rc = -ENOMEM;
 		goto fail0;
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index d7dc455..a59eb4d 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -29,7 +29,8 @@
 #define PCI_DEVICE_ID_INTEL_82975_0	0x277c
 #endif				/* PCI_DEVICE_ID_INTEL_82975_0 */
 
-#define I82975X_NR_CSROWS(nr_chans)		(8/(nr_chans))
+#define I82975X_NR_DIMMS		8
+#define I82975X_NR_CSROWS(nr_chans)	(I82975X_NR_DIMMS / (nr_chans))
 
 /* Intel 82975X register addresses - device 0 function 0 - DRAM Controller */
 #define I82975X_EAP		0x58	/* Dram Error Address Pointer (32b)
@@ -289,7 +290,8 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1, "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
@@ -303,11 +305,15 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, page);
 
 	if (info->errsts & 0x0002)
-		edac_mc_handle_ue(mci, page, offst , row, "i82975x UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     page, offst, 0,
+				     row, -1, -1,
+				     "i82975x UE", "", NULL);
 	else
-		edac_mc_handle_ce(mci, page, offst, info->derrsyn, row,
-				multi_chan ? chan : 0,
-				"i82975x CE");
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     page, offst, info->derrsyn,
+				     row, multi_chan ? chan : 0, -1,
+				     "i82975x CE", "", NULL);
 
 	return 1;
 }
@@ -378,7 +384,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 	 *
 	 */
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 
 		value = readb(mch_window + I82975X_DRB + index +
@@ -465,6 +471,7 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc = -ENODEV;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i82975x_pvt *pvt;
 	void __iomem *mch_window;
 	u32 mchbar;
@@ -533,8 +540,13 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	chans = dual_channel_active(mch_window) + 1;
 
 	/* assuming only one controller, index thus is 0 */
-	mci = edac_mc_alloc(sizeof(*pvt), I82975X_NR_CSROWS(chans),
-					chans, 0);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I82975X_NR_DIMMS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = I82975X_NR_CSROWS(chans);
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (!mci) {
 		rc = -ENOMEM;
 		goto fail1;
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index c1d9e15..d074b71 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -812,7 +812,7 @@ static void mpc85xx_mc_check(struct mem_ctl_info *mci)
 	err_addr = in_be32(pdata->mc_vbase + MPC85XX_MC_CAPTURE_ADDRESS);
 	pfn = err_addr >> PAGE_SHIFT;
 
-	for (row_index = 0; row_index < mci->nr_csrows; row_index++) {
+	for (row_index = 0; row_index < mci->num_csrows; row_index++) {
 		csrow = &mci->csrows[row_index];
 		if ((pfn >= csrow->first_page) && (pfn <= csrow->last_page))
 			break;
@@ -850,16 +850,20 @@ static void mpc85xx_mc_check(struct mem_ctl_info *mci)
 	mpc85xx_mc_printk(mci, KERN_ERR, "PFN: %#8.8x\n", pfn);
 
 	/* we are out of range */
-	if (row_index == mci->nr_csrows)
+	if (row_index == mci->num_csrows)
 		mpc85xx_mc_printk(mci, KERN_ERR, "PFN out of range!\n");
 
 	if (err_detect & DDR_EDE_SBE)
-		edac_mc_handle_ce(mci, pfn, err_addr & ~PAGE_MASK,
-				  syndrome, row_index, 0, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     pfn, err_addr & ~PAGE_MASK, syndrome,
+				     row_index, 0, -1,
+				     mci->ctl_name, "", NULL);
 
 	if (err_detect & DDR_EDE_MBE)
-		edac_mc_handle_ue(mci, pfn, err_addr & ~PAGE_MASK,
-				  row_index, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     pfn, err_addr & ~PAGE_MASK, syndrome,
+				     row_index, 0, -1,
+				     mci->ctl_name, "", NULL);
 
 	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, err_detect);
 }
@@ -925,7 +929,7 @@ static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
 		}
 	}
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		u32 start;
 		u32 end;
 
@@ -961,6 +965,7 @@ static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
 static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct mpc85xx_mc_pdata *pdata;
 	struct resource r;
 	u32 sdram_ctl;
@@ -969,7 +974,14 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	if (!devres_open_group(&op->dev, mpc85xx_mc_err_probe, GFP_KERNEL))
 		return -ENOMEM;
 
-	mci = edac_mc_alloc(sizeof(*pdata), 4, 1, edac_mc_idx);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = 4;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = 1;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
+			    sizeof(*pdata));
 	if (!mci) {
 		devres_release_group(&op->dev, mpc85xx_mc_err_probe);
 		return -ENOMEM;
@@ -1158,7 +1170,6 @@ static void __init mpc85xx_mc_clear_rfxe(void *data)
 static int __init mpc85xx_mc_init(void)
 {
 	int res = 0;
-	u32 pvr = 0;
 
 	printk(KERN_INFO "Freescale(R) MPC85xx EDAC driver, "
 	       "(C) 2006 Montavista Software\n");
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 281e245..a32e9b6 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -611,12 +611,17 @@ static void mv64x60_mc_check(struct mem_ctl_info *mci)
 
 	/* first bit clear in ECC Err Reg, 1 bit error, correctable by HW */
 	if (!(reg & 0x1))
-		edac_mc_handle_ce(mci, err_addr >> PAGE_SHIFT,
-				  err_addr & PAGE_MASK, syndrome, 0, 0,
-				  mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     err_addr >> PAGE_SHIFT,
+				     err_addr & PAGE_MASK, syndrome,
+				     0, 0, -1,
+				     mci->ctl_name, "", NULL);
 	else	/* 2 bit error, UE */
-		edac_mc_handle_ue(mci, err_addr >> PAGE_SHIFT,
-				  err_addr & PAGE_MASK, 0, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     err_addr >> PAGE_SHIFT,
+				     err_addr & PAGE_MASK, 0,
+				     0, 0, -1,
+				     mci->ctl_name, "", NULL);
 
 	/* clear the error */
 	out_le32(pdata->mc_vbase + MV64X60_SDRAM_ERR_ADDR, 0);
@@ -695,6 +700,7 @@ static void mv64x60_init_csrows(struct mem_ctl_info *mci,
 static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct mv64x60_mc_pdata *pdata;
 	struct resource *r;
 	u32 ctl;
@@ -703,7 +709,14 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	if (!devres_open_group(&pdev->dev, mv64x60_mc_err_probe, GFP_KERNEL))
 		return -ENOMEM;
 
-	mci = edac_mc_alloc(sizeof(struct mv64x60_mc_pdata), 1, 1, edac_mc_idx);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = 1;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = 1;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
+			    sizeof(struct mv64x60_mc_pdata));
 	if (!mci) {
 		printk(KERN_ERR "%s: No memory for CPU err\n", __func__);
 		devres_release_group(&pdev->dev, mv64x60_mc_err_probe);
diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index 3fcefda..2959db6 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -110,15 +110,16 @@ static void pasemi_edac_process_error_info(struct mem_ctl_info *mci, u32 errsta)
 	/* uncorrectable/multi-bit errors */
 	if (errsta & (MCDEBUG_ERRSTA_MBE_STATUS |
 		      MCDEBUG_ERRSTA_RFL_STATUS)) {
-		edac_mc_handle_ue(mci, mci->csrows[cs].first_page, 0,
-				  cs, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     mci->csrows[cs].first_page, 0, 0,
+				     cs, 0, -1, mci->ctl_name, "", NULL);
 	}
 
 	/* correctable/single-bit errors */
-	if (errsta & MCDEBUG_ERRSTA_SBE_STATUS) {
-		edac_mc_handle_ce(mci, mci->csrows[cs].first_page, 0,
-				  0, cs, 0, mci->ctl_name);
-	}
+	if (errsta & MCDEBUG_ERRSTA_SBE_STATUS)
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     mci->csrows[cs].first_page, 0, 0,
+				     cs, 0, -1, mci->ctl_name, "", NULL);
 }
 
 static void pasemi_edac_check(struct mem_ctl_info *mci)
@@ -139,7 +140,7 @@ static int pasemi_edac_init_csrows(struct mem_ctl_info *mci,
 	u32 rankcfg;
 	int index;
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 		dimm = csrow->channels[0].dimm;
 
@@ -191,6 +192,7 @@ static int __devinit pasemi_edac_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
 {
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	u32 errctl1, errcor, scrub, mcen;
 
 	pci_read_config_dword(pdev, MCCFG_MCEN, &mcen);
@@ -207,9 +209,14 @@ static int __devinit pasemi_edac_probe(struct pci_dev *pdev,
 		MCDEBUG_ERRCTL1_RFL_LOG_EN;
 	pci_write_config_dword(pdev, MCDEBUG_ERRCTL1, errctl1);
 
-	mci = edac_mc_alloc(0, PASEMI_EDAC_NR_CSROWS, PASEMI_EDAC_NR_CHANS,
-				system_mmc_id++);
-
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = PASEMI_EDAC_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = PASEMI_EDAC_NR_CHANS;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(system_mmc_id++, ARRAY_SIZE(layers), layers, false,
+			    0);
 	if (mci == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 1adaddf..89ffc39 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -330,7 +330,7 @@ ppc4xx_edac_generate_bank_message(const struct mem_ctl_info *mci,
 	size -= n;
 	total += n;
 
-	for (rows = 0, row = 0; row < mci->nr_csrows; row++) {
+	for (rows = 0, row = 0; row < mci->num_csrows; row++) {
 		if (ppc4xx_edac_check_bank_error(status, row)) {
 			n = snprintf(buffer, size, "%s%u",
 					(rows++ ? ", " : ""), row);
@@ -725,9 +725,12 @@ ppc4xx_edac_handle_ce(struct mem_ctl_info *mci,
 
 	ppc4xx_edac_generate_message(mci, status, message, sizeof(message));
 
-	for (row = 0; row < mci->nr_csrows; row++)
+	for (row = 0; row < mci->num_csrows; row++)
 		if (ppc4xx_edac_check_bank_error(status, row))
-			edac_mc_handle_ce_no_info(mci, message);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     0, 0, 0,
+					     row, 0, -1,
+					     message, "", NULL);
 }
 
 /**
@@ -753,9 +756,12 @@ ppc4xx_edac_handle_ue(struct mem_ctl_info *mci,
 
 	ppc4xx_edac_generate_message(mci, status, message, sizeof(message));
 
-	for (row = 0; row < mci->nr_csrows; row++)
+	for (row = 0; row < mci->num_csrows; row++)
 		if (ppc4xx_edac_check_bank_error(status, row))
-			edac_mc_handle_ue(mci, page, offset, row, message);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     page, offset, 0,
+					     row, 0, -1,
+					     message, "", NULL);
 }
 
 /**
@@ -917,7 +923,7 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 	 * 1:1 with a controller bank/rank.
 	 */
 
-	for (row = 0; row < mci->nr_csrows; row++) {
+	for (row = 0; row < mci->num_csrows; row++) {
 		struct csrow_info *csi = &mci->csrows[row];
 
 		/*
@@ -1233,6 +1239,7 @@ static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 	dcr_host_t dcr_host;
 	const struct device_node *np = op->dev.of_node;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	static int ppc4xx_edac_instance;
 
 	/*
@@ -1278,12 +1285,14 @@ static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 	 * controller instance and perform the appropriate
 	 * initialization.
 	 */
-
-	mci = edac_mc_alloc(sizeof(struct ppc4xx_edac_pdata),
-			    ppc4xx_edac_nr_csrows,
-			    ppc4xx_edac_nr_chans,
-			    ppc4xx_edac_instance);
-
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = ppc4xx_edac_nr_csrows;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = ppc4xx_edac_nr_chans;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(ppc4xx_edac_instance, ARRAY_SIZE(layers), layers,
+			    false, sizeof(struct ppc4xx_edac_pdata));
 	if (mci == NULL) {
 		ppc4xx_edac_printk(KERN_ERR, "%s: "
 				   "Failed to allocate EDAC MC instance!\n",
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index a4b0626..f820c14 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -179,10 +179,11 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 		error_found = 1;
 
 		if (handle_errors)
-			edac_mc_handle_ce(mci, page, 0,	/* not avail */
-					syndrome,
-					edac_mc_find_csrow_by_page(mci, page),
-					0, mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     page, 0, syndrome,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0, -1,
+					     mci->ctl_name, "", NULL);
 	}
 
 	if (info->eapr & BIT(1)) {	/* UE? */
@@ -190,9 +191,11 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors)
 			/* 82600 doesn't give enough info */
-			edac_mc_handle_ue(mci, page, 0,
-					edac_mc_find_csrow_by_page(mci, page),
-					mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     page, 0, 0,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0, -1,
+					     mci->ctl_name, "", NULL);
 	}
 
 	return error_found;
@@ -226,7 +229,7 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	reg_sdram = dramcr & BIT(4);
 	row_high_limit_last = 0;
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 		dimm = csrow->channels[0].dimm;
 
@@ -267,6 +270,7 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	u8 dramcr;
 	u32 eapr;
 	u32 scrub_disabled;
@@ -281,8 +285,13 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	debugf2("%s(): sdram refresh rate = %#0x\n", __func__,
 		sdram_refresh_rate);
 	debugf2("%s(): DRAMC register = %#0x\n", __func__, dramcr);
-	mci = edac_mc_alloc(0, R82600_NR_CSROWS, R82600_NR_CHANS, 0);
-
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = R82600_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = R82600_NR_CHANS;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (mci == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 981262b..4752a7f 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -313,8 +313,6 @@ struct sbridge_pvt {
 	struct sbridge_info	info;
 	struct sbridge_channel	channel[NUM_CHANNELS];
 
-	int 			csrow_map[NUM_CHANNELS][MAX_DIMMS];
-
 	/* Memory type detection */
 	bool			is_mirrored, is_lockstep, is_close_pg;
 
@@ -486,29 +484,14 @@ static struct pci_dev *get_pdev_slot_func(u8 bus, unsigned slot,
 }
 
 /**
- * sbridge_get_active_channels() - gets the number of channels and csrows
+ * check_if_ecc_is_active() - Checks if ECC is active
  * bus:		Device bus
- * @channels:	Number of channels that will be returned
- * @csrows:	Number of csrows found
- *
- * Since EDAC core needs to know in advance the number of available channels
- * and csrows, in order to allocate memory for csrows/channels, it is needed
- * to run two similar steps. At the first step, implemented on this function,
- * it checks the number of csrows/channels present at one socket, identified
- * by the associated PCI bus.
- * this is used in order to properly allocate the size of mci components.
- * Note: one csrow is one dimm.
  */
-static int sbridge_get_active_channels(const u8 bus, unsigned *channels,
-				      unsigned *csrows)
+static int check_if_ecc_is_active(const u8 bus)
 {
 	struct pci_dev *pdev = NULL;
-	int i, j;
 	u32 mcmtr;
 
-	*channels = 0;
-	*csrows = 0;
-
 	pdev = get_pdev_slot_func(bus, 15, 0);
 	if (!pdev) {
 		sbridge_printk(KERN_ERR, "Couldn't find PCI device "
@@ -522,41 +505,14 @@ static int sbridge_get_active_channels(const u8 bus, unsigned *channels,
 		sbridge_printk(KERN_ERR, "ECC is disabled. Aborting\n");
 		return -ENODEV;
 	}
-
-	for (i = 0; i < NUM_CHANNELS; i++) {
-		u32 mtr;
-
-		/* Device 15 functions 2 - 5  */
-		pdev = get_pdev_slot_func(bus, 15, 2 + i);
-		if (!pdev) {
-			sbridge_printk(KERN_ERR, "Couldn't find PCI device "
-						 "%2x.%02d.%d!!!\n",
-						 bus, 15, 2 + i);
-			return -ENODEV;
-		}
-		(*channels)++;
-
-		for (j = 0; j < ARRAY_SIZE(mtr_regs); j++) {
-			pci_read_config_dword(pdev, mtr_regs[j], &mtr);
-			debugf1("Bus#%02x channel #%d  MTR%d = %x\n", bus, i, j, mtr);
-			if (IS_DIMM_PRESENT(mtr))
-				(*csrows)++;
-		}
-	}
-
-	debugf0("Number of active channels: %d, number of active dimms: %d\n",
-		*channels, *csrows);
-
 	return 0;
 }
 
 static int get_dimm_config(struct mem_ctl_info *mci)
 {
 	struct sbridge_pvt *pvt = mci->pvt_info;
-	struct csrow_info *csr;
+	struct dimm_info *dimm;
 	int i, j, banks, ranks, rows, cols, size, npages;
-	int csrow = 0;
-	unsigned long last_page = 0;
 	u32 reg;
 	enum edac_type mode;
 	enum mem_type mtype;
@@ -615,7 +571,8 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 		u32 mtr;
 
 		for (j = 0; j < ARRAY_SIZE(mtr_regs); j++) {
-			struct dimm_info *dimm = &mci->dimms[j];
+			dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+				       i, j, 0);
 			pci_read_config_dword(pvt->pci_tad[i],
 					      mtr_regs[j], &mtr);
 			debugf4("Channel #%d  MTR%d = %x\n", i, j, mtr);
@@ -635,19 +592,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 					size, npages,
 					banks, ranks, rows, cols);
 
-				/*
-				 * Fake stuff. This controller doesn't see
-				 * csrows.
-				 */
-				csr = &mci->csrows[csrow];
-				pvt->csrow_map[i][j] = csrow;
-				last_page += npages;
-				csrow++;
-
-				csr->channels[0].dimm = dimm;
 				dimm->nr_pages = npages;
-				dimm->mc_channel = i;
-				dimm->mc_dimm_number = j;
 				dimm->grain = 32;
 				dimm->dtype = (banks == 8) ? DEV_X8 : DEV_X4;
 				dimm->mtype = mtype;
@@ -834,11 +779,10 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 				 u8 *socket,
 				 long *channel_mask,
 				 u8 *rank,
-				 char *area_type)
+				 char *area_type, char *msg)
 {
 	struct mem_ctl_info	*new_mci;
 	struct sbridge_pvt *pvt = mci->pvt_info;
-	char			msg[256];
 	int 			n_rir, n_sads, n_tads, sad_way, sck_xch;
 	int			sad_interl, idx, base_ch;
 	int			interleave_mode;
@@ -859,12 +803,10 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	 */
 	if ((addr > (u64) pvt->tolm) && (addr < (1L << 32))) {
 		sprintf(msg, "Error at TOLM area, on addr 0x%08Lx", addr);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	if (addr >= (u64)pvt->tohm) {
 		sprintf(msg, "Error at MMIOH area, on addr 0x%016Lx", addr);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 
@@ -881,7 +823,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		limit = SAD_LIMIT(reg);
 		if (limit <= prv) {
 			sprintf(msg, "Can't discover the memory socket");
-			edac_mc_handle_ce_no_info(mci, msg);
 			return -EINVAL;
 		}
 		if  (addr <= limit)
@@ -890,7 +831,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	}
 	if (n_sads == MAX_SAD) {
 		sprintf(msg, "Can't discover the memory socket");
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	area_type = get_dram_attr(reg);
@@ -931,7 +871,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		break;
 	default:
 		sprintf(msg, "Can't discover socket interleave");
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	*socket = sad_interleave[idx];
@@ -946,7 +885,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	if (!new_mci) {
 		sprintf(msg, "Struct for socket #%u wasn't initialized",
 			*socket);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	mci = new_mci;
@@ -962,7 +900,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		limit = TAD_LIMIT(reg);
 		if (limit <= prv) {
 			sprintf(msg, "Can't discover the memory channel");
-			edac_mc_handle_ce_no_info(mci, msg);
 			return -EINVAL;
 		}
 		if  (addr <= limit)
@@ -1002,7 +939,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		break;
 	default:
 		sprintf(msg, "Can't discover the TAD target");
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	*channel_mask = 1 << base_ch;
@@ -1016,7 +952,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 			break;
 		default:
 			sprintf(msg, "Invalid mirror set. Can't decode addr");
-			edac_mc_handle_ce_no_info(mci, msg);
 			return -EINVAL;
 		}
 	} else
@@ -1044,7 +979,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	if (offset > addr) {
 		sprintf(msg, "Can't calculate ch addr: TAD offset 0x%08Lx is too high for addr 0x%08Lx!",
 			offset, addr);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	addr -= offset;
@@ -1084,7 +1018,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	if (n_rir == MAX_RIR_RANGES) {
 		sprintf(msg, "Can't discover the memory rank for ch addr 0x%08Lx",
 			ch_addr);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	rir_way = RIR_WAY(reg);
@@ -1398,7 +1331,8 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 {
 	struct mem_ctl_info *new_mci;
 	struct sbridge_pvt *pvt = mci->pvt_info;
-	char *type, *optype, *msg, *recoverable_msg;
+	enum hw_event_mc_err_type tp_event;
+	char *type, *optype, msg[256], *recoverable_msg;
 	bool ripv = GET_BITFIELD(m->mcgstatus, 0, 0);
 	bool overflow = GET_BITFIELD(m->status, 62, 62);
 	bool uncorrected_error = GET_BITFIELD(m->status, 61, 61);
@@ -1410,13 +1344,21 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	u32 optypenum = GET_BITFIELD(m->status, 4, 6);
 	long channel_mask, first_channel;
 	u8  rank, socket;
-	int csrow, rc, dimm;
+	int rc, dimm;
 	char *area_type = "Unknown";
 
-	if (ripv)
-		type = "NON_FATAL";
-	else
-		type = "FATAL";
+	if (uncorrected_error) {
+		if (ripv) {
+			type = "FATAL";
+			tp_event = HW_EVENT_ERR_FATAL;
+		} else {
+			type = "NON_FATAL";
+			tp_event = HW_EVENT_ERR_UNCORRECTED;
+		}
+	} else {
+		type = "CORRECTED";
+		tp_event = HW_EVENT_ERR_CORRECTED;
+	}
 
 	/*
 	 * According with Table 15-9 of the Intel Archictecture spec vol 3A,
@@ -1434,19 +1376,19 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	} else {
 		switch (optypenum) {
 		case 0:
-			optype = "generic undef request";
+			optype = "generic undef request error";
 			break;
 		case 1:
-			optype = "memory read";
+			optype = "memory read error";
 			break;
 		case 2:
-			optype = "memory write";
+			optype = "memory write error";
 			break;
 		case 3:
-			optype = "addr/cmd";
+			optype = "addr/cmd error";
 			break;
 		case 4:
-			optype = "memory scrubbing";
+			optype = "memory scrubbing error";
 			break;
 		default:
 			optype = "reserved";
@@ -1455,13 +1397,13 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	}
 
 	rc = get_memory_error_data(mci, m->addr, &socket,
-				   &channel_mask, &rank, area_type);
+				   &channel_mask, &rank, area_type, msg);
 	if (rc < 0)
-		return;
+		goto err_parsing;
 	new_mci = get_mci_for_node_id(socket);
 	if (!new_mci) {
-		edac_mc_handle_ce_no_info(mci, "Error: socket got corrupted!");
-		return;
+		strcpy(msg, "Error: socket got corrupted!");
+		goto err_parsing;
 	}
 	mci = new_mci;
 	pvt = mci->pvt_info;
@@ -1475,8 +1417,6 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	else
 		dimm = 2;
 
-	csrow = pvt->csrow_map[first_channel][dimm];
-
 	if (uncorrected_error && recoverable)
 		recoverable_msg = " recoverable";
 	else
@@ -1487,18 +1427,14 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	 * Probably, we can just discard it, as the channel information
 	 * comes from the get_memory_error_data() address decoding
 	 */
-	msg = kasprintf(GFP_ATOMIC,
-			"%d %s error(s): %s on %s area %s%s: cpu=%d Err=%04x:%04x (ch=%d), "
-			"addr = 0x%08llx => socket=%d, Channel=%ld(mask=%ld), rank=%d\n",
+	snprintf(msg, sizeof(msg),
+			"%d error(s)%s: %s%s: cpu=%d Err=%04x:%04x addr = 0x%08llx socket=%d Channel=%ld(mask=%ld), rank=%d\n",
 			core_err_cnt,
+			overflow ? " OVERFLOW" : "",
 			area_type,
-			optype,
-			type,
 			recoverable_msg,
-			overflow ? "OVERFLOW" : "",
 			m->cpu,
 			mscod, errcode,
-			channel,		/* 1111b means not specified */
 			(long long) m->addr,
 			socket,
 			first_channel,		/* This is the real channel on SB */
@@ -1507,13 +1443,19 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 
 	debugf0("%s", msg);
 
+	/* FIXME: need support for channel mask */
+
 	/* Call the helper to output message */
-	if (uncorrected_error)
-		edac_mc_handle_fbd_ue(mci, csrow, 0, 0, msg);
-	else
-		edac_mc_handle_fbd_ce(mci, csrow, 0, msg);
+	edac_mc_handle_error(tp_event, mci,
+			     m->addr >> PAGE_SHIFT, m->addr & ~PAGE_MASK, 0,
+			     channel, dimm, -1,
+			     optype, msg, m);
+	return;
+err_parsing:
+	edac_mc_handle_error(tp_event, mci, 0, 0, 0,
+			     -1, -1, -1,
+			     msg, "", m);
 
-	kfree(msg);
 }
 
 /*
@@ -1675,16 +1617,25 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct sbridge_pvt *pvt;
-	int rc, channels, csrows;
+	int rc;
 
 	/* Check the number of active and not disabled channels */
-	rc = sbridge_get_active_channels(sbridge_dev->bus, &channels, &csrows);
+	rc = check_if_ecc_is_active(sbridge_dev->bus);
 	if (unlikely(rc < 0))
 		return rc;
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), csrows, channels, sbridge_dev->mc);
+	layers[0].type = EDAC_MC_LAYER_CHANNEL;
+	layers[0].size = NUM_CHANNELS;
+	layers[0].is_csrow = false;
+	layers[1].type = EDAC_MC_LAYER_SLOT;
+	layers[1].size = MAX_DIMMS;
+	layers[1].is_csrow = true;
+	mci = edac_mc_alloc(sbridge_dev->mc, ARRAY_SIZE(layers), layers,
+			    false, sizeof(*pvt));
+
 	if (unlikely(!mci))
 		return -ENOMEM;
 
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 6314ff9..9a91826 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -71,7 +71,10 @@ static void tile_edac_check(struct mem_ctl_info *mci)
 	if (mem_error.sbe_count != priv->ce_count) {
 		dev_dbg(mci->dev, "ECC CE err on node %d\n", priv->node);
 		priv->ce_count = mem_error.sbe_count;
-		edac_mc_handle_ce(mci, 0, 0, 0, 0, 0, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     0, 0, 0,
+				     0, 0, -1,
+				     mci->ctl_name, "", NULL);
 	}
 }
 
@@ -122,6 +125,7 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 	char			hv_file[32];
 	int			hv_devhdl;
 	struct mem_ctl_info	*mci;
+	struct edac_mc_layer	layers[2];
 	struct tile_edac_priv	*priv;
 	int			rc;
 
@@ -131,8 +135,14 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	/* A TILE MC has a single channel and one chip-select row. */
-	mci = edac_mc_alloc(sizeof(struct tile_edac_priv),
-		TILE_EDAC_NR_CSROWS, TILE_EDAC_NR_CHANS, pdev->id);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = TILE_EDAC_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = TILE_EDAC_NR_CHANS;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false,
+			    sizeof(struct tile_edac_priv));
 	if (mci == NULL)
 		return -ENOMEM;
 	priv = mci->pvt_info;
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 0de288f..5f3c57f 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -215,19 +215,26 @@ static void x38_process_error_info(struct mem_ctl_info *mci,
 		return;
 
 	if ((info->errsts ^ info->errsts2) & X38_ERRSTS_BITS) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1,
+				     "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
 	for (channel = 0; channel < x38_channel_num; channel++) {
 		log = info->eccerrlog[channel];
 		if (log & X38_ECCERRLOG_UE) {
-			edac_mc_handle_ue(mci, 0, 0,
-				eccerrlog_row(channel, log), "x38 UE");
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     0, 0, 0,
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "x38 UE", "", NULL);
 		} else if (log & X38_ECCERRLOG_CE) {
-			edac_mc_handle_ce(mci, 0, 0,
-				eccerrlog_syndrome(log),
-				eccerrlog_row(channel, log), 0, "x38 CE");
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     0, 0, eccerrlog_syndrome(log),
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "x38 CE", "", NULL);
 		}
 	}
 }
@@ -319,6 +326,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	u16 drbs[X38_CHANNELS][X38_RANKS_PER_CHANNEL];
 	bool stacked;
 	void __iomem *window;
@@ -334,7 +342,13 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	how_many_channel(pdev);
 
 	/* FIXME: unconventional pvt_info usage */
-	mci = edac_mc_alloc(0, X38_RANKS, x38_channel_num, 0);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = X38_RANKS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = x38_channel_num;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
@@ -362,7 +376,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	 * cumulative; the last one will contain the total memory
 	 * contained in all ranks.
 	 */
-	for (i = 0; i < mci->nr_csrows; i++) {
+	for (i = 0; i < mci->num_csrows; i++) {
 		unsigned long nr_pages;
 		struct csrow_info *csrow = &mci->csrows[i];
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 1862a4b..71d37b0 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -79,6 +79,25 @@ enum dev_type {
 #define DEV_FLAG_X64		BIT(DEV_X64)
 
 /**
+ * enum hw_event_mc_err_type - type of the detected error
+ *
+ * @HW_EVENT_ERR_CORRECTED:	Corrected Error - Indicates that an ECC
+ *				corrected error was detected
+ * @HW_EVENT_ERR_UNCORRECTED:	Uncorrected Error - Indicates an error that
+ *				can't be corrected by ECC, but it is not
+ *				factal (maybe it is on an unused memory area,
+ *				or the memory controller could recover from
+ *				it for example, by re-trying the operation).
+ * @HW_EVENT_ERR_FATAL:		Fatal Error - Uncorrected error that could not
+ *				be recovered.
+ */
+enum hw_event_mc_err_type {
+	HW_EVENT_ERR_CORRECTED,
+	HW_EVENT_ERR_UNCORRECTED,
+	HW_EVENT_ERR_FATAL,
+};
+
+/**
  * enum mem_type - Type of the memory stick
  *
  * @MEM_EMPTY		Empty csrow
@@ -369,12 +388,75 @@ enum scrub_type {
  * PS - I enjoyed writing all that about as much as you enjoyed reading it.
  */
 
-/* FIXME: add a per-dimm ce error count */
+/**
+ * enum edac_mc_layer - memory controller hierarchy layer
+ *
+ * @EDAC_MC_LAYER_BRANCH:	memory layer is named "branch"
+ * @EDAC_MC_LAYER_CHANNEL:	memory layer is named "channel"
+ * @EDAC_MC_LAYER_SLOT:		memory layer is named "slot"
+ * @EDAC_MC_LAYER_CHIP_SELECT:	memory layer is named "chip select"
+ *
+ * This enum is used by the drivers to tell edac_mc_sysfs what name should
+ * be used when describing a memory stick location.
+ */
+enum edac_mc_layer_type {
+	EDAC_MC_LAYER_BRANCH,
+	EDAC_MC_LAYER_CHANNEL,
+	EDAC_MC_LAYER_SLOT,
+	EDAC_MC_LAYER_CHIP_SELECT,
+};
+
+/**
+ * struct edac_mc_layer - describes the memory controller hierarchy
+ * @layer:		layer type
+ * @size:maximum size of the layer
+ * @is_csrow:		This layer is part of the "csrow" when old API
+ *			compatibility mode is enabled. Otherwise, it is
+ *			a channel
+ */
+struct edac_mc_layer {
+	enum edac_mc_layer_type	type;
+	unsigned		size;
+	bool			is_csrow;
+};
+
+/*
+ * Maximum number of layers used by the memory controller to uniquelly
+ * identify a single memory stick.
+ * NOTE: incrementing it would require changes at edac_mc_handle_error()
+ * and at the routines at edac_mc_sysfs that create layers
+ */
+#define EDAC_MAX_LAYERS		3
+
+/*
+ * A loop could be used here to make it more generic, but, as we only have
+ * 3 layers, this is a little faster. By design, layers can never be 0 or
+ * more than 3. If that ever happens, a NULL is returned, causing an OOPS
+ * during the memory allocation routine, with would point to the developer
+ * that he's doing something wrong.
+ */
+#define GET_POS(layers, var, nlayers, lay0, lay1, lay2) ({		\
+	typeof(var) __p;						\
+	if ((nlayers) == 1)						\
+		__p = &var[lay0];					\
+	else if ((nlayers) == 2)					\
+		__p = &var[(lay1) + ((layers[1]).size * (lay0))];	\
+	else if ((nlayers) == 3)					\
+		__p = &var[(lay2) + ((layers[2]).size * ((lay1) +	\
+			    ((layers[1]).size * (lay0))))];		\
+	else								\
+		__p = NULL;						\
+	__p;								\
+})
+
+
+/* FIXME: add the proper per-location error counts */
 struct dimm_info {
 	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
-	unsigned memory_controller;
-	unsigned csrow;
-	unsigned csrow_channel;
+
+	/* Memory location data */
+	unsigned location[EDAC_MAX_LAYERS];
+
 	struct kobject kobj;		/* sysfs kobject for this csrow */
 	struct mem_ctl_info *mci;	/* the parent */
 
@@ -383,9 +465,9 @@ struct dimm_info {
 	enum mem_type mtype;	/* memory dimm type */
 	enum edac_type edac_mode;	/* EDAC mode for this dimm */
 
-	u32 nr_pages;			/* number of pages in csrow */
+	u32 nr_pages;			/* number of pages on this dimm */
 
-	u32 ce_count;		/* Correctable Errors for this dimm */
+	unsigned csrow, cschannel;	/* Points to the old API data */
 };
 
 /**
@@ -405,9 +487,10 @@ struct dimm_info {
  */
 struct rank_info {
 	int chan_idx;
-	u32 ce_count;
 	struct csrow_info *csrow;
 	struct dimm_info *dimm;
+
+	u32 ce_count;		/* Correctable Errors for this csrow */
 };
 
 struct csrow_info {
@@ -459,6 +542,11 @@ struct mcidev_sysfs_attribute {
         ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
 };
 
+struct edac_hierarchy {
+	char		*name;
+	unsigned	nr;
+};
+
 /* MEMORY controller information structure
  */
 struct mem_ctl_info {
@@ -503,13 +591,16 @@ struct mem_ctl_info {
 	unsigned long (*ctl_page_to_phys) (struct mem_ctl_info * mci,
 					   unsigned long page);
 	int mc_idx;
-	int nr_csrows;
 	struct csrow_info *csrows;
+	unsigned num_csrows, num_cschannel;
 
+	/* Memory Controller hierarchy */
+	unsigned n_layers;
+	struct edac_mc_layer *layers;
 	/*
 	 * DIMM info. Will eventually remove the entire csrows_info some day
 	 */
-	unsigned nr_dimms;
+	unsigned tot_dimms;
 	struct dimm_info *dimms;
 
 	/*
@@ -524,12 +615,13 @@ struct mem_ctl_info {
 	const char *dev_name;
 	char proc_name[MC_PROC_NAME_MAX_LEN + 1];
 	void *pvt_info;
-	u32 ue_noinfo_count;	/* Uncorrectable Errors w/o info */
-	u32 ce_noinfo_count;	/* Correctable Errors w/o info */
-	u32 ue_count;		/* Total Uncorrectable Errors for this MC */
-	u32 ce_count;		/* Total Correctable Errors for this MC */
 	unsigned long start_time;	/* mci load start time (in jiffies) */
 
+	/* drivers shouldn't access this struct directly */
+	unsigned ce_noinfo_count, ue_noinfo_count;
+	unsigned ce_mc, ue_mc;
+	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
+
 	struct completion complete;
 
 	/* edac sysfs device control */
@@ -542,7 +634,7 @@ struct mem_ctl_info {
 	 * by the low level driver.
 	 *
 	 * Set by the low level driver to provide attributes at the
-	 * controller level, same level as 'ue_count' and 'ce_count' above.
+	 * controller level.
 	 * An array of structures, NULL terminated
 	 *
 	 * If attributes are desired, then set to array of attributes
-- 
1.7.8

