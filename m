Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807Ab2GLN0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:26:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:27661 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933778Ab2GLN0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:26:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="170963782"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Evgeniy Dushistov <dushistov@mail.ru>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] fs/ufs: re-arrange the code a bit
Date: Thu, 12 Jul 2012 16:28:07 +0300
Message-Id: <1342099688-14894-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
References: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch does not do any functional changes. It only moves 3 functions
in fs/ufs/super.c a little bit up in order to prepare for further changes
where I'll need this new arrangement to avoid forward declarations.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ufs/super.c |  117 ++++++++++++++++++++++++++++----------------------------
 1 files changed, 58 insertions(+), 59 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index ae91e0a..ad56c6d 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -691,6 +691,64 @@ static void ufs_put_super_internal(struct super_block *sb)
 	UFSD("EXIT\n");
 }
 
+static int ufs_sync_fs(struct super_block *sb, int wait)
+{
+	struct ufs_sb_private_info * uspi;
+	struct ufs_super_block_first * usb1;
+	struct ufs_super_block_third * usb3;
+	unsigned flags;
+
+	lock_ufs(sb);
+	lock_super(sb);
+
+	UFSD("ENTER\n");
+
+	flags = UFS_SB(sb)->s_flags;
+	uspi = UFS_SB(sb)->s_uspi;
+	usb1 = ubh_get_usb_first(uspi);
+	usb3 = ubh_get_usb_third(uspi);
+
+	usb1->fs_time = cpu_to_fs32(sb, get_seconds());
+	if ((flags & UFS_ST_MASK) == UFS_ST_SUN  ||
+	    (flags & UFS_ST_MASK) == UFS_ST_SUNOS ||
+	    (flags & UFS_ST_MASK) == UFS_ST_SUNx86)
+		ufs_set_fs_state(sb, usb1, usb3,
+				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
+	ufs_put_cstotal(sb);
+	sb->s_dirt = 0;
+
+	UFSD("EXIT\n");
+	unlock_super(sb);
+	unlock_ufs(sb);
+
+	return 0;
+}
+
+static void ufs_write_super(struct super_block *sb)
+{
+	if (!(sb->s_flags & MS_RDONLY))
+		ufs_sync_fs(sb, 1);
+	else
+		sb->s_dirt = 0;
+}
+
+static void ufs_put_super(struct super_block *sb)
+{
+	struct ufs_sb_info * sbi = UFS_SB(sb);
+
+	UFSD("ENTER\n");
+
+	if (!(sb->s_flags & MS_RDONLY))
+		ufs_put_super_internal(sb);
+
+	ubh_brelse_uspi (sbi->s_uspi);
+	kfree (sbi->s_uspi);
+	kfree (sbi);
+	sb->s_fs_info = NULL;
+	UFSD("EXIT\n");
+	return;
+}
+
 static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct ufs_sb_info * sbi;
@@ -1191,65 +1249,6 @@ failed_nomem:
 	return -ENOMEM;
 }
 
-static int ufs_sync_fs(struct super_block *sb, int wait)
-{
-	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
-	struct ufs_super_block_third * usb3;
-	unsigned flags;
-
-	lock_ufs(sb);
-	lock_super(sb);
-
-	UFSD("ENTER\n");
-
-	flags = UFS_SB(sb)->s_flags;
-	uspi = UFS_SB(sb)->s_uspi;
-	usb1 = ubh_get_usb_first(uspi);
-	usb3 = ubh_get_usb_third(uspi);
-
-	usb1->fs_time = cpu_to_fs32(sb, get_seconds());
-	if ((flags & UFS_ST_MASK) == UFS_ST_SUN  ||
-	    (flags & UFS_ST_MASK) == UFS_ST_SUNOS ||
-	    (flags & UFS_ST_MASK) == UFS_ST_SUNx86)
-		ufs_set_fs_state(sb, usb1, usb3,
-				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
-	ufs_put_cstotal(sb);
-	sb->s_dirt = 0;
-
-	UFSD("EXIT\n");
-	unlock_super(sb);
-	unlock_ufs(sb);
-
-	return 0;
-}
-
-static void ufs_write_super(struct super_block *sb)
-{
-	if (!(sb->s_flags & MS_RDONLY))
-		ufs_sync_fs(sb, 1);
-	else
-		sb->s_dirt = 0;
-}
-
-static void ufs_put_super(struct super_block *sb)
-{
-	struct ufs_sb_info * sbi = UFS_SB(sb);
-		
-	UFSD("ENTER\n");
-
-	if (!(sb->s_flags & MS_RDONLY))
-		ufs_put_super_internal(sb);
-	
-	ubh_brelse_uspi (sbi->s_uspi);
-	kfree (sbi->s_uspi);
-	kfree (sbi);
-	sb->s_fs_info = NULL;
-	UFSD("EXIT\n");
-	return;
-}
-
-
 static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 {
 	struct ufs_sb_private_info * uspi;
-- 
1.7.7.6

