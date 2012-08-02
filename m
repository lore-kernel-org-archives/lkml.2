Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2HBNL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:11:28 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:47400 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab2HBNL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:11:26 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        Glauber Costa <glommer@parallels.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: [PATCH] slub: use free_page instead of put_page for freeing kmalloc allocation
Date: Thu,  2 Aug 2012 17:11:05 +0400
Message-Id: <1343913065-14631-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slab allocators provide its users with memory regions, with very few
placement guarantees. No user should assume an actual page is given by
kmalloc calls that are multiple of a page in size. This means that we
can be sure that every sane user of the interface would not mess with
the page reference counting of the underlying page.

When freeing objects, the slub allocator will most of the time free
empty pages by calling __free_pages(). But high-order kmalloc will be
diposed by means of put_page() instead.

It makes no sense to call put_page() in kernel pages that are not
reference counted, which is the case here.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: David Rientjes <rientjes@google.com>
CC: Pekka Enberg <penberg@kernel.org>
CC: Christoph Lameter <cl@linux.com>
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index e517d43..9ca4e20 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3453,7 +3453,7 @@ void kfree(const void *x)
 	if (unlikely(!PageSlab(page))) {
 		BUG_ON(!PageCompound(page));
 		kmemleak_free(x);
-		put_page(page);
+		__free_pages(page, compound_order(page));
 		return;
 	}
 	slab_free(page->slab, page, object, _RET_IP_);
-- 
1.7.11.2

