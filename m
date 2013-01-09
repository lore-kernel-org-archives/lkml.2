Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab3AIVqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:46:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:41704 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021Ab3AIUho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Vijay Subramanian <subramanian.vijay@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Kiran Kumar Kella <kkiran@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 34/47] tcp: refine SYN handling in tcp_validate_incoming
Date: Wed,  9 Jan 2013 12:35:29 -0800
Message-Id: <20130109201733.404367853@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e371589917011efe6ff8c7dfb4e9e81934ac5855 ]

Followup of commit 0c24604b68fc (tcp: implement RFC 5961 4.2)

As reported by Vijay Subramanian, we should send a challenge ACK
instead of a dup ack if a SYN flag is set on a packet received out of
window.

This permits the ratelimiting to work as intended, and to increase
correct SNMP counters.

Suggested-by: Vijay Subramanian <subramanian.vijay@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Vijay Subramanian <subramanian.vijay@gmail.com>
Cc: Kiran Kumar Kella <kkiran@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5214,8 +5214,11 @@ static bool tcp_validate_incoming(struct
 		 * an acknowledgment should be sent in reply (unless the RST
 		 * bit is set, if so drop the segment and return)".
 		 */
-		if (!th->rst)
+		if (!th->rst) {
+			if (th->syn)
+				goto syn_challenge;
 			tcp_send_dupack(sk, skb);
+		}
 		goto discard;
 	}
 
@@ -5245,6 +5248,7 @@ static bool tcp_validate_incoming(struct
 	 * RFC 5691 4.2 : Send a challenge ack
 	 */
 	if (th->syn) {
+syn_challenge:
 		if (syn_inerr)
 			TCP_INC_STATS_BH(sock_net(sk), TCP_MIB_INERRS);
 		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);


