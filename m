Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab1EZSPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:15:09 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:22269 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757665Ab1EZSPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:04 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Z2rSlggVM1k4IDFoy6rTS.YBp1pyjv0pqR17j4VvqGJHCNz
 naPHiF6BogWymqhYVSKuDJG4nLQuSFA77Tpck4MSD34aIkItpb49UASRQG.J
 zZSFijIs_J9Wx.oVZTzkoUJf8XyYxtdp_dxHzM1SXX0IeOcX296l1oKEr8kP
 kBKtkIUv1VQR2QvcVdtWaRGFtzEu10Sd53U4CbKmN53ITLYb_vaVwWM7HPbC
 o5Nn.tGMnB64DR8uiecauOerdjj7U7ZVLUwNUS5U7AcgxBUcqi46egQX.1R2
 g.KSxqiuY4t1ymC6jkQKq6O1jDs_jvk9Z8oWEQRTIRvzxcGdR
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181501.946180879@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:43 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 01/17] slub: Push irq disable into allocate_slab()
References: <20110526181442.789868308@linux.com>
Content-Disposition: inline; filename=push_irq_disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do the irq handling in allocate_slab() instead of __slab_alloc().

__slab_alloc() is already cluttered and allocate_slab() is already
fiddling around with gfp flags.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-19 13:59:24.271151647 -0500
+++ linux-2.6/mm/slub.c	2011-05-19 13:59:24.981151647 -0500
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
@@ -1203,12 +1208,15 @@ static struct page *allocate_slab(struct
 		 * Try a lower order alloc if possible
 		 */
 		page = alloc_slab_page(flags, node, oo);
-		if (!page)
-			return NULL;
-
 		stat(s, ORDER_FALLBACK);
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
@@ -1849,15 +1857,8 @@ new_slab:
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

