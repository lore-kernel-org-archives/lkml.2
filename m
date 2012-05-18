Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929Ab2ERQlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:41:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758638Ab2ERQdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:09 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Josh Boyer <jwboyer@redhat.com>,
        Hui Wang <jason77.wang@gmail.com>,
        Greg K H <gregkh@linuxfoundation.org>
Subject: [PATCH EDAC v26 47/66] edac: add a new per-dimm API and make the old per-virtual-rank API obsolete
Date: Fri, 18 May 2012 13:32:34 -0300
Message-Id: <1337358773-6919-48-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
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
Cc: Greg K H <gregkh@linuxfoundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/Kconfig         |    8 ++
 drivers/edac/edac_mc_sysfs.c |  165 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 172 insertions(+), 1 deletions(-)

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
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 7002c9c..86da176 100644
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
+	dimm->dev.bus = &mci->bus;
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
@@ -725,11 +878,19 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
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
 
@@ -757,7 +918,9 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	debugf0("%s()\n", __func__);
 
+#ifdef CONFIG_EDAC_LEGACY_SYSFS
 	edac_delete_csrow_objects(mci);
+#endif
 
 	for (i = 0; i < mci->tot_dimms; i++) {
 		struct dimm_info *dimm = &mci->dimms[i];
-- 
1.7.8

