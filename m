Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab2BJADu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:03:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758726Ab2BJABj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 19/31] edac: rework memory layer hierarchy description
Date: Thu,  9 Feb 2012 22:01:18 -0200
Message-Id: <1328832090-9166-20-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old way of allocating data were confusing. It were
also introducing a miss-concept with regards to "channel",
when csrows are used.

Instead, use a more generic approach: breaks the memory
controller into layers. Drivers are free to describe the
layers any way they want, in order to match the memory
architecture.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c       |  108 +++----
 drivers/edac/amd76x_edac.c      |   35 ++-
 drivers/edac/cell_edac.c        |   31 +-
 drivers/edac/cpc925_edac.c      |   26 +-
 drivers/edac/e752x_edac.c       |   44 ++--
 drivers/edac/e7xxx_edac.c       |   37 +--
 drivers/edac/edac_core.h        |   54 +---
 drivers/edac/edac_mc.c          |  684 +++++++++++++++------------------------
 drivers/edac/edac_mc_sysfs.c    |   93 +++---
 drivers/edac/i3000_edac.c       |   34 +-
 drivers/edac/i3200_edac.c       |   36 +-
 drivers/edac/i5000_edac.c       |   48 ++--
 drivers/edac/i5100_edac.c       |   26 +-
 drivers/edac/i5400_edac.c       |   49 ++--
 drivers/edac/i7300_edac.c       |   46 +--
 drivers/edac/i7core_edac.c      |  168 ++---------
 drivers/edac/i82443bxgx_edac.c  |   28 +-
 drivers/edac/i82860_edac.c      |   36 +--
 drivers/edac/i82875p_edac.c     |   35 +-
 drivers/edac/i82975x_edac.c     |   33 +-
 drivers/edac/mpc85xx_edac.c     |   26 +-
 drivers/edac/mv64x60_edac.c     |   26 +-
 drivers/edac/pasemi_edac.c      |   25 +-
 drivers/edac/ppc4xx_edac.c      |   34 +-
 drivers/edac/r82600_edac.c      |   33 +-
 drivers/edac/sb_edac.c          |   94 ++-----
 drivers/edac/tile_edac.c        |   18 +-
 drivers/edac/x38_edac.c         |   37 ++-
 include/linux/edac.h            |  122 ++++----
 include/trace/events/hw_event.h |   27 +--
 30 files changed, 838 insertions(+), 1255 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 139e774..1b374b5 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1049,24 +1049,24 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	if (!src_mci) {
 		amd64_mc_err(mci, "failed to map error addr 0x%lx to a node\n",
 			     (unsigned long)sys_addr);
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     page, offset, syndrome,
-				     -1, -1, -1, -1, -1,
+				     -1, -1, -1,
 				     EDAC_MOD_STR,
-				     "failed to map error addr to a node");
+				     "failed to map error addr to a node",
+				     NULL);
 		return;
 	}
 
 	/* Now map the sys_addr to a CSROW */
 	csrow = sys_addr_to_csrow(src_mci, sys_addr);
 	if (csrow < 0) {
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     page, offset, syndrome,
-				     -1, -1, -1, -1, -1,
+				     -1, -1, -1,
 				     EDAC_MOD_STR,
-				     "failed to map error addr to a csrow");
+				     "failed to map error addr to a csrow",
+				     NULL);
 		return;
 	}
 
@@ -1082,12 +1082,12 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 			amd64_mc_warn(src_mci, "unknown syndrome 0x%04x - "
 				      "possible error reporting race\n",
 				      syndrome);
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-					     HW_EVENT_SCOPE_MC_CSROW, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 					     page, offset, syndrome,
-					     -1, -1, -1, csrow, -1,
+					     csrow, -1, -1,
 					     EDAC_MOD_STR,
-					     "unknown syndrome - possible error reporting race");
+					     "unknown syndrome - possible error reporting race",
+					     NULL);
 			return;
 		}
 	} else {
@@ -1102,11 +1102,10 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 		channel = ((sys_addr & BIT(3)) != 0);
 	}
 
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-			     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, src_mci,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci,
 			     page, offset, syndrome,
-			     -1, -1, -1, csrow, channel,
-			     EDAC_MOD_STR, "");
+			     csrow, channel, -1,
+			     EDAC_MOD_STR, "", NULL);
 }
 
 static int ddr2_cs_size(unsigned i, bool dct_width)
@@ -1587,19 +1586,18 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 page, offset;
 	int nid, csrow, chan = 0;
-	enum hw_event_error_scope scope;
 
 	error_address_to_page_and_offset(sys_addr, &page, &offset);
 
 	csrow = f1x_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
 
 	if (csrow < 0) {
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     page, offset, syndrome,
-				     -1, -1, -1, -1, -1,
+				     -1, -1, -1,
 				     EDAC_MOD_STR,
-				     "failed to map error addr to a csrow");
+				     "failed to map error addr to a csrow",
+				     NULL);
 		return;
 	}
 
@@ -1611,22 +1609,16 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	if (dct_ganging_enabled(pvt))
 		chan = get_channel_from_ecc_syndrome(mci, syndrome);
 
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				HW_EVENT_SCOPE_MC, mci,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				page, offset, syndrome,
-				-1, -1, -1, -1, -1,
+				-1, -1, -1,
 				EDAC_MOD_STR,
-				"failed to map error addr to a csrow");
-	if (chan >= 0)
-		scope = HW_EVENT_SCOPE_MC_CSROW_CHANNEL;
-	else
-		scope = HW_EVENT_SCOPE_MC_CSROW;
+				"failed to map error addr to a csrow", NULL);
 
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				HW_EVENT_SCOPE_MC, mci,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				page, offset, syndrome,
-				-1, -1, -1, csrow, chan,
-				EDAC_MOD_STR, "");
+				csrow, chan, -1,
+				EDAC_MOD_STR, "", NULL);
 }
 
 /*
@@ -1907,12 +1899,12 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 	/* Ensure that the Error Address is VALID */
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     0, 0, 0,
-				     -1, -1, -1, -1, -1,
+				     -1, -1, -1,
 				     EDAC_MOD_STR,
-				     "HW has no ERROR_ADDRESS available");
+				     "HW has no ERROR_ADDRESS available",
+				     NULL);
 		return;
 	}
 
@@ -1936,12 +1928,12 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     0, 0, 0,
-				     -1, -1, -1, -1, -1,
+				     -1, -1, -1,
 				     EDAC_MOD_STR,
-				     "HW has no ERROR_ADDRESS available");
+				     "HW has no ERROR_ADDRESS available",
+				     NULL);
 		return;
 	}
 
@@ -1956,12 +1948,11 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (!src_mci) {
 		amd64_mc_err(mci, "ERROR ADDRESS (0x%lx) NOT mapped to a MC\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
-				     -1, -1, -1, -1, -1,
+				     -1, -1, -1,
 				     EDAC_MOD_STR,
-				     "ERROR ADDRESS NOT mapped to a MC");
+				     "ERROR ADDRESS NOT mapped to a MC", NULL);
 		return;
 	}
 
@@ -1971,18 +1962,17 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (csrow < 0) {
 		amd64_mc_err(mci, "ERROR_ADDRESS (0x%lx) NOT mapped to CS\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
-				     -1, -1, -1, -1, -1,
+				     -1, -1, -1,
 				     EDAC_MOD_STR,
-				     "ERROR ADDRESS NOT mapped to CS");
+				     "ERROR ADDRESS NOT mapped to CS",
+				     NULL);
 	} else {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
-				     -1, -1, -1, csrow, -1,
-				     EDAC_MOD_STR, "");
+				     csrow, -1, -1,
+				     EDAC_MOD_STR, "", NULL);
 	}
 }
 
@@ -2542,6 +2532,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct amd64_pvt *pvt = NULL;
 	struct amd64_family_type *fam_type = NULL;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	int err = 0, ret;
 	u8 nid = get_node_id(F2);
 
@@ -2576,10 +2567,13 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 		goto err_siblings;
 
 	ret = -ENOMEM;
-	/* FIXME: Assuming one DIMM per csrow channel */
-	mci = edac_mc_alloc(nid, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    0, 0, pvt->csels[0].b_cnt * pvt->channel_count,
-			    pvt->csels[0].b_cnt, pvt->channel_count, nid);
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
index 7e6bbf8..4f3e54a 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -145,12 +145,10 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors) {
 			row = (info->ecc_mode_status >> 4) & 0xf;
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
-					     mci, mci->csrows[row].first_page,
-					     0, 0,
-					     -1, -1, row, row, 0,
-					     mci->ctl_name, "");
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     mci->csrows[row].first_page, 0, 0,
+					     row, 0, -1,
+					     mci->ctl_name, "", NULL);
 		}
 	}
 
@@ -162,12 +160,10 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors) {
 			row = info->ecc_mode_status & 0xf;
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
-					     mci, mci->csrows[row].first_page,
-					     0, 0,
-					     -1, -1, row, row, 0,
-					     mci->ctl_name, "");
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     mci->csrows[row].first_page, 0, 0,
+					     row, 0, -1,
+					     mci->ctl_name, "", NULL);
 		}
 	}
 
@@ -239,7 +235,8 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 		EDAC_SECDED,
 		EDAC_SECDED
 	};
-	struct mem_ctl_info *mci = NULL;
+	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	u32 ems;
 	u32 ems_mode;
 	struct amd76x_error_info discard;
@@ -247,9 +244,15 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	debugf0("%s()\n", __func__);
 	pci_read_config_dword(pdev, AMD76X_ECC_MODE_STATUS, &ems);
 	ems_mode = (ems >> 10) & 0x3;
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_MCCHANNEL_IS_CSROW,
-			    0, 0, AMD76X_NR_CSROWS,
-			    AMD76X_NR_CSROWS, 1, 0);
+
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = AMD76X_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = 1;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
+
 	if (mci == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index abe06a4..39616a3 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -48,11 +48,9 @@ static void cell_edac_count_ce(struct mem_ctl_info *mci, int chan, u64 ar)
 	syndrome = (ar & 0x000000001fe00000ul) >> 21;
 
 	/* TODO: Decoding of the error address */
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
-				csrow->first_page + pfn, offset, syndrome,
-				-1, -1, -1, 0, chan,
-				"", "");
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			     csrow->first_page + pfn, offset, syndrome,
+			     0, chan, -1, "", "", NULL);
 }
 
 static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
@@ -72,11 +70,9 @@ static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
 	offset = address & ~PAGE_MASK;
 
 	/* TODO: Decoding of the error address */
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
-				csrow->first_page + pfn, offset, 0,
-				-1, -1, -1, 0, chan,
-				"", "");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			     csrow->first_page + pfn, offset, 0,
+			     0, chan, -1, "", "", NULL);
 }
 
 static void cell_edac_check(struct mem_ctl_info *mci)
@@ -163,7 +159,7 @@ static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 			"Initialized on node %d, chanmask=0x%x,"
 			" first_page=0x%lx, nr_pages=0x%x\n",
 			priv->node, priv->chanmask,
-			csrow->first_page, dimm->nr_pages);
+			csrow->first_page, nr_pages);
 		break;
 	}
 }
@@ -172,6 +168,7 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 {
 	struct cbe_mic_tm_regs __iomem	*regs;
 	struct mem_ctl_info		*mci;
+	struct edac_mc_layer		layers[2];
 	struct cell_edac_priv		*priv;
 	u64				reg;
 	int				rc, chanmask, num_chans;
@@ -200,9 +197,15 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 
 	/* Allocate & init EDAC MC data structure */
 	num_chans = chanmask == 3 ? 2 : 1;
-	mci = edac_mc_alloc(pdev->id, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    0, 0, num_chans,
-			    1, num_chans, sizeof(struct cell_edac_priv));
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
index 4a25b92..eb6297d 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -555,20 +555,18 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 	if (apiexcp & CECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM CECC Fault\n");
 		channel = cpc925_mc_find_channel(mci, syndrome);
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     pfn, offset, syndrome,
-				     -1, -1, -1, csrow, channel,
-				     mci->ctl_name, "");
+				     csrow, channel, -1,
+				     mci->ctl_name, "", NULL);
 	}
 
 	if (apiexcp & UECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM UECC Fault\n");
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     pfn, offset, 0,
-				     -1, -1, -1, csrow, -1,
-				     mci->ctl_name, "");
+				     csrow, -1, -1,
+				     mci->ctl_name, "", NULL);
 	}
 
 	cpc925_mc_printk(mci, KERN_INFO, "Dump registers:\n");
