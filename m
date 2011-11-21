Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1KUKWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:22:03 -0500
Received: from mail-dy0-f46.google.com ([209.85.220.46]:52144 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab1KUKWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:22:01 -0500
Message-ID: <1321870915.2552.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [BUG] 3.2-rc2: BUG kmalloc-8: Redzone overwritten
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: David Miller <davem@davemloft.net>, Matt Mackall <mpm@selenic.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Mon, 21 Nov 2011 11:21:55 +0100
In-Reply-To: <1321870529.2552.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1321866845.3831.7.camel@lappy>
	 <1321870529.2552.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 21 novembre 2011 à 11:15 +0100, Eric Dumazet a écrit :

> 
> Hmm, trinity tries to crash decnet ;)
> 
> Maybe we should remove this decnet stuff for good instead of tracking
> all bugs just for the record. Is there anybody still using decnet ?
> 
> For example dn_start_slow_timer() starts a timer without holding a
> reference on struct sock, this is highly suspect.
> 
> [PATCH] decnet: proper socket refcounting
> 
> Better use sk_reset_timer() / sk_stop_timer() helpers to make sure we
> dont access already freed/reused memory later.
> 
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Hmm, I forgot to remove the sock_hold(sk) call from dn_slow_timer(),
here is V2 :

[PATCH] decnet: proper socket refcounting

Better use sk_reset_timer() / sk_stop_timer() helpers to make sure we
dont access already freed/reused memory later.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
V2: remove sock_hold(sk) call from dn_slow_timer()

 net/decnet/dn_timer.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/decnet/dn_timer.c b/net/decnet/dn_timer.c
index 67f691b..d9c150c 100644
--- a/net/decnet/dn_timer.c
+++ b/net/decnet/dn_timer.c
@@ -36,16 +36,13 @@ static void dn_slow_timer(unsigned long arg);
 
 void dn_start_slow_timer(struct sock *sk)
 {
-	sk->sk_timer.expires	= jiffies + SLOW_INTERVAL;
-	sk->sk_timer.function	= dn_slow_timer;
-	sk->sk_timer.data	= (unsigned long)sk;
-
-	add_timer(&sk->sk_timer);
+	setup_timer(&sk->sk_timer, dn_slow_timer, (unsigned long)sk);
+	sk_reset_timer(sk, &sk->sk_timer, jiffies + SLOW_INTERVAL);
 }
 
 void dn_stop_slow_timer(struct sock *sk)
 {
-	del_timer(&sk->sk_timer);
+	sk_stop_timer(sk, &sk->sk_timer);
 }
 
 static void dn_slow_timer(unsigned long arg)
@@ -53,12 +50,10 @@ static void dn_slow_timer(unsigned long arg)
 	struct sock *sk = (struct sock *)arg;
 	struct dn_scp *scp = DN_SK(sk);
 
-	sock_hold(sk);
 	bh_lock_sock(sk);
 
 	if (sock_owned_by_user(sk)) {
-		sk->sk_timer.expires = jiffies + HZ / 10;
-		add_timer(&sk->sk_timer);
+		sk_reset_timer(sk, &sk->sk_timer, jiffies + HZ / 10);
 		goto out;
 	}
 
@@ -100,9 +95,7 @@ static void dn_slow_timer(unsigned long arg)
 			scp->keepalive_fxn(sk);
 	}
 
-	sk->sk_timer.expires = jiffies + SLOW_INTERVAL;
-
-	add_timer(&sk->sk_timer);
+	sk_reset_timer(sk, &sk->sk_timer, jiffies + SLOW_INTERVAL);
 out:
 	bh_unlock_sock(sk);
 	sock_put(sk);


