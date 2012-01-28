Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab2A1Pd7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:33:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab2A1Pc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:32:58 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv2 08/16] edac: Prepare to push down to drivers the filling of the dimm_info
Date: Sat, 28 Jan 2012 13:32:43 -0200
Message-Id: <1327764771-28649-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
References: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several data that it is currently stored per csrow will be
pushed into the dimm themselves. Due to that, the mci->dimms
filling will need to happen inside the drivers.

Prepare for that, by initializing the dimm fields during mci
alloc. With this change, the changes at the drivers will be
smaller, as they won't need to touch at the fields they don't
currently initialize.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c      |   43 ++++++++++++++++++++-----------------------
 drivers/edac/i5100_edac.c   |    1 +
 drivers/edac/i7core_edac.c  |    1 +
 drivers/edac/i82975x_edac.c |    1 +
 drivers/edac/sb_edac.c      |    1 +
 5 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 93ef044..37dca79 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -214,6 +214,24 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 		}
 	}
 
+	/*
+	 * By default, assumes that a per-csrow arrangement will be used,
+	 * as most drivers are based on such assumption.
+	 */
+	if (!mci->nr_dimms) {
+		mci->dimm_loc_type = DIMM_LOC_CSROW;
+		dimm = mci->dimms;
+		for (row = 0; row < mci->nr_csrows; row++) {
+			for (chn = 0; chn < mci->csrows[row].nr_channels; chn++) {
+				mci->csrows[row].channels[chn].dimm = dimm;
+				dimm->location.csrow = row;
+				dimm->location.csrow_channel = chn;
+				dimm++;
+				mci->nr_dimms++;
+			}
+		}
+	}
+
 	mci->op_state = OP_ALLOC;
 	INIT_LIST_HEAD(&mci->grp_kobj_list);
 
@@ -512,37 +530,16 @@ EXPORT_SYMBOL(edac_mc_find);
 /* FIXME - should a warning be printed if no error detection? correction? */
 int edac_mc_add_mc(struct mem_ctl_info *mci)
 {
-	int i, j;
-	struct dimm_info *dimm;
-
 	debugf0("%s()\n", __func__);
 
-	/*
-	 * If nr_dimms is not filled, that means that the driver itself
-	 * were not converted to use the new struct, or that the driver
-	 * is for a csrow-based device.
-	 * Fill the dimms accordingly.
-	 */
-	if (!mci->nr_dimms) {
-		mci->dimm_loc_type = DIMM_LOC_CSROW;
-		dimm = mci->dimms;
-		for (i = 0; i < mci->nr_csrows; i++) {
-			for (j = 0; j < mci->csrows[i].nr_channels; j++) {
-				mci->csrows[i].channels[j].dimm = dimm;
-				dimm->location.csrow = i;
-				dimm->location.csrow_channel = j;
-				dimm++;
-				mci->nr_dimms++;
-			}
-		}
-	}
 #ifdef CONFIG_EDAC_DEBUG
 	if (edac_debug_level >= 3)
 		edac_mc_dump_mci(mci);
 
 	if (edac_debug_level >= 4) {
-
+		int i;
 		for (i = 0; i < mci->nr_csrows; i++) {
+			int j;
 			edac_mc_dump_csrow(&mci->csrows[i]);
 			for (j = 0; j < mci->csrows[i].nr_channels; j++)
 				edac_mc_dump_channel(&mci->csrows[i].
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 302e43b..52939ca 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -852,6 +852,7 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 
 	dimm = mci->dimms;
 	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
+	mci->nr_dimms = 0;
 	for (i = 0; i < mci->nr_csrows; i++) {
 		const unsigned long npages = i5100_npages(mci, i);
 		const unsigned chan = i5100_csrow_to_chan(mci, i);
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 4819df8..d6dd9bf 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -641,6 +641,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 
 	dimm = mci->dimms;
 	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
+	mci->nr_dimms = 0;
 	for (i = 0; i < NUM_CHANS; i++) {
 		u32 data, dimm_dod[3], value[8];
 
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 4a4026e..47f023e 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -379,6 +379,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 
 	mci->dimm_loc_type = DIMM_LOC_CSROW;
 	dimm = mci->dimms;
+	mci->nr_dimms = 0;
 	for (index = 0; index < mci->nr_csrows; index++) {
 		csrow = &mci->csrows[index];
 
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 34fa898..43fc65e 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -614,6 +614,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 
 	dimm = mci->dimms;
 	mci->dimm_loc_type = DIMM_LOC_MC_CHANNEL;
+	mci->nr_dimms = 0;
 	for (i = 0; i < NUM_CHANNELS; i++) {
 		u32 mtr;
 
-- 
1.7.8

