Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0C3Upd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:45:33 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:24394 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab0C3Upb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:45:31 -0400
X-Spam-Processed: digidescorp.com, Tue, 30 Mar 2010 15:45:30 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.144.237.51
X-Return-Path: prvs=1705e26b8f=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
From: "Steven J. Magnani" <steve@digidescorp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       James Morris <jmorris@namei.org>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
       monstr@monstr.eu, Karl Hiramoto <karl@hiramoto.org>,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] net: Fix oops from tcp_collapse() when using splice()
Date: Tue, 30 Mar 2010 15:45:13 -0500
Message-Id: <1269981913-18073-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tcp_read_sock() can have a eat skbs without immediately advancing copied_seq.
This can cause a panic in tcp_collapse() if it is called as a result
of the recv_actor dropping the socket lock.

A userspace program that splices data from a socket to either another
socket or to a file can trigger this bug.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/net/ipv4/tcp.c b/net/ipv4/tcp.c
--- a/net/ipv4/tcp.c	2010-03-30 15:25:55.000000000 -0500
+++ b/net/ipv4/tcp.c	2010-03-30 15:27:49.000000000 -0500
@@ -1335,6 +1335,7 @@ int tcp_read_sock(struct sock *sk, read_
 		sk_eat_skb(sk, skb, 0);
 		if (!desc->count)
 			break;
+		tp->copied_seq = seq;
 	}
 	tp->copied_seq = seq;
 

