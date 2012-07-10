Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab2GJQYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:24:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47618 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab2GJQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:24:13 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space parameter
Date: Tue, 10 Jul 2012 18:23:42 +0200
Message-Id: <1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the possibility to adjust the "maximum expected number of
bad blocks per 1024 blocks" (max_beb_per1024) for each mtd device.

The majority of NAND devices have their max_beb_per1024 equal to 20, but
sometimes it's more.
Now, we can adjust that via a kernel parameter:
ubi.mtd=<name|num|path>[,<vid_hdr_offs>[,max_beb_per1024]]
and via UBI_IOCATT ioctl which is now:
struct ubi_attach_req {
	__s32 ubi_num;
	__s32 mtd_num;
	__s32 vid_hdr_offset;
	__u8 max_beb_per1024;
	__s8 padding[11];
};

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/mtd/ubi/Kconfig |   25 --------------
 drivers/mtd/ubi/build.c |   82 +++++++++++++++++++++++++++++++---------------
 drivers/mtd/ubi/cdev.c  |    9 ++++-
 drivers/mtd/ubi/ubi.h   |    6 +++-
 include/mtd/ubi-user.h  |   19 ++++++++++-
 5 files changed, 86 insertions(+), 55 deletions(-)

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index b77ffe1..7a57cc0 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -27,31 +27,6 @@ config MTD_UBI_WL_THRESHOLD
 	  life-cycle less than 10000, the threshold should be lessened (e.g.,
 	  to 128 or 256, although it does not have to be power of 2).
 
-config MTD_UBI_BEB_LIMIT
-	int "Maximum expected bad eraseblocks per 1024 eraseblocks"
-	default 20
-	range 2 256
-	help
-	  If the MTD device admits of bad eraseblocks (e.g. NAND flash), UBI
-	  reserves some amount of physical eraseblocks to handle new bad
-	  eraseblocks.
-	  This option specifies the maximum bad eraseblocks UBI expects on the
-	  ubi device per 1024 eraseblocks.
-	  This value is often given in an other form in the NAND datasheet
-	  (min NVB i.e. minimal number of valid blocks). The maximum expected
-	  bad eraseblocks per 1024 is then:
-	    1024 * (1 - MinNVB / MaxNVB)
-	  Which gives 20 for most NAND devices.
-
-	  This limit is used in order to derive amount of eraseblock UBI
-	  reserves for handling new bad blocks.
-	  If the device has more bad eraseblocks than this limit, UBI does not
-	  reserve any physical eraseblocks for new bad eraseblocks, but
-	  attempts to use available eraseblocks (if any).
-	  If the underlying flash does not admit of bad eraseblocks (e.g. NOR
-	  flash), this value is ignored.
-	  Leave the default value if unsure.
-
 config MTD_UBI_GLUEBI
 	tristate "MTD devices emulation driver (gluebi)"
 	help
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 87b39c2..76358e9 100644
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
+	int max_beb_per1024;
 };
 
 /* Numbers of elements set in the @mtd_dev_param array */
@@ -565,9 +569,37 @@ void ubi_free_internal_volumes(struct ubi_device *ubi)
 	}
 }
 
