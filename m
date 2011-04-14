Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab1DNUWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:22:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857Ab1DNUWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:22:30 -0400
Date: Thu, 14 Apr 2011 13:22:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@sr71.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jan Beulich <JBeulich@novell.com>,
        Christoph Lameter <cl@linux.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: BUILD_BUG_ON() breaks sparse gfp_t checks
Message-Id: <20110414132220.970cfb2a.akpm@linux-foundation.org>
In-Reply-To: <1302795695.14658.6801.camel@nimitz>
References: <1302795695.14658.6801.camel@nimitz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 08:41:35 -0700
Dave Hansen <dave@sr71.net> wrote:

> Running sparse on page_alloc.c today, it errors out:
>         
>         mm/page_alloc.c:96:5: warning: symbol 'percpu_pagelist_fraction' was not declared. Should it be static?
>         mm/page_alloc.c:175:5: warning: symbol 'min_free_kbytes' was not declared. Should it be static?
>         include/linux/gfp.h:254:17: error: bad constant expression
>         include/linux/gfp.h:254:17: error: cannot size expression
> 
> which is a line in gfp_zone():
> 
> 	BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> 
> That's really unfortunate, because it ends up hiding all of the other
> legitimate sparse messages (like I introduced with the appended patch):
> 
>         mm/page_alloc.c:96:5: warning: symbol 'percpu_pagelist_fraction' was not declared. Should it be static?
>         mm/page_alloc.c:175:5: warning: symbol 'min_free_kbytes' was not declared. Should it be static?
>         mm/page_alloc.c:3692:15: warning: symbol '__early_pfn_to_nid' was not declared. Should it be static?
>         mm/page_alloc.c:5315:59: warning: incorrect type in argument 1 (different base types)
>         mm/page_alloc.c:5315:59:    expected unsigned long [unsigned] [usertype] size
>         mm/page_alloc.c:5315:59:    got restricted gfp_t [usertype] <noident>
> ...
> 
> Is sparse broken, or is that ?  Even if it is, should we be working
> around this somehow?  It looks like we've basically crippled sparse in
> some spots.

Is sparse having conniptions over that monster expression for
GFP_ZONE_BAD?

The kernel calls gfp_zone() with a constant arg in very few places. 
This?

--- a/include/linux/gfp.h~a
+++ a/include/linux/gfp.h
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

