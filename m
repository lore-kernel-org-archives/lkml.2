Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab2CGMAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:00:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110Ab2CGMAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:00:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] edac: Export MC hierarchy counters for CE and UE
Date: Wed,  7 Mar 2012 09:00:16 -0300
Message-Id: <1331121616-27719-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331121616-27719-1-git-send-email-mchehab@redhat.com>
References: <1331121616-27719-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac_dbg.c |    6 +-
 drivers/edac/amd64_edac_inj.c |   24 ++++--
 drivers/edac/edac_mc.c        |   14 +++-
 drivers/edac/edac_mc_sysfs.c  |  198 ++++++++++++++++++++++++++++++++++++-----
 drivers/edac/i7core_edac.c    |   26 +++---
 include/linux/edac.h          |   17 +++-
 6 files changed, 239 insertions(+), 46 deletions(-)

diff --git a/drivers/edac/amd64_edac_dbg.c b/drivers/edac/amd64_edac_dbg.c
index e356228..16c517a 100644
--- a/drivers/edac/amd64_edac_dbg.c
+++ b/drivers/edac/amd64_edac_dbg.c
@@ -1,7 +1,8 @@
 #include "amd64_edac.h"
 
 #define EDAC_DCT_ATTR_SHOW(reg)						\
-static ssize_t amd64_##reg##_show(struct mem_ctl_info *mci, char *data)	\
+static ssize_t amd64_##reg##_show(struct mem_ctl_info *mci, char *data,	\
+				  void *priv)				\
 {									\
 	struct amd64_pvt *pvt = mci->pvt_info;				\
 		return sprintf(data, "0x%016llx\n", (u64)pvt->reg);	\
@@ -12,7 +13,8 @@ EDAC_DCT_ATTR_SHOW(dbam0);
 EDAC_DCT_ATTR_SHOW(top_mem);
 EDAC_DCT_ATTR_SHOW(top_mem2);
 
-static ssize_t amd64_hole_show(struct mem_ctl_info *mci, char *data)
+static ssize_t amd64_hole_show(struct mem_ctl_info *mci, char *data,
+			       void *priv)
 {
 	u64 hole_base = 0;
 	u64 hole_offset = 0;
diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
index 303f10e..a6fd957 100644
--- a/drivers/edac/amd64_edac_inj.c
+++ b/drivers/edac/amd64_edac_inj.c
@@ -1,6 +1,7 @@
 #include "amd64_edac.h"
 
-static ssize_t amd64_inject_section_show(struct mem_ctl_info *mci, char *buf)
+static ssize_t amd64_inject_section_show(struct mem_ctl_info *mci, char *buf,
+					 void *priv)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	return sprintf(buf, "0x%x\n", pvt->injection.section);
@@ -13,7 +14,8 @@ static ssize_t amd64_inject_section_show(struct mem_ctl_info *mci, char *buf)
  * range: 0..3
  */
 static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
-					  const char *data, size_t count)
+					  const char *data, size_t count,
+					  void *priv)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	unsigned long value;
@@ -33,7 +35,8 @@ static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
 	return ret;
 }
 
-static ssize_t amd64_inject_word_show(struct mem_ctl_info *mci, char *buf)
+static ssize_t amd64_inject_word_show(struct mem_ctl_info *mci, char *buf,
+				      void *priv)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	return sprintf(buf, "0x%x\n", pvt->injection.word);
@@ -46,7 +49,8 @@ static ssize_t amd64_inject_word_show(struct mem_ctl_info *mci, char *buf)
  * range: 0..8
  */
 static ssize_t amd64_inject_word_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
+					const char *data, size_t count,
+					void *priv)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	unsigned long value;
@@ -66,7 +70,8 @@ static ssize_t amd64_inject_word_store(struct mem_ctl_info *mci,
 	return ret;
 }
 