+static int get_bad_peb_limit(const struct ubi_device *ubi, int max_beb_per1024)
+{
+	int device_peb_count;
+	uint64_t device_size;
+	int beb_limit = 0;
+
+	/* this has already been checked in ioctl */
+	if (max_beb_per1024 <= 0)
+		goto out;
+
+	/* we are using here the whole MTD device size and not
+	 * the MTD partition size because the maximum number of
+	 * bad blocks is a percentage of the whole device and
+	 * the bad blocks are not fairly disposed on a flash
+	 * device
+	 */
+	device_size = mtd_get_device_size(ubi->mtd);
+	device_peb_count = mtd_div_by_eb(device_size, ubi->mtd);
+	beb_limit = mult_frac(device_peb_count, max_beb_per1024, 1024);
+	/* round it up */
+	if (mult_frac(beb_limit, 1024, max_beb_per1024) < ubi->peb_count)
+		beb_limit++;
+
+out:
+	return beb_limit;
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
+static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 {
 	if (ubi->mtd->numeraseregions != 0) {
 		/*
@@ -610,26 +642,7 @@ static int io_init(struct ubi_device *ubi)
 
 	if (mtd_can_have_bb(ubi->mtd)) {
 		ubi->bad_allowed = 1;
-		if (CONFIG_MTD_UBI_BEB_LIMIT > 0) {
-			int per1024 = CONFIG_MTD_UBI_BEB_LIMIT;
-			int device_peb_count;
-			uint64_t device_size;
-			int beb_limit;
-
-			/* we are using here the whole MTD device size and not
-			 * the MTD partition size because the maximum number of
-			 * bad blocks is a percentage of the whole device and
-			 * the bad blocks are not fairly disposed on a flash
-			 * device
-			 */
-			device_size = mtd_get_device_size(ubi->mtd);
-			device_peb_count = mtd_div_by_eb(device_size, ubi->mtd);
-			beb_limit = mult_frac(device_peb_count, per1024, 1024);
-			/* round it up */
-			if (mult_frac(beb_limit, 1024, per1024) < ubi->peb_count)
-				beb_limit++;
-			ubi->bad_peb_limit = beb_limit;
-		}
+		ubi->bad_peb_limit = get_bad_peb_limit(ubi, max_beb_per1024);
 	}
 
 	if (ubi->mtd->type == MTD_NORFLASH) {
@@ -822,6 +835,7 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
  * @mtd: MTD device description object
  * @ubi_num: number to assign to the new UBI device
  * @vid_hdr_offset: VID header offset
+ * @max_beb_per1024: maximum number of expected bad blocks per 1024 eraseblocks
  *
  * This function attaches MTD device @mtd_dev to UBI and assign @ubi_num number
  * to the newly created UBI device, unless @ubi_num is %UBI_DEV_NUM_AUTO, in
@@ -832,7 +846,8 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
  * Note, the invocations of this function has to be serialized by the
  * @ubi_devices_mutex.
  */
-int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
+int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
+		       int vid_hdr_offset, int max_beb_per1024)
 {
 	struct ubi_device *ubi;
 	int i, err, ref = 0;
@@ -905,7 +920,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	dbg_msg("sizeof(struct ubi_ainf_peb) %zu", sizeof(struct ubi_ainf_peb));
 	dbg_msg("sizeof(struct ubi_wl_entry) %zu", sizeof(struct ubi_wl_entry));
 
-	err = io_init(ubi);
+	err = io_init(ubi, max_beb_per1024);
 	if (err)
 		goto out_free;
 
@@ -1194,7 +1209,7 @@ static int __init ubi_init(void)
 
 		mutex_lock(&ubi_devices_mutex);
 		err = ubi_attach_mtd_dev(mtd, UBI_DEV_NUM_AUTO,
-					 p->vid_hdr_offs);
+					 p->vid_hdr_offs, p->max_beb_per1024);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0) {
 			ubi_err("cannot attach mtd%d", mtd->index);
@@ -1313,7 +1328,7 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 	struct mtd_dev_param *p;
 	char buf[MTD_PARAM_LEN_MAX];
 	char *pbuf = &buf[0];
-	char *tokens[2] = {NULL, NULL};
+	char *tokens[MTD_PARAM_NB_MAX];
 
 	if (!val)
 		return -EINVAL;
@@ -1343,7 +1358,7 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 	if (buf[len - 1] == '\n')
 		buf[len - 1] = '\0';
 
-	for (i = 0; i < 2; i++)
+	for (i = 0; i < MTD_PARAM_NB_MAX; i++)
 		tokens[i] = strsep(&pbuf, ",");
 
 	if (pbuf) {
@@ -1361,18 +1376,31 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 	if (p->vid_hdr_offs < 0)
 		return p->vid_hdr_offs;
 
+	if (tokens[2])
+		p->max_beb_per1024 = bytes_str_to_int(tokens[2]);
+	/* a value of 0 is force to the default value to keep the same
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
+		      "mtd=<name|num|path>[,<vid_hdr_offs>[,"
+		      "max_beb_per1024]].\n"
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
index acec85d..ed5dd75 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -1005,12 +1005,19 @@ static long ctrl_cdev_ioctl(struct file *file, unsigned int cmd,
 			break;
 		}
 
+		/* for compatibility with older user-space tools,
+		 * a zero value should be treated like a default value
+		 */
+		if (!req.max_beb_per1024)
+			req.max_beb_per1024 = MTD_UBI_DEFAULT_BEB_LIMIT;
+
 		/*
 		 * Note, further request verification is done by
 		 * 'ubi_attach_mtd_dev()'.
 		 */
 		mutex_lock(&ubi_devices_mutex);
-		err = ubi_attach_mtd_dev(mtd, req.ubi_num, req.vid_hdr_offset);
+		err = ubi_attach_mtd_dev(mtd, req.ubi_num, req.vid_hdr_offset,
+					 req.max_beb_per1024);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0)
 			put_mtd_device(mtd);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index c94612e..2148f35 100644
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
+		       int vid_hdr_offset, int max_beb_per1024);
 int ubi_detach_mtd_dev(int ubi_num, int anyway);
 struct ubi_device *ubi_get_device(int ubi_num);
 void ubi_put_device(struct ubi_device *ubi);
diff --git a/include/mtd/ubi-user.h b/include/mtd/ubi-user.h
index 8787349..77cd0d1 100644
--- a/include/mtd/ubi-user.h
+++ b/include/mtd/ubi-user.h
@@ -222,6 +222,7 @@ enum {
  * @ubi_num: UBI device number to create
  * @mtd_num: MTD device number to attach
  * @vid_hdr_offset: VID header offset (use defaults if %0)
+ * @max_beb_per1024: Maximum expected bad eraseblocks per 1024 eraseblocks
  * @padding: reserved for future, not used, has to be zeroed
  *
  * This data structure is used to specify MTD device UBI has to attach and the
@@ -245,12 +246,28 @@ enum {
  * be 2KiB-64 bytes = 1984. Note, that this position is not even 512-bytes
  * aligned, which is OK, as UBI is clever enough to realize this is 4th
  * sub-page of the first page and add needed padding.
+ *
+ * The @max_beb_per1024 is the maximum bad eraseblocks UBI expects on the ubi
+ * device per 1024 eraseblocks.
+ * This value is often given in an other form in the NAND datasheet (min NVB
+ * i.e. minimal number of valid blocks). The maximum expected bad eraseblocks
+ * per 1024 is then:
+ *   1024 * (1 - MinNVB / MaxNVB)
+ * Which gives 20 for most NAND devices.
+ * This limit is used in order to derive amount of eraseblock UBI reserves for
+ * handling new bad blocks.
+ * If the device has more bad eraseblocks than this limit, UBI does not reserve
+ * any physical eraseblocks for new bad eraseblocks, but attempts to use
+ * available eraseblocks (if any).
+ * The accepted range is 0-255. If 0 is given, the default value
+ * MTD_UBI_DEFAULT_BEB_LIMIT will be used for compatibility.
  */
 struct ubi_attach_req {
 	__s32 ubi_num;
 	__s32 mtd_num;
 	__s32 vid_hdr_offset;
-	__s8 padding[12];
+	__u8 max_beb_per1024;
+	__s8 padding[11];
 };
 
 /**
-- 
1.7.2.5

