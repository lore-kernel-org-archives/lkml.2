Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab2BHVSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:18:21 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:56775 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092Ab2BHVSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:18:17 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Decotigny <decot@google.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>
Subject: [PATCH 17/50] enc28j60: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:24 +0100
Message-Id: <1328735457-29986-18-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328735897;4010f097;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Reset the state to NET_ADDR_PERM as soon as the MAC get
changed via .ndo_set_mac_address.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/microchip/enc28j60.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
index 50055e0..2abf71d 100644
--- a/drivers/net/ethernet/microchip/enc28j60.c
+++ b/drivers/net/ethernet/microchip/enc28j60.c
@@ -528,6 +528,9 @@ static int enc28j60_set_mac_address(struct net_device *dev, void *addr)
 		return -EADDRNOTAVAIL;
 
 	memcpy(dev->dev_addr, address->sa_data, dev->addr_len);
+	if (dev->addr_assign_type & NET_ADDR_RANDOM)
+		dev->addr_assign_type ^= NET_ADDR_RANDOM;
+
 	return enc28j60_set_hw_macaddr(dev);
 }
 
@@ -1579,7 +1582,7 @@ static int __devinit enc28j60_probe(struct spi_device *spi)
 		ret = -EIO;
 		goto error_irq;
 	}
-	random_ether_addr(dev->dev_addr);
+	dev_hw_addr_random(dev, dev->dev_addr);
 	enc28j60_set_hw_macaddr(dev);
 
 	/* Board setup must set the relevant edge trigger type;
-- 
1.7.7.3

