Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814Ab2HPOxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:53:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58917 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab2HPOwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:52:38 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 1/2] UBI: replace MTD_UBI_BEB_LIMIT with module parameter
Date: Thu, 16 Aug 2012 16:52:02 +0200
Message-Id: <1345128723-13582-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345042639.3393.150.camel@sauron.fi.intel.com>
References: <1345042639.3393.150.camel@sauron.fi.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the possibility to adjust the "maximum expected number of
bad blocks per 1024 blocks" (max_beb_per1024) for each mtd device.

The majority of NAND devices have their max_beb_per1024 equal to 20, but
sometimes it's more.
Now, we can adjust that via a kernel parameter:
ubi.mtd=<name|num|path>[,<vid_hdr_offs>[,max_beb_per1024]]

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/configs/sam9_l9260_defconfig |    1 -
 drivers/mtd/ubi/Kconfig               |   26 ---------
 drivers/mtd/ubi/build.c               |   93 ++++++++++++++++++++++-----------
 drivers/mtd/ubi/cdev.c                |    3 +-
 drivers/mtd/ubi/ubi.h                 |    6 ++-
 5 files changed, 70 insertions(+), 59 deletions(-)

diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_l9260_defconfig
index d11fea5..47dd71a 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -39,7 +39,6 @@ CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_MTD_UBI=y
-CONFIG_MTD_UBI_BEB_LIMIT=30
 CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index f326877..7a57cc0 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -27,32 +27,6 @@ config MTD_UBI_WL_THRESHOLD
 	  life-cycle less than 10000, the threshold should be lessened (e.g.,
 	  to 128 or 256, although it does not have to be power of 2).
 
-config MTD_UBI_BEB_LIMIT
-	int "Maximum expected bad eraseblock count per 1024 eraseblocks"
-	default 20
-	range 2 256
-	help
-	  This option specifies the maximum bad physical eraseblocks UBI
-	  expects on the MTD device (per 1024 eraseblocks). If the underlying
-	  flash does not admit of bad eraseblocks (e.g. NOR flash), this value
-	  is ignored.
-
-	  NAND datasheets often specify the minimum and maximum NVM (Number of
-	  Valid Blocks) for the flashes' endurance lifetime. The maximum
-	  expected bad eraseblocks per 1024 eraseblocks then can be calculated
-	  as "1024 * (1 - MinNVB / MaxNVB)", which gives 20 for most NANDs
-	  (MaxNVB is basically the total count of eraseblocks on the chip).
-
-	  To put it differently, if this value is 20, UBI will try to reserve
-	  about 1.9% of physical eraseblocks for bad blocks handling. And that
-	  will be 1.9% of eraseblocks on the entire NAND chip, not just the MTD
-	  partition UBI attaches. This means that if you have, say, a NAND
-	  flash chip admits maximum 40 bad eraseblocks, and it is split on two
-	  MTD partitions of the same size, UBI will reserve 40 eraseblocks when
-	  attaching a partition.
-
-	  Leave the default value if unsure.
-
 config MTD_UBI_GLUEBI
 	tristate "MTD devices emulation driver (gluebi)"
 	help
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 738772c..65edbc0 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -46,6 +46,8 @@
 /* Maximum length of the 'mtd=' parameter */
 #define MTD_PARAM_LEN_MAX 64
 
+#define MTD_PARAM_NB_MAX 3
+
 #ifdef CONFIG_MTD_UBI_MODULE
 #define ubi_is_module() 1
 #else
@@ -57,10 +59,12 @@
  * @name: MTD character device node path, MTD device name, or MTD device number
  *        string
  * @vid_hdr_offs: VID header offset
+ * @max_beb_per1024: maximum expected number of bad blocks per 1024 erase blocks
  */
 struct mtd_dev_param {
 	char name[MTD_PARAM_LEN_MAX];
 	int vid_hdr_offs;
+	unsigned int max_beb_per1024;
 };
 
 /* Numbers of elements set in the @mtd_dev_param array */
@@ -565,9 +569,37 @@ void ubi_free_internal_volumes(struct ubi_device *ubi)
 	}
 }
 
