Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031377Ab2HGWrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:47:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031343Ab2HGWrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:47:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Max Matveev <makc@redhat.com>, Jiri Benc <jbenc@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 37/49] net: fix rtnetlink IFF_PROMISC and IFF_ALLMULTI handling
Date: Tue,  7 Aug 2012 15:44:55 -0700
Message-Id: <20120807222030.184332865@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -647,6 +647,12 @@ static void set_operstate(struct net_dev
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
@@ -655,7 +661,7 @@ static unsigned int rtnl_dev_combine_fla
 	/* bugwards compatibility: ifi_change == 0 is treated as ~0 */
 	if (ifm->ifi_change)
 		flags = (flags & ifm->ifi_change) |
-			(dev->flags & ~ifm->ifi_change);
+			(rtnl_dev_get_flags(dev) & ~ifm->ifi_change);
 
 	return flags;
 }


