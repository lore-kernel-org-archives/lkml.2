Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab2D3L3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:29:19 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53084 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441Ab2D3L3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:29:16 -0400
Subject: [PATCH RFC 3/3] proc/smaps: show amount of hwpoison pages
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Date: Mon, 30 Apr 2012 15:29:11 +0400
Message-ID: <20120430112910.14137.28935.stgit@zurg>
In-Reply-To: <20120430112903.14137.81692.stgit@zurg>
References: <20120430112903.14137.81692.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds line "HWPoinson: <size> kB" into /proc/pid/smaps if
CONFIG_MEMORY_FAILURE=y and some HWPoison pages were found.
This may be useful for searching applications which use a broken memory.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
---
 fs/proc/task_mmu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index b1d9729..3e564f0 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -394,6 +394,7 @@ struct mem_size_stats {
 	unsigned long anonymous_thp;
 	unsigned long swap;
 	unsigned long nonlinear;
+	unsigned long hwpoison;
 	u64 pss;
 };
 
@@ -416,6 +417,8 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
 			mss->swap += ptent_size;
 		else if (is_migration_entry(swpent))
 			page = migration_entry_to_page(swpent);
+		else if (is_hwpoison_entry(swpent))
+			mss->hwpoison += ptent_size;
 	} else if (pte_file(ptent)) {
 		if (pte_to_pgoff(ptent) != pgoff)
 			mss->nonlinear += ptent_size;
@@ -430,6 +433,9 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
 	if (page->index != pgoff)
 		mss->nonlinear += ptent_size;
 
+	if (PageHWPoison(page))
+		mss->hwpoison += ptent_size;
+
 	mss->resident += ptent_size;
 	/* Accumulate the size in pages that have been accessed. */
 	if (pte_young(ptent) || PageReferenced(page))
@@ -535,6 +541,10 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 		seq_printf(m, "Nonlinear:      %8lu kB\n",
 				mss.nonlinear >> 10);
 
+	if (IS_ENABLED(CONFIG_MEMORY_FAILURE) && mss.hwpoison)
+		seq_printf(m, "HWPoison:       %8lu kB\n",
+				mss.hwpoison >> 10);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;

