Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab2FGETZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:19:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59627 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab2FGETS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:19:18 -0400
Message-Id: <20120607040343.012541720@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:22 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sascha Hauer <s.hauer@pengutronix.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 46/82] mtd: mxc_nand: move ecc strengh setup before nand_scan_tail
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 4a43faf54e9173b6acce37cf7f053fc9515a2cdf upstream.

Since commit 6a918bade9dab40aaef80559bd1169c69e8d69cb, the mxc_nand driver
fails with:

Driver must set ecc.strength when using hardware ECC

This is because nand_scan_tail checks for correct ecc strength
settings, so we must set them up before nand_scan_tail.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/mxc_nand.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -1219,12 +1219,6 @@ static int __init mxcnd_probe(struct pla
 	if (nfc_is_v21() && mtd->writesize == 4096)
 		this->ecc.layout = &nandv2_hw_eccoob_4k;
 
-	/* second phase scan */
-	if (nand_scan_tail(mtd)) {
-		err = -ENXIO;
-		goto escan;
-	}
-
 	if (this->ecc.mode == NAND_ECC_HW) {
 		if (nfc_is_v1())
 			this->ecc.strength = 1;
@@ -1232,6 +1226,12 @@ static int __init mxcnd_probe(struct pla
 			this->ecc.strength = (host->eccsize == 4) ? 4 : 8;
 	}
 
+	/* second phase scan */
+	if (nand_scan_tail(mtd)) {
+		err = -ENXIO;
+		goto escan;
+	}
+
 	/* Register the partitions */
 	mtd_device_parse_register(mtd, part_probes, NULL, pdata->parts,
 				  pdata->nr_parts);


