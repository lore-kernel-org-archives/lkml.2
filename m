Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1ABHXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:42 -0500
Received: from mail.windriver.com ([147.11.1.11]:35748 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1ABHXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Andy Gospodarek <andy@greyhouse.net>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>, stable@kerne.org,
        Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 125/260] bonding: correctly process non-linear skbs
Date: Sun,  2 Jan 2011 02:17:01 -0500
Message-Id: <1293952756-15010-126-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:26.0477 (UTC) FILETIME=[CE8D6DD0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Gospodarek <andy@greyhouse.net>

commit ab12811c89e88f2e66746790b1fe4469ccb7bdd9 upstream.

It was recently brought to my attention that 802.3ad mode bonds would no
longer form when using some network hardware after a driver update.
After snooping around I realized that the particular hardware was using
page-based skbs and found that skb->data did not contain a valid LACPDU
as it was not stored there.  That explained the inability to form an
802.3ad-based bond.  For balance-alb mode bonds this was also an issue
as ARPs would not be properly processed.

This patch fixes the issue in my tests and should be applied to 2.6.36
and as far back as anyone cares to add it to stable.

Thanks to Alexander Duyck <alexander.h.duyck@intel.com> and Jesse
Brandeburg <jesse.brandeburg@intel.com> for the suggestions on this one.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
CC: Alexander Duyck <alexander.h.duyck@intel.com>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: stable@kerne.org
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/bonding/bond_3ad.c |    3 +++
 drivers/net/bonding/bond_alb.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 822f586..0ddf4c6 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2466,6 +2466,9 @@ int bond_3ad_lacpdu_recv(struct sk_buff *skb, struct net_device *dev, struct pac
 	if (!(dev->flags & IFF_MASTER))
 		goto out;
 
+	if (!pskb_may_pull(skb, sizeof(struct lacpdu)))
+		goto out;
+
 	read_lock(&bond->lock);
 	slave = bond_get_slave_by_dev((struct bonding *)netdev_priv(dev),
 					orig_dev);
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 40fdc41..0d42b38 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -368,6 +368,9 @@ static int rlb_arp_recv(struct sk_buff *skb, struct net_device *bond_dev, struct
 		goto out;
 	}
 
+	if (!pskb_may_pull(skb, arp_hdr_len(bond_dev)))
+		goto out;
+
 	if (skb->len < sizeof(struct arp_pkt)) {
 		pr_debug("Packet is too small to be an ARP\n");
 		goto out;
-- 
1.7.3.3

