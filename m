Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2JZAIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:08:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:54150 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab2JZAIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Hinnerk Stosch <janhinnerk.stosch@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Mihai Maruseac <mihai.maruseac@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 81/85] ipv6: addrconf: fix /proc/net/if_inet6
Date: Thu, 25 Oct 2012 17:06:39 -0700
Message-Id: <20121026000039.252877015@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9f0d3c2781baa1102108e16efbe640dd74564a7c ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3088,14 +3088,15 @@ static struct inet6_ifaddr *if6_get_firs
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
@@ -3113,18 +3114,20 @@ static struct inet6_ifaddr *if6_get_next
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
 


