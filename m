Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab0G3S1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:27:48 -0400
Received: from kroah.org ([198.145.64.141]:58270 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759786Ab0G3Rz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:26 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:40 2010
Message-Id: <20100730175140.451142291@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Patrick McHardy <kaber@trash.net>
Subject: [075/205] netfilter: ip6t_REJECT: fix a dst leak in ipv6 REJECT
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 499031ac8a3df6738f6186ded9da853e8ea18253 upstream.

We should release dst if dst->error is set.

Bug introduced in 2.6.14 by commit e104411b82f5c
([XFRM]: Always release dst_entry on error in xfrm_lookup)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/netfilter/ip6t_REJECT.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -96,9 +96,11 @@ static void send_reset(struct net *net,
 	fl.fl_ip_dport = otcph.source;
 	security_skb_classify_flow(oldskb, &fl);
 	dst = ip6_route_output(net, NULL, &fl);
-	if (dst == NULL)
+	if (dst == NULL || dst->error) {
+		dst_release(dst);
 		return;
-	if (dst->error || xfrm_lookup(net, &dst, &fl, NULL, 0))
+	}
+	if (xfrm_lookup(net, &dst, &fl, NULL, 0))
 		return;
 
 	hh_len = (dst->dev->hard_header_len + 15)&~15;


