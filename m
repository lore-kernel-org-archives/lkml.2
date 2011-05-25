Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab1EYI6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:58:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43382 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1EYI63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:58:29 -0400
Date: Wed, 25 May 2011 10:58:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "slub: Remove node check in slab_free"
Message-ID: <20110525085816.GA24233@elte.hu>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
 <20110525074040.GA9233@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525074040.GA9233@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * James Morris <jmorris@namei.org> wrote:
> 
> > I started experiencing a boot hang in 2.6.39+, and bisected it to this 
> > change:
> 
> i too was seeing various instabilities and SLUB corruption in -tip testing. 
> Every 5th randconfig kernel crashes.
> 
> I started testing the revert.

Stability of -tip has increased dramatically (36 test iterations and 
no crash), so yes this revert resolves the crashes.

I've attached the changelogified revert patch below. James, since i 
was seeing these sporadically you've saved me a couple of hours of 
rather painful bisection work! :-)

Thanks,

	Ingo

----------------->
>From 6ac0730862b6dd1b45bc86e8e61e4026293b09f9 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 25 May 2011 09:37:47 +0200
Subject: [PATCH] Revert "slub: Remove node check in slab_free"

This reverts commit 442b06bcea23a01934d3da7ec5898fa154a6cafb.

As Linus explained it's broken. Quoting Linus:

That whole "deactivate_slab()" + "c->page = NULL" that this patch 
does looks bogus.

Look at __slab_alloc(), we have:

        page = c->page;
        if (!page)
                goto new_slab;

        slab_lock(page);
        if (unlikely(!node_match(c, node)))
                goto another_slab;

and let's assume we have two users racing on that "c->page". The 
"slab_lock()" is going to work for one of them, right?

Ok, so the one it works for will then hit:

        if (kmem_cache_debug(s))
                goto debug;

and thus get to the new "deactivate_slab(s,c) + c->page = NULL" and 
then unlock the page.

In the meantime, the one that wasn't able to lock the page will now 
go forward, but will not have "node_match()" any more, so it does 
that "goto another_slab".

Which does "deactivate_slab(s,c)" again, and now c->page is NULL, so 
that totally breaks.

Reported-and-bisected-by: James Morris <jmorris@namei.org>
Analyzed-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/alpine.LRH.2.00.1105242146240.12134@tundra.namei.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/slub.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4ea7f1a..ed1281b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1881,8 +1881,6 @@ debug:
 
 	page->inuse++;
 	page->freelist = get_freepointer(s, object);
-	deactivate_slab(s, c);
-	c->page = NULL;
 	c->node = NUMA_NO_NODE;
 	goto unlock_out;
 }
@@ -2114,7 +2112,7 @@ redo:
 	tid = c->tid;
 	barrier();
 
-	if (likely(page == c->page)) {
+	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
 		set_freepointer(s, object, c->freelist);
 
 		if (unlikely(!irqsafe_cpu_cmpxchg_double(
