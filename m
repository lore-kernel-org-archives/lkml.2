Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1ITWl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:41:59 -0400
Received: from n1.taur.dk ([217.198.219.102]:44022 "EHLO n1.taur.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1ITWl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:41:58 -0400
Message-ID: <4E79168D.4080201@kasperkp.dk>
Date: Wed, 21 Sep 2011 00:41:17 +0200
From: Kasper Pedersen <kernel@kasperkp.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110831 Fedora/3.1.12-2.fc14 Thunderbird/3.1.12
MIME-Version: 1.0
To: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] tg3: fix VLAN tagging regression
References: <4E78FC38.7040903@kasperkp.dk>
In-Reply-To: <4E78FC38.7040903@kasperkp.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 92cd3a17ce9c719abb4c28dee3438e0c641f8de4
    tg3: Simplify tx bd assignments

broke VLAN tagging on outbound packets.
It ifdef'ed BCM_KERNEL_SUPPORTS_8021Q, but this
is not set anywhere. So vlan never gets set, and
all packets are sent with vlan=0.

v2: We can just remove the test. vlan_tx_tag_present
is valid regardless of whether the 802.1q module
is built.

Tested on BCM5721 rev 11.

Signed-off-by: Kasper Pedersen <kernel@kasperkp.dk>
---
 drivers/net/tg3.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index dc3fbf6..4a1374d 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -6234,12 +6234,10 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 
-#ifdef BCM_KERNEL_SUPPORTS_8021Q
 	if (vlan_tx_tag_present(skb)) {
 		base_flags |= TXD_FLAG_VLAN;
 		vlan = vlan_tx_tag_get(skb);
 	}
-#endif
 
 	if (tg3_flag(tp, USE_JUMBO_BDFLAG) &&
 	    !mss && skb->len > VLAN_ETH_FRAME_LEN)

