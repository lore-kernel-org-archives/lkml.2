Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2BOJke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:40:34 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:61741 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab2BOJkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:40:19 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] usb gadget: fix race between eth_open() and gen_ndis_set_resp()
Date: Wed, 15 Feb 2012 17:40:06 +0800
Message-Id: <1329298806-27623-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In such a scenario:
static int gen_ndis_set_resp()
{
	...
        switch (OID) {
	        case OID_GEN_CURRENT_PACKET_FILTER:
		...
		if (*params->filter) {
			...
		} else {
                        params->state = RNDIS_INITIALIZED;
			netif_carrier_off(params->dev);
			netif_stop_queue(params->dev);      <=== A
		}
}

After A is finished, if someone call 'ifconfig usb0 *.*.*.*',
usb0 will never go up because eth_open() fail to call eth_start();

Fix it by calling eth_start() unconditionally in eth_open().

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/u_ether.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index 29c854b..a1a666f 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -640,8 +640,7 @@ static int eth_open(struct net_device *net)
 	struct gether	*link;
 
 	DBG(dev, "%s\n", __func__);
-	if (netif_carrier_ok(dev->net))
-		eth_start(dev, GFP_KERNEL);
+	eth_start(dev, GFP_KERNEL);
 
 	spin_lock_irq(&dev->lock);
 	link = dev->port_usb;
-- 
1.7.5.4

