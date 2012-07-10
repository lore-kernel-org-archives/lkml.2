Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab2GJQYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:24:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50372 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab2GJQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:24:14 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] ubiattach: introduce max_beb_per1024 in UBI_IOCATT
Date: Tue, 10 Jul 2012 18:23:43 +0200
Message-Id: <1341937423-16516-6-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctl UBI_IOCATT has been extended with max_beb_per1024 parameter.

This parameter is used for adjusting the "maximum expected number of
bad blocks per 1024 blocks" for each mtd device.
The number of physical erase blocks (PEB) that UBI will reserve for bad
block handling is now:
whole_flash_chipset__PEB_number * max_beb_per1024 / 1024

This means that for a 4096 PEB NAND device with 3 MTD partitions:
mtd0: 512 PEB
mtd1: 1536 PEB
mtd2: 2048 PEB

the commands:
ubiattach -m 0 -d 0 -b 20 /dev/ubi_ctrl
ubiattach -m 1 -d 1 -b 20 /dev/ubi_ctrl
ubiattach -m 2 -d 2 -b 20 /dev/ubi_ctrl
will attach mtdx to UBIx and reserve:
80 PEB for bad block handling on UBI0
80 PEB for bad block handling on UBI1
80 PEB for bad block handling on UBI2

=> for the whole device, 240 PEB will be reserved for bad block
handling.

This may seems a waste of space, but as far as the bad blocks can appear
every where on a flash device, in the worst case scenario they can
all appear in one MTD partition.
So the maximum number of expected erase blocks given by the NAND
manufacturer should be reserve on each MTD partition.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 include/mtd/ubi-user.h             |   20 ++++++++++++++++-
 tests/fs-tests/integrity/integck.c |    1 +
 ubi-utils/include/libubi.h         |    2 +
 ubi-utils/libubi.c                 |    2 +
 ubi-utils/ubiattach.c              |   41 +++++++++++++++++++++++++++++-------
 5 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/include/mtd/ubi-user.h b/include/mtd/ubi-user.h
