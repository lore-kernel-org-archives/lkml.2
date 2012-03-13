Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225Ab2CMAYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:48805 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157Ab2CMAYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 174/196] ehea: fix wrongly reported speed and port
Date: Mon, 12 Mar 2012 20:21:27 -0400
Message-Id: <1331598109-31424-129-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit dcbe14b91a920657ff3a9ba0efb7c5b5562f956a upstream.

Currently EHEA reports to ethtool as supporting 10M, 100M, 1G and
10G and connected to FIBRE independent of the hardware configuration.
However, when connected to FIBRE the only supported speed is 10G
full-duplex, and the other speeds and modes are only supported
when connected to twisted pair.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Acked-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/ehea/ehea_ethtool.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ehea/ehea_ethtool.c b/drivers/net/ehea/ehea_ethtool.c
index 75b099c..f97da2a 100644
--- a/drivers/net/ehea/ehea_ethtool.c
+++ b/drivers/net/ehea/ehea_ethtool.c
@@ -53,15 +53,20 @@ static int ehea_get_settings(struct net_device *dev, struct ethtool_cmd *cmd)
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
-- 
1.7.9.3

