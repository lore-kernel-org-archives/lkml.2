Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab2DPUo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:44:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494Ab2DPUi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:38:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [EDAC ABI v13 12/25] i7core_edac: convert it to use struct device
Date: Mon, 16 Apr 2012 17:38:36 -0300
Message-Id: <1334608729-30803-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of relying on a complex logic inside the edac core to create
a "device tree-like" sysfs struct, just use device_add.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |  338 +++++++++++++++++++++++++++-----------------
 1 files changed, 209 insertions(+), 129 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 7f81a04..e6a8efd 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -246,6 +246,8 @@ struct i7core_dev {
 };
 
 struct i7core_pvt {
+	struct device addrmatch_dev, chancounts_dev;
+
 	struct pci_dev	*pci_noncore;
 	struct pci_dev	*pci_mcr[MAX_MCR_FUNC + 1];
 	struct pci_dev	*pci_ch[NUM_CHANS][MAX_CHAN_FUNC + 1];
@@ -659,6 +661,8 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			Error insertion routines
  ****************************************************************************/
 
+#define to_mci(k) container_of(k, struct mem_ctl_info, dev)
+
 /* The i7core has independent error injection features per channel.
    However, to have a simpler code, we don't allow enabling error injection
    on more than one channel.
@@ -688,9 +692,11 @@ static int disable_inject(const struct mem_ctl_info *mci)
  *	bit 0 - refers to the lower 32-byte half cacheline
  *	bit 1 - refers to the upper 32-byte half cacheline
  */
-static ssize_t i7core_inject_section_store(struct mem_ctl_info *mci,
+static ssize_t i7core_inject_section_store(struct device *dev,
+					   struct device_attribute *mattr,
 					   const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct i7core_pvt *pvt = mci->pvt_info;
 	unsigned long value;
 	int rc;
@@ -706,9 +712,11 @@ static ssize_t i7core_inject_section_store(struct mem_ctl_info *mci,
 	return count;
 }
 
-static ssize_t i7core_inject_section_show(struct mem_ctl_info *mci,
-					      char *data)
+static ssize_t i7core_inject_section_show(struct device *dev,
+					  struct device_attribute *mattr,
+					  char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct i7core_pvt *pvt = mci->pvt_info;
 	return sprintf(data, "0x%08x\n", pvt->inject.section);
 }
@@ -721,10 +729,12 @@ static ssize_t i7core_inject_section_show(struct mem_ctl_info *mci,
  *	bit 1 - inject ECC error
  *	bit 2 - inject parity error
  */
-static ssize_t i7core_inject_type_store(struct mem_ctl_info *mci,
+static ssize_t i7core_inject_type_store(struct device *dev,
+					struct device_attribute *mattr,
 					const char *data, size_t count)
 {
-	struct i7core_pvt *pvt = mci->pvt_info;
+	struct mem_ctl_info *mci = to_mci(dev);
+struct i7core_pvt *pvt = mci->pvt_info;
 	unsigned long value;
 	int rc;
 
@@ -739,10 +749,13 @@ static ssize_t i7core_inject_type_store(struct mem_ctl_info *mci,
 	return count;
 }
 
-static ssize_t i7core_inject_type_show(struct mem_ctl_info *mci,
-					      char *data)
+static ssize_t i7core_inject_type_show(struct device *dev,
+				       struct device_attribute *mattr,
+				       char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct i7core_pvt *pvt = mci->pvt_info;
+
 	return sprintf(data, "0x%08x\n", pvt->inject.type);
 }
 
@@ -756,9 +769,11 @@ static ssize_t i7core_inject_type_show(struct mem_ctl_info *mci,
  *   23:16 and 31:24). Flipping bits in two symbol pairs will cause an
  *   uncorrectable error to be injected.
  */
-static ssize_t i7core_inject_eccmask_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
+static ssize_t i7core_inject_eccmask_store(struct device *dev,
+					   struct device_attribute *mattr,
+					   const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct i7core_pvt *pvt = mci->pvt_info;
 	unsigned long value;
 	int rc;
@@ -774,10 +789,13 @@ static ssize_t i7core_inject_eccmask_store(struct mem_ctl_info *mci,
 	return count;
 }
 
-static ssize_t i7core_inject_eccmask_show(struct mem_ctl_info *mci,
-					      char *data)
+static ssize_t i7core_inject_eccmask_show(struct device *dev,
+					  struct device_attribute *mattr,
+					  char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct i7core_pvt *pvt = mci->pvt_info;
+
 	return sprintf(data, "0x%08x\n", pvt->inject.eccmask);
 }
 
@@ -794,9 +812,11 @@ static ssize_t i7core_inject_eccmask_show(struct mem_ctl_info *mci,
 
 #define DECLARE_ADDR_MATCH(param, limit)			\
 static ssize_t i7core_inject_store_##param(			\
-		struct mem_ctl_info *mci,			\
-		const char *data, size_t count)			\
+	struct device *dev,					\
+	struct device_attribute *mattr,				\
+	const char *data, size_t count)				\
 {								\
+	struct mem_ctl_info *mci = to_mci(dev);			\
 	struct i7core_pvt *pvt;					\
 	long value;						\
 	int rc;							\
@@ -821,9 +841,11 @@ static ssize_t i7core_inject_store_##param(			\
 }								\
 								\
 static ssize_t i7core_inject_show_##param(			\
-		struct mem_ctl_info *mci,			\
-		char *data)					\
+	struct device *dev,					\
+	struct device_attribute *mattr,				\
+	char *data)						\
 {								\
+	struct mem_ctl_info *mci = to_mci(dev);			\
 	struct i7core_pvt *pvt;					\
 								\
 	pvt = mci->pvt_info;					\
@@ -835,14 +857,9 @@ static ssize_t i7core_inject_show_##param(			\
 }
 
 #define ATTR_ADDR_MATCH(param)					\
-	{							\
-		.attr = {					\
-			.name = #param,				\
-			.mode = (S_IRUGO | S_IWUSR)		\
-		},						\
-		.show  = i7core_inject_show_##param,		\
-		.store = i7core_inject_store_##param,		\
-	}
+	static DEVICE_ATTR(param, S_IRUGO | S_IWUSR,		\
+		    i7core_inject_show_##param,			\
+		    i7core_inject_store_##param)
 
 DECLARE_ADDR_MATCH(channel, 3);
 DECLARE_ADDR_MATCH(dimm, 3);
@@ -851,6 +868,13 @@ DECLARE_ADDR_MATCH(bank, 32);
 DECLARE_ADDR_MATCH(page, 0x10000);
 DECLARE_ADDR_MATCH(col, 0x4000);
 
+ATTR_ADDR_MATCH(channel);
+ATTR_ADDR_MATCH(dimm);
+ATTR_ADDR_MATCH(rank);
+ATTR_ADDR_MATCH(bank);
+ATTR_ADDR_MATCH(page);
+ATTR_ADDR_MATCH(col);
+
 static int write_and_test(struct pci_dev *dev, const int where, const u32 val)
 {
 	u32 read;
@@ -896,9 +920,11 @@ static int write_and_test(struct pci_dev *dev, const int where, const u32 val)
  *    is reliable enough to check if the MC is using the
  *    three channels. However, this is not clear at the datasheet.
  */
-static ssize_t i7core_inject_enable_store(struct mem_ctl_info *mci,
-				       const char *data, size_t count)
+static ssize_t i7core_inject_enable_store(struct device *dev,
+					  struct device_attribute *mattr,
+					  const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct i7core_pvt *pvt = mci->pvt_info;
 	u32 injectmask;
 	u64 mask = 0;
@@ -999,9 +1025,11 @@ static ssize_t i7core_inject_enable_store(struct mem_ctl_info *mci,
 	return count;
 }
 
-static ssize_t i7core_inject_enable_show(struct mem_ctl_info *mci,
-					char *data)
+static ssize_t i7core_inject_enable_show(struct device *dev,
+					 struct device_attribute *mattr,
+					 char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct i7core_pvt *pvt = mci->pvt_info;
 	u32 injectmask;
 
@@ -1021,12 +1049,14 @@ static ssize_t i7core_inject_enable_show(struct mem_ctl_info *mci,
 
 #define DECLARE_COUNTER(param)					\
 static ssize_t i7core_show_counter_##param(			\
-		struct mem_ctl_info *mci,			\
-		char *data)					\
+	struct device *dev,					\
+	struct device_attribute *mattr,				\
+	char *data)						\
 {								\
+	struct mem_ctl_info *mci = to_mci(dev);			\
 	struct i7core_pvt *pvt = mci->pvt_info;			\
 								\
-	debugf1("%s() \n", __func__);				\
+	debugf1("%s()\n", __func__);				\
 	if (!pvt->ce_count_available || (pvt->is_registered))	\
 		return sprintf(data, "data unavailable\n");	\
 	return sprintf(data, "%lu\n",				\
@@ -1034,121 +1064,167 @@ static ssize_t i7core_show_counter_##param(			\
 }
 
 #define ATTR_COUNTER(param)					\
-	{							\
-		.attr = {					\
-			.name = __stringify(udimm##param),	\
-			.mode = (S_IRUGO | S_IWUSR)		\
-		},						\
-		.show  = i7core_show_counter_##param		\
-	}
+	static DEVICE_ATTR(udimm##param, S_IRUGO | S_IWUSR,	\
+		    i7core_show_counter_##param,		\
+		    NULL)
 
 DECLARE_COUNTER(0);
 DECLARE_COUNTER(1);
 DECLARE_COUNTER(2);
 
+ATTR_COUNTER(0);
+ATTR_COUNTER(1);
+ATTR_COUNTER(2);
+
 /*
- * Sysfs struct
+ * inject_addrmatch device sysfs struct
  */
 
-static const struct mcidev_sysfs_attribute i7core_addrmatch_attrs[] = {
-	ATTR_ADDR_MATCH(channel),
-	ATTR_ADDR_MATCH(dimm),
-	ATTR_ADDR_MATCH(rank),
-	ATTR_ADDR_MATCH(bank),
-	ATTR_ADDR_MATCH(page),
-	ATTR_ADDR_MATCH(col),
-	{ } /* End of list */
+static struct attribute *i7core_addrmatch_attrs[] = {
+	&dev_attr_channel.attr,
+	&dev_attr_dimm.attr,
+	&dev_attr_rank.attr,
+	&dev_attr_bank.attr,
+	&dev_attr_page.attr,
+	&dev_attr_col.attr,
+	NULL
 };
 
-static const struct mcidev_sysfs_group i7core_inject_addrmatch = {
-	.name  = "inject_addrmatch",
-	.mcidev_attr = i7core_addrmatch_attrs,
+static struct attribute_group addrmatch_grp = {
+	.attrs	= i7core_addrmatch_attrs,
 };
 
-static const struct mcidev_sysfs_attribute i7core_udimm_counters_attrs[] = {
-	ATTR_COUNTER(0),
-	ATTR_COUNTER(1),
-	ATTR_COUNTER(2),
-	{ .attr = { .name = NULL } }
+static const struct attribute_group *addrmatch_groups[] = {
+	&addrmatch_grp,
+	NULL
 };
 
-static const struct mcidev_sysfs_group i7core_udimm_counters = {
-	.name  = "all_channel_counts",
-	.mcidev_attr = i7core_udimm_counters_attrs,
+static void addrmatch_release(struct device *device)
+{
+	debugf1("Releasing device %s\n", dev_name(device));
+}
+
+static struct device_type addrmatch_type = {
+	.groups		= addrmatch_groups,
+	.release	= addrmatch_release,
 };
 
-static const struct mcidev_sysfs_attribute i7core_sysfs_rdimm_attrs[] = {
-	{
-		.attr = {
-			.name = "inject_section",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show  = i7core_inject_section_show,
-		.store = i7core_inject_section_store,
-	}, {
-		.attr = {
-			.name = "inject_type",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show  = i7core_inject_type_show,
-		.store = i7core_inject_type_store,
-	}, {
-		.attr = {
-			.name = "inject_eccmask",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show  = i7core_inject_eccmask_show,
-		.store = i7core_inject_eccmask_store,
-	}, {
-		.grp = &i7core_inject_addrmatch,
-	}, {
-		.attr = {
-			.name = "inject_enable",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show  = i7core_inject_enable_show,
-		.store = i7core_inject_enable_store,
-	},
-	{ }	/* End of list */
+/*
+ * all_channel_counts sysfs struct
+ */
+
+static struct attribute *i7core_udimm_counters_attrs[] = {
+	&dev_attr_udimm0.attr,
+	&dev_attr_udimm1.attr,
+	&dev_attr_udimm2.attr,
+	NULL
+};
+
+static struct attribute_group all_channel_counts_grp = {
+	.attrs	= i7core_udimm_counters_attrs,
 };
 
-static const struct mcidev_sysfs_attribute i7core_sysfs_udimm_attrs[] = {
-	{
-		.attr = {
-			.name = "inject_section",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show  = i7core_inject_section_show,
-		.store = i7core_inject_section_store,
-	}, {
-		.attr = {
-			.name = "inject_type",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show  = i7core_inject_type_show,
-		.store = i7core_inject_type_store,
-	}, {
-		.attr = {
-			.name = "inject_eccmask",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show  = i7core_inject_eccmask_show,
-		.store = i7core_inject_eccmask_store,
-	}, {
-		.grp = &i7core_inject_addrmatch,
-	}, {
-		.attr = {
-			.name = "inject_enable",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show  = i7core_inject_enable_show,
-		.store = i7core_inject_enable_store,
-	}, {
-		.grp = &i7core_udimm_counters,
-	},
-	{ }	/* End of list */
+static const struct attribute_group *all_channel_counts_groups[] = {
+	&all_channel_counts_grp,
+	NULL
 };
 
+static void all_channel_counts_release(struct device *device)
+{
+	debugf1("Releasing device %s\n", dev_name(device));
+}
+
+static struct device_type all_channel_counts_type = {
+	.groups		= all_channel_counts_groups,
+	.release	= all_channel_counts_release,
+};
+
+/*
+ * inject sysfs attributes
+ */
+
+static DEVICE_ATTR(inject_section, S_IRUGO | S_IWUSR,
+		   i7core_inject_section_show, i7core_inject_section_store);
+
+static DEVICE_ATTR(inject_type, S_IRUGO | S_IWUSR,
+		   i7core_inject_type_show, i7core_inject_type_store);
+
+
+static DEVICE_ATTR(inject_eccmask, S_IRUGO | S_IWUSR,
+		   i7core_inject_eccmask_show, i7core_inject_eccmask_store);
+
+static DEVICE_ATTR(inject_enable, S_IRUGO | S_IWUSR,
+		   i7core_inject_enable_show, i7core_inject_enable_store);
+
+static int i7core_create_sysfs_devices(struct mem_ctl_info *mci)
+{
+	struct i7core_pvt *pvt = mci->pvt_info;
+	int rc;
+
+	rc = device_create_file(&mci->dev, &dev_attr_inject_section);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_inject_type);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_inject_eccmask);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_inject_enable);
+	if (rc < 0)
+		return rc;
+
+	pvt->addrmatch_dev.type = &addrmatch_type;
+	pvt->addrmatch_dev.bus = mci->dev.bus;
+	device_initialize(&pvt->addrmatch_dev);
+	pvt->addrmatch_dev.parent = &mci->dev;
+	dev_set_name(&pvt->addrmatch_dev, "inject_addrmatch");
+	dev_set_drvdata(&pvt->addrmatch_dev, mci);
+
+	debugf1("%s(): creating %s\n", __func__,
+		dev_name(&pvt->addrmatch_dev));
+
+	rc = device_add(&pvt->addrmatch_dev);
+	if (rc < 0)
+		return rc;
+
+	if (!pvt->is_registered) {
+		pvt->chancounts_dev.type = &all_channel_counts_type;
+		pvt->chancounts_dev.bus = mci->dev.bus;
+		device_initialize(&pvt->chancounts_dev);
+		pvt->chancounts_dev.parent = &mci->dev;
+		dev_set_name(&pvt->chancounts_dev, "all_channel_counts");
+		dev_set_drvdata(&pvt->chancounts_dev, mci);
+
+		debugf1("%s(): creating %s\n", __func__,
+			dev_name(&pvt->chancounts_dev));
+
+		rc = device_add(&pvt->chancounts_dev);
+		if (rc < 0)
+			return rc;
+	}
+	return 0;
+}
+
+static void i7core_delete_sysfs_devices(struct mem_ctl_info *mci)
+{
+	struct i7core_pvt *pvt = mci->pvt_info;
+
+	debugf1("\n");
+
+	device_remove_file(&mci->dev, &dev_attr_inject_section);
+	device_remove_file(&mci->dev, &dev_attr_inject_type);
+	device_remove_file(&mci->dev, &dev_attr_inject_eccmask);
+	device_remove_file(&mci->dev, &dev_attr_inject_enable);
+
+	if (!pvt->is_registered) {
+		put_device(&pvt->chancounts_dev);
+		device_del(&pvt->chancounts_dev);
+	}
+	put_device(&pvt->addrmatch_dev);
+	device_del(&pvt->addrmatch_dev);
+}
+
 /****************************************************************************
 	Device initialization routines: put/get, init/exit
  ****************************************************************************/
@@ -2119,6 +2195,7 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	i7core_pci_ctl_release(pvt);
 
 	/* Remove MC sysfs nodes */
+	i7core_delete_sysfs_devices(mci);
 	edac_mc_del_mc(mci->pdev);
 
 	debugf1("%s: free mci struct\n", mci->ctl_name);
@@ -2177,10 +2254,6 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	if (unlikely(rc < 0))
 		goto fail0;
 
-	if (pvt->is_registered)
-		mci->mc_driver_sysfs_attributes = i7core_sysfs_rdimm_attrs;
-	else
-		mci->mc_driver_sysfs_attributes = i7core_sysfs_udimm_attrs;
 
 	/* Get dimm basic config */
 	get_dimm_config(mci);
@@ -2204,6 +2277,13 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 		rc = -EINVAL;
 		goto fail0;
 	}
+	if (i7core_create_sysfs_devices(mci)) {
+		debugf0("MC: " __FILE__
+			": %s(): failed to create sysfs nodes\n", __func__);
+		edac_mc_del_mc(mci->pdev);
+		rc = -EINVAL;
+		goto fail0;
+	}
 
 	/* Default error mask is any memory */
 	pvt->inject.channel = 0;
-- 
1.7.8

