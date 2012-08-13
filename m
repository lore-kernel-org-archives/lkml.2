Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2HMWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:16:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60108 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab2HMWQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:16:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [ 21/65] mm: mmu_notifier: fix freed page still mapped in secondary MMU
Date: Mon, 13 Aug 2012 15:14:05 -0700
Message-Id: <20120813221416.825074565@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

commit 3ad3d901bbcfb15a5e4690e55350db0899095a68 upstream.

mmu_notifier_release() is called when the process is exiting.  It will
delete all the mmu notifiers.  But at this time the page belonging to the
process is still present in page tables and is present on the LRU list, so
this race will happen:

      CPU 0                 CPU 1
mmu_notifier_release:    try_to_unmap:
   hlist_del_init_rcu(&mn->hlist);
                            ptep_clear_flush_notify:
                                  mmu nofifler not found
                            free page  !!!!!!
                            /*
                             * At the point, the page has been
                             * freed, but it is still mapped in
                             * the secondary MMU.
                             */

  mn->ops->release(mn, mm);

Then the box is not stable and sometimes we can get this bug:

[  738.075923] BUG: Bad page state in process migrate-perf  pfn:03bec
[  738.075931] page:ffffea00000efb00 count:0 mapcount:0 mapping:          (null) index:0x8076
[  738.075936] page flags: 0x20000000000014(referenced|dirty)

The same issue is present in mmu_notifier_unregister().

We can call ->release before deleting the notifier to ensure the page has
been unmapped from the secondary MMU before it is freed.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mmu_notifier.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -33,6 +33,24 @@
 void __mmu_notifier_release(struct mm_struct *mm)
 {
 	struct mmu_notifier *mn;
+	struct hlist_node *n;
+
+	/*
+	 * RCU here will block mmu_notifier_unregister until
+	 * ->release returns.
+	 */
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist)
+		/*
+		 * if ->release runs before mmu_notifier_unregister it
+		 * must be handled as it's the only way for the driver
+		 * to flush all existing sptes and stop the driver
+		 * from establishing any more sptes before all the
+		 * pages in the mm are freed.
+		 */
+		if (mn->ops->release)
+			mn->ops->release(mn, mm);
+	rcu_read_unlock();
 
 	spin_lock(&mm->mmu_notifier_mm->lock);
 	while (unlikely(!hlist_empty(&mm->mmu_notifier_mm->list))) {
@@ -46,23 +64,6 @@ void __mmu_notifier_release(struct mm_st
 		 * mmu_notifier_unregister to return.
 		 */
 		hlist_del_init_rcu(&mn->hlist);
-		/*
-		 * RCU here will block mmu_notifier_unregister until
-		 * ->release returns.
-		 */
-		rcu_read_lock();
-		spin_unlock(&mm->mmu_notifier_mm->lock);
-		/*
-		 * if ->release runs before mmu_notifier_unregister it
-		 * must be handled as it's the only way for the driver
-		 * to flush all existing sptes and stop the driver
-		 * from establishing any more sptes before all the
-		 * pages in the mm are freed.
-		 */
-		if (mn->ops->release)
-			mn->ops->release(mn, mm);
-		rcu_read_unlock();
-		spin_lock(&mm->mmu_notifier_mm->lock);
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
@@ -284,16 +285,13 @@ void mmu_notifier_unregister(struct mmu_
 {
 	BUG_ON(atomic_read(&mm->mm_count) <= 0);
 
-	spin_lock(&mm->mmu_notifier_mm->lock);
 	if (!hlist_unhashed(&mn->hlist)) {
-		hlist_del_rcu(&mn->hlist);
-
 		/*
 		 * RCU here will force exit_mmap to wait ->release to finish
 		 * before freeing the pages.
 		 */
 		rcu_read_lock();
-		spin_unlock(&mm->mmu_notifier_mm->lock);
+
 		/*
 		 * exit_mmap will block in mmu_notifier_release to
 		 * guarantee ->release is called before freeing the
@@ -302,8 +300,11 @@ void mmu_notifier_unregister(struct mmu_
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
 		rcu_read_unlock();
-	} else
+
+		spin_lock(&mm->mmu_notifier_mm->lock);
+		hlist_del_rcu(&mn->hlist);
 		spin_unlock(&mm->mmu_notifier_mm->lock);
+	}
 
 	/*
 	 * Wait any running method to finish, of course including


