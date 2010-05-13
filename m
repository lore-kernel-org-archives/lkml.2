Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab0EMJzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 05:55:40 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:38123 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab0EMJzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 05:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wRsEwvBVLfCrrjxH8IZNwcyC7flGAfi8cuuM4tVy7craTe/eZUuAeUEPxuJGvdszzT
         8uZh7G0m667XlC69KMCSR3J4p7zLnBOwq9sjgcq4NzsE5xq042lXgPctVpB3F5HM6FDc
         wwrZkrEpVJT7sbrlPFab/gQe33q5wgjFtnEVw=
From: Changli Gao <xiaosuo@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 2/9] relay: use kvcalloc and kvfree
Date: Thu, 13 May 2010 17:55:24 +0800
Message-Id: <1273744524-10030-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use kvcalloc and kvfree

use kvcalloc and kvfree

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 kernel/relay.c |   35 +++--------------------------------
 1 file changed, 3 insertions(+), 32 deletions(-)
diff --git a/kernel/relay.c b/kernel/relay.c
index 3d97f28..002d2f7 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -65,35 +65,6 @@ static const struct vm_operations_struct relay_file_mmap_ops = {
 	.close = relay_file_mmap_close,
 };
 
-/*
- * allocate an array of pointers of struct page
- */
-static struct page **relay_alloc_page_array(unsigned int n_pages)
-{
-	struct page **array;
-	size_t pa_size = n_pages * sizeof(struct page *);
-
-	if (pa_size > PAGE_SIZE) {
-		array = vmalloc(pa_size);
-		if (array)
-			memset(array, 0, pa_size);
-	} else {
-		array = kzalloc(pa_size, GFP_KERNEL);
-	}
-	return array;
-}
-
-/*
- * free an array of pointers of struct page
- */
-static void relay_free_page_array(struct page **array)
-{
-	if (is_vmalloc_addr(array))
-		vfree(array);
-	else
-		kfree(array);
-}
-
 /**
  *	relay_mmap_buf: - mmap channel buffer to process address space
  *	@buf: relay channel buffer
@@ -138,7 +109,7 @@ static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
 	*size = PAGE_ALIGN(*size);
 	n_pages = *size >> PAGE_SHIFT;
 
-	buf->page_array = relay_alloc_page_array(n_pages);
+	buf->page_array = kvcalloc(n_pages, sizeof(struct page *));
 	if (!buf->page_array)
 		return NULL;
 
@@ -159,7 +130,7 @@ static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
 depopulate:
 	for (j = 0; j < i; j++)
 		__free_page(buf->page_array[j]);
-	relay_free_page_array(buf->page_array);
+	kvfree(buf->page_array);
 	return NULL;
 }
 
@@ -218,7 +189,7 @@ static void relay_destroy_buf(struct rchan_buf *buf)
 		vunmap(buf->start);
 		for (i = 0; i < buf->page_count; i++)
 			__free_page(buf->page_array[i]);
-		relay_free_page_array(buf->page_array);
+		kvfree(buf->page_array);
 	}
 	chan->buf[buf->cpu] = NULL;
 	kfree(buf->padding);
