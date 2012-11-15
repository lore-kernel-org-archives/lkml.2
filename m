Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993083Ab2KOEbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:31:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:49395 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993055Ab2KOELy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pavel Emelyanov <xemul@parallels.com>,
        Giorgos Mavrikas <gmavrikas@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 53/66] tcp-repair: Handle zero-length data put in rcv queue
Date: Wed, 14 Nov 2012 20:10:58 -0800
Message-Id: <20121115040942.963040043@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Pavel Emelyanov <xemul@parallels.com>

[ Upstream commit c454e6111d1ef4268fe98e87087216e51c2718c3 ]

When sending data into a tcp socket in repair state we should check
for the amount of data being 0 explicitly. Otherwise we'll have an skb
with seq == end_seq in rcv queue, but tcp doesn't expect this to happen
(in particular a warn_on in tcp_recvmsg shoots).

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Reported-by: Giorgos Mavrikas <gmavrikas@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4556,6 +4556,9 @@ int tcp_send_rcvq(struct sock *sk, struc
 	struct tcphdr *th;
 	bool fragstolen;
 
+	if (size == 0)
+		return 0;
+
 	skb = alloc_skb(size + sizeof(*th), sk->sk_allocation);
 	if (!skb)
 		goto err;


