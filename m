Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab1EaQ4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:56:02 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:24390 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757023Ab1EaQ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:56:01 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: eQHHYMUVM1nAHZgi6MIP_X5rhb8a4sUPN19Wvwz6ElSlVI0
 VbP9DtouYv6UrsgdIv3Mo3ey72ILsQj1aTafQjkRgkzkPrGI8AOVZMouqkKV
 4go07Yo_SVQtR6OIjFDIx7IoLQzZy9inJwP.drk92iJWVRUzDrE3.eUJPQeC
 LcWC5ezZVEtor5v0DFJdfHGsffeqJ0R9T4qxJDkmB_Fx7zhUHWH27P_xlq3A
 ALoYKQYXD9qeBeVnFFhMsTma.2kme.Ji0nvo0shoX9EZIIA_KgZgCBa8QK0D
 RZJSkAk1TZNG9Zv3crbkA_blX18j8i3FZFrU0hHxITRrmoX.zQ88as6D48h1
 dLgj7BQi9AV6RCc5qafeUbFxJ
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 31 May 2011 11:55:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 01/17] slub: Push irq disable into allocate_slab()
In-Reply-To: <alpine.DEB.2.00.1105261348490.26952@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105311155050.19928@router.home>
References: <20110526181442.789868308@linux.com> <20110526181501.946180879@linux.com> <alpine.DEB.2.00.1105261348490.26952@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, David Rientjes wrote:

> > +	if (flags & __GFP_WAIT)
> > +		local_irq_disable();
> > +
> > +	if (!page)
> > +		return NULL;
> > +
>
> This changes the meaning of ORDER_FALLBACK from its previous meaning,
> which was "number of times the preferred order could not be allocated and
> then minimum order could be allocated" to "number of times the preferred
> order could not be allocated, regardless of whether the minimum order
> allocation was successful."  The former is the true meaning of the word
> "fallback," so is this semantics change avoidable?  Otherwise it seems
> like the statistic should be renamed (NEW_SLAB_FAIL?)

Ok that needs to be fixed:

Subject: slub: Push irq disable into allocate_slab()

Do the irq handling in allocate_slab() instead of __slab_alloc().

__slab_alloc() is already cluttered and allocate_slab() is already
fiddling around with gfp flags.

v6->v7:
	Only increment ORDER_FALLBACK if we get a page during fallback

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-26 16:13:58.085604969 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 09:42:08.102989621 -0500
@@ -1187,6 +1187,11 @@ static struct page *allocate_slab(struct
 	struct kmem_cache_order_objects oo = s->oo;
 	gfp_t alloc_gfp;

+	flags &= gfp_allowed_mask;
+
+	if (flags & __GFP_WAIT)
+		local_irq_enable();
+
 	flags |= s->allocflags;

 	/*
@@ -1203,12 +1208,17 @@ static struct page *allocate_slab(struct
 		 * Try a lower order alloc if possible
 		 */
 		page = alloc_slab_page(flags, node, oo);
-		if (!page)
-			return NULL;

-		stat(s, ORDER_FALLBACK);
+		if (page)
+			stat(s, ORDER_FALLBACK);
 	}

+	if (flags & __GFP_WAIT)
+		local_irq_disable();
+
+	if (!page)
+		return NULL;
+
 	if (kmemcheck_enabled
 		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
 		int pages = 1 << oo_order(oo);
@@ -1849,15 +1859,8 @@ new_slab:
 		goto load_freelist;
 	}

-	gfpflags &= gfp_allowed_mask;
-	if (gfpflags & __GFP_WAIT)
-		local_irq_enable();
-
 	page = new_slab(s, gfpflags, node);

-	if (gfpflags & __GFP_WAIT)
-		local_irq_disable();
-
 	if (page) {
 		c = __this_cpu_ptr(s->cpu_slab);
 		stat(s, ALLOC_SLAB);