+static int get_bad_peb_limit(const struct ubi_device *ubi,
+			     unsigned int max_beb_per1024)
+{
+	int device_pebs;
+	uint64_t device_size;
+	int limit = 0;
+
+	/*
+	 * Here we are using size of the entire flash chip and
+	 * not just the MTD partition size because the maximum
+	 * number of bad eraseblocks is a percentage of the
+	 * whole device and bad eraseblocks are not fairly
+	 * distributed over the flash chip. So the worst case
+	 * is that all the bad eraseblocks of the chip are in
+	 * the MTD partition we are attaching (ubi->mtd).
+	 */
+	device_size = mtd_get_device_size(ubi->mtd);
+	device_pebs = mtd_div_by_eb(device_size, ubi->mtd);
+	limit = mult_frac(device_pebs, max_beb_per1024, 1024);
+
+	/* Round it up */
+	if (mult_frac(limit, 1024, max_beb_per1024) < device_pebs)
+		limit += 1;
+
+	return limit;
+}
+
 /**
  * io_init - initialize I/O sub-system for a given UBI device.
  * @ubi: UBI device description object
+ * @max_beb_per1024: maximum expected number of bad PEB per 1024 PEB
  *
  * If @ubi->vid_hdr_offset or @ubi->leb_start is zero, default offsets are
  * assumed:
@@ -580,7 +612,7 @@ void ubi_free_internal_volumes(struct ubi_device *ubi)
  * This function returns zero in case of success and a negative error code in
  * case of failure.
  */