-static ssize_t amd64_inject_ecc_vector_show(struct mem_ctl_info *mci, char *buf)
+static ssize_t amd64_inject_ecc_vector_show(struct mem_ctl_info *mci,
+					    char *buf, void *priv)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	return sprintf(buf, "0x%x\n", pvt->injection.bit_map);
@@ -78,7 +83,8 @@ static ssize_t amd64_inject_ecc_vector_show(struct mem_ctl_info *mci, char *buf)
  * DRAM ECC read, it holds the contents of the of the DRAM ECC bits.
  */
 static ssize_t amd64_inject_ecc_vector_store(struct mem_ctl_info *mci,
-					     const char *data, size_t count)
+					     const char *data, size_t count,
+					     void *priv)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	unsigned long value;
@@ -104,7 +110,8 @@ static ssize_t amd64_inject_ecc_vector_store(struct mem_ctl_info *mci,
  * fields needed by the injection registers and read the NB Array Data Port.
  */
 static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
+				       const char *data, size_t count,
+				       void *priv)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	unsigned long value;
@@ -137,7 +144,8 @@ static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
  * fields needed by the injection registers.
  */
 static ssize_t amd64_inject_write_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
+					const char *data, size_t count,
+					void *priv)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	unsigned long value;
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 843e4c1..4ff8d28 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -201,11 +201,13 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	struct edac_mc_layer *lay;
 	struct csrow_info *csi, *csr;
 	struct rank_info *chi, *chp, *chan;
+	struct mcidev_sysfs_attribute *erc;
+	struct errcount_attribute_data *ercd;
 	struct dimm_info *dimm;
 	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
 	void *pvt;
 	unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
-	unsigned tot_csrows, tot_cschannels;
+	unsigned tot_csrows, tot_cschannels, tot_errcount = 0;
 	int i, j;
 	int err;
 	int row, chn;
@@ -240,9 +242,15 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	count = 1;
 	for (i = 0; i < n_layers; i++) {
 		count *= layers[i].size;
+		debugf4("%s: errcount layer %d size %d\n", __func__, i, count);
 		ce_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
 		ue_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
+		tot_errcount += 2 * count;
 	}
+
+	debugf4("%s: allocating %d error counters\n", __func__, tot_errcount);
+	erc = edac_align_ptr(&ptr, sizeof(*erc), tot_errcount);
+	ercd = edac_align_ptr(&ptr, sizeof(*ercd), tot_errcount);
 	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
 	size = ((unsigned long)pvt) + sz_pvt;
 
@@ -263,6 +271,8 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 		mci->ce_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ce_per_layer[i]));
 		mci->ue_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ue_per_layer[i]));
 	}
+	erc = (struct mcidev_sysfs_attribute *)((char *)mci + ((unsigned long)erc));
+	ercd = (struct errcount_attribute_data *)((char *)mci + ((unsigned long)ercd));
 	pvt = sz_pvt ? (((char *)mci) + ((unsigned long)pvt)) : NULL;
 
 	/* setup index and various internal pointers */
@@ -270,6 +280,8 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	mci->csrows = csi;
 	mci->dimms  = dimm;
 	mci->tot_dimms = tot_dimms;
+	mci->errcount_attr = erc;
+	mci->errcount_attr_data = ercd;
 	mci->pvt_info = pvt;
 	mci->n_layers = n_layers;
 	mci->layers = lay;
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index a99131a..870ccb0 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -475,7 +475,7 @@ static ssize_t dimmdev_location_show(struct dimm_info *dimm, char *data)
 	int i;
 	char *p = data;
 
