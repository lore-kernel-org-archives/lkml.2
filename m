Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2DPUV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:21:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab2DPUVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:54 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [EDAC_ABI PATCH v13 23/26] sb_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:42 -0300
Message-Id: <1334607705-30320-24-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/sb_edac.c |  159 +++++++++++++++++-------------------------------
 1 files changed, 56 insertions(+), 103 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index ee1543d..dc6a306 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -314,8 +314,6 @@ struct sbridge_pvt {
 	struct sbridge_info	info;
 	struct sbridge_channel	channel[NUM_CHANNELS];
 
-	int 			csrow_map[NUM_CHANNELS][MAX_DIMMS];
-
 	/* Memory type detection */
 	bool			is_mirrored, is_lockstep, is_close_pg;
 
@@ -487,29 +485,14 @@ static struct pci_dev *get_pdev_slot_func(u8 bus, unsigned slot,
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
@@ -523,41 +506,14 @@ static int sbridge_get_active_channels(const u8 bus, unsigned *channels,
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
@@ -616,7 +572,8 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 		u32 mtr;
 
 		for (j = 0; j < ARRAY_SIZE(mtr_regs); j++) {
-			struct dimm_info *dimm = &mci->dimms[j];
+			dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+				       i, j, 0);
 			pci_read_config_dword(pvt->pci_tad[i],
 					      mtr_regs[j], &mtr);
 			debugf4("Channel #%d  MTR%d = %x\n", i, j, mtr);
@@ -636,16 +593,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
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
@@ -841,11 +788,10 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
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
@@ -867,12 +813,10 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	 */
 	if ((addr > (u64) pvt->tolm) && (addr < (1LL << 32))) {
 		sprintf(msg, "Error at TOLM area, on addr 0x%08Lx", addr);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	if (addr >= (u64)pvt->tohm) {
 		sprintf(msg, "Error at MMIOH area, on addr 0x%016Lx", addr);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 
@@ -889,7 +833,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		limit = SAD_LIMIT(reg);
 		if (limit <= prv) {
 			sprintf(msg, "Can't discover the memory socket");
-			edac_mc_handle_ce_no_info(mci, msg);
 			return -EINVAL;
 		}
 		if  (addr <= limit)
@@ -898,7 +841,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	}
 	if (n_sads == MAX_SAD) {
 		sprintf(msg, "Can't discover the memory socket");
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	area_type = get_dram_attr(reg);
@@ -939,7 +881,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		break;
 	default:
 		sprintf(msg, "Can't discover socket interleave");
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	*socket = sad_interleave[idx];
@@ -954,7 +895,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	if (!new_mci) {
 		sprintf(msg, "Struct for socket #%u wasn't initialized",
 			*socket);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	mci = new_mci;
@@ -970,7 +910,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		limit = TAD_LIMIT(reg);
 		if (limit <= prv) {
 			sprintf(msg, "Can't discover the memory channel");
-			edac_mc_handle_ce_no_info(mci, msg);
 			return -EINVAL;
 		}
 		if  (addr <= limit)
@@ -1010,7 +949,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		break;
 	default:
 		sprintf(msg, "Can't discover the TAD target");
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	*channel_mask = 1 << base_ch;
@@ -1024,7 +962,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 			break;
 		default:
 			sprintf(msg, "Invalid mirror set. Can't decode addr");
-			edac_mc_handle_ce_no_info(mci, msg);
 			return -EINVAL;
 		}
 	} else
@@ -1052,7 +989,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	if (offset > addr) {
 		sprintf(msg, "Can't calculate ch addr: TAD offset 0x%08Lx is too high for addr 0x%08Lx!",
 			offset, addr);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	addr -= offset;
@@ -1092,7 +1028,6 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	if (n_rir == MAX_RIR_RANGES) {
 		sprintf(msg, "Can't discover the memory rank for ch addr 0x%08Lx",
 			ch_addr);
-		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
 	}
 	rir_way = RIR_WAY(reg);
@@ -1406,7 +1341,8 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 {
 	struct mem_ctl_info *new_mci;
 	struct sbridge_pvt *pvt = mci->pvt_info;
-	char *type, *optype, *msg, *recoverable_msg;
+	enum hw_event_mc_err_type tp_event;
+	char *type, *optype, msg[256], *recoverable_msg;
 	bool ripv = GET_BITFIELD(m->mcgstatus, 0, 0);
 	bool overflow = GET_BITFIELD(m->status, 62, 62);
 	bool uncorrected_error = GET_BITFIELD(m->status, 61, 61);
@@ -1418,13 +1354,21 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
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
@@ -1442,19 +1386,19 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
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
@@ -1463,13 +1407,13 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
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
@@ -1483,8 +1427,6 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	else
 		dimm = 2;
 
-	csrow = pvt->csrow_map[first_channel][dimm];
-
 	if (uncorrected_error && recoverable)
 		recoverable_msg = " recoverable";
 	else
@@ -1495,18 +1437,14 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
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
@@ -1515,13 +1453,19 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 
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
@@ -1680,16 +1624,25 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
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
+	mci = new_edac_mc_alloc(sbridge_dev->mc, ARRAY_SIZE(layers), layers,
+			    false, sizeof(*pvt));
+
 	if (unlikely(!mci))
 		return -ENOMEM;
 
-- 
1.7.8

