Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab2ERQwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:52:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758501Ab2ERQdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:03 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH EDAC v26 34/66] edac: Initialize the dimm label with the known information
Date: Fri, 18 May 2012 13:32:21 -0300
Message-Id: <1337358773-6919-35-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While userspace doesn't fill the dimm labels, add there the dimm location,
as described by the used memory model. This could eventually match what
is described at the dmidecode, making easier for people to identify the
memory.

For example, on an Intel motherboard where the DMI table is reliable,
the first memory stick is described as:

Memory Device
	Array Handle: 0x0029
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 1
	Locator: A1_DIMM0
	Bank Locator: A1_Node0_Channel0_Dimm0
	Type: <OUT OF SPEC>
	Type Detail: Synchronous
	Speed: 800 MHz
	Manufacturer: A1_Manufacturer0
	Serial Number: A1_SerNum0
	Asset Tag: A1_AssetTagNum0
	Part Number: A1_PartNum0

The memory named as "A1_DIMM0" is physically located at the first
memory controller (node 0), at channel 0, dimm slot 0.

After this patch, the memory label will be filled with:
	/sys/devices/system/edac/mc/csrow0/ch0_dimm_label:mc#0channel#0slot#0

And (after the new EDAC API patches) as:
	/sys/devices/system/edac/mc/mc0/dimm0/dimm_label:mc#0channel#0slot#0

So, even if the memory label is not initialized on userspace, an useful
information with the error location is filled there, expecially since
several systems/motherboards are provided with enough info to map from
channel/slot (or branch/channel/slot) into the DIMM label. So, letting the
EDAC core fill it by default is a good thing.

It should noticed that, as the label filling happens at the
edac_mc_alloc(), drivers can override it to better describe the memories
(and some actually do it).

Cc: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c       |   28 ++++++++++++++++++++++------
 drivers/edac/edac_mc_sysfs.c |    8 ++++----
 include/linux/edac.h         |    2 +-
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 06028de..10f3750 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -210,10 +210,10 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	struct dimm_info *dimm;
 	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
 	unsigned pos[EDAC_MAX_LAYERS];
-	void *pvt, *ptr = NULL;
 	unsigned size, tot_dimms = 1, count = 1;
 	unsigned tot_csrows = 1, tot_channels = 1, tot_errcount = 0;
-	int i, j, err, row, chn;
+	void *pvt, *p, *ptr = NULL;
+	int i, j, err, row, chn, n, len;
 	bool per_rank = false;
 
 	BUG_ON(n_layers > EDAC_MAX_LAYERS || n_layers == 0);
@@ -325,10 +325,26 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 			i, per_rank ? "rank" : "dimm", (dimm - mci->dimms),
 			pos[0], pos[1], pos[2], row, chn);
 
-		/* Copy DIMM location */
-		for (j = 0; j < n_layers; j++)
+		/*
+		 * Copy DIMM location and initialize it.
+		 */
+		len = sizeof(dimm->label);
+		p = dimm->label;
+		n = snprintf(p, len, "mc#%u", mc_num);
+		p += n;
+		len -= n;
+		for (j = 0; j < n_layers; j++) {
+			n = snprintf(p, len, "%s#%u",
+				     edac_layer_name[layers[j].type],
+				     pos[j]);
+			p += n;
+			len -= n;
 			dimm->location[j] = pos[j];
 
+			if (len <= 0)
+				break;
+		}
+
 		/* Link it to the csrows old API data */
 		chan->dimm = dimm;
 		dimm->csrow = row;
@@ -834,7 +850,7 @@ static void edac_inc_ce_error(struct mem_ctl_info *mci,
 {
 	int i, index = 0;
 
-	mci->ce_count++;
+	mci->ce_mc++;
 
 	if (!enable_per_layer_report) {
 		mci->ce_noinfo_count++;
@@ -858,7 +874,7 @@ static void edac_inc_ue_error(struct mem_ctl_info *mci,
 {
 	int i, index = 0;
 
-	mci->ue_count++;
+	mci->ue_mc++;
 
 	if (!enable_per_layer_report) {
 		mci->ce_noinfo_count++;
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 1dc1c6c..f6a29b0 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -425,8 +425,8 @@ static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 
 	mci->ue_noinfo_count = 0;
 	mci->ce_noinfo_count = 0;
-	mci->ue_count = 0;
-	mci->ce_count = 0;
+	mci->ue_mc = 0;
+	mci->ce_mc = 0;
 
 	for (row = 0; row < mci->nr_csrows; row++) {
 		struct csrow_info *ri = &mci->csrows[row];
@@ -495,12 +495,12 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
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
diff --git a/include/linux/edac.h b/include/linux/edac.h
index d68b01c..91ba3ba 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -581,7 +581,7 @@ struct mem_ctl_info {
 	 * already handles that.
 	 */
 	u32 ce_noinfo_count, ue_noinfo_count;
-	u32 ue_count, ce_count;
+	u32 ue_mc, ce_mc;
 	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
 
 	struct completion complete;
-- 
1.7.8

