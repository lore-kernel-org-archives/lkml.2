Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab1EFAYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:46 -0400
Received: from kroah.org ([198.145.64.141]:36734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab1EFAYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:09 2011
Message-Id: <20110506002209.347825322@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [042/143] bnx2x: declare MODULE_FIRMWARE
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 45229b420f90bb6736dfeb7e491eb46cb02a3e9c upstream.

Replace run-time string formatting with preprocessor string
manipulation.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/bnx2x_main.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/drivers/net/bnx2x_main.c
+++ b/drivers/net/bnx2x_main.c
@@ -49,6 +49,7 @@
 #include <linux/prefetch.h>
 #include <linux/zlib.h>
 #include <linux/io.h>
+#include <linux/stringify.h>
 
 
 #include "bnx2x.h"
@@ -63,8 +64,13 @@
 #include <linux/firmware.h>
 #include "bnx2x_fw_file_hdr.h"
 /* FW files */
-#define FW_FILE_PREFIX_E1	"bnx2x-e1-"
-#define FW_FILE_PREFIX_E1H	"bnx2x-e1h-"
+#define FW_FILE_VERSION					\
+	__stringify(BCM_5710_FW_MAJOR_VERSION) "."	\
+	__stringify(BCM_5710_FW_MINOR_VERSION) "."	\
+	__stringify(BCM_5710_FW_REVISION_VERSION) "."	\
+	__stringify(BCM_5710_FW_ENGINEERING_VERSION)
+#define FW_FILE_NAME_E1		"bnx2x-e1-" FW_FILE_VERSION ".fw"
+#define FW_FILE_NAME_E1H	"bnx2x-e1h-" FW_FILE_VERSION ".fw"
 
 /* Time in jiffies before concluding the transmitter is hung */
 #define TX_TIMEOUT		(5*HZ)
@@ -77,6 +83,8 @@ MODULE_AUTHOR("Eliezer Tamir");
 MODULE_DESCRIPTION("Broadcom NetXtreme II BCM57710/57711/57711E Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
+MODULE_FIRMWARE(FW_FILE_NAME_E1);
+MODULE_FIRMWARE(FW_FILE_NAME_E1H);
 
 static int multi_mode = 1;
 module_param(multi_mode, int, 0);
@@ -11830,21 +11838,14 @@ static inline void be16_to_cpu_n(const u
 
 static int __devinit bnx2x_init_firmware(struct bnx2x *bp, struct device *dev)
 {
-	char fw_file_name[40] = {0};
+	const char *fw_file_name;
 	struct bnx2x_fw_file_hdr *fw_hdr;
-	int rc, offset;
+	int rc;
 
-	/* Create a FW file name */
 	if (CHIP_IS_E1(bp))
-		offset = sprintf(fw_file_name, FW_FILE_PREFIX_E1);
+		fw_file_name = FW_FILE_NAME_E1;
 	else
-		offset = sprintf(fw_file_name, FW_FILE_PREFIX_E1H);
-
-	sprintf(fw_file_name + offset, "%d.%d.%d.%d.fw",
-		BCM_5710_FW_MAJOR_VERSION,
-		BCM_5710_FW_MINOR_VERSION,
-		BCM_5710_FW_REVISION_VERSION,
-		BCM_5710_FW_ENGINEERING_VERSION);
+		fw_file_name = FW_FILE_NAME_E1H;
 
 	printk(KERN_INFO PFX "Loading %s\n", fw_file_name);
 


