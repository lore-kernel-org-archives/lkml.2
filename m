Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596Ab2ERCwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:52:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40405 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762555Ab2ERCw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:28 -0400
Message-Id: <20120518023256.109160335@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sasha Levin <levinsasha928@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 13/53] net: l2tp: unlock socket lock before returning from l2tp_ip_sendmsg
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <levinsasha928@gmail.com>

[ Upstream commit 84768edbb2721637620b2d84501bb0d5aed603f1 ]

l2tp_ip_sendmsg could return without releasing socket lock, making it all the
way to userspace, and generating the following warning:

[  130.891594] ================================================
[  130.894569] [ BUG: lock held when returning to user space! ]
[  130.897257] 3.4.0-rc5-next-20120501-sasha #104 Tainted: G        W
[  130.900336] ------------------------------------------------
[  130.902996] trinity/8384 is leaving the kernel with locks still held!
[  130.906106] 1 lock held by trinity/8384:
[  130.907924]  #0:  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffff82b9503f>] l2tp_ip_sendmsg+0x2f/0x550

Introduced by commit 2f16270 ("l2tp: Fix locking in l2tp_ip.c").

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/l2tp/l2tp_ip.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 55670ec..2a2a3e7 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -441,8 +441,9 @@ static int l2tp_ip_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *m
 
 		daddr = lip->l2tp_addr.s_addr;
 	} else {
+		rc = -EDESTADDRREQ;
 		if (sk->sk_state != TCP_ESTABLISHED)
-			return -EDESTADDRREQ;
+			goto out;
 
 		daddr = inet->inet_daddr;
 		connected = 1;
-- 
1.7.10.1




