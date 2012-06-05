Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031Ab2FEL1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:27:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:50403 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab2FEL1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:27:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151777591"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] affs: stop using lock_super
Date: Tue,  5 Jun 2012 14:28:13 +0300
Message-Id: <1338895695-10362-6-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
References: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The VFS's 'lock_super()' and 'unlock_super()' calls are deprecated and unwanted
and just wait for a brave knight who'd kill them. This patch makes AFFS stop
using them and introduces own AFFS superblock mutex which we use for
serializeing the root block changes.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/affs/affs.h  |    1 +
 fs/affs/super.c |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 45a0ce4..b8af745 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -108,6 +108,7 @@ struct affs_sb_info {
 	char *s_prefix;			/* Prefix for volumes and assigns. */
 	char s_volume[32];		/* Volume prefix for absolute symlinks. */
 	spinlock_t symlink_lock;	/* protects the previous two */
+	struct mutex s_lock;		/* protects the SB's buffer-head */
 };
 
 #define SF_INTL		0x0001		/* International filesystem. */
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 8293cb9..8674915 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -31,14 +31,14 @@ affs_commit_super(struct super_block *sb, int wait)
 	struct buffer_head *bh = sbi->s_root_bh;
 	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	tail->bm_flag = cpu_to_be32(2);
 	secs_to_datestamp(get_seconds(), &tail->disk_change);
 	affs_fix_checksum(sb, bh);
 	mark_buffer_dirty(bh);
 	if (wait)
 		sync_dirty_buffer(bh);
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 }
 
 static void
@@ -299,6 +299,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 		return -ENOMEM;
 
 	sb->s_fs_info = sbi;
+	mutex_init(&sbi->s_lock);
 	mutex_init(&sbi->s_bmlock);
 	spin_lock_init(&sbi->symlink_lock);
 
-- 
1.7.7.6

