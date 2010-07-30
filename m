Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0G3RE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:04:29 -0400
Received: from kroah.org ([198.145.64.141]:35582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab0G3RDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:03:43 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 09:59:55 2010
Message-Id: <20100730165955.129789296@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 09:57:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Pirko <jpirko@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jean Delvare <jdelvare@suse.de>
Subject: [15/17] bonding: select current active slave when enslaving device for mode tlb and alb
In-Reply-To: <20100730170054.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Pirko <jpirko@redhat.com>

commit 5a29f7893fbe681f1334285be7e41e56f0de666c upstream.

I've hit an issue on my system when I've been using RealTek RTL8139D cards in
bonding interface in mode balancing-alb. When I enslave a card, the current
active slave (bond->curr_active_slave) is not set and the link is therefore
not functional.

----
# cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.5.0 (November 4, 2008)

Bonding Mode: adaptive load balancing
Primary Slave: None
Currently Active Slave: None
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

Slave Interface: eth1
MII Status: up
Link Failure Count: 0
Permanent HW addr: 00:1f:1f:01:2f:22
----

The thing that gets it right is when I unplug the cable and then I put it back
into the NIC. Then the current active slave is set to eth1 and link is working
just fine. Here is dmesg log with bonding DEBUG messages turned on:
----
ADDRCONF(NETDEV_UP): bond0: link is not ready
event_dev: bond0, event: 1
IFF_MASTER
event_dev: bond0, event: 8
IFF_MASTER
bond_ioctl: master=bond0, cmd=35216
slave_dev=cac5d800:
slave_dev->name=eth1:
eth1: ! NETIF_F_VLAN_CHALLENGED
event_dev: eth1, event: 8
eth1: link up, 100Mbps, full-duplex, lpa 0xC5E1
event_dev: eth1, event: 1
event_dev: eth1, event: 8
IFF_SLAVE
Initial state of slave_dev is BOND_LINK_UP
bonding: bond0: enslaving eth1 as an active interface with an up link.
ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
event_dev: bond0, event: 4
IFF_MASTER
bond0: no IPv6 routers present

<<<<cable unplug>>>>

eth1: link down
event_dev: eth1, event: 4
IFF_SLAVE
bonding: bond0: link status definitely down for interface eth1, disabling it
event_dev: bond0, event: 4
IFF_MASTER

<<<<cable plug>>>>

eth1: link up, 100Mbps, full-duplex, lpa 0xC5E1
event_dev: eth1, event: 4
IFF_SLAVE
bonding: bond0: link status definitely up for interface eth1.
bonding: bond0: making interface eth1 the new active one.
event_dev: eth1, event: 8
IFF_SLAVE
event_dev: eth1, event: 8
IFF_SLAVE
bonding: bond0: first active interface up!
event_dev: bond0, event: 4
IFF_MASTER
----

The current active slave is set by calling bond_select_active_slave() function
from bond_miimon_commit() function when the slave (eth1) link goes to state up.

I also tested this on other machine with Broadcom NetXtreme II BCM5708
1000Base-T NIC and there all works fine. The thing is that this adapter is down
and goes up after few seconds after it is enslaved.

This patch calls bond_select_active_slave() in bond_enslave() function for modes
alb and tlb and makes sure that the current active slave is set up properly even
when the slave state is already up. Tested on both systems, works fine.

Notice: The same problem can maybe also occrur in mode 8023AD but I'm unable to
test that.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bonding/bond_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1705,6 +1705,7 @@ int bond_enslave(struct net_device *bond
 	case BOND_MODE_ALB:
 		new_slave->state = BOND_STATE_ACTIVE;
 		bond_set_slave_inactive_flags(new_slave);
+		bond_select_active_slave(bond);
 		break;
 	default:
 		dprintk("This slave is always active in trunk mode\n");


