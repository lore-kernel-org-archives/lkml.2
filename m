Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2A3Ii2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:38:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47156 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2A3Ii1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:38:27 -0500
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH 2/3] vmalloc: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
Date: Mon, 30 Jan 2012 12:39:26 +0400
Message-Id: <1327912766-8779-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - Fix vmap() to return ZERO_SIZE_PTR if 0 pages are requested;
 - fix __vmalloc_node_range() to return ZERO_SIZE_PTR if 0 bytes
   are requested;
 - fix __vunmap() to check passed pointer with ZERO_OR_NULL_PTR.

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 mm/vmalloc.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 86ce9a5..040a9cd 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1456,7 +1456,7 @@ static void __vunmap(const void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
 
-	if (!addr)
+	if (unlikely(ZERO_OR_NULL_PTR(addr)))
 		return;
 
 	if ((PAGE_SIZE-1) & (unsigned long)addr) {
@@ -1548,7 +1548,9 @@ void *vmap(struct page **pages, unsigned int count,
 
 	might_sleep();
 
-	if (count > totalram_pages)
+	if (unlikely(!count))
+		return ZERO_SIZE_PTR;
+	if (unlikely(count > totalram_pages))
 		return NULL;
 
 	area = get_vm_area_caller((count << PAGE_SHIFT), flags,
@@ -1648,8 +1650,10 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	void *addr;
 	unsigned long real_size = size;
 
+	if (unlikely(!size))
+		return ZERO_SIZE_PTR;
 	size = PAGE_ALIGN(size);
-	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
+	if (unlikely((size >> PAGE_SHIFT) > totalram_pages))
 		goto fail;
 
 	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNLIST,
-- 
1.7.7.6

