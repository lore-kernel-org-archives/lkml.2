Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2CGMNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:13:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757669Ab2CGMLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] i5000_edac: Fix the logic that retrieves memory information
Date: Wed,  7 Mar 2012 09:11:15 -0300
Message-Id: <1331122278-28458-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331122278-28458-1-git-send-email-mchehab@redhat.com>
References: <1331122278-28458-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic there is broken: it basically creates two csrows for
each DIMM and assumes that all DIMM's are dual rank. Only one of
the csrows will contain the entire DIMM size. If single rank
memories are found, they'll be marked with 0 bytes.

The check if the AMB is present were also wrong.

Yet, as the error reports don't use the memory size in order to
credit an error to the right DIMM, that part of the driver seems
to work. That's why probably nobody detected the issue yet.

After this patch, the memory layout is now properly reported,
when debug mode is enabled, and the number of ranks per dimm is
now shown:

calculate_dimm_size: ----------------------------------------------------------
calculate_dimm_size: slot  3       0 MB   |    0 MB   |    0 MB   |    0 MB   |
calculate_dimm_size: slot  2       0 MB   |    0 MB   |    0 MB   |    0 MB   |
calculate_dimm_size: ----------------------------------------------------------
calculate_dimm_size: slot  1       0 MB   |    0 MB   |    0 MB   |    0 MB   |
calculate_dimm_size: slot  0     512 MB 1R|  512 MB 1R|  512 MB 1R|  512 MB 1R|
calculate_dimm_size: ----------------------------------------------------------
calculate_dimm_size:            channel 0 | channel 1 | channel 2 | channel 3 |
calculate_dimm_size:                   branch 0       |        branch 1       |

(1R above means that all memories on my test machine are single-ranked)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i5000_edac.c |  150 ++++++++++++++++++++++++---------------------
 1 files changed, 79 insertions(+), 71 deletions(-)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 564fe09..14efb74 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -270,7 +270,8 @@
 #define MTR3		0x8C
 
 #define NUM_MTRS		4
-#define CHANNELS_PER_BRANCH	(2)
+#define CHANNELS_PER_BRANCH	2
+#define MAX_BRANCHES		2
 
 /* Defines to extract the vaious fields from the
  *	MTRx - Memory Technology Registers
@@ -962,14 +963,14 @@ static int determine_amb_present_reg(struct i5000_pvt *pvt, int channel)
  *
  *	return the proper MTR register as determine by the csrow and channel desired
  */
-static int determine_mtr(struct i5000_pvt *pvt, int csrow, int channel)
+static int determine_mtr(struct i5000_pvt *pvt, int slot, int channel)
 {
 	int mtr;
 
 	if (channel < CHANNELS_PER_BRANCH)
-		mtr = pvt->b0_mtr[csrow >> 1];
+		mtr = pvt->b0_mtr[slot];
 	else
-		mtr = pvt->b1_mtr[csrow >> 1];
+		mtr = pvt->b1_mtr[slot];
 
 	return mtr;
 }
@@ -994,37 +995,34 @@ static void decode_mtr(int slot_row, u16 mtr)
 	debugf2("\t\tNUMCOL: %s\n", numcol_toString[MTR_DIMM_COLS(mtr)]);
 }
 
