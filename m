Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab2EIGW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:22:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38924 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756223Ab2EIFxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:16 -0400
Message-Id: <20120509055039.667565710@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 071/167] [PATCH 11/26] net: fix a race in sock_queue_err_skb()
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 110c43304db6f06490961529536c362d9ac5732f ]

As soon as an skb is queued into socket error queue, another thread
can consume it, so we are not allowed to reference skb anymore, or risk
use after free.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/skbuff.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3c30ee4..29cb392 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3111,6 +3111,8 @@ static void sock_rmem_free(struct sk_buff *skb)
  */
 int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 {
+	int len = skb->len;
+
 	if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
 	    (unsigned)sk->sk_rcvbuf)
 		return -ENOMEM;
@@ -3125,7 +3127,7 @@ int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 
 	skb_queue_tail(&sk->sk_error_queue, skb);
 	if (!sock_flag(sk, SOCK_DEAD))
-		sk->sk_data_ready(sk, skb->len);
+		sk->sk_data_ready(sk, len);
 	return 0;
 }
 EXPORT_SYMBOL(sock_queue_err_skb);
-- 
1.7.10



