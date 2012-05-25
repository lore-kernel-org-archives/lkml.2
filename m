Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2EYRAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:00:21 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:52217 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2EYRAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:00:19 -0400
From: Chris Boot <bootc@bootc.net>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>
Subject: [PATCH] mmc: avoid multiblock reads for the last sector in SPI mode
Date: Fri, 25 May 2012 18:00:03 +0100
Message-Id: <1337965203-4211-1-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to get a Micro-SD card working over SPI today when I ran
into an issue which made the card unusable. The card was probed
correctly, and the msdos partition table was read, but then some command
was sent that made the card go into a bad state and stay that way. Only
a re-probe would get the card unstuck and only until just after the
partition tables were read.

After some digging I ran into a post [1] on the spi-devel-general mailing
list where someone had exactly the same issue as me, but back in 2007.
There was a patch attached which, after some cleanup, fixes the issue
completely for me.

I have tried this with 3 different Micro-SD cards, all of which suffered
from the problem before the patch and none of which fail after the
patch.

The error shows up as lots of:
mmcblk0: error -38 sending status comand, retrying
mmcblk0: error -38 sending status comand, retrying
mmcblk0: error -38 sending status comand, aborting

   1 : http://permalink.gmane.org/gmane.linux.kernel.spi.devel/516

Signed-off-by: Chris Boot <bootc@bootc.net>
---
 drivers/mmc/card/block.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index dabec55..8c5ff06 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1139,6 +1139,16 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 
 	if (brq->data.blocks > 1) {
 		/*
+		 * Some SD cards in SPI mode return a CRC error or even lock up
+		 * completely when trying to read the last block using a
+		 * multiblock read command.
+		 */
+		if (mmc_host_is_spi(card->host) && (rq_data_dir(req) == READ) &&
+				(blk_rq_pos(req) + blk_rq_sectors(req) ==
+					get_capacity(md->disk)))
+			brq->data.blocks--;
+
+		/*
 		 * After a read error, we redo the request one sector
 		 * at a time in order to accurately determine which
 		 * sectors can be read successfully.
-- 
1.7.10

