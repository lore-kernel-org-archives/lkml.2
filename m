Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1ABHY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:36703 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1ABHYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tom Marshall <tdm.code@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 199/260] tcp: Fix race in tcp_poll
Date: Sun,  2 Jan 2011 02:18:15 -0500
Message-Id: <1293952756-15010-200-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:48.0651 (UTC) FILETIME=[FF882FB0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Marshall <tdm.code@gmail.com>

commit a4d258036ed9b2a1811c3670c6099203a0f284a0 upstream.

If a RST comes in immediately after checking sk->sk_err, tcp_poll will
return POLLIN but not POLLOUT.  Fix this by checking sk->sk_err at the end
of tcp_poll.  Additionally, ensure the correct order of operations on SMP
machines with memory barriers.

Signed-off-by: Tom Marshall <tdm.code@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/tcp.c       |    7 +++++--
 net/ipv4/tcp_input.c |    2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1b40924..3fa16d9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -388,8 +388,6 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	 */
 
 	mask = 0;
-	if (sk->sk_err)
-		mask = POLLERR;
 
 	/*
 	 * POLLHUP is certainly not done right. But poll() doesn't
@@ -459,6 +457,11 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		if (tp->urg_data & TCP_URG_VALID)
 			mask |= POLLPRI;
 	}
+	/* This barrier is coupled with smp_wmb() in tcp_reset() */
+	smp_rmb();
+	if (sk->sk_err)
+		mask |= POLLERR;
+
 	return mask;
 }
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f240f57..dd0c9af 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4040,6 +4040,8 @@ static void tcp_reset(struct sock *sk)
 	default:
 		sk->sk_err = ECONNRESET;
 	}
+	/* This barrier is coupled with smp_rmb() in tcp_poll() */
+	smp_wmb();
 
 	if (!sock_flag(sk, SOCK_DEAD))
 		sk->sk_error_report(sk);
-- 
1.7.3.3

