Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2DPUjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:39:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab2DPUjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:39:05 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Josh Boyer <jwboyer@redhat.com>,
        Hui Wang <jason77.wang@gmail.com>
Subject: [EDAC ABI v13 14/25] edac: add a new per-dimm API and make the old per-virtual-rank API obsolete
Date: Mon, 16 Apr 2012 17:38:38 -0300
Message-Id: <1334608729-30803-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old EDAC API is broken. It only works fine for systems manufatured
before 2005 and for AMD 64. The reason is that it forces all memory
controller drivers to discover rank info.

Also, it doesn't allow grouping the several ranks into a DIMM.

So, what almost all modern drivers do is to create a fake virtual-rank
information, and use it to cheat the EDAC core to accept the driver.

While this works if the user has enough time to discover what DIMM slot
corresponds to each "virtual-rank" information, it prevents EDAC usage
for users with less available time. It also makes life hard for vendors
that may want to provide a table with their motherboards to the userspace
tool (edac-utils) as each driver has its own logic for the virtual
mapping.

So, the old API should be removed, in favor of a more flexible API that
allows newer drivers to not lie to the EDAC core.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Hui Wang <jason77.wang@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/Kconfig         |    8 ++
 drivers/edac/edac_mc.c       |   43 ++++++++----
 drivers/edac/edac_mc_sysfs.c |  165 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 202 insertions(+), 14 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index fdffa1b..3b3f84f 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -31,6 +31,14 @@ if EDAC
 
 comment "Reporting subsystems"
 
+config EDAC_LEGACY_SYSFS
+	bool "EDAC legacy sysfs"
+	default y
+	help
+	  Enable the compatibility sysfs nodes.
+	  Use 'Y' if your edac utilities aren't ported to work with the newer
+	  structures.
+
 config EDAC_DEBUG
 	bool "Debugging"
 	help
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 35c8f3b..bb96fac 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -89,7 +89,7 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 	debugf4("\tmci->edac_check = %p\n", mci->edac_check);
 	debugf3("\tmci->nr_csrows = %d, csrows = %p\n",
 		mci->nr_csrows, mci->csrows);
-	debugf3("\tmci->nr_dimms = %d, dimns = %p\n",
+	debugf3("\tmci->nr_dimms = %d, dimms = %p\n",
 		mci->tot_dimms, mci->dimms);
 	debugf3("\tdev = %p\n", mci->pdev);
 	debugf3("\tmod_name:ctl_name = %s:%s\n", mci->mod_name, mci->ctl_name);
@@ -170,10 +170,6 @@ void *edac_align_ptr(void **p, unsigned size, int quant)
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
@@ -188,6 +184,12 @@ void *edac_align_ptr(void **p, unsigned size, int quant)
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
@@ -207,9 +209,10 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
 	void *pvt, *p;
 	unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
-	unsigned tot_csrows, tot_cschannels;
+	unsigned tot_csrows, tot_cschannels, tot_errcount = 0;
 	int i, j, n, len;
 	int row, chn;
+	bool per_rank = false;
 
 	BUG_ON(n_layers > EDAC_MAX_LAYERS);
 	/*
@@ -225,6 +228,9 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 			tot_csrows *= layers[i].size;
 		else
 			tot_cschannels *= layers[i].size;
+
+		if (layers[i].type == EDAC_MC_LAYER_CHIP_SELECT)
+			per_rank = true;
 	}
 
 	/* Figure out the offsets of the various items from the start of an mc
@@ -241,14 +247,21 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
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
@@ -277,6 +290,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	memcpy(mci->layers, layers, sizeof(*lay) * n_layers);
 	mci->nr_csrows = tot_csrows;
 	mci->num_cschannel = tot_cschannels;
+	mci->mem_is_per_rank = per_rank;
 
 	/*
 	 * Fills the csrow struct
@@ -302,15 +316,16 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
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
@@ -982,8 +997,10 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
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
index 3709d5e..a4ee4aa 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -130,6 +130,7 @@ static const char *edac_caps[] = {
 	[EDAC_S16ECD16ED] = "S16ECD16ED"
 };
 
+#ifdef CONFIG_EDAC_LEGACY_SYSFS
 /*
  * EDAC sysfs CSROW data structures and methods
  */
@@ -443,6 +444,159 @@ static void edac_delete_csrow_objects(struct mem_ctl_info *mci)
 		device_del(&mci->csrows[i].dev);
 	}
 }
