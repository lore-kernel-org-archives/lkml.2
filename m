Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab2BHVLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:11:20 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:36457 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755790Ab2BHVLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:11:15 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/50] eth: reset addr_assign_type if eth_mac_addr() called
Date: Wed,  8 Feb 2012 22:10:08 +0100
Message-Id: <1328735457-29986-2-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328735475;cac68943;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If eth_mac_addr() get called, usually if SIOCSIFHWADDR was
used to change the MAC of a ethernet device, reset the
addr_assign_type to NET_ADDR_PERM if the state was
NET_ADDR_RANDOM before. Reset the state since the MAC is
no longer random at least not from the kernel side.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 net/ethernet/eth.c |    4 ++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index a246836..9d68142 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -288,6 +288,10 @@ int eth_mac_addr(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
+	/* if device marked as NET_ADDR_RANDOM, reset it */
+	if (dev->addr_assign_type & NET_ADDR_RANDOM)
+		dev->addr_assign_type ^= NET_ADDR_RANDOM;
+
 	return 0;
 }
 EXPORT_SYMBOL(eth_mac_addr);
-- 
1.7.7.3

