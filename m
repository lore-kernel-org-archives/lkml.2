Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab0G3Rd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:33:57 -0400
Received: from kroah.org ([198.145.64.141]:35396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758788Ab0G3Rdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:33:47 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:02 2010
Message-Id: <20100730173102.915234586@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [001/140] bridge: fdb cleanup runs too often
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit 25442e06d20aaba7d7b16438078a562b3e4cf19b ]

It is common in end-node, non STP bridges to set forwarding
delay to zero; which causes the forwarding database cleanup
to run every clock tick. Change to run only as soon as needed
or at next ageing timer interval which ever is sooner.

Use round_jiffies_up macro rather than attempting round up
by changing value.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_fdb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -127,7 +127,7 @@ void br_fdb_cleanup(unsigned long _data)
 {
 	struct net_bridge *br = (struct net_bridge *)_data;
 	unsigned long delay = hold_time(br);
-	unsigned long next_timer = jiffies + br->forward_delay;
+	unsigned long next_timer = jiffies + br->ageing_time;
 	int i;
 
 	spin_lock_bh(&br->hash_lock);
@@ -148,9 +148,7 @@ void br_fdb_cleanup(unsigned long _data)
 	}
 	spin_unlock_bh(&br->hash_lock);
 
-	/* Add HZ/4 to ensure we round the jiffies upwards to be after the next
-	 * timer, otherwise we might round down and will have no-op run. */
-	mod_timer(&br->gc_timer, round_jiffies(next_timer + HZ/4));
+	mod_timer(&br->gc_timer, round_jiffies_up(next_timer));
 }
 
 /* Completely flush all dynamic entries in forwarding database.*/


