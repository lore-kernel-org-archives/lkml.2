Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab1DYUbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:31:44 -0400
Received: from 1wt.eu ([62.212.114.60]:34596 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455Ab1DYUZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:26 -0400
Message-Id: <20110425200240.468187050@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: "Steven J. Magnani" <steve@digidescorp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 172/173] net: Fix oops from tcp_collapse() when using splice()
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven J. Magnani <steve@digidescorp.com>

commit baff42ab1494528907bf4d5870359e31711746ae upstream.

tcp_read_sock() can have a eat skbs without immediately advancing copied_seq.
This can cause a panic in tcp_collapse() if it is called as a result
of the recv_actor dropping the socket lock.

A userspace program that splices data from a socket to either another
socket or to a file can trigger this bug.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6afb6d8..2c75f89 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1368,6 +1368,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		sk_eat_skb(sk, skb, 0);
 		if (!desc->count)
 			break;
+		tp->copied_seq = seq;
 	}
 	tp->copied_seq = seq;
 