@@ -940,6 +938,7 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 {
 	static int edac_mc_idx;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	void __iomem *vbase;
 	struct cpc925_mc_pdata *pdata;
 	struct resource *r;
@@ -976,9 +975,14 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	}
 
 	nr_channels = cpc925_mc_get_channels(vbase) + 1;
-	mci = edac_mc_alloc(edac_mc_idx, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    0, 0, CPC925_NR_CSROWS * nr_channels,
-			    CPC925_NR_CSROWS, nr_channels,
+
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = CPC925_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_channels;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
 			    sizeof(struct cpc925_mc_pdata));
 	if (!mci) {
 		cpc925_printk(KERN_ERR, "No memory for mem_ctl_info\n");
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 813d965..1acce46 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -353,11 +353,10 @@ static void do_process_ce(struct mem_ctl_info *mci, u16 error_one,
 	channel = !(error_one & 1);
 
 	/* e752x mc reads 34:6 of the DRAM linear address */
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-			     HW_EVENT_SCOPE_MC, mci,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 			     page, offset_in_page(sec1_add << 4), sec1_syndrome,
-			     -1, -1, -1, row, channel,
-			     "e752x CE", "");
+			     row, channel, -1,
+			     "e752x CE", "", NULL);
 }
 
 static inline void process_ce(struct mem_ctl_info *mci, u16 error_one,
@@ -391,12 +390,11 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-					HW_EVENT_SCOPE_MC_CSROW, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 					block_page,
 					offset_in_page(error_2b << 4), 0,
-					-1, -1, -1, row, -1,
-					"e752x UE from Read", "");
+					 row, -1, -1,
+					"e752x UE from Read", "", NULL);
 
 	}
 	if (error_one & 0x0404) {
@@ -411,12 +409,11 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-					HW_EVENT_SCOPE_MC_CSROW, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 					block_page,
 					offset_in_page(error_2b << 4), 0,
-					-1, -1, -1, row, -1,
-					"e752x UE from Scruber", "");
+					row, -1, -1,
+					"e752x UE from Scruber", "", NULL);
 	}
 }
 
@@ -439,10 +436,9 @@ static inline void process_ue_no_info_wr(struct mem_ctl_info *mci,
 		return;
 
 	debugf3("%s()\n", __func__);
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-			     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
-			     -1, -1, -1, -1, -1,
-			     "e752x UE log memory write", "");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+			     -1, -1, -1,
+			     "e752x UE log memory write", "", NULL);
 }
 
 static void do_process_ded_retry(struct mem_ctl_info *mci, u16 error,
@@ -1248,6 +1244,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	u16 pci_data;
 	u8 stat8;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct e752x_pvt *pvt;
 	u16 ddrcsr;
 	int drc_chan;		/* Number of channels 0=1chan,1=2chan */
@@ -1274,13 +1271,16 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	/* Dual channel = 1, Single channel = 0 */
 	drc_chan = dual_channel_active(ddrcsr);
 
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    0, 0, E752X_NR_CSROWS * (drc_chan + 1),
-			    E752X_NR_CSROWS, drc_chan + 1, sizeof(*pvt));
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
index 01f64d3..f59dc0c 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -219,20 +219,15 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	row = edac_mc_find_csrow_by_page(mci, page);
 	/* convert syndrome to channel */
 	channel = e7xxx_find_channel(syndrome);
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-			     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
-			     page, 0, syndrome,
-			     -1, -1, -1, row, channel,
-			     "e7xxx CE", "");
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, page, 0, syndrome,
+			     row, channel, -1, "e7xxx CE", "", NULL);
 }
 
 static void process_ce_no_info(struct mem_ctl_info *mci)
 {
 	debugf3("%s()\n", __func__);
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-			     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
-			     -1, -1, -1, -1, -1,
-			     "e7xxx CE log register overflow", "");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
+			     "e7xxx CE log register overflow", "", NULL);
 }
 
 static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
@@ -247,20 +242,16 @@ static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	block_page = error_2b >> 6;	/* convert to 4k address */
 	row = edac_mc_find_csrow_by_page(mci, block_page);
 
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-			     HW_EVENT_SCOPE_MC_CSROW, mci, block_page, 0, 0,
-			     -1, -1, -1, row, -1,
-			     "e7xxx UE", "");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, block_page, 0, 0,
+			     row, -1, -1, "e7xxx UE", "", NULL);
 }
 
 static void process_ue_no_info(struct mem_ctl_info *mci)
 {
 	debugf3("%s()\n", __func__);
 
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-			     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
-			     -1, -1, -1, -1, -1,
-			     "e7xxx UE log register overflow", "");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
+			     "e7xxx UE log register overflow", "", NULL);
 }
 
 static void e7xxx_get_error_info(struct mem_ctl_info *mci,
@@ -431,6 +422,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	u16 pci_data;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	struct e7xxx_pvt *pvt = NULL;
 	u32 drc;
 	int drc_chan;
@@ -449,10 +441,13 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	 * will map the rank. So, an error to either channel should be
 	 * attributed to the same dimm.
 	 */
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    0, 0, E7XXX_NR_DIMMS,
-			    E7XXX_NR_CSROWS, drc_chan + 1, sizeof(*pvt));
-
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
index e4961fd..1d421d3 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -448,35 +448,10 @@ static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
 
 #endif				/* CONFIG_PCI */
 
-/**
- * enum edac_alloc_fill_strategy - Controls the way csrows/cschannels are mapped
- * @EDAC_ALLOC_FILL_CSROW_CSCHANNEL:	csrows are rows, cschannels are channel.
- *					This is the default and should be used
- *					when the memory controller is able to
- *					see csrows/cschannels. The dimms are
- *					associated with cschannels.
- * @EDAC_ALLOC_FILL_MCCHANNEL_IS_CSROW:	mc_branch/mc_channel are mapped as
- *					cschannel. DIMMs inside each channel are
- *					mapped as csrows. Most FBDIMMs drivers
- *					use this model.
- *@EDAC_ALLOC_FILL_PRIV:		The driver uses its own mapping model.
- *					So, the core will leave the csrows
- *					struct unitialized, leaving to the
- *					driver the task of filling it.
- */
-enum edac_alloc_fill_strategy {
-	EDAC_ALLOC_FILL_CSROW_CSCHANNEL = 0,
-	EDAC_ALLOC_FILL_MCCHANNEL_IS_CSROW,
-	EDAC_ALLOC_FILL_PRIV,
-};
-
-struct mem_ctl_info *edac_mc_alloc(int edac_index,
-				   enum edac_alloc_fill_strategy fill_strategy,
-				   unsigned num_branch,
-				   unsigned num_channel,
-				   unsigned num_dimm,
-				   unsigned nr_csrows,
-				   unsigned num_cschans,
+struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
+				   unsigned n_layers,
+				   struct edac_mc_layer *layers,
+				   bool rev_order,
 				   unsigned sz_pvt);
 extern int edac_mc_add_mc(struct mem_ctl_info *mci);
 extern void edac_mc_free(struct mem_ctl_info *mci);
@@ -485,19 +460,17 @@ extern struct mem_ctl_info *find_mci_by_dev(struct device *dev);
 extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
 extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
 				      unsigned long page);
-void edac_mc_handle_error(enum hw_event_mc_err_type type,
-			  enum hw_event_error_scope scope,
+void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  struct mem_ctl_info *mci,
-			  unsigned long page_frame_number,
-			  unsigned long offset_in_page,
-			  unsigned long syndrome,
-			  int mc_branch,
-			  int mc_channel,
-			  int mc_dimm_number,
-			  int csrow,
-			  int cschannel,
+			  const unsigned long page_frame_number,
+			  const unsigned long offset_in_page,
+			  const unsigned long syndrome,
+			  const int layer0,
+			  const int layer1,
+			  const int layer2,
 			  const char *msg,
-			  const char *other_detail);
+			  const char *other_detail,
+			  const void *mcelog);
 
 /*
  * edac_device APIs
@@ -509,6 +482,7 @@ extern void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
 extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
 				int inst_nr, int block_nr, const char *msg);
 extern int edac_device_alloc_index(void);
+extern const char *edac_layer_name[];
 
 /*
  * edac_pci APIs
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 55760bc..6e8faf3 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -53,13 +53,18 @@ static void edac_mc_dump_channel(struct csrow_channel_info *chan)
 
 static void edac_mc_dump_dimm(struct dimm_info *dimm)
 {
+	int i;
+
 	debugf4("\tdimm = %p\n", dimm);
 	debugf4("\tdimm->label = '%s'\n", dimm->label);
 	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
-	debugf4("\tdimm location %d.%d.%d.%d.%d\n",
-		dimm->mc_branch, dimm->mc_channel,
-		dimm->mc_dimm_number,
-		dimm->csrow, dimm->cschannel);
+	debugf4("\tdimm location ");
+	for (i = 0; i < dimm->mci->n_layers; i++) {
+		printk(KERN_CONT "%d", dimm->location[i]);
+		if (i < dimm->mci->n_layers - 1)
+			printk(KERN_CONT ".");
+	}
+	printk(KERN_CONT "\n");
 	debugf4("\tdimm->grain = %d\n", dimm->grain);
 	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
 }
@@ -160,52 +165,25 @@ void *edac_align_ptr(void **p, unsigned size, int quant)
 /**
  * edac_mc_alloc: Allocate and partially fills a struct mem_ctl_info structure
  * @edac_index:		Memory controller number
- * @fill_strategy:	csrow/cschannel filling strategy
- * @num_branch:		Number of memory controller branches
- * @num_channel:	Number of memory controller channels
- * @num_dimm:		Number of dimms per memory controller channel
- * @num_csrows:		Number of CWROWS accessed via the memory controller
- * @num_cschannel:	Number of csrows channels
+ * @n_layers:		Number of layers at the MC hierarchy
+ * layers:		Describes each layer as seen by the Memory Controller
+ * @rev_order:		Fills csrows/cs channels at the reverse order
  * @size_pvt:		size of private storage needed
  *
- * This routine supports 3 modes of DIMM mapping:
- *	1) the ones that accesses DRAM's via some bus interface (FB-DIMM
- * and RAMBUS memory controllers) or that don't have chip select view
- *
- * In this case, a branch is generally a group of 2 channels, used generally
- * in  parallel to provide 128 bits data.
- *
- * In the case of FB-DIMMs, the dimm is addressed via the SPD Address
- * input selection, used by the AMB to select the DIMM. The MC channel
- * corresponds to the Memory controller channel bus used to see a series
- * of FB-DIMM's.
- *
- * num_branch, num_channel and num_dimm should point to the real
- *	parameters of the memory controller.
- *
- * The total number of dimms is num_branch * num_channel * num_dimm
- *
- * According with JEDEC No. 205, up to 8 FB-DIMMs are possible per channel. Of
- * course, controllers may have a lower limit.
+ * FIXME: rev_order seems to be uneeded. On all places, it is marked as false.
+ * Tests are required, but if this is the case, this field can just be dropped.
  *
- * num_csrows/num_cschannel should point to the emulated parameters.
- * The total number of cschannels (num_csrows * num_cschannel) should be a
- * multiple of the total number dimms, e. g:
- *  factor = (num_csrows * num_cschannel)/(num_branch * num_channel * num_dimm)
- * should be an integer (typically: it is 1 or num_cschannel)
+ * FIXME: drivers handle multi-rank memories on different ways: on some
+ * drivers, one multi-rank memory is mapped as one DIMM, while, on others,
+ * a single multi-rank DIMM would be mapped into several "dimms".
  *
- *	2) The MC uses CSROWS/CS CHANNELS to directly select a DRAM chip.
- * One dimm chip exists on every cs channel, for single-rank memories.
- *	num_branch and num_channel should be 0
- *	num_dimm should be the total number of dimms
- *	num_csrows * num_cschannel should be equal to num_dimm
+ * Non-csrow based drivers (like FB-DIMM and RAMBUS ones) will likely report
+ * such DIMMS properly, but the CSROWS-based ones will likely do the wrong
+ * thing, as two chip select values are used for dual-rank memories (and 4, for
+ * quad-rank ones). I suspect that this issue could be solved inside the EDAC
+ * core for SDRAM memories, but it requires further study at JEDEC JESD 21C.
  *
- *	3)The MC uses CSROWS/CS CHANNELS. One dimm chip exists on every
- * csrow. The cs channel is used to indicate the defective chip(s) inside
- * the memory stick.
- *	num_branch and num_channel should be 0
- *	num_dimm should be the total number of dimms
- *	num_csrows should be equal to num_dimm
+ * In summary, solving this issue is not easy, as it requires a lot of testing.
  *
  * Everything is kmalloc'ed as one big chunk - more efficient.
  * Only can be used if all structures have the same lifetime - otherwise
@@ -217,87 +195,64 @@ void *edac_align_ptr(void **p, unsigned size, int quant)
  *	NULL allocation failed
  *	struct mem_ctl_info pointer
  */
