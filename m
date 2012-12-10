Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2LJLAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:00:41 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:5570 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752547Ab2LJLAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:00:40 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 06:00:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAJtkv1BbdWObgWdsb2JhbABEg0e6ZBYOAQEWJieCHwEFJ1IQPxJXBgESiBTCKZB4A5YDiU2JbQ
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 04/12] ipack/devices/ipoctal: remove wait_queue and atomic_t board_write
Date: Mon, 10 Dec 2012 11:50:00 +0100
Message-Id: <1355136608-22029-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
References: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't block the TTY client when sending characters.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 241db2f..5bbcb16 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -20,7 +20,6 @@
 #include <linux/serial.h>
 #include <linux/tty_flip.h>
 #include <linux/slab.h>
-#include <linux/atomic.h>
 #include <linux/io.h>
 #include <linux/ipack.h>
 #include "ipoctal.h"
@@ -42,7 +41,6 @@ struct ipoctal_channel {
 	union scc2698_channel __iomem	*regs;
 	union scc2698_block __iomem	*block_regs;
 	unsigned int			board_id;
-	unsigned char			*board_write;
 	u8				isr_rx_rdy_mask;
 	u8				isr_tx_rdy_mask;
 };
@@ -51,7 +49,6 @@ struct ipoctal {
 	struct ipack_device		*dev;
 	unsigned int			board_id;
 	struct ipoctal_channel		channel[NR_CHANNELS];
-	unsigned char			write;
 	struct tty_driver		*tty_drv;
 	u8 __iomem			*mem8_space;
 	u8 __iomem			*int_space;
@@ -181,10 +178,8 @@ static void ipoctal_irq_tx(struct ipoctal_channel *channel)
 	channel->nb_bytes--;
 
 	if (channel->nb_bytes == 0 &&
-	    channel->board_id != IPACK1_DEVICE_ID_SBS_OCTAL_485) {
-		*channel->board_write = 1;
-		wake_up_interruptible(&channel->queue);
-	}
+	    channel->board_id != IPACK1_DEVICE_ID_SBS_OCTAL_485)
+		iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
 }
 
 static void ipoctal_irq_channel(struct ipoctal_channel *channel)
@@ -207,8 +202,7 @@ static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 		iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
 		iowrite8(CR_CMD_NEGATE_RTSN, &channel->regs->w.cr);
 		iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
-		*channel->board_write = 1;
-		wake_up_interruptible(&channel->queue);
+		iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
 	}
 
 	/* RX data */
@@ -302,7 +296,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		struct ipoctal_channel *channel = &ipoctal->channel[i];
 		channel->regs = chan_regs + i;
 		channel->block_regs = block_regs + (i >> 1);
-		channel->board_write = &ipoctal->write;
 		channel->board_id = ipoctal->board_id;
 		if (i & 1) {
 			channel->isr_tx_rdy_mask = ISR_TxRDY_B;
@@ -385,8 +378,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 
 		ipoctal_reset_stats(&channel->stats);
 		channel->nb_bytes = 0;
-		init_waitqueue_head(&channel->queue);
-
 		spin_lock_init(&channel->lock);
 		channel->pointer_read = 0;
 		channel->pointer_write = 0;
@@ -449,10 +440,6 @@ static int ipoctal_write_tty(struct tty_struct *tty,
 	 * operations
 	 */
 	iowrite8(CR_ENABLE_TX, &channel->regs->w.cr);
-	wait_event_interruptible(channel->queue, *channel->board_write);
-	iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
-
-	*channel->board_write = 0;
 	return char_copied;
 }
 
-- 
1.7.10.4

