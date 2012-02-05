Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2BEW1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:27:19 -0500
Received: from 1wt.eu ([62.212.114.60]:62142 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab2BEW1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:07 -0500
Message-Id: <20120205220952.655543446@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andy Gospodarek <andy@greyhouse.net>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 75/91] [PATCH] bonding: correctly process non-linear skbs
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/bonding/bond_3ad.c |    3 +++
 drivers/net/bonding/bond_alb.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/net/bonding/bond_3ad.c
===================================================================
--- longterm-2.6.27.orig/drivers/net/bonding/bond_3ad.c	2012-02-05 22:34:32.729915391 +0100
+++ longterm-2.6.27/drivers/net/bonding/bond_3ad.c	2012-02-05 22:34:45.523916489 +0100
@@ -2436,6 +2436,9 @@
 	if (!(dev->flags & IFF_MASTER))
 		goto out;
 
+	if (!pskb_may_pull(skb, sizeof(struct lacpdu)))
+		goto out;
+
 	read_lock(&bond->lock);
 	slave = bond_get_slave_by_dev((struct bonding *)dev->priv, orig_dev);
 	if (!slave)
Index: longterm-2.6.27/drivers/net/bonding/bond_alb.c
===================================================================
--- longterm-2.6.27.orig/drivers/net/bonding/bond_alb.c	2012-02-05 22:34:32.733915045 +0100
+++ longterm-2.6.27/drivers/net/bonding/bond_alb.c	2012-02-05 22:34:45.528915452 +0100
@@ -359,6 +359,9 @@
 		goto out;
 	}
 
+	if (!pskb_may_pull(skb, arp_hdr_len(bond_dev)))
+		goto out;
+
 	if (skb->len < sizeof(struct arp_pkt)) {
 		dprintk("Packet is too small to be an ARP\n");
 		goto out;