-	for (i = 0; i <= mci->n_layers; i++) {
+	for (i = 0; i < mci->n_layers; i++) {
 		p += sprintf(p, "%s %d ",
 			     edac_layer_name[mci->layers[i].type],
 			     dimm->location[i]);
@@ -605,7 +605,8 @@ err_out:
 /* default sysfs methods and data structures for the main MCI kobject */
 
 static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
+					const char *data, size_t count,
+					void *priv)
 {
 	int cnt, row, chan, i;
 	mci->ue_mc = 0;
@@ -627,8 +628,8 @@ static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 	cnt = 1;
 	for (i = 0; i < mci->n_layers; i++) {
 		cnt *= mci->layers[i].size;
-		memset(mci->ce_per_layer[i], 0, cnt);
-		memset(mci->ue_per_layer[i], 0, cnt);
+		memset(mci->ce_per_layer[i], 0, cnt * sizeof(u32));
+		memset(mci->ue_per_layer[i], 0, cnt * sizeof(u32));
 	}
 
 	mci->start_time = jiffies;
@@ -645,7 +646,8 @@ static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
  * the scrub rate.
  */
 static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
-					  const char *data, size_t count)
+					  const char *data, size_t count,
+					  void *priv)
 {
 	unsigned long bandwidth = 0;
 	int new_bw = 0;
@@ -669,7 +671,8 @@ static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
 /*
  * ->get_sdram_scrub_rate() return value semantics same as above.
  */
-static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data,
+					 void *priv)
 {
 	int bandwidth = 0;
 
@@ -686,37 +689,44 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
 }
 
 /* default attribute files for the MCI object */
-static ssize_t mci_ue_count_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_ue_count_show(struct mem_ctl_info *mci, char *data,
+				 void *priv)
 {
 	return sprintf(data, "%d\n", mci->ue_mc);
 }
 
-static ssize_t mci_ce_count_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_ce_count_show(struct mem_ctl_info *mci, char *data,
+				 void *priv)
 {
 	return sprintf(data, "%d\n", mci->ce_mc);
 }
 
-static ssize_t mci_ce_noinfo_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_ce_noinfo_show(struct mem_ctl_info *mci, char *data,
+				  void *priv)
 {
 	return sprintf(data, "%d\n", mci->ce_noinfo_count);
 }
 
-static ssize_t mci_ue_noinfo_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_ue_noinfo_show(struct mem_ctl_info *mci, char *data,
+				  void *priv)
 {
 	return sprintf(data, "%d\n", mci->ue_noinfo_count);
 }
 
-static ssize_t mci_seconds_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_seconds_show(struct mem_ctl_info *mci, char *data,
+				void *priv)
 {
 	return sprintf(data, "%ld\n", (jiffies - mci->start_time) / HZ);
 }
 
-static ssize_t mci_ctl_name_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_ctl_name_show(struct mem_ctl_info *mci, char *data,
+				 void *priv)
 {
 	return sprintf(data, "%s\n", mci->ctl_name);
 }
 
-static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data,
+				void *priv)
 {
 	int total_pages, csrow_idx, j;
 
@@ -747,7 +757,8 @@ static ssize_t mcidev_show(struct kobject *kobj, struct attribute *attr,
 	debugf1("%s() mem_ctl_info %p\n", __func__, mem_ctl_info);
 
 	if (mcidev_attr->show)
-		return mcidev_attr->show(mem_ctl_info, buffer);
+		return mcidev_attr->show(mem_ctl_info, buffer,
+					 mcidev_attr->priv);
 
 	return -EIO;
 }
@@ -761,7 +772,8 @@ static ssize_t mcidev_store(struct kobject *kobj, struct attribute *attr,
 	debugf1("%s() mem_ctl_info %p\n", __func__, mem_ctl_info);
 
 	if (mcidev_attr->store)
-		return mcidev_attr->store(mem_ctl_info, buffer, count);
+		return mcidev_attr->store(mem_ctl_info, buffer, count,
+					  mcidev_attr->priv);
 
 	return -EIO;
 }
@@ -773,10 +785,11 @@ static const struct sysfs_ops mci_ops = {
 };
 
 #define MCIDEV_ATTR(_name,_mode,_show,_store)			\
-static struct mcidev_sysfs_attribute mci_attr_##_name = {			\
+static struct mcidev_sysfs_attribute mci_attr_##_name = {	\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show   = _show,					\
 	.store  = _store,					\
+	.priv   = NULL,						\
 };
 
 /* default Control file */
@@ -808,6 +821,138 @@ static struct mcidev_sysfs_attribute *mci_attr[] = {
 	NULL
 };
 
