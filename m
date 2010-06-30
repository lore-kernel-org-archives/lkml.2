Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab0F3TMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:12:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35272 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab0F3TMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:12:43 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH -rt 1/2] Revert select_parent locking fix
Date: Wed, 30 Jun 2010 12:12:24 -0700
Message-Id: <1277925145-8355-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against currrent 2.6.33-rt tree.

This reverts 697684652c217b241a07d9e261c7a20e9b072d43 which resolved a
locking issue with select_parent. Unfortunately the fix, which keeps
the entire subchain locked, breaks lockdep.

Reverting so a proper fix can follow.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Nick Piggin <npiggin@suse.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: John Kacur <jkacur@redhat.com>
---
 fs/dcache.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 18a3b76..da90157 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1052,12 +1052,12 @@ resume:
 
 		/*
 		 * Descend a level if the d_subdirs list is non-empty.
-		 * Note that we keep a hold on the parent lock while
-		 * we descend, so we don't have to reacquire it on
-		 * ascend.
 		 */
 		if (!list_empty(&dentry->d_subdirs)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
 			this_parent = dentry;
+			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
 
@@ -1071,20 +1071,25 @@ resume:
 		struct dentry *child;
 
 		tmp = this_parent->d_parent;
-		child = this_parent;
-		next = child->d_u.d_child.next;
+		rcu_read_lock();
 		spin_unlock(&this_parent->d_lock);
+		child = this_parent;
 		this_parent = tmp;
+		spin_lock(&this_parent->d_lock);
+		/* might go back up the wrong parent if we have had a rename
+		 * or deletion */
+		if (this_parent != child->d_parent ||
+				// d_unlinked(this_parent) || XXX
+				read_seqretry(&rename_lock, seq)) {
+			spin_unlock(&this_parent->d_lock);
+			rcu_read_unlock();
+			goto rename_retry;
+		}
+		rcu_read_unlock();
+		next = child->d_u.d_child.next;
 		goto resume;
 	}
-
 out:
-	/* Make sure we unlock all the way back up the tree */
-	while (this_parent != parent) {
-		struct dentry *tmp = this_parent->d_parent;
-		spin_unlock(&this_parent->d_lock);
-		this_parent = tmp;
-	}
 	spin_unlock(&this_parent->d_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
-- 
1.6.0.4

