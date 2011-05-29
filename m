Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1E2VMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 17:12:10 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:17505 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1E2VMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 17:12:08 -0400
Message-Id: <201105292112.p4TLC6cN017178@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sun, 29 May 2011 16:55:44 -0400
Subject: [PATCH] ip_options_compile: properly handle unaligned pointer
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, <kaber@trash.net>
X-OriginalArrivalTime: 29 May 2011 21:12:07.0265 (UTC) FILETIME=[10F01D10:01CC1E45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code takes an unaligned pointer and does htonl() on it to
make it big-endian, then does a memcpy().  The problem is that the
compiler decides that since the pointer is to a __be32, it is legal
to optimize the copy into a processor word store.  However, on an
architecture that does not handled unaligned writes in kernel space,
this produces an unaligned exception fault.

The solution is to track the pointer as a "char *" (which removes a bunch
of unpleasant casts in any case), and then just use put_unaligned_be32()
to write the value to memory.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 net/ipv4/ip_options.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index 2391b24..a12d33f 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/icmp.h>
@@ -352,7 +353,7 @@ int ip_options_compile(struct net *net,
 				goto error;
 			}
 			if (optptr[2] <= optlen) {
-				__be32 *timeptr = NULL;
+				unsigned char *timeptr = NULL;
 				if (optptr[2]+3 > optptr[1]) {
 					pp_ptr = optptr + 2;
 					goto error;
@@ -361,7 +362,7 @@ int ip_options_compile(struct net *net,
 				      case IPOPT_TS_TSONLY:
 					opt->ts = optptr - iph;
 					if (skb)
-						timeptr = (__be32*)&optptr[optptr[2]-1];
+						timeptr = &optptr[optptr[2]-1];
 					opt->ts_needtime = 1;
 					optptr[2] += 4;
 					break;
@@ -373,7 +374,7 @@ int ip_options_compile(struct net *net,
 					opt->ts = optptr - iph;
 					if (rt)  {
 						memcpy(&optptr[optptr[2]-1], &rt->rt_spec_dst, 4);
-						timeptr = (__be32*)&optptr[optptr[2]+3];
+						timeptr = &optptr[optptr[2]+3];
 					}
 					opt->ts_needaddr = 1;
 					opt->ts_needtime = 1;
@@ -391,7 +392,7 @@ int ip_options_compile(struct net *net,
 						if (inet_addr_type(net, addr) == RTN_UNICAST)
 							break;
 						if (skb)
-							timeptr = (__be32*)&optptr[optptr[2]+3];
+							timeptr = &optptr[optptr[2]+3];
 					}
 					opt->ts_needtime = 1;
 					optptr[2] += 8;
@@ -405,10 +406,10 @@ int ip_options_compile(struct net *net,
 				}
 				if (timeptr) {
 					struct timespec tv;
-					__be32  midtime;
+					u32  midtime;
 					getnstimeofday(&tv);
-					midtime = htonl((tv.tv_sec % 86400) * MSEC_PER_SEC + tv.tv_nsec / NSEC_PER_MSEC);
-					memcpy(timeptr, &midtime, sizeof(__be32));
+					midtime = (tv.tv_sec % 86400) * MSEC_PER_SEC + tv.tv_nsec / NSEC_PER_MSEC;
+					put_unaligned_be32(midtime, timeptr);
 					opt->is_changed = 1;
 				}
 			} else {
-- 
1.6.5.2

