Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab2BJAGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:06:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704Ab2BJABi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:38 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 15/31] edac: DIMM location cleanup
Date: Thu,  9 Feb 2012 22:01:14 -0200
Message-Id: <1328832090-9166-16-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleans up the DIMM location information:
	- Remove it from the structure;
	- make the location sysfs node code more flexible;
	- cleans up the dimm code inside the drivers that
	  fills the dimm location properties.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c    |    6 ++--
 drivers/edac/edac_mc.c       |    8 ++++--
 drivers/edac/edac_mc_sysfs.c |   26 +++++++++++++++++-------
 drivers/edac/i5100_edac.c    |   44 ++++++++++++++++++++---------------------
 drivers/edac/i5400_edac.c    |   32 ++++++++++++------------------
 drivers/edac/i7300_edac.c    |   15 ++++++++-----
 drivers/edac/i7core_edac.c   |   19 +++++++----------
 drivers/edac/i82975x_edac.c  |   14 ++++--------
 drivers/edac/sb_edac.c       |   11 ++-------
 include/linux/edac.h         |   27 ++++++++-----------------
 10 files changed, 94 insertions(+), 108 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 613d5f1..3cba6a5 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2142,7 +2142,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 	struct csrow_info *csrow;
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u64 base, mask;
-	u32 val;
+	u32 val, nr_pages;
 	int i, j, empty = 1;
 	enum mem_type mtype;
 	enum edac_type edac_mode;
@@ -2186,12 +2186,12 @@ static int init_csrows(struct mem_ctl_info *mci)
 		for (j = 0; j < pvt->channel_count; j++) {
 			csrow->channels[j].dimm->mtype = mtype;
 			csrow->channels[j].dimm->edac_mode = edac_mode;
-			csrow->channels[j].dimm->n_pages = npages;
+			csrow->channels[j].dimm->nr_pages = nr_pages;
 
 		}
 
 		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
-		debugf1("    nr_pages: %u\n", csrow->nr_pages);
+		debugf1("    nr_pages: %u\n", nr_pages);
 	}
 
 	return empty;
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index f33d603..ee3f0f8 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -219,13 +219,15 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	 * as most drivers are based on such assumption.
 	 */
 	if (!mci->nr_dimms) {
-		mci->dimm_loc_type = DIMM_LOC_CSROW;
 		dimm = mci->dimms;
 		for (row = 0; row < mci->nr_csrows; row++) {
 			for (chn = 0; chn < mci->csrows[row].nr_channels; chn++) {
 				mci->csrows[row].channels[chn].dimm = dimm;
-				dimm->location.csrow = row;
-				dimm->location.csrow_channel = chn;
+				dimm->mc_branch = -1;
+				dimm->mc_channel = -1;
+				dimm->mc_dimm_number = -1;
+				dimm->csrow = row;
+				dimm->csrow_channel = chn;
 				dimm++;
 				mci->nr_dimms++;
 			}
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index d175e48..64b4c76 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -471,14 +471,24 @@ static const struct sysfs_ops dimmfs_ops = {
 /* show/store functions for DIMM Label attributes */
 static ssize_t dimmdev_location_show(struct dimm_info *dimm, char *data)
 {
-	if (dimm->mci->dimm_loc_type == DIMM_LOC_CSROW)
-		return sprintf(data, "csrow %d, channel %d\n",
-			       dimm->location.csrow,
-			       dimm->location.csrow_channel);
-	else
-		return sprintf(data, "channel %d, dimm %d\n",
-			       dimm->location.mc_channel,
-			       dimm->location.mc_dimm_number);
+	char *p = data;
+
+	if (dimm->mc_branch >= 0)
+		p += sprintf(p, "branch %d ", dimm->mc_branch);
+
+	if (dimm->mc_channel >= 0)
+		p += sprintf(p, "channel %d ", dimm->mc_channel);
+
+	if (dimm->csrow >= 0)
+		p += sprintf(p, "csrow %d ", dimm->csrow);
+
+	if (dimm->csrow_channel >= 0)
+		p += sprintf(p, "cs_channel %d ", dimm->csrow_channel);
+
+	if (dimm->mc_dimm_number >= 0)
+		p += sprintf(p, "dimm %d ", dimm->mc_dimm_number);
+
+	return p - data;
 }
 
 static ssize_t dimmdev_label_show(struct dimm_info *dimm, char *data)
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 075d3c7..f9baee3 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -848,35 +848,33 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 	int i;
 	unsigned long total_pages = 0UL;
 	struct i5100_priv *priv = mci->pvt_info;
-	struct dimm_info *dimm;
 
-	dimm = mci->dimms;
-	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
-	mci->nr_dimms = 0;
-	for (i = 0; i < mci->nr_csrows; i++) {
+	for (i = 0; i < mci->nr_dimms; i++) {
 		const unsigned long npages = i5100_npages(mci, i);
 		const unsigned chan = i5100_csrow_to_chan(mci, i);
 		const unsigned rank = i5100_csrow_to_rank(mci, i);
+		struct dimm_info *dimm = &mci->dimms[i];
 
-		if (!npages)
-			continue;
-
-		total_pages += npages;
-
-		mci->csrows[i].channels[0].dimm = dimm;
 		dimm->nr_pages = npages;
-		dimm->location.mc_channel = chan;
-		dimm->location.mc_dimm_number = rank;
-		dimm->grain = 32;
-		dimm->dtype = (priv->mtr[chan][rank].width == 4) ?
-			      DEV_X4 : DEV_X8;
-		dimm->mtype = MEM_RDDR2;
-		dimm->edac_mode = EDAC_SECDED;
-		snprintf(dimm->label, sizeof(dimm->label),
-			 "DIMM%u",
-			 i5100_rank_to_slot(mci, chan, rank));
-		mci->nr_dimms++;
-		dimm++;
+
+		dimm->mc_branch = -1;
+		dimm->mc_channel = chan;
+		dimm->mc_dimm_number = rank;
+		dimm->csrow = -1;
+		dimm->csrow_channel = -1;
+
+		if (npages) {
+			total_pages += npages;
+
+			dimm->grain = 32;
+			dimm->dtype = (priv->mtr[chan][rank].width == 4) ?
+				DEV_X4 : DEV_X8;
+			dimm->mtype = MEM_RDDR2;
+			dimm->edac_mode = EDAC_SECDED;
+			snprintf(dimm->label, sizeof(dimm->label),
+				"DIMM%u",
+				i5100_rank_to_slot(mci, chan, rank));
+		}
 	}
 }
 
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index cbba3df..6b07450 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1130,14 +1130,12 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 static int i5400_init_csrows(struct mem_ctl_info *mci)
 {
 	struct i5400_pvt *pvt;
-	struct csrow_info *p_csrow;
 	int empty, channel_count;
 	int max_csrows;
 	int mtr;
-	int csrow_megs;
+	int size_mb;
 	int channel;
-	int csrow;
-	struct dimm_info *dimm;
+	int slot;
 
 	pvt = mci->pvt_info;
 
@@ -1146,34 +1144,30 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 
 	empty = 1;		/* Assume NO memory */
 
-	dimm = mci->dimms;
-	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
-	mci->nr_dimms = 0;
-	for (csrow = 0; csrow < max_csrows; csrow++) {
-		p_csrow = &mci->csrows[csrow];
+	for (slot = 0; slot < mci->nr_dimms; slot++) {
+		struct dimm_info *dimm = &mci->dimms[slot];
+		channel = slot % pvt->maxch;
 
-		p_csrow->csrow_idx = csrow;
+		dimm->mc_branch = channel / 2;
+		dimm->mc_channel = channel % 2;
+		dimm->mc_dimm_number = slot / pvt->maxch;
+		dimm->csrow = -1;
+		dimm->csrow_channel = -1;
 
 		/* use branch 0 for the basis */
-		mtr = determine_mtr(pvt, csrow, 0);
+		mtr = determine_mtr(pvt, slot, 0);
 
 		/* if no DIMMS on this row, continue */
 		if (!MTR_DIMMS_PRESENT(mtr))
 			continue;
 
-		csrow_megs = 0;
-		for (channel = 0; channel < pvt->maxch; channel++)
-			csrow_megs += pvt->dimm_info[csrow][channel].megabytes;
+		size_mb =  pvt->dimm_info[slot / pvt->maxch][channel].megabytes;
 
-		dimm->nr_pages = csrow_megs << 8;
-		dimm->location.mc_channel = channel;
-		dimm->location.mc_dimm_number = csrow / pvt->maxch;
+		dimm->nr_pages = size_mb << 8;
 		dimm->grain = 8;
 		dimm->dtype = MTR_DRAM_WIDTH(mtr) ? DEV_X8 : DEV_X4;
 		dimm->mtype = MEM_RDDR2;
 		dimm->edac_mode = EDAC_SECDED;
-		mci->nr_dimms++;
-		dimm++;
 
 		empty = 0;
 	}
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 73969d0..0838ec2 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -773,7 +773,6 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 	int rc = -ENODEV;
 	int mtr;
 	int ch, branch, slot, channel;
-	u32 nr_pages;
 	struct dimm_info *dimm;
 
 	pvt = mci->pvt_info;
@@ -800,7 +799,6 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 
 	/* Get the set of MTR[0-7] regs by each branch */
 	dimm = mci->dimms;
-	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
 	mci->nr_dimms = 0;
 	for (slot = 0; slot < MAX_SLOTS; slot++) {
 		int where = mtr_regs[slot];
@@ -813,19 +811,24 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 
 				dinfo = &pvt->dimm_info[slot][channel];
 
-				dimm->location.mc_channel = channel;
-				dimm->location.mc_dimm_number = slot;
+				dimm->mc_branch = branch;
+				dimm->mc_channel = ch;
+				dimm->mc_dimm_number = slot;
+				dimm->csrow = -1;
+				dimm->csrow_channel = -1;
 
 				mtr = decode_mtr(pvt, slot, ch, branch,
 						 dinfo, dimm);
+
+				mci->nr_dimms++;
+				dimm++;
+
 				/* if no DIMMS on this row, continue */
 				if (!MTR_DIMMS_PRESENT(mtr))
 					continue;
 
 				rc = 0;
 
-				mci->nr_dimms++;
-				dimm++;
 			}
 		}
 	}
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index cbee6ad..c6c649d 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -601,7 +601,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	int csrow = 0;
 	enum edac_type mode;
 	enum mem_type mtype;
-	struct dimm_info *dimm;
 
 	/* Get data from the MC register, function 0 */
 	pdev = pvt->pci_mcr[0];
@@ -638,9 +637,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 		numrow(pvt->info.max_dod >> 6),
 		numcol(pvt->info.max_dod >> 9));
 
-	dimm = mci->dimms;
-	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
-	mci->nr_dimms = 0;
 	for (i = 0; i < NUM_CHANS; i++) {
 		u32 data, dimm_dod[3], value[8];
 
@@ -693,9 +689,16 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			(data & REGISTERED_DIMM) ? 'R' : 'U');
 
 		for (j = 0; j < 3; j++) {
+			struct dimm_info *dimm = &mci->dimms[i * 3 + j];
 			u32 banks, ranks, rows, cols;
 			u32 size, npages;
 
+			dimm->mc_branch = -1;
+			dimm->mc_channel = i;
+			dimm->mc_dimm_number = j;
+			dimm->csrow = -1;
+			dimm->csrow_channel = -1;
+
 			if (!DIMM_PRESENT(dimm_dod[j]))
 				continue;
 
@@ -718,6 +721,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			npages = MiB_TO_PAGES(size);
 
 			csr = &mci->csrows[csrow];
+			csr->channels[0].dimm = dimm;
 
 			pvt->csrow_map[i][j] = csrow;
 
@@ -737,19 +741,12 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 				dimm->dtype = DEV_UNKNOWN;
 			}
 
-			csr->channels[0].dimm = dimm;
-
-			dimm->location.mc_channel = i;
-			dimm->location.mc_dimm_number = j;
 			snprintf(dimm->label, sizeof(dimm->label),
 				 "CPU#%uChannel#%u_DIMM#%u",
 				 pvt->i7core_dev->socket, i, j);
 			dimm->grain = 8;
 			dimm->edac_mode = mode;
 			dimm->mtype = mtype;
-
-			mci->nr_dimms++;
-			dimm++;
 			csrow++;
 		}
 
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index b70ea1e..d7dc455 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -378,9 +378,6 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 	 *
 	 */
 
-	mci->dimm_loc_type = DIMM_LOC_CSROW;
-	dimm = mci->dimms;
-	mci->nr_dimms = 0;
 	for (index = 0; index < mci->nr_csrows; index++) {
 		csrow = &mci->csrows[index];
 
@@ -406,11 +403,12 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		 */
 		dtype = i82975x_dram_type(mch_window, index);
 		for (chan = 0; chan < csrow->nr_channels; chan++) {
-			mci->csrows[index].channels[chan].dimm = dimm;
+			dimm = mci->csrows[index].channels[chan].dimm;
+
+			if (!nr_pages)
+				continue;
 
 			dimm->nr_pages = nr_pages / csrow->nr_channels;
-			dimm->location.csrow = index;
-			dimm->location.csrow_channel = chan;
 			strncpy(csrow->channels[chan].dimm->label,
 					labels[(index >> 1) + (chan * 2)],
 					EDAC_MC_LABEL_LEN);
@@ -418,11 +416,9 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 			dimm->dtype = dtype;
 			dimm->mtype = MEM_DDR2; /* I82975x supports only DDR2 */
 			dimm->edac_mode = EDAC_SECDED; /* only supported */
-			dimm++;
-			mci->nr_dimms++;
 		}
 
-		if (cumul_size == last_cumul_size)
+		if (!nr_pages)
 			continue;	/* not populated */
 
 		csrow->first_page = last_cumul_size;
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 9266e3f..981262b 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -560,7 +560,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	u32 reg;
 	enum edac_type mode;
 	enum mem_type mtype;
-	struct dimm_info *dimm;
 
 	pci_read_config_dword(pvt->pci_br, SAD_TARGET, &reg);
 	pvt->sbridge_dev->source_id = SOURCE_ID(reg);
@@ -612,13 +611,11 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	/* On all supported DDR3 DIMM types, there are 8 banks available */
 	banks = 8;
 
-	dimm = mci->dimms;
-	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
-	mci->nr_dimms = 0;
 	for (i = 0; i < NUM_CHANNELS; i++) {
 		u32 mtr;
 
 		for (j = 0; j < ARRAY_SIZE(mtr_regs); j++) {
+			struct dimm_info *dimm = &mci->dimms[j];
 			pci_read_config_dword(pvt->pci_tad[i],
 					      mtr_regs[j], &mtr);
 			debugf4("Channel #%d  MTR%d = %x\n", i, j, mtr);
@@ -649,8 +646,8 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 
 				csr->channels[0].dimm = dimm;
 				dimm->nr_pages = npages;
-				dimm->location.mc_channel = i;
-				dimm->location.mc_dimm_number = j;
+				dimm->mc_channel = i;
+				dimm->mc_dimm_number = j;
 				dimm->grain = 32;
 				dimm->dtype = (banks == 8) ? DEV_X8 : DEV_X4;
 				dimm->mtype = mtype;
@@ -658,8 +655,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 				snprintf(dimm->label, sizeof(dimm->label),
 					 "CPU_SrcID#%u_Channel#%u_DIMM#%u",
 					 pvt->sbridge_dev->source_id, i, j);
-				mci->nr_dimms++;
-				dimm++;
 			}
 		}
 	}
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 753187d..652be25 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -341,25 +341,17 @@ enum scrub_type {
  * PS - I enjoyed writing all that about as much as you enjoyed reading it.
  */
 
-enum dimm_location_type {
-	DIMM_LOC_CSROW,
-	DIMM_LOC_MC_CHANNEL,
-};
-
-/* FIXME: add a per-dimm ce error count */
+/* FIXME: add the proper per-location error counts */
 struct dimm_info {
 	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
-	unsigned memory_controller;
-	union {
-		struct {
-			unsigned mc_channel;
-			unsigned mc_dimm_number;
-		};
-		struct {
-			unsigned csrow;
-			unsigned csrow_channel;
-		};
-	} location;
+
+	/* Memory location data */
+	int mc_branch;
+	int mc_channel;
+	int csrow;
+	int mc_dimm_number;
+	int csrow_channel;
+
 	struct kobject kobj;		/* sysfs kobject for this csrow */
 	struct mem_ctl_info *mci;	/* the parent */
 
@@ -479,7 +471,6 @@ struct mem_ctl_info {
 	/*
 	 * DIMM info. Will eventually remove the entire csrows_info some day
 	 */
-	enum dimm_location_type dimm_loc_type;
 	unsigned nr_dimms;
 	struct dimm_info *dimms;
 
-- 
1.7.8

