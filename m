Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2E2Wau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 18:30:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42737 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2E2Was (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 18:30:48 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH] 8021q/vlan: process NETDEV_GOING_DOWN
Date: Wed, 30 May 2012 00:30:35 +0200
Message-Id: <1338330635-27259-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current flow, when you take down a physical device that has
VLANs configured on it, the NETDEV_GOING_DOWN notification will be
sent too late, i.e., no data can be sent to the wire anymore.

static int __dev_close_many(struct list_head *head)
{
...
	list_for_each_entry(dev, head, unreg_list) {
		call_netdevice_notifiers(NETDEV_GOING_DOWN, dev);
...
	}
...
	list_for_each_entry(dev, head, unreg_list) {
		if (ops->ndo_stop)
			ops->ndo_stop(dev);
	}
...
}

static int dev_close_many(struct list_head *head)
{
	...
	__dev_close_many(head);

	list_for_each_entry(dev, head, unreg_list) {
		rtmsg_ifinfo(RTM_NEWLINK, dev, IFF_UP|IFF_RUNNING);
		call_netdevice_notifiers(NETDEV_DOWN, dev);
	}
}

In a setup like this: eth0 with VLANs 2, 3 the flow would be:

eth0 - NETDEV_GOING_DOWN
ndo_stop is called on the device
eth0.2 - NETDEV_GOING_DOWN
eth0.2 - NETDEV_DOWN
eth0.3 - NETDEV_GOING_DOWN
eth0.3 - NETDEV_DOWN
eth0 - NETDEV_DOWN

If instead NETDEV_GOING_DOWN is processed, the flow would be:
eth0.2 - NETDEV_GOING_DOWN
eth0.2 - NETDEV_DOWN
eth0.3 - NETDEV_GOING_DOWN
eth0.3 - NETDEV_DOWN
eth0 - NETDEV_GOING_DOWN
eth0 - NETDEV_DOWN
ndo_stop is called on the device

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 net/8021q/vlan.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 6089f0c..fd87ecc 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -402,6 +402,12 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 
 		break;
 
+	case NETDEV_GOING_DOWN: /* NETDEV_DOWN */
+	/* If the parent device is going down it will call ndo_stop after
+	 * it sends out NETDEV_GOING_DOWN but before sending out NETDEV_DOWN,
+	 * The effect of which is, that no data can be sent anymore
+	 * by the time the VLAN device sends out its NETDEV_GOING_DOWN.
+	 */
 	case NETDEV_DOWN:
 		/* Put all VLANs for this dev in the down state too.  */
 		for (i = 0; i < VLAN_N_VID; i++) {
-- 
1.7.10

