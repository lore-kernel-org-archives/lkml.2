Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab0HDC4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:56:32 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:48636 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756860Ab0HDCwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:52:12 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: CVd9RC4VM1nJVwARUkJFzgyhOvUGJxdLZ6NCnW1PSFouAKY
 kxuwRAniFFW1Lyh6z4w7Z4yNl2iI24dlXKmbS3Fey232gUCEver3AO14gQwC
 mE.1QArsaHFCrrztkvm6TrOgautJ9Et5PAXfe0IXjDT_.Y6cjko6mI5V.FLI
 2r3XFLk7tqWTVCc9G8PTwHHluPZpTue1oNsGay3Qiu_c.BrUWSTIAbapObh.
 a846L7nB5TdhmGN9Fwq73kujbcwjZEhwZK9EjGj9whLYSA1RX
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20100804024531.315379267@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 Aug 2010 21:45:27 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q3 13/23] slub: Move gfpflag masking out of the hotpath
References: <20100804024514.139976032@linux.com>
Content-Disposition: inline; filename=slub_move_gfpflags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the gfpflags masking into the hooks for checkers and into the slowpaths.
gfpflag masking requires access to a global variable and thus adds an
additional cacheline reference to the hotpaths.

If no hooks are active then the gfpflag masking will result in
code that the compiler can toss out.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-26 14:26:33.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-26 14:26:47.000000000 -0500
@@ -798,6 +798,7 @@ static void trace(struct kmem_cache *s, 
  */
 static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 {
+	flags &= gfp_allowed_mask;
 	lockdep_trace_alloc(flags);
 	might_sleep_if(flags & __GFP_WAIT);
 
@@ -806,6 +807,7 @@ static inline int slab_pre_alloc_hook(st
 
 static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, void *object)
 {
+	flags &= gfp_allowed_mask;
 	kmemcheck_slab_alloc(s, flags, object, s->objsize);
 	kmemleak_alloc_recursive(object, s->objsize, 1, s->flags, flags);
 }
@@ -1679,6 +1681,7 @@ new_slab:
 		goto load_freelist;
 	}
 
+	gfpflags &= gfp_allowed_mask;
 	if (gfpflags & __GFP_WAIT)
 		local_irq_enable();
 
@@ -1727,8 +1730,6 @@ static __always_inline void *slab_alloc(
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
-	gfpflags &= gfp_allowed_mask;
-
 	if (!slab_pre_alloc_hook(s, gfpflags))
 		return NULL;
 

