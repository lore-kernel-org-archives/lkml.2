Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161515Ab1FAIKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:10:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:43374 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161183Ab1FAIKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:10:24 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:09 2011
Message-Id: <20110601080308.593554219@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:43 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Bohac <jbohac@suse.cz>, Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [047/146] bonding: 802.3ad - fix agg_device_up
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jiri Bohac <jbohac@suse.cz>

[ Upstream commit 2430af8b7fa37ac0be102c77f9dc6ee669d24ba9 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/bonding/bond_3ad.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1482,8 +1482,11 @@ static struct aggregator *ad_agg_selecti
 
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


