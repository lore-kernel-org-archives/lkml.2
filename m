Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370Ab2FDLrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:47:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:62343 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab2FDLrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174458405"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Benny Halevy <bhalevy@tonian.com>, osd-dev@open-osd.org
Subject: [PATCH] exofs: stop using s_dirt
Date: Mon,  4 Jun 2012 14:48:27 +0300
Message-Id: <1338810507-26539-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Exofs has the '->write_super()' handler and makes some use of the '->s_dirt'
superblock flag, but it really needs neither of them because it never sets
's_dirt' to one which means the VFS never calls its '->write_super()' handler.
Thus, remove both.

Note, I am trying to remove both 's_dirt' and 'write_super()' from VFS
altogether once all users are gone.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/exofs/super.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 735ca06..6e1c515 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -400,8 +400,6 @@ static int exofs_sync_fs(struct super_block *sb, int wait)
 	ret = ore_write(ios);
 	if (unlikely(ret))
 		EXOFS_ERR("%s: ore_write failed.\n", __func__);
-	else
-		sb->s_dirt = 0;
 
 
 	unlock_super(sb);
@@ -412,14 +410,6 @@ out:
 	return ret;
 }
 
-static void exofs_write_super(struct super_block *sb)
-{
-	if (!(sb->s_flags & MS_RDONLY))
-		exofs_sync_fs(sb, 1);
-	else
-		sb->s_dirt = 0;
-}
-
 static void _exofs_print_device(const char *msg, const char *dev_path,
 				struct osd_dev *od, u64 pid)
 {
@@ -942,7 +932,6 @@ static const struct super_operations exofs_sops = {
 	.write_inode    = exofs_write_inode,
 	.evict_inode    = exofs_evict_inode,
 	.put_super      = exofs_put_super,
-	.write_super    = exofs_write_super,
 	.sync_fs	= exofs_sync_fs,
 	.statfs         = exofs_statfs,
 };
-- 
1.7.7.6

