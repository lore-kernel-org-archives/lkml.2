Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab2ECIM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:12:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39304 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2ECIMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:12:51 -0400
Date: Thu, 3 May 2012 17:12:44 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: peterz@infradead.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        yoshikawa.takuya@oss.ntt.co.jp
Subject: [RFC] sched: make callers check lock contention for
 cond_resched_lock()
Message-Id: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for showing what I am thinking and only compile tested
on linux-next, so an RFC.

Although I might misread something, I am not sure whether every user of
this API wanted to avoid contention check without CONFIG_PREEMPT.

Any comments will be appreciated.

Thanks,
	Takuya

===
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

While doing kvm development, we found a case in which we wanted to break
a critical section on lock contention even without CONFIG_PREEMPT.

Although we can do that using spin_is_contended() and cond_resched(),
changing cond_resched_lock() to satisfy such a need is another option.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 arch/x86/kvm/mmu.c       |    3 ++-
 fs/btrfs/extent_io.c     |    2 +-
 fs/btrfs/inode.c         |    3 ++-
 fs/btrfs/ordered-data.c  |    3 ++-
 fs/btrfs/relocation.c    |    3 ++-
 fs/dcache.c              |    3 ++-
 fs/fscache/object.c      |    3 ++-
 fs/jbd/commit.c          |    6 ++++--
 fs/jbd2/commit.c         |    3 ++-
 fs/nfs/nfs4filelayout.c  |    2 +-
 fs/nfs/write.c           |    2 +-
 fs/ocfs2/dlm/dlmdomain.c |    5 +++--
 fs/ocfs2/dlm/dlmthread.c |    3 ++-
 fs/reiserfs/journal.c    |    4 ++--
 include/linux/sched.h    |    6 +++---
 kernel/sched/core.c      |    4 ++--
 16 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 07424cf..3361ee3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1704,7 +1704,8 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 			mmu_pages_clear_parents(&parents);
 		}
 		kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
-		cond_resched_lock(&vcpu->kvm->mmu_lock);
+		cond_resched_lock(&vcpu->kvm->mmu_lock,
+				  spin_is_contended(&vcpu->kvm->mmu_lock));
 		kvm_mmu_pages_init(parent, &parents, &pages);
 	}
 }
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 198c2ba..cfcc233 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -675,7 +675,7 @@ again:
 		if (start > end)
 			break;
 
-		cond_resched_lock(&tree->lock);
+		cond_resched_lock(&tree->lock, spin_needbreak(&tree->lock));
 	}
 out:
 	spin_unlock(&tree->lock);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 61b16c6..16a6173 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3985,7 +3985,8 @@ again:
 			goto again;
 		}
 
-		if (cond_resched_lock(&root->inode_lock))
+		if (cond_resched_lock(&root->inode_lock,
+				      spin_needbreak(&root->inode_lock)))
 			goto again;
 
 		node = rb_next(node);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index bbf6d0d..1dfcd6d 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -485,7 +485,8 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root,
 		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags)) {
 			list_move(&ordered->root_extent_list,
 				  &root->fs_info->ordered_extents);
-			cond_resched_lock(&root->fs_info->ordered_extent_lock);
+			cond_resched_lock(&root->fs_info->ordered_extent_lock,
+				spin_needbreak(&root->fs_info->ordered_extent_lock));
 			continue;
 		}
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 646ee21..6102a62 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1471,7 +1471,8 @@ again:
 		}
 
 		objectid = btrfs_ino(&entry->vfs_inode) + 1;
-		if (cond_resched_lock(&root->inode_lock))
+		if (cond_resched_lock(&root->inode_lock,
+				      spin_needbreak(&root->inode_lock)))
 			goto again;
 
 		node = rb_next(node);
diff --git a/fs/dcache.c b/fs/dcache.c
index 58a6ecf..dccfa62 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -855,7 +855,8 @@ relock:
 			if (!--count)
 				break;
 		}
-		cond_resched_lock(&dcache_lru_lock);
+		cond_resched_lock(&dcache_lru_lock,
+				  spin_needbreak(&dcache_lru_lock));
 	}
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index b6b897c..9db99c6 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -824,7 +824,8 @@ static void fscache_enqueue_dependents(struct fscache_object *object)
 		fscache_put_object(dep);
 
 		if (!list_empty(&object->dependents))
-			cond_resched_lock(&object->lock);
+			cond_resched_lock(&object->lock,
+					  spin_needbreak(&object->lock));
 	}
 
 	spin_unlock(&object->lock);
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 52c15c7..59c60bf 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -474,7 +474,8 @@ void journal_commit_transaction(journal_t *journal)
 			__journal_unfile_buffer(jh);
 		jbd_unlock_bh_state(bh);
 		release_data_buffer(bh);
-		cond_resched_lock(&journal->j_list_lock);
+		cond_resched_lock(&journal->j_list_lock,
+				  spin_needbreak(&journal->j_list_lock));
 	}
 	spin_unlock(&journal->j_list_lock);
 
@@ -905,7 +906,8 @@ restart_loop:
 			release_buffer_page(bh);
 		else
 			__brelse(bh);
