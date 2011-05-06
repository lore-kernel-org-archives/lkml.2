Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1EFAYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:48 -0400
Received: from kroah.org ([198.145.64.141]:36738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab1EFAYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:09 2011
Message-Id: <20110506002209.443127149@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>, Divy Le Ray <divy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [043/143] cxgb3: declare MODULE_FIRMWARE
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 34336ec032878d1a32e7df881f16ce2145e53f83 upstream.

Replace run-time string formatting with preprocessor string
manipulation.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/cxgb3/common.h     |    8 +++-----
 drivers/net/cxgb3/cxgb3_main.c |   25 ++++++++++++++++---------
 2 files changed, 19 insertions(+), 14 deletions(-)

--- a/drivers/net/cxgb3/common.h
+++ b/drivers/net/cxgb3/common.h
@@ -125,11 +125,9 @@ enum {				/* adapter interrupt-maintaine
 	IRQ_NUM_STATS		/* keep last */
 };
 
-enum {
-	TP_VERSION_MAJOR	= 1,
-	TP_VERSION_MINOR	= 1,
-	TP_VERSION_MICRO	= 0
-};
+#define TP_VERSION_MAJOR	1
+#define TP_VERSION_MINOR	1
+#define TP_VERSION_MICRO	0
 
 #define S_TP_VERSION_MAJOR		16
 #define M_TP_VERSION_MAJOR		0xFF
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -44,6 +44,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/firmware.h>
 #include <linux/log2.h>
+#include <linux/stringify.h>
 #include <asm/uaccess.h>
 
 #include "common.h"
@@ -989,11 +990,21 @@ static int bind_qsets(struct adapter *ad
 	return err;
 }
 
-#define FW_FNAME "cxgb3/t3fw-%d.%d.%d.bin"
-#define TPSRAM_NAME "cxgb3/t3%c_psram-%d.%d.%d.bin"
+#define FW_VERSION __stringify(FW_VERSION_MAJOR) "."			\
+	__stringify(FW_VERSION_MINOR) "." __stringify(FW_VERSION_MICRO)
+#define FW_FNAME "cxgb3/t3fw-" FW_VERSION ".bin"
+#define TPSRAM_VERSION __stringify(TP_VERSION_MAJOR) "."		\
+	__stringify(TP_VERSION_MINOR) "." __stringify(TP_VERSION_MICRO)
+#define TPSRAM_NAME "cxgb3/t3%c_psram-" TPSRAM_VERSION ".bin"
 #define AEL2005_OPT_EDC_NAME "cxgb3/ael2005_opt_edc.bin"
 #define AEL2005_TWX_EDC_NAME "cxgb3/ael2005_twx_edc.bin"
 #define AEL2020_TWX_EDC_NAME "cxgb3/ael2020_twx_edc.bin"
+MODULE_FIRMWARE(FW_FNAME);
+MODULE_FIRMWARE("cxgb3/t3b_psram-" TPSRAM_VERSION ".bin");
+MODULE_FIRMWARE("cxgb3/t3c_psram-" TPSRAM_VERSION ".bin");
+MODULE_FIRMWARE(AEL2005_OPT_EDC_NAME);
+MODULE_FIRMWARE(AEL2005_TWX_EDC_NAME);
+MODULE_FIRMWARE(AEL2020_TWX_EDC_NAME);
 
 static inline const char *get_edc_fw_name(int edc_idx)
 {
@@ -1064,16 +1075,13 @@ int t3_get_edc_fw(struct cphy *phy, int
 static int upgrade_fw(struct adapter *adap)
 {
 	int ret;
-	char buf[64];
 	const struct firmware *fw;
 	struct device *dev = &adap->pdev->dev;
 
-	snprintf(buf, sizeof(buf), FW_FNAME, FW_VERSION_MAJOR,
-		 FW_VERSION_MINOR, FW_VERSION_MICRO);
-	ret = request_firmware(&fw, buf, dev);
+	ret = request_firmware(&fw, FW_FNAME, dev);
 	if (ret < 0) {
 		dev_err(dev, "could not upgrade firmware: unable to load %s\n",
-			buf);
+			FW_FNAME);
 		return ret;
 	}
 	ret = t3_load_fw(adap, fw->data, fw->size);
@@ -1117,8 +1125,7 @@ static int update_tpsram(struct adapter
 	if (!rev)
 		return 0;
 
-	snprintf(buf, sizeof(buf), TPSRAM_NAME, rev,
-		 TP_VERSION_MAJOR, TP_VERSION_MINOR, TP_VERSION_MICRO);
+	snprintf(buf, sizeof(buf), TPSRAM_NAME, rev);
 
 	ret = request_firmware(&tpsram, buf, dev);
 	if (ret < 0) {


