Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab2DPUjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:39:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab2DPUiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:38:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: [EDAC ABI v13 01/25] edac: Initialize the dimm label with the known information
Date: Mon, 16 Apr 2012 17:38:25 -0300
Message-Id: <1334608729-30803-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While userspace doesn't fill the dimm labels, add there the dimm location,
as described by the used memory model. This could eventually match what
is described at the dmidecode, making easier for people to identify the
memory.

For example, on an Intel motherboard, the memory is described as:

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

After this patch, the memory label will be filled with:
	/sys/devices/system/edac/mc/mc0/dimm0/dimm_label:mc#0channel#0slot#0

With somewhat matches what it is at the Bank Locator DMI information.
So, it is easier to associate the dimm labels, of course assuming that
the DMI has the Bank Locator filled, and the BIOS doesn't have any bugs.

Yet, even without it, several motherboards are provided with enough
info to map from channel/slot (or branch/channel/slot) into the DIMM
label. So, letting the EDAC core fill it, by default is a good thing.

It should noticed that, as the label filling happens at the
edac_mc_alloc(), drivers can override it to better describe the memories
(and some actually do it).

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c       |   21 +++++++++++++++++----
 drivers/edac/edac_mc_sysfs.c |    8 ++++----
 include/linux/edac.h         |    2 --
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index f5be026..3323d99 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -202,10 +202,10 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	struct rank_info *chi, *chp, *chan;
 	struct dimm_info *dimm;
 	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
-	void *pvt;
+	void *pvt, *p;
 	unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
 	unsigned tot_csrows, tot_cschannels;
-	int i, j;
+	int i, j, n, len;
 	int err;
 	int row, chn;
 
@@ -311,9 +311,22 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 			i, (dimm - mci->dimms),
 			pos[0], pos[1], pos[2], row, chn);
 
-		/* Copy DIMM location */
-		for (j = 0; j < n_layers; j++)
+		/*
+		 * Copy DIMM location and initialize the memory location
+		 */
+		len = sizeof(dimm->label);
+		p = dimm->label;
+		n = snprintf(p, len, "mc#%u", edac_index);
+		p += n;
+		len -= n;
+		for (j = 0; j < n_layers; j++) {
+			n = snprintf(p, len, "%s#%u",
+				     edac_layer_name[layers[j].type],
+				     pos[j]);
+			p += n;
+			len -= n;
 			dimm->location[j] = pos[j];
+		}
 
 		/* Link it to the csrows old API data */
 		chan->dimm = dimm;
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index c0275e6..cfeb92c 100644
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
index 1439670..6d8c394 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -553,8 +553,6 @@ struct mem_ctl_info {
 	const char *dev_name;
 	char proc_name[MC_PROC_NAME_MAX_LEN + 1];
 	void *pvt_info;
-	u32 ue_count;           /* Total Uncorrectable Errors for this MC */
-	u32 ce_count;           /* Total Correctable Errors for this MC */
 	unsigned long start_time;	/* mci load start time (in jiffies) */
 
 	/* drivers shouldn't access this struct directly */
-- 
1.7.8

