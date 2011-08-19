Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1HSSI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:08:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59380 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab1HSSIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:08:55 -0400
MIME-Version: 1.0
Date: Fri, 19 Aug 2011 21:08:54 +0300
Message-ID: <CAC67Hz_G9cs7zECFmJ9a=twJfEUMja3eBGzAFvryUh+BpTTETw@mail.gmail.com>
Subject: [RFC][PATCH] Failed neighbors attached to routes are not released
From: Guy Yur <guyyur@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The issue I am seeing is with a neighbor used as a gateway in a route,
when the neighbor gets nud FAILED it will not be removed from the
neighbor cache.
The reference count for the neighbor remains > 1 when
neigh_periodic_work() is called.

Issue noticed with IPv6 neighbors on Arch Linux with kernel 3.0.3
kernel config includes CONFIG_IPV6_ROUTER_PREF

The problem affects routing when the neighbor loses connectivity and returns.

Scenario: Using a default route and a static route through different interfaces.
When the neighbor gateway of the static route goes down the traffic
will move to the default gateway as expected.
Once the static route neighbor comes back up it is not asked for
neighbor solicitation
because the route is marked as FAILED and the traffic will continue to
pass through the default gateway.

Steps to reproduce the route not being removed:
1. add an IPv6 address on an interface
2. add a route to a network through a gateway on the interface's network
3. make sure the gateway address is not reachable
4. ping6 a host in the route network
5. "ip -6 nei" will show the gateway neighbor as FAILED and it won't be released

Steps to reproduce the routing problem:
1. client and two gateway machines (A and B)
2. on the client define a static route through A and a default route through B
3. disconnect eth on A
4. ping6 a host in the network that should go through A
   after a while the traffic will move through B which is the default route
5. reconnect eth on A
6. ping6 a host in the network again, the traffic will still go through B
   "ip -6 nei" on the client will still show A as FAILED

Patch to change the nud state to NONE if the reference count > 1 --
allowing the neighbor to be released in a future pass.

--- linux/net/core/neighbour.c.orig	2011-08-19 13:15:35.041524169 +0300
+++ linux/net/core/neighbour.c	2011-08-19 18:19:07.271276096 +0300
@@ -802,14 +802,16 @@ static void neigh_periodic_work(struct w
 			if (time_before(n->used, n->confirmed))
 				n->used = n->confirmed;

-			if (atomic_read(&n->refcnt) == 1 &&
-			    (state == NUD_FAILED ||
+			if ((state == NUD_FAILED ||
 			     time_after(jiffies, n->used + n->parms->gc_staletime))) {
-				*np = n->next;
-				n->dead = 1;
-				write_unlock(&n->lock);
-				neigh_cleanup_and_release(n);
-				continue;
+				if (atomic_read(&n->refcnt) == 1) {
+					*np = n->next;
+					n->dead = 1;
+					write_unlock(&n->lock);
+					neigh_cleanup_and_release(n);
+					continue;
+				} else
+					n->nud_state = NUD_NONE;
 			}
 			write_unlock(&n->lock);
