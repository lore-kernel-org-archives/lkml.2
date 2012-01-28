Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2A1Pd5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:33:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab2A1Pc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:32:58 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv2 07/16] edac: Add per dimm's sysfs nodes
Date: Sat, 28 Jan 2012 13:32:42 -0200
Message-Id: <1327764771-28649-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
References: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of just exporting a per-csrow dimm directories, add
a pure per-dimm attributes. This will help to better map
the DIMM properties, when csrow info is not available.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |  172 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/edac.h         |    2 +
 2 files changed, 173 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index a439bed..54b24cb 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -415,6 +415,156 @@ err_out:
 	return err;
 }
 
+/* dimm specific attribute structure */
+struct dimmdev_attribute {
+	struct attribute attr;
+	 ssize_t(*show) (struct dimm_info *, char *);
+	 ssize_t(*store) (struct dimm_info *, const char *, size_t);
+};
+
+#define DIMMDEV_ATTR(_name,_mode,_show,_store)	\
+static struct dimmdev_attribute attr_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.show   = _show,					\
+	.store  = _store,					\
+};
+
+#define to_dimm(k) container_of(k, struct dimm_info, kobj)
+#define to_dimmdev_attr(a) container_of(a, struct dimmdev_attribute, attr)
+
+/* Set of show/store higher level functions for default dimm attributes */
+static ssize_t dimmdev_show(struct kobject *kobj,
+			struct attribute *attr, char *buffer)
+{
+	struct dimm_info *dimm = to_dimm(kobj);
+	struct dimmdev_attribute *dimmdev_attr = to_dimmdev_attr(attr);
+
+	if (dimmdev_attr->show)
+		return dimmdev_attr->show(dimm, buffer);
+	return -EIO;
+}
+
+static ssize_t dimmdev_store(struct kobject *kobj, struct attribute *attr,
+			const char *buffer, size_t count)
+{
+	struct dimm_info *dimm = to_dimm(kobj);
+	struct dimmdev_attribute *dimmdev_attr = to_dimmdev_attr(attr);
+
+	if (dimmdev_attr->store)
+		return dimmdev_attr->store(dimm,
+					buffer,
+					count);
+	return -EIO;
+}
+
+static const struct sysfs_ops dimmfs_ops = {
+	.show = dimmdev_show,
+	.store = dimmdev_store
+};
+
+/* show/store functions for DIMM Label attributes */
+static ssize_t dimmdev_location_show(struct dimm_info *dimm, char *data)
+{
+	if (dimm->mci->dimm_loc_type == DIMM_LOC_CSROW)
+		return sprintf(data, "csrow %d, channel %d\n",
+			       dimm->location.csrow,
+			       dimm->location.csrow_channel);
+	else
+		return sprintf(data, "channel %d, dimm %d\n",
+			       dimm->location.mc_channel,
+			       dimm->location.mc_dimm_number);
+}
+
+static ssize_t dimmdev_label_show(struct dimm_info *dimm, char *data)
+{
+	/* if field has not been initialized, there is nothing to send */
+	if (!dimm->label[0])
+		return 0;
+
+	return snprintf(data, EDAC_MC_LABEL_LEN, "%s\n", dimm->label);
+}
+
+static ssize_t dimmdev_label_store(struct dimm_info *dimm,
+					const char *data,
+					size_t count)
+{
+	ssize_t max_size = 0;
+
+	max_size = min((ssize_t) count, (ssize_t) EDAC_MC_LABEL_LEN - 1);
+	strncpy(dimm->label, data, max_size);
+	dimm->label[max_size] = '\0';
+
+	return max_size;
+}
+
+/* default cwrow<id>/attribute files */
+DIMMDEV_ATTR(label, S_IRUGO | S_IWUSR, dimmdev_label_show, dimmdev_label_store);
+DIMMDEV_ATTR(location, S_IRUGO, dimmdev_location_show, NULL);
+
+/* default attributes of the DIMM<id> object */
+static struct dimmdev_attribute *default_dimm_attr[] = {
+	&attr_label,
+	&attr_location,
+	NULL,
+};
+
+/* No memory to release for this kobj */
+static void edac_dimm_instance_release(struct kobject *kobj)
+{
+	struct mem_ctl_info *mci;
+	struct dimm_info *cs;
+
+	debugf1("%s()\n", __func__);
+
+	cs = container_of(kobj, struct dimm_info, kobj);
+	mci = cs->mci;
+
+	kobject_put(&mci->edac_mci_kobj);
+}
+
+/* the kobj_type instance for a DIMM */
+static struct kobj_type ktype_dimm = {
+	.release = edac_dimm_instance_release,
+	.sysfs_ops = &dimmfs_ops,
+	.default_attrs = (struct attribute **)default_dimm_attr,
+};
+/* Create a CSROW object under specifed edac_mc_device */
+static int edac_create_dimm_object(struct mem_ctl_info *mci,
+					struct dimm_info *dimm, int index)
+{
+	struct kobject *kobj_mci = &mci->edac_mci_kobj;
+	struct kobject *kobj;
+	int err;
+
+	/* generate ..../edac/mc/mc<id>/dimm<index>   */
+	memset(&dimm->kobj, 0, sizeof(dimm->kobj));
+	dimm->mci = mci;	/* include container up link */
+
+	/* bump the mci instance's kobject's ref count */
+	kobj = kobject_get(&mci->edac_mci_kobj);
+	if (!kobj) {
+		err = -ENODEV;
+		goto err_out;
+	}
+
+	/* Instanstiate the dimm object */
+	err = kobject_init_and_add(&dimm->kobj, &ktype_dimm, kobj_mci,
+				   "dimm%d", index);
+	if (err)
+		goto err_release_top_kobj;
+
+	kobject_uevent(&dimm->kobj, KOBJ_ADD);
+	return 0;
+
+	/* error unwind stack */
+err_release_top_kobj:
+	kobject_put(&mci->edac_mci_kobj);
+
+err_out:
+	return err;
+}
+
+
 /* default sysfs methods and data structures for the main MCI kobject */
 
 static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
