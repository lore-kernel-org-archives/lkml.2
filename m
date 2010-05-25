Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0EYNvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:51:31 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37660 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab0EYNv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:51:26 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCHv4 15/17] UFS: do not manipulate s_dirt directly
Date: Tue, 25 May 2010 16:49:10 +0300
Message-Id: <1274795352-3551-16-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 May 2010 13:50:54.0953 (UTC) FILETIME=[4BC81D90:01CAFC11]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
---
 fs/ufs/balloc.c |    8 ++++----
 fs/ufs/ialloc.c |    4 ++--
 fs/ufs/super.c  |   12 ++++++------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 5cfa4d8..43e5c4f 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -122,7 +122,7 @@ void ufs_free_fragments(struct inode *inode, u64 fragment, unsigned count)
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	
 	unlock_super (sb);
 	UFSD("EXIT\n");
@@ -223,7 +223,7 @@ do_more:
 		goto do_more;
 	}
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 	return;
@@ -573,7 +573,7 @@ static u64 ufs_add_fragments(struct inode *inode, u64 fragment,
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	UFSD("EXIT, fragment %llu\n", (unsigned long long)fragment);
 	
@@ -702,7 +702,7 @@ succed:
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	result += cgno * uspi->s_fpg;
 	UFSD("EXIT3, result %llu\n", (unsigned long long)result);
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index 3a959d5..765a21d 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -124,7 +124,7 @@ void ufs_free_inode (struct inode * inode)
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
 	
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 }
@@ -300,7 +300,7 @@ cg_found:
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	inode->i_ino = cg * uspi->s_ipg + bit;
 	inode_init_owner(inode, dir, mode);
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 14743d9..a0317d8 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -288,7 +288,7 @@ void ufs_error (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		sb->s_flags |= MS_RDONLY;
 	}
 	va_start (args, fmt);
@@ -321,7 +321,7 @@ void ufs_panic (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
@@ -1204,7 +1204,7 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 		ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 	ufs_put_cstotal(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 	UFSD("EXIT\n");
 	unlock_kernel();
@@ -1218,7 +1218,7 @@ static void ufs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		ufs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static void ufs_put_super(struct super_block *sb)
@@ -1227,7 +1227,7 @@ static void ufs_put_super(struct super_block *sb)
 		
 	UFSD("ENTER\n");
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		ufs_write_super(sb);
 
 	if (!(sb->s_flags & MS_RDONLY))
@@ -1297,7 +1297,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 			ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 		ubh_mark_buffer_dirty (USPI_UBH(uspi));
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 		sb->s_flags |= MS_RDONLY;
 	} else {
 	/*
-- 
1.6.6.1

