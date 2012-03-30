Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936476Ab2C3WG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:06:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965342Ab2C3VQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:16:05 -0400
Message-Id: <20120330194903.023849109@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 139/149] net: fix napi_reuse_skb() skb reserve
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 2a2a459eeeff48640dc557548ce576d666ab06ed ]

napi->skb is allocated in napi_get_frags() using
netdev_alloc_skb_ip_align(), with a reserve of NET_SKB_PAD +
NET_IP_ALIGN bytes.

However, when such skb is recycled in napi_reuse_skb(), it ends with a
reserve of NET_IP_ALIGN which is suboptimal.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3634,7 +3634,8 @@ EXPORT_SYMBOL(napi_gro_receive);
 static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 {
 	__skb_pull(skb, skb_headlen(skb));
-	skb_reserve(skb, NET_IP_ALIGN - skb_headroom(skb));
+	/* restore the reserve we had after netdev_alloc_skb_ip_align() */
+	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN - skb_headroom(skb));
 	skb->vlan_tci = 0;
 	skb->dev = napi->dev;
 	skb->skb_iif = 0;


