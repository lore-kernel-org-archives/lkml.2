Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2JGXWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:22:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38267 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab2JGXWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:12 -0400
Message-Id: <20121007225847.286070400@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 091/108] ipv6: release reference of ip6_null_entrys dst entry  in __ip6_del_rt
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit 6825a26c2dc21eb4f8df9c06d3786ddec97cf53b ]

as we hold dst_entry before we call __ip6_del_rt,
so we should alse call dst_release not only return
-ENOENT when the rt6_info is ip6_null_entry.

and we already hold the dst entry, so I think it's
safe to call dst_release out of the write-read lock.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/route.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2e21751..488a1b7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1435,17 +1435,18 @@ static int __ip6_del_rt(struct rt6_info *rt, struct nl_info *info)
 	struct fib6_table *table;
 	struct net *net = dev_net(rt->rt6i_dev);
 
-	if (rt == net->ipv6.ip6_null_entry)
-		return -ENOENT;
+	if (rt == net->ipv6.ip6_null_entry) {
+		err = -ENOENT;
+		goto out;
+	}
 
 	table = rt->rt6i_table;
 	write_lock_bh(&table->tb6_lock);
-
 	err = fib6_del(rt, info);
-	dst_release(&rt->dst);
-
 	write_unlock_bh(&table->tb6_lock);
 
+out:
+	dst_release(&rt->dst);
 	return err;
 }
 


