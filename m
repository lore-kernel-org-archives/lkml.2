Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab2JJXHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:07:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40616 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932585Ab2JJXDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:25 -0400
X-Sasl-enc: s/9+gQDTnelLoGUbcjRNWoqfsOhdyj4wZ6Y2zE9PuZFA 1349910204
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 062/122] mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP
Date: Thu, 11 Oct 2012 07:53:48 +0900
Message-Id: <20121010225349.283752613@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit 027ef6c87853b0a9df53175063028edb4950d476 upstream.

In many places !pmd_present has been converted to pmd_none.  For pmds
that's equivalent and pmd_none is quicker so using pmd_none is better.

However (unless we delete pmd_present) we should provide an accurate
pmd_present too.  This will avoid the risk of code thinking the pmd is non
present because it's under __split_huge_page_map, see the pmd_mknotpresent
there and the comment above it.

If the page has been mprotected as PROT_NONE, it would also lead to a
pmd_present false negative in the same way as the race with
split_huge_page.

Because the PSE bit stays on at all times (both during split_huge_page and
when the _PAGE_PROTNONE bit get set), we could only check for the PSE bit,
but checking the PROTNONE bit too is still good to remember pmd_present
must always keep PROT_NONE into account.

This explains a not reproducible BUG_ON that was seldom reported on the
lists.

The same issue is in pmd_large, it would go wrong with both PROT_NONE and
if it races with split_huge_page.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/pgtable.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -146,8 +146,7 @@ static inline unsigned long pmd_pfn(pmd_
 
 static inline int pmd_large(pmd_t pte)
 {
-	return (pmd_flags(pte) & (_PAGE_PSE | _PAGE_PRESENT)) ==
-		(_PAGE_PSE | _PAGE_PRESENT);
+	return pmd_flags(pte) & _PAGE_PSE;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -415,7 +414,13 @@ static inline int pte_hidden(pte_t pte)
 
 static inline int pmd_present(pmd_t pmd)
 {
-	return pmd_flags(pmd) & _PAGE_PRESENT;
+	/*
+	 * Checking for _PAGE_PSE is needed too because
+	 * split_huge_page will temporarily clear the present bit (but
+	 * the _PAGE_PSE flag will remain set at all times while the
+	 * _PAGE_PRESENT bit is clear).
+	 */
+	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE);
 }
 
 static inline int pmd_none(pmd_t pmd)


