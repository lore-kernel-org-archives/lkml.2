Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab1EXXyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:54:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55717 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434Ab1EXXyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=pwgCCE5RoUllM8OQ6wGoEZ03viMTZ5qj9xCotY9cq9R5qkeJIYmIP6gL5pTPqSsWGJ
         8A1aoiq0DMc86GsPXfVw==
Date: Tue, 24 May 2011 16:53:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [patch 4/6] slub: avoid compiling SLAB_CACHE_DMA without DMA
 support
In-Reply-To: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105241652110.29780@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_ZONE_DMA is disabled, SLAB_CACHE_DMA is a no-op.  Avoid
compiling support for it on such a configuration.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -162,7 +162,10 @@ static inline int kmem_cache_debug(struct kmem_cache *s)
 		SLAB_FAILSLAB)
 
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
-		SLAB_CACHE_DMA | SLAB_NOTRACK)
+# ifdef CONFIG_ZONE_DMA
+		SLAB_CACHE_DMA | \
+# endif
+		SLAB_NOTRACK)
 
 #define OO_SHIFT	16
 #define OO_MASK		((1 << OO_SHIFT) - 1)
@@ -2544,8 +2547,10 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	if (order)
 		s->allocflags |= __GFP_COMP;
 
+#ifdef CONFIG_ZONE_DMA
 	if (s->flags & SLAB_CACHE_DMA)
 		s->allocflags |= SLUB_DMA;
+#endif
 
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		s->allocflags |= __GFP_RECLAIMABLE;
@@ -4651,8 +4656,10 @@ static char *create_unique_id(struct kmem_cache *s)
 	 * are matched during merging to guarantee that the id is
 	 * unique.
 	 */
+#ifdef CONFIG_ZONE_DMA
 	if (s->flags & SLAB_CACHE_DMA)
 		*p++ = 'd';
+#endif
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		*p++ = 'a';
 	if (s->flags & SLAB_DEBUG_FREE)
