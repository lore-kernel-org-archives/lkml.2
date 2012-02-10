Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2BJAEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:04:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720Ab2BJABj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 17/31] edac-mc: Allow reporting errors on a non-csrow oriented way
Date: Thu,  9 Feb 2012 22:01:16 -0200
Message-Id: <1328832090-9166-18-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The edac core were written with the idea that memory controllers
are able to directly access csrows, and that the channels are
used inside a csrows select.

This is not true for FB-DIMM and RAMBUS memory controllers.

Also, some advanced memory controllers don't present a per-csrows
view.

So, change the allocation and error report routines to allow
them to work with all types of architectures.

This allowed to remove several hacks on FB-DIMM and RAMBUS
memory controllers.

Compiled-tested only on all platforms (x86_64, i386, tile and several
ppc subarchs).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c       |  145 +++++--
 drivers/edac/amd76x_edac.c      |   27 +-
 drivers/edac/cell_edac.c        |   21 +-
 drivers/edac/cpc925_edac.c      |   21 +-
 drivers/edac/e752x_edac.c       |   40 ++-
 drivers/edac/e7xxx_edac.c       |   42 ++-
 drivers/edac/edac_core.h        |   74 ++--
 drivers/edac/edac_device.c      |   27 +-
 drivers/edac/edac_mc.c          |  837 +++++++++++++++++++++++++--------------
 drivers/edac/edac_mc_sysfs.c    |   80 +++--
 drivers/edac/edac_module.h      |    2 +-
 drivers/edac/edac_pci.c         |    7 +-
 drivers/edac/i3000_edac.c       |   27 +-
 drivers/edac/i3200_edac.c       |   33 +-
 drivers/edac/i5000_edac.c       |   48 ++-
 drivers/edac/i5100_edac.c       |   73 ++---
 drivers/edac/i5400_edac.c       |   40 +-
 drivers/edac/i7300_edac.c       |   61 ++--
 drivers/edac/i7core_edac.c      |  102 +++--
 drivers/edac/i82443bxgx_edac.c  |   26 +-
 drivers/edac/i82860_edac.c      |   46 ++-
 drivers/edac/i82875p_edac.c     |   32 +-
 drivers/edac/i82975x_edac.c     |   31 +-
 drivers/edac/mpc85xx_edac.c     |   23 +-
 drivers/edac/mv64x60_edac.c     |   21 +-
 drivers/edac/pasemi_edac.c      |   24 +-
 drivers/edac/ppc4xx_edac.c      |   29 +-
 drivers/edac/r82600_edac.c      |   28 +-
 drivers/edac/sb_edac.c          |   89 +++--
 drivers/edac/tile_edac.c        |   12 +-
 drivers/edac/x38_edac.c         |   29 +-
 include/linux/edac.h            |  298 ++++++++------
 include/trace/events/hw_event.h |   40 ++-
 33 files changed, 1518 insertions(+), 917 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3cba6a5..139e774 100644
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
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a node");
+		return;
+	}
+
+	/* Now map the sys_addr to a CSROW */
+	csrow = sys_addr_to_csrow(src_mci, sys_addr);
+	if (csrow < 0) {
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a csrow");
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
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+					     HW_EVENT_SCOPE_MC_CSROW, mci,
+					     page, offset, syndrome,
+					     -1, -1, -1, csrow, -1,
+					     EDAC_MOD_STR,
+					     "unknown syndrome - possible error reporting race");
 			return;
 		}
 	} else {
@@ -1065,28 +1102,11 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
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
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+			     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, src_mci,
+			     page, offset, syndrome,
+			     -1, -1, -1, csrow, channel,
+			     EDAC_MOD_STR, "");
 }
 
 static int ddr2_cs_size(unsigned i, bool dct_width)
@@ -1567,16 +1587,22 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 page, offset;
 	int nid, csrow, chan = 0;
+	enum hw_event_error_scope scope;
+
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
 
 	csrow = f1x_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
 
 	if (csrow < 0) {
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a csrow");
 		return;
 	}
 
-	error_address_to_page_and_offset(sys_addr, &page, &offset);
-
 	/*
 	 * We need the syndromes for channel detection only when we're
 	 * ganged. Otherwise @chan should already contain the channel at
@@ -1585,16 +1611,22 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	if (dct_ganging_enabled(pvt))
 		chan = get_channel_from_ecc_syndrome(mci, syndrome);
 
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				HW_EVENT_SCOPE_MC, mci,
+				page, offset, syndrome,
+				-1, -1, -1, -1, -1,
+				EDAC_MOD_STR,
+				"failed to map error addr to a csrow");
 	if (chan >= 0)
-		edac_mc_handle_ce(mci, page, offset, syndrome, csrow, chan,
-				  EDAC_MOD_STR);
+		scope = HW_EVENT_SCOPE_MC_CSROW_CHANNEL;
 	else
-		/*
-		 * Channel unknown, report all channels on this CSROW as failed.
-		 */
-		for (chan = 0; chan < mci->csrows[csrow].nr_channels; chan++)
-			edac_mc_handle_ce(mci, page, offset, syndrome,
-					  csrow, chan, EDAC_MOD_STR);
+		scope = HW_EVENT_SCOPE_MC_CSROW;
+
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				HW_EVENT_SCOPE_MC, mci,
+				page, offset, syndrome,
+				-1, -1, -1, csrow, chan,
+				EDAC_MOD_STR, "");
 }
 
 /*
@@ -1875,7 +1907,12 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 	/* Ensure that the Error Address is VALID */
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC, mci,
+				     0, 0, 0,
+				     -1, -1, -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "HW has no ERROR_ADDRESS available");
 		return;
 	}
 
@@ -1899,11 +1936,17 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC, mci,
+				     0, 0, 0,
+				     -1, -1, -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "HW has no ERROR_ADDRESS available");
 		return;
 	}
 
 	sys_addr = get_error_address(m);
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
 
 	/*
 	 * Find out which node the error address belongs to. This may be
@@ -1913,7 +1956,12 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (!src_mci) {
 		amd64_mc_err(mci, "ERROR ADDRESS (0x%lx) NOT mapped to a MC\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC, mci,
+				     page, offset, 0,
+				     -1, -1, -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "ERROR ADDRESS NOT mapped to a MC");
 		return;
 	}
 
@@ -1923,10 +1971,18 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (csrow < 0) {
 		amd64_mc_err(mci, "ERROR_ADDRESS (0x%lx) NOT mapped to CS\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC, mci,
+				     page, offset, 0,
+				     -1, -1, -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "ERROR ADDRESS NOT mapped to CS");
 	} else {
-		error_address_to_page_and_offset(sys_addr, &page, &offset);
-		edac_mc_handle_ue(log_mci, page, offset, csrow, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW, mci,
+				     page, offset, 0,
+				     -1, -1, -1, csrow, -1,
+				     EDAC_MOD_STR, "");
 	}
 }
 
@@ -2520,7 +2576,10 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 		goto err_siblings;
 
 	ret = -ENOMEM;
-	mci = edac_mc_alloc(0, pvt->csels[0].b_cnt, pvt->channel_count, nid);
+	/* FIXME: Assuming one DIMM per csrow channel */
+	mci = edac_mc_alloc(nid, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    0, 0, pvt->csels[0].b_cnt * pvt->channel_count,
+			    pvt->csels[0].b_cnt, pvt->channel_count, nid);
 	if (!mci)
 		goto err_siblings;
 
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index 1532750..7e6bbf8 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -29,7 +29,6 @@
 	edac_mc_chipset_printk(mci, level, "amd76x", fmt, ##arg)
 
 #define AMD76X_NR_CSROWS 8
-#define AMD76X_NR_CHANS  1
 #define AMD76X_NR_DIMMS  4
 
 /* AMD 76x register addresses - device 0 function 0 - PCI bridge */
@@ -146,8 +145,12 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors) {
 			row = (info->ecc_mode_status >> 4) & 0xf;
-			edac_mc_handle_ue(mci, mci->csrows[row].first_page, 0,
-					row, mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
+					     mci, mci->csrows[row].first_page,
+					     0, 0,
+					     -1, -1, row, row, 0,
+					     mci->ctl_name, "");
 		}
 	}
 
@@ -159,8 +162,12 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors) {
 			row = info->ecc_mode_status & 0xf;
-			edac_mc_handle_ce(mci, mci->csrows[row].first_page, 0,
-					0, row, 0, mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
+					     mci, mci->csrows[row].first_page,
+					     0, 0,
+					     -1, -1, row, row, 0,
+					     mci->ctl_name, "");
 		}
 	}
 
@@ -190,7 +197,7 @@ static void amd76x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	u32 mba, mba_base, mba_mask, dms;
 	int index;
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 		dimm = csrow->channels[0].dimm;
 
@@ -240,11 +247,11 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	debugf0("%s()\n", __func__);
 	pci_read_config_dword(pdev, AMD76X_ECC_MODE_STATUS, &ems);
 	ems_mode = (ems >> 10) & 0x3;
-	mci = edac_mc_alloc(0, AMD76X_NR_CSROWS, AMD76X_NR_CHANS, 0);
-
-	if (mci == NULL) {
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_MCCHANNEL_IS_CSROW,
+			    0, 0, AMD76X_NR_CSROWS,
+			    AMD76X_NR_CSROWS, 1, 0);
+	if (mci == NULL)
 		return -ENOMEM;
-	}
 
 	debugf0("%s(): mci = %p\n", __func__, mci);
 	mci->dev = &pdev->dev;
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index 09e1b5d..abe06a4 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -48,8 +48,11 @@ static void cell_edac_count_ce(struct mem_ctl_info *mci, int chan, u64 ar)
 	syndrome = (ar & 0x000000001fe00000ul) >> 21;
 
 	/* TODO: Decoding of the error address */
-	edac_mc_handle_ce(mci, csrow->first_page + pfn, offset,
-			  syndrome, 0, chan, "");
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				csrow->first_page + pfn, offset, syndrome,
+				-1, -1, -1, 0, chan,
+				"", "");
 }
 
 static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
@@ -69,7 +72,11 @@ static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
 	offset = address & ~PAGE_MASK;
 
 	/* TODO: Decoding of the error address */
-	edac_mc_handle_ue(mci, csrow->first_page + pfn, offset, 0, "");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				csrow->first_page + pfn, offset, 0,
+				-1, -1, -1, 0, chan,
+				"", "");
 }
 
 static void cell_edac_check(struct mem_ctl_info *mci)
@@ -167,7 +174,7 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 	struct mem_ctl_info		*mci;
 	struct cell_edac_priv		*priv;
 	u64				reg;
-	int				rc, chanmask;
+	int				rc, chanmask, num_chans;
 
 	regs = cbe_get_cpu_mic_tm_regs(cbe_node_to_cpu(pdev->id));
 	if (regs == NULL)
@@ -192,8 +199,10 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 		in_be64(&regs->mic_fir));
 
 	/* Allocate & init EDAC MC data structure */
-	mci = edac_mc_alloc(sizeof(struct cell_edac_priv), 1,
-			    chanmask == 3 ? 2 : 1, pdev->id);
+	num_chans = chanmask == 3 ? 2 : 1;
+	mci = edac_mc_alloc(pdev->id, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    0, 0, num_chans,
+			    1, num_chans, sizeof(struct cell_edac_priv));
 	if (mci == NULL)
 		return -ENOMEM;
 	priv = mci->pvt_info;
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 7b764a8..4a25b92 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -336,7 +336,7 @@ static void cpc925_init_csrows(struct mem_ctl_info *mci)
 
 	get_total_mem(pdata);
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		mbmr = __raw_readl(pdata->vbase + REG_MBMR_OFFSET +
 				   0x20 * index);
 		mbbar = __raw_readl(pdata->vbase + REG_MBBAR_OFFSET +
@@ -555,13 +555,20 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 	if (apiexcp & CECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM CECC Fault\n");
 		channel = cpc925_mc_find_channel(mci, syndrome);
-		edac_mc_handle_ce(mci, pfn, offset, syndrome,
-				  csrow, channel, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				     pfn, offset, syndrome,
+				     -1, -1, -1, csrow, channel,
+				     mci->ctl_name, "");
 	}
 
 	if (apiexcp & UECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM UECC Fault\n");
-		edac_mc_handle_ue(mci, pfn, offset, csrow, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW, mci,
+				     pfn, offset, 0,
+				     -1, -1, -1, csrow, -1,
+				     mci->ctl_name, "");
 	}
 
 	cpc925_mc_printk(mci, KERN_INFO, "Dump registers:\n");
@@ -969,8 +976,10 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	}
 
 	nr_channels = cpc925_mc_get_channels(vbase) + 1;
-	mci = edac_mc_alloc(sizeof(struct cpc925_mc_pdata),
-			CPC925_NR_CSROWS, nr_channels, edac_mc_idx);
+	mci = edac_mc_alloc(edac_mc_idx, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    0, 0, CPC925_NR_CSROWS * nr_channels,
+			    CPC925_NR_CSROWS, nr_channels,
+			    sizeof(struct cpc925_mc_pdata));
 	if (!mci) {
 		cpc925_printk(KERN_ERR, "No memory for mem_ctl_info\n");
 		res = -ENOMEM;
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 310f657..813d965 100644
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
@@ -350,8 +353,11 @@ static void do_process_ce(struct mem_ctl_info *mci, u16 error_one,
 	channel = !(error_one & 1);
 
 	/* e752x mc reads 34:6 of the DRAM linear address */
-	edac_mc_handle_ce(mci, page, offset_in_page(sec1_add << 4),
-			sec1_syndrome, row, channel, "e752x CE");
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+			     HW_EVENT_SCOPE_MC, mci,
+			     page, offset_in_page(sec1_add << 4), sec1_syndrome,
+			     -1, -1, -1, row, channel,
+			     "e752x CE", "");
 }
 
 static inline void process_ce(struct mem_ctl_info *mci, u16 error_one,
@@ -385,9 +391,13 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
-		edac_mc_handle_ue(mci, block_page,
-				offset_in_page(error_2b << 4),
-				row, "e752x UE from Read");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+					HW_EVENT_SCOPE_MC_CSROW, mci,
+					block_page,
+					offset_in_page(error_2b << 4), 0,
+					-1, -1, -1, row, -1,
+					"e752x UE from Read", "");
+
 	}
 	if (error_one & 0x0404) {
 		error_2b = scrb_add;
@@ -401,9 +411,12 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
-		edac_mc_handle_ue(mci, block_page,
-				offset_in_page(error_2b << 4),
-				row, "e752x UE from Scruber");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+					HW_EVENT_SCOPE_MC_CSROW, mci,
+					block_page,
+					offset_in_page(error_2b << 4), 0,
+					-1, -1, -1, row, -1,
+					"e752x UE from Scruber", "");
 	}
 }
 
