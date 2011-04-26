Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1DZVdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:33:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:57987 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab1DZVOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483513"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: herbert@gondor.hengli.com.au, davem@davemloft.net, bphilips@suse.de,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [40/106] gro: Reset dev pointer on reuse
Message-Id: <20110426211319.D35013E1887@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

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
Signed-off-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/net/core/dev.c
===================================================================
--- linux-2.6.35.y.orig/net/core/dev.c
+++ linux-2.6.35.y/net/core/dev.c
@@ -3231,6 +3231,7 @@ void napi_reuse_skb(struct napi_struct *
 {
 	__skb_pull(skb, skb_headlen(skb));
 	skb_reserve(skb, NET_IP_ALIGN - skb_headroom(skb));
+	skb->dev = napi->dev;
 
 	napi->skb = skb;
 }
