Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab2DENxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 09:53:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab2DENxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 09:53:00 -0400
Date: Thu, 5 Apr 2012 15:47:43 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] bonding: properly unset current_arp_slave on slave link
 up
Message-ID: <20120405134743.GB16870@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a slave comes up, we're unsetting the current_arp_slave without
removing active flags from it, which can lead to situations where we have
more than one slave with active flags in active-backup mode.

To avoid this situation we must remove the active flags from a slave before
removing it as a current_arp_slave.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>

---
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0c76186..ad731a1 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3001,7 +3001,11 @@ static void bond_ab_arp_commit(struct bonding *bond, int delta_in_ticks)
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
