Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2LJLCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:02:02 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:5570 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754522Ab2LJLBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:01:01 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 06:00:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAJtkv1BbdWObgWdsb2JhbABEg0e6ZBYOAQEWJieCHwEFJ1IQPxJXBgESiBTCKZB4A5YDkzo
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 07/12] ipack/devices/ipoctal: avoid re-enable RX two times.
Date: Mon, 10 Dec 2012 11:50:03 +0100
Message-Id: <1355136608-22029-7-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
References: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RX is enabled when the tty port is open, so no need to do it in initialization
time: it can allow the device to receive characters but no TTY client is
listening to them.

It produced an infinite number of IRQ as RxFIFO is not read to clear that
IRQ in the device, so it is still pending.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 96467bb..45920f5 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -60,6 +60,10 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 
 	channel = dev_get_drvdata(tty->dev);
 
+	/*
+	 * Enable RX. TX will be enabled when
+	 * there is something to send
+	 */
 	iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
 	return 0;
 }
@@ -384,12 +388,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 			continue;
 		}
 		dev_set_drvdata(tty_dev, channel);
-
-		/*
-		 * Enable again the RX. TX will be enabled when
-		 * there is something to send
-		 */
-		iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
 	}
 
 	return 0;
-- 
1.7.10.4

