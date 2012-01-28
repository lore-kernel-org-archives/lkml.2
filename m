Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2A1Pd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:33:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab2A1Pc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:32:58 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv2 05/16] edac: Create a dimm struct and move the labels into it
Date: Sat, 28 Jan 2012 13:32:40 -0200
Message-Id: <1327764771-28649-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
References: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way a DIMM is currently represented implies that they're
linked into a per-csrow struct. However, some drivers don't see
csrows, as they're ridden behind some chip like the AMB's
on FBDIMM's, for example.

This forced drivers to fake a csrow struct, and to create
a mess under csrow/channel original's concept.

Move the DIMM labels into a per-DIMM struct, and add there
the real location of the socket, in terms of csrow/channel,
on csrow-based architectures, or on channel/dimm number,
on modern architectures.

On three drivers based on the modern architectures
(i5100_edac, sb_edac and i7core_edac), the labels were
filled inside the driver, as a way to avoid loosing the
channel/dimm number. Those drivers were converted to
properly fill the DIMM location properties internally.

All other drivers will use a per-csrow type of location.
Some of those drivers will require a latter conversion, as
they also fake the csrows internally.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c       |   95 ++++++++++++++++++++++++++++-------------
 drivers/edac/edac_mc_sysfs.c |   13 ++++--
 drivers/edac/i5100_edac.c    |   28 ++++++++++---
 drivers/edac/i7core_edac.c   |   18 ++++++--
 drivers/edac/i82975x_edac.c  |   13 +++++-
 drivers/edac/sb_edac.c       |   18 ++++++--
 include/linux/edac.h         |   31 +++++++++++++-
 7 files changed, 163 insertions(+), 53 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 8776f30..93ef044 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -48,7 +48,8 @@ static void edac_mc_dump_channel(struct csrow_channel_info *chan)
 	debugf4("\tchannel = %p\n", chan);
 	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
 	debugf4("\tchannel->ce_count = %d\n", chan->ce_count);
-	debugf4("\tchannel->label = '%s'\n", chan->label);
+	if (chan->dimm)
+		debugf4("\tchannel->label = '%s'\n", chan->dimm->label);
 	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
 }
 
@@ -161,6 +162,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	struct mem_ctl_info *mci;
 	struct csrow_info *csi, *csrow;
 	struct csrow_channel_info *chi, *chp, *chan;
+	struct dimm_info *dimm;
 	void *pvt;
 	unsigned size;
 	int row, chn;
@@ -174,7 +176,8 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	mci = (struct mem_ctl_info *)0;
 	csi = edac_align_ptr(&mci[1], sizeof(*csi));
 	chi = edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
-	pvt = edac_align_ptr(&chi[nr_chans * nr_csrows], sz_pvt);
+	dimm = edac_align_ptr(&chi[nr_chans * nr_csrows], sizeof(*dimm));
+	pvt = edac_align_ptr(&dimm[nr_chans * nr_csrows], sz_pvt);
 	size = ((unsigned long)pvt) + sz_pvt;
 
 	mci = kzalloc(size, GFP_KERNEL);
@@ -186,11 +189,13 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	 */
 	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
 	chi = (struct csrow_channel_info *)(((char *)mci) + ((unsigned long)chi));
+	dimm = (struct dimm_info *)(((char *)mci) + ((unsigned long)dimm));
 	pvt = sz_pvt ? (((char *)mci) + ((unsigned long)pvt)) : NULL;
 
 	/* setup index and various internal pointers */
 	mci->mc_idx = edac_index;
 	mci->csrows = csi;
+	mci->dimms  = dimm;
 	mci->pvt_info = pvt;
 	mci->nr_csrows = nr_csrows;
 
