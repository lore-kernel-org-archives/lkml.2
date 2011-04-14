Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1DNXmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 19:42:23 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40272 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1DNXmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 19:42:21 -0400
Subject: [PATCH] make sparse happy with gfp.h
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 14 Apr 2011 16:42:17 -0700
Message-Id: <20110414234216.9E31DBD9@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Running sparse on page_alloc.c today, it errors out:
        include/linux/gfp.h:254:17: error: bad constant expression
        include/linux/gfp.h:254:17: error: cannot size expression

which is a line in gfp_zone():

        BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);

That's really unfortunate, because it ends up hiding all of the other
legitimate sparse messages like this:
        mm/page_alloc.c:5315:59: warning: incorrect type in argument 1 (different base types)
        mm/page_alloc.c:5315:59:    expected unsigned long [unsigned] [usertype] size
        mm/page_alloc.c:5315:59:    got restricted gfp_t [usertype] <noident>
...

Having sparse be able to catch these very oopsable bugs is a lot more
important than keeping a BUILD_BUG_ON().  Kill the BUILD_BUG_ON().

Compiles on x86_64 with and without CONFIG_DEBUG_VM=y.  defconfig
boots fine for me.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/linux/gfp.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/gfp.h~make-sparse-happy-with-gfp_h include/linux/gfp.h
--- linux-2.6.git/include/linux/gfp.h~make-sparse-happy-with-gfp_h	2011-04-14 14:47:02.629275904 -0700
+++ linux-2.6.git-dave/include/linux/gfp.h	2011-04-14 14:47:38.813272674 -0700
@@ -249,14 +249,9 @@ static inline enum zone_type gfp_zone(gf
 
 	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
 					 ((1 << ZONES_SHIFT) - 1);
-
-	if (__builtin_constant_p(bit))
-		BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
-	else {
 #ifdef CONFIG_DEBUG_VM
-		BUG_ON((GFP_ZONE_BAD >> bit) & 1);
+	BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 #endif
-	}
 	return z;
 }
 
_
