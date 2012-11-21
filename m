Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2KUAtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:49:13 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51652 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab2KUAtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:49:12 -0500
Message-ID: <50AC24F5.9090303@linux.vnet.ibm.com>
Date: Tue, 20 Nov 2012 16:48:53 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [3.7-rc6] capture_free_page() frees page without accounting for
 them??
References: <50ABE741.2020604@linux.vnet.ibm.com>
In-Reply-To: <50ABE741.2020604@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------060201040006090003020504"
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112100-3534-0000-0000-00000F2EB7DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060201040006090003020504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I'm really evil, so I changed the loop in compact_capture_page() to
basically steal the highest-order page it can.  This shouldn't _break_
anything, but it does ensure that we'll be splitting pages that we find
more often and recreating this *MUCH* faster:

-               for (order = cc->order; order < MAX_ORDER; order++) {
+               for (order = MAX_ORDER - 1; order >= cc->order;order--)

I also augmented the area in capture_free_page() that I expect to be
leaking:

        if (alloc_order != order) {
                static int leaked_pages = 0;
                leaked_pages += 1<<order;
                leaked_pages -= 1<<alloc_order;
                printk("%s() alloc_order(%d) != order(%d) leaked %d\n",
                                __func__, alloc_order, order,
				leaked_pages);
                expand(zone, page, alloc_order, order,
                        &zone->free_area[order], migratetype);
        }

I add up all the fields in buddyinfo to figure out how much _should_ be
in the allocator and then compare it to MemFree to get a guess at how
much is leaked.  That number correlates _really_ well with the
"leaked_pages" variable above.  That pretty much seals it for me.

I'll run a stress test overnight to see if it pops up again.  The patch
I'm running is attached.  I'll send a properly changelogged one tomorrow
if it works.


--------------060201040006090003020504
Content-Type: text/x-patch;
 name="leak-fix-20121120-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="leak-fix-20121120-1.patch"



---

 linux-2.6.git-dave/mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~leak-fix-20121120-1 mm/page_alloc.c
--- linux-2.6.git/mm/page_alloc.c~leak-fix-20121120-1	2012-11-20 19:44:09.588966346 -0500
+++ linux-2.6.git-dave/mm/page_alloc.c	2012-11-20 19:44:21.993057915 -0500
@@ -1405,7 +1405,7 @@ int capture_free_page(struct page *page,
 
 	mt = get_pageblock_migratetype(page);
 	if (unlikely(mt != MIGRATE_ISOLATE))
-		__mod_zone_freepage_state(zone, -(1UL << order), mt);
+		__mod_zone_freepage_state(zone, -(1UL << alloc_order), mt);
 
 	if (alloc_order != order)
 		expand(zone, page, alloc_order, order,
_

--------------060201040006090003020504--

