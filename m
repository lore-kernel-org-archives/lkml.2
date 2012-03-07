Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2CGLlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:41:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756400Ab2CGLkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:40:46 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] edac: Add per-dimm sysfs show nodes
Date: Wed,  7 Mar 2012 08:40:38 -0300
Message-Id: <1331120438-27523-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs nodes to describe DIMM properties: size, memory type,
dev type and edac mode.

With this change, the physical memory characteristics of the dimm stick
is now properly presented, as detected by the memory controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |   36 ++++++++++++++++--
 include/linux/edac.h         |   82 +++++++++++++++++++++++++++++------------
 2 files changed, 90 insertions(+), 28 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 9bfc930..875cd01d 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -498,14 +498,42 @@ static ssize_t dimmdev_label_store(struct dimm_info *dimm,
 	return max_size;
 }
 
+static ssize_t dimmdev_size_show(struct dimm_info *dimm, char *data)
+{
+	return sprintf(data, "%u\n", PAGES_TO_MiB(dimm->nr_pages));
+}
+
+static ssize_t dimmdev_mem_type_show(struct dimm_info *dimm, char *data)
+{
+	return sprintf(data, "%s\n", mem_types[dimm->mtype]);
+}
+
+static ssize_t dimmdev_dev_type_show(struct dimm_info *dimm, char *data)
+{
+	return sprintf(data, "%s\n", dev_types[dimm->dtype]);
+}
+
+static ssize_t dimmdev_edac_mode_show(struct dimm_info *dimm, char *data)
+{
+	return sprintf(data, "%s\n", edac_caps[dimm->edac_mode]);
+}
+
 /* default cwrow<id>/attribute files */
-DIMMDEV_ATTR(label, S_IRUGO | S_IWUSR, dimmdev_label_show, dimmdev_label_store);
-DIMMDEV_ATTR(location, S_IRUGO, dimmdev_location_show, NULL);
+DIMMDEV_ATTR(dimm_label, S_IRUGO | S_IWUSR, dimmdev_label_show, dimmdev_label_store);
+DIMMDEV_ATTR(dimm_location, S_IRUGO, dimmdev_location_show, NULL);
+DIMMDEV_ATTR(dimm_size, S_IRUGO, dimmdev_size_show, NULL);
+DIMMDEV_ATTR(dimm_mem_type, S_IRUGO, dimmdev_mem_type_show, NULL);
+DIMMDEV_ATTR(dimm_dev_type, S_IRUGO, dimmdev_dev_type_show, NULL);
+DIMMDEV_ATTR(dimm_edac_mode, S_IRUGO, dimmdev_edac_mode_show, NULL);
 
 /* default attributes of the DIMM<id> object */
 static struct dimmdev_attribute *default_dimm_attr[] = {
-	&attr_label,
-	&attr_location,
+	&attr_dimm_label,
+	&attr_dimm_location,
+	&attr_dimm_size,
+	&attr_dimm_mem_type,
+	&attr_dimm_dev_type,
+	&attr_dimm_edac_mode,
 	NULL,
 };
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index e9c376a..1862a4b 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -45,7 +45,19 @@ static inline void opstate_init(void)
 #define EDAC_MC_LABEL_LEN	31
 #define MC_PROC_NAME_MAX_LEN	7
 
