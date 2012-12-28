Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2L1Tv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:51:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55072 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559Ab2L1TRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:41 -0500
Message-Id: <20121228190400.009542785@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarveshwar Bandi <sarveshwar.bandi@emulex.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 151/173] bonding: Bonding driver does not consider the  gso_max_size/gso_max_segs setting of slave devices.
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>

[ Upstream commit 0e376bd0b791ac6ac6bdb051492df0769c840848 ]

Patch sets the lowest gso_max_size and gso_max_segs values of the slave devices during enslave and detach.

Signed-off-by: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 6c284d1..202ae34 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1366,6 +1366,8 @@ static void bond_compute_features(struct bonding *bond)
 	struct net_device *bond_dev = bond->dev;
 	u32 vlan_features = BOND_VLAN_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
+	unsigned int gso_max_size = GSO_MAX_SIZE;
+	u16 gso_max_segs = GSO_MAX_SEGS;
 	int i;
 
 	read_lock(&bond->lock);
@@ -1379,11 +1381,16 @@ static void bond_compute_features(struct bonding *bond)
 
 		if (slave->dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = slave->dev->hard_header_len;
+
+		gso_max_size = min(gso_max_size, slave->dev->gso_max_size);
+		gso_max_segs = min(gso_max_segs, slave->dev->gso_max_segs);
 	}
 
 done:
 	bond_dev->vlan_features = vlan_features;
 	bond_dev->hard_header_len = max_hard_header_len;
+	bond_dev->gso_max_segs = gso_max_segs;
+	netif_set_gso_max_size(bond_dev, gso_max_size);
 
 	read_unlock(&bond->lock);
 