@@ -905,7 +1055,7 @@ static void edac_remove_mci_instance_attributes(struct mem_ctl_info *mci,
  */
 int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 {
-	int i;
+	int i, j;
 	int err;
 	struct csrow_info *csrow;
 	struct kobject *kobj_mci = &mci->edac_mci_kobj;
@@ -952,8 +1102,24 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 		}
 	}
 
+	/*
+	 * Make directories for each DIMM object under the mc<id> kobject
+	 */
+	for (j = 0; j < mci->nr_dimms; j++) {
+		err = edac_create_dimm_object(mci, &mci->dimms[j] , j);
+		if (err) {
+			debugf1("%s() failure: create dimm %d obj\n",
+				__func__, j);
+			goto fail2;
+		}
+	}
+
 	return 0;
 
+fail2:
+	for (j--; j >= 0; j--)
+		kobject_put(&mci->dimms[i].kobj);
+
 	/* CSROW error: backout what has already been registered,  */
 fail1:
 	for (i--; i >= 0; i--) {
@@ -984,6 +1150,10 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	/* remove all csrow kobjects */
 	debugf4("%s()  unregister this mci kobj\n", __func__);
+	for (i = 0; i < mci->nr_dimms; i++) {
+		debugf0("%s()  unreg dimm-%d\n", __func__, i);
+		kobject_put(&mci->dimms[i].kobj);
+	}
 	for (i = 0; i < mci->nr_csrows; i++) {
 		if (mci->csrows[i].nr_pages > 0) {
 			debugf0("%s()  unreg csrow-%d\n", __func__, i);
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 9f4deed..027e478 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -268,6 +268,8 @@ struct dimm_info {
 			unsigned csrow_channel;
 		};
 	} location;
+	struct kobject kobj;		/* sysfs kobject for this csrow */
+	struct mem_ctl_info *mci;	/* the parent */
 };
 
 struct csrow_channel_info {
-- 
1.7.8

