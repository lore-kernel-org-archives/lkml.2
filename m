Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab2KVWhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:37:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:49010 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab2KVSdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Xi Wang <xi.wang@gmail.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 54/83] ipv4: avoid undefined behavior in do_ip_setsockopt()
Date: Wed, 21 Nov 2012 16:42:16 -0800
Message-Id: <20121122004218.511820450@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Xi Wang <xi.wang@gmail.com>

[ Upstream commit 0c9f79be295c99ac7e4b569ca493d75fdcc19e4e ]

(1<<optname) is undefined behavior in C with a negative optname or
optname larger than 31.  In those cases the result of the shift is
not necessarily zero (e.g., on x86).

This patch simplifies the code with a switch statement on optname.
It also allows the compiler to generate better code (e.g., using a
64-bit mask).

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_sockglue.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -457,19 +457,28 @@ static int do_ip_setsockopt(struct sock
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


