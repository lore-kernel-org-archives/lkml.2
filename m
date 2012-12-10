Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2LJLBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:01:05 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:5570 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754607Ab2LJLA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:00:59 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 06:00:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAJtkv1BbdWObgWdsb2JhbABEg0e6ZBYOAQEWJieCHwEFJ1IQPxJXBgESiBTCKZB4A5YDkzo
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 08/12] ipack/devices/ipoctal: ack IRQ before processing it
Date: Mon, 10 Dec 2012 11:50:04 +0100
Message-Id: <1355136608-22029-8-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
References: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the IRQ processing, we can generate another IRQ that can come before we
end the previous one, so we lost it. E.g. when transmitting a character.

To allow the processing in SMP machines, we ack the IRQ at the beginning of the
IRQ handler.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 45920f5..d57ac61 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -223,14 +223,14 @@ static irqreturn_t ipoctal_irq_handler(void *arg)
 	unsigned int i;
 	struct ipoctal *ipoctal = (struct ipoctal *) arg;
 
-	/* Check all channels */
-	for (i = 0; i < NR_CHANNELS; i++)
-		ipoctal_irq_channel(&ipoctal->channel[i]);
-
 	/* Clear the IPack device interrupt */
 	readw(ipoctal->int_space + ACK_INT_REQ0);
 	readw(ipoctal->int_space + ACK_INT_REQ1);
 
+	/* Check all channels */
+	for (i = 0; i < NR_CHANNELS; i++)
+		ipoctal_irq_channel(&ipoctal->channel[i]);
+
 	return IRQ_HANDLED;
 }
 
-- 
1.7.10.4

