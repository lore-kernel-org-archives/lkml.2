Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2D3L3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:29:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47866 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2D3L3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:29:09 -0400
Subject: [PATCH RFC 1/3] proc/smaps: carefully handle migration entries
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 30 Apr 2012 15:29:03 +0400
Message-ID: <20120430112903.14137.81692.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently smaps reports migration entries as "swap",
as result "swap" can appears in shared mapping.

This patch converts migration entries into pages and handles them as usual.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/proc/task_mmu.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index b073971..acee5fd 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -402,18 +402,20 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = mss->vma;
-	struct page *page;
+	struct page *page = NULL;
 	int mapcount;
 
-	if (is_swap_pte(ptent)) {
-		mss->swap += ptent_size;
-		return;
-	}
+	if (pte_present(ptent)) {
+		page = vm_normal_page(vma, addr, ptent);
+	} else if (is_swap_pte(ptent)) {
+		swp_entry_t swpent = pte_to_swp_entry(ptent);
 
-	if (!pte_present(ptent))
-		return;
+		if (!non_swap_entry(swpent))
+			mss->swap += ptent_size;
+		else if (is_migration_entry(swpent))
+			page = migration_entry_to_page(swpent);
+	}
 
-	page = vm_normal_page(vma, addr, ptent);
 	if (!page)
 		return;
 

