Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1I1WkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:40:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1I1WkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:29 2011
Message-Id: <20110928220129.064268644@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Schwierzeck <daniel.schwierzeck@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [036/244] atm: br2684: Fix oops due to skb->dev being NULL
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Schwierzeck <daniel.schwierzeck@googlemail.com>

commit fbe5e29ec1886967255e76946aaf537b8cc9b81e upstream.

This oops have been already fixed with commit

    27141666b69f535a4d63d7bc6d9e84ee5032f82a

    atm: [br2684] Fix oops due to skb->dev being NULL

    It happens that if a packet arrives in a VC between the call to open it on
    the hardware and the call to change the backend to br2684, br2684_regvcc
    processes the packet and oopses dereferencing skb->dev because it is
    NULL before the call to br2684_push().

but have been introduced again with commit

    b6211ae7f2e56837c6a4849316396d1535606e90

    atm: Use SKB queue and list helpers instead of doing it by-hand.

Signed-off-by: Daniel Schwierzeck <daniel.schwierzeck@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/atm/br2684.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -558,12 +558,13 @@ static int br2684_regvcc(struct atm_vcc
 	spin_unlock_irqrestore(&rq->lock, flags);
 
 	skb_queue_walk_safe(&queue, skb, tmp) {
-		struct net_device *dev = skb->dev;
+		struct net_device *dev;
+
+		br2684_push(atmvcc, skb);
+		dev = skb->dev;
 
 		dev->stats.rx_bytes -= skb->len;
 		dev->stats.rx_packets--;
-
-		br2684_push(atmvcc, skb);
 	}
 
 	/* initialize netdev carrier state */


