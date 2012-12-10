Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2LJLBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:01:07 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:5570 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754822Ab2LJLBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:01:03 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 06:00:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAJtkv1BbdWObgWdsb2JhbABEg0e6ZBYOAQEWJieCHwEFJ1IQPxJXBgESiBTCKZB4A5YDkzo
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 12/12] ipack/devices/ipoctal: added shutdown callback
Date: Mon, 10 Dec 2012 11:50:08 +0100
Message-Id: <1355136608-22029-12-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
References: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added shutdown callback to disable RX and TX when there is no other client
accesing the device.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 3561fb52..e2ae10b 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -624,6 +624,22 @@ static void ipoctal_hangup(struct tty_struct *tty)
 	wake_up_interruptible(&channel->tty_port.open_wait);
 }
 
+static void ipoctal_shutdown(struct tty_struct *tty)
+{
+	struct ipoctal_channel *channel = tty->driver_data;
+
+	if (channel == NULL)
+		return;
+
+	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
+	channel->rx_enable = 0;
+	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
+	clear_bit(ASYNCB_INITIALIZED, &channel->tty_port.flags);
+}
+
 static const struct tty_operations ipoctal_fops = {
 	.ioctl =		NULL,
 	.open =			ipoctal_open,
@@ -634,6 +650,7 @@ static const struct tty_operations ipoctal_fops = {
 	.chars_in_buffer =	ipoctal_chars_in_buffer,
 	.get_icount =		ipoctal_get_icount,
 	.hangup =		ipoctal_hangup,
+	.shutdown =		ipoctal_shutdown,
 };
 
 static int ipoctal_probe(struct ipack_device *dev)
-- 
1.7.10.4

