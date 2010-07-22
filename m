Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab0GVTwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:52:43 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23868 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0GVTwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:52:41 -0400
Date: Thu, 22 Jul 2010 13:52:40 -0600
From: Greg Edwards <greg.edwards@hp.com>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: bonding-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] bonding: set device in RLB ARP packet handler
Message-ID: <20100722195240.GA25359@w-gedwards.lhn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit 6146b1a4, the dev field in the RLB ARP packet handler was
set to NULL to wildcard and accommodate balancing VLANs on top of bonds.

This has the side-effect of the packet handler being called against
other, non RLB-enabled bonds, and a kernel oops results when it tries to
dereference rx_hashtbl in rlb_update_entry_from_arp(), which won't be
set for those bonds, e.g. active-backup.

With the __netif_receive_skb() changes from commit 1f3c8804, frames
received on VLANs correctly make their way to the bond's handler,
so we no longer need to wildcard the device.

Signed-off-by: Greg Edwards <greg.edwards@hp.com>
---
Jay,

The oops can be reproduced by:

modprobe bonding

echo active-backup > /sys/class/net/bond0/bonding/mode
echo 100 > /sys/class/net/bond0/bonding/miimon
ifconfig bond0 xxx.xxx.xxx.xxx netmask xxx.xxx.xxx.xxx
echo +eth0 > /sys/class/net/bond0/bonding/slaves
echo +eth1 > /sys/class/net/bond0/bonding/slaves

echo +bond1 > /sys/class/net/bonding_masters
echo balance-alb > /sys/class/net/bond1/bonding/mode
echo 100 > /sys/class/net/bond1/bonding/miimon
ifconfig bond1 xxx.xxx.xxx.xxx netmask xxx.xxx.xxx.xxx
echo +eth2 > /sys/class/net/bond1/bonding/slaves
echo +eth3 > /sys/class/net/bond1/bonding/slaves

Pass some traffic on bond0.  Boom.


 drivers/net/bonding/bond_alb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index df48307..8d7dfd2 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -822,7 +822,7 @@ static int rlb_initialize(struct bonding *bond)
 
 	/*initialize packet type*/
 	pk_type->type = cpu_to_be16(ETH_P_ARP);
-	pk_type->dev = NULL;
+	pk_type->dev = bond->dev;
 	pk_type->func = rlb_arp_recv;
 
 	/* register to receive ARPs */
-- 
1.7.0.4

