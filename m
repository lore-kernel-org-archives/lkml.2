Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab0JVSsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:48:30 -0400
Received: from kroah.org ([198.145.64.141]:45790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758093Ab0JVSis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:48 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:36:00 2010
Message-Id: <20101022183559.952332829@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tom Marshall <tdm.code@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [42/66] tcp: Fix race in tcp_poll
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Tom Marshall <tdm.code@gmail.com>

[ Upstream commit a4d258036ed9b2a1811c3670c6099203a0f284a0 ]

If a RST comes in immediately after checking sk->sk_err, tcp_poll will
return POLLIN but not POLLOUT.  Fix this by checking sk->sk_err at the end
of tcp_poll.  Additionally, ensure the correct order of operations on SMP
machines with memory barriers.

Signed-off-by: Tom Marshall <tdm.code@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp.c       |    7 +++++--
 net/ipv4/tcp_input.c |    2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -386,8 +386,6 @@ unsigned int tcp_poll(struct file *file,
 	 */
 
 	mask = 0;
-	if (sk->sk_err)
-		mask = POLLERR;
 
 	/*
 	 * POLLHUP is certainly not done right. But poll() doesn't
@@ -457,6 +455,11 @@ unsigned int tcp_poll(struct file *file,
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
 
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3969,6 +3969,8 @@ static void tcp_reset(struct sock *sk)
 	default:
 		sk->sk_err = ECONNRESET;
 	}
+	/* This barrier is coupled with smp_rmb() in tcp_poll() */
+	smp_wmb();
 
 	if (!sock_flag(sk, SOCK_DEAD))
 		sk->sk_error_report(sk);