@@ -426,7 +439,10 @@ static inline void process_ue_no_info_wr(struct mem_ctl_info *mci,
 		return;
 
 	debugf3("%s()\n", __func__);
-	edac_mc_handle_ue_no_info(mci, "e752x UE log memory write");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+			     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
+			     -1, -1, -1, -1, -1,
+			     "e752x UE log memory write", "");
 }
 
 static void do_process_ded_retry(struct mem_ctl_info *mci, u16 error,
@@ -1062,7 +1078,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	 * channel operation).  DRB regs are cumulative; therefore DRB7 will
 	 * contain the total memory contained in all eight rows.
 	 */
-	for (last_cumul_size = index = 0; index < mci->nr_csrows; index++) {
+	for (last_cumul_size = index = 0; index < mci->num_csrows; index++) {
 		/* mem_dev 0=x8, 1=x4 */
 		mem_dev = (dra >> (index * 4 + 2)) & 0x3;
 		csrow = &mci->csrows[remap_csrow_index(mci, index)];
@@ -1258,7 +1274,9 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	/* Dual channel = 1, Single channel = 0 */
 	drc_chan = dual_channel_active(ddrcsr);
 
-	mci = edac_mc_alloc(sizeof(*pvt), E752X_NR_CSROWS, drc_chan + 1, 0);
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    0, 0, E752X_NR_CSROWS * (drc_chan + 1),
+			    E752X_NR_CSROWS, drc_chan + 1, sizeof(*pvt));
 
 	if (mci == NULL) {
 		return -ENOMEM;
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 2005d80..01f64d3 100644
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
@@ -216,13 +219,20 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	row = edac_mc_find_csrow_by_page(mci, page);
 	/* convert syndrome to channel */
 	channel = e7xxx_find_channel(syndrome);
-	edac_mc_handle_ce(mci, page, 0, syndrome, row, channel, "e7xxx CE");
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+			     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+			     page, 0, syndrome,
+			     -1, -1, -1, row, channel,
+			     "e7xxx CE", "");
 }
 
 static void process_ce_no_info(struct mem_ctl_info *mci)
 {
 	debugf3("%s()\n", __func__);
-	edac_mc_handle_ce_no_info(mci, "e7xxx CE log register overflow");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+			     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
+			     -1, -1, -1, -1, -1,
+			     "e7xxx CE log register overflow", "");
 }
 
 static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
@@ -236,13 +246,21 @@ static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	/* FIXME - should use PAGE_SHIFT */
 	block_page = error_2b >> 6;	/* convert to 4k address */
 	row = edac_mc_find_csrow_by_page(mci, block_page);
-	edac_mc_handle_ue(mci, block_page, 0, row, "e7xxx UE");
+
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+			     HW_EVENT_SCOPE_MC_CSROW, mci, block_page, 0, 0,
+			     -1, -1, -1, row, -1,
+			     "e7xxx UE", "");
 }
 
 static void process_ue_no_info(struct mem_ctl_info *mci)
 {
 	debugf3("%s()\n", __func__);
-	edac_mc_handle_ue_no_info(mci, "e7xxx UE log register overflow");
+
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+			     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
+			     -1, -1, -1, -1, -1,
+			     "e7xxx UE log register overflow", "");
 }
 
 static void e7xxx_get_error_info(struct mem_ctl_info *mci,
@@ -365,7 +383,7 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	 * channel operation).  DRB regs are cumulative; therefore DRB7 will
 	 * contain the total memory contained in all eight rows.
 	 */
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		/* mem_dev 0=x8, 1=x4 */
 		mem_dev = (dra >> (index * 4 + 3)) & 0x1;
 		csrow = &mci->csrows[index];
@@ -423,7 +441,17 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	pci_read_config_dword(pdev, E7XXX_DRC, &drc);
 
 	drc_chan = dual_channel_active(drc, dev_idx);
-	mci = edac_mc_alloc(sizeof(*pvt), E7XXX_NR_CSROWS, drc_chan + 1, 0);
+	/*
+	 * According with the datasheet, this device has a maximum of
+	 * 4 DIMMS per channel, either single-rank or dual-rank. So, the
+	 * total amount of dimms is 8 (E7XXX_NR_DIMMS).
+	 * That means that the DIMM is mapped as CSROWs, and the channel
+	 * will map the rank. So, an error to either channel should be
+	 * attributed to the same dimm.
+	 */
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    0, 0, E7XXX_NR_DIMMS,
+			    E7XXX_NR_CSROWS, drc_chan + 1, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index fe90cd4..e4961fd 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -448,8 +448,36 @@ static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
 
 #endif				/* CONFIG_PCI */
 
-extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-					  unsigned nr_chans, int edac_index);
+/**
+ * enum edac_alloc_fill_strategy - Controls the way csrows/cschannels are mapped
+ * @EDAC_ALLOC_FILL_CSROW_CSCHANNEL:	csrows are rows, cschannels are channel.
+ *					This is the default and should be used
+ *					when the memory controller is able to
+ *					see csrows/cschannels. The dimms are
+ *					associated with cschannels.
+ * @EDAC_ALLOC_FILL_MCCHANNEL_IS_CSROW:	mc_branch/mc_channel are mapped as
+ *					cschannel. DIMMs inside each channel are
+ *					mapped as csrows. Most FBDIMMs drivers
+ *					use this model.
+ *@EDAC_ALLOC_FILL_PRIV:		The driver uses its own mapping model.
+ *					So, the core will leave the csrows
+ *					struct unitialized, leaving to the
+ *					driver the task of filling it.
+ */
+enum edac_alloc_fill_strategy {
+	EDAC_ALLOC_FILL_CSROW_CSCHANNEL = 0,
+	EDAC_ALLOC_FILL_MCCHANNEL_IS_CSROW,
+	EDAC_ALLOC_FILL_PRIV,
+};
+
+struct mem_ctl_info *edac_mc_alloc(int edac_index,
+				   enum edac_alloc_fill_strategy fill_strategy,
+				   unsigned num_branch,
+				   unsigned num_channel,
+				   unsigned num_dimm,
+				   unsigned nr_csrows,
+				   unsigned num_cschans,
+				   unsigned sz_pvt);
 extern int edac_mc_add_mc(struct mem_ctl_info *mci);
 extern void edac_mc_free(struct mem_ctl_info *mci);
 extern struct mem_ctl_info *edac_mc_find(int idx);
@@ -457,35 +485,19 @@ extern struct mem_ctl_info *find_mci_by_dev(struct device *dev);
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
+void edac_mc_handle_error(enum hw_event_mc_err_type type,
+			  enum hw_event_error_scope scope,
+			  struct mem_ctl_info *mci,
+			  unsigned long page_frame_number,
+			  unsigned long offset_in_page,
+			  unsigned long syndrome,
+			  int mc_branch,
+			  int mc_channel,
+			  int mc_dimm_number,
+			  int csrow,
+			  int cschannel,
+			  const char *msg,
+			  const char *other_detail);
 
 /*
  * edac_device APIs
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
index ee3f0f8..55760bc 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -48,10 +48,20 @@ static void edac_mc_dump_channel(struct csrow_channel_info *chan)
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
+	debugf4("\tdimm = %p\n", dimm);
+	debugf4("\tdimm->label = '%s'\n", dimm->label);
+	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
+	debugf4("\tdimm location %d.%d.%d.%d.%d\n",
+		dimm->mc_branch, dimm->mc_channel,
+		dimm->mc_dimm_number,
+		dimm->csrow, dimm->cschannel);
+	debugf4("\tdimm->grain = %d\n", dimm->grain);
+	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
 }
 
 static void edac_mc_dump_csrow(struct csrow_info *csrow)
@@ -73,8 +83,10 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
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
@@ -113,9 +125,12 @@ EXPORT_SYMBOL_GPL(edac_mem_types);
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
@@ -137,14 +152,60 @@ void *edac_align_ptr(void *ptr, unsigned size)
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
+ * @fill_strategy:	csrow/cschannel filling strategy
+ * @num_branch:		Number of memory controller branches
+ * @num_channel:	Number of memory controller channels
+ * @num_dimm:		Number of dimms per memory controller channel
+ * @num_csrows:		Number of CWROWS accessed via the memory controller
+ * @num_cschannel:	Number of csrows channels
+ * @size_pvt:		size of private storage needed
+ *
+ * This routine supports 3 modes of DIMM mapping:
+ *	1) the ones that accesses DRAM's via some bus interface (FB-DIMM
+ * and RAMBUS memory controllers) or that don't have chip select view
+ *
+ * In this case, a branch is generally a group of 2 channels, used generally
+ * in  parallel to provide 128 bits data.
+ *
+ * In the case of FB-DIMMs, the dimm is addressed via the SPD Address
+ * input selection, used by the AMB to select the DIMM. The MC channel
+ * corresponds to the Memory controller channel bus used to see a series
+ * of FB-DIMM's.
+ *
+ * num_branch, num_channel and num_dimm should point to the real
+ *	parameters of the memory controller.
+ *
+ * The total number of dimms is num_branch * num_channel * num_dimm
+ *
+ * According with JEDEC No. 205, up to 8 FB-DIMMs are possible per channel. Of
+ * course, controllers may have a lower limit.
+ *
+ * num_csrows/num_cschannel should point to the emulated parameters.
+ * The total number of cschannels (num_csrows * num_cschannel) should be a
+ * multiple of the total number dimms, e. g:
+ *  factor = (num_csrows * num_cschannel)/(num_branch * num_channel * num_dimm)
+ * should be an integer (typically: it is 1 or num_cschannel)
+ *
+ *	2) The MC uses CSROWS/CS CHANNELS to directly select a DRAM chip.
+ * One dimm chip exists on every cs channel, for single-rank memories.
+ *	num_branch and num_channel should be 0
+ *	num_dimm should be the total number of dimms
+ *	num_csrows * num_cschannel should be equal to num_dimm
+ *
+ *	3)The MC uses CSROWS/CS CHANNELS. One dimm chip exists on every
+ * csrow. The cs channel is used to indicate the defective chip(s) inside
+ * the memory stick.
+ *	num_branch and num_channel should be 0
+ *	num_dimm should be the total number of dimms
+ *	num_csrows should be equal to num_dimm
  *
  * Everything is kmalloc'ed as one big chunk - more efficient.
  * Only can be used if all structures have the same lifetime - otherwise
@@ -156,30 +217,87 @@ void *edac_align_ptr(void *ptr, unsigned size)
  *	NULL allocation failed
  *	struct mem_ctl_info pointer
  */
-struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-				unsigned nr_chans, int edac_index)
+struct mem_ctl_info *edac_mc_alloc(int edac_index,
+				   enum edac_alloc_fill_strategy fill_strategy,
+				   unsigned num_branch,
+				   unsigned num_channel,
+				   unsigned num_dimm,
+				   unsigned num_csrows,
+				   unsigned num_cschannel,
+				   unsigned sz_pvt)
 {
+	void *ptr;
 	struct mem_ctl_info *mci;
-	struct csrow_info *csi, *csrow;
+	struct csrow_info *csi, *csr;
 	struct csrow_channel_info *chi, *chp, *chan;
 	struct dimm_info *dimm;
+	u32 *ce_branch, *ce_channel, *ce_dimm, *ce_csrow, *ce_cschannel;
+	u32 *ue_branch, *ue_channel, *ue_dimm, *ue_csrow, *ue_cschannel;
 	void *pvt;
-	unsigned size;
-	int row, chn;
+	unsigned size, tot_dimms, count, dimm_div;
+	int i;
 	int err;
+	int mc_branch, mc_channel, mc_dimm_number, csrow, cschannel;
+	int row, chn;
+
+	/*
+	 * While we expect that non-pertinent values will be filled with
+	 * 0, in order to provide a way for this routine to detect if the
+	 * EDAC is emulating the old sysfs API, we can't actually accept
+	 * 0, as otherwise, a multiply by 0 whould hapen.
+	 */
+	if (num_branch <= 0)
+		num_branch = 1;
+	if (num_channel <= 0)
+		num_channel = 1;
+	if (num_dimm <= 0)
+		num_dimm = 1;
+	if (num_csrows <= 0)
+		num_csrows = 1;
+	if (num_cschannel <= 0)
+		num_cschannel = 1;
+
+	tot_dimms = num_branch * num_channel * num_dimm;
+	dimm_div = (num_csrows * num_cschannel) / tot_dimms;
+	if (dimm_div == 0) {
+		printk(KERN_ERR "%s: dimm_div is wrong: tot_channels/tot_dimms = %d/%d < 1\n",
+			__func__, num_csrows * num_cschannel, tot_dimms);
+		dimm_div = 1;
+	}
+	/* FIXME: change it to debug2() at the final version */
 
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
+	ptr = NULL;
+	mci = edac_align_ptr(&ptr, sizeof(*mci), 1);
+	csi = edac_align_ptr(&ptr, sizeof(*csi), num_csrows);
+	chi = edac_align_ptr(&ptr, sizeof(*chi), num_csrows * num_cschannel);
+	dimm = edac_align_ptr(&ptr, sizeof(*dimm), tot_dimms);
+
+	count = num_branch;
+	ue_branch = edac_align_ptr(&ptr, sizeof(*ce_branch), count);
+	ce_branch = edac_align_ptr(&ptr, sizeof(*ce_branch), count);
+	count *= num_channel;
+	ue_channel = edac_align_ptr(&ptr, sizeof(*ce_channel), count);
+	ce_channel = edac_align_ptr(&ptr, sizeof(*ce_channel), count);
+	count *= num_dimm;
+	ue_dimm = edac_align_ptr(&ptr, sizeof(*ce_dimm), count * num_dimm);
+	ce_dimm = edac_align_ptr(&ptr, sizeof(*ce_dimm), count * num_dimm);
+
+	count = num_csrows;
+	ue_csrow = edac_align_ptr(&ptr, sizeof(*ce_dimm), count);
+	ce_csrow = edac_align_ptr(&ptr, sizeof(*ce_dimm), count);
+	count *= num_cschannel;
+	ue_cschannel = edac_align_ptr(&ptr, sizeof(*ce_dimm), count);
+	ce_cschannel = edac_align_ptr(&ptr, sizeof(*ce_dimm), count);
+
+	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
 	size = ((unsigned long)pvt) + sz_pvt;
 
+	debugf1("%s(): allocating %u bytes for mci data\n", __func__, size);
 	mci = kzalloc(size, GFP_KERNEL);
 	if (mci == NULL)
 		return NULL;
@@ -197,41 +315,121 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	mci->csrows = csi;
 	mci->dimms  = dimm;
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
-
-		for (chn = 0; chn < nr_chans; chn++) {
-			chan = &chp[chn];
-			chan->chan_idx = chn;
-			chan->csrow = csrow;
+
+	mci->tot_dimms = tot_dimms;
+	mci->num_branch = num_branch;
+	mci->num_channel = num_channel;
+	mci->num_dimm = num_dimm;
+	mci->num_csrows = num_csrows;
+	mci->num_cschannel = num_cschannel;
+
+	/*
+	 * Fills the dimm struct
+	 */
+	mc_branch = (num_branch > 0) ? 0 : -1;
+	mc_channel = (num_channel > 0) ? 0 : -1;
+	mc_dimm_number = (num_dimm > 0) ? 0 : -1;
+	if (!num_channel && !num_branch) {
+		csrow = (num_csrows > 0) ? 0 : -1;
+		cschannel = (num_cschannel > 0) ? 0 : -1;
+	} else {
+		csrow = -1;
+		cschannel = -1;
+	}
+
+	debugf4("%s: initializing %d dimms\n", __func__, tot_dimms);
+	for (i = 0; i < tot_dimms; i++) {
+		dimm = &mci->dimms[i];
+
+		dimm->mc_branch = mc_branch;
+		dimm->mc_channel = mc_channel;
+		dimm->mc_dimm_number = mc_dimm_number;
+		dimm->csrow = csrow;
+		dimm->cschannel = cschannel;
+
+		/*
+		 * Increment the location
+		 * On csrow-emulated devices, csrow/cschannel should be -1
+		 */
+		if (!num_channel && !num_branch) {
+			if (num_cschannel) {
+				cschannel = (cschannel + 1) % num_cschannel;
+				if (cschannel)
+					continue;
+			}
+			if (num_csrows) {
+				csrow = (csrow + 1) % num_csrows;
+				if (csrow)
+					continue;
+			}
+		}
+		if (num_dimm) {
+			mc_dimm_number = (mc_dimm_number + 1) % num_dimm;
+			if (mc_dimm_number)
+				continue;
+		}
+		if (num_channel) {
+			mc_channel = (mc_channel + 1) % num_channel;
+			if (mc_channel)
+				continue;
+		}
+		if (num_branch) {
+			mc_branch = (mc_branch + 1) % num_branch;
+			if (mc_branch)
+				continue;
 		}
 	}
 
 	/*
-	 * By default, assumes that a per-csrow arrangement will be used,
-	 * as most drivers are based on such assumption.
+	 * Fills the csrows struct
+	 *
+	 * NOTE: there are two possible memory arrangements here:
+	 *
+	 *
 	 */
-	if (!mci->nr_dimms) {
-		dimm = mci->dimms;
-		for (row = 0; row < mci->nr_csrows; row++) {
-			for (chn = 0; chn < mci->csrows[row].nr_channels; chn++) {
-				mci->csrows[row].channels[chn].dimm = dimm;
-				dimm->mc_branch = -1;
-				dimm->mc_channel = -1;
-				dimm->mc_dimm_number = -1;
-				dimm->csrow = row;
-				dimm->csrow_channel = chn;
-				dimm++;
-				mci->nr_dimms++;
+	switch (fill_strategy) {
+	case EDAC_ALLOC_FILL_CSROW_CSCHANNEL:
+		for (row = 0; row < num_csrows; row++) {
+			csr = &csi[row];
+			csr->csrow_idx = row;
+			csr->mci = mci;
+			csr->nr_channels = num_cschannel;
+			chp = &chi[row * num_cschannel];
+			csr->channels = chp;
+
+			for (chn = 0; chn < num_cschannel; chn++) {
+				int dimm_idx = (chn + row * num_cschannel) /
+						dimm_div;
+				debugf4("%s: csrow(%d,%d) = dimm%d\n",
+					__func__, row, chn, dimm_idx);
+				chan = &chp[chn];
+				chan->chan_idx = chn;
+				chan->csrow = csr;
+				chan->dimm = &dimm[dimm_idx];
 			}
 		}
+	case EDAC_ALLOC_FILL_MCCHANNEL_IS_CSROW:
+		for (row = 0; row < num_csrows; row++) {
+			csr = &csi[row];
+			csr->csrow_idx = row;
+			csr->mci = mci;
+			csr->nr_channels = num_cschannel;
+			chp = &chi[row * num_cschannel];
+			csr->channels = chp;
+
+			for (chn = 0; chn < num_cschannel; chn++) {
+				int dimm_idx = (chn * num_cschannel + row) /
+						dimm_div;
+				debugf4("%s: csrow(%d,%d) = dimm%d\n",
+					__func__, row, chn, dimm_idx);
+				chan = &chp[chn];
+				chan->chan_idx = chn;
+				chan->csrow = csr;
+				chan->dimm = &dimm[dimm_idx];
+			}
+		}
+	case EDAC_ALLOC_FILL_PRIV:
+		break;
 	}
 
 	mci->op_state = OP_ALLOC;
@@ -522,7 +720,6 @@ EXPORT_SYMBOL(edac_mc_find);
  * edac_mc_add_mc: Insert the 'mci' structure into the mci global list and
  *                 create sysfs entries associated with mci structure
  * @mci: pointer to the mci structure to be added to the list
- * @mc_idx: A unique numeric identifier to be assigned to the 'mci' structure.
  *
  * Return:
  *	0	Success
@@ -540,13 +737,15 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 
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
@@ -671,7 +870,7 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 	debugf1("MC%d: %s(): 0x%lx\n", mci->mc_idx, __func__, page);
 	row = -1;
 
-	for (i = 0; i < mci->nr_csrows; i++) {
+	for (i = 0; i < mci->num_csrows; i++) {
 		struct csrow_info *csrow = &csrows[i];
 		n = 0;
 		for (j = 0; j < csrow->nr_channels; j++) {
@@ -704,312 +903,338 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 }
 EXPORT_SYMBOL_GPL(edac_mc_find_csrow_by_page);
 
-/* FIXME - setable log (warning/emerg) levels */
-/* FIXME - integrate with evlog: http://evlog.sourceforge.net/ */
-void edac_mc_handle_ce(struct mem_ctl_info *mci,
-		unsigned long page_frame_number,
-		unsigned long offset_in_page, unsigned long syndrome,
-		int row, int channel, const char *msg)
+void edac_increment_ce_error(enum hw_event_error_scope scope,
+			     struct mem_ctl_info *mci,
+			     int mc_branch,
+			     int mc_channel,
+			     int mc_dimm_number,
+			     int csrow,
+			     int cschannel)
 {
-	unsigned long remapped_page;
-	char detail[80], *label = NULL;
-	u32 grain;
+	int index;
 
-	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
+	mci->err.ce_mc++;
 
-	/* FIXME - maybe make panic on INTERNAL ERROR an option */
-	if (row >= mci->nr_csrows || row < 0) {
-		/* something is wrong */
-		trace_mc_out_of_range(mci, "CE", "row", row, 0, mci->nr_csrows);
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range "
-			"(%d >= %d)\n", row, mci->nr_csrows);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
+	if (scope == HW_EVENT_SCOPE_MC) {
+		mci->ce_noinfo_count = 0;
 		return;
 	}
 
-	if (channel >= mci->csrows[row].nr_channels || channel < 0) {
-		/* something is wrong */
-		trace_mc_out_of_range(mci, "CE", "channel", channel,
-				      0, mci->csrows[row].nr_channels);
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel out of range "
-			"(%d >= %d)\n", channel,
-			mci->csrows[row].nr_channels);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
-		return;
+	index = 0;
+	if (mc_branch >= 0) {
+		index = mc_branch;
+		mci->err.ce_branch[index]++;
 	}
+	if (scope == HW_EVENT_SCOPE_MC_BRANCH)
+		return;
+	index *= mci->num_branch;
 
-	label = mci->csrows[row].channels[channel].dimm->label;
-	grain = mci->csrows[row].channels[channel].dimm->grain;
-
-	/* Memory type dependent details about the error */
-	snprintf(detail, sizeof(detail),
-		 " (page 0x%lx, offset 0x%lx, grain %d, "
-		 "syndrome 0x%lx, row %d, channel %d)\n",
-		 page_frame_number, offset_in_page,
-		 grain, syndrome, row, channel);
-	trace_mc_error(HW_EVENT_ERR_CORRECTED, mci->mc_idx,
-		       label, msg, detail);
-
-	if (edac_mc_get_log_ce())
-		/* FIXME - put in DIMM location */
-		edac_mc_printk(mci, KERN_WARNING,
-			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
-			"0x%lx, row %d, channel %d, label \"%s\": %s\n",
-			page_frame_number, offset_in_page,
-			grain, syndrome, row, channel,
-			label, msg);
+	if (mc_channel >= 0) {
+		index += mc_channel;
+		mci->err.ce_channel[index]++;
+	}
+	if (scope == HW_EVENT_SCOPE_MC_CHANNEL)
+		return;
+	index *= mci->num_channel;
 
-	mci->ce_count++;
-	mci->csrows[row].ce_count++;
-	mci->csrows[row].channels[channel].dimm->ce_count++;
-	mci->csrows[row].channels[channel].ce_count++;
+	if (mc_dimm_number >= 0) {
+		index += mc_dimm_number;
+		mci->err.ce_dimm[index]++;
+	}
+	if (scope == HW_EVENT_SCOPE_MC_DIMM)
+		return;
+	index *= mci->num_dimm;
 
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
+	if (csrow >= 0) {
+		index += csrow;
+		mci->err.ce_csrow[csrow]++;
+	}
+	if (scope == HW_EVENT_SCOPE_MC_CSROW_CHANNEL)
+		return;
+	index *= mci->num_csrows;
 
-		edac_mc_scrub_block(remapped_page, offset_in_page, grain);
+	if (cschannel >= 0) {
+		index += cschannel;
+		mci->err.ce_cschannel[index]++;
 	}
 }
-EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
 
-void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci, const char *msg)
+void edac_increment_ue_error(enum hw_event_error_scope scope,
+			     struct mem_ctl_info *mci,
+			     int mc_branch,
+			     int mc_channel,
+			     int mc_dimm_number,
+			     int csrow,
+			     int cschannel)
 {
-	trace_mc_error(HW_EVENT_ERR_CORRECTED, mci->mc_idx,
-		       "unknown", msg, "");
-	if (edac_mc_get_log_ce())
-		edac_mc_printk(mci, KERN_WARNING,
-			"CE - no information available: %s\n", msg);
+	int index;
 
-	mci->ce_noinfo_count++;
-	mci->ce_count++;
-}
-EXPORT_SYMBOL_GPL(edac_mc_handle_ce_no_info);
+	mci->err.ue_mc++;
 
-void edac_mc_handle_ue(struct mem_ctl_info *mci,
-		unsigned long page_frame_number,
-		unsigned long offset_in_page, int row, const char *msg)
-{
-	int len = EDAC_MC_LABEL_LEN * 4;
-	char labels[len + 1];
-	char *pos = labels;
-	int chan;
-	int chars;
-	char detail[80], *label = NULL;
-	u32 grain;
-
-	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
-
-	/* FIXME - maybe make panic on INTERNAL ERROR an option */
-	if (row >= mci->nr_csrows || row < 0) {
-		/* something is wrong */
-		trace_mc_out_of_range(mci, "UE", "row", row,
-				      0, mci->nr_csrows);
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range "
-			"(%d >= %d)\n", row, mci->nr_csrows);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
+	if (scope == HW_EVENT_SCOPE_MC) {
+		mci->ue_noinfo_count = 0;
 		return;
 	}
 
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
+	index = 0;
+	if (mc_branch >= 0) {
+		index = mc_branch;
+		mci->err.ue_branch[index]++;
 	}
+	if (scope == HW_EVENT_SCOPE_MC_BRANCH)
+		return;
+	index *= mci->num_branch;
 
-	/* Memory type dependent details about the error */
-	snprintf(detail, sizeof(detail),
-		 "page 0x%lx, offset 0x%lx, grain %d, row %d ",
-		 page_frame_number, offset_in_page, grain, row);
-	trace_mc_error(HW_EVENT_ERR_UNCORRECTED, mci->mc_idx,
-		       labels,
-		       msg, detail);
-
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
+	if (mc_channel >= 0) {
+		index += mc_channel;
+		mci->err.ue_channel[index]++;
+	}
+	if (scope == HW_EVENT_SCOPE_MC_CHANNEL)
+		return;
+	index *= mci->num_channel;
 
-	mci->ue_count++;
-	mci->csrows[row].ue_count++;
-}
-EXPORT_SYMBOL_GPL(edac_mc_handle_ue);
+	if (mc_dimm_number >= 0) {
+		index += mc_dimm_number;
+		mci->err.ue_dimm[index]++;
+	}
+	if (scope == HW_EVENT_SCOPE_MC_DIMM)
+		return;
+	index *= mci->num_dimm;
 
-void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci, const char *msg)
-{
-	trace_mc_error(HW_EVENT_ERR_UNCORRECTED, mci->mc_idx,
-		       "unknown", msg, "");
-	if (edac_mc_get_panic_on_ue())
-		panic("EDAC MC%d: Uncorrected Error", mci->mc_idx);
+	if (csrow >= 0) {
+		index += csrow;
+		mci->err.ue_csrow[csrow]++;
+	}
+	if (scope == HW_EVENT_SCOPE_MC_CSROW_CHANNEL)
+		return;
+	index *= mci->num_csrows;
 
-	if (edac_mc_get_log_ue())
-		edac_mc_printk(mci, KERN_WARNING,
-			"UE - no information available: %s\n", msg);
-	mci->ue_noinfo_count++;
-	mci->ue_count++;
+	if (cschannel >= 0) {
+		index += cschannel;
+		mci->err.ue_cschannel[index]++;
+	}
 }
-EXPORT_SYMBOL_GPL(edac_mc_handle_ue_no_info);
 
-/*************************************************************
- * On Fully Buffered DIMM modules, this help function is
- * called to process UE events
- */
-void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
-			unsigned int csrow,
-			unsigned int channela,
-			unsigned int channelb, char *msg)
+void edac_mc_handle_error(enum hw_event_mc_err_type type,
+			  enum hw_event_error_scope scope,
+			  struct mem_ctl_info *mci,
+			  unsigned long page_frame_number,
+			  unsigned long offset_in_page,
+			  unsigned long syndrome,
+			  int mc_branch,
+			  int mc_channel,
+			  int mc_dimm_number,
+			  int csrow,
+			  int cschannel,
+			  const char *msg,
+			  const char *other_detail)
 {
-	int len = EDAC_MC_LABEL_LEN * 4;
-	char labels[len + 1];
-	char *pos = labels;
-	int chars;
-	char detail[80], *label;
+	unsigned long remapped_page;
+	/* FIXME: too much for stack. Move it to some pre-alocated area */
+	char detail[80 + strlen(other_detail)];
+	char label[(EDAC_MC_LABEL_LEN + 2) * mci->tot_dimms], *p;
+	char location[80];
+	int i;
+	u32 grain;
 
-	if (csrow >= mci->nr_csrows) {
-		/* something is wrong */
+	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
-		trace_mc_out_of_range(mci, "UE FBDIMM", "row", csrow,
-				      0, mci->nr_csrows);
+	/* Check if the event report is consistent */
+	if ((scope == HW_EVENT_SCOPE_MC_CSROW_CHANNEL) &&
+	    (cschannel >= mci->num_cschannel)) {
+		trace_mc_out_of_range(mci, "CE", "cs channel", cschannel,
+					0, mci->num_cschannel);
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range (%d >= %d)\n",
-			csrow, mci->nr_csrows);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
+				"INTERNAL ERROR: cs channel out of range (%d >= %d)\n",
+				cschannel, mci->num_cschannel);
+		if (type == HW_EVENT_ERR_CORRECTED)
+			mci->err.ce_mc++;
+		else
+			mci->err.ue_mc++;
 		return;
+	} else {
+		cschannel = -1;
 	}
 
-	if (channela >= mci->csrows[csrow].nr_channels) {
-		/* something is wrong */
-		trace_mc_out_of_range(mci, "UE FBDIMM", "channel-a", channela,
-				      0, mci->csrows[csrow].nr_channels);
+	if ((scope <= HW_EVENT_SCOPE_MC_CSROW) &&
+	    (csrow >= mci->num_csrows)) {
+		trace_mc_out_of_range(mci, "CE", "csrow", csrow,
+					0, mci->num_csrows);
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel-a out of range "
-			"(%d >= %d)\n",
-			channela, mci->csrows[csrow].nr_channels);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
+				"INTERNAL ERROR: csrow out of range (%d >= %d)\n",
+				csrow, mci->num_csrows);
+		if (type == HW_EVENT_ERR_CORRECTED)
+			mci->err.ce_mc++;
+		else
+			mci->err.ue_mc++;
 		return;
+	} else {
+		csrow = -1;
 	}
 
-	if (channelb >= mci->csrows[csrow].nr_channels) {
-		/* something is wrong */
-		trace_mc_out_of_range(mci, "UE FBDIMM", "channel-b", channelb,
-				      0, mci->csrows[csrow].nr_channels);
+	if ((scope <= HW_EVENT_SCOPE_MC_CSROW) &&
+	    (mc_dimm_number >= mci->num_dimm)) {
+		trace_mc_out_of_range(mci, "CE", "dimm_number",
+					mc_dimm_number, 0, mci->num_dimm);
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel-b out of range "
-			"(%d >= %d)\n",
-			channelb, mci->csrows[csrow].nr_channels);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
+				"INTERNAL ERROR: dimm_number out of range (%d >= %d)\n",
+				mc_dimm_number, mci->num_dimm);
+		if (type == HW_EVENT_ERR_CORRECTED)
+			mci->err.ce_mc++;
+		else
+			mci->err.ue_mc++;
 		return;
+	} else {
+		mc_dimm_number = -1;
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
-	/* Memory type dependent details about the error */
-	snprintf(detail, sizeof(detail),
-		 "row %d, channel-a= %d channel-b= %d ",
-		 csrow, channela, channelb);
-	trace_mc_error(HW_EVENT_ERR_UNCORRECTED, mci->mc_idx,
-		       labels,
-		       msg, detail);
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
-
-/*************************************************************
- * On Fully Buffered DIMM modules, this help function is
- * called to process CE events
- */
-void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
-			unsigned int csrow, unsigned int channel, char *msg)
-{
-	char detail[80], *label = NULL;
-	/* Ensure boundary values */
-	if (csrow >= mci->nr_csrows) {
-		/* something is wrong */
-		trace_mc_out_of_range(mci, "CE FBDIMM", "row", csrow,
-				      0, mci->nr_csrows);
+	if ((scope <= HW_EVENT_SCOPE_MC_CHANNEL) &&
+	    (mc_channel >= mci->num_dimm)) {
+		trace_mc_out_of_range(mci, "CE", "mc_channel",
+					mc_channel, 0, mci->num_dimm);
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range (%d >= %d)\n",
-			csrow, mci->nr_csrows);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
+				"INTERNAL ERROR: mc_channel out of range (%d >= %d)\n",
+				mc_channel, mci->num_dimm);
+		if (type == HW_EVENT_ERR_CORRECTED)
+			mci->err.ce_mc++;
+		else
+			mci->err.ue_mc++;
 		return;
+	} else {
+		mc_channel = -1;
 	}
-	if (channel >= mci->csrows[csrow].nr_channels) {
-		/* something is wrong */
-		trace_mc_out_of_range(mci, "UE FBDIMM", "channel", channel,
-				      0, mci->csrows[csrow].nr_channels);
+
+	if ((scope <= HW_EVENT_SCOPE_MC_BRANCH) &&
+	    (mc_branch >= mci->num_branch)) {
+		trace_mc_out_of_range(mci, "CE", "branch",
+					mc_branch, 0, mci->num_branch);
 		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel out of range (%d >= %d)\n",
-			channel, mci->csrows[csrow].nr_channels);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
+				"INTERNAL ERROR: mc_branch out of range (%d >= %d)\n",
+				mc_branch, mci->num_branch);
+		if (type == HW_EVENT_ERR_CORRECTED)
+			mci->err.ce_mc++;
+		else
+			mci->err.ue_mc++;
 		return;
+	} else {
+		mc_branch = -1;
 	}
 
-	/* Memory type dependent details about the error */
-	snprintf(detail, sizeof(detail),
-		 "(row %d, channel %d)\n",
-		 csrow, channel);
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
+	for (i = 0; i < mci->tot_dimms; i++) {
+		struct dimm_info *dimm = &mci->dimms[i];
 
-	label = mci->csrows[csrow].channels[channel].dimm->label;
+		if (mc_branch >= 0 && mc_branch != dimm->mc_branch)
+			continue;
 
-	trace_mc_error(HW_EVENT_ERR_CORRECTED, mci->mc_idx,
-		       label, msg, detail);
+		if (mc_channel >= 0 && mc_channel != dimm->mc_channel)
+			continue;
 
-	if (edac_mc_get_log_ce())
-		/* FIXME - put in DIMM location */
-		edac_mc_printk(mci, KERN_WARNING,
-			"CE row %d, channel %d, label \"%s\": %s\n",
-			csrow, channel, label, msg);
+		if (mc_dimm_number >= 0 &&
+		    mc_dimm_number != dimm->mc_dimm_number)
+			continue;
+
+		if (csrow >= 0 && csrow != dimm->csrow)
+			continue;
+		if (cschannel >= 0 && cschannel != dimm->cschannel)
+			continue;
+
+		if (dimm->grain > grain)
+			grain = dimm->grain;
+
+		strcpy(p, dimm->label);
+		p[strlen(p)] = ' ';
+		p = p + strlen(p);
+	}
+	p[strlen(p)] = '\0';
+
+	/* Fill the RAM location data */
+	p = location;
+	if (mc_branch >= 0)
+		p += sprintf(p, "branch %d ", mc_branch);
+
+	if (mc_channel >= 0)
+		p += sprintf(p, "channel %d ", mc_channel);
+
+	if (mc_dimm_number >= 0)
+		p += sprintf(p, "dimm %d ", mc_dimm_number);
 
-	mci->ce_count++;
-	mci->csrows[csrow].ce_count++;
-	mci->csrows[csrow].channels[channel].dimm->ce_count++;
-	mci->csrows[csrow].channels[channel].ce_count++;
+	if (csrow >= 0)
+		p += sprintf(p, "csrow %d ", csrow);
+
+	if (cschannel >= 0)
+		p += sprintf(p, "cs_channel %d ", cschannel);
+
+
+	/* Memory type dependent details about the error */
+	if (type == HW_EVENT_ERR_CORRECTED)
+		snprintf(detail, sizeof(detail),
+			"page 0x%lx offset 0x%lx grain %d syndrome 0x%lx\n",
+			page_frame_number, offset_in_page,
+			grain, syndrome);
+	else
+		snprintf(detail, sizeof(detail),
+			"page 0x%lx offset 0x%lx grain %d\n",
+			page_frame_number, offset_in_page, grain);
+
+	trace_mc_error(type, mci->mc_idx, msg, label, mc_branch, mc_channel,
+		       mc_dimm_number, csrow, cschannel,
+		       detail, other_detail);
+
+	if (type == HW_EVENT_ERR_CORRECTED) {
+		if (edac_mc_get_log_ce())
+			edac_mc_printk(mci, KERN_WARNING,
+				       "CE %s label \"%s\" (location: %d.%d.%d.%d.%d %s %s)\n",
+				       msg, label, mc_branch, mc_channel,
+				       mc_dimm_number, csrow, cschannel,
+				       detail, other_detail);
+		edac_increment_ce_error(scope, mci, mc_branch, mc_channel,
+					mc_dimm_number, csrow, cschannel);
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
+				"UE %s label \"%s\" (%s %s %s)\n",
+				msg, label, location, detail, other_detail);
+
+		if (edac_mc_get_panic_on_ue())
+			panic("UE %s label \"%s\" (%s %s %s)\n",
+			      msg, label, location, detail, other_detail);
+
+		edac_increment_ue_error(scope, mci, mc_branch, mc_channel,
+					mc_dimm_number, csrow, cschannel);
+	}
 }
-EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
+EXPORT_SYMBOL_GPL(edac_mc_handle_error);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 64b4c76..a6f611f 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -132,13 +132,17 @@ static const char *edac_caps[] = {
 static ssize_t csrow_ue_count_show(struct csrow_info *csrow, char *data,
 				int private)
 {
-	return sprintf(data, "%u\n", csrow->ue_count);
+	struct mem_ctl_info *mci = csrow->mci;
+
+	return sprintf(data, "%u\n", mci->err.ue_csrow[csrow->csrow_idx]);
 }
 
 static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data,
 				int private)
 {
-	return sprintf(data, "%u\n", csrow->ce_count);
+	struct mem_ctl_info *mci = csrow->mci;
+
+	return sprintf(data, "%u\n", mci->err.ce_csrow[csrow->csrow_idx]);
 }
 
 static ssize_t csrow_size_show(struct csrow_info *csrow, char *data,
@@ -205,7 +209,10 @@ static ssize_t channel_dimm_label_store(struct csrow_info *csrow,
 static ssize_t channel_ce_count_show(struct csrow_info *csrow,
 				char *data, int channel)
 {
-	return sprintf(data, "%u\n", csrow->channels[channel].ce_count);
+	struct mem_ctl_info *mci = csrow->mci;
+	int index = csrow->csrow_idx * mci->num_cschannel + channel;
+
+	return sprintf(data, "%u\n", mci->err.ce_cschannel[index]);
 }
 
 /* csrow specific attribute structure */
@@ -479,14 +486,14 @@ static ssize_t dimmdev_location_show(struct dimm_info *dimm, char *data)
 	if (dimm->mc_channel >= 0)
 		p += sprintf(p, "channel %d ", dimm->mc_channel);
 
+	if (dimm->mc_dimm_number >= 0)
+		p += sprintf(p, "dimm %d ", dimm->mc_dimm_number);
+
 	if (dimm->csrow >= 0)
 		p += sprintf(p, "csrow %d ", dimm->csrow);
 
-	if (dimm->csrow_channel >= 0)
-		p += sprintf(p, "cs_channel %d ", dimm->csrow_channel);
-
-	if (dimm->mc_dimm_number >= 0)
-		p += sprintf(p, "dimm %d ", dimm->mc_dimm_number);
+	if (dimm->cschannel >= 0)
+		p += sprintf(p, "cs_channel %d ", dimm->cschannel);
 
 	return p - data;
 }
@@ -614,22 +621,27 @@ err_out:
 static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 					const char *data, size_t count)
 {
-	int row, chan;
-
+	int num;
+	mci->err.ue_mc = 0;
+	mci->err.ce_mc = 0;
 	mci->ue_noinfo_count = 0;
 	mci->ce_noinfo_count = 0;
-	mci->ue_count = 0;
-	mci->ce_count = 0;
 
-	for (row = 0; row < mci->nr_csrows; row++) {
-		struct csrow_info *ri = &mci->csrows[row];
-
-		ri->ue_count = 0;
-		ri->ce_count = 0;
-
-		for (chan = 0; chan < ri->nr_channels; chan++)
-			ri->channels[chan].ce_count = 0;
-	}
+	num = mci->num_branch;
+	memset(mci->err.ue_branch, 0, num);
+	memset(mci->err.ce_branch, 0, num);
+	num *= mci->num_channel;
+	memset(mci->err.ue_channel, 0, num);
+	memset(mci->err.ce_channel, 0, num);
+	num *= mci->num_dimm;
+	memset(mci->err.ue_dimm, 0, num);
+	memset(mci->err.ce_dimm, 0, num);
+	num *= mci->num_csrows;
+	memset(mci->err.ue_csrow, 0, num);
+	memset(mci->err.ce_csrow, 0, num);
+	num *= mci->num_cschannel;
+	memset(mci->err.ue_cschannel, 0, num);
+	memset(mci->err.ce_cschannel, 0, num);
 
 	mci->start_time = jiffies;
 	return count;
@@ -688,12 +700,12 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
 /* default attribute files for the MCI object */
 static ssize_t mci_ue_count_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data, "%d\n", mci->ue_count);
+	return sprintf(data, "%d\n", mci->err.ue_mc);
 }
 
 static ssize_t mci_ce_count_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data, "%d\n", mci->ce_count);
+	return sprintf(data, "%d\n", mci->err.ce_mc);
 }
 
 static ssize_t mci_ce_noinfo_show(struct mem_ctl_info *mci, char *data)