-/* memory devices */
+/**
+ * enum dev_type - describe the type of memory DRAM chips used at the stick
+ * @DEV_UNKNOWN:	Can't be determined, or MC doesn't support detect it
+ * @DEV_X1:		1 bit for data
+ * @DEV_X2:		2 bits for data
+ * @DEV_X4:		4 bits for data
+ * @DEV_X8:		8 bits for data
+ * @DEV_X16:		16 bits for data
+ * @DEV_X32:		32 bits for data
+ * @DEV_X64:		64 bits for data
+ *
+ * Typical values are x4 and x8.
+ */
 enum dev_type {
 	DEV_UNKNOWN = 0,
 	DEV_X1,
@@ -67,7 +79,7 @@ enum dev_type {
 #define DEV_FLAG_X64		BIT(DEV_X64)
 
 /**
- * enum mem_type - memory types
+ * enum mem_type - Type of the memory stick
  *
  * @MEM_EMPTY		Empty csrow
  * @MEM_RESERVED:	Reserved csrow type
@@ -171,18 +183,29 @@ enum mem_type {
 #define MEM_FLAG_DDR3		 BIT(MEM_DDR3)
 #define MEM_FLAG_RDDR3		 BIT(MEM_RDDR3)
 
-/* chipset Error Detection and Correction capabilities and mode */
+/** enum edac-type - Error Detection and Correction capabilities and mode
+ * @EDAC_UNKNOWN:	Unknown if ECC is available
+ * @EDAC_NONE:		Doesn't support ECC
+ * @EDAC_RESERVED:	Reserved ECC type
+ * @EDAC_PARITY:	Detects parity errors
+ * @EDAC_EC:		Error Checking - no correction
+ * @EDAC_SECDED:	Single bit error correction, Double detection
+ * @EDAC_S2ECD2ED:	Chipkill x2 devices - do these exist?
+ * @EDAC_S4ECD4ED:	Chipkill x4 devices
+ * @EDAC_S8ECD8ED:	Chipkill x8 devices
+ * @EDAC_S16ECD16ED:	Chipkill x16 devices
+ */
 enum edac_type {
-	EDAC_UNKNOWN = 0,	/* Unknown if ECC is available */
-	EDAC_NONE,		/* Doesn't support ECC */
-	EDAC_RESERVED,		/* Reserved ECC type */
-	EDAC_PARITY,		/* Detects parity errors */
-	EDAC_EC,		/* Error Checking - no correction */
-	EDAC_SECDED,		/* Single bit error correction, Double detection */
-	EDAC_S2ECD2ED,		/* Chipkill x2 devices - do these exist? */
-	EDAC_S4ECD4ED,		/* Chipkill x4 devices */
-	EDAC_S8ECD8ED,		/* Chipkill x8 devices */
-	EDAC_S16ECD16ED,	/* Chipkill x16 devices */
+	EDAC_UNKNOWN =	0,
+	EDAC_NONE,
+	EDAC_RESERVED,
+	EDAC_PARITY,
+	EDAC_EC,
+	EDAC_SECDED,
+	EDAC_S2ECD2ED,
+	EDAC_S4ECD4ED,
+	EDAC_S8ECD8ED,
+	EDAC_S16ECD16ED,
 };
 
 #define EDAC_FLAG_UNKNOWN	BIT(EDAC_UNKNOWN)
@@ -195,18 +218,29 @@ enum edac_type {
 #define EDAC_FLAG_S8ECD8ED	BIT(EDAC_S8ECD8ED)
 #define EDAC_FLAG_S16ECD16ED	BIT(EDAC_S16ECD16ED)
 
-/* scrubbing capabilities */
+/** enum scrub_type - scrubbing capabilities
+ * @SCRUB_UNKNOWN		Unknown if scrubber is available
+ * @SCRUB_NONE:			No scrubber
+ * @SCRUB_SW_PROG:		SW progressive (sequential) scrubbing
+ * @SCRUB_SW_SRC:		Software scrub only errors
+ * @SCRUB_SW_PROG_SRC:		Progressive software scrub from an error
+ * @SCRUB_SW_TUNABLE:		Software scrub frequency is tunable
+ * @SCRUB_HW_PROG:		HW progressive (sequential) scrubbing
+ * @SCRUB_HW_SRC:		Hardware scrub only errors
+ * @SCRUB_HW_PROG_SRC:		Progressive hardware scrub from an error
+ * SCRUB_HW_TUNABLE:		Hardware scrub frequency is tunable
+ */
 enum scrub_type {
-	SCRUB_UNKNOWN = 0,	/* Unknown if scrubber is available */
-	SCRUB_NONE,		/* No scrubber */
-	SCRUB_SW_PROG,		/* SW progressive (sequential) scrubbing */
-	SCRUB_SW_SRC,		/* Software scrub only errors */
-	SCRUB_SW_PROG_SRC,	/* Progressive software scrub from an error */
-	SCRUB_SW_TUNABLE,	/* Software scrub frequency is tunable */
-	SCRUB_HW_PROG,		/* HW progressive (sequential) scrubbing */
-	SCRUB_HW_SRC,		/* Hardware scrub only errors */
-	SCRUB_HW_PROG_SRC,	/* Progressive hardware scrub from an error */
-	SCRUB_HW_TUNABLE	/* Hardware scrub frequency is tunable */
+	SCRUB_UNKNOWN =	0,
+	SCRUB_NONE,
+	SCRUB_SW_PROG,
+	SCRUB_SW_SRC,
+	SCRUB_SW_PROG_SRC,
+	SCRUB_SW_TUNABLE,
+	SCRUB_HW_PROG,
+	SCRUB_HW_SRC,
+	SCRUB_HW_PROG_SRC,
+	SCRUB_HW_TUNABLE
 };
 
 #define SCRUB_FLAG_SW_PROG	BIT(SCRUB_SW_PROG)
-- 
1.7.8

