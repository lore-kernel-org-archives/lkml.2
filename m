Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab2CGMI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:08:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab2CGMI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:08:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] edac: Add a sysfs node to test the EDAC error report facility
Date: Wed,  7 Mar 2012 09:08:21 -0300
Message-Id: <1331122101-28382-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even on memory controllers that have memory injection, such functionality
can be disabled by BIOS during bootstrap, and it may not be possible to
enable it via BIOS setup.

So, as not all hardware supports error injection, add a mechanism to
allow testing the edac driver and the core.

This feature is only enabled when EDAC_DEBUG is equal to Y, so there's no
extra code for the production Kernels.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

NOTE: This patch should be applied after the series that add proper support for
FB-DIMM, due to context changes.

 drivers/edac/edac_mc_sysfs.c |   62 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/edac.h         |    4 +++
 2 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 870ccb0..f538f9e 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -744,6 +744,42 @@ static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data,
 	return sprintf(data, "%u\n", PAGES_TO_MiB(total_pages));
 }
 
+#ifdef CONFIG_EDAC_DEBUG
+static ssize_t edac_fake_inject_show(struct mem_ctl_info *mci,
+				     char *data, void *priv)
+{
+	return sprintf(data,
+		       "EDAC fake test engine. Writing to this node a value in the form of :\n"
+		       "\t0:1:0\n"
+		       "will call the EDAC core routine to produce a memory error for the given memory location (0, 1, 0).\n"
+		       "The driver's error parsing logic won't be tested. This tool is useful only\n"
+		       "if you're testing the EDAC core tracing facility, or if you're needing to test\n"
+		       "some userspace application.\n");
+}
+
+static ssize_t edac_fake_inject_store(struct mem_ctl_info *mci,
+				      const char *data, size_t count,
+				      void *priv)
+{
+	static enum hw_event_mc_err_type type = HW_EVENT_ERR_CORRECTED;
+	int err, layer0 = -1, layer1 = -1, layer2 = -1;
+	err = sscanf(data, "%i:%i:%i", &layer0, &layer1, &layer2);
+	if (err < 0)
+		return err;
+
+	printk(KERN_DEBUG
+	       "Generating a fake error to %d.%d.%d to test core handling. NOTE: this won't test the driver-specific decoding logic.\n",
+	       layer0, layer1, layer2);
+	edac_mc_handle_error(type, mci, 0, 0, 0,
+			     layer0, layer1, layer2,
+			     "FAKE ERROR", "for EDAC testing only", NULL);
+	if (++type == HW_EVENT_ERR_FATAL)
+		type = HW_EVENT_ERR_CORRECTED;
+
+	return count;
+}
+#endif
+
 #define to_mci(k) container_of(k, struct mem_ctl_info, edac_mci_kobj)
 #define to_mcidev_attr(a) container_of(a,struct mcidev_sysfs_attribute,attr)
 
@@ -877,7 +913,7 @@ static int edac_create_errcount_layer(struct mem_ctl_info *mci,
 		debugf4("%s() creating %s\n", __func__, (*erc)->attr.name);
 		if (!(*erc)->attr.name)
 			return -ENOMEM;
-		(*erc)->attr.mode = S_IRUGO;
+		(*erc)->attr.mode = S_IRUGO | S_IWUSR;
 		(*erc)->show = errcount_ce_show;
 		(*erc)->priv = *ercd;
 		(*ercd)->n_layers = layer + 1;
@@ -1326,7 +1362,24 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 			goto fail2;
 		}
 	}
-	edac_create_errcount_objects(mci);
+	err = edac_create_errcount_objects(mci);
+	if (err) {
+		debugf1("%s() failure: create error count objects\n",
+			__func__);
+		goto fail2;
+	}
+#ifdef CONFIG_EDAC_DEBUG
+	mci->errinject_attr.attr.name = "fake_inject";
+	mci->errinject_attr.attr.mode = S_IRUGO | S_IWUSR;
+	mci->errinject_attr.show = edac_fake_inject_show;
+	mci->errinject_attr.store = edac_fake_inject_store;
+	err = sysfs_create_file(&mci->edac_mci_kobj, &mci->errinject_attr.attr);
+	if (err < 0) {
+		printk(KERN_ERR
+		       "sysfs_create_file for fake inject failed: %d\n", err);
+		mci->errinject_attr.attr.name = NULL;
+	}
+#endif
 
 	return 0;
 
@@ -1371,6 +1424,11 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	debugf0("%s()\n", __func__);
 
+#ifdef CONFIG_EDAC_DEBUG
+	if (mci->errinject_attr.attr.name)
+		sysfs_remove_file(&mci->edac_mci_kobj,
+				  &mci->errinject_attr.attr);
+#endif
 	edac_remove_errcount(mci);
 
 	/* remove all dimms kobjects */
diff --git a/include/linux/edac.h b/include/linux/edac.h
index beb6170..895c4a8 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -635,6 +635,10 @@ struct mem_ctl_info {
 	struct mcidev_sysfs_attribute *errcount_attr;
 	struct errcount_attribute_data *errcount_attr_data;
 
+#ifdef CONFIG_EDAC_DEBUG
+	struct mcidev_sysfs_attribute errinject_attr;
+#endif
+
 	struct completion complete;
 
 	/* edac sysfs device control */
-- 
1.7.8

