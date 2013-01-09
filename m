Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378Ab3AIVfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:35:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:42282 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933307Ab3AIUii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 47/47] can: Do not call dev_put if restart timer is running upon close
Date: Wed,  9 Jan 2013 12:35:42 -0800
Message-Id: <20130109201734.895771480@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/dev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -557,8 +557,7 @@ void close_candev(struct net_device *dev
 {
 	struct can_priv *priv = netdev_priv(dev);
 
-	if (del_timer_sync(&priv->restart_timer))
-		dev_put(dev);
+	del_timer_sync(&priv->restart_timer);
 	can_flush_echo_skb(dev);
 }
 EXPORT_SYMBOL_GPL(close_candev);


