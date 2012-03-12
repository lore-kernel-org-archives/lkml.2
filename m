Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab2CLIgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 04:36:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63040 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab2CLIgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 04:36:06 -0400
From: Weiping Pan <panweiping3@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Weiping Pan <panweiping3@gmail.com>
Subject: [PATCH net] bonding: send igmp report for its master
Date: Mon, 12 Mar 2012 16:40:46 +0800
Message-Id: <f5d199e12d78dadcfb932e103984276d36b186e0.1331539261.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liang Zheng(lzheng@redhat.com) found that in the following topo,
bonding can not send igmp report.

eth0--
      |-- bond0 -- br0
eth1--

modprobe bonding mode=1 miimon=100 resend_igmp=10
ifconfig bond0 up
ifenslave bond0 eth0 eth1

brctl addbr br0
ifconfig br0 192.168.100.2/24 up
brctl addif br0 bond0

Add 192.168.100.2(br0) into a multicast group, like 224.10.10.10,
then trigger a fali-over in bonding.
You can see that parameter "resend_igmp" does not work.

The reason is that when we add br0 into a multicast group,
it does not propagate multicast knowledge down to its ports.

If we choose to propagate multicast knowledge down to all ports for bridge,
then we have to track every change that is done to bridge, and keep a backup
for all ports. It is hard to track, I think.

Instead I choose to modify bonding to send igmp report for its master.

There is a problem in this patch, in the following topo,
bonding will send duplicate igmp reports.

bond0--
      |-- bond2
bond1--

The reason is that I do not check whether master_dev is a bridge or a bonding.
I prefer to skip such check, since this topo is rare.
And if we add such check, then for every kind of virtual device,
we should check whether bonding can be a slave of it,
and if we add a new virtual device, we have to add a check in bonding, too.

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_main.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 435984a..300c490 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -794,6 +794,14 @@ static void bond_resend_igmp_join_requests_delayed(struct work_struct *work)
 {
 	struct bonding *bond = container_of(work, struct bonding,
 					    mcast_work.work);
+	struct net_device *bond_dev, *master_dev = NULL;
+	bond_dev = bond->dev;
+	master_dev = bond_dev->master;
+
+	if (unlikely(master_dev)) {
+		__bond_resend_igmp_join_requests(master_dev);
+	}
+
 	bond_resend_igmp_join_requests(bond);
 }
 
-- 
1.7.4.4

