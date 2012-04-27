Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab2D0MjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:39:19 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40149 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757169Ab2D0MjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:39:15 -0400
Subject: [PATCH 2/2] proc: report page->index instead of pfn for non-linear
 mappings in /proc/pid/pagemap
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Pavel Emelyanov <xemul@parallels.com>
Date: Fri, 27 Apr 2012 16:39:11 +0400
Message-ID: <20120427123910.2132.7022.stgit@zurg>
In-Reply-To: <4F91BC8A.9020503@parallels.com>
References: <4F91BC8A.9020503@parallels.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no way to find out current layout of non-linear mapping.
Also there is no way to distinguish ordinary file mapping from non-linear mapping.

Now in pagemap non-linear pte can be recognized as present swapped file-backed,
or as non-present non-swapped file-backed for non-present non-linear file-pte:

    present swapped file    data        description
    0       0       0       null        non-present
    0       0       1       page-index  non-linear file-pte
    0       1       0       swap-entry  anon-page in swap, migration or hwpoison
    0       1       1       swap-entry  file-page in migration or hwpoison
    1       0       0       page-pfn    present private-anon or special page
    1       0       1       page-pfn    present file or shared-anon page
    1       1       0       none        impossible combination
    1       1       1       page-index  non-linear file-page

[ the last unused combination 1-1-0 can be used for special pages, if anyone want this ]

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
---
 Documentation/vm/pagemap.txt |   15 +++++++++++++++
 fs/proc/task_mmu.c           |   13 +++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/pagemap.txt b/Documentation/vm/pagemap.txt
index 7587493..6800dda 100644
--- a/Documentation/vm/pagemap.txt
+++ b/Documentation/vm/pagemap.txt
@@ -13,6 +13,7 @@ There are three components to pagemap:
    fs/proc/task_mmu.c, above pagemap_read):
 
     * Bits 0-54  page frame number (PFN) if present
+    * Bits 0-54  page index for non-linear mappings
     * Bits 0-4   swap type if swapped
     * Bits 5-54  swap offset if swapped
     * Bits 55-60 page shift (page size = 1<<page shift)
@@ -26,6 +27,20 @@ There are three components to pagemap:
    precisely which pages are mapped (or in swap) and comparing mapped
    pages between processes.
 
+   For non-linear file mappings page index is reported instead of PFN.
+   Non-linear pte can be recognized as present swapped file-backed or
+   non-present non-swapped file-backed.
+
+    present swapped file    data	description
+    0       0       0       null	non-present
+    0       0       1       page-index	non-linear file-pte
+    0       1       0       swap-entry	anon-page in swap, migration or hwpoison
+    0       1       1       swap-entry	file-page in migration or hwpoison
+    1       0       0       page-pfn	present private-anon or special page
+    1       0       1       page-pfn	present file or shared-anon page
+    1       1       0       none	impossible combination
+    1       1       1       page-index	non-linear file-page
+
    Efficient users of this interface will use /proc/pid/maps to
    determine which areas of memory are actually mapped and llseek to
    skip over unmapped regions.
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index bc3df31..fcc802f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -744,6 +744,9 @@ static void pte_to_pagemap_entry(pagemap_entry_t *pme,
 		frame = pte_pfn(pte);
 		flags = PM_PRESENT;
 		page = vm_normal_page(vma, addr, pte);
+	} if (pte_file(pte)) {
+		frame = pte_to_pgoff(pte);
+		flags = PM_FILE;
 	} if (is_swap_pte(pte)) {
 		swp_entry_t entry = pte_to_swp_entry(pte);
 
@@ -755,8 +758,13 @@ static void pte_to_pagemap_entry(pagemap_entry_t *pme,
 	} else
 		return;
 
-	if (page && !PageAnon(page))
-		flags |= PM_FILE;
+	if (page) {
+		if (vma->vm_flags & VM_NONLINEAR) {
+			frame = page->index;
+			flags = PM_FILE | PM_SWAP | PM_PRESENT;
+		} else if (!PageAnon(page))
+			flags |= PM_FILE;
+	}
 
 	*pme = make_pme(PM_PFRAME(frame) | PM_PSHIFT(PAGE_SHIFT) | flags);
 }
@@ -874,6 +882,7 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
  * consisting of the following:
  *
  * Bits 0-54  page frame number (PFN) if present
+ * Bits 0-54  page index for non-linear mappings
  * Bits 0-4   swap type if swapped
  * Bits 5-54  swap offset if swapped
  * Bits 55-60 page shift (page size = 1<<page shift)

