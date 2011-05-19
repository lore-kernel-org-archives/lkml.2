Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192Ab1ESS3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:29:40 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35045 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933954Ab1ESSZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:25:38 -0400
X-Sasl-enc: X7p5bqirdvDvg+eYs8f6Xh44PluDJEZ2QSnGmO7oq+Gi 1305829537
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:24:36 2011
Message-Id: <20110519182436.902767935@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:23:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Breno Leitao <leitao@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [06/21] ehea: fix wrongly reported speed and port
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

commit dcbe14b91a920657ff3a9ba0efb7c5b5562f956a upstream.

Currently EHEA reports to ethtool as supporting 10M, 100M, 1G and
10G and connected to FIBRE independent of the hardware configuration.
However, when connected to FIBRE the only supported speed is 10G
full-duplex, and the other speeds and modes are only supported
when connected to twisted pair.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Acked-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ehea/ehea_ethtool.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/net/ehea/ehea_ethtool.c
+++ b/drivers/net/ehea/ehea_ethtool.c
@@ -53,15 +53,20 @@ static int ehea_get_settings(struct net_
 		cmd->duplex = -1;
 	}
 
-	cmd->supported = (SUPPORTED_10000baseT_Full | SUPPORTED_1000baseT_Full
-		       | SUPPORTED_100baseT_Full |  SUPPORTED_100baseT_Half
-		       | SUPPORTED_10baseT_Full | SUPPORTED_10baseT_Half
-		       | SUPPORTED_Autoneg | SUPPORTED_FIBRE);
-
-	cmd->advertising = (ADVERTISED_10000baseT_Full | ADVERTISED_Autoneg
-			 | ADVERTISED_FIBRE);
+	if (cmd->speed == SPEED_10000) {
+		cmd->supported = (SUPPORTED_10000baseT_Full | SUPPORTED_FIBRE);
+		cmd->advertising = (ADVERTISED_10000baseT_Full | ADVERTISED_FIBRE);
+		cmd->port = PORT_FIBRE;
+	} else {
+		cmd->supported = (SUPPORTED_1000baseT_Full | SUPPORTED_100baseT_Full
+			       | SUPPORTED_100baseT_Half | SUPPORTED_10baseT_Full
+			       | SUPPORTED_10baseT_Half | SUPPORTED_Autoneg
+			       | SUPPORTED_TP);
+		cmd->advertising = (ADVERTISED_1000baseT_Full | ADVERTISED_Autoneg
+				 | ADVERTISED_TP);
+		cmd->port = PORT_TP;
+	}
 
-	cmd->port = PORT_FIBRE;
 	cmd->autoneg = port->autoneg == 1 ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 
 	return 0;


