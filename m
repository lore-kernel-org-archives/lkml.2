Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2EIF5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:57:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39166 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756655Ab2EIFxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:49 -0400
Message-Id: <20120509055039.267551992@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Veaceslav Falico <vfalico@redhat.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 068/167] [PATCH 08/26] bonding: properly unset current_arp_slave on slave
 link up
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 5a4309746cd74734daa964acb02690c22b3c8911 ]

When a slave comes up, we're unsetting the current_arp_slave without
removing active flags from it, which can lead to situations where we have
more than one slave with active flags in active-backup mode.

To avoid this situation we must remove the active flags from a slave before
removing it as a current_arp_slave.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e58aa2b..f65e0b9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2982,7 +2982,11 @@ static void bond_ab_arp_commit(struct bonding *bond, int delta_in_ticks)
 					   trans_start + delta_in_ticks)) ||
 			    bond->curr_active_slave != slave) {
 				slave->link = BOND_LINK_UP;
-				bond->current_arp_slave = NULL;
+				if (bond->current_arp_slave) {
+					bond_set_slave_inactive_flags(
+						bond->current_arp_slave);
+					bond->current_arp_slave = NULL;
+				}
 
 				pr_info("%s: link status definitely up for interface %s.\n",
 					bond->dev->name, slave->dev->name);
-- 
1.7.10



