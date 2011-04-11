Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1DKWD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 18:03:59 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34704 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab1DKWD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 18:03:57 -0400
Subject: [PATCH 3/3] reuse __free_pages_exact() in __alloc_pages_exact()
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 11 Apr 2011 15:03:48 -0700
References: <20110411220345.9B95067C@kernel>
In-Reply-To: <20110411220345.9B95067C@kernel>
Message-Id: <20110411220348.D0280E4D@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michal Nazarewicz noticed that __alloc_pages_exact()'s
__free_page() loop was really close to something he was
using in one of his patches.   That made me realize that
it was actually very similar to __free_pages_exact().

This uses __free_pages_exact() in place of the loop
that we had in __alloc_pages_exact().  Since we had to
change the temporary variables around anyway, I gave
them some better names to hopefully address some other
review comments.

---

 linux-2.6.git-dave/mm/page_alloc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~reuse-free-exact mm/page_alloc.c
--- linux-2.6.git/mm/page_alloc.c~reuse-free-exact	2011-04-11 15:01:17.701822598 -0700
+++ linux-2.6.git-dave/mm/page_alloc.c	2011-04-11 15:01:17.713822594 -0700
@@ -2338,14 +2338,11 @@ struct page *__alloc_pages_exact(gfp_t g
 
 	page = alloc_pages(gfp_mask, order);
 	if (page) {
-		struct page *alloc_end = page + (1 << order);
-		struct page *used = page + nr_pages;
+		struct page *unused_start = page + nr_pages;
+		int nr_unused = (1 << order) - nr_pages;
 
 		split_page(page, order);
-		while (used < alloc_end) {
-			__free_page(used);
-			used++;
-		}
+		__free_pages_exact(unused_start, nr_unused);
 	}
 
 	return page;
_
