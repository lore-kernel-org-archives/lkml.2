Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab2DPUmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:42:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711Ab2DPUi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:38:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [EDAC ABI v13 11/25] amd64_edac: convert sysfs logic to use struct device
Date: Mon, 16 Apr 2012 17:38:35 -0300
Message-Id: <1334608729-30803-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the EDAC core supports struct device, there's no sense
on having any logic at the EDAC core to simulate it. So, instead
of adding such logic there, change the logic at amd64_edac to
use it.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c     |   43 ++++++++------
 drivers/edac/amd64_edac.h     |   29 +++++++--
 drivers/edac/amd64_edac_dbg.c |   89 ++++++++++++++--------------
 drivers/edac/amd64_edac_inj.c |  128 +++++++++++++++++++++++-----------------
 4 files changed, 167 insertions(+), 122 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index b26fc06..321b838 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2434,26 +2434,29 @@ static bool ecc_enabled(struct pci_dev *F3, u8 nid)
 	return true;
 }
 
-struct mcidev_sysfs_attribute sysfs_attrs[ARRAY_SIZE(amd64_dbg_attrs) +
-					  ARRAY_SIZE(amd64_inj_attrs) +
-					  1];
-
-struct mcidev_sysfs_attribute terminator = { .attr = { .name = NULL } };
-
-static void set_mc_sysfs_attrs(struct mem_ctl_info *mci)
+static int set_mc_sysfs_attrs(struct mem_ctl_info *mci)
 {
-	unsigned int i = 0, j = 0;
+	int rc;
 
-	for (; i < ARRAY_SIZE(amd64_dbg_attrs); i++)
-		sysfs_attrs[i] = amd64_dbg_attrs[i];
+	rc = amd64_create_sysfs_dbg_files(mci);
+	if (rc < 0)
+		return rc;
 
-	if (boot_cpu_data.x86 >= 0x10)
-		for (j = 0; j < ARRAY_SIZE(amd64_inj_attrs); j++, i++)
-			sysfs_attrs[i] = amd64_inj_attrs[j];
+	if (boot_cpu_data.x86 >= 0x10) {
+		rc = amd64_create_sysfs_inject_files(mci);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
 
-	sysfs_attrs[i] = terminator;
+static void del_mc_sysfs_attrs(struct mem_ctl_info *mci)
+{
+	amd64_remove_sysfs_dbg_files(mci);
 
-	mci->mc_driver_sysfs_attributes = sysfs_attrs;
+	if (boot_cpu_data.x86 >= 0x10)
+		amd64_remove_sysfs_inject_files(mci);
 }
 
 static void setup_mci_misc_attrs(struct mem_ctl_info *mci,
@@ -2579,13 +2582,15 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	if (init_csrows(mci))
 		mci->edac_cap = EDAC_FLAG_NONE;
 
-	set_mc_sysfs_attrs(mci);
-
 	ret = -ENODEV;
 	if (edac_mc_add_mc(mci)) {
 		debugf1("failed edac_mc_add_mc()\n");
 		goto err_add_mc;
 	}
+	if (set_mc_sysfs_attrs(mci)) {
+		debugf1("failed edac_mc_add_mc()\n");
+		goto err_add_sysfs;
+	}
 
 	/* register stuff with EDAC MCE */
 	if (report_gart_errors)
@@ -2599,6 +2604,8 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 
 	return 0;
 
+err_add_sysfs:
+	edac_mc_del_mc(mci->pdev);
 err_add_mc:
 	edac_mc_free(mci);
 
@@ -2669,6 +2676,8 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s = ecc_stngs[nid];
 
+	mci = find_mci_by_dev(&pdev->dev);
+	del_mc_sysfs_attrs(mci);
 	/* Remove from EDAC CORE tracking list */
 	mci = edac_mc_del_mc(&pdev->dev);
 	if (!mci)
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 9a666cb..098f336 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -413,20 +413,33 @@ struct ecc_settings {
 };
 
 #ifdef CONFIG_EDAC_DEBUG
-#define NUM_DBG_ATTRS 5
+int amd64_create_sysfs_dbg_files(struct mem_ctl_info *mci);
+void amd64_remove_sysfs_dbg_files(struct mem_ctl_info *mci);
+
 #else
-#define NUM_DBG_ATTRS 0
+static inline int amd64_create_sysfs_dbg_files(struct mem_ctl_info *mci)
+{
+	return 0;
+}
+void inline amd64_remove_sysfs_dbg_files(struct mem_ctl_info *mci)
+{
+}
 #endif
 
 #ifdef CONFIG_EDAC_AMD64_ERROR_INJECTION
-#define NUM_INJ_ATTRS 5
+int amd64_create_sysfs_inject_files(struct mem_ctl_info *mci);
+void amd64_remove_sysfs_inject_files(struct mem_ctl_info *mci);
+
 #else
-#define NUM_INJ_ATTRS 0
+static inline int amd64_create_sysfs_inject_files(struct mem_ctl_info *mci)
+{
+	return 0;
+}
+static inline void amd64_remove_sysfs_inject_files(struct mem_ctl_info *mci)
+{
+}
 #endif
 
-extern struct mcidev_sysfs_attribute amd64_dbg_attrs[NUM_DBG_ATTRS],
-				     amd64_inj_attrs[NUM_INJ_ATTRS];
-
 /*
  * Each of the PCI Device IDs types have their own set of hardware accessor
  * functions and per device encoding/decoding logic.
@@ -460,3 +473,5 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
 
 int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 			     u64 *hole_offset, u64 *hole_size);
+
+#define to_mci(k) container_of(k, struct mem_ctl_info, dev)
diff --git a/drivers/edac/amd64_edac_dbg.c b/drivers/edac/amd64_edac_dbg.c
index e356228..2c1bbf7 100644
--- a/drivers/edac/amd64_edac_dbg.c
+++ b/drivers/edac/amd64_edac_dbg.c
@@ -1,8 +1,11 @@
 #include "amd64_edac.h"
 
 #define EDAC_DCT_ATTR_SHOW(reg)						\
-static ssize_t amd64_##reg##_show(struct mem_ctl_info *mci, char *data)	\
+static ssize_t amd64_##reg##_show(struct device *dev,			\
+			       struct device_attribute *mattr,		\
+			       char *data)				\
 {									\
+	struct mem_ctl_info *mci = to_mci(dev);				\
 	struct amd64_pvt *pvt = mci->pvt_info;				\
 		return sprintf(data, "0x%016llx\n", (u64)pvt->reg);	\
 }
@@ -12,8 +15,12 @@ EDAC_DCT_ATTR_SHOW(dbam0);
 EDAC_DCT_ATTR_SHOW(top_mem);
 EDAC_DCT_ATTR_SHOW(top_mem2);
 
-static ssize_t amd64_hole_show(struct mem_ctl_info *mci, char *data)
+static ssize_t amd64_hole_show(struct device *dev,
+			       struct device_attribute *mattr,
+			       char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
+
 	u64 hole_base = 0;
 	u64 hole_offset = 0;
 	u64 hole_size = 0;
@@ -27,46 +34,40 @@ static ssize_t amd64_hole_show(struct mem_ctl_info *mci, char *data)
 /*
  * update NUM_DBG_ATTRS in case you add new members
  */
-struct mcidev_sysfs_attribute amd64_dbg_attrs[] = {
+static DEVICE_ATTR(dhar, S_IRUGO, amd64_dhar_show, NULL);
+static DEVICE_ATTR(dbam, S_IRUGO, amd64_dbam0_show, NULL);
+static DEVICE_ATTR(topmem, S_IRUGO, amd64_top_mem_show, NULL);
+static DEVICE_ATTR(topmem2, S_IRUGO, amd64_top_mem2_show, NULL);
+static DEVICE_ATTR(dram_hole, S_IRUGO, amd64_hole_show, NULL);
+
+int amd64_create_sysfs_dbg_files(struct mem_ctl_info *mci)
+{
+	int rc;
+
+	rc = device_create_file(&mci->dev, &dev_attr_dhar);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_dbam);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_topmem);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_topmem2);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_dram_hole);
+	if (rc < 0)
+		return rc;
 
-	{
-		.attr = {
-			.name = "dhar",
-			.mode = (S_IRUGO)
-		},
-		.show = amd64_dhar_show,
-		.store = NULL,
-	},
-	{
-		.attr = {
-			.name = "dbam",
-			.mode = (S_IRUGO)
-		},
-		.show = amd64_dbam0_show,
-		.store = NULL,
-	},
-	{
-		.attr = {
-			.name = "topmem",
-			.mode = (S_IRUGO)
-		},
-		.show = amd64_top_mem_show,
-		.store = NULL,
-	},
-	{
-		.attr = {
-			.name = "topmem2",
-			.mode = (S_IRUGO)
-		},
-		.show = amd64_top_mem2_show,
-		.store = NULL,
-	},
-	{
-		.attr = {
-			.name = "dram_hole",
-			.mode = (S_IRUGO)
-		},
-		.show = amd64_hole_show,
-		.store = NULL,
-	},
-};
+	return 0;
+}
+
+void amd64_remove_sysfs_dbg_files(struct mem_ctl_info *mci)
+{
+	device_remove_file(&mci->dev, &dev_attr_dhar);
+	device_remove_file(&mci->dev, &dev_attr_dbam);
+	device_remove_file(&mci->dev, &dev_attr_topmem);
+	device_remove_file(&mci->dev, &dev_attr_topmem2);
+	device_remove_file(&mci->dev, &dev_attr_dram_hole);
+}
diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
index 303f10e..ef1ff4e 100644
--- a/drivers/edac/amd64_edac_inj.c
+++ b/drivers/edac/amd64_edac_inj.c
@@ -1,7 +1,10 @@
 #include "amd64_edac.h"
 
