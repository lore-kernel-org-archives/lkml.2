Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab2CGLks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:40:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395Ab2CGLkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:40:45 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] edac: Create a dimm struct and move the labels into it
Date: Wed,  7 Mar 2012 08:40:33 -0300
Message-Id: <1331120438-27523-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
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
the real location of the socket, in terms of csrow/channel.
Latter patches will modify the location to properly represent the
memory architecture.

All other drivers will use a per-csrow type of location.
Some of those drivers will require a latter conversion, as
they also fake the csrows internally.

TODO: While this patch doesn't change the existing behavior, on
csrows-based memory controllers, a csrow/channel pair points to a memory
rank. There's a known bug at the EDAC core that allows having different
labels for the same DIMM, if it has more than one rank. A latter patch
is need to merge the several ranks for a DIMM into the same dimm_info
struct, in order to avoid having different labels for the same DIMM.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c       |   75 ++++++++++++++++++++++++++++++-----------
 drivers/edac/edac_mc_sysfs.c |   16 +++++---
 drivers/edac/i5100_edac.c    |    8 ++--
 drivers/edac/i7core_edac.c   |    4 +-
 drivers/edac/i82975x_edac.c  |    2 +-
 include/linux/edac.h         |   28 +++++++++++++---
 6 files changed, 95 insertions(+), 38 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 7188e60..c3b5cff 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -45,7 +45,8 @@ static void edac_mc_dump_channel(struct rank_info *chan)
 	debugf4("\tchannel = %p\n", chan);
 	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
 	debugf4("\tchannel->ce_count = %d\n", chan->ce_count);
-	debugf4("\tchannel->label = '%s'\n", chan->label);
+	if (chan->dimm)
+		debugf4("\tchannel->label = '%s'\n", chan->dimm->label);
 	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
 }
 
@@ -158,6 +159,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	struct mem_ctl_info *mci;
 	struct csrow_info *csi, *csrow;
 	struct rank_info *chi, *chp, *chan;
+	struct dimm_info *dimm;
 	void *pvt;
 	unsigned size;
 	int row, chn;
@@ -171,7 +173,8 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	mci = (struct mem_ctl_info *)0;
 	csi = edac_align_ptr(&mci[1], sizeof(*csi));
 	chi = edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
-	pvt = edac_align_ptr(&chi[nr_chans * nr_csrows], sz_pvt);
+	dimm = edac_align_ptr(&chi[nr_chans * nr_csrows], sizeof(*dimm));
+	pvt = edac_align_ptr(&dimm[nr_chans * nr_csrows], sz_pvt);
 	size = ((unsigned long)pvt) + sz_pvt;
 
 	mci = kzalloc(size, GFP_KERNEL);
@@ -181,13 +184,14 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	/* Adjust pointers so they point within the memory we just allocated
 	 * rather than an imaginary chunk of memory located at address 0.
 	 */
-	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
 	chi = (struct rank_info *)(((char *)mci) + ((unsigned long)chi));
+	dimm = (struct dimm_info *)(((char *)mci) + ((unsigned long)dimm));
 	pvt = sz_pvt ? (((char *)mci) + ((unsigned long)pvt)) : NULL;
 
 	/* setup index and various internal pointers */
 	mci->mc_idx = edac_index;
 	mci->csrows = csi;
+	mci->dimms  = dimm;
 	mci->pvt_info = pvt;
 	mci->nr_csrows = nr_csrows;
 
@@ -206,6 +210,21 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 		}
 	}
 
+	/*
+	 * By default, assumes that a per-csrow arrangement will be used,
+	 * as most drivers are based on such assumption.
+	 */
+	dimm = mci->dimms;
+	for (row = 0; row < mci->nr_csrows; row++) {
+		for (chn = 0; chn < mci->csrows[row].nr_channels; chn++) {
+			mci->csrows[row].channels[chn].dimm = dimm;
+			dimm->csrow = row;
+			dimm->csrow_channel = chn;
+			dimm++;
+			mci->nr_dimms++;
+		}
+	}
+
 	mci->op_state = OP_ALLOC;
 	INIT_LIST_HEAD(&mci->grp_kobj_list);
 
@@ -679,6 +698,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 		int row, int channel, const char *msg)
 {
 	unsigned long remapped_page;
+	char *label = NULL;
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
@@ -702,6 +722,9 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
+	if (mci->csrows[row].channels[channel].dimm)
+		label = mci->csrows[row].channels[channel].dimm->label;
+
 	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
@@ -709,7 +732,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 			"0x%lx, row %d, channel %d, label \"%s\": %s\n",
 			page_frame_number, offset_in_page,
 			mci->csrows[row].grain, syndrome, row, channel,
-			mci->csrows[row].channels[channel].label, msg);
+			label, msg);
 
 	mci->ce_count++;
 	mci->csrows[row].ce_count++;
@@ -755,6 +778,7 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
 	char *pos = labels;
 	int chan;
 	int chars;
+	char *label = NULL;
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
@@ -768,17 +792,21 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
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
 
 	if (edac_mc_get_log_ue())
@@ -825,6 +853,7 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
 	char labels[len + 1];
 	char *pos = labels;
 	int chars;
