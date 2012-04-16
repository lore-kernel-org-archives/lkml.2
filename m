Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2DPU2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab2DPUVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [EDAC_ABI PATCH v13 11/26] i5400_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:30 -0300
Message-Id: <1334607705-30320-12-git-send-email-mchehab@redhat.com>
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
 drivers/edac/i5400_edac.c |  217 +++++++++++++++++++++++++--------------------
 1 files changed, 119 insertions(+), 98 deletions(-)

diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 784d6dc..029c557 100644
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
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
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
-- 
1.7.8