-		cond_resched_lock(&journal->j_list_lock);
+		cond_resched_lock(&journal->j_list_lock,
+				  spin_needbreak(&journal->j_list_lock));
 	}
 	spin_unlock(&journal->j_list_lock);
 	/*
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 840f70f..5e71afa 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -989,7 +989,8 @@ restart_loop:
 			release_buffer_page(bh);	/* Drops bh reference */
 		else
 			__brelse(bh);
-		cond_resched_lock(&journal->j_list_lock);
+		cond_resched_lock(&journal->j_list_lock,
+				  spin_needbreak(&journal->j_list_lock));
 	}
 	spin_unlock(&journal->j_list_lock);
 	/*
diff --git a/fs/nfs/nfs4filelayout.c b/fs/nfs/nfs4filelayout.c
index 5acfd9e..0536aab 100644
--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -946,7 +946,7 @@ filelayout_scan_ds_commit_list(struct nfs4_fl_commit_bucket *bucket, int max,
 	list_for_each_entry_safe(req, tmp, src, wb_list) {
 		if (!nfs_lock_request(req))
 			continue;
-		if (cond_resched_lock(lock))
+		if (cond_resched_lock(lock, spin_needbreak(lock)))
 			list_safe_reset_next(req, tmp, wb_list);
 		nfs_request_remove_commit_list(req);
 		clear_bit(PG_COMMIT_TO_DS, &req->wb_flags);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index c074623..0d83257 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -570,7 +570,7 @@ nfs_scan_commit_list(struct list_head *src, struct list_head *dst, int max,
 	list_for_each_entry_safe(req, tmp, src, wb_list) {
 		if (!nfs_lock_request(req))
 			continue;
-		if (cond_resched_lock(lock))
+		if (cond_resched_lock(lock, spin_needbreak(lock)))
 			list_safe_reset_next(req, tmp, wb_list);
 		nfs_request_remove_commit_list(req);
 		nfs_list_add_request(req, dst);
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 9e89d70..5602e4c 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -465,11 +465,12 @@ redo_bucket:
 			dlm_lockres_put(res);
 
 			if (dropped) {
-				cond_resched_lock(&dlm->spinlock);
+				cond_resched_lock(&dlm->spinlock,
+						  spin_needbreak(&dlm->spinlock));
 				goto redo_bucket;
 			}
 		}
-		cond_resched_lock(&dlm->spinlock);
+		cond_resched_lock(&dlm->spinlock, spin_needbreak(&dlm->spinlock));
 		num += n;
 	}
 	spin_unlock(&dlm->spinlock);
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index e73c833..ee86242 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -276,7 +276,8 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
 		dlm_lockres_put(lockres);
 
 		/* Avoid adding any scheduling latencies */
-		cond_resched_lock(&dlm->spinlock);
+		cond_resched_lock(&dlm->spinlock,
+				  spin_needbreak(&dlm->spinlock));
 	}
 
 	spin_unlock(&dlm->spinlock);
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index b1a0857..d58f596 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -835,7 +835,7 @@ static int write_ordered_buffers(spinlock_t * lock,
 		}
 	      loop_next:
 		put_bh(bh);
-		cond_resched_lock(lock);
+		cond_resched_lock(lock, spin_needbreak(lock));
 	}
 	if (chunk.nr) {
 		spin_unlock(lock);
@@ -870,7 +870,7 @@ static int write_ordered_buffers(spinlock_t * lock,
 			spin_lock(lock);
 		}
 		put_bh(bh);
-		cond_resched_lock(lock);
+		cond_resched_lock(lock, spin_needbreak(lock));
 	}
 	spin_unlock(lock);
 	return ret;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d2acbd..61f4396 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2723,7 +2723,7 @@ extern int _cond_resched(void);
 	_cond_resched();			\
 })
 
-extern int __cond_resched_lock(spinlock_t *lock);
+extern int __cond_resched_lock(spinlock_t *lock, int need_break);
 
 #ifdef CONFIG_PREEMPT_COUNT
 #define PREEMPT_LOCK_OFFSET	PREEMPT_OFFSET
@@ -2731,9 +2731,9 @@ extern int __cond_resched_lock(spinlock_t *lock);
 #define PREEMPT_LOCK_OFFSET	0
 #endif
 
-#define cond_resched_lock(lock) ({				\
+#define cond_resched_lock(lock, need_break) ({			\
 	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
-	__cond_resched_lock(lock);				\
+	__cond_resched_lock(lock, need_break);			\
 })
 
 extern int __cond_resched_softirq(void);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 477b998..470113f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4570,14 +4570,14 @@ EXPORT_SYMBOL(_cond_resched);
  * operations here to prevent schedule() from being called twice (once via
  * spin_unlock(), once by hand).
  */
-int __cond_resched_lock(spinlock_t *lock)
+int __cond_resched_lock(spinlock_t *lock, int need_break)
 {
 	int resched = should_resched();
 	int ret = 0;
 
 	lockdep_assert_held(lock);
 
-	if (spin_needbreak(lock) || resched) {
+	if (need_break || resched) {
 		spin_unlock(lock);
 		if (resched)
 			__cond_resched();
-- 
1.7.5.4

