Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2LJLBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:01:03 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:5570 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754816Ab2LJLBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:01:01 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 06:00:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAJtkv1BbdWObgWdsb2JhbABEg0e6ZBYOAQEWJieCHwEFJ1IQPxJXBgESiBTCKYw4hEADlgOTOoFr
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 09/12] ipack/devices/ipoctal: protect the channel data processing with a spinlock
Date: Mon, 10 Dec 2012 11:50:05 +0100
Message-Id: <1355136608-22029-9-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
References: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We protect important data such as TX buffer pointer, nb_bytes counter and status
registers of the device, from accessing several times at the same time.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index d57ac61..8dff66e 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -191,6 +191,8 @@ static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 	tty = tty_port_tty_get(&channel->tty_port);
 	if (!tty)
 		return;
+
+	spin_lock(&channel->lock);
 	/* The HW is organized in pair of channels.  See which register we need
 	 * to read from */
 	isr = ioread8(&channel->block_regs->r.isr);
@@ -216,6 +218,7 @@ static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
+	spin_unlock(&channel->lock);
 }
 
 static irqreturn_t ipoctal_irq_handler(void *arg)
-- 
1.7.10.4

