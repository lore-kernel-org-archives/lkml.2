Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1LSRi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:38:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40257 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1LSRiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:38:25 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH] mm: Fix BUILD_BUG assertion in pmdp_clear_flush_young()
Date: Mon, 19 Dec 2011 09:38:08 -0800
Message-Id: <1324316288-2367-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20111217152253.1aedda0936cd5d1d98be5e76@canb.auug.org.au>
References: <20111217152253.1aedda0936cd5d1d98be5e76@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

It has been reported that when building for sh:

    mm/pgtable-generic.c: In function 'pmdp_clear_flush_young':
    mm/pgtable-generic.c:76: error: call to '__build_bug_failed' declared with attribute error: BUILD_BUG failed

Adding some ugle #ifdeffery will probably fix this issue.

Signed-off-by: David Daney <david.daney@cavium.com>
---

This is completely untested, but may be the best fix for this.  Linus
and others have expressed a dislike for using BUG() to detect what
should be dead code paths at runtime, but it seems to be the state of
the art here.

 mm/pgtable-generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index eb663fb..73784c8 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -70,7 +70,7 @@ int pmdp_clear_flush_young(struct vm_area_struct *vma,
 			   unsigned long address, pmd_t *pmdp)
 {
 	int young;
-#ifndef CONFIG_TRANSPARENT_HUGEPAGE
+#if !defined(CONFIG_HUGETLB_PAGE) || !defined(CONFIG_TRANSPARENT_HUGEPAGE)
 	BUG();
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-- 
1.7.2.3

