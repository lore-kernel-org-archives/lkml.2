Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315Ab2JAXj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:39:27 -0400
Received: from 1wt.eu ([62.212.114.60]:35038 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab2JAW7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:53 -0400
Message-Id: <20121001225158.886573172@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Bohac <jbohac@suse.cz>, Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 030/180] bonding: 802.3ad - fix agg_device_up
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Bohac <jbohac@suse.cz>

commit 2430af8b7fa37ac0be102c77f9dc6ee669d24ba9 upstream.

The slave member of struct aggregator does not necessarily point
to a slave which is part of the aggregator. It points to the
slave structure containing the aggregator structure, while
completely different slaves (or no slaves at all) may be part of
the aggregator.

The agg_device_up() function wrongly uses agg->slave to find the state
of the aggregator.  Use agg->lag_ports->slave instead. The bug has
been introduced by commit 4cd6fe1c6483cde93e2ec91f58b7af9c9eea51ad
("bonding: fix link down handling in 802.3ad mode").

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/bonding/bond_3ad.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 223990d..05308e6 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1471,8 +1471,11 @@ static struct aggregator *ad_agg_selection_test(struct aggregator *best,
 
 static int agg_device_up(const struct aggregator *agg)
 {
-	return (netif_running(agg->slave->dev) &&
-		netif_carrier_ok(agg->slave->dev));
+	struct port *port = agg->lag_ports;
+	if (!port)
+		return 0;
+	return (netif_running(port->slave->dev) &&
+		netif_carrier_ok(port->slave->dev));
 }
 
 /**
-- 
1.7.2.1.45.g54fbc



