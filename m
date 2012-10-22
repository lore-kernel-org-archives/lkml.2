Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2JVFyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:54:12 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:39143 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab2JVFyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:54:10 -0400
From: Doug Goldstein <cardoe@cardoe.com>
To: Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, systemd-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Doug Goldstein <cardoe@cardoe.com>
Subject: [PATCH] vlan: set sysfs device_type to 'vlan'
Date: Mon, 22 Oct 2012 00:53:57 -0500
Message-Id: <1350885237-12998-1-git-send-email-cardoe@cardoe.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sets the sysfs device_type to 'vlan' for udev. This makes it easier for
applications that query network information via udev to identify vlans
instead of using strrchr().

Signed-off-by: Doug Goldstein <cardoe@cardoe.com>
---

Pre-patch output:
swanson ~ # udevadm info -q all -p /sys/devices/virtual/net/br0.4
P: /devices/virtual/net/br0.4
E: UDEV_LOG=3
E: DEVPATH=/devices/virtual/net/br0.4
E: INTERFACE=br0.4
E: IFINDEX=6
E: SUBSYSTEM=net

Post-patch output:
swanson ~ # udevadm info -q all -p /sys/devices/virtual/net/br0.4
P: /devices/virtual/net/br0.4
E: UDEV_LOG=3
E: DEVPATH=/devices/virtual/net/br0.4
E: DEVTYPE=vlan
E: INTERFACE=br0.4
E: IFINDEX=12
E: SUBSYSTEM=net

The intent was to match other virtual network types such as bridges.
swanson ~ # udevadm info -q all -p /sys/devices/virtual/net/br0
P: /devices/virtual/net/br0
E: UDEV_LOG=3
E: DEVPATH=/devices/virtual/net/br0
E: DEVTYPE=bridge
E: INTERFACE=br0
E: IFINDEX=5
E: SUBSYSTEM=net

---
 net/8021q/vlan_dev.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 4024424..78a8744 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -531,6 +531,10 @@ static const struct header_ops vlan_header_ops = {
 	.parse	 = eth_header_parse,
 };
 
+static struct device_type vlan_type = {
+	.name	= "vlan",
+};
+
 static const struct net_device_ops vlan_netdev_ops;
 
 static int vlan_dev_init(struct net_device *dev)
@@ -579,6 +583,8 @@ static int vlan_dev_init(struct net_device *dev)
 
 	dev->netdev_ops = &vlan_netdev_ops;
 
+	SET_NETDEV_DEVTYPE(dev, &vlan_type);
+
 	if (is_vlan_dev(real_dev))
 		subclass = 1;
 
-- 
1.7.8.6

