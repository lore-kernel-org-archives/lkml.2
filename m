Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab2FAORD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:17:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:39264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab2FAORA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:17:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="147036878"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH 2/5] reiserfs: clean-up function return type
Date: Fri,  1 Jun 2012 17:18:05 +0300
Message-Id: <1338560288-10727-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338560288-10727-1-git-send-email-dedekind1@gmail.com>
References: <1338560288-10727-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Turn 'reiserfs_flush_old_commits()' into a void function because the callers
do not cares about what it returns anyway.

We are going to remove the 'sb->s_dirt' field completely and this patch is a
small step towards this direction.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/reiserfs/journal.c  |    8 +++-----
 fs/reiserfs/reiserfs.h |    2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index b1a0857..68aea62 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -3492,7 +3492,7 @@ static void flush_async_commits(struct work_struct *work)
 ** flushes any old transactions to disk
 ** ends the current transaction if it is too old
 */
-int reiserfs_flush_old_commits(struct super_block *sb)
+void reiserfs_flush_old_commits(struct super_block *sb)
 {
 	time_t now;
 	struct reiserfs_transaction_handle th;
@@ -3502,9 +3502,8 @@ int reiserfs_flush_old_commits(struct super_block *sb)
 	/* safety check so we don't flush while we are replaying the log during
 	 * mount
 	 */
-	if (list_empty(&journal->j_journal_list)) {
-		return 0;
-	}
+	if (list_empty(&journal->j_journal_list))
+		return;
 
 	/* check the current transaction.  If there are no writers, and it is
 	 * too old, finish it, and force the commit blocks to disk
@@ -3526,7 +3525,6 @@ int reiserfs_flush_old_commits(struct super_block *sb)
 			do_journal_end(&th, sb, 1, COMMIT_NOW | WAIT);
 		}
 	}
-	return sb->s_dirt;
 }
 
 /*
diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index a59d271..09664c9 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -2452,7 +2452,7 @@ struct reiserfs_transaction_handle *reiserfs_persistent_transaction(struct
 int reiserfs_end_persistent_transaction(struct reiserfs_transaction_handle *);
 int reiserfs_commit_page(struct inode *inode, struct page *page,
 			 unsigned from, unsigned to);
-int reiserfs_flush_old_commits(struct super_block *);
+void reiserfs_flush_old_commits(struct super_block *);
 int reiserfs_commit_for_inode(struct inode *);
 int reiserfs_inode_needs_commit(struct inode *);
 void reiserfs_update_inode_transaction(struct inode *);
-- 
1.7.7.6