-struct mem_ctl_info *edac_mc_alloc(int edac_index,
-				   enum edac_alloc_fill_strategy fill_strategy,
-				   unsigned num_branch,
-				   unsigned num_channel,
-				   unsigned num_dimm,
-				   unsigned num_csrows,
-				   unsigned num_cschannel,
+struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
+				   unsigned n_layers,
+				   struct edac_mc_layer *layers,
+				   bool rev_order,
 				   unsigned sz_pvt)
 {
 	void *ptr;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer *lay;
 	struct csrow_info *csi, *csr;
 	struct csrow_channel_info *chi, *chp, *chan;
 	struct dimm_info *dimm;
-	u32 *ce_branch, *ce_channel, *ce_dimm, *ce_csrow, *ce_cschannel;
-	u32 *ue_branch, *ue_channel, *ue_dimm, *ue_csrow, *ue_cschannel;
+	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
 	void *pvt;
-	unsigned size, tot_dimms, count, dimm_div;
-	int i;
+	unsigned size, tot_dimms, count, per_layer_count[EDAC_MAX_LAYERS];
+	unsigned tot_csrows, tot_cschannels;
+	int i, j;
 	int err;
-	int mc_branch, mc_channel, mc_dimm_number, csrow, cschannel;
 	int row, chn;
 
+	BUG_ON(n_layers > EDAC_MAX_LAYERS);
 	/*
-	 * While we expect that non-pertinent values will be filled with
-	 * 0, in order to provide a way for this routine to detect if the
-	 * EDAC is emulating the old sysfs API, we can't actually accept
-	 * 0, as otherwise, a multiply by 0 whould hapen.
+	 * Calculate the total amount of dimms and csrows/cschannels while
+	 * in the old API emulation mode
 	 */
-	if (num_branch <= 0)
-		num_branch = 1;
-	if (num_channel <= 0)
-		num_channel = 1;
-	if (num_dimm <= 0)
-		num_dimm = 1;
-	if (num_csrows <= 0)
-		num_csrows = 1;
-	if (num_cschannel <= 0)
-		num_cschannel = 1;
-
-	tot_dimms = num_branch * num_channel * num_dimm;
-	dimm_div = (num_csrows * num_cschannel) / tot_dimms;
-	if (dimm_div == 0) {
-		printk(KERN_ERR "%s: dimm_div is wrong: tot_channels/tot_dimms = %d/%d < 1\n",
-			__func__, num_csrows * num_cschannel, tot_dimms);
-		dimm_div = 1;
+	tot_dimms = 1;
+	tot_cschannels = 1;
+	tot_csrows = 1;
+	for (i = 0; i < n_layers; i++) {
+		tot_dimms *= layers[i].size;
+		if (layers[i].is_csrow)
+			tot_csrows *= layers[i].size;
+		else
+			tot_cschannels *= layers[i].size;
 	}
-	/* FIXME: change it to debug2() at the final version */
 
 	/* Figure out the offsets of the various items from the start of an mc
 	 * structure.  We want the alignment of each item to be at least as
 	 * stringent as what the compiler would provide if we could simply
 	 * hardcode everything into a single struct.
 	 */
-	ptr = NULL;
+	ptr = 0;
 	mci = edac_align_ptr(&ptr, sizeof(*mci), 1);
-	csi = edac_align_ptr(&ptr, sizeof(*csi), num_csrows);
-	chi = edac_align_ptr(&ptr, sizeof(*chi), num_csrows * num_cschannel);
+	lay = edac_align_ptr(&ptr, sizeof(*lay), n_layers);
+	csi = edac_align_ptr(&ptr, sizeof(*csi), tot_csrows);
+	chi = edac_align_ptr(&ptr, sizeof(*chi), tot_csrows * tot_cschannels);
 	dimm = edac_align_ptr(&ptr, sizeof(*dimm), tot_dimms);
-
-	count = num_branch;
-	ue_branch = edac_align_ptr(&ptr, sizeof(*ce_branch), count);
-	ce_branch = edac_align_ptr(&ptr, sizeof(*ce_branch), count);
-	count *= num_channel;
-	ue_channel = edac_align_ptr(&ptr, sizeof(*ce_channel), count);
-	ce_channel = edac_align_ptr(&ptr, sizeof(*ce_channel), count);
-	count *= num_dimm;
-	ue_dimm = edac_align_ptr(&ptr, sizeof(*ce_dimm), count * num_dimm);
-	ce_dimm = edac_align_ptr(&ptr, sizeof(*ce_dimm), count * num_dimm);
-
-	count = num_csrows;
-	ue_csrow = edac_align_ptr(&ptr, sizeof(*ce_dimm), count);
-	ce_csrow = edac_align_ptr(&ptr, sizeof(*ce_dimm), count);
-	count *= num_cschannel;
-	ue_cschannel = edac_align_ptr(&ptr, sizeof(*ce_dimm), count);
-	ce_cschannel = edac_align_ptr(&ptr, sizeof(*ce_dimm), count);
-
+	count = 1;
+	for (i = 0; i < n_layers; i++) {
+		count *= layers[i].size;
+		ce_per_layer[i] = edac_align_ptr(&ptr, sizeof(unsigned), count);
+		ue_per_layer[i] = edac_align_ptr(&ptr, sizeof(unsigned), count);
+	}
 	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
 	size = ((unsigned long)pvt) + sz_pvt;
 
-	debugf1("%s(): allocating %u bytes for mci data\n", __func__, size);
+	debugf1("%s(): allocating %u bytes for mci data (%d dimms, %d csrows/channels)\n",
+		__func__, size, tot_dimms, tot_csrows * tot_cschannels);
 	mci = kzalloc(size, GFP_KERNEL);
 	if (mci == NULL)
 		return NULL;
@@ -305,131 +260,97 @@ struct mem_ctl_info *edac_mc_alloc(int edac_index,
 	/* Adjust pointers so they point within the memory we just allocated
 	 * rather than an imaginary chunk of memory located at address 0.
 	 */
+	lay = (struct edac_mc_layer *)(((char *)mci) + ((unsigned long)lay));
 	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
 	chi = (struct csrow_channel_info *)(((char *)mci) + ((unsigned long)chi));
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
-	mci->pvt_info = pvt;
-
 	mci->tot_dimms = tot_dimms;
-	mci->num_branch = num_branch;
-	mci->num_channel = num_channel;
-	mci->num_dimm = num_dimm;
-	mci->num_csrows = num_csrows;
-	mci->num_cschannel = num_cschannel;
+	mci->pvt_info = pvt;
+	mci->n_layers = n_layers;
+	mci->layers = lay;
+	memcpy(mci->layers, layers, sizeof(*lay) * n_layers);
+	mci->num_csrows = tot_csrows;
+	mci->num_cschannel = tot_cschannels;
 
 	/*
-	 * Fills the dimm struct
+	 * Fills the csrow struct
 	 */
-	mc_branch = (num_branch > 0) ? 0 : -1;
-	mc_channel = (num_channel > 0) ? 0 : -1;
-	mc_dimm_number = (num_dimm > 0) ? 0 : -1;
-	if (!num_channel && !num_branch) {
-		csrow = (num_csrows > 0) ? 0 : -1;
-		cschannel = (num_cschannel > 0) ? 0 : -1;
-	} else {
-		csrow = -1;
-		cschannel = -1;
+	for (row = 0; row < tot_csrows; row++) {
+		csr = &csi[row];
+		csr->csrow_idx = row;
+		csr->mci = mci;
+		csr->nr_channels = tot_cschannels;
+		chp = &chi[row * tot_cschannels];
+		csr->channels = chp;
+
+		for (chn = 0; chn < tot_cschannels; chn++) {
+			chan = &chp[chn];
+			chan->chan_idx = chn;
+			chan->csrow = csr;
+		}
 	}
 
+	/*
+	 * Fills the dimm struct
+	 */
+	memset(&per_layer_count, 0, sizeof(per_layer_count));
+	row = 0;
+	chn = 0;
 	debugf4("%s: initializing %d dimms\n", __func__, tot_dimms);
 	for (i = 0; i < tot_dimms; i++) {
+		debugf4("%s: dimm%d: row %d, chan %d\n", __func__,
+			i, row, chn);
+		chan = &csi[row].channels[chn];
 		dimm = &mci->dimms[i];
-
-		dimm->mc_branch = mc_branch;
-		dimm->mc_channel = mc_channel;
-		dimm->mc_dimm_number = mc_dimm_number;
-		dimm->csrow = csrow;
-		dimm->cschannel = cschannel;
-
-		/*
-		 * Increment the location
-		 * On csrow-emulated devices, csrow/cschannel should be -1
-		 */
-		if (!num_channel && !num_branch) {
-			if (num_cschannel) {
-				cschannel = (cschannel + 1) % num_cschannel;
-				if (cschannel)
-					continue;
+		dimm->mci = mci;
+
+		/* Copy DIMM location */
+		for (j = 0; j < n_layers; j++)
+			dimm->location[j] = per_layer_count[j];
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
 			}
-			if (num_csrows) {
-				csrow = (csrow + 1) % num_csrows;
-				if (csrow)
-					continue;
+		} else {
+			for (j = n_layers - 1; j >= 0; j--)
+				if (layers[j].is_csrow)
+					break;
+			row++;
+			if (row == tot_csrows) {
+				row = 0;
+				chn++;
 			}
 		}
-		if (num_dimm) {
-			mc_dimm_number = (mc_dimm_number + 1) % num_dimm;
-			if (mc_dimm_number)
-				continue;
-		}
-		if (num_channel) {
-			mc_channel = (mc_channel + 1) % num_channel;
-			if (mc_channel)
-				continue;
-		}
-		if (num_branch) {
-			mc_branch = (mc_branch + 1) % num_branch;
-			if (mc_branch)
-				continue;
-		}
-	}
 
-	/*
-	 * Fills the csrows struct
-	 *
-	 * NOTE: there are two possible memory arrangements here:
-	 *
-	 *
-	 */
-	switch (fill_strategy) {
-	case EDAC_ALLOC_FILL_CSROW_CSCHANNEL:
-		for (row = 0; row < num_csrows; row++) {
-			csr = &csi[row];
-			csr->csrow_idx = row;
-			csr->mci = mci;
-			csr->nr_channels = num_cschannel;
-			chp = &chi[row * num_cschannel];
-			csr->channels = chp;
-
-			for (chn = 0; chn < num_cschannel; chn++) {
-				int dimm_idx = (chn + row * num_cschannel) /
-						dimm_div;
-				debugf4("%s: csrow(%d,%d) = dimm%d\n",
-					__func__, row, chn, dimm_idx);
-				chan = &chp[chn];
-				chan->chan_idx = chn;
-				chan->csrow = csr;
-				chan->dimm = &dimm[dimm_idx];
-			}
+		/* Increment dimm location */
+		for (j = n_layers - 1; j >= 0; j--) {
+			per_layer_count[j]++;
+			if (per_layer_count[j] < layers[j].size)
+				break;
+			per_layer_count[j] = 0;
 		}
-	case EDAC_ALLOC_FILL_MCCHANNEL_IS_CSROW:
-		for (row = 0; row < num_csrows; row++) {
-			csr = &csi[row];
-			csr->csrow_idx = row;
-			csr->mci = mci;
-			csr->nr_channels = num_cschannel;
-			chp = &chi[row * num_cschannel];
-			csr->channels = chp;
-
-			for (chn = 0; chn < num_cschannel; chn++) {
-				int dimm_idx = (chn * num_cschannel + row) /
-						dimm_div;
-				debugf4("%s: csrow(%d,%d) = dimm%d\n",
-					__func__, row, chn, dimm_idx);
-				chan = &chp[chn];
-				chan->chan_idx = chn;
-				chan->csrow = csr;
-				chan->dimm = &dimm[dimm_idx];
-			}
-		}
-	case EDAC_ALLOC_FILL_PRIV:
-		break;
 	}
 
 	mci->op_state = OP_ALLOC;
@@ -886,9 +807,9 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
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
@@ -903,221 +824,110 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 }
 EXPORT_SYMBOL_GPL(edac_mc_find_csrow_by_page);
 
-void edac_increment_ce_error(enum hw_event_error_scope scope,
-			     struct mem_ctl_info *mci,
-			     int mc_branch,
-			     int mc_channel,
-			     int mc_dimm_number,
-			     int csrow,
-			     int cschannel)
-{
-	int index;
+const char *edac_layer_name[] = {
+	[EDAC_MC_LAYER_BRANCH] = "branch",
+	[EDAC_MC_LAYER_CHANNEL] = "channel",
+	[EDAC_MC_LAYER_SLOT] = "slot",
+	[EDAC_MC_LAYER_CHIP_SELECT] = "csrow",
+};
+EXPORT_SYMBOL_GPL(edac_layer_name);
 
-	mci->err.ce_mc++;
+static void edac_increment_ce_error(struct mem_ctl_info *mci,
+				    bool enable_filter,
+				    unsigned pos[EDAC_MAX_LAYERS])
+{
+	int i, index = 0;
 
-	if (scope == HW_EVENT_SCOPE_MC) {
-		mci->ce_noinfo_count = 0;
-		return;
-	}
+	mci->ce_mc++;
 
-	index = 0;
-	if (mc_branch >= 0) {
-		index = mc_branch;
-		mci->err.ce_branch[index]++;
-	}
-	if (scope == HW_EVENT_SCOPE_MC_BRANCH)
+	if (!enable_filter) {
+		mci->ce_noinfo_count++;
 		return;
-	index *= mci->num_branch;
-
-	if (mc_channel >= 0) {
-		index += mc_channel;
-		mci->err.ce_channel[index]++;
 	}
-	if (scope == HW_EVENT_SCOPE_MC_CHANNEL)
-		return;
-	index *= mci->num_channel;
 
-	if (mc_dimm_number >= 0) {
-		index += mc_dimm_number;
-		mci->err.ce_dimm[index]++;
-	}
-	if (scope == HW_EVENT_SCOPE_MC_DIMM)
-		return;
-	index *= mci->num_dimm;
-
-	if (csrow >= 0) {
-		index += csrow;
-		mci->err.ce_csrow[csrow]++;
-	}
-	if (scope == HW_EVENT_SCOPE_MC_CSROW_CHANNEL)
-		return;
-	index *= mci->num_csrows;
-
-	if (cschannel >= 0) {
-		index += cschannel;
-		mci->err.ce_cschannel[index]++;
+	for (i = 0; i <= mci->n_layers; i++) {
+		if (pos[i] < 0)
+			break;
+		index += pos[i];
+		mci->ce_per_layer[i][index]++;
+		index *= mci->layers[i].size;
 	}
 }
 
-void edac_increment_ue_error(enum hw_event_error_scope scope,
-			     struct mem_ctl_info *mci,
-			     int mc_branch,
-			     int mc_channel,
-			     int mc_dimm_number,
-			     int csrow,
-			     int cschannel)
+static void edac_increment_ue_error(struct mem_ctl_info *mci,
+				    bool enable_filter,
+				    unsigned pos[EDAC_MAX_LAYERS])
 {
-	int index;
-
-	mci->err.ue_mc++;
+	int i, index = 0;
 
-	if (scope == HW_EVENT_SCOPE_MC) {
-		mci->ue_noinfo_count = 0;
-		return;
-	}
+	mci->ue_mc++;
 
-	index = 0;
-	if (mc_branch >= 0) {
-		index = mc_branch;
-		mci->err.ue_branch[index]++;
-	}
-	if (scope == HW_EVENT_SCOPE_MC_BRANCH)
+	if (!enable_filter) {
+		mci->ce_noinfo_count++;
 		return;
-	index *= mci->num_branch;
-
-	if (mc_channel >= 0) {
-		index += mc_channel;
-		mci->err.ue_channel[index]++;
 	}
-	if (scope == HW_EVENT_SCOPE_MC_CHANNEL)
-		return;
-	index *= mci->num_channel;
 
-	if (mc_dimm_number >= 0) {
-		index += mc_dimm_number;
-		mci->err.ue_dimm[index]++;
-	}
-	if (scope == HW_EVENT_SCOPE_MC_DIMM)
-		return;
-	index *= mci->num_dimm;
-
-	if (csrow >= 0) {
-		index += csrow;
-		mci->err.ue_csrow[csrow]++;
-	}
-	if (scope == HW_EVENT_SCOPE_MC_CSROW_CHANNEL)
-		return;
-	index *= mci->num_csrows;
-
-	if (cschannel >= 0) {
-		index += cschannel;
-		mci->err.ue_cschannel[index]++;
+	for (i = 0; i <= mci->n_layers; i++) {
+		if (pos[i] < 0)
+			break;
+		index += pos[i];
+		mci->ue_per_layer[i][index]++;
+		index *= mci->layers[i].size;
 	}
 }
 
-void edac_mc_handle_error(enum hw_event_mc_err_type type,
-			  enum hw_event_error_scope scope,
+void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  struct mem_ctl_info *mci,
-			  unsigned long page_frame_number,
-			  unsigned long offset_in_page,
-			  unsigned long syndrome,
-			  int mc_branch,
-			  int mc_channel,
-			  int mc_dimm_number,
-			  int csrow,
-			  int cschannel,
+			  const unsigned long page_frame_number,
+			  const unsigned long offset_in_page,
+			  const unsigned long syndrome,
+			  const int layer0,
+			  const int layer1,
+			  const int layer2,
 			  const char *msg,
-			  const char *other_detail)
+			  const char *other_detail,
+			  const void *mcelog)
 {
 	unsigned long remapped_page;
-	/* FIXME: too much for stack. Move it to some pre-alocated area */
+	/* FIXME: too much for stack: move it to some pre-alocated area */
 	char detail[80 + strlen(other_detail)];
 	char label[(EDAC_MC_LABEL_LEN + 2) * mci->tot_dimms], *p;
 	char location[80];
+	int row = -1, chan = -1;
+	int pos[EDAC_MAX_LAYERS] = { layer0, layer1, layer2 };
 	int i;
 	u32 grain;
+	bool enable_filter = false;
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
 	/* Check if the event report is consistent */
-	if ((scope == HW_EVENT_SCOPE_MC_CSROW_CHANNEL) &&
-	    (cschannel >= mci->num_cschannel)) {
-		trace_mc_out_of_range(mci, "CE", "cs channel", cschannel,
-					0, mci->num_cschannel);
-		edac_mc_printk(mci, KERN_ERR,
-				"INTERNAL ERROR: cs channel out of range (%d >= %d)\n",
-				cschannel, mci->num_cschannel);
-		if (type == HW_EVENT_ERR_CORRECTED)
-			mci->err.ce_mc++;
-		else
-			mci->err.ue_mc++;
-		return;
-	} else {
-		cschannel = -1;
-	}
-
-	if ((scope <= HW_EVENT_SCOPE_MC_CSROW) &&
-	    (csrow >= mci->num_csrows)) {
-		trace_mc_out_of_range(mci, "CE", "csrow", csrow,
-					0, mci->num_csrows);
-		edac_mc_printk(mci, KERN_ERR,
-				"INTERNAL ERROR: csrow out of range (%d >= %d)\n",
-				csrow, mci->num_csrows);
-		if (type == HW_EVENT_ERR_CORRECTED)
-			mci->err.ce_mc++;
-		else
-			mci->err.ue_mc++;
-		return;
-	} else {
-		csrow = -1;
-	}
-
-	if ((scope <= HW_EVENT_SCOPE_MC_CSROW) &&
-	    (mc_dimm_number >= mci->num_dimm)) {
-		trace_mc_out_of_range(mci, "CE", "dimm_number",
-					mc_dimm_number, 0, mci->num_dimm);
-		edac_mc_printk(mci, KERN_ERR,
-				"INTERNAL ERROR: dimm_number out of range (%d >= %d)\n",
-				mc_dimm_number, mci->num_dimm);
-		if (type == HW_EVENT_ERR_CORRECTED)
-			mci->err.ce_mc++;
-		else
-			mci->err.ue_mc++;
-		return;
-	} else {
-		mc_dimm_number = -1;
-	}
-
-	if ((scope <= HW_EVENT_SCOPE_MC_CHANNEL) &&
-	    (mc_channel >= mci->num_dimm)) {
-		trace_mc_out_of_range(mci, "CE", "mc_channel",
-					mc_channel, 0, mci->num_dimm);
-		edac_mc_printk(mci, KERN_ERR,
-				"INTERNAL ERROR: mc_channel out of range (%d >= %d)\n",
-				mc_channel, mci->num_dimm);
-		if (type == HW_EVENT_ERR_CORRECTED)
-			mci->err.ce_mc++;
-		else
-			mci->err.ue_mc++;
-		return;
-	} else {
-		mc_channel = -1;
-	}
-
-	if ((scope <= HW_EVENT_SCOPE_MC_BRANCH) &&
-	    (mc_branch >= mci->num_branch)) {
-		trace_mc_out_of_range(mci, "CE", "branch",
-					mc_branch, 0, mci->num_branch);
-		edac_mc_printk(mci, KERN_ERR,
-				"INTERNAL ERROR: mc_branch out of range (%d >= %d)\n",
-				mc_branch, mci->num_branch);
-		if (type == HW_EVENT_ERR_CORRECTED)
-			mci->err.ce_mc++;
-		else
-			mci->err.ue_mc++;
-		return;
-	} else {
-		mc_branch = -1;
+	for (i = 0; i < mci->n_layers; i++) {
+		if (pos[i] >= mci->layers[i].size) {
+			if (type == HW_EVENT_ERR_CORRECTED) {
+				p = "CE";
+				mci->ce_mc++;
+			} else {
+				p = "UE";
+				mci->ue_mc++;
+			}
+			trace_mc_out_of_range(mci, p,
+					edac_layer_name[mci->layers[i].type],
+					pos[i], 0, mci->layers[i].size);
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
+		if (pos[i] > 0)
+			enable_filter = true;
 	}
 
 	/*
@@ -1134,50 +944,70 @@ void edac_mc_handle_error(enum hw_event_mc_err_type type,
 	 */
 	grain = 0;
 	p = label;
+	*p = '\0';
 	for (i = 0; i < mci->tot_dimms; i++) {
 		struct dimm_info *dimm = &mci->dimms[i];
 
-		if (mc_branch >= 0 && mc_branch != dimm->mc_branch)
+		if (layer0 >= 0 && layer0 != dimm->location[0])
 			continue;
-
-		if (mc_channel >= 0 && mc_channel != dimm->mc_channel)
+		if (layer1 >= 0 && layer1 != dimm->location[1])
 			continue;
-
-		if (mc_dimm_number >= 0 &&
-		    mc_dimm_number != dimm->mc_dimm_number)
-			continue;
-
-		if (csrow >= 0 && csrow != dimm->csrow)
-			continue;
-		if (cschannel >= 0 && cschannel != dimm->cschannel)
+		if (layer2 >= 0 && layer2 != dimm->location[2])
 			continue;
 
 		if (dimm->grain > grain)
 			grain = dimm->grain;
 
-		strcpy(p, dimm->label);
-		p[strlen(p)] = ' ';
-		p = p + strlen(p);
+		/*
+		 * If the error is memory-controller wide, there's no sense
+		 * on seeking for the affected DIMMs, as everything may be
+		 * affected.
+		 */
+		if (enable_filter) {
+			strcpy(p, dimm->label);
+			p[strlen(p)] = ' ';
+			p = p + strlen(p);
+			*p = '\0';
+
+			/*
+			 * get csrow/channel of the dimm, in order to allow
+			 * incrementing the compat API counters
+			 */
+			if (mci->layers[i].is_csrow) {
+				if (row == -1)
+					row = dimm->csrow;
+				else if (row >= 0 && row != dimm->csrow)
+					row = -2;
+			} else {
+				if (chan == -1)
+					chan = dimm->cschannel;
+				else if (chan >= 0 && chan != dimm->cschannel)
+					chan = -2;
+			}
+		}
+	}
+	if (!enable_filter) {
+		p = "any memory";
+	} else {
+		if (type == HW_EVENT_ERR_CORRECTED) {
+			if (row >= 0)
+				mci->csrows[row].ce_count++;
+			if (chan >= 0)
+				mci->csrows[row].channels[chan].ce_count++;
+		} else
+			if (row >= 0)
+				mci->csrows[row].ue_count++;
 	}
-	p[strlen(p)] = '\0';
 
 	/* Fill the RAM location data */
 	p = location;
-	if (mc_branch >= 0)
-		p += sprintf(p, "branch %d ", mc_branch);
-
-	if (mc_channel >= 0)
-		p += sprintf(p, "channel %d ", mc_channel);
-
-	if (mc_dimm_number >= 0)
-		p += sprintf(p, "dimm %d ", mc_dimm_number);
-
-	if (csrow >= 0)
-		p += sprintf(p, "csrow %d ", csrow);
-
-	if (cschannel >= 0)
-		p += sprintf(p, "cs_channel %d ", cschannel);
-
+	for (i = 0; i <= mci->n_layers; i++) {
+		if (pos[i] < 0)
+			continue;
+		p += sprintf(p, "%s %d ",
+			     edac_layer_name[mci->layers[i].type],
+			     pos[i]);
+	}
 
 	/* Memory type dependent details about the error */
 	if (type == HW_EVENT_ERR_CORRECTED)
@@ -1190,19 +1020,16 @@ void edac_mc_handle_error(enum hw_event_mc_err_type type,
 			"page 0x%lx offset 0x%lx grain %d\n",
 			page_frame_number, offset_in_page, grain);
 
-	trace_mc_error(type, mci->mc_idx, msg, label, mc_branch, mc_channel,
-		       mc_dimm_number, csrow, cschannel,
+	trace_mc_error(type, mci->mc_idx, msg, label, location,
 		       detail, other_detail);
 
 	if (type == HW_EVENT_ERR_CORRECTED) {
 		if (edac_mc_get_log_ce())
 			edac_mc_printk(mci, KERN_WARNING,
-				       "CE %s label \"%s\" (location: %d.%d.%d.%d.%d %s %s)\n",
-				       msg, label, mc_branch, mc_channel,
-				       mc_dimm_number, csrow, cschannel,
+				       "CE %s label \"%s\" (%s %s %s)\n",
+				       msg, label, location,
 				       detail, other_detail);
-		edac_increment_ce_error(scope, mci, mc_branch, mc_channel,
-					mc_dimm_number, csrow, cschannel);
+		edac_increment_ce_error(mci,enable_filter, pos);
 
 		if (mci->scrub_mode & SCRUB_SW_SRC) {
 			/*
@@ -1233,8 +1060,7 @@ void edac_mc_handle_error(enum hw_event_mc_err_type type,
 			panic("UE %s label \"%s\" (%s %s %s)\n",
 			      msg, label, location, detail, other_detail);
 
-		edac_increment_ue_error(scope, mci, mc_branch, mc_channel,
-					mc_dimm_number, csrow, cschannel);
+		edac_increment_ue_error(mci,enable_filter, pos);
 	}
 }
 EXPORT_SYMBOL_GPL(edac_mc_handle_error);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index a6f611f..245c588 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -132,17 +132,13 @@ static const char *edac_caps[] = {
 static ssize_t csrow_ue_count_show(struct csrow_info *csrow, char *data,
 				int private)
 {
-	struct mem_ctl_info *mci = csrow->mci;
-
-	return sprintf(data, "%u\n", mci->err.ue_csrow[csrow->csrow_idx]);
+	return sprintf(data, "%u\n", csrow->ue_count);
 }
 
 static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data,
 				int private)
 {
-	struct mem_ctl_info *mci = csrow->mci;
-
-	return sprintf(data, "%u\n", mci->err.ce_csrow[csrow->csrow_idx]);
+	return sprintf(data, "%u\n", csrow->ce_count);
 }
 
 static ssize_t csrow_size_show(struct csrow_info *csrow, char *data,
@@ -209,10 +205,7 @@ static ssize_t channel_dimm_label_store(struct csrow_info *csrow,
 static ssize_t channel_ce_count_show(struct csrow_info *csrow,
 				char *data, int channel)
 {
-	struct mem_ctl_info *mci = csrow->mci;
-	int index = csrow->csrow_idx * mci->num_cschannel + channel;
-
-	return sprintf(data, "%u\n", mci->err.ce_cschannel[index]);
+	return sprintf(data, "%u\n", csrow->channels[channel].ce_count);
 }
 
 /* csrow specific attribute structure */
@@ -478,22 +471,15 @@ static const struct sysfs_ops dimmfs_ops = {
 /* show/store functions for DIMM Label attributes */
 static ssize_t dimmdev_location_show(struct dimm_info *dimm, char *data)
 {
+	struct mem_ctl_info *mci = dimm->mci;
+	int i;
 	char *p = data;
 
-	if (dimm->mc_branch >= 0)
-		p += sprintf(p, "branch %d ", dimm->mc_branch);
-
-	if (dimm->mc_channel >= 0)
-		p += sprintf(p, "channel %d ", dimm->mc_channel);
-
-	if (dimm->mc_dimm_number >= 0)
-		p += sprintf(p, "dimm %d ", dimm->mc_dimm_number);
-
-	if (dimm->csrow >= 0)
-		p += sprintf(p, "csrow %d ", dimm->csrow);
-
-	if (dimm->cschannel >= 0)
-		p += sprintf(p, "cs_channel %d ", dimm->cschannel);
+	for (i = 0; i <= mci->n_layers; i++) {
+		p += sprintf(p, "%s %d ",
+			     edac_layer_name[mci->layers[i].type],
+			     dimm->location[i]);
+	}
 
 	return p - data;
 }
@@ -621,27 +607,29 @@ err_out:
 static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 					const char *data, size_t count)
 {
-	int num;
-	mci->err.ue_mc = 0;
-	mci->err.ce_mc = 0;
+	int cnt, row, chan, i;
+	mci->ue_mc = 0;
+	mci->ce_mc = 0;
 	mci->ue_noinfo_count = 0;
 	mci->ce_noinfo_count = 0;
 
-	num = mci->num_branch;
-	memset(mci->err.ue_branch, 0, num);
-	memset(mci->err.ce_branch, 0, num);
-	num *= mci->num_channel;
-	memset(mci->err.ue_channel, 0, num);
-	memset(mci->err.ce_channel, 0, num);
-	num *= mci->num_dimm;
-	memset(mci->err.ue_dimm, 0, num);
-	memset(mci->err.ce_dimm, 0, num);
-	num *= mci->num_csrows;
-	memset(mci->err.ue_csrow, 0, num);
-	memset(mci->err.ce_csrow, 0, num);
-	num *= mci->num_cschannel;
-	memset(mci->err.ue_cschannel, 0, num);
-	memset(mci->err.ce_cschannel, 0, num);
+
+	for (row = 0; row < mci->num_csrows; row++) {
+		struct csrow_info *ri = &mci->csrows[row];
+
+		ri->ue_count = 0;
+		ri->ce_count = 0;
+
+		for (chan = 0; chan < ri->nr_channels; chan++)
+			ri->channels[chan].ce_count = 0;
+	}
+
+	cnt = 1;
+	for (i = 0; i < mci->n_layers; i++) {
+		cnt *= mci->layers[i].size;
+		memset(mci->ce_per_layer[i], 0, cnt);
+		memset(mci->ue_per_layer[i], 0, cnt);
+	}
 
 	mci->start_time = jiffies;
 	return count;
@@ -700,12 +688,12 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
 /* default attribute files for the MCI object */
 static ssize_t mci_ue_count_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data, "%d\n", mci->err.ue_mc);
+	return sprintf(data, "%d\n", mci->ue_mc);
 }
 
 static ssize_t mci_ce_count_show(struct mem_ctl_info *mci, char *data)
 {
-	return sprintf(data, "%d\n", mci->err.ce_mc);
+	return sprintf(data, "%d\n", mci->ce_mc);
 }
 
 static ssize_t mci_ce_noinfo_show(struct mem_ctl_info *mci, char *data)
@@ -1172,11 +1160,18 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 		/* Only expose populated DIMMs */
 		if (dimm->nr_pages == 0)
 			continue;
-
-		debugf1("%s creating dimm%d, located at %d.%d.%d.%d.%d\n",
-			__func__, j, dimm->mc_branch, dimm->mc_channel,
-			dimm->mc_dimm_number, dimm->csrow, dimm->cschannel);
-
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
 		err = edac_create_dimm_object(mci, dimm, j);
 		if (err) {
 			debugf1("%s() failure: create dimm %d obj\n",
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index 77c06af..c366002 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -245,10 +245,9 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & I3000_ERRSTS_BITS) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
-				     -1, -1, -1, -1, -1,
-				     "UE overwrote CE", "");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1,
+				     "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
@@ -259,18 +258,15 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, pfn);
 
 	if (info->errsts & I3000_ERRSTS_UE)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     pfn, offset, 0,
-				     -1, -1, -1, row, -1,
-				     "i3000 UE", "");
+				     row, -1, -1,
+				     "i3000 UE", "", NULL);
 	else
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     pfn, offset, info->derrsyn,
-				     -1, -1, -1, row,
-				     multi_chan ? channel : 0,
-				     "i3000 CE", "");
+				     row, multi_chan ? channel : 0, -1,
+				     "i3000 CE", "", NULL);
 
 	return 1;
 }
@@ -317,6 +313,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	unsigned long last_cumul_size, nr_pages;
 	int interleaved, nr_channels;
 	unsigned char dra[I3000_RANKS / 2], drb[I3000_RANKS];
@@ -359,10 +356,13 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	interleaved = i3000_is_interleaved(c0dra, c1dra, c0drb, c1drb);
 	nr_channels = interleaved ? 2 : 1;
 
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    -1, -1, I3000_RANKS,
-			    I3000_RANKS / nr_channels, nr_channels,
-			    0);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I3000_RANKS / nr_channels;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_channels;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index 6f04a50..1233435 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -229,29 +229,25 @@ static void i3200_process_error_info(struct mem_ctl_info *mci,
 		return;
 
 	if ((info->errsts ^ info->errsts2) & I3200_ERRSTS_BITS) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
-				     -1, -1, -1, -1, -1,
-				     "UE overwrote CE", "");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1, "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
 	for (channel = 0; channel < nr_channels; channel++) {
 		log = info->eccerrlog[channel];
 		if (log & I3200_ECCERRLOG_UE) {
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-					     HW_EVENT_SCOPE_MC_CSROW, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 					     0, 0, 0,
-					     -1, -1, -1,
-					     eccerrlog_row(channel, log), -1,
-					     "i3000 UE", "");
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "i3000 UE", "", NULL);
 		} else if (log & I3200_ECCERRLOG_CE) {
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-					     HW_EVENT_SCOPE_MC_CSROW, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 					     0, 0, eccerrlog_syndrome(log),
-					     -1, -1, -1,
-					     eccerrlog_row(channel, log), -1,
-					     "i3000 UE", "");
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "i3000 UE", "", NULL);
 		}
 	}
 }
@@ -341,6 +337,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	u16 drbs[I3200_CHANNELS][I3200_RANKS_PER_CHANNEL];
 	bool stacked;
 	void __iomem *window;
@@ -355,10 +352,13 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	i3200_get_drbs(window, drbs);
 	nr_channels = how_many_channels(pdev);
 
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    -1, -1, I3200_DIMMS,
-			    I3200_RANKS, nr_channels,
-			    0);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I3200_DIMMS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_channels;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 5fec235..564fe09 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -537,11 +537,10 @@ static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
 		 bank, ras, cas, allErrors, specific);
 
 	/* Call the helper to output message */
