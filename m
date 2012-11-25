Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2KYWeF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 17:34:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab2KYWeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 17:34:01 -0500
Date: Sun, 25 Nov 2012 23:33:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] uprobes: Kill uprobes_mutex[], separate alloc_uprobe()
	and __uprobe_register()
Message-ID: <20121125223350.GA24811@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121125223331.GA24788@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_register() and uprobe_unregister() are the only users of
mutex_lock(uprobes_hash(inode)), and the only reason why we can't
simply remove it is that we need to ensure that delete_uprobe() is
not possible after alloc_uprobe() and before consumer_add().

IOW, we need to ensure that when we take uprobe->register_rwsem
this uprobe is still valid and we didn't race with _unregister()
which called delete_uprobe() in between.

With this patch uprobe_register() simply checks uprobe_is_active()
and retries if it hits this very unlikely race. uprobes_mutex[] is
no longer needed and can be removed.

There is another reason for this change, prepare_uprobe() should be
folded into alloc_uprobe() and we do not want to hold the extra locks
around read_mapping_page/etc.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   51 +++++++++++++---------------------------------
 1 files changed, 15 insertions(+), 36 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 2886c82..105ac0d 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -50,29 +50,6 @@ static struct rb_root uprobes_tree = RB_ROOT;
 static DEFINE_SPINLOCK(uprobes_treelock);	/* serialize rbtree access */
 
 #define UPROBES_HASH_SZ	13
-
-/*
- * We need separate register/unregister and mmap/munmap lock hashes because
- * of mmap_sem nesting.
- *
- * uprobe_register() needs to install probes on (potentially) all processes
- * and thus needs to acquire multiple mmap_sems (consequtively, not
- * concurrently), whereas uprobe_mmap() is called while holding mmap_sem
- * for the particular process doing the mmap.
- *
- * uprobe_register()->register_for_each_vma() needs to drop/acquire mmap_sem
- * because of lock order against i_mmap_mutex. This means there's a hole in
- * the register vma iteration where a mmap() can happen.
- *
- * Thus uprobe_register() can race with uprobe_mmap() and we can try and
- * install a probe where one is already installed.
- */
-
-/* serialize (un)register */
-static struct mutex uprobes_mutex[UPROBES_HASH_SZ];
-
-#define uprobes_hash(v)		(&uprobes_mutex[((unsigned long)(v)) % UPROBES_HASH_SZ])
-
 /* serialize uprobe->pending_list */
 static struct mutex uprobes_mmap_mutex[UPROBES_HASH_SZ];
 #define uprobes_mmap_hash(v)	(&uprobes_mmap_mutex[((unsigned long)(v)) % UPROBES_HASH_SZ])
@@ -865,20 +842,26 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	if (offset > i_size_read(inode))
 		return -EINVAL;
 
-	ret = -ENOMEM;
-	mutex_lock(uprobes_hash(inode));
+ retry:
 	uprobe = alloc_uprobe(inode, offset);
-	if (uprobe) {
-		down_write(&uprobe->register_rwsem);
+	if (!uprobe)
+		return -ENOMEM;
+	/*
+	 * We can race with uprobe_unregister()->delete_uprobe().
+	 * Check uprobe_is_active() and retry if it is false.
+	 */
+	down_write(&uprobe->register_rwsem);
+	ret = -EAGAIN;
+	if (likely(uprobe_is_active(uprobe))) {
 		ret = __uprobe_register(uprobe, uc);
 		if (ret)
 			__uprobe_unregister(uprobe, uc);
-		up_write(&uprobe->register_rwsem);
 	}
-	mutex_unlock(uprobes_hash(inode));
-	if (uprobe)
-		put_uprobe(uprobe);
+	up_write(&uprobe->register_rwsem);
+	put_uprobe(uprobe);
 
+	if (unlikely(ret == -EAGAIN))
+		goto retry;
 	return ret;
 }
 
@@ -896,11 +879,9 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 	if (!uprobe)
 		return;
 
-	mutex_lock(uprobes_hash(inode));
 	down_write(&uprobe->register_rwsem);
 	__uprobe_unregister(uprobe, uc);
 	up_write(&uprobe->register_rwsem);
-	mutex_unlock(uprobes_hash(inode));
 	put_uprobe(uprobe);
 }
 
@@ -1609,10 +1590,8 @@ static int __init init_uprobes(void)
 {
 	int i;
 
-	for (i = 0; i < UPROBES_HASH_SZ; i++) {
-		mutex_init(&uprobes_mutex[i]);
+	for (i = 0; i < UPROBES_HASH_SZ; i++)
 		mutex_init(&uprobes_mmap_mutex[i]);
-	}
 
 	if (percpu_init_rwsem(&dup_mmap_sem))
 		return -ENOMEM;
-- 
1.5.5.1

