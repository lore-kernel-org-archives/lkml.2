Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2GCNmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:42:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:18887 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab2GCNmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:42:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166324237"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 3/3] fs/sysv: stop using write_super and s_dirt
Date: Tue,  3 Jul 2012 16:43:28 +0300
Message-Id: <1341323008-29414-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
References: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

It does not look like sysv FS needs 'write_super()' at all, because all it
does is a timestamp update. I cannot test this patch, because this
file-system is so old and probably has not been used by anyone for years,
so there are no tools to create it in Linux. But from the code I see that
marking the superblock as dirty is basically marking the superblock buffers as
drity and then setting the s_dirt flag. And when 'write_super()' is executed to
handle the s_dirt flag, we just update the timestamp and again mark the
superblock buffer as dirty. Seems pointless.

It looks like we can update the timestamp more opprtunistically - on unmount
or remount of sync, and nothing should change.

Thus, this patch removes 'sysv_write_super()' and 's_dirt'.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/sysv/inode.c |   10 ----------
 fs/sysv/sysv.h  |    1 -
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index f20ffe3..80e1e2b 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -43,7 +43,6 @@ static int sysv_sync_fs(struct super_block *sb, int wait)
 	 * then attach current time stamp.
 	 * But if the filesystem was marked clean, keep it clean.
 	 */
-	sb->s_dirt = 0;
 	old_time = fs32_to_cpu(sbi, *sbi->s_sb_time);
 	if (sbi->s_type == FSTYPE_SYSV4) {
 		if (*sbi->s_sb_state == cpu_to_fs32(sbi, 0x7c269d38 - old_time))
@@ -57,14 +56,6 @@ static int sysv_sync_fs(struct super_block *sb, int wait)
 	return 0;
 }
 
-static void sysv_write_super(struct super_block *sb)
-{
-	if (!(sb->s_flags & MS_RDONLY))
-		sysv_sync_fs(sb, 1);
-	else
-		sb->s_dirt = 0;
-}
-
 static int sysv_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
@@ -351,7 +342,6 @@ const struct super_operations sysv_sops = {
 	.write_inode	= sysv_write_inode,
 	.evict_inode	= sysv_evict_inode,
 	.put_super	= sysv_put_super,
-	.write_super	= sysv_write_super,
 	.sync_fs	= sysv_sync_fs,
 	.remount_fs	= sysv_remount,
 	.statfs		= sysv_statfs,
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 11b0767..0bc35fd 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -117,7 +117,6 @@ static inline void dirty_sb(struct super_block *sb)
 	mark_buffer_dirty(sbi->s_bh1);
 	if (sbi->s_bh1 != sbi->s_bh2)
 		mark_buffer_dirty(sbi->s_bh2);
-	sb->s_dirt = 1;
 }
 
 
-- 
1.7.7.6