-	edac_mc_handle_error(HW_EVENT_ERR_FATAL,
-			     HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
-			     branch >> 1, -1, rank, -1, -1,
+	edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 0, 0, 0,
+			     branch >> 1, -1, rank,
 			     rdwr ? "Write error" : "Read error",
-			     msg);
+			     msg, NULL);
 }
 
 /*
@@ -639,11 +638,10 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 			 rank, bank, ras, cas, ue_errors, specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
-				channel >> 1, -1, rank, -1, -1,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				channel >> 1, -1, rank,
 				rdwr ? "Write error" : "Read error",
-				msg);
+				msg, NULL);
 	}
 
 	/* Check correctable errors */
@@ -695,11 +693,10 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 			 specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				HW_EVENT_SCOPE_MC_CHANNEL, mci, 0, 0, 0,
-				channel >> 1, channel % 2, rank, -1, -1,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+				channel >> 1, channel % 2, rank,
 				rdwr ? "Write error" : "Read error",
-				msg);
+				msg, NULL);
 	}
 
 	if (!misc_messages)
@@ -742,10 +739,9 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 			 "Err=%#x (%s)", misc_errors, specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
-				branch >> 1, -1, -1, -1, -1,
-				"Misc error", msg);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+				branch >> 1, -1, -1,
+				"Misc error", msg, NULL);
 	}
 }
 
