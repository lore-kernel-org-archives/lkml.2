Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2JJXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:25:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40027 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757570Ab2JJWyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:54:00 -0400
X-Sasl-enc: E0jFzkCzrOVJimW0jpQRm0Liz4FrL0zX/RX5APlt7LV2 1349909639
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Stephan Springl <springl-k@lar.bfw.de>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 026/133] tcp: fix regression in urgent data handling
Date: Thu, 11 Oct 2012 07:50:52 +0900
Message-Id: <20121010224859.168638738@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1d57f19539c074105791da6384a8ad674bba8037 ]

Stephan Springl found that commit 1402d366019fed "tcp: introduce
tcp_try_coalesce" introduced a regression for rlogin

It turns out problem comes from TCP urgent data handling and
a change in behavior in input path.

rlogin sends two one-byte packets with URG ptr set, and when next data
frame is coalesced, we lack sk_data_ready() calls to wakeup consumer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Stephan Springl <springl-k@lar.bfw.de>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4818,7 +4818,7 @@ queue_and_out:
 
 		if (eaten > 0)
 			kfree_skb_partial(skb, fragstolen);
-		else if (!sock_flag(sk, SOCK_DEAD))
+		if (!sock_flag(sk, SOCK_DEAD))
 			sk->sk_data_ready(sk, 0);
 		return;
 	}
@@ -5680,8 +5680,7 @@ no_ack:
 #endif
 			if (eaten)
 				kfree_skb_partial(skb, fragstolen);
-			else
-				sk->sk_data_ready(sk, 0);
+			sk->sk_data_ready(sk, 0);
 			return 0;
 		}
 	}


