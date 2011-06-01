Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161599Ab1FAILa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:11:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161590Ab1FAILY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:11:24 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:20 2011
Message-Id: <20110601080319.077836473@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:54 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [058/146] Revert "tcp: disallow bind() to reuse addr/port"
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 3e8c806a08c7beecd972e7ce15c570b9aba64baa ]

This reverts commit c191a836a908d1dd6b40c503741f91b914de3348.

It causes known regressions for programs that expect to be able to use
SO_REUSEADDR to shutdown a socket, then successfully rebind another
socket to the same ID.

Programs such as haproxy and amavisd expect this to work.

This should fix kernel bugzilla 32832.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/inet_connection_sock.c  |    5 ++---
 net/ipv6/inet6_connection_sock.c |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -73,7 +73,7 @@ int inet_csk_bind_conflict(const struct
 		     !sk2->sk_bound_dev_if ||
 		     sk->sk_bound_dev_if == sk2->sk_bound_dev_if)) {
 			if (!reuse || !sk2->sk_reuse ||
-			    ((1 << sk2->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))) {
+			    sk2->sk_state == TCP_LISTEN) {
 				const __be32 sk2_rcv_saddr = sk_rcv_saddr(sk2);
 				if (!sk2_rcv_saddr || !sk_rcv_saddr(sk) ||
 				    sk2_rcv_saddr == sk_rcv_saddr(sk))
@@ -122,8 +122,7 @@ again:
 					    (tb->num_owners < smallest_size || smallest_size == -1)) {
 						smallest_size = tb->num_owners;
 						smallest_rover = rover;
-						if (atomic_read(&hashinfo->bsockets) > (high - low) + 1 &&
-						    !inet_csk(sk)->icsk_af_ops->bind_conflict(sk, tb)) {
+						if (atomic_read(&hashinfo->bsockets) > (high - low) + 1) {
 							spin_unlock(&head->lock);
 							snum = smallest_rover;
 							goto have_snum;
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -44,7 +44,7 @@ int inet6_csk_bind_conflict(const struct
 		     !sk2->sk_bound_dev_if ||
 		     sk->sk_bound_dev_if == sk2->sk_bound_dev_if) &&
 		    (!sk->sk_reuse || !sk2->sk_reuse ||
-		     ((1 << sk2->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))) &&
+		     sk2->sk_state == TCP_LISTEN) &&
 		     ipv6_rcv_saddr_equal(sk, sk2))
 			break;
 	}


