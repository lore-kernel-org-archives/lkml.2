Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1CKKGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 05:06:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42511 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1CKKFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 05:05:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=MpFkR1r5zWGd0wKlO8CD50uGZzkWF5AyaArBdK1FmFZfGJOQbQgcUoWYrFcDuZebxC
         FkQCGlus2Uc+ZBQtNJMU7XM8Ghf7v3ZFjDNQbBs+ycky43wqkfZQRUZBJ1ZytOSbzg/O
         YKT3V6gVXoocQCNhv+9qFjYpOPrzVCn47oM2k=
From: Ivan Djelic <ivan.djelic@parrot.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ivan Djelic <ivan.djelic@parrot.com>
Subject: [PATCH/RFC v4 3/3] mtd: nand: enable software BCH ECC in nand simulator
Date: Fri, 11 Mar 2011 11:05:34 +0100
Message-Id: <6ff44a54b0f9b27ce91a82d1c6a172eff6a5e2ec.1299836869.git.ivan.djelic@parrot.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1fb708d8d49cdd83e62424fb77912418f5c92d69.1299836869.git.ivan.djelic@parrot.com>
References: <1fb708d8d49cdd83e62424fb77912418f5c92d69.1299836869.git.ivan.djelic@parrot.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds option 'bch' to nandsim, which can be used to enable
software BCH ECC (introduced in previous patches) and select BCH error
correction capability.

Signed-off-by: Ivan Djelic <ivan.djelic@parrot.com>
---
v4 changelog:
- coding style fixes
v3 changelog:
  No change.
v2 changelog
- do not handle small page devices

 drivers/mtd/nand/nandsim.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index a5aa99f..213181b 100644
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
@@ -165,6 +168,8 @@ MODULE_PARM_DESC(overridesize,   "Specifies the NAND Flash size overriding the I
 				 " e.g. 5 means a size of 32 erase blocks");
 MODULE_PARM_DESC(cache_file,     "File to use to cache nand pages instead of memory");
 MODULE_PARM_DESC(bbt,		 "0 OOB, 1 BBT with marker in OOB, 2 BBT with marker in data area");
+MODULE_PARM_DESC(bch,		 "Enable BCH ecc and set how many bits should "
+				 "be correctable in 512-byte blocks");
 
 /* The largest possible page size */
 #define NS_LARGEST_PAGE_SIZE	4096
@@ -2309,7 +2314,43 @@ static int __init ns_init_module(void)
 	if ((retval = parse_gravepages()) != 0)
 		goto error;
 
-	if ((retval = nand_scan(nsmtd, 1)) != 0) {
+	retval = nand_scan_ident(nsmtd, 1, NULL);
+	if (retval) {
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
+	retval = nand_scan_tail(nsmtd);
+	if (retval) {
 		NS_ERR("can't register NAND Simulator\n");
 		if (retval > 0)
 			retval = -ENXIO;
-- 
1.7.2.3

