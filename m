Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab2L1TiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:38:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55404 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932250Ab2L1TSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:55 -0500
Message-Id: <20121228190348.197447310@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 086/173] can: Do not call dev_put if restart timer is running upon close
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@systec-electronic.com>

commit ab48b03ec9ae1840a1e427e2375bd0d9d554b4ed upstream.

If the restart timer is running due to BUS-OFF and the device is
disconnected an dev_put will decrease the usage counter to -1 thus
blocking the interface removal, resulting in the following dmesg
lines repeating every 10s:
can: notifier: receive list not found for dev can0
can: notifier: receive list not found for dev can0
can: notifier: receive list not found for dev can0
unregister_netdevice: waiting for can0 to become free. Usage count = -1

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/dev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 963e2cc..8233e5e 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -609,8 +609,7 @@ void close_candev(struct net_device *dev)
 {
 	struct can_priv *priv = netdev_priv(dev);
 
-	if (del_timer_sync(&priv->restart_timer))
-		dev_put(dev);
+	del_timer_sync(&priv->restart_timer);
 	can_flush_echo_skb(dev);
 }
 EXPORT_SYMBOL_GPL(close_candev);


