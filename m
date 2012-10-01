Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab2JAXAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:00:44 -0400
Received: from 1wt.eu ([62.212.114.60]:35195 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932683Ab2JAXAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:38 -0400
Message-Id: <20121001225200.909225352@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 078/180] net: fix a race in sock_queue_err_skb()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 110c43304db6f06490961529536c362d9ac5732f ]

As soon as an skb is queued into socket error queue, another thread
can consume it, so we are not allowed to reference skb anymore, or risk
use after free.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/skbuff.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 025f924..72ff527 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2989,6 +2989,8 @@ static void sock_rmem_free(struct sk_buff *skb)
  */
 int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 {
+	int len = skb->len;
+
 	if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
 	    (unsigned)sk->sk_rcvbuf)
 		return -ENOMEM;
@@ -3000,7 +3002,7 @@ int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 
 	skb_queue_tail(&sk->sk_error_queue, skb);
 	if (!sock_flag(sk, SOCK_DEAD))
-		sk->sk_data_ready(sk, skb->len);
+		sk->sk_data_ready(sk, len);
 	return 0;
 }
 EXPORT_SYMBOL(sock_queue_err_skb);
-- 
1.7.2.1.45.g54fbc



