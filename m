Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab0EJX3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:29:14 -0400
Received: from kroah.org ([198.145.64.141]:33367 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab0EJWwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:51 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:25 2010
Message-Id: <20100510223325.870688593@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Jorge Boncompte [DTI2]" <jorge@dti2.net>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [094/117] udp: fix for unicast RX path optimization
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jorge Boncompte [DTI2] <jorge@dti2.net>

[ Upstream commit 1223c67c0938d2df309fde618bd82c87c8c1af04 ]

Commits 5051ebd275de672b807c28d93002c2fb0514a3c9 and
5051ebd275de672b807c28d93002c2fb0514a3c9 ("ipv[46]: udp: optimize unicast RX
path") broke some programs.

	After upgrading a L2TP server to 2.6.33 it started to fail, tunnels going up an
down, after the 10th tunnel came up. My modified rp-l2tp uses a global
unconnected socket bound to (INADDR_ANY, 1701) and one connected socket per
tunnel after parameter negotiation.

	After ten sockets were open and due to mixed parameters to
udp[46]_lib_lookup2() kernel started to drop packets.

Signed-off-by: Jorge Boncompte [DTI2] <jorge@dti2.net>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/udp.c |    4 ++--
 net/ipv6/udp.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -471,8 +471,8 @@ static struct sock *__udp4_lib_lookup(st
 			if (hslot->count < hslot2->count)
 				goto begin;
 
-			result = udp4_lib_lookup2(net, INADDR_ANY, sport,
-						  daddr, hnum, dif,
+			result = udp4_lib_lookup2(net, saddr, sport,
+						  INADDR_ANY, hnum, dif,
 						  hslot2, slot2);
 		}
 		rcu_read_unlock();
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -258,8 +258,8 @@ static struct sock *__udp6_lib_lookup(st
 			if (hslot->count < hslot2->count)
 				goto begin;
 
-			result = udp6_lib_lookup2(net, &in6addr_any, sport,
-						  daddr, hnum, dif,
+			result = udp6_lib_lookup2(net, saddr, sport,
+						  &in6addr_any, hnum, dif,
 						  hslot2, slot2);
 		}
 		rcu_read_unlock();


