Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1DORFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:05:39 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49439 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab1DORFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:05:37 -0400
Subject: [PATCH 2/2] print vmalloc() state after allocation failures
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        Michal Nazarewicz <mina86@mina86.com>, akpm@osdl.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 15 Apr 2011 10:04:38 -0700
References: <20110415170437.17E1AF36@kernel>
In-Reply-To: <20110415170437.17E1AF36@kernel>
Message-Id: <20110415170438.D5C317D5@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was tracking down a page allocation failure that ended up in vmalloc().
Since vmalloc() uses 0-order pages, if somebody asks for an insane amount
of memory, we'll still get a warning with "order:0" in it.  That's not
very useful.

During recovery, vmalloc() also nicely frees all of the memory that it
got up to the point of the failure.  That is wonderful, but it also
quickly hides any issues.  We have a much different sitation if vmalloc()
repeatedly fails 10GB in to:

	vmalloc(100 * 1<<30);

versus repeatedly failing 4096 bytes in to a:

	vmalloc(8192);

This patch will print out messages that look like this:

[   68.123503] vmalloc: allocation failure, allocated 6680576 of 13426688 bytes
[   68.124218] bash: page allocation failure: order:0, mode:0xd2
[   68.124811] Pid: 3770, comm: bash Not tainted 2.6.39-rc3-00082-g85f2e68-dirty #333
[   68.125579] Call Trace:
[   68.125853]  [<ffffffff810f6da6>] warn_alloc_failed+0x146/0x170
[   68.126464]  [<ffffffff8107e05c>] ? printk+0x6c/0x70
[   68.126791]  [<ffffffff8112b5d4>] ? alloc_pages_current+0x94/0xe0
[   68.127661]  [<ffffffff8111ed37>] __vmalloc_node_range+0x237/0x290
...

The 'order' variable is added for clarity when calling
warn_alloc_failed() to avoid having an unexplained '0' as an argument.
The 'tmp_mask' is there to keep the alloc_pages_node() looking sane.
Adding __GFP_NOWARN is done because we now have our own, full error
message in vmalloc code.

As a side issue, I also noticed that ctl_ioctl() does vmalloc() based
solely on an unverified value passed in from userspace.  Granted, it's
under CAP_SYS_ADMIN, but it still frightens me a bit.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/mm/vmalloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-warn mm/vmalloc.c
--- linux-2.6.git/mm/vmalloc.c~vmalloc-warn	2011-04-15 08:49:06.823306620 -0700
+++ linux-2.6.git-dave/mm/vmalloc.c	2011-04-15 09:20:17.926460283 -0700
@@ -1534,6 +1534,7 @@ static void *__vmalloc_node(unsigned lon
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, int node, void *caller)
 {
+	int order = 0;
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
 	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
@@ -1560,11 +1561,12 @@ static void *__vmalloc_area_node(struct 
 
 	for (i = 0; i < area->nr_pages; i++) {
 		struct page *page;
+		gfp_t tmp_mask = gfp_mask | __GFP_NOWARN;
 
 		if (node < 0)
-			page = alloc_page(gfp_mask);
+			page = alloc_page(tmp_mask);
 		else
-			page = alloc_pages_node(node, gfp_mask, 0);
+			page = alloc_pages_node(node, tmp_mask, order);
 
 		if (unlikely(!page)) {
 			/* Successfully allocated i pages, free them in __vunmap() */
@@ -1579,6 +1581,9 @@ static void *__vmalloc_area_node(struct 
 	return area->addr;
 
 fail:
+	warn_alloc_failed(gfp_mask, order, "vmalloc: allocation failure, "
+			  "allocated %ld of %ld bytes\n",
+			  (area->nr_pages*PAGE_SIZE), area->size);
 	vfree(area->addr);
 	return NULL;
 }
_
