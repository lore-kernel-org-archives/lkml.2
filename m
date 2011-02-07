Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab1BGOMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:12:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53872 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1BGOLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:11:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ocsdgYEK7LJBTXnNwwSlh3a3DRaPT9dgE0tZfkZkF98iCE5rjT5q4IM/yf7rzrux80
         OV7Z/Hd8hm/pVPrL4+wmha+X/0M+1AVjf6fFnFH9LsUm3S8JWpygnAGQZXac3o9HJKsz
         vNlVD0fwor73Q8FXOFvfkhRzo/GYphQOPxNuM=
From: Ivan Djelic <ivan.djelic@parrot.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Ivan Djelic <ivan.djelic@parrot.com>
Subject: [PATCH/RFC v2 3/3] mtd: nand: enable software BCH ECC in nand simulator
Date: Mon,  7 Feb 2011 15:09:32 +0100
Message-Id: <3b66f37e95b304381d76f06c405398f59a07ac6a.2296641159.git.ivan.djelic@parrot.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <181c9a1c88b781116615761109cccdf89ea877a1.2296641159.git.ivan.djelic@parrot.com>
References: <181c9a1c88b781116615761109cccdf89ea877a1.2296641159.git.ivan.djelic@parrot.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds option 'bch' to nandsim, which can be used to enable
software BCH ECC (introduced in previous patches) and select BCH error
correction capability.

Signed-off-by: Ivan Djelic <ivan.djelic@parrot.com>
---
v2 changelog
- do not handle small page devices

 drivers/mtd/nand/nandsim.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index a5aa99f..e4ed5d7 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -34,6 +34,7 @@
 #include <linux/string.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
+#include <linux/mtd/nand_bch.h>
 #include <linux/mtd/partitions.h>
 #include <linux/delay.h>
 #include <linux/list.h>
@@ -108,6 +109,7 @@ static unsigned int rptwear = 0;
 static unsigned int overridesize = 0;
 static char *cache_file = NULL;
 static unsigned int bbt;
+static unsigned int bch;
 
 module_param(first_id_byte,  uint, 0400);
 module_param(second_id_byte, uint, 0400);
@@ -132,6 +134,7 @@ module_param(rptwear,        uint, 0400);
 module_param(overridesize,   uint, 0400);
 module_param(cache_file,     charp, 0400);
 module_param(bbt,	     uint, 0400);
+module_param(bch,	     uint, 0400);
 
 MODULE_PARM_DESC(first_id_byte,  "The first byte returned by NAND Flash 'read ID' command (manufacturer ID)");
 MODULE_PARM_DESC(second_id_byte, "The second byte returned by NAND Flash 'read ID' command (chip ID)");
@@ -165,6 +168,7 @@ MODULE_PARM_DESC(overridesize,   "Specifies the NAND Flash size overriding the I
 				 " e.g. 5 means a size of 32 erase blocks");
 MODULE_PARM_DESC(cache_file,     "File to use to cache nand pages instead of memory");
 MODULE_PARM_DESC(bbt,		 "0 OOB, 1 BBT with marker in OOB, 2 BBT with marker in data area");
+MODULE_PARM_DESC(bch,		 "Enable BCH ecc and set how many bits should be correctable in 512-byte blocks");
 
 /* The largest possible page size */
 #define NS_LARGEST_PAGE_SIZE	4096
@@ -2309,7 +2313,41 @@ static int __init ns_init_module(void)
 	if ((retval = parse_gravepages()) != 0)
 		goto error;
 
-	if ((retval = nand_scan(nsmtd, 1)) != 0) {
+	if ((retval = nand_scan_ident(nsmtd, 1, NULL)) != 0) {
+		NS_ERR("cannot scan NAND Simulator device\n");
+		if (retval > 0)
+			retval = -ENXIO;
+		goto error;
+	}
+
+	if (bch) {
+		unsigned int eccsteps, eccbytes;
+		if (!mtd_nand_has_bch()) {
+			NS_ERR("BCH ECC support is disabled\n");
+			retval = -EINVAL;
+			goto error;
+		}
+		/* use 512-byte ecc blocks */
+		eccsteps = nsmtd->writesize/512;
+		eccbytes = (bch*13+7)/8;
+		/* do not bother supporting small page devices */
+		if ((nsmtd->oobsize < 64) || !eccsteps) {
+			NS_ERR("bch not available on small page devices\n");
+			retval = -EINVAL;
+			goto error;
+		}
+		if ((eccbytes*eccsteps+2) > nsmtd->oobsize) {
+			NS_ERR("invalid bch value %u\n", bch);
+			retval = -EINVAL;
+			goto error;
+		}
+		chip->ecc.mode = NAND_ECC_SOFT_BCH;
+		chip->ecc.size = 512;
+		chip->ecc.bytes = eccbytes;
+		NS_INFO("using %u-bit/%u bytes BCH ECC\n", bch, chip->ecc.size);
+	}
+
+	if ((retval = nand_scan_tail(nsmtd)) != 0) {
 		NS_ERR("can't register NAND Simulator\n");
 		if (retval > 0)
 			retval = -ENXIO;
-- 
1.7.2.3

