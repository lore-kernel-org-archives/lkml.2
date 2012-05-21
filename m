Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2EUNFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:05:23 -0400
Received: from araneidae.co.uk ([81.187.94.2]:50561 "EHLO
	venus.araneidae.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab2EUNFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:05:22 -0400
X-Greylist: delayed 1044 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2012 09:05:21 EDT
Date: Mon, 21 May 2012 13:47:53 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Ben Dooks <ben-linux@fluff.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Implement full reset of DM9000 network device
Message-ID: <alpine.DEB.2.00.1205211344010.26839@venus.araneidae.co.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Davicom application note for the DM9000 network device recommends
performing software reset twice to correctly initialise the device.
Without this reset some devices fail to initialise correctly on
system startup.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
---
 drivers/net/ethernet/davicom/dm9000.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 2a22f52..57d074c 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -156,17 +156,6 @@ static inline board_info_t *to_dm9000_board(struct net_device *dev)
 
 /* DM9000 network board routine ---------------------------- */
 
-static void
-dm9000_reset(board_info_t * db)
-{
-	dev_dbg(db->dev, "resetting device\n");
-
-	/* RESET device */
-	writeb(DM9000_NCR, db->io_addr);
-	udelay(200);
-	writeb(NCR_RST, db->io_data);
-	udelay(200);
-}
 
 /*
  *   Read a byte from I/O port
@@ -189,6 +178,27 @@ iow(board_info_t * db, int reg, int value)
 	writeb(value, db->io_data);
 }
 
+
+static void
+dm9000_reset(board_info_t *db)
+{
+	dev_dbg(db->dev, "resetting device\n");
+
+	/* Reset DM9000, see DM9000 Application Notes V1.22 Jun 11, 2004 page 29
+	 * The essential point is that we have to do a double reset, and the
+	 * instruction is to set LBK into MAC internal loopback mode. */
+	iow(db, DM9000_NCR, 0x03);
+	udelay(100);        /* Application note says at least 20 us */
+	if (ior(db, DM9000_NCR) & 1)
+		dev_err(db->dev, "dm9000 did not respond to first reset\n");
+
+	iow(db, DM9000_NCR, 0);
+	iow(db, DM9000_NCR, 0x03);
+	udelay(100);
+	if (ior(db, DM9000_NCR) & 1)
+		dev_err(db->dev, "dm9000 did not respond to second reset\n");
+}
+
 /* routines for sending block to chip */
 
 static void dm9000_outblk_8bit(void __iomem *reg, void *data, int count)
-- 
1.6.6.1


