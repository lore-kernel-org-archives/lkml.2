Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab0IXQsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:48:25 -0400
Received: from kroah.org ([198.145.64.141]:37058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923Ab0IXQe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:34:57 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:44 2010
Message-Id: <20100924163344.878590365@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [10/68] bridge: Clear INET control block of SKBs passed into ip_fragment().
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 4ce6b9e1621c187a32a47a17bf6be93b1dc4a3df ]

In a similar vain to commit 17762060c25590bfddd68cc1131f28ec720f405f
("bridge: Clear IPCB before possible entry into IP stack")

Any time we call into the IP stack we have to make sure the state
there is as expected by the ipv4 code.

With help from Eric Dumazet and Herbert Xu.

Reported-by: Brandan Das <brandan.das@stratus.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_netfilter.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -800,9 +800,11 @@ static int br_nf_dev_queue_xmit(struct s
 	if (skb->nfct != NULL &&
 	    (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb)) &&
 	    skb->len > skb->dev->mtu &&
-	    !skb_is_gso(skb))
+	    !skb_is_gso(skb)) {
+		/* BUG: Should really parse the IP options here. */
+		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
 		return ip_fragment(skb, br_dev_queue_push_xmit);
-	else
+	} else
 		return br_dev_queue_push_xmit(skb);
 }
 #else