@@ -507,18 +512,37 @@ EXPORT_SYMBOL(edac_mc_find);
 /* FIXME - should a warning be printed if no error detection? correction? */
 int edac_mc_add_mc(struct mem_ctl_info *mci)
 {
+	int i, j;
+	struct dimm_info *dimm;
+
 	debugf0("%s()\n", __func__);
 
+	/*
+	 * If nr_dimms is not filled, that means that the driver itself
+	 * were not converted to use the new struct, or that the driver
+	 * is for a csrow-based device.
+	 * Fill the dimms accordingly.
+	 */
+	if (!mci->nr_dimms) {
+		mci->dimm_loc_type = DIMM_LOC_CSROW;
+		dimm = mci->dimms;
+		for (i = 0; i < mci->nr_csrows; i++) {
+			for (j = 0; j < mci->csrows[i].nr_channels; j++) {
+				mci->csrows[i].channels[j].dimm = dimm;
+				dimm->location.csrow = i;
+				dimm->location.csrow_channel = j;
+				dimm++;
+				mci->nr_dimms++;
+			}
+		}
+	}
 #ifdef CONFIG_EDAC_DEBUG
 	if (edac_debug_level >= 3)
 		edac_mc_dump_mci(mci);
 
 	if (edac_debug_level >= 4) {
-		int i;
 
 		for (i = 0; i < mci->nr_csrows; i++) {
-			int j;
-
 			edac_mc_dump_csrow(&mci->csrows[i]);
 			for (j = 0; j < mci->csrows[i].nr_channels; j++)
 				edac_mc_dump_channel(&mci->csrows[i].
@@ -685,7 +709,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 		int row, int channel, const char *msg)
 {
 	unsigned long remapped_page;
-	char detail[80];
+	char detail[80], *label = NULL;
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
@@ -712,6 +736,9 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
+	if (mci->csrows[row].channels[channel].dimm)
+		label = mci->csrows[row].channels[channel].dimm->label;
+
 	/* Memory type dependent details about the error */
 	snprintf(detail, sizeof(detail),
 		 " (page 0x%lx, offset 0x%lx, grain %d, "
@@ -719,8 +746,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 		 page_frame_number, offset_in_page,
 		 mci->csrows[row].grain, syndrome, row, channel);
 	trace_mc_error(HW_EVENT_ERR_CORRECTED, mci->mc_idx,
-		       mci->csrows[row].channels[channel].label,
-		       msg, detail);
+		       label, msg, detail);
 
 	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
@@ -729,7 +755,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 			"0x%lx, row %d, channel %d, label \"%s\": %s\n",
 			page_frame_number, offset_in_page,
 			mci->csrows[row].grain, syndrome, row, channel,
-			mci->csrows[row].channels[channel].label, msg);
+			label, msg);
 
 	mci->ce_count++;
 	mci->csrows[row].ce_count++;
@@ -777,7 +803,7 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
 	char *pos = labels;
 	int chan;
 	int chars;
-	char detail[80];
+	char detail[80], *label = NULL;
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
@@ -793,17 +819,21 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
 		return;
 	}
 
-	chars = snprintf(pos, len + 1, "%s",
-			 mci->csrows[row].channels[0].label);
-	len -= chars;
-	pos += chars;
+	if (mci->csrows[row].channels[0].dimm) {
+		label = mci->csrows[row].channels[0].dimm->label;
+		chars = snprintf(pos, len + 1, "%s", label);
+		len -= chars;
+		pos += chars;
+	}
 
 	for (chan = 1; (chan < mci->csrows[row].nr_channels) && (len > 0);
 		chan++) {
-		chars = snprintf(pos, len + 1, ":%s",
-				 mci->csrows[row].channels[chan].label);
-		len -= chars;
-		pos += chars;
+		if (mci->csrows[row].channels[chan].dimm) {
+			label = mci->csrows[row].channels[chan].dimm->label;
+			chars = snprintf(pos, len + 1, ":%s", label);
+			len -= chars;
+			pos += chars;
+		}
 	}
 
 	/* Memory type dependent details about the error */
@@ -861,7 +891,7 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
 	char labels[len + 1];
 	char *pos = labels;
 	int chars;
