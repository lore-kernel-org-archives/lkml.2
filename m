Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab2ETVKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 17:10:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44095 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2ETVKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 17:10:11 -0400
Date: Sun, 20 May 2012 14:10:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ben Hutchings <ben@decadent.org.uk>, Steven Rostedt <rostedt@goodmis.org>
cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [WARNING] lockdep and kmemcheck_alloc_shadow
In-Reply-To: <1337485947.4107.295.camel@deadeye>
Message-ID: <alpine.DEB.2.00.1205201405110.10189@chino.kir.corp.google.com>
References: <1337449661.32434.4.camel@gandalf.stny.rr.com> <1337485947.4107.295.camel@deadeye>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2012, Ben Hutchings wrote:

> Seems to be a bug in SLUB:
> 
> > static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> > {
> [...]
> > 	if (flags & __GFP_WAIT)
> > 		local_irq_disable();
> > 
> > 	if (!page)
> > 		return NULL;
> > 
> > 	if (kmemcheck_enabled
> > 		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
> > 		int pages = 1 << oo_order(oo);
> > 
> > 		kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
> [...]
> 
> So kmemcheck_alloc_shadow() runs with IRQs off, but uses the same flags
> as the original allocation.
> 
> Looks like this was introduced by:
> 
> commit 7e0528dadc9f8b04e4de0dba48a075100c2afe75
> Author: Christoph Lameter <cl@linux.com>
> Date:   Wed Jun 1 12:25:44 2011 -0500
> 
>     slub: Push irq disable into allocate_slab()
> 
> which went into 3.1.
> 

Agreed, slab handles this correctly and it looks like slub ends up 
disabling irqs too early.

Does this fix it?  If so, we'll need to annotate it for stable as Ben 
noted.


mm, slub: ensure irqs are not disabled for kmemcheck allocation

kmemcheck_alloc_shadow() cannot be called with irqs disabled, which is
possible with __GFP_WAIT.  Ensure we always have them enabled at
allocation time like slab does.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1314,13 +1314,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 			stat(s, ORDER_FALLBACK);
 	}
 
-	if (flags & __GFP_WAIT)
-		local_irq_disable();
-
-	if (!page)
-		return NULL;
-
-	if (kmemcheck_enabled
+	if (page && kmemcheck_enabled
 		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
 		int pages = 1 << oo_order(oo);
 
@@ -1336,6 +1330,11 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 			kmemcheck_mark_unallocated_pages(page, pages);
 	}
 
+	if (flags & __GFP_WAIT)
+		local_irq_disable();
+	if (!page)
+		return NULL;
+
 	page->objects = oo_objects(oo);
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