@@ -1357,10 +1353,10 @@ static void i5000_get_dimm_and_channel_counts(struct pci_dev *pdev,
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
@@ -1386,15 +1382,21 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	i5000_get_dimm_and_channel_counts(pdev, &num_dimms_per_channel,
 					&num_channels);
-	num_csrows = num_dimms_per_channel * 2;
 
-	debugf0("MC: %s(): Number of - Channels= %d  DIMMS= %d  CSROWS= %d\n",
-		__func__, num_channels, num_dimms_per_channel, num_csrows);
+	debugf0("MC: %s(): Number of Branches=2 Channels= %d  DIMMS= %d\n",
+		__func__, num_channels, num_dimms_per_channel);
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    2, num_channels, num_dimms_per_channel,
-			    num_csrows, num_channels, sizeof(*pvt));
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
index 24b03b8..d594170 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -426,11 +426,10 @@ static void i5100_handle_ce(struct mem_ctl_info *mci,
 		 "bank %u, cas %u, ras %u\n",
 		 bank, cas, ras);
 
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-			     HW_EVENT_SCOPE_MC_DIMM, mci,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 			     0, 0, syndrome,
-			     0, chan, rank, -1, -1,
-			     msg, detail);
+			     chan, rank, -1,
+			     msg, detail, NULL);
 }
 
 static void i5100_handle_ue(struct mem_ctl_info *mci,
@@ -449,11 +448,10 @@ static void i5100_handle_ue(struct mem_ctl_info *mci,
 		 "bank %u, cas %u, ras %u\n",
 		 bank, cas, ras);
 
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-			     HW_EVENT_SCOPE_MC_DIMM, mci,
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 			     0, 0, syndrome,
-			     0, chan, rank, -1, -1,
-			     msg, detail);
+			     chan, rank, -1,
+			     msg, detail, NULL);
 }
 
 static void i5100_read_log(struct mem_ctl_info *mci, int chan,
@@ -864,6 +862,7 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 {
 	int rc;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i5100_priv *priv;
 	struct pci_dev *ch0mm, *ch1mm;
 	int ret = 0;
@@ -924,9 +923,14 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 		goto bail_ch1;
 	}
 
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    1, 2, ranksperch,
-			    ranksperch * 2, 1, sizeof(*priv));
+	layers[0].type = EDAC_MC_LAYER_CHANNEL;
+	layers[0].size = 2;
+	layers[0].is_csrow = false;
+	layers[1].type = EDAC_MC_LAYER_SLOT;
+	layers[1].size = ranksperch;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+			    false, sizeof(*priv));
 	if (!mci) {
 		ret = -ENOMEM;
 		goto bail_disable_ch1;
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index c7455da..681e97a 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -571,11 +571,10 @@ static void i5400_proccess_non_recoverable_info(struct mem_ctl_info *mci,
 		 "Bank=%d Buffer ID = %d RAS=%d CAS=%d Err=0x%lx (%s)",
 		 bank, buf_id, ras, cas, allErrors, error_name[errnum]);
 
-	edac_mc_handle_error(tp_event,
-			     HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
-			     branch >> 1, -1, rank, -1, -1,
+	edac_mc_handle_error(tp_event, mci, 0, 0, 0,
+			     branch >> 1, -1, rank,
 			     rdwr ? "Write error" : "Read error",
-			     msg);
+			     msg, NULL);
 }
 
 /*
@@ -645,11 +644,10 @@ static void i5400_process_nonfatal_error_info(struct mem_ctl_info *mci,
 			 branch >> 1, bank, rdwr_str(rdwr), ras, cas,
 			 allErrors, error_name[errnum]);
 
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
-				     branch >> 1, channel % 2, rank, -1, -1,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+				     branch >> 1, channel % 2, rank,
 				     rdwr ? "Write error" : "Read error",
-				     msg);
+				     msg, NULL);
 
 		return;
 	}
@@ -1208,9 +1206,7 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
 	struct i5400_pvt *pvt;
-	int num_channels;
-	int num_dimms_per_channel;
-	int num_csrows;
+	struct edac_mc_layer layers[3];
 
 	if (dev_idx >= ARRAY_SIZE(i5400_devs))
 		return -EINVAL;
@@ -1224,24 +1220,17 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	if (PCI_FUNC(pdev->devfn) != 0)
 		return -ENODEV;
 
-	/* As we don't have a motherboard identification routine to determine
-	 * actual number of slots/dimms per channel, we thus utilize the
-	 * resource as specified by the chipset. Thus, we might have
-	 * have more DIMMs per channel than actually on the mobo, but this
-	 * allows the driver to support up to the chipset max, without
-	 * some fancy mobo determination.
-	 */
-	num_dimms_per_channel = MAX_DIMMS_PER_CHANNEL;
-	num_channels = MAX_CHANNELS;
-	num_csrows = num_dimms_per_channel;
-
-	debugf0("MC: %s(): Number of - Channels= %d  DIMMS= %d  CSROWS= %d\n",
-		__func__, num_channels, num_dimms_per_channel, num_csrows);
-
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    2, num_channels, num_dimms_per_channel,
-			    num_csrows, num_channels, sizeof(*pvt));
+	layers[0].type = EDAC_MC_LAYER_BRANCH;
+	layers[0].size = 2;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = MAX_CHANNELS;
+	layers[1].is_csrow = false;
+	layers[2].type = EDAC_MC_LAYER_SLOT;
+	layers[2].size = MAX_DIMMS_PER_CHANNEL;
+	layers[2].is_csrow = true;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
@@ -1252,8 +1241,8 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 
 	pvt = mci->pvt_info;
 	pvt->system_address = pdev;	/* Record this device in our private */
