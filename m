Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935346Ab2C3VIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:08:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55486 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935354Ab2C3VI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:08:28 -0400
Message-Id: <20120330195736.195496360@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:59:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Greear <greearb@candelatech.com>,
        Dave Jones <davej@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 098/108] net: fix a potential rcu_read_lock() imbalance in rt6_fill_node()
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 94f826b8076e2cb92242061e92f21b5baa3eccc2 ]

Commit f2c31e32b378 (net: fix NULL dereferences in check_peer_redir() )
added a regression in rt6_fill_node(), leading to rcu_read_lock()
imbalance.

Thats because NLA_PUT() can make a jump to nla_put_failure label.

Fix this by using nla_put()

Many thanks to Ben Greear for his help

Reported-by: Ben Greear <greearb@candelatech.com>
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2411,8 +2411,12 @@ static int rt6_fill_node(struct net *net
 
 	rcu_read_lock();
 	n = dst_get_neighbour(&rt->dst);
-	if (n)
-		NLA_PUT(skb, RTA_GATEWAY, 16, &n->primary_key);
+	if (n) {
+		if (nla_put(skb, RTA_GATEWAY, 16, &n->primary_key) < 0) {
+			rcu_read_unlock();
+			goto nla_put_failure;
+		}
+	}
 	rcu_read_unlock();
 
 	if (rt->dst.dev)


