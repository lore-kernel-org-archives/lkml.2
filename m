Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab2KSFau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:30:50 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50924 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2KSFas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:30:48 -0500
X-Originating-IP: 217.70.178.141
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 29/58] mm: Make copy_pte_range static
Date: Sun, 18 Nov 2012 21:28:08 -0800
Message-Id: <1353302917-13995-30-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of mm/memory.c references copy_pte_range.
linux/huge_mm.h prototypes it, but nothing uses that prototype.  Commit
71e3aac0724ffe8918992d76acfe3aad7d8724a5 in January 2011 explicitly made
copy_pte_range non-static, but no commit ever introduced a caller for
copy_pte_range outside of mm/memory.c.  Make the function static.

This eliminates a warning from gcc (-Wmissing-prototypes) and from
Sparse (-Wdecl).

mm/memory.c:917:5: warning: no previous prototype for ‘copy_pte_range’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/huge_mm.h |    4 ----
 mm/memory.c             |    7 ++++---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8ed2187..e10d4fe 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -87,10 +87,6 @@ extern int handle_pte_fault(struct mm_struct *mm,
 #endif /* CONFIG_DEBUG_VM */
 
 extern unsigned long transparent_hugepage_flags;
-extern int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-			  pmd_t *dst_pmd, pmd_t *src_pmd,
-			  struct vm_area_struct *vma,
-			  unsigned long addr, unsigned long end);
 extern int split_huge_page(struct page *page);
 extern void __split_huge_page_pmd(struct mm_struct *mm, pmd_t *pmd);
 #define split_huge_page_pmd(__mm, __pmd)				\
diff --git a/mm/memory.c b/mm/memory.c
index fb135ba..fa106b3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -914,9 +914,10 @@ out_set_pte:
 	return 0;
 }
 
-int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		   pmd_t *dst_pmd, pmd_t *src_pmd, struct vm_area_struct *vma,
-		   unsigned long addr, unsigned long end)
+static int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
+			  pmd_t *dst_pmd, pmd_t *src_pmd,
+			  struct vm_area_struct *vma,
+			  unsigned long addr, unsigned long end)
 {
 	pte_t *orig_src_pte, *orig_dst_pte;
 	pte_t *src_pte, *dst_pte;
-- 
1.7.10.4

