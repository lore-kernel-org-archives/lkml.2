Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab2CMAWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:47441 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab2CMAWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 047/196] gro: Reset dev pointer on reuse
Date: Mon, 12 Mar 2012 20:19:20 -0400
Message-Id: <1331598109-31424-2-git-send-email-paul.gortmaker@windriver.com>
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

commit 66c46d741e2e60f0e8b625b80edb0ab820c46d7a upstream.

On older kernels the VLAN code may zero skb->dev before dropping
it and causing it to be reused by GRO.

Unfortunately we didn't reset skb->dev in that case which causes
the next GRO user to get a bogus skb->dev pointer.

This particular problem no longer happens with the current upstream
kernel due to changes in VLAN processing.

However, for correctness we should still reset the skb->dev pointer
in the GRO reuse function in case a future user does the same thing.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 3095934..19a74f6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2822,6 +2822,7 @@ void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 {
 	__skb_pull(skb, skb_headlen(skb));
 	skb_reserve(skb, NET_IP_ALIGN - skb_headroom(skb));
+	skb->dev = napi->dev;
 
 	napi->skb = skb;
 }
-- 
1.7.9.3

