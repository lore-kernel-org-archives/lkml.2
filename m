Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2DWHYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:24:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53415 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2DWHYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:24:33 -0400
Date: Mon, 23 Apr 2012 03:22:24 -0400 (EDT)
Message-Id: <20120423.032224.814734981507451327.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ncardwell@google.com
Subject: Re: linux-next: build warning after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120423165409.d424daced95611012d151aa6@canb.auug.org.au>
References: <20120423165409.d424daced95611012d151aa6@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Apr 2012 00:22:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 23 Apr 2012 16:54:09 +1000

> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> ppc44x_defconfig) produced these warnings:
> 
> net/ipv4/tcp_ipv4.c: In function 'tcp_v4_init_sock':
> net/ipv4/tcp_ipv4.c:1891:19: warning: unused variable 'tp' [-Wunused-variable]
> net/ipv6/tcp_ipv6.c: In function 'tcp_v6_init_sock':
> net/ipv6/tcp_ipv6.c:1836:19: warning: unused variable 'tp' [-Wunused-variable]
> 
> Introduced by commit 900f65d361d3 ("tcp: move duplicate code from
> tcp_v4_init_sock()/tcp_v6_init_sock()").

Thanks, I just pushed the following:

--------------------
tcp: Fix build warning after tcp_{v4,v6}_init_sock consolidation.

net/ipv4/tcp_ipv4.c: In function 'tcp_v4_init_sock':
net/ipv4/tcp_ipv4.c:1891:19: warning: unused variable 'tp' [-Wunused-variable]
net/ipv6/tcp_ipv6.c: In function 'tcp_v6_init_sock':
net/ipv6/tcp_ipv6.c:1836:19: warning: unused variable 'tp' [-Wunused-variable]

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_ipv4.c |    3 +--
 net/ipv6/tcp_ipv6.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5b07ea1..0883921 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1888,14 +1888,13 @@ static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
 static int tcp_v4_init_sock(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	struct tcp_sock *tp = tcp_sk(sk);
 
 	tcp_init_sock(sk);
 
 	icsk->icsk_af_ops = &ipv4_specific;
 
 #ifdef CONFIG_TCP_MD5SIG
-	tp->af_specific = &tcp_sock_ipv4_specific;
+	tcp_sk(sk)->af_specific = &tcp_sock_ipv4_specific;
 #endif
 
 	return 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 24dac6b..8044f6a 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1829,14 +1829,13 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific = {
 static int tcp_v6_init_sock(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	struct tcp_sock *tp = tcp_sk(sk);
 
 	tcp_init_sock(sk);
 
 	icsk->icsk_af_ops = &ipv6_specific;
 
 #ifdef CONFIG_TCP_MD5SIG
-	tp->af_specific = &tcp_sock_ipv6_specific;
+	tcp_sk(sk)->af_specific = &tcp_sock_ipv6_specific;
 #endif
 
 	return 0;
-- 
1.7.10