-static ssize_t amd64_inject_section_show(struct mem_ctl_info *mci, char *buf)
+static ssize_t amd64_inject_section_show(struct device *dev,
+					 struct device_attribute *mattr,
+					 char *buf)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct amd64_pvt *pvt = mci->pvt_info;
 	return sprintf(buf, "0x%x\n", pvt->injection.section);
 }
@@ -12,9 +15,11 @@ static ssize_t amd64_inject_section_show(struct mem_ctl_info *mci, char *buf)
  *
  * range: 0..3
  */
-static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
+static ssize_t amd64_inject_section_store(struct device *dev,
+					  struct device_attribute *mattr,
 					  const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct amd64_pvt *pvt = mci->pvt_info;
 	unsigned long value;
 	int ret = 0;
@@ -33,8 +38,11 @@ static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
 	return ret;
 }
 
-static ssize_t amd64_inject_word_show(struct mem_ctl_info *mci, char *buf)
+static ssize_t amd64_inject_word_show(struct device *dev,
+					struct device_attribute *mattr,
+					char *buf)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct amd64_pvt *pvt = mci->pvt_info;
 	return sprintf(buf, "0x%x\n", pvt->injection.word);
 }
@@ -45,9 +53,11 @@ static ssize_t amd64_inject_word_show(struct mem_ctl_info *mci, char *buf)
  *
  * range: 0..8
  */
