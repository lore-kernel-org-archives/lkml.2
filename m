Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0CaKwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 06:52:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab0CaKw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:52:29 -0400
Date: Wed, 31 Mar 2010 06:52:13 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Pirko <jpirko@redhat.com>, Stephen Hemminger <shemminger@vyatta.com>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Amerigo Wang <amwang@redhat.com>, bonding-devel@lists.sourceforge.net,
       Jay Vosburgh <fubar@us.ibm.com>
Message-Id: <20100331105559.5607.38643.sendpatchset@localhost.localdomain>
Subject: [Patch] bonding: fix potential deadlock in bond_uninit()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bond_uninit() is invoked with rtnl_lock held, when it does destroy_workqueue()
which will potentially flush all works in this workqueue, if we hold rtnl_lock
again in the work function, it will deadlock.

So unlock rtnl_lock before calling destroy_workqueue().

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jiri Pirko <jpirko@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>

---
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5b92fbf..b781728 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4542,8 +4542,11 @@ static void bond_uninit(struct net_device *bond_dev)
 
 	bond_remove_proc_entry(bond);
 
-	if (bond->wq)
+	if (bond->wq) {
+		rtnl_unlock();
 		destroy_workqueue(bond->wq);
+		rtnl_lock();
+	}
 
 	netif_addr_lock_bh(bond_dev);
 	bond_mc_list_destroy(bond);
