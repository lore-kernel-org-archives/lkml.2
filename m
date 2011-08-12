Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1HNQId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:08:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab1HNQI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:56 2011
Message-Id: <20110812210556.482390538@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zoltan Kiss <schaman@sch.bme.hu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [50/90] IPv4: Send gratuitous ARP for secondary IP addresses also
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Zoltan Kiss <schaman@sch.bme.hu>

[ Upstream commit b76d0789c92a816a5539dc14232a700b8d62a53a ]

If a device event generates gratuitous ARP messages, only primary
address is used for sending. This patch iterates through the whole
list. Tested with 2 IP addresses configuration on bonding interface.

Signed-off-by: Zoltan Kiss <schaman@sch.bme.hu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/devinet.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1134,15 +1134,15 @@ static void inetdev_send_gratuitous_arp(
 					struct in_device *in_dev)
 
 {
-	struct in_ifaddr *ifa = in_dev->ifa_list;
+	struct in_ifaddr *ifa;
 
-	if (!ifa)
-		return;
-
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


