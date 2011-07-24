Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1GYAJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 20:09:43 -0400
Received: from balu.sch.bme.hu ([152.66.208.40]:46450 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab1GYAJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 20:09:40 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jul 2011 20:09:40 EDT
Date: Mon, 25 Jul 2011 01:09:30 +0200
From: "Zoltan, Kiss" <schaman@sch.bme.hu>
Subject: [PATCH 1/1] IPv4: Send gratuitous ARP for secondary IP addresses also
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Pekka Savola <pekkas@netcore.fi>, James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zoltan Kiss <schaman@sch.bme.hu>
Message-id: <1311548970-27522-1-git-send-email-schaman@sch.bme.hu>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <schaman@sch.bme.hu>

If a device event generates gratuitous ARP messages, only primary
address is used for sending. This patch iterates through the whole
list. Tested with 2 IP addresses configuration on bonding interface.

Signed-off-by: Zoltan Kiss <schaman@sch.bme.hu>
---
 net/ipv4/devinet.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 37b3c18..bc19bd0 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1134,15 +1134,15 @@ static void inetdev_send_gratuitous_arp(struct net_device *dev,
 					struct in_device *in_dev)
 
 {
-	struct in_ifaddr *ifa = in_dev->ifa_list;
-
-	if (!ifa)
-		return;
+	struct in_ifaddr *ifa;
 
-	arp_send(ARPOP_REQUEST, ETH_P_ARP,
-		 ifa->ifa_local, dev,
-		 ifa->ifa_local, NULL,
-		 dev->dev_addr, NULL);
+	for (ifa = in_dev->ifa_list; ifa;
+	     ifa = ifa->ifa_next) {
+		arp_send(ARPOP_REQUEST, ETH_P_ARP,
+			 ifa->ifa_local, dev,
+			 ifa->ifa_local, NULL,
+			 dev->dev_addr, NULL);
+	}
 }
 
 /* Called only under RTNL semaphore */
-- 
1.7.4.1

