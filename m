Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab2CGLhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:37:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab2CGLhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:37:38 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] edac: rename channel_info to rank_info
Date: Wed,  7 Mar 2012 08:37:32 -0300
Message-Id: <1331120252-27474-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What it is pointed by a csrow/channel vector is a rank information, and
not a channel information.

On a traditional architecture, the memory controller directly access the
memory ranks, via chip select rows. Different ranks at the same DIMM is
selected via different chip select rows. So, typically, one
csrow/channel pair means one different DIMM.

On FB-DIMMs, there's a microcontroller chip at the DIMM, called Advanced
Memory Buffer (AMB) that serves as the interface between the memory
controller and the memory chips.

The AMB selection is via the DIMM slot, and not via a csrow.

It is up to the AMB to talk with the csrows of the DRAM chips.

So, the FB-DIMM memory controllers see the DIMM slot, and not the DIMM
rank. RAMBUS is similar.

Newer memory controllers, like the ones found on Intel Sandy Bridge and
Nehalem, even working with normal DDR3 DIMM's, don't use the usual
channel A/channel B interleaving schema to provide 128 bits data access.

Instead, they have more channels (3 or 4 channels), and they can use
several interleaving schemas. Such memory controllers see the DIMMs
directly on their registers, instead of the ranks, which is better for
the driver, as its main usageis to point to a broken DIMM stick (the
Field Repleceable Unit), and not to point to a broken DRAM chip.

The drivers that support such such newer memory architecture models
currently need to fake information and to abuse on EDAC structures, as
the subsystem was conceived with the idea that the csrow would always be
visible by the CPU.

To make things a little worse, those drivers don't currently fake
csrows/channels on a consistent way, as the concepts there don't apply
to the memory controllers they're talking with. So, each driver author
interpreted the concepts using a different logic.

In order to fix it, let's rename the data structure that points into a
DIMM rank to "rank_info", in order to be clearer about what's stored
there.

Latter patches will provide a better way to represent the memory
hierarchy for the other types of memory controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c |    6 +++---
 include/linux/edac.h   |   22 +++++++++++++++++-----
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index d69144a..7188e60 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -40,7 +40,7 @@ static LIST_HEAD(mc_devices);
 
 #ifdef CONFIG_EDAC_DEBUG
 
-static void edac_mc_dump_channel(struct channel_info *chan)
+static void edac_mc_dump_channel(struct rank_info *chan)
 {
 	debugf4("\tchannel = %p\n", chan);
 	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
@@ -157,7 +157,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 {
 	struct mem_ctl_info *mci;
 	struct csrow_info *csi, *csrow;
-	struct channel_info *chi, *chp, *chan;
+	struct rank_info *chi, *chp, *chan;
 	void *pvt;
 	unsigned size;
 	int row, chn;
@@ -182,7 +182,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	 * rather than an imaginary chunk of memory located at address 0.
 	 */
 	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
-	chi = (struct channel_info *)(((char *)mci) + ((unsigned long)chi));
+	chi = (struct rank_info *)(((char *)mci) + ((unsigned long)chi));
 	pvt = sz_pvt ? (((char *)mci) + ((unsigned long)pvt)) : NULL;
 
 	/* setup index and various internal pointers */
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 96f996f..b14e33d 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -335,10 +335,22 @@ enum scrub_type {
  * PS - I enjoyed writing all that about as much as you enjoyed reading it.
  */
 
-struct channel_info {
-	int chan_idx;		/* channel index */
-	u32 ce_count;		/* Correctable Errors for this CHANNEL */
-	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
+/**
+ * struct rank_info - contains the information for one DIMM rank
+ *
+ * @chan_idx:	channel number where the rank is (typically, 0 or 1)
+ * @ce_count:	number of correctable errors for this rank
+ * @label:	DIMM label. Different ranks for the same DIMM should be
+ *		filled, on userspace, with the same label.
+ *		FIXME: The core currently won't enforce it.
+ * @csrow:	A pointer to the chip select row structure (the parent
+ *		structure). The location of the rank is given by
+ *		the (csrow->csrow_idx, chan_idx) vector.
+ */
+struct rank_info {
+	int chan_idx;
+	u32 ce_count;
+	char label[EDAC_MC_LABEL_LEN + 1];
 	struct csrow_info *csrow;	/* the parent */
 };
 
@@ -362,7 +374,7 @@ struct csrow_info {
 
 	/* channel information for this csrow */
 	u32 nr_channels;
-	struct channel_info *channels;
+	struct rank_info *channels;
 };
 
 struct mcidev_sysfs_group {
-- 
1.7.8

