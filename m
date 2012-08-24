Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab2HXOiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:38:16 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35936 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab2HXOiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:38:13 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 1/2] mm/mmu_notifier: init notifier if necessary
Date: Fri, 24 Aug 2012 22:37:55 +0800
Message-Id: <1345819076-12545-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12082414-3568-0000-0000-0000025C47C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gavin Shan <shangw@linux.vnet.ibm.com>

While registering MMU notifier, new instance of MMU notifier_mm will
be allocated and later free'd if currrent mm_struct's MMU notifier_mm
has been initialized. That cause some overhead. The patch tries to
eleminate that.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/mmu_notifier.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 862b608..fb4067f 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -192,22 +192,23 @@ static int do_mmu_notifier_register(struct mmu_notifier *mn,
 
 	BUG_ON(atomic_read(&mm->mm_users) <= 0);
 
-	ret = -ENOMEM;
-	mmu_notifier_mm = kmalloc(sizeof(struct mmu_notifier_mm), GFP_KERNEL);
-	if (unlikely(!mmu_notifier_mm))
-		goto out;
-
 	if (take_mmap_sem)
 		down_write(&mm->mmap_sem);
 	ret = mm_take_all_locks(mm);
 	if (unlikely(ret))
-		goto out_cleanup;
+		goto out;
 
 	if (!mm_has_notifiers(mm)) {
+		mmu_notifier_mm = kmalloc(sizeof(struct mmu_notifier_mm),
+					GFP_ATOMIC);
+		if (unlikely(!mmu_notifier_mm)) {
+			ret = -ENOMEM;
+			goto out_of_mem;
+		}
 		INIT_HLIST_HEAD(&mmu_notifier_mm->list);
 		spin_lock_init(&mmu_notifier_mm->lock);
+
 		mm->mmu_notifier_mm = mmu_notifier_mm;
-		mmu_notifier_mm = NULL;
 	}
 	atomic_inc(&mm->mm_count);
 
@@ -223,13 +224,12 @@ static int do_mmu_notifier_register(struct mmu_notifier *mn,
 	hlist_add_head(&mn->hlist, &mm->mmu_notifier_mm->list);
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
+out_of_mem:
 	mm_drop_all_locks(mm);
-out_cleanup:
+out:
 	if (take_mmap_sem)
 		up_write(&mm->mmap_sem);
-	/* kfree() does nothing if mmu_notifier_mm is NULL */
-	kfree(mmu_notifier_mm);
-out:
+
 	BUG_ON(atomic_read(&mm->mm_users) <= 0);
 	return ret;
 }
-- 
1.7.7.6

