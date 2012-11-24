Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab2KXERG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 23:17:06 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46652 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab2KXERE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 23:17:04 -0500
MIME-Version: 1.0
Date: Sat, 24 Nov 2012 12:17:03 +0800
Message-ID: <CAJd=RBCzydfXGBPLdkyvKaGZPK9H-pKa1-vk38dnZpeiZM8n3w@mail.gmail.com>
Subject: [PATCH 1/3] balancenuma: add stats for huge pmd numa faults
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A thp contributes 512 times more than a regular page to numa fault stats,
so deserves its own vm event counter. THP migration is also accounted.

[A duplicated computation of page node idx is cleaned up]

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/include/linux/vm_event_item.h	Fri Nov 23 21:24:12 2012
+++ b/include/linux/vm_event_item.h	Fri Nov 23 21:37:32 2012
@@ -40,6 +40,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
 #ifdef CONFIG_BALANCE_NUMA
 		NUMA_PTE_UPDATES,
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		NUMA_THP_HINT_FAULTS,
+		NUMA_THP_HINT_FAULTS_LOCAL,
+		NUMA_THP_MIGRATE_SUCCESS,
+		NUMA_THP_MIGRATE_FAIL,
+#endif
 		NUMA_HINT_FAULTS,
 		NUMA_HINT_FAULTS_LOCAL,
 		NUMA_PAGE_MIGRATE,
--- a/mm/huge_memory.c	Fri Nov 23 21:28:04 2012
+++ b/mm/huge_memory.c	Fri Nov 23 21:52:06 2012
@@ -1035,12 +1035,13 @@ int do_huge_pmd_numa_page(struct mm_stru

 	page = pmd_page(pmd);
 	get_page(page);
-	count_vm_numa_event(NUMA_HINT_FAULTS);
 	current_nid = page_to_nid(page);
+	count_vm_numa_event(NUMA_THP_HINT_FAULTS);
+	if (current_nid == numa_node_id())
+		count_vm_numa_event(NUMA_THP_HINT_FAULTS_LOCAL);

 	target_nid = mpol_misplaced(page, vma, haddr);
 	if (target_nid == -1) {
-		current_nid = page_to_nid(page);
 		put_page(page);
 		goto clear_pmdnuma;
 	}
@@ -1063,9 +1064,11 @@ int do_huge_pmd_numa_page(struct mm_stru
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
 				pmdp, pmd, addr,
 				page, target_nid);
-	if (migrated)
+	if (migrated) {
+		count_vm_numa_event(NUMA_THP_MIGRATE_SUCCESS);
 		current_nid = target_nid;
-	else {
+	} else {
+		count_vm_numa_event(NUMA_THP_MIGRATE_FAIL);
 		spin_lock(&mm->page_table_lock);
 		if (unlikely(!pmd_same(pmd, *pmdp))) {
 			unlock_page(page);
--- a/mm/vmstat.c	Fri Nov 23 21:30:04 2012
+++ b/mm/vmstat.c	Fri Nov 23 21:57:32 2012
@@ -776,6 +776,12 @@ const char * const vmstat_text[] = {

 #ifdef CONFIG_BALANCE_NUMA
 	"numa_pte_updates",
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	"numa_thp_hint_faults",
+	"numa_thp_hint_faults_local",
+	"numa_thp_migrated_success",
+	"numa_thp_migrated_fail",
+#endif
 	"numa_hint_faults",
 	"numa_hint_faults_local",
 	"numa_pages_migrated",
--
