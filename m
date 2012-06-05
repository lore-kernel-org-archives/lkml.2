Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116Ab2FEGe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 02:34:28 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61260 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753693Ab2FEGe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 02:34:26 -0400
MIME-Version: 1.0
Date: Tue, 5 Jun 2012 14:34:25 +0800
Message-ID: <CAA7+ByWuSVzKsgCwyrrac=faWuGY9FxHpeSiJ0-WtP7DVg4y1g@mail.gmail.com>
Subject: [PATCH] vmalloc: walk vmap_areas by sorted list instead of rb_next()
From: Hong zhi guo <honkiko@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        zhiguo.hong@nsn.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a walk by repeating rb_next to find a suitable hole. Could be
simply replaced by walk on the sorted vmap_area_list. More simpler and
efficient.

Mutation of the list and tree only happens in pair within
__insert_vmap_area and __free_vmap_area, under protection of
vmap_area_lock.  The patch code is also under vmap_area_lock, so the
list walk is safe, and consistent with the tree walk.

Tested on SMP by repeating batch of vmalloc anf vfree for random sizes
and rounds for hours.

Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
---
 mm/vmalloc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2aad499..0eb5347 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -413,11 +413,11 @@ nocache:
 		if (addr + size - 1 < addr)
 			goto overflow;

-		n = rb_next(&first->rb_node);
-		if (n)
-			first = rb_entry(n, struct vmap_area, rb_node);
-		else
+		if (list_is_last(&first->list, &vmap_area_list))
 			goto found;
+
+		first = list_entry(first->list.next,
+				struct vmap_area, list);
 	}

 found:
-- 
1.7.4.1