-	pvt->maxch = num_channels;
-	pvt->maxdimmperch = num_dimms_per_channel;
+	pvt->maxch = MAX_CHANNELS;
+	pvt->maxdimmperch = MAX_DIMMS_PER_CHANNEL;
 
 	/* 'get' the pci devices we want to reserve for our use */
 	if (i5400_get_devices(mci, dev_idx))
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 33f9ac2..7b9c848 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -467,11 +467,10 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 			 "Bank=%d RAS=%d CAS=%d Err=0x%lx (%s))",
 			 bank, ras, cas, errors, specific);
 
-		edac_mc_handle_error(HW_EVENT_ERR_FATAL,
-				     HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0, 0,
-				     branch, -1, rank, -1, -1,
+		edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 0, 0, 0,
+				     branch, -1, rank,
 				     is_wr ? "Write error" : "Read error",
-				     pvt->tmp_prt_buffer);
+				     pvt->tmp_prt_buffer, NULL);
 
 	}
 
@@ -514,12 +513,11 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 			 "DRAM-Bank=%d RAS=%d CAS=%d, Err=0x%lx (%s))",
 			 bank, ras, cas, errors, specific);
 
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_BRANCH, mci, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0,
 				     syndrome,
-				     branch >> 1, channel % 2, rank, -1, -1,
+				     branch >> 1, channel % 2, rank,
 				     is_wr ? "Write error" : "Read error",
-				     pvt->tmp_prt_buffer);
+				     pvt->tmp_prt_buffer, NULL);
 	}
 	return;
 }
@@ -1027,10 +1025,8 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
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
@@ -1047,25 +1043,17 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
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
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    MAX_BRANCHES, num_channels / MAX_BRANCHES,
-			    num_dimms_per_channel,
-			    num_csrows, num_channels, sizeof(*pvt));
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
index f63c0f4..ce75892 100644
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
-	int csrow = 0, cschannel = 0;
 	enum edac_type mode;
 	enum mem_type mtype;
 
@@ -712,16 +610,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 
 			npages = MiB_TO_PAGES(size);
 
-			pvt->csrow_map[i][j] = csrow;
-
-			csr = &mci->csrows[csrow];
-			csr->channels[cschannel].dimm = dimm;
-			cschannel++;
-			if (cschannel >= MAX_DIMMS) {
-				cschannel = 0;
-				csrow++;
-			}
-
 			dimm->nr_pages = npages;
 
 			switch (banks) {
@@ -744,7 +632,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			dimm->grain = 8;
 			dimm->edac_mode = mode;
 			dimm->mtype = mtype;
-			csrow++;
 		}
 
 		pci_read_config_dword(pdev, MC_SAG_CH_0, &value[0]);
@@ -763,17 +650,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 				(value[j] & ((1 << 24) - 1)));
 	}
 
-	/* Clears the unused data */
-	while (csrow < NUM_CHANS && cschannel < MAX_DIMMS) {
-		csr = &mci->csrows[csrow];
-		csr->channels[cschannel].dimm = NULL;
-		cschannel++;
-		if (cschannel >= MAX_DIMMS) {
-			cschannel = 0;
-			csrow++;
-		}
-	}
-
 	return 0;
 }
 
@@ -1571,7 +1447,7 @@ error:
 /****************************************************************************
 			Error check routines
  ****************************************************************************/
-static void i7core_rdimm_update_csrow(struct mem_ctl_info *mci,
+static void i7core_rdimm_update_errcount(struct mem_ctl_info *mci,
 				      const int chan,
 				      const int dimm,
 				      const int add)
@@ -1579,11 +1455,8 @@ static void i7core_rdimm_update_csrow(struct mem_ctl_info *mci,
 	int i;
 
 	for (i = 0; i < add; i++) {
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_DIMM, mci,
-				     0, 0, 0,
-				     0, chan, dimm, -1, -1,
-				     "error", "");
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+				     chan, dimm, -1, "error", "", NULL);
 	}
 }
 
@@ -1624,11 +1497,11 @@ static void i7core_rdimm_update_ce_count(struct mem_ctl_info *mci,
 
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
 
@@ -1759,7 +1632,6 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 	u32 channel = (m->misc >> 18) & 0x3;
 	u32 syndrome = m->misc >> 32;
 	u32 errnum = find_first_bit(&error, 32);
-	int csrow;
 
 	if (uncorrected_error) {
 		if (ripv) {
@@ -1832,21 +1704,18 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 		(long long) m->addr, m->cpu, core_err_cnt,
 		(long long)m->status, (long long)m->misc, optype, err);
 
-	csrow = pvt->csrow_map[channel][dimm];
-
 	/*
 	 * Call the helper to output message
 	 * FIXME: what to do if core_err_cnt > 1? Currently, it generates
 	 * only one event
 	 */
 	if (uncorrected_error || !pvt->is_registered)
-		edac_mc_handle_error(tp_event,
-				     HW_EVENT_SCOPE_MC_DIMM, mci,
+		edac_mc_handle_error(tp_event, mci,
 				     m->addr >> PAGE_SHIFT,
 				     m->addr & ~PAGE_MASK,
 				     syndrome,
-				     0, channel, dimm, -1, -1,
-				     err, msg);
+				     channel, dimm, -1,
+				     err, msg, m);
 
 	kfree(msg);
 }
@@ -2265,18 +2134,19 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
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
 
-	mci = edac_mc_alloc(EDAC_ALLOC_FILL_PRIV, i7core_dev->socket,
-			    1, NUM_CHANS, MAX_DIMMS,
-			    MAX_DIMMS, NUM_CHANS, sizeof(*pvt));
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
index 0992549..09d39c0 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -156,23 +156,19 @@ static int i82443bxgx_edacmc_process_error_info(struct mem_ctl_info *mci,
 	if (info->eap & I82443BXGX_EAP_OFFSET_SBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
-					     mci, page, pageoffset, 0,
-					     -1, -1, -1,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     page, pageoffset, 0,
 					     edac_mc_find_csrow_by_page(mci, page),
-					     0, mci->ctl_name, 0);
+					     0, -1, mci->ctl_name, "", NULL);
 	}
 
 	if (info->eap & I82443BXGX_EAP_OFFSET_MBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
-					     mci, page, pageoffset, 0,
-					     -1, -1, -1,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     page, pageoffset, 0,
 					     edac_mc_find_csrow_by_page(mci, page),
-					     0, mci->ctl_name, 0);
+					     0, -1, mci->ctl_name, "", NULL);
 	}
 
 	return error_found;
@@ -239,6 +235,7 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	u8 dramc;
 	u32 nbxcfg, ecc_mode;
 	enum mem_type mtype;
@@ -252,10 +249,13 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	if (pci_read_config_dword(pdev, I82443BXGX_NBXCFG, &nbxcfg))
 		return -EIO;
 
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    0, 0, I82443BXGX_NR_CSROWS,
-			    I82443BXGX_NR_CSROWS, I82443BXGX_NR_CHANS, 0);
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
index 3ab8a7a..85ed3a6 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -109,10 +109,8 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
-				     -1, -1, -1, -1, -1,
-				     "UE overwrote CE", "");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1, "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
@@ -121,19 +119,15 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 	dimm = mci->csrows[row].channels[0].dimm;
 
 	if (info->errsts & 0x0002)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC_DIMM, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     info->eap, 0, 0,
-				     dimm->mc_branch, dimm->mc_channel,
-				     dimm->mc_dimm_number, -1, -1,
-				     "i82860 UE", "");
+				     dimm->location[0], dimm->location[1], -1,
+				     "i82860 UE", "", NULL);
 	else
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC_DIMM, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     info->eap, 0, info->derrsyn,
-				     dimm->mc_branch, dimm->mc_channel,
-				     dimm->mc_dimm_number, -1, -1,
-				     "i82860 CE", "");
+				     dimm->location[0], dimm->location[1], -1,
+				     "i82860 CE", "", NULL);
 
 	return 1;
 }
