Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1EJAT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 20:19:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40382 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab1EJATY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 20:19:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:organization;
	b=gHsy66wvLVram6n51KURjqjd/G7NXHsdMQPzsY5mlWJdmmRBww8TeuKmy3zkKWFDr
	dyfrWws6AuWMHD6gg1oSQ==
From: David Decotigny <decot@google.com>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: David Decotigny <decot@google.com>
Subject: [PATCH 1/2] net/stmmac: don't go through ethtool to start autonegociation
Date: Mon,  9 May 2011 17:19:07 -0700
Message-Id: <1304986748-15809-2-git-send-email-decot@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304986748-15809-1-git-send-email-decot@google.com>
References: <1304986748-15809-1-git-send-email-decot@google.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver used to call phy's ethtool configuration routine to start
autonegociation. This change has it call directly phy's routine to
start autonegociation.

IMPORTANT: initial version was hiding phy_start_aneg() return value,
           this patch returns it (<0 upon error).

Tested: module compiles, NOT tested on real hardware.
Signed-off-by: David Decotigny <decot@google.com>
---
 drivers/net/stmmac/stmmac_ethtool.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/stmmac/stmmac_ethtool.c b/drivers/net/stmmac/stmmac_ethtool.c
index 6f5aaeb..9c05cf0 100644
--- a/drivers/net/stmmac/stmmac_ethtool.c
+++ b/drivers/net/stmmac/stmmac_ethtool.c
@@ -236,17 +236,8 @@ stmmac_set_pauseparam(struct net_device *netdev,
 	priv->flow_ctrl = new_pause;
 
 	if (phy->autoneg) {
-		if (netif_running(netdev)) {
-			struct ethtool_cmd cmd = { .cmd = ETHTOOL_SSET };
-			/* auto-negotiation automatically restarted */
-			cmd.supported = phy->supported;
-			cmd.advertising = phy->advertising;
-			cmd.autoneg = phy->autoneg;
-			ethtool_cmd_speed_set(&cmd, phy->speed);
-			cmd.duplex = phy->duplex;
-			cmd.phy_address = phy->addr;
-			ret = phy_ethtool_sset(phy, &cmd);
-		}
+		if (netif_running(netdev))
+			ret = phy_start_aneg(phy);
 	} else
 		priv->hw->mac->flow_ctrl(priv->ioaddr, phy->duplex,
 					 priv->flow_ctrl, priv->pause);
-- 
1.7.3.1

