Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2CLMsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:48:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab2CLMsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:48:40 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] edac: display "rank" for csrow-based MC's at the debug msgs
Date: Mon, 12 Mar 2012 09:48:33 -0300
Message-Id: <1331556515-7902-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331556515-7902-1-git-send-email-mchehab@redhat.com>
References: <1331556515-7902-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch complements changeset 114ea60: on all places where the
struct dimm_info actually stores ranks, call it as "rank" at all
displayed messages.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c       |   43 +++++++++++++++++++++++++++++------------
 drivers/edac/edac_mc_sysfs.c |   19 ++++-------------
 include/linux/edac.h         |   12 ++++++++++-
 3 files changed, 46 insertions(+), 28 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index e1589b6..ea5fec4 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -83,6 +83,8 @@ static void edac_mc_dump_csrow(struct csrow_info *csrow)
 
 static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 {
+	const char *type = mci->mem_is_per_rank ? "ranks" : "dimms";
+
 	debugf3("\tmci = %p\n", mci);
 	debugf3("\tmci->mtype_cap = %lx\n", mci->mtype_cap);
 	debugf3("\tmci->edac_ctl_cap = %lx\n", mci->edac_ctl_cap);
@@ -90,8 +92,8 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 	debugf4("\tmci->edac_check = %p\n", mci->edac_check);
 	debugf3("\tmci->num_csrows = %d, csrows = %p\n",
 		mci->num_csrows, mci->csrows);
-	debugf3("\tmci->nr_dimms = %d, dimns = %p\n",
-		mci->tot_dimms, mci->dimms);
+	debugf3("\tmci->nr_%s = %d, %s = %p\n",
+		type, mci->tot_dimms, type, mci->dimms);
 	debugf3("\tdev = %p\n", mci->dev);
 	debugf3("\tmod_name:ctl_name = %s:%s\n", mci->mod_name, mci->ctl_name);
 	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
@@ -171,10 +173,6 @@ void *edac_align_ptr(void **p, unsigned size, int quant)
  * @size_pvt:		size of private storage needed
  *
  *
- * FIXME: drivers handle multi-rank memories on different ways: on some
- * drivers, one multi-rank memory is mapped as one DIMM, while, on others,
- * a single multi-rank DIMM would be mapped into several "dimms".
- *
  * Non-csrow based drivers (like FB-DIMM and RAMBUS ones) will likely report
  * such DIMMS properly, but the CSROWS-based ones will likely do the wrong
  * thing, as two chip select values are used for dual-rank memories (and 4, for
@@ -189,6 +187,12 @@ void *edac_align_ptr(void **p, unsigned size, int quant)
  *
  * Use edac_mc_free() to free mc structures allocated by this function.
  *
+ * NOTE: drivers handle multi-rank memories on different ways: on some
+ * drivers, one multi-rank memory is mapped as one entry, while, on others,
+ * a single multi-rank DIMM would be mapped into several entries. Currently,
+ * this function will allocate multiple struct dimm_info on such scenarios,
+ * as grouping the multiple ranks require drivers change.
+ *
  * Returns:
  *	NULL allocation failed
  *	struct mem_ctl_info pointer
@@ -214,6 +218,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	int i, j, n, len;
 	int err;
 	int row, chn;
+	bool per_rank = false;
 
 	BUG_ON(n_layers > EDAC_MAX_LAYERS);
 	/*
@@ -229,6 +234,11 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 			tot_csrows *= layers[i].size;
 		else
 			tot_cschannels *= layers[i].size;
+
+		if (layers[i].type == EDAC_MC_LAYER_CHIP_SELECT) {
+			per_rank = true;
+			break;
+		}
 	}
 
 	/* Figure out the offsets of the various items from the start of an mc
@@ -257,8 +267,11 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
 	size = ((unsigned long)pvt) + sz_pvt;
 
-	debugf1("%s(): allocating %u bytes for mci data (%d dimms, %d csrows/channels)\n",
-		__func__, size, tot_dimms, tot_csrows * tot_cschannels);
+	debugf1("%s(): allocating %u bytes for mci data (%d %s, %d csrows/channels)\n",
+		__func__, size,
+		tot_dimms,
+		per_rank ? "ranks" : "dimms",
+		tot_csrows * tot_cschannels);
 	mci = kzalloc(size, GFP_KERNEL);
 	if (mci == NULL)
 		return NULL;
@@ -291,6 +304,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	memcpy(mci->layers, layers, sizeof(*lay) * n_layers);
 	mci->num_csrows = tot_csrows;
 	mci->num_cschannel = tot_cschannels;
+	mci->mem_is_per_rank = true;
 
 	/*
 	 * Fills the csrow struct
@@ -316,15 +330,16 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	memset(&pos, 0, sizeof(pos));
 	row = 0;
 	chn = 0;
-	debugf4("%s: initializing %d dimms\n", __func__, tot_dimms);
+	debugf4("%s: initializing %d %s\n", __func__, tot_dimms,
+		per_rank ? "ranks" : "dimms");
 	for (i = 0; i < tot_dimms; i++) {
 		chan = &csi[row].channels[chn];
 		dimm = GET_POS(lay, mci->dimms, n_layers,
 			       pos[0], pos[1], pos[2]);
 		dimm->mci = mci;
 
-		debugf2("%s: %d: dimm%zd (%d:%d:%d): row %d, chan %d\n", __func__,
-			i, (dimm - mci->dimms),
+		debugf2("%s: %d: %s%zd (%d:%d:%d): row %d, chan %d\n", __func__,
+			i, per_rank ? "rank" : "dimm", (dimm - mci->dimms),
 			pos[0], pos[1], pos[2], row, chn);
 
 		/*
@@ -1004,8 +1019,10 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			 * get csrow/channel of the dimm, in order to allow
 			 * incrementing the compat API counters
 			 */
-			debugf4("%s: dimm csrows (%d,%d)\n",
-				__func__, dimm->csrow, dimm->cschannel);
+			debugf4("%s: %s csrows map: (%d,%d)\n",
+				__func__,
+				mci->mem_is_per_rank ? "rank" : "dimm",
+				dimm->csrow, dimm->cschannel);
 			if (row == -1)
 				row = dimm->csrow;
 			else if (row >= 0 && row != dimm->csrow)
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index dd934c2..4452983 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -567,8 +567,7 @@ static struct kobj_type ktype_dimm = {
 };
 /* Create a CSROW object under specifed edac_mc_device */
 static int edac_create_dimm_object(struct mem_ctl_info *mci,
-					struct dimm_info *dimm, int index,
-					bool is_rank)
+					struct dimm_info *dimm, int index)
 {
 	struct kobject *kobj_mci = &mci->edac_mci_kobj;
 	struct kobject *kobj;
@@ -587,10 +586,10 @@ static int edac_create_dimm_object(struct mem_ctl_info *mci,
 	}
 
 	/* Instanstiate the dimm object */
-	if (!is_rank)
-		nodename = "dimm%d";
-	else
+	if (mci->mem_is_per_rank)
 		nodename = "rank%d";
+	else
+		nodename = "dimm%d";
 	err = kobject_init_and_add(&dimm->kobj, &ktype_dimm, kobj_mci,
 				nodename, index);
 	if (err)
@@ -1344,7 +1343,6 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	int err;
 	struct csrow_info *csrow;
 	struct kobject *kobj_mci = &mci->edac_mci_kobj;
-	bool is_rank = false;
 
 	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
 
@@ -1393,13 +1391,6 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 		}
 	}
 
