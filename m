Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777Ab2KXE1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 23:27:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57800 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab2KXE1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 23:27:40 -0500
MIME-Version: 1.0
Date: Sat, 24 Nov 2012 12:27:39 +0800
Message-ID: <CAJd=RBCOCnzM0SbUPeCOe=cLfuJ5doFKWnCk5uSZhkJXbSArHA@mail.gmail.com>
Subject: [PATCH 3/3] balancenuma: fix page locking in migrating thp
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fail to migrate thp(due to unsuccessful isolation), and if the original
pmd entry is changed after reaquiring page table lock, it is unsafe to
release the page lock as page maybe unstable.

It is fixed by raising extra page count before trying migration.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/huge_memory.c	Fri Nov 23 22:07:38 2012
+++ b/mm/huge_memory.c	Fri Nov 23 22:55:32 2012
@@ -1060,11 +1060,13 @@ int do_huge_pmd_numa_page(struct mm_stru
 	}
 	spin_unlock(&mm->page_table_lock);

+	get_page(page);
 	/* Migrate the THP to the requested node */
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
 				pmdp, pmd, addr,
 				page, target_nid);
 	if (migrated) {
+		put_page(page);
 		count_vm_numa_event(NUMA_THP_MIGRATE_SUCCESS);
 		current_nid = target_nid;
 	} else {
@@ -1072,8 +1074,10 @@ int do_huge_pmd_numa_page(struct mm_stru
 		spin_lock(&mm->page_table_lock);
 		if (unlikely(!pmd_same(pmd, *pmdp))) {
 			unlock_page(page);
+			put_page(page);
 			goto out_unlock;
 		}
+		put_page(page);
 		goto clear_pmdnuma;
 	}

--