+	char *label;
 
 	if (csrow >= mci->nr_csrows) {
 		/* something is wrong */
@@ -859,12 +888,15 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
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
 
 	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
@@ -886,6 +918,7 @@ EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
 void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 			unsigned int csrow, unsigned int channel, char *msg)
 {
+	char *label = NULL;
 
 	/* Ensure boundary values */
 	if (csrow >= mci->nr_csrows) {
@@ -905,12 +938,14 @@ void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
+	if (mci->csrows[csrow].channels[channel].dimm)
+		label = mci->csrows[csrow].channels[channel].dimm->label;
+
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
index 29ffa35..f99a83d 100644
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
@@ -952,9 +957,8 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	/* CSROW error: backout what has already been registered,  */
 fail1:
 	for (i--; i >= 0; i--) {
-		if (csrow->nr_pages > 0) {
+		if (mci->csrows[i].nr_pages > 0)
 			kobject_put(&mci->csrows[i].kobj);
-		}
 	}
 
 	/* remove the mci instance's attributes, if any */
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index bcbdeec..fd931f4 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -433,7 +433,7 @@ static void i5100_handle_ce(struct mem_ctl_info *mci,
 		"CE chan %d, bank %u, rank %u, syndrome 0x%lx, "
 		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
 		chan, bank, rank, syndrome, cas, ras,
-		csrow, mci->csrows[csrow].channels[0].label, msg);
+		csrow, mci->csrows[csrow].channels[0].dimm->label, msg);
 
 	mci->ce_count++;
 	mci->csrows[csrow].ce_count++;
@@ -455,7 +455,7 @@ static void i5100_handle_ue(struct mem_ctl_info *mci,
 		"UE chan %d, bank %u, rank %u, syndrome 0x%lx, "
 		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
 		chan, bank, rank, syndrome, cas, ras,
-		csrow, mci->csrows[csrow].channels[0].label, msg);
+		csrow, mci->csrows[csrow].channels[0].dimm->label, msg);
 
 	mci->ue_count++;
 	mci->csrows[csrow].ue_count++;
@@ -871,8 +871,8 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 		mci->csrows[i].channels[0].chan_idx = 0;
 		mci->csrows[i].channels[0].ce_count = 0;
 		mci->csrows[i].channels[0].csrow = mci->csrows + i;
-		snprintf(mci->csrows[i].channels[0].label,
-			 sizeof(mci->csrows[i].channels[0].label),
+		snprintf(mci->csrows[i].channels[0].dimm->label,
+			 sizeof(mci->csrows[i].channels[0].dimm->label),
 			 "DIMM%u", i5100_rank_to_slot(mci, chan, rank));
 
 		total_pages += npages;
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 70ad892..9a262c7 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -746,8 +746,8 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 
 			csr->edac_mode = mode;
 			csr->mtype = mtype;
-			snprintf(csr->channels[0].label,
-					sizeof(csr->channels[0].label),
+			snprintf(csr->channels[0].dimm->label,
+					sizeof(csr->channels[0].dimm->label),
 					"CPU#%uChannel#%u_DIMM#%u",
 					pvt->i7core_dev->socket, i, j);
 
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index a5da732..d12e571 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -399,7 +399,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		 *   [0-3] for dual-channel; i.e. csrow->nr_channels = 2
 		 */
 		for (chan = 0; chan < csrow->nr_channels; chan++)
-			strncpy(csrow->channels[chan].label,
+			strncpy(csrow->channels[chan].dimm->label,
 					labels[(index >> 1) + (chan * 2)],
 					EDAC_MC_LABEL_LEN);
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index b14e33d..9289654 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -335,23 +335,34 @@ enum scrub_type {
  * PS - I enjoyed writing all that about as much as you enjoyed reading it.
  */
 
+/* FIXME: add a per-dimm ce error count */
+struct dimm_info {
+	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
+	unsigned memory_controller;
+	unsigned csrow;
+	unsigned csrow_channel;
+};
+
 /**
  * struct rank_info - contains the information for one DIMM rank
  *
  * @chan_idx:	channel number where the rank is (typically, 0 or 1)
  * @ce_count:	number of correctable errors for this rank
- * @label:	DIMM label. Different ranks for the same DIMM should be
- *		filled, on userspace, with the same label.
- *		FIXME: The core currently won't enforce it.
  * @csrow:	A pointer to the chip select row structure (the parent
  *		structure). The location of the rank is given by
  *		the (csrow->csrow_idx, chan_idx) vector.
+ * @dimm:	A pointer to the DIMM structure, where the DIMM label
+ *		information is stored.
+ *
+ * FIXME: Currently, the EDAC core model will assume one DIMM per rank.
+ *	  This is a bad assumption, but it makes this patch easier. Later
+ *	  patches in this series will fix this issue.
  */
 struct rank_info {
 	int chan_idx;
 	u32 ce_count;
-	char label[EDAC_MC_LABEL_LEN + 1];
-	struct csrow_info *csrow;	/* the parent */
+	struct csrow_info *csrow;
+	struct dimm_info *dimm;
 };
 
 struct csrow_info {
@@ -451,6 +462,13 @@ struct mem_ctl_info {
 	int mc_idx;
 	int nr_csrows;
 	struct csrow_info *csrows;
+
+	/*
+	 * DIMM info. Will eventually remove the entire csrows_info some day
+	 */
+	unsigned nr_dimms;
+	struct dimm_info *dimms;
+
 	/*
 	 * FIXME - what about controllers on other busses? - IDs must be
 	 * unique.  dev pointer should be sufficiently unique, but
-- 
1.7.8

