Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab1DNPrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:47:25 -0400
Received: from www.sr71.net ([198.145.64.142]:45243 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab1DNPrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:47:23 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Apr 2011 11:47:23 EDT
Subject: BUILD_BUG_ON() breaks sparse gfp_t checks
From: Dave Hansen <dave@sr71.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jan Beulich <JBeulich@novell.com>, Christoph Lameter <cl@linux.com>,
        akpm <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 14 Apr 2011 08:41:35 -0700
Message-ID: <1302795695.14658.6801.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running sparse on page_alloc.c today, it errors out:
        
        mm/page_alloc.c:96:5: warning: symbol 'percpu_pagelist_fraction' was not declared. Should it be static?
        mm/page_alloc.c:175:5: warning: symbol 'min_free_kbytes' was not declared. Should it be static?
        include/linux/gfp.h:254:17: error: bad constant expression
        include/linux/gfp.h:254:17: error: cannot size expression

which is a line in gfp_zone():

	BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);

That's really unfortunate, because it ends up hiding all of the other
legitimate sparse messages (like I introduced with the appended patch):

        mm/page_alloc.c:96:5: warning: symbol 'percpu_pagelist_fraction' was not declared. Should it be static?
        mm/page_alloc.c:175:5: warning: symbol 'min_free_kbytes' was not declared. Should it be static?
        mm/page_alloc.c:3692:15: warning: symbol '__early_pfn_to_nid' was not declared. Should it be static?
        mm/page_alloc.c:5315:59: warning: incorrect type in argument 1 (different base types)
        mm/page_alloc.c:5315:59:    expected unsigned long [unsigned] [usertype] size
        mm/page_alloc.c:5315:59:    got restricted gfp_t [usertype] <noident>
...

Is sparse broken, or is that ?  Even if it is, should we be working
around this somehow?  It looks like we've basically crippled sparse in
some spots.

---

 linux-2.6.git-dave/include/linux/gfp.h |    3 ++-
 linux-2.6.git-dave/mm/page_alloc.c     |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/gfp.h~fix-gfp_h-sparse include/linux/gfp.h
--- linux-2.6.git/include/linux/gfp.h~fix-gfp_h-sparse	2011-04-14 08:23:33.402280424 -0700
+++ linux-2.6.git-dave/include/linux/gfp.h	2011-04-14 08:32:33.782224008 -0700
@@ -249,7 +249,7 @@ static inline enum zone_type gfp_zone(gf
 
 	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
 					 ((1 << ZONES_SHIFT) - 1);
-
+/*
 	if (__builtin_constant_p(bit))
 		BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 	else {
@@ -257,6 +257,7 @@ static inline enum zone_type gfp_zone(gf
 		BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 #endif
 	}
+	*/
 	return z;
 }
 
diff -puN mm/page_alloc.c~fix-gfp_h-sparse mm/page_alloc.c
--- linux-2.6.git/mm/page_alloc.c~fix-gfp_h-sparse	2011-04-14 08:24:20.806271357 -0700
+++ linux-2.6.git-dave/mm/page_alloc.c	2011-04-14 08:24:35.554268529 -0700
@@ -5312,6 +5312,7 @@ void *__init alloc_large_system_hash(con
 			 */
 			if (get_order(size) < MAX_ORDER) {
 				table = alloc_pages_exact(size, GFP_ATOMIC);
+				table = alloc_pages_exact(GFP_ATOMIC, size);
 				kmemleak_alloc(table, size, 1, GFP_ATOMIC);
 			}
 		}
_


-- Dave

