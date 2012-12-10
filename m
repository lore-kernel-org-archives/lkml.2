Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2LJLDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:03:03 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:5570 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752547Ab2LJLAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:00:42 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 06:00:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAJtkv1BbdWObgWdsb2JhbABEg0e6ZBYOAQEWJieCHwEFJ1IQPxJXBgESiBTCKZB4A5YDkzo
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 03/12] ipack/devices/ipoctal: fix kernel bug when using pppd
Date: Mon, 10 Dec 2012 11:49:59 +0100
Message-Id: <1355136608-22029-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
References: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to setup the pppd server to use ipoctal's serial ports, it says the ports
are busy the first time. If the operation is repeated, a kernel bug due to a
dereference of a NULL pointer appears.

Removing the one-access-only setup from the driver, removes this kernel bug.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 8f699b0..241db2f 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -38,7 +38,6 @@ struct ipoctal_channel {
 	spinlock_t			lock;
 	unsigned int			pointer_read;
 	unsigned int			pointer_write;
-	atomic_t			open;
 	struct tty_port			tty_port;
 	union scc2698_channel __iomem	*regs;
 	union scc2698_block __iomem	*block_regs;
@@ -70,22 +69,12 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 
 static int ipoctal_open(struct tty_struct *tty, struct file *file)
 {
-	int res;
 	struct ipoctal_channel *channel;
 
 	channel = dev_get_drvdata(tty->dev);
-
-	if (atomic_read(&channel->open))
-		return -EBUSY;
-
 	tty->driver_data = channel;
 
-	res = tty_port_open(&channel->tty_port, tty, file);
-	if (res)
-		return res;
-
-	atomic_inc(&channel->open);
-	return 0;
+	return tty_port_open(&channel->tty_port, tty, file);
 }
 
 static void ipoctal_reset_stats(struct ipoctal_stats *stats)
@@ -111,9 +100,7 @@ static void ipoctal_close(struct tty_struct *tty, struct file *filp)
 	struct ipoctal_channel *channel = tty->driver_data;
 
 	tty_port_close(&channel->tty_port, tty, filp);
-
-	if (atomic_dec_and_test(&channel->open))
-		ipoctal_free_channel(channel);
+	ipoctal_free_channel(channel);
 }
 
 static int ipoctal_get_icount(struct tty_struct *tty,
@@ -205,10 +192,6 @@ static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 	u8 isr, sr;
 	struct tty_struct *tty;
 
-	/* If there is no client, skip the check */
-	if (!atomic_read(&channel->open))
-		return;
-
 	tty = tty_port_tty_get(&channel->tty_port);
 	if (!tty)
 		return;
-- 
1.7.10.4

