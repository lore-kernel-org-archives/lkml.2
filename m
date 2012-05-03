Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab2ECMvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:51:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab2ECMse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:48:34 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/9] writeback: Move requeueing when I_SYNC set to writeback_sb_inodes()
Date: Thu,  3 May 2012 14:47:56 +0200
Message-Id: <1336049283-5859-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336049283-5859-1-git-send-email-jack@suse.cz>
References: <1336049283-5859-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writeback_single_inode() is called on inode which has I_SYNC already
set while doing WB_SYNC_NONE, inode is moved to b_more_io list. However
this makes sense only if the caller is flusher thread. For other callers of
writeback_single_inode() it doesn't really make sense and may be even wrong
- flusher thread may be doing WB_SYNC_ALL writeback in parallel.

So we move requeueing from writeback_single_inode() to writeback_sb_inodes().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c                |   30 ++++++++++++++++--------------
 include/trace/events/writeback.h |   36 +++++++++++++++++++++++++++++-------
 2 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index dd41437..65cd147 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -373,21 +373,8 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 		WARN_ON(inode->i_state & I_WILL_FREE);
 
 	if (inode->i_state & I_SYNC) {
-		/*
-		 * If this inode is locked for writeback and we are not doing
-		 * writeback-for-data-integrity, move it to b_more_io so that
-		 * writeback can proceed with the other inodes on s_io.
-		 *
-		 * We'll have another go at writing back this inode when we
-		 * completed a full scan of b_io.
-		 */
-		if (wbc->sync_mode != WB_SYNC_ALL) {
-			requeue_io(inode, wb);
-			trace_writeback_single_inode_requeue(inode, wbc,
-							     nr_to_write);
+		if (wbc->sync_mode != WB_SYNC_ALL)
 			return 0;
-		}
-
 		/*
 		 * It's a data-integrity sync.  We must wait.
 		 */
@@ -576,6 +563,21 @@ static long writeback_sb_inodes(struct super_block *sb,
 			redirty_tail(inode, wb);
 			continue;
 		}
+		if ((inode->i_state & I_SYNC) && wbc.sync_mode != WB_SYNC_ALL) {
+			/*
+			 * If this inode is locked for writeback and we are not
+			 * doing writeback-for-data-integrity, move it to
+			 * b_more_io so that writeback can proceed with the
+			 * other inodes on s_io.
+			 *
+			 * We'll have another go at writing back this inode
+			 * when we completed a full scan of b_io.
+			 */
+			spin_unlock(&inode->i_lock);
+			requeue_io(inode, wb);
+			trace_writeback_sb_inodes_requeue(inode);
+			continue;
+		}
 		__iget(inode);
 		write_chunk = writeback_chunk_size(wb->bdi, work);
 		wbc.nr_to_write = write_chunk;
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 7b81887..b453d92 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -372,6 +372,35 @@ TRACE_EVENT(balance_dirty_pages,
 	  )
 );
 
+TRACE_EVENT(writeback_sb_inodes_requeue,
+
+	TP_PROTO(struct inode *inode),
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+		__field(unsigned long, ino)
+		__field(unsigned long, state)
+		__field(unsigned long, dirtied_when)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name,
+		        dev_name(inode_to_bdi(inode)->dev), 32);
+		__entry->ino		= inode->i_ino;
+		__entry->state		= inode->i_state;
+		__entry->dirtied_when	= inode->dirtied_when;
+	),
+
+	TP_printk("bdi %s: ino=%lu state=%s dirtied_when=%lu age=%lu",
+		  __entry->name,
+		  __entry->ino,
+		  show_inode_state(__entry->state),
+		  __entry->dirtied_when,
+		  (jiffies - __entry->dirtied_when) / HZ
+	)
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
@@ -450,13 +479,6 @@ DECLARE_EVENT_CLASS(writeback_single_inode_template,
 	)
 );
 
-DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode_requeue,
-	TP_PROTO(struct inode *inode,
-		 struct writeback_control *wbc,
-		 unsigned long nr_to_write),
-	TP_ARGS(inode, wbc, nr_to_write)
-);
-
 DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode,
 	TP_PROTO(struct inode *inode,
 		 struct writeback_control *wbc,
-- 
1.7.1

