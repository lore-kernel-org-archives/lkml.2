Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab1DNUCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:02:12 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50226 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759461Ab1DNUCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:02:07 -0400
Subject: [PATCH 3/3] reuse __free_pages_exact() in __alloc_pages_exact()
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 14 Apr 2011 13:01:42 -0700
References: <20110414200139.ABD98551@kernel>
In-Reply-To: <20110414200139.ABD98551@kernel>
Message-Id: <20110414200141.09C3AA5F@kernel>
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
--- linux-2.6.git/mm/page_alloc.c~reuse-free-exact	2011-04-14 12:03:10.132795021 -0700
+++ linux-2.6.git-dave/mm/page_alloc.c	2011-04-14 12:03:10.144795019 -0700
@@ -2338,14 +2338,11 @@ struct page *__alloc_pages_exact(gfp_t g
 
 	page = alloc_pages(gfp_mask, order);
 	if (page) {
-		struct page *alloc_end = page + (1 << order);
-		struct page *used = page + nr_pages;
+		struct page *unused_start = page + nr_pages;
+		unsigned long nr_unused = (1 << order) - nr_pages;
 
 		split_page(page, order);
-		while (used < alloc_end) {
-			__free_page(used);
-			used++;
-		}
+		__free_pages_exact(unused_start, nr_unused);
 	}
 
 	return page;
_