-	char detail[80];
+	char detail[80], *label;
 
 	if (csrow >= mci->nr_csrows) {
 		/* something is wrong */
@@ -903,12 +933,15 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
 	mci->csrows[csrow].ue_count++;
 
 	/* Generate the DIMM labels from the specified channels */
-	chars = snprintf(pos, len + 1, "%s",
-			 mci->csrows[csrow].channels[channela].label);
-	len -= chars;
-	pos += chars;
-	chars = snprintf(pos, len + 1, "-%s",
-			 mci->csrows[csrow].channels[channelb].label);
+	if (mci->csrows[csrow].channels[channela].dimm) {
+		label = mci->csrows[csrow].channels[channela].dimm->label;
+		chars = snprintf(pos, len + 1, "%s", label);
+		len -= chars;
+		pos += chars;
+	}
+	if (mci->csrows[csrow].channels[channela].dimm)
+		chars = snprintf(pos, len + 1, "-%s",
+				mci->csrows[csrow].channels[channelb].dimm->label);
 
 	/* Memory type dependent details about the error */
 	snprintf(detail, sizeof(detail),
@@ -937,7 +970,7 @@ EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
 void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 			unsigned int csrow, unsigned int channel, char *msg)
 {
-	char detail[80];
+	char detail[80], *label = NULL;
 	/* Ensure boundary values */
 	if (csrow >= mci->nr_csrows) {
 		/* something is wrong */
@@ -964,16 +997,18 @@ void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 	snprintf(detail, sizeof(detail),
 		 "(row %d, channel %d)\n",
 		 csrow, channel);
+
+	if (mci->csrows[csrow].channels[channel].dimm)
+		label = mci->csrows[csrow].channels[channel].dimm->label;
+
 	trace_mc_error(HW_EVENT_ERR_CORRECTED, mci->mc_idx,
-		       mci->csrows[csrow].channels[channel].label,
-		       msg, detail);
+		       label, msg, detail);
 
 	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
 			"CE row %d, channel %d, label \"%s\": %s\n",
-			csrow, channel,
-			mci->csrows[csrow].channels[channel].label, msg);
+			csrow, channel, label, msg);
 
 	mci->ce_count++;
 	mci->csrows[csrow].ce_count++;
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 29ffa35..fed653a 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -170,11 +170,13 @@ static ssize_t channel_dimm_label_show(struct csrow_info *csrow,
 				char *data, int channel)
 {
 	/* if field has not been initialized, there is nothing to send */
-	if (!csrow->channels[channel].label[0])
+	if (!csrow->channels[channel].dimm)
+		return 0;
+	if (!csrow->channels[channel].dimm->label[0])
 		return 0;
 
 	return snprintf(data, EDAC_MC_LABEL_LEN, "%s\n",
-			csrow->channels[channel].label);
+			csrow->channels[channel].dimm->label);
 }
 
 static ssize_t channel_dimm_label_store(struct csrow_info *csrow,
@@ -183,9 +185,12 @@ static ssize_t channel_dimm_label_store(struct csrow_info *csrow,
 {
 	ssize_t max_size = 0;
 
+	if (!csrow->channels[channel].dimm)
+		return -EINVAL;
+
 	max_size = min((ssize_t) count, (ssize_t) EDAC_MC_LABEL_LEN - 1);
-	strncpy(csrow->channels[channel].label, data, max_size);
-	csrow->channels[channel].label[max_size] = '\0';
+	strncpy(csrow->channels[channel].dimm->label, data, max_size);
+	csrow->channels[channel].dimm->label[max_size] = '\0';
 
 	return max_size;
 }
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index bcbdeec..302e43b 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -428,12 +428,16 @@ static void i5100_handle_ce(struct mem_ctl_info *mci,
 			    const char *msg)
 {
 	const int csrow = i5100_rank_to_csrow(mci, chan, rank);
+	char *label = NULL;
+
+	if (mci->csrows[csrow].channels[0].dimm)
+		label = mci->csrows[csrow].channels[0].dimm->label;
 
 	printk(KERN_ERR
 		"CE chan %d, bank %u, rank %u, syndrome 0x%lx, "
 		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
 		chan, bank, rank, syndrome, cas, ras,
-		csrow, mci->csrows[csrow].channels[0].label, msg);
+		csrow, label, msg);
 
 	mci->ce_count++;
 	mci->csrows[csrow].ce_count++;
@@ -450,12 +454,16 @@ static void i5100_handle_ue(struct mem_ctl_info *mci,
 			    const char *msg)
 {
 	const int csrow = i5100_rank_to_csrow(mci, chan, rank);
+	char *label = NULL;
+
+	if (mci->csrows[csrow].channels[0].dimm)
+		label = mci->csrows[csrow].channels[0].dimm->label;
 
 	printk(KERN_ERR
 		"UE chan %d, bank %u, rank %u, syndrome 0x%lx, "
 		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
 		chan, bank, rank, syndrome, cas, ras,
-		csrow, mci->csrows[csrow].channels[0].label, msg);
+		csrow, label, msg);
 
 	mci->ue_count++;
 	mci->csrows[csrow].ue_count++;
@@ -840,7 +848,10 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 	int i;
 	unsigned long total_pages = 0UL;
 	struct i5100_priv *priv = mci->pvt_info;
+	struct dimm_info *dimm;
 
+	dimm = mci->dimms;
+	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
 	for (i = 0; i < mci->nr_csrows; i++) {
 		const unsigned long npages = i5100_npages(mci, i);
 		const unsigned chan = i5100_csrow_to_chan(mci, i);
@@ -871,11 +882,16 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 		mci->csrows[i].channels[0].chan_idx = 0;
 		mci->csrows[i].channels[0].ce_count = 0;
 		mci->csrows[i].channels[0].csrow = mci->csrows + i;
-		snprintf(mci->csrows[i].channels[0].label,
-			 sizeof(mci->csrows[i].channels[0].label),
-			 "DIMM%u", i5100_rank_to_slot(mci, chan, rank));
-
 		total_pages += npages;
+
+		mci->csrows[i].channels[0].dimm = dimm;
+		dimm->location.mc_channel = chan;
+		dimm->location.mc_dimm_number = rank;
+		snprintf(dimm->label, sizeof(dimm->label),
+			 "DIMM%u",
+			 i5100_rank_to_slot(mci, chan, rank));
+		mci->nr_dimms++;
+		dimm++;
 	}
 }
 
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 70ad892..4819df8 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -592,7 +592,7 @@ static int i7core_get_active_channels(const u8 socket, unsigned *channels,
 	return 0;
 }
 
-static int get_dimm_config(const struct mem_ctl_info *mci)
+static int get_dimm_config(struct mem_ctl_info *mci)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	struct csrow_info *csr;
@@ -602,6 +602,7 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 	unsigned long last_page = 0;
 	enum edac_type mode;
 	enum mem_type mtype;
+	struct dimm_info *dimm;
 
 	/* Get data from the MC register, function 0 */
 	pdev = pvt->pci_mcr[0];
@@ -638,6 +639,8 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 		numrow(pvt->info.max_dod >> 6),
 		numcol(pvt->info.max_dod >> 9));
 