-static void handle_channel(struct i5000_pvt *pvt, int csrow, int channel,
+static void handle_channel(struct i5000_pvt *pvt, int slot, int channel,
 			struct i5000_dimm_info *dinfo)
 {
 	int mtr;
 	int amb_present_reg;
 	int addrBits;
 
-	mtr = determine_mtr(pvt, csrow, channel);
+	mtr = determine_mtr(pvt, slot, channel);
 	if (MTR_DIMMS_PRESENT(mtr)) {
 		amb_present_reg = determine_amb_present_reg(pvt, channel);
 
-		/* Determine if there is  a  DIMM present in this DIMM slot */
-		if (amb_present_reg & (1 << (csrow >> 1))) {
+		/* Determine if there is a DIMM present in this DIMM slot */
+		if (amb_present_reg) {
 			dinfo->dual_rank = MTR_DIMM_RANK(mtr);
 
-			if (!((dinfo->dual_rank == 0) &&
-				((csrow & 0x1) == 0x1))) {
-				/* Start with the number of bits for a Bank
-				 * on the DRAM */
-				addrBits = MTR_DRAM_BANKS_ADDR_BITS(mtr);
-				/* Add thenumber of ROW bits */
-				addrBits += MTR_DIMM_ROWS_ADDR_BITS(mtr);
-				/* add the number of COLUMN bits */
-				addrBits += MTR_DIMM_COLS_ADDR_BITS(mtr);
-
-				addrBits += 6;	/* add 64 bits per DIMM */
-				addrBits -= 20;	/* divide by 2^^20 */
-				addrBits -= 3;	/* 8 bits per bytes */
-
-				dinfo->megabytes = 1 << addrBits;
-			}
+			/* Start with the number of bits for a Bank
+				* on the DRAM */
+			addrBits = MTR_DRAM_BANKS_ADDR_BITS(mtr);
+			/* Add the number of ROW bits */
+			addrBits += MTR_DIMM_ROWS_ADDR_BITS(mtr);
+			/* add the number of COLUMN bits */
+			addrBits += MTR_DIMM_COLS_ADDR_BITS(mtr);
+
+			addrBits += 6;	/* add 64 bits per DIMM */
+			addrBits -= 20;	/* divide by 2^^20 */
+			addrBits -= 3;	/* 8 bits per bytes */
+
+			dinfo->megabytes = 1 << addrBits;
 		}
 	}
 }
@@ -1038,10 +1036,9 @@ static void handle_channel(struct i5000_pvt *pvt, int csrow, int channel,
 static void calculate_dimm_size(struct i5000_pvt *pvt)
 {
 	struct i5000_dimm_info *dinfo;
-	int csrow, max_csrows;
+	int slot, channel, branch;
 	char *p, *mem_buffer;
 	int space, n;
-	int channel;
 
 	/* ================= Generate some debug output ================= */
 	space = PAGE_SIZE;
@@ -1052,22 +1049,17 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 		return;
 	}
 
-	n = snprintf(p, space, "\n");
-	p += n;
-	space -= n;
-
-	/* Scan all the actual CSROWS (which is # of DIMMS * 2)
+	/* Scan all the actual slots
 	 * and calculate the information for each DIMM
-	 * Start with the highest csrow first, to display it first
-	 * and work toward the 0th csrow
+	 * Start with the highest slot first, to display it first
+	 * and work toward the 0th slot
 	 */
-	max_csrows = pvt->maxdimmperch * 2;
-	for (csrow = max_csrows - 1; csrow >= 0; csrow--) {
+	for (slot = pvt->maxdimmperch - 1; slot >= 0; slot--) {
 
-		/* on an odd csrow, first output a 'boundary' marker,
+		/* on an odd slot, first output a 'boundary' marker,
 		 * then reset the message buffer  */
-		if (csrow & 0x1) {
-			n = snprintf(p, space, "---------------------------"
+		if (slot & 0x1) {
+			n = snprintf(p, space, "--------------------------"
 				"--------------------------------");
 			p += n;
 			space -= n;
@@ -1075,30 +1067,39 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 			p = mem_buffer;
 			space = PAGE_SIZE;
 		}
-		n = snprintf(p, space, "csrow %2d    ", csrow);
+		n = snprintf(p, space, "slot %2d    ", slot);
 		p += n;
 		space -= n;
 
 		for (channel = 0; channel < pvt->maxch; channel++) {
-			dinfo = &pvt->dimm_info[csrow][channel];
-			handle_channel(pvt, csrow, channel, dinfo);
-			n = snprintf(p, space, "%4d MB   | ", dinfo->megabytes);
+			dinfo = &pvt->dimm_info[slot][channel];
+			handle_channel(pvt, slot, channel, dinfo);
+			if (dinfo->megabytes)
+				n = snprintf(p, space, "%4d MB %dR| ",
+					     dinfo->megabytes, dinfo->dual_rank + 1);
+			else
+				n = snprintf(p, space, "%4d MB   | ", 0);
 			p += n;
 			space -= n;
 		}
-		n = snprintf(p, space, "\n");
 		p += n;
 		space -= n;
+		debugf2("%s\n", mem_buffer);
+		p = mem_buffer;
+		space = PAGE_SIZE;
 	}
 
 	/* Output the last bottom 'boundary' marker */
-	n = snprintf(p, space, "---------------------------"
-		"--------------------------------\n");
+	n = snprintf(p, space, "--------------------------"
+		"--------------------------------");
 	p += n;
 	space -= n;
+	debugf2("%s\n", mem_buffer);
+	p = mem_buffer;
+	space = PAGE_SIZE;
 
 	/* now output the 'channel' labels */
-	n = snprintf(p, space, "            ");
+	n = snprintf(p, space, "           ");
 	p += n;
 	space -= n;
 	for (channel = 0; channel < pvt->maxch; channel++) {
@@ -1106,9 +1107,17 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 		p += n;
 		space -= n;
 	}
-	n = snprintf(p, space, "\n");
+	debugf2("%s\n", mem_buffer);
+	p = mem_buffer;
+	space = PAGE_SIZE;
+
+	n = snprintf(p, space, "           ");
 	p += n;
-	space -= n;
+	for (branch = 0; branch < MAX_BRANCHES; branch++) {
+		n = snprintf(p, space, "       branch %d       | ", branch);
+		p += n;
+		space -= n;
+	}
 
 	/* output the last message and free buffer */
 	debugf2("%s\n", mem_buffer);
@@ -1241,14 +1250,13 @@ static void i5000_get_mc_regs(struct mem_ctl_info *mci)
 static int i5000_init_csrows(struct mem_ctl_info *mci)
 {
 	struct i5000_pvt *pvt;
-	struct csrow_info *p_csrow;
 	struct dimm_info *dimm;
 	int empty, channel_count;
 	int max_csrows;
-	int mtr, mtr1;
+	int mtr;
 	int csrow_megs;
 	int channel;
-	int csrow;
+	int slot;
 
 	pvt = mci->pvt_info;
 
@@ -1258,26 +1266,25 @@ static int i5000_init_csrows(struct mem_ctl_info *mci)
 	empty = 1;		/* Assume NO memory */
 
 	/*
-	 * TODO: it would be better to not use csrow here, filling
-	 * directly the dimm_info structs, based on branch, channel, dim number
+	 * FIXME: The memory layout used to map slot/channel into the
+	 * real memory architecture is weird: branch+slot are "csrows"
+	 * and channel is channel. That required an extra array (dimm_info)
+	 * to map the dimms. A good cleanup would be to remove this array,
+	 * and do a loop here with branch, channel, slot
 	 */
-	for (csrow = 0; csrow < max_csrows; csrow++) {
-		p_csrow = &mci->csrows[csrow];
+	for (slot = 0; slot < max_csrows; slot++) {
+		for (channel = 0; channel < pvt->maxch; channel++) {
 
-		p_csrow->csrow_idx = csrow;
+			mtr = determine_mtr(pvt, slot, channel);
 
-		/* use branch 0 for the basis */
-		mtr = pvt->b0_mtr[csrow >> 1];
-		mtr1 = pvt->b1_mtr[csrow >> 1];
+			if (!MTR_DIMMS_PRESENT(mtr))
+				continue;
 
-		/* if no DIMMS on this row, continue */
-		if (!MTR_DIMMS_PRESENT(mtr) && !MTR_DIMMS_PRESENT(mtr1))
-			continue;
+			dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+				       channel / MAX_BRANCHES,
+				       channel % MAX_BRANCHES, slot);
 
-		csrow_megs = 0;
-		for (channel = 0; channel < pvt->maxch; channel++) {
-			dimm = p_csrow->channels[channel].dimm;
-			csrow_megs += pvt->dimm_info[csrow][channel].megabytes;
+			csrow_megs = pvt->dimm_info[slot][channel].megabytes;
 			dimm->grain = 8;
 
 			/* Assume DDR2 for now */
@@ -1290,7 +1297,7 @@ static int i5000_init_csrows(struct mem_ctl_info *mci)
 				dimm->dtype = DEV_X4;
 
 			dimm->edac_mode = EDAC_S8ECD8ED;
-			dimm->nr_pages = (csrow_megs << 8) / pvt->maxch;
+			dimm->nr_pages = csrow_megs << 8;
 		}
 
 		empty = 0;
@@ -1337,7 +1344,7 @@ static void i5000_get_dimm_and_channel_counts(struct pci_dev *pdev,
 	 * supported on this memory controller
 	 */
 	pci_read_config_byte(pdev, MAXDIMMPERCH, &value);
-	*num_dimms_per_channel = (int)value *2;
+	*num_dimms_per_channel = (int)value;
 
 	pci_read_config_byte(pdev, MAXCH, &value);
 	*num_channels = (int)value;
@@ -1387,11 +1394,12 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 		__func__, num_channels, num_dimms_per_channel);
 
 	/* allocate a new MC control structure */
+
 	layers[0].type = EDAC_MC_LAYER_BRANCH;
-	layers[0].size = 2;
-	layers[0].is_csrow = true;
+	layers[0].size = MAX_BRANCHES;
+	layers[0].is_csrow = false;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
-	layers[1].size = num_channels;
+	layers[1].size = num_channels / MAX_BRANCHES;
 	layers[1].is_csrow = false;
 	layers[2].type = EDAC_MC_LAYER_SLOT;
 	layers[2].size = num_dimms_per_channel;
-- 
1.7.8

