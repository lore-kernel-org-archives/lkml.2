Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1HZF6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 01:58:06 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40081 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1HZF6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 01:58:03 -0400
X-AuditID: b753bd60-a32aeba0000019f4-f5-4e5735e7a414
X-AuditID: b753bd60-a32aeba0000019f4-f5-4e5735e7a414
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH net-next ] Fix time-lag of IFF_RUNNING flag consistency
 between vlan and real devices
To: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?utf-8?q?Micha=C5=82?= =?utf-8?b?TWlyb3PFgmF3?= 
	<mirq-linux@rere.qmqm.pl>,
        Tom Herbert <therbert@google.com>, Jesse Gross <jesse@nicira.com>,
        herbert@gondor.hengli.com.au
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?utf-8?b?Ik1pY2hhxYI=?= =?utf-8?q?Miros=C5=82aw=22?= 
	<mirq-linux@rere.qmqm.pl>,
        Tom Herbert <therbert@google.com>, Jesse Gross <jesse@nicira.com>
Date: Fri, 26 Aug 2011 15:02:57 +0900
Message-ID: <20110826060257.5304.62723.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a time-lag of IFF_RUNNING flag consistency between vlan and real
devices when the real devices are in problem such as link or cable broken.
This leads to a degradation of Availability such as a delay of failover in
HA systems using vlan since the detection of the problem at real device is
delayed.

Why this happens:
Network devices' flags can be checked using ioctl with SIOCGIFFLAGS. When
vlan technique is used, it checks the flags of vlan device, not real
device.

Patch:
This patch adds vlan-device check into dev_get_flags(). So, it can check
flags of the real device even if the vlan is used.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: Tom Herbert <therbert@google.com>
Cc: Jesse Gross <jesse@nicira.com>
---

 include/linux/if_vlan.h |    2 +-
 net/core/dev.c          |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 44da482..4df4e6f 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -91,7 +91,7 @@ struct vlan_group {
 	struct rcu_head		rcu;
 };
 
-static inline int is_vlan_dev(struct net_device *dev)
+static inline int is_vlan_dev(const struct net_device *dev)
 {
         return dev->priv_flags & IFF_802_1Q_VLAN;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index a4306f7..527e21b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4603,6 +4603,13 @@ unsigned dev_get_flags(const struct net_device *dev)
 		(dev->gflags & (IFF_PROMISC |
 				IFF_ALLMULTI));
 
+	/*
+	 * If we're trying to get flags on a vlan device
+	 * use the underlying physical device instead.
+	 */
+	if (is_vlan_dev(dev))
+		dev = vlan_dev_real_dev(dev);
+
 	if (netif_running(dev)) {
 		if (netif_oper_up(dev))
 			flags |= IFF_RUNNING;

