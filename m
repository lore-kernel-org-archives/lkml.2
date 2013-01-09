Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3AIUgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:36:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:40852 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab3AIUgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sarveshwar Bandi <sarveshwar.bandi@emulex.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 01/47] bonding: Bonding driver does not consider the gso_max_size/gso_max_segs setting of slave devices.
Date: Wed,  9 Jan 2013 12:34:56 -0800
Message-Id: <20130109201729.605040407@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>

[ Upstream commit 0e376bd0b791ac6ac6bdb051492df0769c840848 ]

Patch sets the lowest gso_max_size and gso_max_segs values of the slave devices during enslave and detach.

Signed-off-by: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1439,6 +1439,8 @@ static void bond_compute_features(struct
 	struct net_device *bond_dev = bond->dev;
 	u32 vlan_features = BOND_VLAN_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
+	unsigned int gso_max_size = GSO_MAX_SIZE;
+	u16 gso_max_segs = GSO_MAX_SEGS;
 	int i;
 
 	read_lock(&bond->lock);
@@ -1452,11 +1454,16 @@ static void bond_compute_features(struct
 
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
 


