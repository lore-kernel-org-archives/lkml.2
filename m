Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab0LMAId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:08:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36268 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab0LLXrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:06 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: eric.dumazet@gmail.com, kaber@trash.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [123/223] netfilter: nf_conntrack: allow nf_ct_alloc_hashtable() to get highmem pages
Message-Id: <20101212234704.C4E03B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit 6b1686a71e3158d3c5f125260effce171cc7852b upstream.

commit ea781f197d6a8 (use SLAB_DESTROY_BY_RCU and get rid of call_rcu())
did a mistake in __vmalloc() call in nf_ct_alloc_hashtable().

I forgot to add __GFP_HIGHMEM, so pages were taken from LOWMEM only.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/netfilter/nf_conntrack_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/net/netfilter/nf_conntrack_core.c
===================================================================
--- linux.orig/net/netfilter/nf_conntrack_core.c
+++ linux/net/netfilter/nf_conntrack_core.c
@@ -1252,7 +1252,8 @@ void *nf_ct_alloc_hashtable(unsigned int
 	if (!hash) {
 		*vmalloced = 1;
 		printk(KERN_WARNING "nf_conntrack: falling back to vmalloc.\n");
-		hash = __vmalloc(sz, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
+		hash = __vmalloc(sz, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+				 PAGE_KERNEL);
 	}
 
 	if (hash && nulls)
