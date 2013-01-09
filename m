Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab3AIUhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:37:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:41554 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021Ab3AIUhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 11/80] inet_diag: avoid unsafe and nonsensical prefix matches in inet_diag_bc_run()
Date: Wed,  9 Jan 2013 12:35:03 -0800
Message-Id: <20130109201501.836947791@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit f67caec9068cee426ec23cf9005a1dee2ecad187 ]

Add logic to check the address family of the user-supplied conditional
and the address family of the connection entry. We now do not do
prefix matching of addresses from different address families (AF_INET
vs AF_INET6), except for the previously existing support for having an
IPv4 prefix match an IPv4-mapped IPv6 address (which this commit
maintains as-is).

This change is needed for two reasons:

(1) The addresses are different lengths, so comparing a 128-bit IPv6
prefix match condition to a 32-bit IPv4 connection address can cause
us to unwittingly walk off the end of the IPv4 address and read
garbage or oops.

(2) The IPv4 and IPv6 address spaces are semantically distinct, so a
simple bit-wise comparison of the prefixes is not meaningful, and
would lead to bogus results (except for the IPv4-mapped IPv6 case,
which this commit maintains).

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_diag.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -423,25 +423,31 @@ static int inet_diag_bc_run(const struct
 				break;
 			}
 
-			if (cond->prefix_len == 0)
-				break;
-
 			if (op->code == INET_DIAG_BC_S_COND)
 				addr = entry->saddr;
 			else
 				addr = entry->daddr;
 
+			if (cond->family != AF_UNSPEC &&
+			    cond->family != entry->family) {
+				if (entry->family == AF_INET6 &&
+				    cond->family == AF_INET) {
+					if (addr[0] == 0 && addr[1] == 0 &&
+					    addr[2] == htonl(0xffff) &&
+					    bitstring_match(addr + 3,
+							    cond->addr,
+							    cond->prefix_len))
+						break;
+				}
+				yes = 0;
+				break;
+			}
+
+			if (cond->prefix_len == 0)
+				break;
 			if (bitstring_match(addr, cond->addr,
 					    cond->prefix_len))
 				break;
-			if (entry->family == AF_INET6 &&
-			    cond->family == AF_INET) {
-				if (addr[0] == 0 && addr[1] == 0 &&
-				    addr[2] == htonl(0xffff) &&
-				    bitstring_match(addr + 3, cond->addr,
-						    cond->prefix_len))
-					break;
-			}
 			yes = 0;
 			break;
 		}


