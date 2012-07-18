Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab2GRAKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:10:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490Ab2GRAEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:04:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 22/37] bonding: Manage /proc/net/bonding/ entries from the netdev events
Date: Tue, 17 Jul 2012 17:02:59 -0700
Message-Id: <20120717232433.190705969@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/bonding/bond_main.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3218,6 +3218,12 @@ static int bond_master_netdev_event(unsi
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
@@ -4402,8 +4408,6 @@ static void bond_uninit(struct net_devic
 
 	bond_work_cancel_all(bond);
 
-	bond_remove_proc_entry(bond);
-
 	bond_debug_unregister(bond);
 
 	__hw_addr_flush(&bond->mc_list);
@@ -4805,7 +4809,6 @@ static int bond_init(struct net_device *
 
 	bond_set_lockdep_class(bond_dev);
 
-	bond_create_proc_entry(bond);
 	list_add_tail(&bond->bond_list, &bn->dev_list);
 
 	bond_prepare_sysfs_group(bond);