+#endif
+
+/*
+ * Per-dimm (or per-rank) devices
+ */
+
+#define to_dimm(k) container_of(k, struct dimm_info, dev)
+
+/* show/store functions for DIMM Label attributes */
+static ssize_t dimmdev_location_show(struct device *dev,
+				     struct device_attribute *mattr, char *data)
+{
+	struct dimm_info *dimm = to_dimm(dev);
+	struct mem_ctl_info *mci = dimm->mci;
+	int i;
+	char *p = data;
+
+	for (i = 0; i < mci->n_layers; i++) {
+		p += sprintf(p, "%s %d ",
+			     edac_layer_name[mci->layers[i].type],
+			     dimm->location[i]);
+	}
+
+	return p - data;
+}
+
+static ssize_t dimmdev_label_show(struct device *dev,
+				  struct device_attribute *mattr, char *data)
+{
+	struct dimm_info *dimm = to_dimm(dev);
+
+	/* if field has not been initialized, there is nothing to send */
+	if (!dimm->label[0])
+		return 0;
+
+	return snprintf(data, EDAC_MC_LABEL_LEN, "%s\n", dimm->label);
+}
+
+static ssize_t dimmdev_label_store(struct device *dev,
+				   struct device_attribute *mattr,
+				   const char *data,
+				   size_t count)
+{
+	struct dimm_info *dimm = to_dimm(dev);
+
+	ssize_t max_size = 0;
+
+	max_size = min((ssize_t) count, (ssize_t) EDAC_MC_LABEL_LEN - 1);
+	strncpy(dimm->label, data, max_size);
+	dimm->label[max_size] = '\0';
+
+	return max_size;
+}
+
+static ssize_t dimmdev_size_show(struct device *dev,
+				 struct device_attribute *mattr, char *data)
+{
+	struct dimm_info *dimm = to_dimm(dev);
+
+	return sprintf(data, "%u\n", PAGES_TO_MiB(dimm->nr_pages));
+}
+
+static ssize_t dimmdev_mem_type_show(struct device *dev,
+				     struct device_attribute *mattr, char *data)
+{
+	struct dimm_info *dimm = to_dimm(dev);
+
+	return sprintf(data, "%s\n", mem_types[dimm->mtype]);
+}
+
+static ssize_t dimmdev_dev_type_show(struct device *dev,
+				     struct device_attribute *mattr, char *data)
+{
+	struct dimm_info *dimm = to_dimm(dev);
+
+	return sprintf(data, "%s\n", dev_types[dimm->dtype]);
+}
+
+static ssize_t dimmdev_edac_mode_show(struct device *dev,
+				      struct device_attribute *mattr,
+				      char *data)
+{
+	struct dimm_info *dimm = to_dimm(dev);
+
+	return sprintf(data, "%s\n", edac_caps[dimm->edac_mode]);
+}
+
+/* dimm/rank attribute files */
+static DEVICE_ATTR(dimm_label, S_IRUGO | S_IWUSR,
+		   dimmdev_label_show, dimmdev_label_store);
+static DEVICE_ATTR(dimm_location, S_IRUGO, dimmdev_location_show, NULL);
+static DEVICE_ATTR(size, S_IRUGO, dimmdev_size_show, NULL);
+static DEVICE_ATTR(dimm_mem_type, S_IRUGO, dimmdev_mem_type_show, NULL);
+static DEVICE_ATTR(dimm_dev_type, S_IRUGO, dimmdev_dev_type_show, NULL);
+static DEVICE_ATTR(dimm_edac_mode, S_IRUGO, dimmdev_edac_mode_show, NULL);
+
+/* attributes of the dimm<id>/rank<id> object */
+static struct attribute *dimm_attrs[] = {
+	&dev_attr_dimm_label.attr,
+	&dev_attr_dimm_location.attr,
+	&dev_attr_size.attr,
+	&dev_attr_dimm_mem_type.attr,
+	&dev_attr_dimm_dev_type.attr,
+	&dev_attr_dimm_edac_mode.attr,
+	NULL,
+};
+
+static struct attribute_group dimm_attr_grp = {
+	.attrs	= dimm_attrs,
+};
+
+static const struct attribute_group *dimm_attr_groups[] = {
+	&dimm_attr_grp,
+	NULL
+};
+
+static void dimm_attr_release(struct device *device)
+{
+	debugf1("Releasing dimm device %s\n", dev_name(device));
+}
+
+static struct device_type dimm_attr_type = {
+	.groups		= dimm_attr_groups,
+	.release	= dimm_attr_release,
+};
+
+/* Create a DIMM object under specifed memory controller device */
+static int edac_create_dimm_object(struct mem_ctl_info *mci,
+				   struct dimm_info *dimm,
+				   int index)
+{
+	int err;
+	dimm->mci = mci;
+
+	dimm->dev.type = &dimm_attr_type;
+	dimm->dev.bus = mci_pdev.bus;
+	device_initialize(&dimm->dev);
+
+	dimm->dev.parent = &mci->dev;
+	if (mci->mem_is_per_rank)
+		dev_set_name(&dimm->dev, "rank%d", index);
+	else
+		dev_set_name(&dimm->dev, "dimm%d", index);
+	dev_set_drvdata(&dimm->dev, dimm);
+	pm_runtime_forbid(&mci->dev);
+
+	err =  device_add(&dimm->dev);
+
+	debugf0("%s(): creating rank/dimm device %s\n", __func__,
+		dev_name(&dimm->dev));
+
+	return err;
+}
 
 /*
  * Memory controller device
@@ -660,7 +814,6 @@ static struct device_type mci_attr_type = {
 	.release	= mci_attr_release,
 };
 
-
 /*
  * Create a new Memory Controller kobject instance,
  *	mc<id> under the 'mc' directory
@@ -712,11 +865,19 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 			printk(KERN_CONT "\n");
 		}
 #endif
+		err = edac_create_dimm_object(mci, dimm, i);
+		if (err) {
+			debugf1("%s() failure: create dimm %d obj\n",
+				__func__, i);
+			goto fail;
+		}
 	}
 
+#ifdef CONFIG_EDAC_LEGACY_SYSFS
 	err = edac_create_csrow_objects(mci);
 	if (err < 0)
 		goto fail;
+#endif
 
 	return 0;
 
@@ -742,7 +903,9 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	debugf0("%s()\n", __func__);
 
+#ifdef CONFIG_EDAC_LEGACY_SYSFS
 	edac_delete_csrow_objects(mci);
+#endif
 
 	for (i = 0; i < mci->tot_dimms; i++) {
 		struct dimm_info *dimm = &mci->dimms[i];
-- 
1.7.8

