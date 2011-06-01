Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab1FAR0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:26:19 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:28769 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758490Ab1FAR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:14 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: BfEdJ.IVM1lRBRzElMcTSmKz6wzHUX87V508o5_v9aFot0Z
 gHOyOUa29AdaHOeTlM70fPc6zAFOk6_q4nz3umc_Ir09kcy0t8tYKXHJf_.a
 ZZXj_hsK6c_U7JlDWFDP3Fmp5s39DEGHbu3HK36Jtw6Dj9Ccqu5llUKXgrxD
 uqSWbwuBWMNWRMQjD_5cXUHDjyXkPdnetxiu8Cb7M7uAfEkiLAtnkk2G_Fc.
 VwXZeBxa61tqu3SKhLXazDvJQ8fZr_kGY_6BxloaHcE5GMRwRRigEW0JBOl3
 5Q7oUqpF.n65fUY6Go5uV6BCHizurf7EXyxIHqoZh7nGx74s9
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172612.349447452@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:44 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 01/17] slub: Push irq disable into allocate_slab()
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=push_irq_disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

