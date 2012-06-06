Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2FFPzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:55:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:47640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836Ab2FFPzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:55:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161755301"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/7] affs: re-structure superblock locking a bit
Date: Wed,  6 Jun 2012 18:56:54 +0300
Message-Id: <1338998217-5010-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
References: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

AFFS wants to serialize the superblock (the root block in AFFS terms) updates
and uses 'lock_super()/unlock_super()' for these purposes. This patch pushes the
locking down to the 'affs_commit_super()' from the callers.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/affs/super.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index c837e43..4ceec56 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -31,11 +31,13 @@ affs_commit_super(struct super_block *sb, int wait)
 	struct buffer_head *bh = sbi->s_root_bh;
 	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
 
+	lock_super(sb);
 	secs_to_datestamp(get_seconds(), &tail->disk_change);
 	affs_fix_checksum(sb, bh);
 	mark_buffer_dirty(bh);
 	if (wait)
 		sync_dirty_buffer(bh);
+	unlock_super(sb);
 }
 
 static void
@@ -54,22 +56,17 @@ affs_put_super(struct super_block *sb)
 static void
 affs_write_super(struct super_block *sb)
 {
-	lock_super(sb);
 	if (!(sb->s_flags & MS_RDONLY))
 		affs_commit_super(sb, 1);
 	sb->s_dirt = 0;
-	unlock_super(sb);
-
 	pr_debug("AFFS: write_super() at %lu, clean=2\n", get_seconds());
 }
 
 static int
 affs_sync_fs(struct super_block *sb, int wait)
 {
-	lock_super(sb);
 	affs_commit_super(sb, wait);
 	sb->s_dirt = 0;
-	unlock_super(sb);
 	return 0;
 }
 
-- 
1.7.7.6

