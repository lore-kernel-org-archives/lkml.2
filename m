Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161628Ab1FAJUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:20:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161328Ab1FAILt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:11:49 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:24 2011
Message-Id: <20110601080323.623873577@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:58 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David L Stevens <dlstevens@us.ibm.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [062/146] igmp: call ip_mc_clear_src() only when we have no users of ip_mc_list
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 24cf3af3fed5edcf90bc2a0ed181e6ce1513d2dc ]

In igmp_group_dropped() we call ip_mc_clear_src(), which resets the number
of source filters per mulitcast. However, igmp_group_dropped() is also
called on NETDEV_DOWN, NETDEV_PRE_TYPE_CHANGE and NETDEV_UNREGISTER, which
means that the group might get added back on NETDEV_UP, NETDEV_REGISTER and
NETDEV_POST_TYPE_CHANGE respectively, leaving us with broken source
filters.

To fix that, we must clear the source filters only when there are no users
in the ip_mc_list, i.e. in ip_mc_dec_group() and on device destroy.

Acked-by: David L Stevens <dlstevens@us.ibm.com>
Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/igmp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1172,20 +1172,18 @@ static void igmp_group_dropped(struct ip
 
 	if (!in_dev->dead) {
 		if (IGMP_V1_SEEN(in_dev))
-			goto done;
+			return;
 		if (IGMP_V2_SEEN(in_dev)) {
 			if (reporter)
 				igmp_send_report(in_dev, im, IGMP_HOST_LEAVE_MESSAGE);
-			goto done;
+			return;
 		}
 		/* IGMPv3 */
 		igmpv3_add_delrec(in_dev, im);
 
 		igmp_ifc_event(in_dev);
 	}
-done:
 #endif
-	ip_mc_clear_src(im);
 }
 
 static void igmp_group_added(struct ip_mc_list *im)
@@ -1322,6 +1320,7 @@ void ip_mc_dec_group(struct in_device *i
 				*ip = i->next_rcu;
 				in_dev->mc_count--;
 				igmp_group_dropped(i);
+				ip_mc_clear_src(i);
 
 				if (!in_dev->dead)
 					ip_rt_multicast_event(in_dev);
@@ -1431,7 +1430,8 @@ void ip_mc_destroy_dev(struct in_device
 		in_dev->mc_list = i->next_rcu;
 		in_dev->mc_count--;
 
-		igmp_group_dropped(i);
+		/* We've dropped the groups in ip_mc_down already */
+		ip_mc_clear_src(i);
 		ip_ma_put(i);
 	}
 }