@@ -193,6 +187,7 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i82860_error_info discard;
 
 	/*
@@ -205,12 +200,13 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 	 * the channel and the GRA registers map to physical devices so we are
 	 * going to make 1 channel for group.
 	 */
-
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    1, 2 /* channels */, 8 /* sticks per channel */,
-			    16, 1,
-			    0);
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
index 74afaba..471b26a 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -236,10 +236,9 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0081) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
-				     -1, -1, -1, -1, -1,
-				     "UE overwrote CE", "");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1,
+				     "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
@@ -247,18 +246,15 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, info->eap);
 
 	if (info->errsts & 0x0080)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     info->eap, 0, 0,
-				     -1, -1, -1, row, -1,
-				     "i82875p UE", "");
+				     row, -1, -1,
+				     "i82875p UE", "", NULL);
 	else
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     info->eap, 0, info->derrsyn,
-				     -1, -1, -1, row,
-				     multi_chan ? (info->des & 0x1) : 0,
-				     "i82875p CE", "");
+				     row, multi_chan ? (info->des & 0x1) : 0,
+				     -1, "i82875p CE", "", NULL);
 
 	return 1;
 }
@@ -401,6 +397,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc = -ENODEV;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i82875p_pvt *pvt;
 	struct pci_dev *ovrfl_pdev;
 	void __iomem *ovrfl_window;
@@ -416,10 +413,14 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENODEV;
 	drc = readl(ovrfl_window + I82875P_DRC);
 	nr_chans = dual_channel_active(drc) + 1;
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    -1, -1, I82875P_NR_DIMMS,
-			    I82875P_NR_CSROWS(nr_chans), nr_chans,
-			    sizeof(*pvt));
+
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
index 33feeba..c0a683a 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -290,10 +290,8 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
-				     -1, -1, -1, -1, -1,
-				     "UE overwrote CE", "");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1,"UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
@@ -307,18 +305,15 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, page);
 
 	if (info->errsts & 0x0002)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offst, 0,
-				     -1, -1, -1, row, -1,
-				     "i82975x UE", "");
+				     row, -1, -1,
+				     "i82975x UE", "", NULL);
 	else
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     page, offst, info->derrsyn,
-				     -1, -1, -1, row,
-				     multi_chan ? chan : 0,
-				     "i82975x CE", "");
+				     row, multi_chan ? chan : 0, -1,
+				     "i82975x CE", "", NULL);
 
 	return 1;
 }
@@ -476,6 +471,7 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc = -ENODEV;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i82975x_pvt *pvt;
 	void __iomem *mch_window;
 	u32 mchbar;
@@ -544,10 +540,13 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	chans = dual_channel_active(mch_window) + 1;
 
 	/* assuming only one controller, index thus is 0 */
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    -1, -1, I82975X_NR_DIMMS,
-			    I82975X_NR_CSROWS(chans), chans,
-			    sizeof(*pvt));
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
index f7c3a67..d074b71 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -854,18 +854,16 @@ static void mpc85xx_mc_check(struct mem_ctl_info *mci)
 		mpc85xx_mc_printk(mci, KERN_ERR, "PFN out of range!\n");
 
 	if (err_detect & DDR_EDE_SBE)
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     pfn, err_addr & ~PAGE_MASK, syndrome,
-				     -1, -1, -1, row_index, 0,
-				     mci->ctl_name, "");
+				     row_index, 0, -1,
+				     mci->ctl_name, "", NULL);
 
 	if (err_detect & DDR_EDE_MBE)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     pfn, err_addr & ~PAGE_MASK, syndrome,
-				     -1, -1, -1, row_index, 0,
-				     mci->ctl_name, "");
+				     row_index, 0, -1,
+				     mci->ctl_name, "", NULL);
 
 	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, err_detect);
 }
@@ -967,6 +965,7 @@ static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
 static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct mpc85xx_mc_pdata *pdata;
 	struct resource r;
 	u32 sdram_ctl;
@@ -975,8 +974,14 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	if (!devres_open_group(&op->dev, mpc85xx_mc_err_probe, GFP_KERNEL))
 		return -ENOMEM;
 
-	mci = edac_mc_alloc(edac_mc_idx, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    0, 0, 4, 4, 1, sizeof(*pdata));
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
@@ -1165,7 +1170,6 @@ static void __init mpc85xx_mc_clear_rfxe(void *data)
 static int __init mpc85xx_mc_init(void)
 {
 	int res = 0;
-	u32 pvr = 0;
 
 	printk(KERN_INFO "Freescale(R) MPC85xx EDAC driver, "
 	       "(C) 2006 Montavista Software\n");
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 96a675a..a32e9b6 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -611,19 +611,17 @@ static void mv64x60_mc_check(struct mem_ctl_info *mci)
 
 	/* first bit clear in ECC Err Reg, 1 bit error, correctable by HW */
 	if (!(reg & 0x1))
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     err_addr >> PAGE_SHIFT,
 				     err_addr & PAGE_MASK, syndrome,
-				     -1, -1, -1, 0, 0,
-				     mci->ctl_name, "");
+				     0, 0, -1,
+				     mci->ctl_name, "", NULL);
 	else	/* 2 bit error, UE */
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     err_addr >> PAGE_SHIFT,
 				     err_addr & PAGE_MASK, 0,
-				     -1, -1, -1, 0, 0,
-				     mci->ctl_name, "");
+				     0, 0, -1,
+				     mci->ctl_name, "", NULL);
 
 	/* clear the error */
 	out_le32(pdata->mc_vbase + MV64X60_SDRAM_ERR_ADDR, 0);
@@ -702,6 +700,7 @@ static void mv64x60_init_csrows(struct mem_ctl_info *mci,
 static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct mv64x60_mc_pdata *pdata;
 	struct resource *r;
 	u32 ctl;
@@ -710,9 +709,14 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	if (!devres_open_group(&pdev->dev, mv64x60_mc_err_probe, GFP_KERNEL))
 		return -ENOMEM;
 
-	mci = edac_mc_alloc(edac_mc_idx, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    0, 0, 1,
-			    1, 1, sizeof(struct mv64x60_mc_pdata));
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
index 0d0a545..2959db6 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -110,20 +110,16 @@ static void pasemi_edac_process_error_info(struct mem_ctl_info *mci, u32 errsta)
 	/* uncorrectable/multi-bit errors */
 	if (errsta & (MCDEBUG_ERRSTA_MBE_STATUS |
 		      MCDEBUG_ERRSTA_RFL_STATUS)) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     mci->csrows[cs].first_page, 0, 0,
-				     -1, -1, -1, cs, 0,
-				     mci->ctl_name, "");
+				     cs, 0, -1, mci->ctl_name, "", NULL);
 	}
 
 	/* correctable/single-bit errors */
 	if (errsta & MCDEBUG_ERRSTA_SBE_STATUS)
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     mci->csrows[cs].first_page, 0, 0,
-				     -1, -1, -1, cs, 0,
-				     mci->ctl_name, "");
+				     cs, 0, -1, mci->ctl_name, "", NULL);
 }
 
 static void pasemi_edac_check(struct mem_ctl_info *mci)
@@ -196,6 +192,7 @@ static int __devinit pasemi_edac_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
 {
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	u32 errctl1, errcor, scrub, mcen;
 
 	pci_read_config_dword(pdev, MCCFG_MCEN, &mcen);
@@ -212,10 +209,14 @@ static int __devinit pasemi_edac_probe(struct pci_dev *pdev,
 		MCDEBUG_ERRCTL1_RFL_LOG_EN;
 	pci_write_config_dword(pdev, MCDEBUG_ERRCTL1, errctl1);
 
-	mci = edac_mc_alloc(system_mmc_id++, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    0, 0, PASEMI_EDAC_NR_CSROWS,
-			    PASEMI_EDAC_NR_CSROWS, PASEMI_EDAC_NR_CHANS, 0);
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
index 2e393cb..89ffc39 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -214,7 +214,7 @@ static struct platform_driver ppc4xx_edac_driver = {
  * TODO: The row and channel parameters likely need to be dynamically
  * set based on the aforementioned variant controller realizations.
  */
-static const unsigned ppc4xx_edac_num_csrows = 2;
+static const unsigned ppc4xx_edac_nr_csrows = 2;
 static const unsigned ppc4xx_edac_nr_chans = 1;
 
 /*
@@ -727,10 +727,10 @@ ppc4xx_edac_handle_ce(struct mem_ctl_info *mci,
 
 	for (row = 0; row < mci->num_csrows; row++)
 		if (ppc4xx_edac_check_bank_error(status, row))
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-					     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
-					     -1, -1, -1, -1, -1,
-					     message, "");
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     0, 0, 0,
+					     row, 0, -1,
+					     message, "", NULL);
 }
 
 /**
@@ -758,11 +758,10 @@ ppc4xx_edac_handle_ue(struct mem_ctl_info *mci,
 
 	for (row = 0; row < mci->num_csrows; row++)
 		if (ppc4xx_edac_check_bank_error(status, row))
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-					     HW_EVENT_SCOPE_MC, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 					     page, offset, 0,
-					     -1, -1, -1, -1, -1,
-					     message, "");
+					     row, 0, -1,
+					     message, "", NULL);
 }
 
 /**
@@ -1240,6 +1239,7 @@ static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 	dcr_host_t dcr_host;
 	const struct device_node *np = op->dev.of_node;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	static int ppc4xx_edac_instance;
 
 	/*
@@ -1285,14 +1285,14 @@ static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 	 * controller instance and perform the appropriate
 	 * initialization.
 	 */
-
-	mci = edac_mc_alloc(ppc4xx_edac_instance,
-			    EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    0, 0, ppc4xx_edac_num_csrows * ppc4xx_edac_nr_chans,
-			    ppc4xx_edac_num_csrows,
-			    ppc4xx_edac_nr_chans,
-			    sizeof(struct ppc4xx_edac_pdata));
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
index 214bc48..f820c14 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -179,13 +179,11 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 		error_found = 1;
 
 		if (handle_errors)
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
-					     mci, page, 0, syndrome,
-					     -1, -1, -1,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     page, 0, syndrome,
 					     edac_mc_find_csrow_by_page(mci, page),
-					     0,
-					     mci->ctl_name, "");
+					     0, -1,
+					     mci->ctl_name, "", NULL);
 	}
 
 	if (info->eapr & BIT(1)) {	/* UE? */
@@ -193,13 +191,11 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors)
 			/* 82600 doesn't give enough info */
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-					     HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
-					     mci, page, 0, 0,
-					     -1, -1, -1,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     page, 0, 0,
 					     edac_mc_find_csrow_by_page(mci, page),
-					     0,
-					     mci->ctl_name, "");
+					     0, -1,
+					     mci->ctl_name, "", NULL);
 	}
 
 	return error_found;
@@ -274,6 +270,7 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	u8 dramcr;
 	u32 eapr;
 	u32 scrub_disabled;