@@ -720,7 +732,7 @@ static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data)
 {
 	int total_pages, csrow_idx, j;
 
-	for (total_pages = csrow_idx = 0; csrow_idx < mci->nr_csrows;
+	for (total_pages = csrow_idx = 0; csrow_idx < mci->num_csrows;
 	     csrow_idx++) {
 		struct csrow_info *csrow = &mci->csrows[csrow_idx];
 
@@ -1133,7 +1145,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	/* Make directories for each CSROW object under the mc<id> kobject
 	 */
-	for (i = 0; i < mci->nr_csrows; i++) {
+	for (i = 0; i < mci->num_csrows; i++) {
 		int n = 0;
 
 		csrow = &mci->csrows[i];
@@ -1155,11 +1167,17 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
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
+
+		debugf1("%s creating dimm%d, located at %d.%d.%d.%d.%d\n",
+			__func__, j, dimm->mc_branch, dimm->mc_channel,
+			dimm->mc_dimm_number, dimm->csrow, dimm->cschannel);
+
+		err = edac_create_dimm_object(mci, dimm, j);
 		if (err) {
 			debugf1("%s() failure: create dimm %d obj\n",
 				__func__, j);
@@ -1213,11 +1231,11 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 
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
index bf8a230..77c06af 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -245,7 +245,10 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & I3000_ERRSTS_BITS) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
+				     -1, -1, -1, -1, -1,
+				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
@@ -256,10 +259,18 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, pfn);
 
 	if (info->errsts & I3000_ERRSTS_UE)
-		edac_mc_handle_ue(mci, pfn, offset, row, "i3000 UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW, mci,
+				     pfn, offset, 0,
+				     -1, -1, -1, row, -1,
+				     "i3000 UE", "");
 	else
-		edac_mc_handle_ce(mci, pfn, offset, info->derrsyn, row,
-				multi_chan ? channel : 0, "i3000 CE");
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				     pfn, offset, info->derrsyn,
+				     -1, -1, -1, row,
+				     multi_chan ? channel : 0,
+				     "i3000 CE", "");
 
 	return 1;
 }
@@ -347,7 +358,11 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	interleaved = i3000_is_interleaved(c0dra, c1dra, c0drb, c1drb);
 	nr_channels = interleaved ? 2 : 1;
-	mci = edac_mc_alloc(0, I3000_RANKS / nr_channels, nr_channels, 0);
+
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    -1, -1, I3000_RANKS,
+			    I3000_RANKS / nr_channels, nr_channels,
+			    0);
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
index b3dc867..6f04a50 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -21,6 +21,7 @@
 
 #define PCI_DEVICE_ID_INTEL_3200_HB    0x29f0
 
+#define I3200_DIMMS		4
 #define I3200_RANKS		8
 #define I3200_RANKS_PER_CHANNEL	4
 #define I3200_CHANNELS		2
@@ -228,21 +229,29 @@ static void i3200_process_error_info(struct mem_ctl_info *mci,
 		return;
 
 	if ((info->errsts ^ info->errsts2) & I3200_ERRSTS_BITS) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
+				     -1, -1, -1, -1, -1,
+				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
 	for (channel = 0; channel < nr_channels; channel++) {
 		log = info->eccerrlog[channel];
 		if (log & I3200_ECCERRLOG_UE) {
-			edac_mc_handle_ue(mci, 0, 0,
-				eccerrlog_row(channel, log),
-				"i3200 UE");
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+					     HW_EVENT_SCOPE_MC_CSROW, mci,
+					     0, 0, 0,
+					     -1, -1, -1,
+					     eccerrlog_row(channel, log), -1,
+					     "i3000 UE", "");
 		} else if (log & I3200_ECCERRLOG_CE) {
-			edac_mc_handle_ce(mci, 0, 0,
-				eccerrlog_syndrome(log),
-				eccerrlog_row(channel, log), 0,
-				"i3200 CE");
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+					     HW_EVENT_SCOPE_MC_CSROW, mci,
+					     0, 0, eccerrlog_syndrome(log),
+					     -1, -1, -1,
+					     eccerrlog_row(channel, log), -1,
+					     "i3000 UE", "");
 		}
 	}
 }
@@ -346,8 +355,10 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	i3200_get_drbs(window, drbs);
 	nr_channels = how_many_channels(pdev);
 
-	mci = edac_mc_alloc(sizeof(struct i3200_priv), I3200_RANKS,
-		nr_channels, 0);
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    -1, -1, I3200_DIMMS,
+			    I3200_RANKS, nr_channels,
+			    0);
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
index e8d32e8..5fec235 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -533,13 +533,15 @@ static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
 
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
+	edac_mc_handle_error(HW_EVENT_ERR_FATAL,
+			     HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
+			     branch >> 1, -1, rank, -1, -1,
+			     rdwr ? "Write error" : "Read error",
+			     msg);
 }
 
 /*
@@ -633,13 +635,15 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 
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
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
+				channel >> 1, -1, rank, -1, -1,
+				rdwr ? "Write error" : "Read error",
+				msg);
 	}
 
 	/* Check correctable errors */
@@ -685,13 +689,17 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
-			 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d "
+			 "Rank=%d Bank=%d RDWR=%s RAS=%d "
 			 "CAS=%d, CE Err=0x%x (%s))", branch >> 1, bank,
 			 rdwr ? "Write" : "Read", ras, cas, ce_errors,
 			 specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_fbd_ce(mci, rank, channel, msg);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				HW_EVENT_SCOPE_MC_CHANNEL, mci, 0, 0, 0,
+				channel >> 1, channel % 2, rank, -1, -1,
+				rdwr ? "Write error" : "Read error",
+				msg);
 	}
 
 	if (!misc_messages)
@@ -731,11 +739,13 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
-			 "(Branch=%d Err=%#x (%s))", branch >> 1,
-			 misc_errors, specific);
+			 "Err=%#x (%s)", misc_errors, specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_fbd_ce(mci, 0, 0, msg);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
+				branch >> 1, -1, -1, -1, -1,
+				"Misc error", msg);
 	}
 }
 
@@ -1251,6 +1261,10 @@ static int i5000_init_csrows(struct mem_ctl_info *mci)
 
 	empty = 1;		/* Assume NO memory */
 
+	/*
+	 * TODO: it would be better to not use csrow here, filling
+	 * directly the dimm_info structs, based on branch, channel, dim number
+	 */
 	for (csrow = 0; csrow < max_csrows; csrow++) {
 		p_csrow = &mci->csrows[csrow];
 
@@ -1378,7 +1392,9 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 		__func__, num_channels, num_dimms_per_channel, num_csrows);
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    2, num_channels, num_dimms_per_channel,
+			    num_csrows, num_channels, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index f9baee3..24b03b8 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -410,14 +410,6 @@ static int i5100_csrow_to_chan(const struct mem_ctl_info *mci, int csrow)
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
@@ -427,21 +419,18 @@ static void i5100_handle_ce(struct mem_ctl_info *mci,
 			    unsigned ras,
 			    const char *msg)
 {
-	const int csrow = i5100_rank_to_csrow(mci, chan, rank);
-	char *label = NULL;
-
-	if (mci->csrows[csrow].channels[0].dimm)
-		label = mci->csrows[csrow].channels[0].dimm->label;
-
-	printk(KERN_ERR
-		"CE chan %d, bank %u, rank %u, syndrome 0x%lx, "
-		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
-		chan, bank, rank, syndrome, cas, ras,
-		csrow, label, msg);
-
-	mci->ce_count++;
-	mci->csrows[csrow].ce_count++;
-	mci->csrows[csrow].channels[0].ce_count++;
+	char detail[80];
+
+	/* Form out message */
+	snprintf(detail, sizeof(detail),
+		 "bank %u, cas %u, ras %u\n",
+		 bank, cas, ras);
+
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+			     HW_EVENT_SCOPE_MC_DIMM, mci,
+			     0, 0, syndrome,
+			     0, chan, rank, -1, -1,
+			     msg, detail);
 }
 
 static void i5100_handle_ue(struct mem_ctl_info *mci,
@@ -453,20 +442,18 @@ static void i5100_handle_ue(struct mem_ctl_info *mci,
 			    unsigned ras,
 			    const char *msg)
 {
-	const int csrow = i5100_rank_to_csrow(mci, chan, rank);
-	char *label = NULL;
-
-	if (mci->csrows[csrow].channels[0].dimm)
-		label = mci->csrows[csrow].channels[0].dimm->label;
-
-	printk(KERN_ERR
-		"UE chan %d, bank %u, rank %u, syndrome 0x%lx, "
-		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
-		chan, bank, rank, syndrome, cas, ras,
-		csrow, label, msg);
-
-	mci->ue_count++;
-	mci->csrows[csrow].ue_count++;
+	char detail[80];
+
+	/* Form out message */
+	snprintf(detail, sizeof(detail),
+		 "bank %u, cas %u, ras %u\n",
+		 bank, cas, ras);
+
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+			     HW_EVENT_SCOPE_MC_DIMM, mci,
+			     0, 0, syndrome,
+			     0, chan, rank, -1, -1,
+			     msg, detail);
 }
 
 static void i5100_read_log(struct mem_ctl_info *mci, int chan,
@@ -849,7 +836,7 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 	unsigned long total_pages = 0UL;
 	struct i5100_priv *priv = mci->pvt_info;
 
-	for (i = 0; i < mci->nr_dimms; i++) {
+	for (i = 0; i < mci->tot_dimms; i++) {
 		const unsigned long npages = i5100_npages(mci, i);
 		const unsigned chan = i5100_csrow_to_chan(mci, i);
 		const unsigned rank = i5100_csrow_to_rank(mci, i);
@@ -857,12 +844,6 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 
 		dimm->nr_pages = npages;
 
-		dimm->mc_branch = -1;
-		dimm->mc_channel = chan;
-		dimm->mc_dimm_number = rank;
-		dimm->csrow = -1;
-		dimm->csrow_channel = -1;
-
 		if (npages) {
 			total_pages += npages;
 
@@ -943,7 +924,9 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 		goto bail_ch1;
 	}
 
-	mci = edac_mc_alloc(sizeof(*priv), ranksperch * 2, 1, 0);
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    1, 2, ranksperch,
+			    ranksperch * 2, 1, sizeof(*priv));
 	if (!mci) {
 		ret = -ENOMEM;
 		goto bail_disable_ch1;
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 6b07450..c7455da 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -532,13 +532,15 @@ static void i5400_proccess_non_recoverable_info(struct mem_ctl_info *mci,
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
@@ -566,13 +568,14 @@ static void i5400_proccess_non_recoverable_info(struct mem_ctl_info *mci,
 
 	/* Form out message */
 	snprintf(msg, sizeof(msg),
-		 "%s (Branch=%d DRAM-Bank=%d Buffer ID = %d RDWR=%s "
-		 "RAS=%d CAS=%d %s Err=0x%lx (%s))",
-		 type, branch >> 1, bank, buf_id, rdwr_str(rdwr), ras, cas,
-		 type, allErrors, error_name[errnum]);
-
-	/* Call the helper to output message */
-	edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
+		 "Bank=%d Buffer ID = %d RAS=%d CAS=%d Err=0x%lx (%s)",
+		 bank, buf_id, ras, cas, allErrors, error_name[errnum]);
+
+	edac_mc_handle_error(tp_event,
+			     HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
+			     branch >> 1, -1, rank, -1, -1,
+			     rdwr ? "Write error" : "Read error",
+			     msg);
 }
 
 /*
@@ -642,8 +645,11 @@ static void i5400_process_nonfatal_error_info(struct mem_ctl_info *mci,
 			 branch >> 1, bank, rdwr_str(rdwr), ras, cas,
 			 allErrors, error_name[errnum]);
 
-		/* Call the helper to output message */
-		edac_mc_handle_fbd_ce(mci, rank, channel, msg);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
+				     branch >> 1, channel % 2, rank, -1, -1,
+				     rdwr ? "Write error" : "Read error",
+				     msg);
 
 		return;
 	}
@@ -1144,16 +1150,10 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 
 	empty = 1;		/* Assume NO memory */
 
-	for (slot = 0; slot < mci->nr_dimms; slot++) {
+	for (slot = 0; slot < mci->tot_dimms; slot++) {
 		struct dimm_info *dimm = &mci->dimms[slot];
 		channel = slot % pvt->maxch;
 
-		dimm->mc_branch = channel / 2;
-		dimm->mc_channel = channel % 2;
-		dimm->mc_dimm_number = slot / pvt->maxch;
-		dimm->csrow = -1;
-		dimm->csrow_channel = -1;
-
 		/* use branch 0 for the basis */
 		mtr = determine_mtr(pvt, slot, 0);
 
@@ -1239,7 +1239,9 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 		__func__, num_channels, num_dimms_per_channel, num_csrows);
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    2, num_channels, num_dimms_per_channel,
+			    num_csrows, num_channels, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 0838ec2..33f9ac2 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -464,17 +464,15 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
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
+		edac_mc_handle_error(HW_EVENT_ERR_FATAL,
+				     HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
+				     branch, -1, rank, -1, -1,
+				     is_wr ? "Write error" : "Read error",
+				     pvt->tmp_prt_buffer);
+
 	}
 
 	/* read in the 1st NON-FATAL error register */
@@ -513,23 +511,15 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 
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
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0,
+				     syndrome,
+				     branch >> 1, channel % 2, rank, -1, -1,
+				     is_wr ? "Write error" : "Read error",
+				     pvt->tmp_prt_buffer);
 	}
 	return;
 }
@@ -799,7 +789,7 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 
 	/* Get the set of MTR[0-7] regs by each branch */
 	dimm = mci->dimms;
-	mci->nr_dimms = 0;
+	mci->tot_dimms = 0;
 	for (slot = 0; slot < MAX_SLOTS; slot++) {
 		int where = mtr_regs[slot];
 		for (branch = 0; branch < MAX_BRANCHES; branch++) {
@@ -811,16 +801,10 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 
 				dinfo = &pvt->dimm_info[slot][channel];
 
-				dimm->mc_branch = branch;
-				dimm->mc_channel = ch;
-				dimm->mc_dimm_number = slot;
-				dimm->csrow = -1;
-				dimm->csrow_channel = -1;
-
 				mtr = decode_mtr(pvt, slot, ch, branch,
 						 dinfo, dimm);
 
-				mci->nr_dimms++;
+				mci->tot_dimms++;
 				dimm++;
 
 				/* if no DIMMS on this row, continue */
@@ -1078,7 +1062,10 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 		__func__, num_channels, num_dimms_per_channel, num_csrows);
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    MAX_BRANCHES, num_channels / MAX_BRANCHES,
+			    num_dimms_per_channel,
+			    num_csrows, num_channels, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index c6c649d..f63c0f4 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -598,7 +598,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	struct csrow_info *csr;
 	struct pci_dev *pdev;
 	int i, j;
-	int csrow = 0;
+	int csrow = 0, cschannel = 0;
 	enum edac_type mode;
 	enum mem_type mtype;
 
@@ -693,12 +693,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			u32 banks, ranks, rows, cols;
 			u32 size, npages;
 
-			dimm->mc_branch = -1;
-			dimm->mc_channel = i;
-			dimm->mc_dimm_number = j;
-			dimm->csrow = -1;
-			dimm->csrow_channel = -1;
-
 			if (!DIMM_PRESENT(dimm_dod[j]))
 				continue;
 
@@ -710,8 +704,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			/* DDR3 has 8 I/O banks */
 			size = (rows * cols * banks * ranks) >> (20 - 3);
 
-			pvt->channel[i].dimms++;
-
 			debugf0("\tdimm %d %d Mb offset: %x, "
 				"bank: %d, rank: %d, row: %#x, col: %#x\n",
 				j, size,
@@ -720,11 +712,16 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 
 			npages = MiB_TO_PAGES(size);
 
-			csr = &mci->csrows[csrow];
-			csr->channels[0].dimm = dimm;
-
 			pvt->csrow_map[i][j] = csrow;
 
+			csr = &mci->csrows[csrow];
+			csr->channels[cschannel].dimm = dimm;
+			cschannel++;
+			if (cschannel >= MAX_DIMMS) {
+				cschannel = 0;
+				csrow++;
+			}
+
 			dimm->nr_pages = npages;
 
 			switch (banks) {
@@ -766,6 +763,17 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 				(value[j] & ((1 << 24) - 1)));
 	}
 
+	/* Clears the unused data */
+	while (csrow < NUM_CHANS && cschannel < MAX_DIMMS) {
+		csr = &mci->csrows[csrow];
+		csr->channels[cschannel].dimm = NULL;
+		cschannel++;
+		if (cschannel >= MAX_DIMMS) {
+			cschannel = 0;
+			csrow++;
+		}
+	}
+
 	return 0;
 }
 
