Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2B1BGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:06:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48212 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab2B1BGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.74.74 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010208.704235436@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Graf <tgraf@suug.ch>,
        Jesper Dangaard Brouer <hawk@comx.dk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 28/73] net: Dont proxy arp respond if iif == rt->dst.dev if private VLAN is disabled
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Thomas Graf <tgraf@suug.ch>

[ Upstream commit 70620c46ac2b45c24b0f22002fdf5ddd1f7daf81 ]

Commit 653241 (net: RFC3069, private VLAN proxy arp support) changed
the behavior of arp proxy to send arp replies back out on the interface
the request came in even if the private VLAN feature is disabled.

Previously we checked rt->dst.dev != skb->dev for in scenarios, when
proxy arp is enabled on for the netdevice and also when individual proxy
neighbour entries have been added.

This patch adds the check back for the pneigh_lookup() scenario.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Acked-by: Jesper Dangaard Brouer <hawk@comx.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/arp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -906,7 +906,8 @@ static int arp_process(struct sk_buff *s
 			if (addr_type == RTN_UNICAST  &&
 			    (arp_fwd_proxy(in_dev, dev, rt) ||
 			     arp_fwd_pvlan(in_dev, dev, rt, sip, tip) ||
-			     pneigh_lookup(&arp_tbl, net, &tip, dev, 0))) {
+			     (rt->dst.dev != dev &&
+			      pneigh_lookup(&arp_tbl, net, &tip, dev, 0)))) {
 				n = neigh_event_ns(&arp_tbl, sha, &sip, dev);
 				if (n)
 					neigh_release(n);


