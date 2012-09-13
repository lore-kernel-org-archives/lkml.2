Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2IMJpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:45:22 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:43062 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2IMJpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:45:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkCAL6qUVBbdWObgWdsb2JhbABFu3AiAQEWJieCIQEFJ1IQUVcGE4gRvBqRRwOVX4kziVQ
X-IronPort-AV: E=Sophos;i="4.80,416,1344204000"; 
   d="scan'208";a="1043297973"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 5/5] Staging: ipack/devices/ipoctal: simplify ipoctal_write_tty()
Date: Thu, 13 Sep 2012 11:46:28 +0200
Message-Id: <1347529588-21212-5-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347529588-21212-1-git-send-email-siglesias@igalia.com>
References: <1347529588-21212-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove count_wr and the assigment of nb_bytes = 0 in that function as is
useless. Now it returns the count of the characters actually sent.

There is other nb_bytes = 0 deleted that has a duplicate a few lines before.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 5f4545a..150fc75 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -33,7 +33,6 @@ static const struct tty_operations ipoctal_fops;
 struct ipoctal_channel {
 	struct ipoctal_stats		stats;
 	unsigned int			nb_bytes;
-	unsigned int			count_wr;
 	wait_queue_head_t		queue;
 	spinlock_t			lock;
 	unsigned int			pointer_read;
@@ -189,7 +188,6 @@ static void ipoctal_irq_tx(struct ipoctal_channel *channel)
 	value = channel->tty_port.xmit_buf[*pointer_write];
 	iowrite8(value, &channel->regs->w.thr);
 	channel->stats.tx++;
-	channel->count_wr++;
 	(*pointer_write)++;
 	*pointer_write = *pointer_write % PAGE_SIZE;
 	channel->nb_bytes--;
@@ -444,7 +442,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		spin_lock_init(&channel->lock);
 		channel->pointer_read = 0;
 		channel->pointer_write = 0;
-		channel->nb_bytes = 0;
 		tty_dev = tty_register_device(tty, i, NULL);
 		if (IS_ERR(tty_dev)) {
 			dev_err(&ipoctal->dev->dev, "Failed to register tty device.\n");
@@ -499,11 +496,9 @@ static int ipoctal_write_tty(struct tty_struct *tty,
 			     const unsigned char *buf, int count)
 {
 	struct ipoctal_channel *channel = tty->driver_data;
+	unsigned int char_copied;
 
-	channel->nb_bytes = 0;
-	channel->count_wr = 0;
-
-	ipoctal_copy_write_buffer(channel, buf, count);
+	char_copied = ipoctal_copy_write_buffer(channel, buf, count);
 
 	/* As the IP-OCTAL 485 only supports half duplex, do it manually */
 	if (channel->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) {
@@ -520,7 +515,7 @@ static int ipoctal_write_tty(struct tty_struct *tty,
 	iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
 
 	*channel->board_write = 0;
-	return channel->count_wr;
+	return char_copied;
 }
 
 static int ipoctal_write_room(struct tty_struct *tty)
-- 
1.7.10.4

