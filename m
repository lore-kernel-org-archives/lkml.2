Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2IJGZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:25:28 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:40814
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938Ab2IJGZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:25:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1d1ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah1288h12a5h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <shmulik.ladkani@gmail.com>, <mikedunn@newsguy.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH 1/2] mtd: add helpers to set/get features for ONFI nand
Date: Mon, 10 Sep 2012 14:01:10 +0800
Message-ID: <1347256871-18339-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the set-features(0xef)/get-features(0xee) helpers for ONFI nand.
Also add the necessary macros.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/nand_base.c |   50 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/nand.h     |   14 +++++++++++
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 88f671c..fbc49cc 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2700,6 +2700,50 @@ static int nand_block_markbad(struct mtd_info *mtd, loff_t ofs)
 }
 
 /**
+ * nand_onfi_set_features- [REPLACEABLE] set features for ONFI nand
+ * @mtd: MTD device structure
+ * @chip: nand chip info structure
+ * @feature_addr: feature address.
+ * @subfeature_para: the subfeature parameters, a four bytes array.
+ */
+static int nand_onfi_set_features(struct mtd_info *mtd, struct nand_chip *chip,
+			int feature_addr, uint8_t *subfeature_para)
+{
+	int status;
+
+	if (!chip->onfi_version)
+		return -EINVAL;
+
+	chip->cmdfunc(mtd, NAND_CMD_SET_FEATURES, feature_addr, -1);
+	chip->write_buf(mtd, subfeature_para, ONFI_SUBFEATURE_PARA_LEN);
+	status = chip->waitfunc(mtd, chip);
+	if (status & NAND_STATUS_FAIL)
+		return -EIO;
+	return 0;
+}
+
+/**
+ * nand_onfi_get_features- [REPLACEABLE] get features for ONFI nand
+ * @mtd: MTD device structure
+ * @chip: nand chip info structure
+ * @feature_addr: feature address.
+ * @subfeature_para: the subfeature parameters, a four bytes array.
+ */
+static int nand_onfi_get_features(struct mtd_info *mtd, struct nand_chip *chip,
+			int feature_addr, uint8_t *subfeature_para)
+{
+	if (!chip->onfi_version)
+		return -EINVAL;
+
+	/* clear the sub feature parameters */
+	memset(subfeature_para, 0, ONFI_SUBFEATURE_PARA_LEN);
+
+	chip->cmdfunc(mtd, NAND_CMD_GET_FEATURES, feature_addr, -1);
+	chip->read_buf(mtd, subfeature_para, ONFI_SUBFEATURE_PARA_LEN);
+	return 0;
+}
+
+/**
  * nand_suspend - [MTD Interface] Suspend the NAND flash
  * @mtd: MTD device structure
  */
@@ -3223,6 +3267,12 @@ int nand_scan_tail(struct mtd_info *mtd)
 	if (!chip->write_page)
 		chip->write_page = nand_write_page;
 
+	/* set for ONFI nand */
+	if (!chip->onfi_set_features)
+		chip->onfi_set_features = nand_onfi_set_features;
+	if (!chip->onfi_get_features)
+		chip->onfi_get_features = nand_onfi_get_features;
+
 	/*
 	 * Check ECC mode, default to software if 3byte/512byte hardware ECC is
 	 * selected and we have 256 byte pagesize fallback to software ECC
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 8f99d36..641794c 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -92,6 +92,8 @@ extern int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len);
 #define NAND_CMD_READID		0x90
 #define NAND_CMD_ERASE2		0xd0
 #define NAND_CMD_PARAM		0xec
+#define NAND_CMD_GET_FEATURES	0xee
+#define NAND_CMD_SET_FEATURES	0xef
 #define NAND_CMD_RESET		0xff
 
 #define NAND_CMD_LOCK		0x2a
@@ -229,6 +231,12 @@ typedef enum {
 /* Keep gcc happy */
 struct nand_chip;
 
+/* ONFI feature address */
+#define ONFI_FEATURE_ADDR_TIMING_MODE	0x1
+
+/* ONFI subfeature parameters length */
+#define ONFI_SUBFEATURE_PARA_LEN	4
+
 struct nand_onfi_params {
 	/* rev info and features block */
 	/* 'O' 'N' 'F' 'I'  */
@@ -452,6 +460,8 @@ struct nand_buffers {
  *			non 0 if ONFI supported.
  * @onfi_params:	[INTERN] holds the ONFI page parameter when ONFI is
  *			supported, 0 otherwise.
+ * @onfi_set_features	[REPLACEABLE] set the features for ONFI nand
+ * @onfi_get_features	[REPLACEABLE] get the features for ONFI nand
  * @ecclayout:		[REPLACEABLE] the default ECC placement scheme
  * @bbt:		[INTERN] bad block table pointer
  * @bbt_td:		[REPLACEABLE] bad block table descriptor for flash
@@ -494,6 +504,10 @@ struct nand_chip {
 	int (*write_page)(struct mtd_info *mtd, struct nand_chip *chip,
 			const uint8_t *buf, int oob_required, int page,
 			int cached, int raw);
+	int (*onfi_set_features)(struct mtd_info *mtd, struct nand_chip *chip,
+			int feature_addr, uint8_t *subfeature_para);
+	int (*onfi_get_features)(struct mtd_info *mtd, struct nand_chip *chip,
+			int feature_addr, uint8_t *subfeature_para);
 
 	int chip_delay;
 	unsigned int options;
-- 
1.7.0.4