+/*
+ * Per layer error count nodes
+ */
+static ssize_t errcount_ce_show(struct mem_ctl_info *mci, char *data,
+				void *priv)
+{
+	struct errcount_attribute_data *ead = priv;
+	int i, index = 0;
+
+	for (i = 0; i < ead->n_layers; i++) {
+		if (i < ead->n_layers - 1)
+			index += mci->layers[i + 1].size * ead->pos[i];
+		else
+			index += ead->pos[i];
+	}
+	return sprintf(data, "%u\n",
+		       mci->ce_per_layer[ead->n_layers - 1][index]);
+}
+
+static ssize_t errcount_ue_show(struct mem_ctl_info *mci, char *data,
+				void *priv)
+{
+	struct errcount_attribute_data *ead = priv;
+	int i, index = 0;
+
+	for (i = 0; i < ead->n_layers; i++) {
+		if (i < ead->n_layers - 1)
+			index += mci->layers[i + 1].size * ead->pos[i];
+		else
+			index += ead->pos[i];
+	}
+	return sprintf(data, "%u\n",
+		       mci->ue_per_layer[ead->n_layers - 1][index]);
+}
+
+static int edac_create_errcount_layer(struct mem_ctl_info *mci,
+				      struct mcidev_sysfs_attribute **erc,
+				      struct errcount_attribute_data **ercd,
+				      const unsigned layer,
+				      const int count)
+{
+	int err, i, j, pos[EDAC_MAX_LAYERS];
+	char location[80], *p;
+
+	memset(&pos, 0, sizeof(pos));
+	for (i = 0; i < count; i++) {
+		p = location;
+		for (j = 0; j <= layer; j++)
+			p += sprintf(p, "_%s%d",
+				     edac_layer_name[mci->layers[j].type],
+				     pos[j]);
+
+		(*erc)->attr.name = kasprintf(GFP_KERNEL, "ce%s", location);
+		debugf4("%s() creating %s\n", __func__, (*erc)->attr.name);
+		if (!(*erc)->attr.name)
+			return -ENOMEM;
+		(*erc)->attr.mode = S_IRUGO;
+		(*erc)->show = errcount_ce_show;
+		(*erc)->priv = *ercd;
+		(*ercd)->n_layers = layer + 1;
+		memcpy((*ercd)->pos, pos, sizeof(pos));
+		err = sysfs_create_file(&mci->edac_mci_kobj, &(*erc)->attr);
+		if (err < 0) {
+			printk(KERN_ERR "sysfs_create_file failed: %d\n", err);
+			return err;
+		}
+		(*erc)++;
+		(*ercd)++;
+
+		(*erc)->attr.name = kasprintf(GFP_KERNEL, "ue%s", location);
+		debugf4("%s() creating %s\n", __func__, (*erc)->attr.name);
+		if (!(*erc)->attr.name)
+			return -ENOMEM;
+		(*erc)->attr.mode = S_IRUGO | S_IWUSR;
+		(*erc)->show = errcount_ue_show;
+		(*erc)->priv = *ercd;
+		(*ercd)->n_layers = layer + 1;
+		memcpy((*ercd)->pos, pos, sizeof(pos));
+		err = sysfs_create_file(&mci->edac_mci_kobj, &(*erc)->attr);
+		if (err < 0) {
+			printk(KERN_ERR "sysfs_create_file failed: %d\n", err);
+			return err;
+		}
+
+		for (j = layer; j >= 0; j--) {
+			pos[j]++;
+			if (pos[j] < mci->layers[j].size)
+				break;
+			pos[j] = 0;
+		}
+		(*erc)++;
+		(*ercd)++;
+	}
+
+	return 0;
+}
+
+static void edac_remove_errcount(struct mem_ctl_info *mci)
+{
+	struct mcidev_sysfs_attribute *erc = mci->errcount_attr;
+
+	do {
+		if (!(erc->attr.name))
+			return;
+		debugf2("%s() removing %s\n", __func__, erc->attr.name);
+		sysfs_remove_file(&mci->edac_mci_kobj, &erc->attr);
+
+		kfree(erc->attr.name);
+		erc++;
+	} while (1);
+	return;
+}
+
+static int edac_create_errcount_objects(struct mem_ctl_info *mci)
+{
+	struct mcidev_sysfs_attribute *erc = mci->errcount_attr;
+	struct errcount_attribute_data *ercd = mci->errcount_attr_data;
+	int err, i, count;
+
+	count = 1;
+	for (i = 0; i < mci->n_layers; i++) {
+		count *= mci->layers[i].size;
+		err = edac_create_errcount_layer(mci, &erc, &ercd, i, count);
+		if (err < 0)
+			goto err;
+	}
+	debugf2("%s: created %d objects\n", __func__, (unsigned)(erc - mci->errcount_attr));
+	return 0;
+err:
+	edac_remove_errcount(mci);
+	return err;
+}
 
 /*
  * Release of a MC controlling instance
@@ -928,7 +1073,8 @@ static ssize_t inst_grp_show(struct kobject *kobj, struct attribute *attr,
 	debugf1("%s() mem_ctl_info %p\n", __func__, mem_ctl_info);
 
 	if (mcidev_attr->show)
-		return mcidev_attr->show(mem_ctl_info, buffer);
+		return mcidev_attr->show(mem_ctl_info, buffer,
+					 mcidev_attr->priv);
 
 	return -EIO;
 }
@@ -942,7 +1088,8 @@ static ssize_t inst_grp_store(struct kobject *kobj, struct attribute *attr,
 	debugf1("%s() mem_ctl_info %p\n", __func__, mem_ctl_info);
 
 	if (mcidev_attr->store)
-		return mcidev_attr->store(mem_ctl_info, buffer, count);
+		return mcidev_attr->store(mem_ctl_info, buffer, count,
+					  mcidev_attr->priv);
 
 	return -EIO;
 }
@@ -1179,6 +1326,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 			goto fail2;
 		}
 	}
+	edac_create_errcount_objects(mci);
 
 	return 0;
 
@@ -1223,12 +1371,18 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	debugf0("%s()\n", __func__);
 
-	/* remove all csrow kobjects */
-	debugf4("%s()  unregister this mci kobj\n", __func__);
+	edac_remove_errcount(mci);
+
+	/* remove all dimms kobjects */
 	for (i = 0; i < mci->tot_dimms; i++) {
-		debugf0("%s()  unreg dimm-%d\n", __func__, i);
-		kobject_put(&mci->dimms[i].kobj);
+		if (mci->dimms[i].nr_pages) {
+			debugf0("%s()  unreg dimm%d\n", __func__, i);
+			kobject_put(&mci->dimms[i].kobj);
+		}
 	}