-static ssize_t amd64_inject_word_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
+static ssize_t amd64_inject_word_store(struct device *dev,
+				       struct device_attribute *mattr,
+				       const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct amd64_pvt *pvt = mci->pvt_info;
 	unsigned long value;
 	int ret = 0;
@@ -66,8 +76,11 @@ static ssize_t amd64_inject_word_store(struct mem_ctl_info *mci,
 	return ret;
 }
 
-static ssize_t amd64_inject_ecc_vector_show(struct mem_ctl_info *mci, char *buf)
+static ssize_t amd64_inject_ecc_vector_show(struct device *dev,
+					    struct device_attribute *mattr,
+					    char *buf)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct amd64_pvt *pvt = mci->pvt_info;
 	return sprintf(buf, "0x%x\n", pvt->injection.bit_map);
 }
@@ -77,9 +90,11 @@ static ssize_t amd64_inject_ecc_vector_show(struct mem_ctl_info *mci, char *buf)
  * corresponding bit within the error injection word above. When used during a
  * DRAM ECC read, it holds the contents of the of the DRAM ECC bits.
  */
-static ssize_t amd64_inject_ecc_vector_store(struct mem_ctl_info *mci,
-					     const char *data, size_t count)
+static ssize_t amd64_inject_ecc_vector_store(struct device *dev,
+				       struct device_attribute *mattr,
+				       const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct amd64_pvt *pvt = mci->pvt_info;
 	unsigned long value;
 	int ret = 0;
@@ -103,9 +118,11 @@ static ssize_t amd64_inject_ecc_vector_store(struct mem_ctl_info *mci,
  * Do a DRAM ECC read. Assemble staged values in the pvt area, format into
  * fields needed by the injection registers and read the NB Array Data Port.
  */
-static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
+static ssize_t amd64_inject_read_store(struct device *dev,
+				       struct device_attribute *mattr,
+				       const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct amd64_pvt *pvt = mci->pvt_info;
 	unsigned long value;
 	u32 section, word_bits;
@@ -136,9 +153,11 @@ static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
  * Do a DRAM ECC write. Assemble staged values in the pvt area and format into
  * fields needed by the injection registers.
  */
-static ssize_t amd64_inject_write_store(struct mem_ctl_info *mci,
+static ssize_t amd64_inject_write_store(struct device *dev,
+					struct device_attribute *mattr,
 					const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	struct amd64_pvt *pvt = mci->pvt_info;
 	unsigned long value;
 	u32 section, word_bits;
@@ -168,46 +187,47 @@ static ssize_t amd64_inject_write_store(struct mem_ctl_info *mci,
 /*
  * update NUM_INJ_ATTRS in case you add new members
  */
-struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
-
-	{
-		.attr = {
-			.name = "inject_section",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show = amd64_inject_section_show,
-		.store = amd64_inject_section_store,
-	},
-	{
-		.attr = {
-			.name = "inject_word",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show = amd64_inject_word_show,
-		.store = amd64_inject_word_store,
-	},
-	{
-		.attr = {
-			.name = "inject_ecc_vector",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show = amd64_inject_ecc_vector_show,
-		.store = amd64_inject_ecc_vector_store,
-	},
-	{
-		.attr = {
-			.name = "inject_write",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show = NULL,
-		.store = amd64_inject_write_store,
-	},
-	{
-		.attr = {
-			.name = "inject_read",
-			.mode = (S_IRUGO | S_IWUSR)
-		},
-		.show = NULL,
-		.store = amd64_inject_read_store,
-	},
-};
+
+static DEVICE_ATTR(inject_section, S_IRUGO | S_IWUSR,
+		   amd64_inject_section_show, amd64_inject_section_store);
+static DEVICE_ATTR(inject_word, S_IRUGO | S_IWUSR,
+		   amd64_inject_word_show, amd64_inject_word_store);
+static DEVICE_ATTR(inject_ecc_vector, S_IRUGO | S_IWUSR,
+		   amd64_inject_ecc_vector_show, amd64_inject_ecc_vector_store);
+static DEVICE_ATTR(inject_write, S_IRUGO | S_IWUSR,
+		   NULL, amd64_inject_write_store);
+static DEVICE_ATTR(inject_read, S_IRUGO | S_IWUSR,
+		   NULL, amd64_inject_read_store);
+
+
+int amd64_create_sysfs_inject_files(struct mem_ctl_info *mci)
+{
+	int rc;
+
+	rc = device_create_file(&mci->dev, &dev_attr_inject_section);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_inject_word);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_inject_ecc_vector);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_inject_write);
+	if (rc < 0)
+		return rc;
+	rc = device_create_file(&mci->dev, &dev_attr_inject_read);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
+void amd64_remove_sysfs_inject_files(struct mem_ctl_info *mci)
+{
+	device_remove_file(&mci->dev, &dev_attr_inject_section);
+	device_remove_file(&mci->dev, &dev_attr_inject_word);
+	device_remove_file(&mci->dev, &dev_attr_inject_ecc_vector);
+	device_remove_file(&mci->dev, &dev_attr_inject_write);
+	device_remove_file(&mci->dev, &dev_attr_inject_read);
+}
-- 
1.7.8

