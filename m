Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab0FUUj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:39:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758391Ab0FUUj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:39:56 -0400
Date: Mon, 21 Jun 2010 16:35:30 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org
Subject: [PATCH -mm 4/6] always use anon_vma root pointer
Message-ID: <20100621163530.20c88a7c@annuminas.surriel.com>
In-Reply-To: <20100621163146.4e4e30cb@annuminas.surriel.com>
References: <20100621163146.4e4e30cb@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: always use anon_vma root pointer

Always use anon_vma->root pointer instead of anon_vma_chain.prev.

Also optimize the map-paths, if a mapping is already established no need to
overwrite it with root anon-vma list, we can keep the more finegrined anon-vma
and skip the overwrite: see the PageAnon check in !exclusive case. This is also
the optimization that hidden the ksm bug as this tends to make
ksm_might_need_to_copy skip the copy, but only the proper fix to
ksm_might_need_to_copy guarantees not triggering the ksm bug unless ksm is in
use. this is an optimization only...

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

diff --git a/mm/rmap.c b/mm/rmap.c
index 006f223..2d9504d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -776,15 +776,13 @@ static void __page_set_anon_rmap(struct page *page,
 	 * If the page isn't exclusively mapped into this vma,
 	 * we must use the _oldest_ possible anon_vma for the
 	 * page mapping!
-	 *
-	 * So take the last AVC chain entry in the vma, which is
-	 * the deepest ancestor, and use the anon_vma from that.
 	 */
 	if (!exclusive) {
-		struct anon_vma_chain *avc;
-		avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
-		anon_vma = avc->anon_vma;
-	}
+		if (PageAnon(page))
+			return;
+		anon_vma = anon_vma->root;
+	} else
+		BUG_ON(PageAnon(page));
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	page->mapping = (struct address_space *) anon_vma;