@@ -1568,17 +1576,14 @@ static void i7core_rdimm_update_csrow(struct mem_ctl_info *mci,
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
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_DIMM, mci,
+				     0, 0, 0,
+				     0, chan, dimm, -1, -1,
+				     "error", "");
 	}
 }
 
@@ -1744,7 +1749,10 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
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
@@ -1753,10 +1761,18 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 	u32 errnum = find_first_bit(&error, 32);
 	int csrow;
 
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
@@ -1811,25 +1827,26 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 		err = "unknown";
 	}
 
-	/* FIXME: should convert addr into bank and rank information */
 	msg = kasprintf(GFP_ATOMIC,
-		"%s (addr = 0x%08llx, cpu=%d, Dimm=%d, Channel=%d, "
-		"syndrome=0x%08x, count=%d, Err=%08llx:%08llx (%s: %s))\n",
-		type, (long long) m->addr, m->cpu, dimm, channel,
-		syndrome, core_err_cnt, (long long)m->status,
-		(long long)m->misc, optype, err);
-
-	debugf0("%s", msg);
+		"addr=0x%08llx cpu=%d count=%d Err=%08llx:%08llx (%s: %s))\n",
+		(long long) m->addr, m->cpu, core_err_cnt,
+		(long long)m->status, (long long)m->misc, optype, err);
 
 	csrow = pvt->csrow_map[channel][dimm];
 
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
+		edac_mc_handle_error(tp_event,
+				     HW_EVENT_SCOPE_MC_DIMM, mci,
+				     m->addr >> PAGE_SHIFT,
+				     m->addr & ~PAGE_MASK,
+				     syndrome,
+				     0, channel, dimm, -1, -1,
+				     err, msg);
 
 	kfree(msg);
 }
@@ -2256,7 +2273,10 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 		return rc;
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), csrows, channels, i7core_dev->socket);
+
+	mci = edac_mc_alloc(EDAC_ALLOC_FILL_PRIV, i7core_dev->socket,
+			    1, NUM_CHANS, MAX_DIMMS,
+			    MAX_DIMMS, NUM_CHANS, sizeof(*pvt));
 	if (unlikely(!mci))
 		return -ENOMEM;
 
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 74166ae..0992549 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -156,19 +156,23 @@ static int i82443bxgx_edacmc_process_error_info(struct mem_ctl_info *mci,
 	if (info->eap & I82443BXGX_EAP_OFFSET_SBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_ce(mci, page, pageoffset,
-				/* 440BX/GX don't make syndrome information
-				 * available */
-				0, edac_mc_find_csrow_by_page(mci, page), 0,
-				mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
+					     mci, page, pageoffset, 0,
+					     -1, -1, -1,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0, mci->ctl_name, 0);
 	}
 
 	if (info->eap & I82443BXGX_EAP_OFFSET_MBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_ue(mci, page, pageoffset,
-					edac_mc_find_csrow_by_page(mci, page),
-					mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
+					     mci, page, pageoffset, 0,
+					     -1, -1, -1,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0, mci->ctl_name, 0);
 	}
 
 	return error_found;
@@ -196,7 +200,7 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 
 	pci_read_config_byte(pdev, I82443BXGX_DRAMC, &dramc);
 	row_high_limit_last = 0;
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 		dimm = csrow->channels[0].dimm;
 
@@ -248,7 +252,9 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	if (pci_read_config_dword(pdev, I82443BXGX_NBXCFG, &nbxcfg))
 		return -EIO;
 
-	mci = edac_mc_alloc(0, I82443BXGX_NR_CSROWS, I82443BXGX_NR_CHANS, 0);
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    0, 0, I82443BXGX_NR_CSROWS,
+			    I82443BXGX_NR_CSROWS, I82443BXGX_NR_CHANS, 0);
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 48e0ecd..3ab8a7a 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -99,6 +99,7 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 				struct i82860_error_info *info,
 				int handle_errors)
 {
+	struct dimm_info *dimm;
 	int row;
 
 	if (!(info->errsts2 & 0x0003))
@@ -108,18 +109,31 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
+				     -1, -1, -1, -1, -1,
+				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
 	info->eap >>= PAGE_SHIFT;
 	row = edac_mc_find_csrow_by_page(mci, info->eap);
+	dimm = mci->csrows[row].channels[0].dimm;
 
 	if (info->errsts & 0x0002)
-		edac_mc_handle_ue(mci, info->eap, 0, row, "i82860 UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC_DIMM, mci,
+				     info->eap, 0, 0,
+				     dimm->mc_branch, dimm->mc_channel,
+				     dimm->mc_dimm_number, -1, -1,
+				     "i82860 UE", "");
 	else
-		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row, 0,
-				"i82860 UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC_DIMM, mci,
+				     info->eap, 0, info->derrsyn,
+				     dimm->mc_branch, dimm->mc_channel,
+				     dimm->mc_dimm_number, -1, -1,
+				     "i82860 CE", "");
 
 	return 1;
 }
@@ -152,7 +166,7 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 	 * cumulative; therefore GRA15 will contain the total memory contained
 	 * in all eight rows.
 	 */
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 		dimm = csrow->channels[0].dimm;
 
@@ -181,15 +195,21 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 	struct mem_ctl_info *mci;
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
+
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    1, 2 /* channels */, 8 /* sticks per channel */,
+			    16, 1,
+			    0);
 
 	if (!mci)
 		return -ENOMEM;
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index dc207dc..74afaba 100644
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
@@ -235,7 +236,10 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0081) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
+				     -1, -1, -1, -1, -1,
+				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
@@ -243,11 +247,18 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, info->eap);
 
 	if (info->errsts & 0x0080)
-		edac_mc_handle_ue(mci, info->eap, 0, row, "i82875p UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW, mci,
+				     info->eap, 0, 0,
+				     -1, -1, -1, row, -1,
+				     "i82875p UE", "");
 	else
-		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row,
-				multi_chan ? (info->des & 0x1) : 0,
-				"i82875p CE");
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				     info->eap, 0, info->derrsyn,
+				     -1, -1, -1, row,
+				     multi_chan ? (info->des & 0x1) : 0,
+				     "i82875p CE", "");
 
 	return 1;
 }
@@ -359,7 +370,7 @@ static void i82875p_init_csrows(struct mem_ctl_info *mci,
 	 * contain the total memory contained in all eight rows.
 	 */
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 
 		value = readb(ovrfl_window + I82875P_DRB + index);
@@ -405,9 +416,10 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENODEV;
 	drc = readl(ovrfl_window + I82875P_DRC);
 	nr_chans = dual_channel_active(drc) + 1;
-	mci = edac_mc_alloc(sizeof(*pvt), I82875P_NR_CSROWS(nr_chans),
-			nr_chans, 0);
-
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    -1, -1, I82875P_NR_DIMMS,
+			    I82875P_NR_CSROWS(nr_chans), nr_chans,
+			    sizeof(*pvt));
 	if (!mci) {
 		rc = -ENOMEM;
 		goto fail0;
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index d7dc455..33feeba 100644
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
@@ -289,7 +290,10 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
+				     -1, -1, -1, -1, -1,
+				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
@@ -303,11 +307,18 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, page);
 
 	if (info->errsts & 0x0002)
-		edac_mc_handle_ue(mci, page, offst , row, "i82975x UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW, mci,
+				     page, offst, 0,
+				     -1, -1, -1, row, -1,
+				     "i82975x UE", "");
 	else
-		edac_mc_handle_ce(mci, page, offst, info->derrsyn, row,
-				multi_chan ? chan : 0,
-				"i82975x CE");
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				     page, offst, info->derrsyn,
+				     -1, -1, -1, row,
+				     multi_chan ? chan : 0,
+				     "i82975x CE", "");
 
 	return 1;
 }
@@ -378,7 +389,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 	 *
 	 */
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 
 		value = readb(mch_window + I82975X_DRB + index +
@@ -533,8 +544,10 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	chans = dual_channel_active(mch_window) + 1;
 
 	/* assuming only one controller, index thus is 0 */
-	mci = edac_mc_alloc(sizeof(*pvt), I82975X_NR_CSROWS(chans),
-					chans, 0);
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    -1, -1, I82975X_NR_DIMMS,
+			    I82975X_NR_CSROWS(chans), chans,
+			    sizeof(*pvt));
 	if (!mci) {
 		rc = -ENOMEM;
 		goto fail1;
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index c1d9e15..f7c3a67 100644
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
@@ -850,16 +850,22 @@ static void mpc85xx_mc_check(struct mem_ctl_info *mci)
 	mpc85xx_mc_printk(mci, KERN_ERR, "PFN: %#8.8x\n", pfn);
 
 	/* we are out of range */
-	if (row_index == mci->nr_csrows)
+	if (row_index == mci->num_csrows)
 		mpc85xx_mc_printk(mci, KERN_ERR, "PFN out of range!\n");
 
 	if (err_detect & DDR_EDE_SBE)
-		edac_mc_handle_ce(mci, pfn, err_addr & ~PAGE_MASK,
-				  syndrome, row_index, 0, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				     pfn, err_addr & ~PAGE_MASK, syndrome,
+				     -1, -1, -1, row_index, 0,
+				     mci->ctl_name, "");
 
 	if (err_detect & DDR_EDE_MBE)
-		edac_mc_handle_ue(mci, pfn, err_addr & ~PAGE_MASK,
-				  row_index, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				     pfn, err_addr & ~PAGE_MASK, syndrome,
+				     -1, -1, -1, row_index, 0,
+				     mci->ctl_name, "");
 
 	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, err_detect);
 }
@@ -925,7 +931,7 @@ static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
 		}
 	}
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		u32 start;
 		u32 end;
 
@@ -969,7 +975,8 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	if (!devres_open_group(&op->dev, mpc85xx_mc_err_probe, GFP_KERNEL))
 		return -ENOMEM;
 
-	mci = edac_mc_alloc(sizeof(*pdata), 4, 1, edac_mc_idx);
+	mci = edac_mc_alloc(edac_mc_idx, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    0, 0, 4, 4, 1, sizeof(*pdata));
 	if (!mci) {
 		devres_release_group(&op->dev, mpc85xx_mc_err_probe);
 		return -ENOMEM;
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 281e245..96a675a 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -611,12 +611,19 @@ static void mv64x60_mc_check(struct mem_ctl_info *mci)
 
 	/* first bit clear in ECC Err Reg, 1 bit error, correctable by HW */
 	if (!(reg & 0x1))
-		edac_mc_handle_ce(mci, err_addr >> PAGE_SHIFT,
-				  err_addr & PAGE_MASK, syndrome, 0, 0,
-				  mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				     err_addr >> PAGE_SHIFT,
+				     err_addr & PAGE_MASK, syndrome,
+				     -1, -1, -1, 0, 0,
+				     mci->ctl_name, "");
 	else	/* 2 bit error, UE */
-		edac_mc_handle_ue(mci, err_addr >> PAGE_SHIFT,
-				  err_addr & PAGE_MASK, 0, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				     err_addr >> PAGE_SHIFT,
+				     err_addr & PAGE_MASK, 0,
+				     -1, -1, -1, 0, 0,
+				     mci->ctl_name, "");
 
 	/* clear the error */
 	out_le32(pdata->mc_vbase + MV64X60_SDRAM_ERR_ADDR, 0);
@@ -703,7 +710,9 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	if (!devres_open_group(&pdev->dev, mv64x60_mc_err_probe, GFP_KERNEL))
 		return -ENOMEM;
 
-	mci = edac_mc_alloc(sizeof(struct mv64x60_mc_pdata), 1, 1, edac_mc_idx);
+	mci = edac_mc_alloc(edac_mc_idx, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    0, 0, 1,
+			    1, 1, sizeof(struct mv64x60_mc_pdata));
 	if (!mci) {
 		printk(KERN_ERR "%s: No memory for CPU err\n", __func__);
 		devres_release_group(&pdev->dev, mv64x60_mc_err_probe);
diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index 3fcefda..0d0a545 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -110,15 +110,20 @@ static void pasemi_edac_process_error_info(struct mem_ctl_info *mci, u32 errsta)
 	/* uncorrectable/multi-bit errors */
 	if (errsta & (MCDEBUG_ERRSTA_MBE_STATUS |
 		      MCDEBUG_ERRSTA_RFL_STATUS)) {
-		edac_mc_handle_ue(mci, mci->csrows[cs].first_page, 0,
-				  cs, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				     mci->csrows[cs].first_page, 0, 0,
+				     -1, -1, -1, cs, 0,
+				     mci->ctl_name, "");
 	}
 
 	/* correctable/single-bit errors */
-	if (errsta & MCDEBUG_ERRSTA_SBE_STATUS) {
-		edac_mc_handle_ce(mci, mci->csrows[cs].first_page, 0,
-				  0, cs, 0, mci->ctl_name);
-	}
+	if (errsta & MCDEBUG_ERRSTA_SBE_STATUS)
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				     mci->csrows[cs].first_page, 0, 0,
+				     -1, -1, -1, cs, 0,
+				     mci->ctl_name, "");
 }
 
 static void pasemi_edac_check(struct mem_ctl_info *mci)
