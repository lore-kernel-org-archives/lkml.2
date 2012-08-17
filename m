Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030874Ab2HQDfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:35:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46731 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030624Ab2HQD0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:54 -0400
Message-Id: <20120817030245.336458529@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Benc <jbenc@redhat.com>,
        Max Matveev <makc@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 10/37] net: fix rtnetlink IFF_PROMISC and IFF_ALLMULTI  handling
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit b1beb681cba5358f62e6187340660ade226a5fcc ]

When device flags are set using rtnetlink, IFF_PROMISC and IFF_ALLMULTI
flags are handled specially. Function dev_change_flags sets IFF_PROMISC and
IFF_ALLMULTI bits in dev->gflags according to the passed value but
do_setlink passes a result of rtnl_dev_combine_flags which takes those bits
from dev->flags.

This can be easily trigerred by doing:

tcpdump -i eth0 &
ip l s up eth0

ip sets IFF_UP flag in ifi_flags and ifi_change, which is combined with
IFF_PROMISC by rtnl_dev_combine_flags, causing __dev_change_flags to set
IFF_PROMISC in gflags.

Reported-by: Max Matveev <makc@redhat.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/rtnetlink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2ef859a..88bcf76 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -670,6 +670,12 @@ static void set_operstate(struct net_device *dev, unsigned char transition)
 	}
 }
 
+static unsigned int rtnl_dev_get_flags(const struct net_device *dev)
+{
+	return (dev->flags & ~(IFF_PROMISC | IFF_ALLMULTI)) |
+	       (dev->gflags & (IFF_PROMISC | IFF_ALLMULTI));
+}
+
 static unsigned int rtnl_dev_combine_flags(const struct net_device *dev,
 					   const struct ifinfomsg *ifm)
 {
@@ -678,7 +684,7 @@ static unsigned int rtnl_dev_combine_flags(const struct net_device *dev,
 	/* bugwards compatibility: ifi_change == 0 is treated as ~0 */
 	if (ifm->ifi_change)
 		flags = (flags & ifm->ifi_change) |
-			(dev->flags & ~ifm->ifi_change);
+			(rtnl_dev_get_flags(dev) & ~ifm->ifi_change);
 
 	return flags;
 }


