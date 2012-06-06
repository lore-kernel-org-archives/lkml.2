Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab2FFPzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:55:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:47640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248Ab2FFPzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:55:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161755263"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/7] affs: stop setting bm_flags
Date: Wed,  6 Jun 2012 18:56:51 +0300
Message-Id: <1338998217-5010-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
References: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

AFFS stores values '1' and '2' in 'bm_flags', and I fail to see any logic when
it prefers one or another. AFFS writes '1' only from '->put_super()', while
'->sync_fs()' and '->write_super()' store value '2'.  So on the first glance,
it looks like we want to have '1' if we unmount.  However, this does not really
happen in these cases:
  1. superblock is written via 'write_super()' then we unmount;
  2. we re-mount R/O, then unmount.
which are quite typical.

I could not find good documentation describing this field, except of one random
piece of documentation in the internet which says that -1 means that the root
block is valid, which is not consistent with what we have in the Linux AFFS
driver.

Jan Kara commented on this: "I have some vague recollection that on Amiga
boolean was usually encoded as: 0 == false, ~0 == -1 == true. But it has been
ages..."

Thus, my conclusion is that value of '1' is as good as value of '2' and we can
just always use '2'. An Jan Kara suggested to go further: "generally bm_flags
handling looks strange. If they are 0, we mount fs read only and thus cannot
change them.  If they are != 0, we write 2 there. So IMHO if you just removed
bm_flags setting, nothing will really happen."

So this patch removes the bm_flags setting completely. This makes the "clean"
argument of the 'affs_commit_super()' function unneeded, so it is also removed.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/affs/super.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 0782653..1d42e46 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -25,13 +25,12 @@ static int affs_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int affs_remount (struct super_block *sb, int *flags, char *data);
 
 static void
-affs_commit_super(struct super_block *sb, int wait, int clean)
+affs_commit_super(struct super_block *sb, int wait)
 {
 	struct affs_sb_info *sbi = AFFS_SB(sb);
 	struct buffer_head *bh = sbi->s_root_bh;
 	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
 
-	tail->bm_flag = cpu_to_be32(clean);
 	secs_to_datestamp(get_seconds(), &tail->disk_change);
 	affs_fix_checksum(sb, bh);
 	mark_buffer_dirty(bh);
@@ -46,7 +45,7 @@ affs_put_super(struct super_block *sb)
 	pr_debug("AFFS: put_super()\n");
 
 	if (!(sb->s_flags & MS_RDONLY) && sb->s_dirt)
-		affs_commit_super(sb, 1, 1);
+		affs_commit_super(sb, 1);
 
 	kfree(sbi->s_prefix);
 	affs_free_bitmap(sb);
@@ -60,7 +59,7 @@ affs_write_super(struct super_block *sb)
 {
 	lock_super(sb);
 	if (!(sb->s_flags & MS_RDONLY))
-		affs_commit_super(sb, 1, 2);
+		affs_commit_super(sb, 1);
 	sb->s_dirt = 0;
 	unlock_super(sb);
 
@@ -71,7 +70,7 @@ static int
 affs_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
-	affs_commit_super(sb, wait, 2);
+	affs_commit_super(sb, wait);
 	sb->s_dirt = 0;
 	unlock_super(sb);
 	return 0;
-- 
1.7.7.6