@@ -139,7 +144,7 @@ static int pasemi_edac_init_csrows(struct mem_ctl_info *mci,
 	u32 rankcfg;
 	int index;
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 		dimm = csrow->channels[0].dimm;
 
@@ -207,8 +212,9 @@ static int __devinit pasemi_edac_probe(struct pci_dev *pdev,
 		MCDEBUG_ERRCTL1_RFL_LOG_EN;
 	pci_write_config_dword(pdev, MCDEBUG_ERRCTL1, errctl1);
 
-	mci = edac_mc_alloc(0, PASEMI_EDAC_NR_CSROWS, PASEMI_EDAC_NR_CHANS,
-				system_mmc_id++);
+	mci = edac_mc_alloc(system_mmc_id++, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    0, 0, PASEMI_EDAC_NR_CSROWS,
+			    PASEMI_EDAC_NR_CSROWS, PASEMI_EDAC_NR_CHANS, 0);
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 1adaddf..2e393cb 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -214,7 +214,7 @@ static struct platform_driver ppc4xx_edac_driver = {
  * TODO: The row and channel parameters likely need to be dynamically
  * set based on the aforementioned variant controller realizations.
  */
-static const unsigned ppc4xx_edac_nr_csrows = 2;
+static const unsigned ppc4xx_edac_num_csrows = 2;
 static const unsigned ppc4xx_edac_nr_chans = 1;
 
 /*
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
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+					     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
+					     -1, -1, -1, -1, -1,
+					     message, "");
 }
 
 /**
@@ -753,9 +756,13 @@ ppc4xx_edac_handle_ue(struct mem_ctl_info *mci,
 
 	ppc4xx_edac_generate_message(mci, status, message, sizeof(message));
 
-	for (row = 0; row < mci->nr_csrows; row++)
+	for (row = 0; row < mci->num_csrows; row++)
 		if (ppc4xx_edac_check_bank_error(status, row))
-			edac_mc_handle_ue(mci, page, offset, row, message);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+					     HW_EVENT_SCOPE_MC, mci,
+					     page, offset, 0,
+					     -1, -1, -1, -1, -1,
+					     message, "");
 }
 
 /**
@@ -917,7 +924,7 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 	 * 1:1 with a controller bank/rank.
 	 */
 
-	for (row = 0; row < mci->nr_csrows; row++) {
+	for (row = 0; row < mci->num_csrows; row++) {
 		struct csrow_info *csi = &mci->csrows[row];
 
 		/*
@@ -1279,10 +1286,12 @@ static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 	 * initialization.
 	 */
 
-	mci = edac_mc_alloc(sizeof(struct ppc4xx_edac_pdata),
-			    ppc4xx_edac_nr_csrows,
+	mci = edac_mc_alloc(ppc4xx_edac_instance,
+			    EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    0, 0, ppc4xx_edac_num_csrows * ppc4xx_edac_nr_chans,
+			    ppc4xx_edac_num_csrows,
 			    ppc4xx_edac_nr_chans,
-			    ppc4xx_edac_instance);
+			    sizeof(struct ppc4xx_edac_pdata));
 
 	if (mci == NULL) {
 		ppc4xx_edac_printk(KERN_ERR, "%s: "
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index a4b0626..214bc48 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -179,10 +179,13 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 		error_found = 1;
 
 		if (handle_errors)
-			edac_mc_handle_ce(mci, page, 0,	/* not avail */
-					syndrome,
-					edac_mc_find_csrow_by_page(mci, page),
-					0, mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
+					     mci, page, 0, syndrome,
+					     -1, -1, -1,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0,
+					     mci->ctl_name, "");
 	}
 
 	if (info->eapr & BIT(1)) {	/* UE? */
@@ -190,9 +193,13 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors)
 			/* 82600 doesn't give enough info */
-			edac_mc_handle_ue(mci, page, 0,
-					edac_mc_find_csrow_by_page(mci, page),
-					mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
+					     mci, page, 0, 0,
+					     -1, -1, -1,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0,
+					     mci->ctl_name, "");
 	}
 
 	return error_found;
@@ -226,7 +233,7 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	reg_sdram = dramcr & BIT(4);
 	row_high_limit_last = 0;
 
-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < mci->num_csrows; index++) {
 		csrow = &mci->csrows[index];
 		dimm = csrow->channels[0].dimm;
 
@@ -281,7 +288,10 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	debugf2("%s(): sdram refresh rate = %#0x\n", __func__,
 		sdram_refresh_rate);
 	debugf2("%s(): DRAMC register = %#0x\n", __func__, dramcr);
-	mci = edac_mc_alloc(0, R82600_NR_CSROWS, R82600_NR_CHANS, 0);
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    -1, -1, R82600_NR_DIMMS,
+			    R82600_NR_CSROWS, R82600_NR_CHANS,
+			    0);
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 981262b..5df6ade 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -646,8 +646,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 
 				csr->channels[0].dimm = dimm;
 				dimm->nr_pages = npages;
-				dimm->mc_channel = i;
-				dimm->mc_dimm_number = j;
 				dimm->grain = 32;
 				dimm->dtype = (banks == 8) ? DEV_X8 : DEV_X4;
 				dimm->mtype = mtype;
@@ -834,11 +832,10 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
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
@@ -859,12 +856,10 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
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
 
@@ -881,7 +876,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		limit = SAD_LIMIT(reg);
 		if (limit <= prv) {
 			sprintf(msg, "Can't discover the memory socket");
-			edac_mc_handle_ce_no_info(mci, msg);
 			return -EINVAL;
 		}
 		if  (addr <= limit)
@@ -890,7 +884,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	}
 	if (n_sads == MAX_SAD) {
 		sprintf(msg, "Can't discover the memory socket");
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	area_type = get_dram_attr(reg);
@@ -931,7 +924,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		break;
 	default:
 		sprintf(msg, "Can't discover socket interleave");
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	*socket = sad_interleave[idx];
@@ -946,7 +938,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	if (!new_mci) {
 		sprintf(msg, "Struct for socket #%u wasn't initialized",
 			*socket);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	mci = new_mci;
@@ -962,7 +953,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		limit = TAD_LIMIT(reg);
 		if (limit <= prv) {
 			sprintf(msg, "Can't discover the memory channel");
-			edac_mc_handle_ce_no_info(mci, msg);
 			return -EINVAL;
 		}
 		if  (addr <= limit)
@@ -1002,7 +992,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		break;
 	default:
 		sprintf(msg, "Can't discover the TAD target");
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	*channel_mask = 1 << base_ch;
@@ -1016,7 +1005,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 			break;
 		default:
 			sprintf(msg, "Invalid mirror set. Can't decode addr");
-			edac_mc_handle_ce_no_info(mci, msg);
 			return -EINVAL;
 		}
 	} else
@@ -1044,7 +1032,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	if (offset > addr) {
 		sprintf(msg, "Can't calculate ch addr: TAD offset 0x%08Lx is too high for addr 0x%08Lx!",
 			offset, addr);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	addr -= offset;
@@ -1084,7 +1071,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	if (n_rir == MAX_RIR_RANGES) {
 		sprintf(msg, "Can't discover the memory rank for ch addr 0x%08Lx",
 			ch_addr);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	rir_way = RIR_WAY(reg);
@@ -1398,7 +1384,8 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 {
 	struct mem_ctl_info *new_mci;
 	struct sbridge_pvt *pvt = mci->pvt_info;
-	char *type, *optype, *msg, *recoverable_msg;
+	enum hw_event_mc_err_type tp_event;
+	char *type, *optype, msg[256], *recoverable_msg;
 	bool ripv = GET_BITFIELD(m->mcgstatus, 0, 0);
 	bool overflow = GET_BITFIELD(m->status, 62, 62);
 	bool uncorrected_error = GET_BITFIELD(m->status, 61, 61);
@@ -1413,10 +1400,18 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	int csrow, rc, dimm;
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
@@ -1434,19 +1429,19 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
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
@@ -1455,13 +1450,13 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
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
@@ -1487,18 +1482,14 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
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
@@ -1507,13 +1498,21 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 
 	debugf0("%s", msg);
 
+	/* FIXME: need support for channel mask */
+
 	/* Call the helper to output message */
-	if (uncorrected_error)
-		edac_mc_handle_fbd_ue(mci, csrow, 0, 0, msg);
-	else
-		edac_mc_handle_fbd_ce(mci, csrow, 0, msg);
+	edac_mc_handle_error(tp_event,
+			     HW_EVENT_SCOPE_MC_DIMM, mci,
+			     m->addr >> PAGE_SHIFT, m->addr & ~PAGE_MASK, 0,
+			     0, channel, dimm, -1, -1,
+			     optype, msg);
+	return;
+err_parsing:
+	edac_mc_handle_error(tp_event,
+			     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
+			     -1, -1, -1, -1, -1,
+			     msg, "");
 
-	kfree(msg);
 }
 
 /*
@@ -1676,15 +1675,17 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 {
 	struct mem_ctl_info *mci;
 	struct sbridge_pvt *pvt;
-	int rc, channels, csrows;
+	int rc, channels, dimms;
 
 	/* Check the number of active and not disabled channels */
-	rc = sbridge_get_active_channels(sbridge_dev->bus, &channels, &csrows);
+	rc = sbridge_get_active_channels(sbridge_dev->bus, &channels, &dimms);
 	if (unlikely(rc < 0))
 		return rc;
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), csrows, channels, sbridge_dev->mc);
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    1, channels, dimms,
+			    dimms, channels, sizeof(*pvt));
 	if (unlikely(!mci))
 		return -ENOMEM;
 
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 6314ff9..19ac19e 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -71,7 +71,11 @@ static void tile_edac_check(struct mem_ctl_info *mci)
 	if (mem_error.sbe_count != priv->ce_count) {
 		dev_dbg(mci->dev, "ECC CE err on node %d\n", priv->node);
 		priv->ce_count = mem_error.sbe_count;
-		edac_mc_handle_ce(mci, 0, 0, 0, 0, 0, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+				     0, 0, 0,
+				     -1, -1, -1, 0, 0,
+				     mci->ctl_name, "");
 	}
 }
 
@@ -131,8 +135,10 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	/* A TILE MC has a single channel and one chip-select row. */
-	mci = edac_mc_alloc(sizeof(struct tile_edac_priv),
-		TILE_EDAC_NR_CSROWS, TILE_EDAC_NR_CHANS, pdev->id);
+	mci = edac_mc_alloc(pdev->id, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    0, 0, TILE_EDAC_NR_CSROWS,
+			    TILE_EDAC_NR_CSROWS, TILE_EDAC_NR_CHANS,
+			    sizeof(struct tile_edac_priv));
 	if (mci == NULL)
 		return -ENOMEM;
 	priv = mci->pvt_info;
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 0de288f..27cf304 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -215,19 +215,29 @@ static void x38_process_error_info(struct mem_ctl_info *mci,
 		return;
 
 	if ((info->errsts ^ info->errsts2) & X38_ERRSTS_BITS) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
+				     -1, -1, -1, -1, -1,
+				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
 	for (channel = 0; channel < x38_channel_num; channel++) {
 		log = info->eccerrlog[channel];
 		if (log & X38_ECCERRLOG_UE) {
-			edac_mc_handle_ue(mci, 0, 0,
-				eccerrlog_row(channel, log), "x38 UE");
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
+					     HW_EVENT_SCOPE_MC_CSROW, mci,
+					     0, 0, 0,
+					     -1, -1, -1,
+					     eccerrlog_row(channel, log), -1,
+					     "x38 UE", "");
 		} else if (log & X38_ECCERRLOG_CE) {
-			edac_mc_handle_ce(mci, 0, 0,
-				eccerrlog_syndrome(log),
-				eccerrlog_row(channel, log), 0, "x38 CE");
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
+					     HW_EVENT_SCOPE_MC_CSROW, mci,
+					     0, 0, eccerrlog_syndrome(log),
+					     -1, -1, -1,
+					     eccerrlog_row(channel, log), -1,
+					     "x38 CE", "");
 		}
 	}
 }
@@ -334,7 +344,10 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	how_many_channel(pdev);
 
 	/* FIXME: unconventional pvt_info usage */
-	mci = edac_mc_alloc(0, X38_RANKS, x38_channel_num, 0);
+	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
+			    -1, -1, X38_RANKS,
+			    X38_RANKS, x38_channel_num,
+			    0);
 	if (!mci)
 		return -ENOMEM;
 
@@ -362,7 +375,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	 * cumulative; the last one will contain the total memory
 	 * contained in all ranks.
 	 */
