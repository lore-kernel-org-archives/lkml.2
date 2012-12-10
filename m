Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2LJLAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:00:49 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:5570 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754607Ab2LJLAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:00:47 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 06:00:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAJtkv1BbdWObgWdsb2JhbABEg0e6ZBYOAQEWJieCHwEFJ1IQPxJXBgESiBTCKZB4A5YDkzo
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 06/12] ipack/devices/ipoctal: rework disable TX when the TX buffer is empty
Date: Mon, 10 Dec 2012 11:50:02 +0100
Message-Id: <1355136608-22029-6-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
References: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending of the device, it disables the TX mode in different places when there
is no more data to transmit.

This patch reorder them and disable the TX mode in the same place.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 88aca90..96467bb 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -177,10 +177,6 @@ static void ipoctal_irq_tx(struct ipoctal_channel *channel)
 	(*pointer_write)++;
 	*pointer_write = *pointer_write % PAGE_SIZE;
 	channel->nb_bytes--;
-
-	if (channel->nb_bytes == 0 &&
-	    channel->board_id != IPACK1_DEVICE_ID_SBS_OCTAL_485)
-		iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
 }
 
 static void ipoctal_irq_channel(struct ipoctal_channel *channel)
@@ -196,14 +192,14 @@ static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 	isr = ioread8(&channel->block_regs->r.isr);
 	sr = ioread8(&channel->regs->r.sr);
 
-	/* In case of RS-485, change from TX to RX when finishing TX.
-	 * Half-duplex. */
-	if ((channel->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) &&
-	    (sr & SR_TX_EMPTY) && (channel->nb_bytes == 0)) {
-		iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
-		iowrite8(CR_CMD_NEGATE_RTSN, &channel->regs->w.cr);
-		iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
+	if ((sr & SR_TX_EMPTY) && (channel->nb_bytes == 0)) {
 		iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
+		/* In case of RS-485, change from TX to RX when finishing TX.
+		 * Half-duplex. */
+		if (channel->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) {
+			iowrite8(CR_CMD_NEGATE_RTSN, &channel->regs->w.cr);
+			iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
+		}
 	}
 
 	/* RX data */
-- 
1.7.10.4

