Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab2LMOOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:14:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45044 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321Ab2LMONy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:13:54 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xi Wang <xi.wang@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 212/241] ipv4: avoid undefined behavior in do_ip_setsockopt()
Date: Thu, 13 Dec 2012 11:59:37 -0200
Message-Id: <1355407206-17100-213-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit 0c9f79be295c99ac7e4b569ca493d75fdcc19e4e upstream.

(1<<optname) is undefined behavior in C with a negative optname or
optname larger than 31.  In those cases the result of the shift is
not necessarily zero (e.g., on x86).

This patch simplifies the code with a switch statement on optname.
It also allows the compiler to generate better code (e.g., using a
64-bit mask).

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/ip_sockglue.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 0d11f23..8285f00 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -456,19 +456,28 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	struct inet_sock *inet = inet_sk(sk);
 	int val = 0, err;
 
-	if (((1<<optname) & ((1<<IP_PKTINFO) | (1<<IP_RECVTTL) |
-			     (1<<IP_RECVOPTS) | (1<<IP_RECVTOS) |
-			     (1<<IP_RETOPTS) | (1<<IP_TOS) |
-			     (1<<IP_TTL) | (1<<IP_HDRINCL) |
-			     (1<<IP_MTU_DISCOVER) | (1<<IP_RECVERR) |
-			     (1<<IP_ROUTER_ALERT) | (1<<IP_FREEBIND) |
-			     (1<<IP_PASSSEC) | (1<<IP_TRANSPARENT) |
-			     (1<<IP_MINTTL) | (1<<IP_NODEFRAG))) ||
-	    optname == IP_UNICAST_IF ||
-	    optname == IP_MULTICAST_TTL ||
-	    optname == IP_MULTICAST_ALL ||
-	    optname == IP_MULTICAST_LOOP ||
-	    optname == IP_RECVORIGDSTADDR) {
+	switch (optname) {
+	case IP_PKTINFO:
+	case IP_RECVTTL:
+	case IP_RECVOPTS:
+	case IP_RECVTOS:
+	case IP_RETOPTS:
+	case IP_TOS:
+	case IP_TTL:
+	case IP_HDRINCL:
+	case IP_MTU_DISCOVER:
+	case IP_RECVERR:
+	case IP_ROUTER_ALERT:
+	case IP_FREEBIND:
+	case IP_PASSSEC:
+	case IP_TRANSPARENT:
+	case IP_MINTTL:
+	case IP_NODEFRAG:
+	case IP_UNICAST_IF:
+	case IP_MULTICAST_TTL:
+	case IP_MULTICAST_ALL:
+	case IP_MULTICAST_LOOP:
+	case IP_RECVORIGDSTADDR:
 		if (optlen >= sizeof(int)) {
 			if (get_user(val, (int __user *) optval))
 				return -EFAULT;
-- 
1.7.9.5

