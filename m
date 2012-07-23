Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab2GWCBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:01:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54157 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195Ab2GWBms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:48 -0400
Message-Id: <20120723010707.224905533@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 103/108] bonding: Manage /proc/net/bonding/ entries from the netdev events
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit a64d49c3dd504b685f9742a2f3dcb11fb8e4345f upstream.

It was recently reported that moving a bonding device between network
namespaces causes warnings from /proc.  It turns out after the move we
were trying to add and to remove the /proc/net/bonding entries from the
wrong network namespace.

Move the bonding /proc registration code into the NETDEV_REGISTER and
NETDEV_UNREGISTER events where the proc registration and unregistration
will always happen at the right time.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_main.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b9c2ae6..2ee7699 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3227,6 +3227,12 @@ static int bond_master_netdev_event(unsigned long event,
 	switch (event) {
 	case NETDEV_CHANGENAME:
 		return bond_event_changename(event_bond);
+	case NETDEV_UNREGISTER:
+		bond_remove_proc_entry(event_bond);
+		break;
+	case NETDEV_REGISTER:
+		bond_create_proc_entry(event_bond);
+		break;
 	default:
 		break;
 	}
@@ -4411,8 +4417,6 @@ static void bond_uninit(struct net_device *bond_dev)
 
 	bond_work_cancel_all(bond);
 
-	bond_remove_proc_entry(bond);
-
 	bond_debug_unregister(bond);
 
 	__hw_addr_flush(&bond->mc_list);
@@ -4814,7 +4818,6 @@ static int bond_init(struct net_device *bond_dev)
 
 	bond_set_lockdep_class(bond_dev);
 
-	bond_create_proc_entry(bond);
 	list_add_tail(&bond->bond_list, &bn->dev_list);
 
 	bond_prepare_sysfs_group(bond);


