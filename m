Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab2GCOp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:45:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab2GCOpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:45:53 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/8] vfs: Move noop_backing_dev_info check from sync into writeback
Date: Tue,  3 Jul 2012 16:45:27 +0200
Message-Id: <1341326734-29881-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1341326734-29881-1-git-send-email-jack@suse.cz>
References: <1341326734-29881-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In principle, a filesystem may want to have ->sync_fs() called during sync(1)
although it does not have a bdi (i.e. s_bdi is set to noop_backing_dev_info).
Only writeback code really needs bdi set to something reasonable. So move the
checks where they are more logical.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |    5 +++++
 fs/sync.c         |    7 -------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 41a3ccf..8f660dd 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1315,6 +1315,8 @@ void writeback_inodes_sb_nr(struct super_block *sb,
 		.reason			= reason,
 	};
 
+	if (sb->s_bdi == &noop_backing_dev_info)
+		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
@@ -1398,6 +1400,9 @@ void sync_inodes_sb(struct super_block *sb)
 		.reason		= WB_REASON_SYNC,
 	};
 
+	/* Nothing to do? */
+	if (sb->s_bdi == &noop_backing_dev_info)
+		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	bdi_queue_work(sb->s_bdi, &work);
diff --git a/fs/sync.c b/fs/sync.c
index 11e3d1c..b3d2a00 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -29,13 +29,6 @@
  */
 static int __sync_filesystem(struct super_block *sb, int wait)
 {
-	/*
-	 * This should be safe, as we require bdi backing to actually
-	 * write out data in the first place
-	 */
-	if (sb->s_bdi == &noop_backing_dev_info)
-		return 0;
-
 	if (sb->s_qcop && sb->s_qcop->quota_sync)
 		sb->s_qcop->quota_sync(sb, -1, wait);
 
-- 
1.7.1

