Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2HFNzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:55:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37562 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2HFNzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:55:37 -0400
Date: Mon, 6 Aug 2012 17:55:29 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ip: fix error handling in ip_finish_output2()
Message-ID: <20120806135529.GA30699@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__neigh_create() returns either a pointer to struct neighbour or PTR_ERR().
But the caller expects it to return either a pointer or NULL.  Replace
the NULL check with IS_ERR() check.

The bug was introduced in a263b3093641fb1ec377582c90986a7fd0625184.

Signed-off-by: Vasily Kulikov <segoon@openwall.com>
---
 Compile tested only.

 net/ipv4/ip_output.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index ba39a52..76dde25 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -197,7 +197,7 @@ static inline int ip_finish_output2(struct sk_buff *skb)
 	neigh = __ipv4_neigh_lookup_noref(dev, nexthop);
 	if (unlikely(!neigh))
 		neigh = __neigh_create(&arp_tbl, &nexthop, dev, false);
-	if (neigh) {
+	if (!IS_ERR(neigh)) {
 		int res = dst_neigh_output(dst, neigh, skb);
 
 		rcu_read_unlock_bh();
-- 
1.7.0.4
