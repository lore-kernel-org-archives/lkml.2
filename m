Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498Ab2FHPlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:41:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39759 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761323Ab2FHPle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:41:34 -0400
Date: Fri, 8 Jun 2012 18:41:26 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Mike Dunn <mikedunn@newsguy.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Ivan Djelic <ivan.djelic@parrot.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: nand: Properly initialize 'mtd->bitflip_threshold'
 prior 'scan_bbt()' is invoked
Message-ID: <20120608184126.6dce8977@halley>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of edbc454 [mtd: driver _read() returns max_bitflips; mtd_read()
returns -EUCLEAN], 'mtd->bitflip_threshold' must be set for mtd devices
having ECC, prior any 'mtd_read()' call.
Otherwise, 'mtd_read()' will falsely return -EUCLEAN.

Normally, 'mtd->bitflip_threshold' is initialized when the MTD is added.

However, this is too late for NAND MTDs, as 'scan_bbt()' is invoked
prior the existing initialization of 'mtd->bitflip_threshold'.

This is a problem since 'scan_bbt()' calls 'mtd_read()', in the case
of a flash-based bad block table.
It resulted in a falsely reported bitflips indication during BBT read,
which lead to constant scrubbing of the flash BBT blocks.

Initialize 'mtd->bitflip_threshold' to its default value (if not already
set by the driver), prior invocation of 'scan_bbt()'.

Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
- The issue was introduced in v3.5-rc1, and needs to be merged prior v3.5
- Sascha, I've credited you as reporter, is that ok with you?
- Sashca, care to test the fix on your system?

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 61805e7..0a8724e 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3484,6 +3484,13 @@ int nand_scan_tail(struct mtd_info *mtd)
 	/* propagate ecc info to mtd_info */
 	mtd->ecclayout = chip->ecc.layout;
 	mtd->ecc_strength = chip->ecc.strength;
+	/*
+	 * Initialize bitflip_threshold to its default prior scan_bbt() call.
+	 * scan_bbt() might invoke mtd_read(), thus bitflip_threshold must be
+	 * properly set.
+	 */
+	if (!mtd->bitflip_threshold)
+		mtd->bitflip_threshold = mtd->ecc_strength;
 
 	/* Check, if we should skip the bad block table scan */
 	if (chip->options & NAND_SKIP_BBTSCAN)
-- 
1.7.5.4