-	for (i = 0; i < mci->n_layers; i++) {
-		if (mci->layers[i].type == EDAC_MC_LAYER_CHIP_SELECT) {
-			is_rank = true;
-			break;
-		}
-	}
-
 	/*
 	 * Make directories for each DIMM object under the mc<id> kobject
 	 */
@@ -1420,7 +1411,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 			printk(KERN_CONT "\n");
 		}
 #endif
-		err = edac_create_dimm_object(mci, dimm, j, is_rank);
+		err = edac_create_dimm_object(mci, dimm, j);
 		if (err) {
 			debugf1("%s() failure: create dimm %d obj\n",
 				__func__, j);
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 895c4a8..e3f5324 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -605,9 +605,19 @@ struct mem_ctl_info {
 	struct csrow_info *csrows;
 	unsigned num_csrows, num_cschannel;
 
-	/* Memory Controller hierarchy */
+	/*
+	 * Memory Controller hierarchy
+	 *
+	 * There are basically two types of memory controller: the ones that
+	 * sees memory sticks ("dimms"), and the ones that sees memory ranks.
+	 * All old memory controllers enumerate memories per rank, but most
+	 * of the recent drivers enumerate memories per DIMM, instead.
+	 * When the memory controller is per rank, mem_is_per_rank is true.
+	 */
 	unsigned n_layers;
 	struct edac_mc_layer *layers;
+	bool mem_is_per_rank;
+
 	/*
 	 * DIMM info. Will eventually remove the entire csrows_info some day
 	 */
-- 
1.7.8

