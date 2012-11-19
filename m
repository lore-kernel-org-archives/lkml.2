Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab2KSFaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:30:17 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59330 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab2KSFaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:30:13 -0500
X-Originating-IP: 217.70.178.152
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/58] mm: include/linux/huge_mm.h: Declare handle_pte_fault unconditionally
Date: Sun, 18 Nov 2012 21:28:04 -0800
Message-Id: <1353302917-13995-26-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/huge_mm.h declares handle_pte_fault inside an ifdef
CONFIG_TRANSPARENT_HUGEPAGE; however, mm/memory.c defines the function
unconditionally.  Move the function outside of the ifdef.

This eliminates a warning from gcc (-Wmissing-prototypes) and from
Sparse (-Wdecl).

mm/memory.c:3449:5: warning: no previous prototype for ‘handle_pte_fault’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/huge_mm.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 3f39803..8ed2187 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -55,6 +55,10 @@ extern pmd_t *page_check_address_pmd(struct page *page,
 
 extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 
+extern int handle_pte_fault(struct mm_struct *mm,
+			    struct vm_area_struct *vma, unsigned long address,
+			    pte_t *pte, pmd_t *pmd, unsigned int flags);
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define HPAGE_PMD_SHIFT HPAGE_SHIFT
 #define HPAGE_PMD_MASK HPAGE_MASK
@@ -87,9 +91,6 @@ extern int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			  pmd_t *dst_pmd, pmd_t *src_pmd,
 			  struct vm_area_struct *vma,
 			  unsigned long addr, unsigned long end);
-extern int handle_pte_fault(struct mm_struct *mm,
-			    struct vm_area_struct *vma, unsigned long address,
-			    pte_t *pte, pmd_t *pmd, unsigned int flags);
 extern int split_huge_page(struct page *page);
 extern void __split_huge_page_pmd(struct mm_struct *mm, pmd_t *pmd);
 #define split_huge_page_pmd(__mm, __pmd)				\
-- 
1.7.10.4

