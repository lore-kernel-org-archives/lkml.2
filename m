Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0HZQnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:43:31 -0400
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:43489 "EHLO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0HZQn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:43:29 -0400
X-Greylist: delayed 2365 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Aug 2010 12:43:29 EDT
MIME-Version: 1.0
Date: Thu, 26 Aug 2010 11:04:01 -0500
Message-ID: <AANLkTimoCn9uWQ1NTJAhRu7cq1MA+oo6E5p30zeXA3f1@mail.gmail.com>
Subject: [PATCH] scatterlist: prevent invalid free when alloc fails
From: Jeffrey Carlyle <jeff.carlyle@motorola.com>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, jaxboe@fusionio.com,
        OLUSANYA SOYANNWO <c23746@motorola.com>, Hu Tao <taohu@motorola.com>
Content-Type: text/plain; charset=ISO-8859-1
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When alloc fails, free_table is being called. Depending on the number of
bytes requested, we determine if we are going to call _get_free_page()
or kmalloc(). When alloc fails, our math is wrong (due to sg_size - 1),
and the last buffer is wrongfully assumed to have been allocated by
kmalloc. Hence, kfree gets called and a panic occurs.

This fix sets the end marker and allows the proper freeing of the
buffers.

Signed-off-by: Olusanya Soyannwo <c23746@motorola.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Jeffrey Carlyle <jeff.carlyle@motorola.com>
---
 lib/scatterlist.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a5ec428..acf2c6e 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -163,7 +163,7 @@ void __sg_free_table(struct sg_table *table,
unsigned int max_ents,
 		return;

 	sgl = table->sgl;
-	while (table->orig_nents) {
+	while (table->orig_nents && sgl) {
 		unsigned int alloc_size = table->orig_nents;
 		unsigned int sg_size;

@@ -227,6 +227,7 @@ int __sg_alloc_table(struct sg_table *table,
unsigned int nents,
 {
 	struct scatterlist *sg, *prv;
 	unsigned int left;
+	unsigned int total_alloc = 0;

 #ifndef ARCH_HAS_SG_CHAIN
 	BUG_ON(nents > max_ents);
@@ -248,8 +249,14 @@ int __sg_alloc_table(struct sg_table *table,
unsigned int nents,
 		left -= sg_size;

 		sg = alloc_fn(alloc_size, gfp_mask);
-		if (unlikely(!sg))
+		if (unlikely(!sg)) {
+			table->orig_nents = total_alloc;
+			/* mark the end of previous entry */
+			sg_mark_end(&prv[alloc_size - 1]);
 			return -ENOMEM;
+		}
+
+		total_alloc += alloc_size;

 		sg_init_table(sg, alloc_size);
 		table->nents = table->orig_nents += sg_size;
-- 
1.6.3.3
