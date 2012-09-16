Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab2IPImy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 04:42:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab2IPImv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 04:42:51 -0400
Date: Sun, 16 Sep 2012 11:44:16 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: fix memory leak on oom with zerocopy
Message-ID: <20120916084416.GA22936@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If orphan flags fails, we don't free the skb
on receive, which leaks the skb memory.

Return value was also wrong: netif_receive_skb
is supposed to return NET_RX_DROP, not ENOMEM.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Fixes a memory leak so 3.6 material?

 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8398836..899f827 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3321,7 +3321,7 @@ ncls:
 
 	if (pt_prev) {
 		if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC)))
-			ret = -ENOMEM;
+			goto drop;
 		else
 			ret = pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
 	} else {
-- 
MST