-static int io_init(struct ubi_device *ubi)
+static int io_init(struct ubi_device *ubi, unsigned int max_beb_per1024)
 {
 	if (ubi->mtd->numeraseregions != 0) {
 		/*
@@ -610,29 +642,7 @@ static int io_init(struct ubi_device *ubi)
 
 	if (mtd_can_have_bb(ubi->mtd)) {
 		ubi->bad_allowed = 1;
-		if (CONFIG_MTD_UBI_BEB_LIMIT > 0) {
-			int per1024 = CONFIG_MTD_UBI_BEB_LIMIT;
-			int limit, device_pebs;
-			uint64_t device_size;
-
-			/*
-			 * Here we are using size of the entire flash chip and
-			 * not just the MTD partition size because the maximum
-			 * number of bad eraseblocks is a percentage of the
-			 * whole device and bad eraseblocks are not fairly
-			 * distributed over the flash chip. So the worst case
-			 * is that all the bad eraseblocks of the chip are in
-			 * the MTD partition we are attaching (ubi->mtd).
-			 */
-			device_size = mtd_get_device_size(ubi->mtd);
-			device_pebs = mtd_div_by_eb(device_size, ubi->mtd);
-			limit = mult_frac(device_pebs, per1024, 1024);
-
-			/* Round it up */
-			if (mult_frac(limit, 1024, per1024) < device_pebs)
-				limit += 1;
-			ubi->bad_peb_limit = limit;
-		}
+		ubi->bad_peb_limit = get_bad_peb_limit(ubi, max_beb_per1024);
 	}
 
 	if (ubi->mtd->type == MTD_NORFLASH) {
@@ -825,6 +835,7 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
  * @mtd: MTD device description object
  * @ubi_num: number to assign to the new UBI device
  * @vid_hdr_offset: VID header offset
+ * @max_beb_per1024: maximum number of expected bad blocks per 1024 eraseblocks
  *
  * This function attaches MTD device @mtd_dev to UBI and assign @ubi_num number
  * to the newly created UBI device, unless @ubi_num is %UBI_DEV_NUM_AUTO, in
@@ -835,7 +846,8 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
  * Note, the invocations of this function has to be serialized by the
  * @ubi_devices_mutex.
  */
-int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
+int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
+		       int vid_hdr_offset, unsigned int max_beb_per1024)
 {
 	struct ubi_device *ubi;
 	int i, err, ref = 0;
@@ -908,7 +920,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	dbg_msg("sizeof(struct ubi_ainf_peb) %zu", sizeof(struct ubi_ainf_peb));
 	dbg_msg("sizeof(struct ubi_wl_entry) %zu", sizeof(struct ubi_wl_entry));
 
-	err = io_init(ubi);
+	err = io_init(ubi, max_beb_per1024);
 	if (err)
 		goto out_free;
 
@@ -1197,7 +1209,7 @@ static int __init ubi_init(void)
 
 		mutex_lock(&ubi_devices_mutex);
 		err = ubi_attach_mtd_dev(mtd, UBI_DEV_NUM_AUTO,
-					 p->vid_hdr_offs);
+					 p->vid_hdr_offs, p->max_beb_per1024);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0) {
 			ubi_err("cannot attach mtd%d", mtd->index);
@@ -1316,7 +1328,8 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 	struct mtd_dev_param *p;
 	char buf[MTD_PARAM_LEN_MAX];
 	char *pbuf = &buf[0];
-	char *tokens[2] = {NULL, NULL};
+	char *tokens[MTD_PARAM_NB_MAX];
+	int err;
 
 	if (!val)
 		return -EINVAL;
@@ -1346,7 +1359,7 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 	if (buf[len - 1] == '\n')
 		buf[len - 1] = '\0';
 
-	for (i = 0; i < 2; i++)
+	for (i = 0; i < MTD_PARAM_NB_MAX; i++)
 		tokens[i] = strsep(&pbuf, ",");
 
 	if (pbuf) {
@@ -1364,18 +1377,38 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 	if (p->vid_hdr_offs < 0)
 		return p->vid_hdr_offs;
 
+	if (tokens[2]) {
+		err = kstrtouint(tokens[2], 10, &p->max_beb_per1024);
+		if (err) {
+			pr_err("UBI error: bad value for max_beb_per1024 parameter: %s",
+			       tokens[2]);
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * A value of 0 is forced to the default value to keep the same
+	 * behavior between ubiattach command and module parameter
+	 */
+	if (!p->max_beb_per1024)
+		p->max_beb_per1024 = MTD_UBI_DEFAULT_BEB_LIMIT;
+
 	mtd_devs += 1;
 	return 0;
 }
 
 module_param_call(mtd, ubi_mtd_param_parse, NULL, NULL, 000);
 MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
-		      "mtd=<name|num|path>[,<vid_hdr_offs>].\n"
+		      "mtd=<name|num|path>[,<vid_hdr_offs>[,max_beb_per1024]].\n"
 		      "Multiple \"mtd\" parameters may be specified.\n"
 		      "MTD devices may be specified by their number, name, or "
 		      "path to the MTD character device node.\n"
 		      "Optional \"vid_hdr_offs\" parameter specifies UBI VID "
 		      "header position to be used by UBI.\n"
+		      "Optional \"max_beb_per1024\" parameter specifies the "
+		      "maximum expected bad eraseblock per 1024 eraseblocks."
+		      "(default " __stringify(MTD_UBI_DEFAULT_BEB_LIMIT)
+		      " if 0 or not set)\n"
 		      "Example 1: mtd=/dev/mtd0 - attach MTD device "
 		      "/dev/mtd0.\n"
 		      "Example 2: mtd=content,1984 mtd=4 - attach MTD device "
diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index fb55678..e0027e7 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -1010,7 +1010,8 @@ static long ctrl_cdev_ioctl(struct file *file, unsigned int cmd,
 		 * 'ubi_attach_mtd_dev()'.
 		 */
 		mutex_lock(&ubi_devices_mutex);
-		err = ubi_attach_mtd_dev(mtd, req.ubi_num, req.vid_hdr_offset);
+		err = ubi_attach_mtd_dev(mtd, req.ubi_num, req.vid_hdr_offset,
+					 MTD_UBI_DEFAULT_BEB_LIMIT);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0)
 			put_mtd_device(mtd);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index c94612e..f926343 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -50,6 +50,9 @@
 /* UBI name used for character devices, sysfs, etc */
 #define UBI_NAME_STR "ubi"
 
+/* Default number of maximum expected bad blocks per 1024 eraseblocks */
+#define MTD_UBI_DEFAULT_BEB_LIMIT 20
+
 /* Normal UBI messages */
 #define ubi_msg(fmt, ...) printk(KERN_NOTICE "UBI: " fmt "\n", ##__VA_ARGS__)
 /* UBI warning messages */
@@ -693,7 +696,8 @@ int ubi_io_write_vid_hdr(struct ubi_device *ubi, int pnum,
 			 struct ubi_vid_hdr *vid_hdr);
 
 /* build.c */
-int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset);
+int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
+		       int vid_hdr_offset, unsigned int max_beb_per1024);
 int ubi_detach_mtd_dev(int ubi_num, int anyway);
 struct ubi_device *ubi_get_device(int ubi_num);
 void ubi_put_device(struct ubi_device *ubi);
-- 
1.7.2.5

