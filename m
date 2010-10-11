Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0JKXWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 19:22:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36658 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0JKXWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 19:22:21 -0400
From: James Hogan <james@albanarts.com>
To: Gary Zambrano <zambrano@broadcom.com>, Jiri Pirko <jpirko@redhat.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] b44: fix resume, request_irq after hw reset
Date: Tue, 12 Oct 2010 00:22:12 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-custom+; KDE/4.4.5; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010120022.13171.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was hanging on resume because it was requesting a shared irq
that it wasn't ready to immediately handle, which was tested in
request_irq because of the CONFIG_DEBUG_SHIRQ config option. The
interrupt handler tried to read the interrupt status register but for
some reason it hung the system.

The request_irq is now moved a bit later after resetting the hardware
which seems to fix it.

Signed-off-by: James Hogan <james@albanarts.com>
---
 drivers/net/b44.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index 1e620e2..dbba981 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -2296,12 +2296,6 @@ static int b44_resume(struct ssb_device *sdev)
 	if (!netif_running(dev))
 		return 0;
 
-	rc = request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, dev);
-	if (rc) {
-		netdev_err(dev, "request_irq failed\n");
-		return rc;
-	}
-
 	spin_lock_irq(&bp->lock);
 
 	b44_init_rings(bp);
@@ -2309,6 +2303,12 @@ static int b44_resume(struct ssb_device *sdev)
 	netif_device_attach(bp->dev);
 	spin_unlock_irq(&bp->lock);
 
+	rc = request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, dev);
+	if (rc) {
+		netdev_err(dev, "request_irq failed\n");
+		return rc;
+	}
+
 	b44_enable_ints(bp);
 	netif_wake_queue(dev);
 
-- 
1.7.2.3