+	dimm = mci->dimms;
+	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
 	for (i = 0; i < NUM_CHANS; i++) {
 		u32 data, dimm_dod[3], value[8];
 
@@ -744,12 +747,17 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 				csr->dtype = DEV_UNKNOWN;
 			}
 
+			csr->channels[0].dimm = dimm;
+			dimm->location.mc_channel = i;
+			dimm->location.mc_dimm_number = j;
+			snprintf(dimm->label, sizeof(dimm->label),
+				 "CPU#%uChannel#%u_DIMM#%u",
+				 pvt->i7core_dev->socket, i, j);
+			mci->nr_dimms++;
+			dimm++;
+
 			csr->edac_mode = mode;
 			csr->mtype = mtype;
-			snprintf(csr->channels[0].label,
-					sizeof(csr->channels[0].label),
-					"CPU#%uChannel#%u_DIMM#%u",
-					pvt->i7core_dev->socket, i, j);
 
 			csrow++;
 		}
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index a5da732..4a4026e 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -364,6 +364,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 	u8 value;
 	u32 cumul_size;
 	int index, chan;
+	struct dimm_info *dimm;
 
 	last_cumul_size = 0;
 
@@ -376,6 +377,8 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 	 *
 	 */
 
+	mci->dimm_loc_type = DIMM_LOC_CSROW;
+	dimm = mci->dimms;
 	for (index = 0; index < mci->nr_csrows; index++) {
 		csrow = &mci->csrows[index];
 
@@ -398,10 +401,16 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		 *   [0-7] for single-channel; i.e. csrow->nr_channels = 1
 		 *   [0-3] for dual-channel; i.e. csrow->nr_channels = 2
 		 */
-		for (chan = 0; chan < csrow->nr_channels; chan++)
-			strncpy(csrow->channels[chan].label,
+		for (chan = 0; chan < csrow->nr_channels; chan++) {
+			mci->csrows[index].channels[chan].dimm = dimm;
+			dimm->location.csrow = index;
+			dimm->location.csrow_channel = chan;
+			strncpy(csrow->channels[chan].dimm->label,
 					labels[(index >> 1) + (chan * 2)],
 					EDAC_MC_LABEL_LEN);
+			dimm++;
+			mci->nr_dimms++;
+		}
 
 		if (cumul_size == last_cumul_size)
 			continue;	/* not populated */
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 7a402bf..34fa898 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -550,7 +550,7 @@ static int sbridge_get_active_channels(const u8 bus, unsigned *channels,
 	return 0;
 }
 
-static int get_dimm_config(const struct mem_ctl_info *mci)
+static int get_dimm_config(struct mem_ctl_info *mci)
 {
 	struct sbridge_pvt *pvt = mci->pvt_info;
 	struct csrow_info *csr;
@@ -560,6 +560,7 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 	u32 reg;
 	enum edac_type mode;
 	enum mem_type mtype;
+	struct dimm_info *dimm;
 
 	pci_read_config_dword(pvt->pci_br, SAD_TARGET, &reg);
 	pvt->sbridge_dev->source_id = SOURCE_ID(reg);
@@ -611,6 +612,8 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 	/* On all supported DDR3 DIMM types, there are 8 banks available */
 	banks = 8;
 
+	dimm = mci->dimms;
+	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
 	for (i = 0; i < NUM_CHANNELS; i++) {
 		u32 mtr;
 
@@ -650,12 +653,17 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 				csr->channels[0].chan_idx = i;
 				csr->channels[0].ce_count = 0;
 				pvt->csrow_map[i][j] = csrow;
-				snprintf(csr->channels[0].label,
-					 sizeof(csr->channels[0].label),
-					 "CPU_SrcID#%u_Channel#%u_DIMM#%u",
-					 pvt->sbridge_dev->source_id, i, j);
 				last_page += npages;
 				csrow++;
+
+				csr->channels[0].dimm = dimm;
+				dimm->location.mc_channel = i;
+				dimm->location.mc_dimm_number = j;
+				snprintf(dimm->label, sizeof(dimm->label),
+					 "CPU_SrcID#%u_Channel#%u_DIMM#%u",
+					 pvt->sbridge_dev->source_id, i, j);
+				mci->nr_dimms++;
+				dimm++;
 			}
 		}
 	}
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 6e3ab94..9f4deed 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -249,10 +249,31 @@ enum scrub_type {
  * PS - I enjoyed writing all that about as much as you enjoyed reading it.
  */
 
+enum dimm_location_type {
+	DIMM_LOC_CSROW,
+	DIMM_LOC_MC_CHANNEL,
+};
+
+/* FIXME: add a per-dimm ce error count */
+struct dimm_info {
+	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
+	unsigned memory_controller;
+	union {
+		struct {
+			unsigned mc_channel;
+			unsigned mc_dimm_number;
+		};
+		struct {
+			unsigned csrow;
+			unsigned csrow_channel;
+		};
+	} location;
+};
+
 struct csrow_channel_info {
 	int chan_idx;		/* channel index */
 	u32 ce_count;		/* Correctable Errors for this CHANNEL */
-	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
+	struct dimm_info *dimm;
 	struct csrow_info *csrow;	/* the parent */
 };
 
@@ -353,6 +374,14 @@ struct mem_ctl_info {
 	int mc_idx;
 	int nr_csrows;
 	struct csrow_info *csrows;
+
+	/*
+	 * DIMM info. Will eventually remove the entire csrows_info some day
+	 */
+	enum dimm_location_type dimm_loc_type;
+	unsigned nr_dimms;
+	struct dimm_info *dimms;
+
 	/*
 	 * FIXME - what about controllers on other busses? - IDs must be
 	 * unique.  dev pointer should be sufficiently unique, but
-- 
1.7.8

