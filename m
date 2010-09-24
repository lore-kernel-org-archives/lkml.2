Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab0IXQ2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:13 -0400
Received: from kroah.org ([198.145.64.141]:46110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583Ab0IXQ2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:10 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:16 2010
Message-Id: <20100924162616.735769173@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Gospodarek <andy@greyhouse.net>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [21/80] bonding: correctly process non-linear skbs
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bonding/bond_3ad.c |    3 +++
 drivers/net/bonding/bond_alb.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2466,6 +2466,9 @@ int bond_3ad_lacpdu_recv(struct sk_buff
 	if (!(dev->flags & IFF_MASTER))
 		goto out;
 
+	if (!pskb_may_pull(skb, sizeof(struct lacpdu)))
+		goto out;
+
 	read_lock(&bond->lock);
 	slave = bond_get_slave_by_dev((struct bonding *)netdev_priv(dev),
 					orig_dev);
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -369,6 +369,9 @@ static int rlb_arp_recv(struct sk_buff *
 		goto out;
 	}
 
+	if (!pskb_may_pull(skb, arp_hdr_len(bond_dev)))
+		goto out;
+
 	if (skb->len < sizeof(struct arp_pkt)) {
 		pr_debug("Packet is too small to be an ARP\n");
 		goto out;