-	for (i = 0; i < mci->nr_csrows; i++) {
+	for (i = 0; i < mci->num_csrows; i++) {
 		unsigned long nr_pages;
 		struct csrow_info *csrow = &mci->csrows[i];
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 652be25..d9fb796 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -12,6 +12,114 @@
 #ifndef _LINUX_EDAC_H_
 #define _LINUX_EDAC_H_
 
+/*
+ * Concepts used at the EDAC subsystem
+ *
+ * There are several things to be aware of that aren't at all obvious:
+ *
+ * SOCKETS, SOCKET SETS, BANKS, ROWS, CHIP-SELECT ROWS, CHANNELS, etc..
+ *
+ * These are some of the many terms that are thrown about that don't always
+ * mean what people think they mean (Inconceivable!).  In the interest of
+ * creating a common ground for discussion, terms and their definitions
+ * will be established.
+ *
+ * Memory devices:	The individual DRAM chips on a memory stick.  These
+ *			devices commonly output 4 and 8 bits each (x4, x8).
+ *			Grouping several of these in parallel provides the
+ *			number of bits that the memory controller expects:
+ *			typically 72 bits, in order to provide 64 bits of ECC
+ *			corrected data.
+ *
+ * Memory Stick:	A printed circuit board that aggregates multiple
+ *			memory devices in parallel.  In general, this is the
+ *			First replaceable unit (FRU) that the final consumer
+ *			cares to replace. It is typically encapsulated as DIMMs
+ *
+ * Socket:		A physical connector on the motherboard that accepts
+ *			a single memory stick.
+ *
+ * Branch:		The highest hierarchy on a Fully-Buffered DIMM memory
+ *			controller. Typically, it contains two channels.
+ *			Two channels at the same branch can be used in single
+ *			mode or in lockstep mode.
+ *			When lockstep is enabled, the cache line is higher,
+ *			but it generally brings some performance penalty.
+ *			Also, it is generally not possible to point to just one
+ *			memory stick when an error occurs, as the error
+ *			correction code is calculated using two dimms instead
+ *			of one. Due to that, it is capable of correcting more
+ *			errors than on single mode.
+ *
+ * Channel:		A memory controller channel, responsible to communicate
+ *			with a group of DIMM's. Each channel has its own
+ *			independent control (command) and data bus, and can
+ *			be used independently or grouped.
+ *
+ * Single-channel:	The data accessed by the memory controller is contained
+ *			into one dimm only. E. g. if the data is 64 bits-wide,
+ *			the data flows to the CPU using one 64 bits parallel
+ *			access.
+ *			Typically used with SDR, DDR, DDR2 and DDR3 memories.
+ *			FB-DIMM and RAMBUS use a different concept for channel,
+ *			so this concept doesn't apply there.
+ *
+ * Double-channel:	The data size accessed by the memory controller is
+ *			contained into two dimms accessed at the same time.
+ *			E. g. if the DIMM is 64 bits-wide, the data flows to
+ *			the CPU using a 128 bits parallel access.
+ *			Typically used with SDR, DDR, DDR2 and DDR3 memories.
+ *			FB-DIMM and RAMBUS uses a different concept for channel,
+ *			so this concept doesn't apply there.
+ *
+ * Chip-select row:	This is the name of the memory controller signal used
+ *			to select the DRAM chips to be used. It may not be
+ *			visible by the memory controller, as some memory buffer
+ *			chip may be responsible to control it.
+ *			On devices where it is visible, it controls the DIMM
+ *			(or the DIMM pair, in dual-channel mode) that is
+ *			accessed by the memory controller.
+ *
+ * Single-Ranked stick:	A Single-ranked stick has 1 chip-select row of memory.
+ *			Motherboards commonly drive two chip-select pins to
+ *			a memory stick. A single-ranked stick, will occupy
+ *			only one of those rows. The other will be unused.
+ *
+ * Double-Ranked stick:	A double-ranked stick has two chip-select rows which
+ *			access different sets of memory devices.  The two
+ *			rows cannot be accessed concurrently.
+ *
+ * Double-sided stick:	DEPRECATED TERM, see Double-Ranked stick.
+ *			A double-sided stick has two chip-select rows which
+ *			access different sets of memory devices.  The two
+ *			rows cannot be accessed concurrently.  "Double-sided"
+ *			is irrespective of the memory devices being mounted
+ *			on both sides of the memory stick.
+ *
+ * Socket set:		All of the memory sticks that are required for
+ *			a single memory access or all of the memory sticks
+ *			spanned by a chip-select row.  A single socket set
+ *			has two chip-select rows and if double-sided sticks
+ *			are used these will occupy those chip-select rows.
+ *
+ * Bank:		This term is avoided because it is unclear when
+ *			needing to distinguish between chip-select rows and
+ *			socket sets.
+ *
+ * Controller pages:
+ *
+ * Physical pages:
+ *
+ * Virtual pages:
+ *
+ *
+ * STRUCTURE ORGANIZATION AND CHOICES
+ *
+ *
+ *
+ * PS - I enjoyed writing all that about as much as you enjoyed reading it.
+ */
+
 #include <linux/atomic.h>
 #include <linux/sysdev.h>
 
@@ -73,6 +181,40 @@ enum hw_event_mc_err_type {
 };
 
 /**
+ * enum hw_event_error_scope - escope of a memory error
+ * @HW_EVENT_ERR_MC:		error can be anywhere inside the MC
+ * @HW_EVENT_SCOPE_MC_BRANCH:	error can be on any DIMM inside the branch
+ * @HW_EVENT_SCOPE_MC_CHANNEL:	error can be on any DIMM inside the MC channel
+ * @HW_EVENT_SCOPE_MC_DIMM:	error is on a specific DIMM
+ * @HW_EVENT_SCOPE_MC_CSROW:	error can be on any DIMM inside the csrow
+ * @HW_EVENT_SCOPE_MC_CSROW_CHANNEL: error is on a CSROW channel
+ *
+ * Depending on the error detection algorithm, the memory topology and even
+ * the MC capabilities, some errors can't be attributed to just one DIMM, but
+ * to a group of memory sockets. Depending on where the error occurs, the
+ * EDAC core will increment the corresponding error count for that entity,
+ * and the upper entities. For example, assuming a system with 1 memory
+ * controller 2 branches, 2 MC channels and 4 DIMMS on it, if an error
+ * happens at channel 0, the error counts for channel 0, for branch 0 and
+ * for the memory controller 0 will be incremented. The DIMM error counts won't
+ * be incremented, as, in this example, the driver can't be 100% sure on what
+ * memory the error actually occurred.
+ *
+ * The order here is important, as edac_mc_handle_error() will use it, in order
+ * to check what parameters will be used. The smallest number should be
+ * the hole memory controller, and the last one should be the more
+ * fine-grained detail, e. g.: DIMM.
+ */
+enum hw_event_error_scope {
+	HW_EVENT_SCOPE_MC,
+	HW_EVENT_SCOPE_MC_BRANCH,
+	HW_EVENT_SCOPE_MC_CHANNEL,
+	HW_EVENT_SCOPE_MC_DIMM,
+	HW_EVENT_SCOPE_MC_CSROW,
+	HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
+};
+
+/**
  * enum mem_type - memory types
  *
  * @MEM_EMPTY		Empty csrow
@@ -233,114 +375,6 @@ enum scrub_type {
 #define OP_RUNNING_POLL_INTR	0x203
 #define OP_OFFLINE		0x300
 
-/*
- * Concepts used at the EDAC subsystem
- *
- * There are several things to be aware of that aren't at all obvious:
- *
- * SOCKETS, SOCKET SETS, BANKS, ROWS, CHIP-SELECT ROWS, CHANNELS, etc..
- *
- * These are some of the many terms that are thrown about that don't always
- * mean what people think they mean (Inconceivable!).  In the interest of
- * creating a common ground for discussion, terms and their definitions
- * will be established.
- *
- * Memory devices:	The individual DRAM chips on a memory stick.  These
- *			devices commonly output 4 and 8 bits each (x4, x8).
- *			Grouping several of these in parallel provides the
- *			number of bits that the memory controller expects:
- *			typically 72 bits, in order to provide 64 bits of ECC
- *			corrected data.
- *
- * Memory Stick:	A printed circuit board that aggregates multiple
- *			memory devices in parallel.  In general, this is the
- *			First replaceable unit (FRU) that the final consumer
- *			cares to replace. It is typically encapsulated as DIMMs
- *
- * Socket:		A physical connector on the motherboard that accepts
- *			a single memory stick.
- *
- * Branch:		The highest hierarchy on a Fully-Buffered DIMM memory
- *			controller. Typically, it contains two channels.
- *			Two channels at the same branch can be used in single
- *			mode or in lockstep mode.
- *			When lockstep is enabled, the cache line is higher,
- *			but it generally brings some performance penalty.
- *			Also, it is generally not possible to point to just one
- *			memory stick when an error occurs, as the error
- *			correction code is calculated using two dimms instead
- *			of one. Due to that, it is capable of correcting more
- *			errors than on single mode.
- *
- * Channel:		A memory controller channel, responsible to communicate
- *			with a group of DIMM's. Each channel has its own
- *			independent control (command) and data bus, and can
- *			be used independently or grouped.
- *
- * Single-channel:	The data accessed by the memory controller is contained
- *			into one dimm only. E. g. if the data is 64 bits-wide,
- *			the data flows to the CPU using one 64 bits parallel
- *			access.
- *			Typically used with SDR, DDR, DDR2 and DDR3 memories.
- *			FB-DIMM and RAMBUS use a different concept for channel,
- *			so this concept doesn't apply there.
- *
- * Double-channel:	The data size accessed by the memory controller is
- *			contained into two dimms accessed at the same time.
- *			E. g. if the DIMM is 64 bits-wide, the data flows to
- *			the CPU using a 128 bits parallel access.
- *			Typically used with SDR, DDR, DDR2 and DDR3 memories.
- *			FB-DIMM and RAMBUS uses a different concept for channel,
- *			so this concept doesn't apply there.
- *
- * Chip-select row:	This is the name of the memory controller signal used
- *			to select the DRAM chips to be used. It may not be
- *			visible by the memory controller, as some memory buffer
- *			chip may be responsible to control it.
- *			On devices where it is visible, it controls the DIMM
- *			(or the DIMM pair, in dual-channel mode) that is
- *			accessed by the memory controller.
- *
- * Single-Ranked stick:	A Single-ranked stick has 1 chip-select row of memory.
- *			Motherboards commonly drive two chip-select pins to
- *			a memory stick. A single-ranked stick, will occupy
- *			only one of those rows. The other will be unused.
- *
- * Double-Ranked stick:	A double-ranked stick has two chip-select rows which
- *			access different sets of memory devices.  The two
- *			rows cannot be accessed concurrently.
- *
- * Double-sided stick:	DEPRECATED TERM, see Double-Ranked stick.
- *			A double-sided stick has two chip-select rows which
- *			access different sets of memory devices.  The two
- *			rows cannot be accessed concurrently.  "Double-sided"
- *			is irrespective of the memory devices being mounted
- *			on both sides of the memory stick.
- *
- * Socket set:		All of the memory sticks that are required for
- *			a single memory access or all of the memory sticks
- *			spanned by a chip-select row.  A single socket set
- *			has two chip-select rows and if double-sided sticks
- *			are used these will occupy those chip-select rows.
- *
- * Bank:		This term is avoided because it is unclear when
- *			needing to distinguish between chip-select rows and
- *			socket sets.
- *
- * Controller pages:
- *
- * Physical pages:
- *
- * Virtual pages:
- *
- *
- * STRUCTURE ORGANIZATION AND CHOICES
- *
- *
- *
- * PS - I enjoyed writing all that about as much as you enjoyed reading it.
- */
-
 /* FIXME: add the proper per-location error counts */
 struct dimm_info {
 	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
@@ -348,9 +382,9 @@ struct dimm_info {
 	/* Memory location data */
 	int mc_branch;
 	int mc_channel;
-	int csrow;
 	int mc_dimm_number;
-	int csrow_channel;
+	int csrow;
+	int cschannel;
 
 	struct kobject kobj;		/* sysfs kobject for this csrow */
 	struct mem_ctl_info *mci;	/* the parent */
@@ -361,13 +395,10 @@ struct dimm_info {
 	enum edac_type edac_mode;	/* EDAC mode for this dimm */
 
 	u32 nr_pages;			/* number of pages in csrow */
-
-	u32 ce_count;		/* Correctable Errors for this dimm */
 };
 
 struct csrow_channel_info {
 	int chan_idx;		/* channel index */
-	u32 ce_count;		/* Correctable Errors for this CHANNEL */
 	struct dimm_info *dimm;
 	struct csrow_info *csrow;	/* the parent */
 };
@@ -381,9 +412,6 @@ struct csrow_info {
 	unsigned long page_mask;	/* used for interleaving -
 					 * 0UL for non intlv */
 
-	u32 ue_count;		/* Uncorrectable Errors for this csrow */
-	u32 ce_count;		/* Correctable Errors for this csrow */
-
 	struct mem_ctl_info *mci;	/* the parent */
 
 	struct kobject kobj;	/* sysfs kobject for this csrow */
@@ -421,6 +449,24 @@ struct mcidev_sysfs_attribute {
         ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
 };
 
+/*
+ * Error counters for all possible memory arrangements
+ */
+struct error_counts {
+	u32 ce_mc;
+	u32 *ce_branch;
+	u32 *ce_channel;
+	u32 *ce_dimm;
+	u32 *ce_csrow;
+	u32 *ce_cschannel;
+	u32 ue_mc;
+	u32 *ue_branch;
+	u32 *ue_channel;
+	u32 *ue_dimm;
+	u32 *ue_csrow;
+	u32 *ue_cschannel;
+};
+
 /* MEMORY controller information structure
  */
 struct mem_ctl_info {
@@ -465,13 +511,19 @@ struct mem_ctl_info {
 	unsigned long (*ctl_page_to_phys) (struct mem_ctl_info * mci,
 					   unsigned long page);
 	int mc_idx;
-	int nr_csrows;
 	struct csrow_info *csrows;
 
+	/* Number of allocated memory location data */
+	unsigned num_branch;
+	unsigned num_channel;
+	unsigned num_dimm;
+	unsigned num_csrows;
+	unsigned num_cschannel;
+
 	/*
 	 * DIMM info. Will eventually remove the entire csrows_info some day
 	 */
-	unsigned nr_dimms;
+	unsigned tot_dimms;
 	struct dimm_info *dimms;
 
 	/*
@@ -486,12 +538,12 @@ struct mem_ctl_info {
 	const char *dev_name;
 	char proc_name[MC_PROC_NAME_MAX_LEN + 1];
 	void *pvt_info;
-	u32 ue_noinfo_count;	/* Uncorrectable Errors w/o info */
-	u32 ce_noinfo_count;	/* Correctable Errors w/o info */
-	u32 ue_count;		/* Total Uncorrectable Errors for this MC */
-	u32 ce_count;		/* Total Correctable Errors for this MC */
 	unsigned long start_time;	/* mci load start time (in jiffies) */
 
+	/* drivers shouldn't access this struct directly */
+	struct error_counts err;
+	unsigned ce_noinfo_count, ue_noinfo_count;
+
 	struct completion complete;
 
 	/* edac sysfs device control */
@@ -504,7 +556,7 @@ struct mem_ctl_info {
 	 * by the low level driver.
 	 *
 	 * Set by the low level driver to provide attributes at the
-	 * controller level, same level as 'ue_count' and 'ce_count' above.
+	 * controller level.
 	 * An array of structures, NULL terminated
 	 *
 	 * If attributes are desired, then set to array of attributes
diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
index fee7ed2..cbec44a 100644
--- a/include/trace/events/hw_event.h
+++ b/include/trace/events/hw_event.h
@@ -54,38 +54,60 @@ DEFINE_EVENT(hw_event_class, hw_event_init,
  */
 TRACE_EVENT(mc_error,
 
-	TP_PROTO(unsigned int err_type,
-		 unsigned int mc_index,
-		 const char *label,
+	TP_PROTO(const unsigned int err_type,
+		 const unsigned int mc_index,
 		 const char *msg,
-		 const char *detail),
+		 const char *label,
+		 const int branch,
+		 const int channel,
+		 const int dimm,
+		 const int csrow,
+		 const int cschannel,
+		 const char *detail,
+		 const char *driver_detail),
 
-	TP_ARGS(err_type, mc_index, label, msg, detail),
+	TP_ARGS(err_type, mc_index, msg, label, branch, channel, dimm, csrow,
+		cschannel, detail, driver_detail),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	err_type		)
 		__field(	unsigned int,	mc_index		)
-		__string(	label,		label			)
+		__field(	int,		branch			)
+		__field(	int,		channel			)
+		__field(	int,		dimm			)
+		__field(	int,		csrow			)
+		__field(	int,		cschannel		)
 		__string(	msg,		msg			)
+		__string(	label,		label			)
 		__string(	detail,		detail			)
+		__string(	driver_detail,	driver_detail		)
 	),
 
 	TP_fast_assign(
 		__entry->err_type		= err_type;
 		__entry->mc_index		= mc_index;
-		__assign_str(label, label);
+		__entry->branch			= branch;
+		__entry->channel		= channel;
+		__entry->dimm			= dimm;
+		__entry->csrow			= csrow;
+		__entry->cschannel		= cschannel;
 		__assign_str(msg, msg);
+		__assign_str(label, label);
 		__assign_str(detail, detail);
+		__assign_str(driver_detail, driver_detail);
 	),
 
-	TP_printk(HW_ERR "mce#%d: %s error %s on label \"%s\" %s\n",
+	TP_printk(HW_ERR "mce#%d: %s error %s on label \"%s\" (location %d.%d.%d.%d.%d %s %s)\n",
 		  __entry->mc_index,
 		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
 			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
 			"Fatal" : "Uncorrected"),
 		  __get_str(msg),
 		  __get_str(label),
-		  __get_str(detail))
+		  __entry->branch, __entry->channel, __entry->dimm,
+		  __entry->csrow, __entry->cschannel,
+		  __get_str(detail),
+		  __get_str(driver_detail))
 );
 
 TRACE_EVENT(mc_out_of_range,
-- 
1.7.8