@@ -288,11 +285,13 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	debugf2("%s(): sdram refresh rate = %#0x\n", __func__,
 		sdram_refresh_rate);
 	debugf2("%s(): DRAMC register = %#0x\n", __func__, dramcr);
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    -1, -1, R82600_NR_DIMMS,
-			    R82600_NR_CSROWS, R82600_NR_CHANS,
-			    0);
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
index 5df6ade..4745c94 100644
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
@@ -522,41 +505,13 @@ static int sbridge_get_active_channels(const u8 bus, unsigned *channels,
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
 	int i, j, banks, ranks, rows, cols, size, npages;
-	int csrow = 0;
-	unsigned long last_page = 0;
 	u32 reg;
 	enum edac_type mode;
 	enum mem_type mtype;
@@ -635,16 +590,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
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
 				dimm->grain = 32;
 				dimm->dtype = (banks == 8) ? DEV_X8 : DEV_X4;
@@ -1397,7 +1342,7 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	u32 optypenum = GET_BITFIELD(m->status, 4, 6);
 	long channel_mask, first_channel;
 	u8  rank, socket;
-	int csrow, rc, dimm;
+	int rc, dimm;
 	char *area_type = "Unknown";
 
 	if (uncorrected_error) {
@@ -1470,8 +1415,6 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	else
 		dimm = 2;
 
-	csrow = pvt->csrow_map[first_channel][dimm];
-
 	if (uncorrected_error && recoverable)
 		recoverable_msg = " recoverable";
 	else
@@ -1501,17 +1444,15 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	/* FIXME: need support for channel mask */
 
 	/* Call the helper to output message */
-	edac_mc_handle_error(tp_event,
-			     HW_EVENT_SCOPE_MC_DIMM, mci,
+	edac_mc_handle_error(tp_event, mci,
 			     m->addr >> PAGE_SHIFT, m->addr & ~PAGE_MASK, 0,
-			     0, channel, dimm, -1, -1,
-			     optype, msg);
+			     channel, dimm, -1,
+			     optype, msg, m);
 	return;
 err_parsing:
-	edac_mc_handle_error(tp_event,
-			     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
-			     -1, -1, -1, -1, -1,
-			     msg, "");
+	edac_mc_handle_error(tp_event, mci, 0, 0, 0,
+			     -1, -1, -1,
+			     msg, "", m);
 
 }
 
@@ -1674,18 +1615,25 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct sbridge_pvt *pvt;
-	int rc, channels, dimms;
+	int rc;
 
 	/* Check the number of active and not disabled channels */
-	rc = sbridge_get_active_channels(sbridge_dev->bus, &channels, &dimms);
+	rc = check_if_ecc_is_active(sbridge_dev->bus);
 	if (unlikely(rc < 0))
 		return rc;
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    1, channels, dimms,
-			    dimms, channels, sizeof(*pvt));
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
index 19ac19e..9a91826 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -71,11 +71,10 @@ static void tile_edac_check(struct mem_ctl_info *mci)
 	if (mem_error.sbe_count != priv->ce_count) {
 		dev_dbg(mci->dev, "ECC CE err on node %d\n", priv->node);
 		priv->ce_count = mem_error.sbe_count;
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-				     HW_EVENT_SCOPE_MC_CSROW_CHANNEL, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     0, 0, 0,
-				     -1, -1, -1, 0, 0,
-				     mci->ctl_name, "");
+				     0, 0, -1,
+				     mci->ctl_name, "", NULL);
 	}
 }
 
@@ -126,6 +125,7 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 	char			hv_file[32];
 	int			hv_devhdl;
 	struct mem_ctl_info	*mci;
+	struct edac_mc_layer	layers[2];
 	struct tile_edac_priv	*priv;
 	int			rc;
 
@@ -135,9 +135,13 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	/* A TILE MC has a single channel and one chip-select row. */
-	mci = edac_mc_alloc(pdev->id, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    0, 0, TILE_EDAC_NR_CSROWS,
-			    TILE_EDAC_NR_CSROWS, TILE_EDAC_NR_CHANS,
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = TILE_EDAC_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = TILE_EDAC_NR_CHANS;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false,
 			    sizeof(struct tile_edac_priv));
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 27cf304..5f3c57f 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -215,29 +215,26 @@ static void x38_process_error_info(struct mem_ctl_info *mci,
 		return;
 
 	if ((info->errsts ^ info->errsts2) & X38_ERRSTS_BITS) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-				     HW_EVENT_SCOPE_MC, mci, 0, 0, 0,
-				     -1, -1, -1, -1, -1,
-				     "UE overwrote CE", "");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1,
+				     "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
 	for (channel = 0; channel < x38_channel_num; channel++) {
 		log = info->eccerrlog[channel];
 		if (log & X38_ECCERRLOG_UE) {
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED,
-					     HW_EVENT_SCOPE_MC_CSROW, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 					     0, 0, 0,
-					     -1, -1, -1,
-					     eccerrlog_row(channel, log), -1,
-					     "x38 UE", "");
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "x38 UE", "", NULL);
 		} else if (log & X38_ECCERRLOG_CE) {
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED,
-					     HW_EVENT_SCOPE_MC_CSROW, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 					     0, 0, eccerrlog_syndrome(log),
-					     -1, -1, -1,
-					     eccerrlog_row(channel, log), -1,
-					     "x38 CE", "");
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "x38 CE", "", NULL);
 		}
 	}
 }
@@ -329,6 +326,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	u16 drbs[X38_CHANNELS][X38_RANKS_PER_CHANNEL];
 	bool stacked;
 	void __iomem *window;
@@ -344,10 +342,13 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	how_many_channel(pdev);
 
 	/* FIXME: unconventional pvt_info usage */
-	mci = edac_mc_alloc(0, EDAC_ALLOC_FILL_CSROW_CSCHANNEL,
-			    -1, -1, X38_RANKS,
-			    X38_RANKS, x38_channel_num,
-			    0);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = X38_RANKS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = x38_channel_num;
+	layers[1].is_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 1d707f4..4d84e40 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -206,41 +206,6 @@ enum hw_event_mc_err_type {
 };
 
 /**
- * enum hw_event_error_scope - escope of a memory error
- *
- * @HW_EVENT_ERR_MC:		error can be anywhere inside the MC
- * @HW_EVENT_SCOPE_MC_BRANCH:	error can be on any DIMM inside the branch
- * @HW_EVENT_SCOPE_MC_CHANNEL:	error can be on any DIMM inside the MC channel
- * @HW_EVENT_SCOPE_MC_DIMM:	error is on a specific DIMM
- * @HW_EVENT_SCOPE_MC_CSROW:	error can be on any DIMM inside the csrow
- * @HW_EVENT_SCOPE_MC_CSROW_CHANNEL: error is on a CSROW channel
- *
- * Depending on the error detection algorithm, the memory topology and even
- * the MC capabilities, some errors can't be attributed to just one DIMM, but
- * to a group of memory sockets. Depending on where the error occurs, the
- * EDAC core will increment the corresponding error count for that entity,
- * and the upper entities. For example, assuming a system with 1 memory
- * controller 2 branches, 2 MC channels and 4 DIMMS on it, if an error
- * happens at channel 0, the error counts for channel 0, for branch 0 and
- * for the memory controller 0 will be incremented. The DIMM error counts won't
- * be incremented, as, in this example, the driver can't be 100% sure on what
- * memory the error actually occurred.
- *
- * The order here is important, as edac_mc_handle_error() will use it, in order
- * to check what parameters will be used. The smallest number should be
- * the hole memory controller, and the last one should be the more
- * fine-grained detail, e. g.: DIMM.
- */
-enum hw_event_error_scope {
-	HW_EVENT_SCOPE_MC,
-	HW_EVENT_SCOPE_MC_BRANCH,
-	HW_EVENT_SCOPE_MC_CHANNEL,
-	HW_EVENT_SCOPE_MC_DIMM,
-	HW_EVENT_SCOPE_MC_CSROW,
-	HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
-};
-
-/**
  * enum mem_type - Type of the memory stick
  *
  * @MEM_EMPTY		Empty csrow
@@ -423,16 +388,51 @@ enum scrub_type {
 #define OP_RUNNING_POLL_INTR	0x203
 #define OP_OFFLINE		0x300
 
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
+	unsigned 		size;
+	bool			is_csrow;
+};
+
+/*
+ * Maximum number of layers used by the memory controller to uniquelly
+ * identify a single memory stick.
+ * NOTE: change it also requires changing edac_mc_handle_error()
+ */
+#define EDAC_MAX_LAYERS		3
+
 /* FIXME: add the proper per-location error counts */
 struct dimm_info {
 	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
 
 	/* Memory location data */
-	int mc_branch;
-	int mc_channel;
-	int mc_dimm_number;
-	int csrow;
-	int cschannel;
+	unsigned location[EDAC_MAX_LAYERS];
 
 	struct kobject kobj;		/* sysfs kobject for this csrow */
 	struct mem_ctl_info *mci;	/* the parent */
@@ -442,13 +442,17 @@ struct dimm_info {
 	enum mem_type mtype;	/* memory dimm type */
 	enum edac_type edac_mode;	/* EDAC mode for this dimm */
 
-	u32 nr_pages;			/* number of pages in csrow */
+	u32 nr_pages;			/* number of pages on this dimm */
+
+	unsigned csrow, cschannel;	/* Points to the old API data */
 };
 
 struct csrow_channel_info {
 	int chan_idx;		/* channel index */
 	struct dimm_info *dimm;
 	struct csrow_info *csrow;	/* the parent */
+
+	u32 ce_count;		/* Correctable Errors for this csrow */
 };
 
 struct csrow_info {
@@ -460,6 +464,9 @@ struct csrow_info {
 	unsigned long page_mask;	/* used for interleaving -
 					 * 0UL for non intlv */
 
+	u32 ue_count;		/* Uncorrectable Errors for this csrow */
+	u32 ce_count;		/* Correctable Errors for this csrow */
+
 	struct mem_ctl_info *mci;	/* the parent */
 
 	struct kobject kobj;	/* sysfs kobject for this csrow */
@@ -497,22 +504,9 @@ struct mcidev_sysfs_attribute {
         ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
 };
 
-/*
- * Error counters for all possible memory arrangements
- */
-struct error_counts {
-	u32 ce_mc;
-	u32 *ce_branch;
-	u32 *ce_channel;
-	u32 *ce_dimm;
-	u32 *ce_csrow;
-	u32 *ce_cschannel;
-	u32 ue_mc;
-	u32 *ue_branch;
-	u32 *ue_channel;
-	u32 *ue_dimm;
-	u32 *ue_csrow;
-	u32 *ue_cschannel;
+struct edac_hierarchy {
+	char		*name;
+	unsigned	nr;
 };
 
 /* MEMORY controller information structure
@@ -560,14 +554,11 @@ struct mem_ctl_info {
 					   unsigned long page);
 	int mc_idx;
 	struct csrow_info *csrows;
+	unsigned num_csrows, num_cschannel;
 
-	/* Number of allocated memory location data */
-	unsigned num_branch;
-	unsigned num_channel;
-	unsigned num_dimm;
-	unsigned num_csrows;
-	unsigned num_cschannel;
-
+	/* Memory Controller hierarchy */
+	unsigned n_layers;
+	struct edac_mc_layer *layers;
 	/*
 	 * DIMM info. Will eventually remove the entire csrows_info some day
 	 */
@@ -589,8 +580,9 @@ struct mem_ctl_info {
 	unsigned long start_time;	/* mci load start time (in jiffies) */
 
 	/* drivers shouldn't access this struct directly */
-	struct error_counts err;
 	unsigned ce_noinfo_count, ue_noinfo_count;
+	unsigned ce_mc, ue_mc;
+	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
 
 	struct completion complete;
 
diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
index cbec44a..4c455c1 100644
--- a/include/trace/events/hw_event.h
+++ b/include/trace/events/hw_event.h
@@ -58,54 +58,41 @@ TRACE_EVENT(mc_error,
 		 const unsigned int mc_index,
 		 const char *msg,
 		 const char *label,
-		 const int branch,
-		 const int channel,
-		 const int dimm,
-		 const int csrow,
-		 const int cschannel,
+		 const char *location,
 		 const char *detail,
 		 const char *driver_detail),
 
-	TP_ARGS(err_type, mc_index, msg, label, branch, channel, dimm, csrow,
-		cschannel, detail, driver_detail),
+	TP_ARGS(err_type, mc_index, msg, label, location,
+		detail, driver_detail),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	err_type		)
 		__field(	unsigned int,	mc_index		)
-		__field(	int,		branch			)
-		__field(	int,		channel			)
-		__field(	int,		dimm			)
-		__field(	int,		csrow			)
-		__field(	int,		cschannel		)
 		__string(	msg,		msg			)
 		__string(	label,		label			)
 		__string(	detail,		detail			)
+		__string(	location,	location		)
 		__string(	driver_detail,	driver_detail		)
 	),
 
 	TP_fast_assign(
 		__entry->err_type		= err_type;
 		__entry->mc_index		= mc_index;
-		__entry->branch			= branch;
-		__entry->channel		= channel;
-		__entry->dimm			= dimm;
-		__entry->csrow			= csrow;
-		__entry->cschannel		= cschannel;
 		__assign_str(msg, msg);
 		__assign_str(label, label);
+		__assign_str(location, location);
 		__assign_str(detail, detail);
 		__assign_str(driver_detail, driver_detail);
 	),
 
-	TP_printk(HW_ERR "mce#%d: %s error %s on label \"%s\" (location %d.%d.%d.%d.%d %s %s)\n",
+	TP_printk(HW_ERR "mce#%d: %s error %s on label \"%s\" (%s %s %s)\n",
 		  __entry->mc_index,
 		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
 			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
 			"Fatal" : "Uncorrected"),
 		  __get_str(msg),
 		  __get_str(label),
-		  __entry->branch, __entry->channel, __entry->dimm,
-		  __entry->csrow, __entry->cschannel,
+		  __get_str(location),
 		  __get_str(detail),
 		  __get_str(driver_detail))
 );
-- 
1.7.8