index 296efae..5f77906 100644
--- a/include/mtd/ubi-user.h
+++ b/include/mtd/ubi-user.h
@@ -235,6 +235,7 @@ enum {
  * @ubi_num: UBI device number to create
  * @mtd_num: MTD device number to attach
  * @vid_hdr_offset: VID header offset (use defaults if %0)
+ * @max_beb_per1024: Maximum expected bad eraseblocks per 1024 eraseblocks
  * @padding: reserved for future, not used, has to be zeroed
  *
  * This data structure is used to specify MTD device UBI has to attach and the
@@ -258,12 +259,29 @@ enum {
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
+ * The accepted range is 0-255. If 0 is given, the default kernel value
+ * MTD_UBI_DEFAULT_BEB_LIMIT will be used for compatibility with previous
+ * versions.
  */
 struct ubi_attach_req {
 	int32_t ubi_num;
 	int32_t mtd_num;
 	int32_t vid_hdr_offset;
-	int8_t padding[12];
+	int8_t max_beb_per1024;
+	int8_t padding[11];
 };
 
 /**
diff --git a/tests/fs-tests/integrity/integck.c b/tests/fs-tests/integrity/integck.c
index 30322cd..f12dfac 100644
--- a/tests/fs-tests/integrity/integck.c
+++ b/tests/fs-tests/integrity/integck.c
@@ -3152,6 +3152,7 @@ static int reattach(void)
 	req.mtd_num = args.mtdn;
 	req.vid_hdr_offset = 0;
 	req.mtd_dev_node = NULL;
+	req.max_beb_per1024 = 0;
 
 	err = ubi_attach(libubi, "/dev/ubi_ctrl", &req);
 	if (err)
diff --git a/ubi-utils/include/libubi.h b/ubi-utils/include/libubi.h
index dc03d02..1eadff8 100644
--- a/ubi-utils/include/libubi.h
+++ b/ubi-utils/include/libubi.h
@@ -50,6 +50,7 @@ typedef void * libubi_t;
  * @mtd_dev_node: path to MTD device node to attach
  * @vid_hdr_offset: VID header offset (%0 means default offset and this is what
  *                  most of the users want)
+ * @max_beb_per1024: Maximum expected bad eraseblocks per 1024 eraseblocks
  */
 struct ubi_attach_request
 {
@@ -57,6 +58,7 @@ struct ubi_attach_request
 	int mtd_num;
 	const char *mtd_dev_node;
 	int vid_hdr_offset;
+	unsigned char max_beb_per1024;
 };
 
 /**
diff --git a/ubi-utils/libubi.c b/ubi-utils/libubi.c
index c898e36..d3c333d 100644
--- a/ubi-utils/libubi.c
+++ b/ubi-utils/libubi.c
@@ -719,6 +719,7 @@ int ubi_attach_mtd(libubi_t desc, const char *node,
 	r.ubi_num = req->dev_num;
 	r.mtd_num = req->mtd_num;
 	r.vid_hdr_offset = req->vid_hdr_offset;
+	r.max_beb_per1024 = req->max_beb_per1024;
 
 	ret = do_attach(node, &r);
 	if (ret == 0)
@@ -780,6 +781,7 @@ int ubi_attach(libubi_t desc, const char *node, struct ubi_attach_request *req)
 	memset(&r, 0, sizeof(struct ubi_attach_req));
 	r.ubi_num = req->dev_num;
 	r.vid_hdr_offset = req->vid_hdr_offset;
+	r.max_beb_per1024 = req->max_beb_per1024;
 
 	/*
 	 * User has passed path to device node. Lets find out MTD device number
diff --git a/ubi-utils/ubiattach.c b/ubi-utils/ubiattach.c
index 27e7c09..2026c2e 100644
--- a/ubi-utils/ubiattach.c
+++ b/ubi-utils/ubiattach.c
@@ -42,6 +42,7 @@ struct args {
 	int vidoffs;
 	const char *node;
 	const char *dev;
+	int max_beb_per1024;
 };
 
 static struct args args = {
@@ -50,6 +51,7 @@ static struct args args = {
 	.vidoffs = 0,
 	.node = NULL,
 	.dev = NULL,
+	.max_beb_per1024 = 0,
 };
 
 static const char doc[] = PROGRAM_NAME " version " VERSION
@@ -63,6 +65,9 @@ static const char optionsstr[] =
 "                      if the character device node does not exist)\n"
 "-O, --vid-hdr-offset  VID header offset (do not specify this unless you really\n"
 "                      know what you are doing, the default should be optimal)\n"
+"-b, --max-beb-per1024 Maximum expected bad block number per 1024 eraseblock.\n"
+"                      The default value is correct for most NAND devices.\n"
+"                      (Range 1-255, 0 for default kernel value).\n"
 "-h, --help            print help message\n"
 "-V, --version         print program version";
 
@@ -71,19 +76,25 @@ static const char usage[] =
 "\t[-m <MTD device number>] [-d <UBI device number>] [-p <path to device>]\n"
 "\t[--mtdn=<MTD device number>] [--devn=<UBI device number>]\n"
 "\t[--dev-path=<path to device>]\n"
+"\t[--max-beb-per1024=<maximum bad block number per 1024 blocks>]\n"
 "UBI control device defaults to " DEFAULT_CTRL_DEV " if not supplied.\n"
 "Example 1: " PROGRAM_NAME " -p /dev/mtd0 - attach /dev/mtd0 to UBI\n"
 "Example 2: " PROGRAM_NAME " -m 0 - attach MTD device 0 (mtd0) to UBI\n"
 "Example 3: " PROGRAM_NAME " -m 0 -d 3 - attach MTD device 0 (mtd0) to UBI\n"
-"           and create UBI device number 3 (ubi3)";
+"           and create UBI device number 3 (ubi3)\n"
+"Example 4: " PROGRAM_NAME " -m 1 -b 25 - attach /dev/mtd1 to UBI and reserve \n"
+"           25*nand_size_in_blocks/1024 erase blocks for bad block handling.\n"
+"           (e.g. if the NAND *chipset* has 4096 PEB, 100 will be reserved \n"
+"           for this UBI device).";
 
 static const struct option long_options[] = {
-	{ .name = "devn",           .has_arg = 1, .flag = NULL, .val = 'd' },
-	{ .name = "dev-path",       .has_arg = 1, .flag = NULL, .val = 'p' },
-	{ .name = "mtdn",           .has_arg = 1, .flag = NULL, .val = 'm' },
-	{ .name = "vid-hdr-offset", .has_arg = 1, .flag = NULL, .val = 'O' },
-	{ .name = "help",           .has_arg = 0, .flag = NULL, .val = 'h' },
-	{ .name = "version",        .has_arg = 0, .flag = NULL, .val = 'V' },
+	{ .name = "devn",            .has_arg = 1, .flag = NULL, .val = 'd' },
+	{ .name = "dev-path",        .has_arg = 1, .flag = NULL, .val = 'p' },
+	{ .name = "mtdn",            .has_arg = 1, .flag = NULL, .val = 'm' },
+	{ .name = "vid-hdr-offset",  .has_arg = 1, .flag = NULL, .val = 'O' },
+	{ .name = "help",            .has_arg = 0, .flag = NULL, .val = 'h' },
+	{ .name = "version",         .has_arg = 0, .flag = NULL, .val = 'V' },
+	{ .name = "max-beb-per1024", .has_arg = 1, .flag = NULL, .val = 'b' },
 	{ NULL, 0, NULL, 0},
 };
 
@@ -92,7 +103,7 @@ static int parse_opt(int argc, char * const argv[])
 	while (1) {
 		int key, error = 0;
 
-		key = getopt_long(argc, argv, "p:m:d:O:hV", long_options, NULL);
+		key = getopt_long(argc, argv, "p:m:d:O:hVb:", long_options, NULL);
 		if (key == -1)
 			break;
 
@@ -134,6 +145,19 @@ static int parse_opt(int argc, char * const argv[])
 		case ':':
 			return errmsg("parameter is missing");
 
+		case 'b':
+			args.max_beb_per1024 = simple_strtoul(optarg, &error);
+			if (error || args.max_beb_per1024 < 0
+			    || args.max_beb_per1024 > 255)
+				return errmsg("bad maximum of expected bad "
+					      "blocks (0-255): \"%s\"",
+					      optarg);
+			if (args.max_beb_per1024 == 0)
+				warnmsg("default kernel value will be used for"
+					" maximum expected bad blocks\n");
+
+			break;
+
 		default:
 			fprintf(stderr, "Use -h for help\n");
 			return -1;
@@ -190,6 +214,7 @@ int main(int argc, char * const argv[])
 	req.mtd_num = args.mtdn;
 	req.vid_hdr_offset = args.vidoffs;
 	req.mtd_dev_node = args.dev;
+	req.max_beb_per1024 = args.max_beb_per1024;
 
 	err = ubi_attach(libubi, args.node, &req);
 	if (err) {
-- 
1.7.2.5

