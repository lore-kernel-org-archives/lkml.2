Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2L1Ro5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 12:44:57 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:38570 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2L1Ro4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 12:44:56 -0500
From: cdall@cs.columbia.edu
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: cl@linux.com, Christoffer Dall <cdall@cs.columbia.edu>,
        Steve Capper <steve.capper@arm.com>, Will Deacon <will.deacon@arm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v2] mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED
Date: Fri, 28 Dec 2012 12:18:35 -0500
Message-Id: <1356715115-32435-1-git-send-email-cdall@cs.columbia.edu>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356714442-27028-1-git-send-email-cdall@cs.columbia.edu>
References: <1356714442-27028-1-git-send-email-cdall@cs.columbia.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoffer Dall <cdall@cs.columbia.edu>

Unfortunately with !CONFIG_PAGEFLAGS_EXTENDED, (!PageHead) is false, and
(PageHead) is true, for tail pages.  This breaks cache cleaning on some
ARM systems, and may cause other bugs.

This patch makes sure PageHead is only true for head pages and PageTail
is only true for tail pages, and neither is true for non-compound pages.

Cc: Steve Capper <steve.capper@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Christoffer Dall <cdall@cs.columbia.edu>
---

Changes since v1:
 - Andrea's e-mail address was misspelled

 include/linux/page-flags.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b5d1384..70473da 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -362,7 +362,7 @@ static inline void ClearPageCompound(struct page *page)
  * pages on the LRU and/or pagecache.
  */
 TESTPAGEFLAG(Compound, compound)
-__PAGEFLAG(Head, compound)
+__SETPAGEFLAG(Head, compound)  __CLEARPAGEFLAG(Head, compound)
 
 /*
  * PG_reclaim is used in combination with PG_compound to mark the
@@ -374,8 +374,14 @@ __PAGEFLAG(Head, compound)
  * PG_compound & PG_reclaim	=> Tail page
  * PG_compound & ~PG_reclaim	=> Head page
  */
+#define PG_head_mask ((1L << PG_compound))
 #define PG_head_tail_mask ((1L << PG_compound) | (1L << PG_reclaim))
 
+static inline int PageHead(struct page *page)
+{
+	return ((page->flags & PG_head_tail_mask) == PG_head_mask);
+}
+
 static inline int PageTail(struct page *page)
 {
 	return ((page->flags & PG_head_tail_mask) == PG_head_tail_mask);
-- 
1.7.9.5

