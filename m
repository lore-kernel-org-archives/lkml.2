Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965325Ab2CMA16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:27:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:49036 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965279Ab2CMAZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 190/196] gro: Only reset frag0 when skb can be pulled
Date: Mon, 12 Mar 2012 20:21:43 -0400
Message-Id: <1331598109-31424-145-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 17dd759c67f21e34f2156abcf415e1f60605a188 upstream.

Currently skb_gro_header_slow unconditionally resets frag0 and
frag0_len.  However, when we can't pull on the skb this leaves
the GRO fields in an inconsistent state.

This patch fixes this by only resetting those fields after the
pskb_may_pull test.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/netdevice.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0af14f2..0899edf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1261,9 +1261,12 @@ static inline int skb_gro_header_hard(struct sk_buff *skb, unsigned int hlen)
 static inline void *skb_gro_header_slow(struct sk_buff *skb, unsigned int hlen,
 					unsigned int offset)
 {
+	if (!pskb_may_pull(skb, hlen))
+		return NULL;
+
 	NAPI_GRO_CB(skb)->frag0 = NULL;
 	NAPI_GRO_CB(skb)->frag0_len = 0;
-	return pskb_may_pull(skb, hlen) ? skb->data + offset : NULL;
+	return skb->data + offset;
 }
 
 static inline void *skb_gro_mac_header(struct sk_buff *skb)
-- 
1.7.9.3

