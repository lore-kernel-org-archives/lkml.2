Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab2LMOME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:12:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44879 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123Ab2LMOL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        Mihai Maruseac <mihai.maruseac@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 181/241] ipv6: addrconf: fix /proc/net/if_inet6
Date: Thu, 13 Dec 2012 11:59:06 -0200
Message-Id: <1355407206-17100-182-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 9f0d3c2781baa1102108e16efbe640dd74564a7c upstream.

Commit 1d5783030a1 (ipv6/addrconf: speedup /proc/net/if_inet6 filling)
added bugs hiding some devices from if_inet6 and breaking applications.

"ip -6 addr" could still display all IPv6 addresses, while "ifconfig -a"
couldnt.

One way to reproduce the bug is by starting in a shell :

unshare -n /bin/bash
ifconfig lo up

And in original net namespace, lo device disappeared from if_inet6

Reported-by: Jan Hinnerk Stosch <janhinnerk.stosch@gmail.com>
Tested-by: Jan Hinnerk Stosch <janhinnerk.stosch@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mihai Maruseac <mihai.maruseac@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv6/addrconf.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 0344f8e..0808ad5 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3093,14 +3093,15 @@ static struct inet6_ifaddr *if6_get_first(struct seq_file *seq, loff_t pos)
 		struct hlist_node *n;
 		hlist_for_each_entry_rcu_bh(ifa, n, &inet6_addr_lst[state->bucket],
 					 addr_lst) {
+			if (!net_eq(dev_net(ifa->idev->dev), net))
+				continue;
 			/* sync with offset */
 			if (p < state->offset) {
 				p++;
 				continue;
 			}
 			state->offset++;
-			if (net_eq(dev_net(ifa->idev->dev), net))
-				return ifa;
+			return ifa;
 		}
 
 		/* prepare for next bucket */
@@ -3118,18 +3119,20 @@ static struct inet6_ifaddr *if6_get_next(struct seq_file *seq,
 	struct hlist_node *n = &ifa->addr_lst;
 
 	hlist_for_each_entry_continue_rcu_bh(ifa, n, addr_lst) {
+		if (!net_eq(dev_net(ifa->idev->dev), net))
+			continue;
 		state->offset++;
-		if (net_eq(dev_net(ifa->idev->dev), net))
-			return ifa;
+		return ifa;
 	}
 
 	while (++state->bucket < IN6_ADDR_HSIZE) {
 		state->offset = 0;
 		hlist_for_each_entry_rcu_bh(ifa, n,
 				     &inet6_addr_lst[state->bucket], addr_lst) {
+			if (!net_eq(dev_net(ifa->idev->dev), net))
+				continue;
 			state->offset++;
-			if (net_eq(dev_net(ifa->idev->dev), net))
-				return ifa;
+			return ifa;
 		}
 	}
 
-- 
1.7.9.5

