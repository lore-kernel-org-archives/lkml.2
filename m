Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0FXDQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:48455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab0FXDPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:49 -0400
Message-Id: <20100624030725.885831564@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:14 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 02/52] fs: fix superblock iteration race
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-fix-iterate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_for_each_entry_safe is not suitable to protect against concurrent
modification of the list. 6754af6 introduced a race in sb walking.

list_for_each_entry can use the trick of pinning the current entry in
the list before we drop and retake the lock because it subsequently
follows cur->next. However list_for_each_entry_safe saves n=cur->next
for following before entering the loop body, so when the lock is
dropped, n may be deleted.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/dcache.c          |    2 ++
 fs/super.c           |    6 ++++++
 include/linux/list.h |   15 +++++++++++++++
 3 files changed, 23 insertions(+)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -590,6 +590,8 @@ static void prune_dcache(int count)
 			up_read(&sb->s_umount);
 		}
 		spin_lock(&sb_lock);
+		/* lock was dropped, must reset next */
+		list_safe_reset_next(sb, n, s_list);
 		count -= pruned;
 		__put_super(sb);
 		/* more work left to do? */
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c
+++ linux-2.6/fs/super.c
@@ -374,6 +374,8 @@ void sync_supers(void)
 			up_read(&sb->s_umount);
 
 			spin_lock(&sb_lock);
+			/* lock was dropped, must reset next */
+			list_safe_reset_next(sb, n, s_list);
 			__put_super(sb);
 		}
 	}
@@ -405,6 +407,8 @@ void iterate_supers(void (*f)(struct sup
 		up_read(&sb->s_umount);
 
 		spin_lock(&sb_lock);
+		/* lock was dropped, must reset next */
+		list_safe_reset_next(sb, n, s_list);
 		__put_super(sb);
 	}
 	spin_unlock(&sb_lock);
@@ -585,6 +589,8 @@ static void do_emergency_remount(struct
 		}
 		up_write(&sb->s_umount);
 		spin_lock(&sb_lock);
+		/* lock was dropped, must reset next */
+		list_safe_reset_next(sb, n, s_list);
 		__put_super(sb);
 	}
 	spin_unlock(&sb_lock);
Index: linux-2.6/include/linux/list.h
===================================================================
--- linux-2.6.orig/include/linux/list.h
+++ linux-2.6/include/linux/list.h
@@ -544,6 +544,21 @@ static inline void list_splice_tail_init
 	     &pos->member != (head); 					\
 	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
 
+/**
+ * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
+ * @pos:	the loop cursor used in the list_for_each_entry_safe loop
+ * @n:		temporary storage used in list_for_each_entry_safe
+ * @member:	the name of the list_struct within the struct.
+ *
+ * list_safe_reset_next is not safe to use in general if the list may be
+ * modified concurrently (eg. the lock is dropped in the loop body). An
+ * exception to this is if the cursor element (pos) is pinned in the list,
+ * and list_safe_reset_next is called after re-taking the lock and before
+ * completing the current iteration of the loop body.
+ */
+#define list_safe_reset_next(pos, n, member)				\
+	n = list_entry(pos->member.next, typeof(*pos), member)
+
 /*
  * Double linked lists with a single pointer list head.
  * Mostly useful for hash tables where the two pointer list head is


