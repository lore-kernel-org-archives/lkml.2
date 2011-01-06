Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1AFAaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:09 -0500
Received: from kroah.org ([198.145.64.141]:35773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab1AFAaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:03 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:03 2011
Message-Id: <20110106002303.342849252@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Changli Gao <xiaosuo@gmail.com>, Jamal Hadi Salim <hadi@cyberus.ca>,
        "David S. Miller" <davem@davemloft.net>
Subject: [071/152] ifb: goto resched directly if error happens and dp->tq isnt empty
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Changli Gao <xiaosuo@gmail.com>

[ Upstream commit 75c1c82566f23dd539fb7ccbf57a1caa7ba82628 ]

If we break the loop when there are still skbs in tq and no skb in
rq, the skbs will be left in txq until new skbs are enqueued into rq.
In rare cases, no new skb is queued, then these skbs will stay in rq
forever.

After this patch, if tq isn't empty when we break the loop, we goto
resched directly.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/ifb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -104,6 +104,8 @@ static void ri_tasklet(unsigned long dev
 			rcu_read_unlock();
 			dev_kfree_skb(skb);
 			stats->tx_dropped++;
+			if (skb_queue_len(&dp->tq) != 0)
+				goto resched;
 			break;
 		}
 		rcu_read_unlock();


