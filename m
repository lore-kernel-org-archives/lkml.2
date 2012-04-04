Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2DDJNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 05:13:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40051 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2DDJNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 05:13:06 -0400
Date: Wed, 4 Apr 2012 12:13:00 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH] ipv6: Fix 'inet6_rtm_getroute' to release 'rt->dst' in case
 of 'alloc_skb' failure
Message-ID: <20120404121300.2e05437b@pixies.home.jungo.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 72331bc [ipv6: Fix RTM_GETROUTE's interpretation of RTA_IIF to be
consistent with ipv4] the code of 'inet6_rtm_getroute()' was re-ordered
such that the reference to 'rt->dst' is incremented prior skb
allocation.

Hence, if 'alloc_skb()' fails, must drop a reference from 'rt->dst'.
Add the missing 'dst_release()' call.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1178345..00b987c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2581,6 +2581,7 @@ static int inet6_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr* nlh, void
 
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb) {
+		dst_release(&rt->dst);
 		err = -ENOBUFS;
 		goto errout;
 	}
