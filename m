Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2HNKao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:30:44 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:54151 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854Ab2HNK3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:29:13 -0400
From: Ilya Shchepetkov <shchepetkov@ispras.ru>
To: Robin Holt <holt@sgi.com>
Cc: Ilya Shchepetkov <shchepetkov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH 1/5] sgi-xp: Call netif_carrier_off() after register_netdev()
Date: Tue, 14 Aug 2012 14:28:51 +0400
Message-Id: <1344940135-17079-2-git-send-email-shchepetkov@ispras.ru>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1344940135-17079-1-git-send-email-shchepetkov@ispras.ru>
References: <1344940135-17079-1-git-send-email-shchepetkov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For carrier detection to work properly when binding the driver with a
cable unplugged, netif_carrier_off() should be calle after
register_netdev(), not before.

Calling netif_carrier_off() before register_netdev() was causing the
network interface to miss a linkwatch pending event leading to an
inconsistent state if the link is not up when interface is initialized.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Ilya Shchepetkov <shchepetkov@ispras.ru>
---
 drivers/misc/sgi-xp/xpnet.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index 3fac67a..9296c8d 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -550,8 +550,6 @@ xpnet_init(void)
 		return -ENOMEM;
 	}
 
-	netif_carrier_off(xpnet_device);
-
 	xpnet_device->netdev_ops = &xpnet_netdev_ops;
 	xpnet_device->mtu = XPNET_DEF_MTU;
 
@@ -584,6 +582,8 @@ xpnet_init(void)
 		kfree(xpnet_broadcast_partitions);
 	}
 
+	netif_carrier_off(xpnet_device);
+
 	return result;
 }
 
-- 
1.7.7

