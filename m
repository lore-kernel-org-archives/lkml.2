Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934496Ab2AJXD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:03:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934482Ab2AJXDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:03:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:05 2012
Message-Id: <20120110215605.644114899@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [47/49] bonding: fix error handling if slave is busy (v2)
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <shemminger@vyatta.com>

commit f7d9821a6a9c83450ac35e76d3709e32fd38b76f upstream.

If slave device already has a receive handler registered, then the
error unwind of bonding device enslave function is broken.

The following will leave a pointer to freed memory in the slave
device list, causing a later kernel panic.
# modprobe dummy
# ip li add dummy0-1 link dummy0 type macvlan
# modprobe bonding
# echo +dummy0 >/sys/class/net/bond0/bonding/slaves

The fix is to detach the slave (which removes it from the list)
in the unwind path.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Reviewed-by: Nicolas de Pesloüan <nicolas.2p.debian@free.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bonding/bond_main.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1822,7 +1822,7 @@ int bond_enslave(struct net_device *bond
 				 "but new slave device does not support netpoll.\n",
 				 bond_dev->name);
 			res = -EBUSY;
-			goto err_close;
+			goto err_detach;
 		}
 	}
 #endif
@@ -1831,7 +1831,7 @@ int bond_enslave(struct net_device *bond
 
 	res = bond_create_slave_symlinks(bond_dev, slave_dev);
 	if (res)
-		goto err_close;
+		goto err_detach;
 
 	res = netdev_rx_handler_register(slave_dev, bond_handle_frame,
 					 new_slave);
@@ -1852,6 +1852,11 @@ int bond_enslave(struct net_device *bond
 err_dest_symlinks:
 	bond_destroy_slave_symlinks(bond_dev, slave_dev);
 
+err_detach:
+	write_lock_bh(&bond->lock);
+	bond_detach_slave(bond, new_slave);
+	write_unlock_bh(&bond->lock);
+
 err_close:
 	dev_close(slave_dev);
 


