Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0KYKSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:18:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48645 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0KYKSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:18:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Simon Kirby <sim@hostway.ca>
Subject: Re: Free memory never fully used, swapping
Cc: kosaki.motohiro@jp.fujitsu.com, Shaohua Li <shaohua.li@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20101125090328.GB14180@hostway.ca>
References: <1290647274.12777.3.camel@sli10-conroe> <20101125090328.GB14180@hostway.ca>
Message-Id: <20101125191759.F465.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 25 Nov 2010 19:18:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are actually a few problems here.  I think they are worth looking
> at them separately, unless "don't use order 3 allocations" is a valid
> statement, in which case we should fix slub.
> 
> The funny thing here is that slub.c's allocate_slab() calls alloc_pages()
> with flags | __GFP_NOWARN | __GFP_NORETRY, and intentionally tries a
> lower order allocation automatically if it fails.  This is why there is
> no allocation failure warning when this happens.  However, it is too late
> -- kswapd is woken and it ties to bring order 3 up to the watermark. 
> If we hacked __alloc_pages_slowpath() to not wake kswapd when
> __GFP_NOWARN is set, we would never see this problem and the slub
> optimization might still mostly work.  Either way, we should "fix" slub
> or "fix" order-3 allocations, so that other people who are using slub
> don't hit the same problem.

This?




Subject: [PATCH] slub: use no __GFP_WAIT instead __GFP_NORETRY

---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8c66aef..0c77399 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1134,7 +1134,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	 * Let the initial higher-order allocation fail under memory pressure
 	 * so we fall-back to the minimum order allocation.
 	 */
-	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
+	alloc_gfp = (flags | __GFP_NOWARN) & ~(__GFP_NOFAIL | __GFP_WAIT);
 
 	page = alloc_slab_page(alloc_gfp, node, oo);
 	if (unlikely(!page)) {
-- 
1.6.5.2




