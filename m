Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab0C3XbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:31:22 -0400
Received: from kroah.org ([198.145.64.141]:46625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab0C3XVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:35 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:40 2010
Message-Id: <20100330224840.071557207@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       Patrick McHardy <kaber@trash.net>, Zhu Yi <yi.zhu@intel.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [122/156] tcp: use limited socket backlog
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhu Yi <yi.zhu@intel.com>

[ Upstream commit 6b03a53a5ab7ccf2d5d69f96cf1c739c4d2a8fb9 ]

Make tcp adapt to the limited socket backlog change.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_ipv4.c |    6 ++++--
 net/ipv6/tcp_ipv6.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1677,8 +1677,10 @@ process:
 			if (!tcp_prequeue(sk, skb))
 				ret = tcp_v4_do_rcv(sk, skb);
 		}
-	} else
-		sk_add_backlog(sk, skb);
+	} else if (sk_add_backlog_limited(sk, skb)) {
+		bh_unlock_sock(sk);
+		goto discard_and_relse;
+	}
 	bh_unlock_sock(sk);
 
 	sock_put(sk);
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1732,8 +1732,10 @@ process:
 			if (!tcp_prequeue(sk, skb))
 				ret = tcp_v6_do_rcv(sk, skb);
 		}
-	} else
-		sk_add_backlog(sk, skb);
+	} else if (sk_add_backlog_limited(sk, skb)) {
+		bh_unlock_sock(sk);
+		goto discard_and_relse;
+	}
 	bh_unlock_sock(sk);
 
 	sock_put(sk);


