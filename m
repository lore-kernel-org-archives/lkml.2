Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab0GYPKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 11:10:11 -0400
Received: from server109-228-4-14.live-servers.net ([109.228.4.14]:64597 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751587Ab0GYPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 11:10:09 -0400
X-Greylist: delayed 2878 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jul 2010 11:10:09 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] lib/scatterlist: Hook sg_kmalloc into kmemleak
Date: Sun, 25 Jul 2010 15:21:15 +0100
Message-Id: <1280067675-7610-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemleak ignores page_alloc() and so believes the final sub-page
allocation using the plain kmalloc is decoupled and lost. This leads to
lots of false-positives with code that uses scatterlists.

The options seem to be either to tell kmemleak that the kmalloc is not
leaked or to notify kmemleak of the page allocations. The danger of the
first approach is that we may hide a real leak, so choose the latter
approach (of which I am not sure of the downsides).

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 lib/scatterlist.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 9afa25b..6e557b1 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -115,17 +115,20 @@ EXPORT_SYMBOL(sg_init_one);
  */
 static struct scatterlist *sg_kmalloc(unsigned int nents, gfp_t gfp_mask)
 {
-	if (nents == SG_MAX_SINGLE_ALLOC)
-		return (struct scatterlist *) __get_free_page(gfp_mask);
-	else
+	if (nents == SG_MAX_SINGLE_ALLOC) {
+		void *ptr = (void *) __get_free_page(gfp_mask);
+		kmemleak_alloc(ptr, PAGE_SIZE, 1, gfp_mask);
+		return ptr;
+	} else
 		return kmalloc(nents * sizeof(struct scatterlist), gfp_mask);
 }
 
 static void sg_kfree(struct scatterlist *sg, unsigned int nents)
 {
-	if (nents == SG_MAX_SINGLE_ALLOC)
+	if (nents == SG_MAX_SINGLE_ALLOC) {
+		kmemleak_free(sg);
 		free_page((unsigned long) sg);
-	else
+	} else
 		kfree(sg);
 }
 
-- 
1.7.1

