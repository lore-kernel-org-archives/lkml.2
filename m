Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540Ab2EJRep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:34:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760501Ab2EJRej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:39 -0400
Message-Id: <20120510173135.105281922@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sasha Levin <levinsasha928@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 25/52] net: l2tp: unlock socket lock before returning from l2tp_ip_sendmsg
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ip.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -441,8 +441,9 @@ static int l2tp_ip_sendmsg(struct kiocb
 
 		daddr = lip->l2tp_addr.s_addr;
 	} else {
+		rc = -EDESTADDRREQ;
 		if (sk->sk_state != TCP_ESTABLISHED)
-			return -EDESTADDRREQ;
+			goto out;
 
 		daddr = inet->inet_daddr;
 		connected = 1;


