Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0I2Ied (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:34:33 -0400
Received: from daytona.panasas.com ([67.152.220.89]:27521 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755001Ab0I2Iec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:34:32 -0400
Message-ID: <4CA2FA13.8050405@panasas.com>
Date: Wed, 29 Sep 2010 10:34:27 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
CC: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] um: Proper Fix for f25c80a4: remove duplicate structure field
 initialization
References: <4CA09977.80506@panasas.com> <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com> <20100928134721.f79a5955.akpm@linux-foundation.org> <AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
In-Reply-To: <AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2010 08:34:31.0069 (UTC) FILETIME=[22F78CD0:01CB5FB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


uml_net_set_mac() was broken and luckily it was never used, before.
What it was trying to do is spin_lock before memcopy the mac address.
Linus attempted to fix it in assumption that someone decided the
lock was needed. But since it was never ever used at all, and was
just dead code, I think we can assume that it is not needed, after
all.

On the other hand patch [f25c80a4] was trying to use eth_mac_addr()
in eth_configure(), *which was the real fallout*. Because of state
checks done inside eth_mac_addr() the address was never set. I have
not reintroduced the memcpy wrapper, but I've put a comment for future
cats.

The code now is back to exactly as it was before [f25c80a4]. With
the cleanup applied. If the spin_lock is indeed needed then a contender
should supply a test case that fails, then fix it with the proper
locking, as a separate unrelated patch.

CC: Julia Lawall <julia@diku.dk>
CC: David S. Miller <davem@davemloft.net>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
Tested-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 arch/um/drivers/net_kern.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 2ab233b..47d0c37 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -255,18 +255,6 @@ static void uml_net_tx_timeout(struct net_device *dev)
 	netif_wake_queue(dev);
 }
 
-static int uml_net_set_mac(struct net_device *dev, void *addr)
-{
-	struct uml_net_private *lp = netdev_priv(dev);
-	struct sockaddr *hwaddr = addr;
-
-	spin_lock_irq(&lp->lock);
-	eth_mac_addr(dev, hwaddr->sa_data);
-	spin_unlock_irq(&lp->lock);
-
-	return 0;
-}
-
 static int uml_net_change_mtu(struct net_device *dev, int new_mtu)
 {
 	dev->mtu = new_mtu;
@@ -373,7 +361,7 @@ static const struct net_device_ops uml_netdev_ops = {
 	.ndo_start_xmit 	= uml_net_start_xmit,
 	.ndo_set_multicast_list = uml_net_set_multicast_list,
 	.ndo_tx_timeout 	= uml_net_tx_timeout,
-	.ndo_set_mac_address	= uml_net_set_mac,
+	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_change_mtu 	= uml_net_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 };
@@ -472,7 +460,8 @@ static void eth_configure(int n, void *init, char *mac,
 	    ((*transport->user->init)(&lp->user, dev) != 0))
 		goto out_unregister;
 
-	eth_mac_addr(dev, device->mac);
+	/* don't use eth_mac_addr, it will not work here */
+	memcpy(dev->dev_addr, device->mac, ETH_ALEN);
 	dev->mtu = transport->user->mtu;
 	dev->netdev_ops = &uml_netdev_ops;
 	dev->ethtool_ops = &uml_net_ethtool_ops;
-- 
1.7.2.3


