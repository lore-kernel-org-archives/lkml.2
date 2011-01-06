Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab1AFArX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:47:23 -0500
Received: from kroah.org ([198.145.64.141]:35807 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab1AFAaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:11 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:04 2011
Message-Id: <20110106002303.974951485@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [077/152] net: fix skb_defer_rx_timestamp()
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit a19faf0250e09b16cac169354126404bc8aa342b ]

After commit c1f19b51d1d8 (net: support time stamping in phy devices.),
kernel might crash if CONFIG_NETWORK_PHY_TIMESTAMPING=y and
skb_defer_rx_timestamp() handles a packet without an ethernet header.

Fixes kernel bugzilla #24102

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=24102
Reported-and-tested-by: Andrew Watts <akwatts@ymail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/timestamping.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/core/timestamping.c
+++ b/net/core/timestamping.c
@@ -96,11 +96,13 @@ bool skb_defer_rx_timestamp(struct sk_bu
 	struct phy_device *phydev;
 	unsigned int type;
 
-	skb_push(skb, ETH_HLEN);
+	if (skb_headroom(skb) < ETH_HLEN)
+		return false;
+	__skb_push(skb, ETH_HLEN);
 
 	type = classify(skb);
 
-	skb_pull(skb, ETH_HLEN);
+	__skb_pull(skb, ETH_HLEN);
 
 	switch (type) {
 	case PTP_CLASS_V1_IPV4:


