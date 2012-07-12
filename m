Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162969Ab2GLXsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:48:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416Ab2GLWg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:36:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        James Chapman <jchapman@katalix.com>,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 025/187] l2tp: fix a race in l2tp_ip_sendmsg()
Date: Thu, 12 Jul 2012 15:33:01 -0700
Message-Id: <20120712191524.586318194@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4399a4df98a63e30fd16e9d0cecc46ea92269e8f ]

Commit 081b1b1bb27f (l2tp: fix l2tp_ip_sendmsg() route handling) added
a race, in case IP route cache is disabled.

In this case, we should not do the dst_release(&rt->dst), since it'll
free the dst immediately, instead of waiting a RCU grace period.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: James Chapman <jchapman@katalix.com>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ip.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -516,10 +516,12 @@ static int l2tp_ip_sendmsg(struct kiocb
 					   sk->sk_bound_dev_if);
 		if (IS_ERR(rt))
 			goto no_route;
-		if (connected)
+		if (connected) {
 			sk_setup_caps(sk, &rt->dst);
-		else
-			dst_release(&rt->dst); /* safe since we hold rcu_read_lock */
+		} else {
+			skb_dst_set(skb, &rt->dst);
+			goto xmit;
+		}
 	}
 
 	/* We dont need to clone dst here, it is guaranteed to not disappear.
@@ -527,6 +529,7 @@ static int l2tp_ip_sendmsg(struct kiocb
 	 */
 	skb_dst_set_noref(skb, &rt->dst);
 
+xmit:
 	/* Queue the packet to IP for output */
 	rc = ip_queue_xmit(skb, &inet->cork.fl);
 	rcu_read_unlock();


