Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab2KNRba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:31:30 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43400 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab2KNRb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:31:29 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [RFC PATCH] mm: WARN_ON_ONCE if f_op->mmap() change vma's start address
Date: Thu, 15 Nov 2012 02:28:52 +0900
Message-Id: <1352914132-18445-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During reviewing the source code, I found a comment which mention that
after f_op->mmap(), vma's start address can be changed.
I didn't verify that it is really possible, because there are so many
f_op->mmap() implementation. But if there are some mmap() which change
vma's start address, it is possible error situation, because we already
prepare prev vma, rb_link and rb_parent and these are related to original
address.

So add WARN_ON_ONCE for finding that this situtation really happens.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/mmap.c b/mm/mmap.c
index 2d94235..36567b7 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1333,7 +1333,11 @@ munmap_back:
 		 *
 		 * Answer: Yes, several device drivers can do it in their
 		 *         f_op->mmap method. -DaveM
+		 * Bug: If addr is changed, prev, rb_link, rb_parent should
+		 *      be updated for vma_link()
 		 */
+		WARN_ON_ONCE(addr != vma->vm_start);
+
 		addr = vma->vm_start;
 		pgoff = vma->vm_pgoff;
 		vm_flags = vma->vm_flags;
-- 
1.7.9.5

