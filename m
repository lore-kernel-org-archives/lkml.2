Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2KELiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:38:54 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46010 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2KELiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:38:51 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/2] staging/media: Use dev_ printks in go7007/go7007-fw.c
Date: Mon,  5 Nov 2012 20:38:46 +0900
Message-Id: <1352115526-8287-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/go7007-fw.c |   42 ++++++++++++++----------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-fw.c b/drivers/staging/media/go7007/go7007-fw.c
index c9a6409..f99c05b 100644
--- a/drivers/staging/media/go7007/go7007-fw.c
+++ b/drivers/staging/media/go7007/go7007-fw.c
@@ -382,8 +382,8 @@ static int gen_mjpeghdr_to_package(struct go7007 *go, __le16 *code, int space)
 
 	buf = kzalloc(4096, GFP_KERNEL);
 	if (buf == NULL) {
-		printk(KERN_ERR "go7007: unable to allocate 4096 bytes for "
-				"firmware construction\n");
+		dev_err(go->dev,
+			"unable to allocate 4096 bytes for firmware construction\n");
 		return -1;
 	}
 
@@ -652,8 +652,8 @@ static int gen_mpeg1hdr_to_package(struct go7007 *go,
 
 	buf = kzalloc(5120, GFP_KERNEL);
 	if (buf == NULL) {
-		printk(KERN_ERR "go7007: unable to allocate 5120 bytes for "
-				"firmware construction\n");
+		dev_err(go->dev,
+			"unable to allocate 5120 bytes for firmware construction\n");
 		return -1;
 	}
 	framelen[0] = mpeg1_frame_header(go, buf, 0, 1, PFRAME);
@@ -839,8 +839,8 @@ static int gen_mpeg4hdr_to_package(struct go7007 *go,
 
 	buf = kzalloc(5120, GFP_KERNEL);
 	if (buf == NULL) {
-		printk(KERN_ERR "go7007: unable to allocate 5120 bytes for "
-				"firmware construction\n");
+		dev_err(go->dev,
+			"unable to allocate 5120 bytes for firmware construction\n");
 		return -1;
 	}
 	framelen[0] = mpeg4_frame_header(go, buf, 0, PFRAME);
@@ -1545,9 +1545,8 @@ static int do_special(struct go7007 *go, u16 type, __le16 *code, int space,
 	case SPECIAL_MODET:
 		return modet_to_package(go, code, space);
 	}
-	printk(KERN_ERR
-		"go7007: firmware file contains unsupported feature %04x\n",
-		type);
+	dev_err(go->dev,
+		"firmware file contains unsupported feature %04x\n", type);
 	return -1;
 }
 
@@ -1577,15 +1576,16 @@ int go7007_construct_fw_image(struct go7007 *go, u8 **fw, int *fwlen)
 		return -1;
 	}
 	if (request_firmware(&fw_entry, go->board_info->firmware, go->dev)) {
-		printk(KERN_ERR
-			"go7007: unable to load firmware from file \"%s\"\n",
+		dev_err(go->dev,
+			"unable to load firmware from file \"%s\"\n",
 			go->board_info->firmware);
 		return -1;
 	}
 	code = kzalloc(codespace * 2, GFP_KERNEL);
 	if (code == NULL) {
-		printk(KERN_ERR "go7007: unable to allocate %d bytes for "
-				"firmware construction\n", codespace * 2);
+		dev_err(go->dev,
+			"unable to allocate %d bytes for firmware construction\n",
+			codespace * 2);
 		goto fw_failed;
 	}
 	src = (__le16 *)fw_entry->data;
@@ -1594,9 +1594,9 @@ int go7007_construct_fw_image(struct go7007 *go, u8 **fw, int *fwlen)
 		chunk_flags = __le16_to_cpu(src[0]);
 		chunk_len = __le16_to_cpu(src[1]);
 		if (chunk_len + 2 > srclen) {
-			printk(KERN_ERR "go7007: firmware file \"%s\" "
-					"appears to be corrupted\n",
-					go->board_info->firmware);
+			dev_err(go->dev,
+				"firmware file \"%s\" appears to be corrupted\n",
+				go->board_info->firmware);
 			goto fw_failed;
 		}
 		if (chunk_flags & mode_flag) {
@@ -1604,17 +1604,15 @@ int go7007_construct_fw_image(struct go7007 *go, u8 **fw, int *fwlen)
 				ret = do_special(go, __le16_to_cpu(src[2]),
 					&code[i], codespace - i, framelen);
 				if (ret < 0) {
-					printk(KERN_ERR "go7007: insufficient "
-							"memory for firmware "
-							"construction\n");
+					dev_err(go->dev,
+						"insufficient memory for firmware construction\n");
 					goto fw_failed;
 				}
 				i += ret;
 			} else {
 				if (codespace - i < chunk_len) {
-					printk(KERN_ERR "go7007: insufficient "
-							"memory for firmware "
-							"construction\n");
+					dev_err(go->dev,
+						"insufficient memory for firmware construction\n");
 					goto fw_failed;
 				}
 				memcpy(&code[i], &src[2], chunk_len * 2);
-- 
1.7.9.5