+
+	/* remove all csrow kobjects */
+	debugf4("%s()  unregister this mci csrows kobj\n", __func__);
 	for (i = 0; i < mci->num_csrows; i++) {
 		int n = 0;
 
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 139fd57..edb6bac 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -689,7 +689,8 @@ static int disable_inject(const struct mem_ctl_info *mci)
  *	bit 1 - refers to the upper 32-byte half cacheline
  */
 static ssize_t i7core_inject_section_store(struct mem_ctl_info *mci,
-					   const char *data, size_t count)
+					   const char *data, size_t count,
+					   void *priv)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	unsigned long value;
@@ -707,7 +708,7 @@ static ssize_t i7core_inject_section_store(struct mem_ctl_info *mci,
 }
 
 static ssize_t i7core_inject_section_show(struct mem_ctl_info *mci,
-					      char *data)
+					      char *data, void *priv)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	return sprintf(data, "0x%08x\n", pvt->inject.section);
@@ -722,7 +723,8 @@ static ssize_t i7core_inject_section_show(struct mem_ctl_info *mci,
  *	bit 2 - inject parity error
  */
 static ssize_t i7core_inject_type_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
+					const char *data, size_t count,
+					void *priv)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	unsigned long value;
@@ -740,7 +742,7 @@ static ssize_t i7core_inject_type_store(struct mem_ctl_info *mci,
 }
 
 static ssize_t i7core_inject_type_show(struct mem_ctl_info *mci,
-					      char *data)
+					      char *data, void *priv)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	return sprintf(data, "0x%08x\n", pvt->inject.type);
@@ -757,7 +759,8 @@ static ssize_t i7core_inject_type_show(struct mem_ctl_info *mci,
  *   uncorrectable error to be injected.
  */
 static ssize_t i7core_inject_eccmask_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
+					const char *data, size_t count,
+					void *priv)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	unsigned long value;
@@ -775,7 +778,7 @@ static ssize_t i7core_inject_eccmask_store(struct mem_ctl_info *mci,
 }
 
 static ssize_t i7core_inject_eccmask_show(struct mem_ctl_info *mci,
-					      char *data)
+					      char *data, void *priv)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	return sprintf(data, "0x%08x\n", pvt->inject.eccmask);
@@ -795,7 +798,7 @@ static ssize_t i7core_inject_eccmask_show(struct mem_ctl_info *mci,
 #define DECLARE_ADDR_MATCH(param, limit)			\
 static ssize_t i7core_inject_store_##param(			\
 		struct mem_ctl_info *mci,			\
-		const char *data, size_t count)			\
+		const char *data, size_t count, void *priv)	\
 {								\
 	struct i7core_pvt *pvt;					\
 	long value;						\
@@ -822,7 +825,7 @@ static ssize_t i7core_inject_store_##param(			\
 								\
 static ssize_t i7core_inject_show_##param(			\
 		struct mem_ctl_info *mci,			\
-		char *data)					\
+		char *data, void *priv)				\
 {								\
 	struct i7core_pvt *pvt;					\
 								\
@@ -897,7 +900,8 @@ static int write_and_test(struct pci_dev *dev, const int where, const u32 val)
  *    three channels. However, this is not clear at the datasheet.
  */
 static ssize_t i7core_inject_enable_store(struct mem_ctl_info *mci,
-				       const char *data, size_t count)
+					  const char *data, size_t count,
+					  void *priv)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	u32 injectmask;
@@ -1000,7 +1004,7 @@ static ssize_t i7core_inject_enable_store(struct mem_ctl_info *mci,
 }
 
 static ssize_t i7core_inject_enable_show(struct mem_ctl_info *mci,
-					char *data)
+					char *data, void *priv)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 	u32 injectmask;
@@ -1022,7 +1026,7 @@ static ssize_t i7core_inject_enable_show(struct mem_ctl_info *mci,
 #define DECLARE_COUNTER(param)					\
 static ssize_t i7core_show_counter_##param(			\
 		struct mem_ctl_info *mci,			\
-		char *data)					\
+		char *data, void *priv)			\
 {								\
 	struct i7core_pvt *pvt = mci->pvt_info;			\
 								\
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 71d37b0..beb6170 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -538,8 +538,19 @@ struct mcidev_sysfs_attribute {
 	const struct mcidev_sysfs_group *grp;	/* Points to a group of attributes */
 
 	/* Ops for show/store values at the attribute - not used on group */
-        ssize_t (*show)(struct mem_ctl_info *,char *);
-        ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
+	ssize_t (*show)(struct mem_ctl_info *, char *, void *);
+	ssize_t (*store)(struct mem_ctl_info *, const char *, size_t, void *);
+
+	void *priv;
+};
+
+/*
+ * struct errcount_attribute - used to store the several error counts
+ */
+struct errcount_attribute_data {
+	int n_layers;
+	int pos[EDAC_MAX_LAYERS];
+	int layer0, layer1, layer2;
 };
 
 struct edac_hierarchy {
@@ -621,6 +632,8 @@ struct mem_ctl_info {
 	unsigned ce_noinfo_count, ue_noinfo_count;
 	unsigned ce_mc, ue_mc;
 	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
+	struct mcidev_sysfs_attribute *errcount_attr;
+	struct errcount_attribute_data *errcount_attr_data;
 
 	struct completion complete;
 
-- 
1.7.8

