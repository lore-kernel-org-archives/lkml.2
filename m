Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0IPRql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:46:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab0IPRqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/12] BKL: Remove BKL from isofs
Date: Thu, 16 Sep 2010 19:46:16 +0200
Message-Id: <1284659185-8942-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:W1C+x7CO4ccp7dYvwd4qi4OLwEDF/JyLV3FiEmaiUm/
 jfbPuGDNpmYLvxKnZcdUpoMwqTIdU4VV4/s1fGN99lxP4T9G4B
 zm5zmRjKJLGcfz+BECoUJKTOW63asFygqAeaMMipW878Uq9LeX
 Pt4KaR2D/Hses2C8LGvIy6OTmfDctyZ9w3FlrK4QS259+2DVQA
 VflYvQdmic4uQOIZgEKbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As in other file systems, we can replace the big kernel lock
with {un,}lock_super in isofs. This means we can now access
multiple file systems concurrently, but it also means that
we serialize readdir and lookup across sleeping operations
which previously released the big kernel lock. This should
not matter though, as these operations are in practice
serialized through the hardware access.

The isofs_get_blocks functions now does not take any lock
any more, it used to recursively get the BKL. After looking
at the code for hours, I convinced myself that it was never
needed here anyway, because it only reads constant fields
of the inode and writes to a buffer head array that is
at this time only visible to the caller.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/isofs/dir.c   |    6 +++---
 fs/isofs/inode.c |   16 ++++++----------
 fs/isofs/namei.c |    8 ++++----
 fs/isofs/rock.c  |    8 ++++----
 4 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index e0aca9a..4e6c000 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -10,7 +10,6 @@
  *
  *  isofs directory handling functions
  */
-#include <linux/smp_lock.h>
 #include <linux/gfp.h>
 #include "isofs.h"
 
@@ -255,18 +254,19 @@ static int isofs_readdir(struct file *filp,
 	char *tmpname;
 	struct iso_directory_record *tmpde;
 	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
 
 	tmpname = (char *)__get_free_page(GFP_KERNEL);
 	if (tmpname == NULL)
 		return -ENOMEM;
 
-	lock_kernel();
+	lock_super(sb);
 	tmpde = (struct iso_directory_record *) (tmpname+1024);
 
 	result = do_isofs_readdir(inode, filp, dirent, filldir, tmpname, tmpde);
 
 	free_page((unsigned long) tmpname);
-	unlock_kernel();
+	unlock_super(sb);
 	return result;
 }
 
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 05baf77..57209f1 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -17,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/nls.h>
 #include <linux/ctype.h>
-#include <linux/smp_lock.h>
 #include <linux/statfs.h>
 #include <linux/cdrom.h>
 #include <linux/parser.h>
@@ -44,11 +43,11 @@ static void isofs_put_super(struct super_block *sb)
 	struct isofs_sb_info *sbi = ISOFS_SB(sb);
 
 #ifdef CONFIG_JOLIET
-	lock_kernel();
+	lock_super(sb);
 
 	unload_nls(sbi->s_nls_iocharset);
 
-	unlock_kernel();
+	unlock_super(sb);
 #endif
 
 	kfree(sbi);
@@ -571,13 +570,13 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	int table, error = -EINVAL;
 	unsigned int vol_desc_start;
 
-	lock_kernel();
+	lock_super(s);
 
 	save_mount_options(s, data);
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi) {
-		unlock_kernel();
+		unlock_super(s);
 		return -ENOMEM;
 	}
 	s->s_fs_info = sbi;
@@ -904,7 +903,7 @@ root_found:
 
 	kfree(opt.iocharset);
 
-	unlock_kernel();
+	unlock_super(s);
 	return 0;
 
 	/*
@@ -942,9 +941,9 @@ out_freebh:
 	brelse(bh);
 out_freesbi:
 	kfree(opt.iocharset);
+	unlock_super(s);
 	kfree(sbi);
 	s->s_fs_info = NULL;
-	unlock_kernel();
 	return error;
 }
 
@@ -983,8 +982,6 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 	int section, rv, error;
 	struct iso_inode_info *ei = ISOFS_I(inode);
 
-	lock_kernel();
-
 	error = -EIO;
 	rv = 0;
 	if (iblock < 0 || iblock != iblock_s) {
@@ -1060,7 +1057,6 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 
 	error = 0;
 abort:
-	unlock_kernel();
 	return rv != 0 ? rv : error;
 }
 
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index ab438be..cf67973 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -6,7 +6,6 @@
  *  (C) 1991  Linus Torvalds - minix filesystem
  */
 
-#include <linux/smp_lock.h>
 #include <linux/gfp.h>
 #include "isofs.h"
 
@@ -168,6 +167,7 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
 	int found;
 	unsigned long uninitialized_var(block);
 	unsigned long uninitialized_var(offset);
+	struct super_block *sb = dir->i_sb;
 	struct inode *inode;
 	struct page *page;
 
@@ -177,7 +177,7 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
-	lock_kernel();
+	lock_super(sb);
 	found = isofs_find_entry(dir, dentry,
 				&block, &offset,
 				page_address(page),
@@ -188,10 +188,10 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
 	if (found) {
 		inode = isofs_iget(dir->i_sb, block, offset);
 		if (IS_ERR(inode)) {
-			unlock_kernel();
+			unlock_super(sb);
 			return ERR_CAST(inode);
 		}
 	}
-	unlock_kernel();
+	unlock_super(sb);
 	return d_splice_alias(inode, dentry);
 }
diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index 96a685c..0599c65 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -8,7 +8,6 @@
 
 #include <linux/slab.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 
 #include "isofs.h"
 #include "rock.h"
@@ -661,6 +660,7 @@ static int rock_ridge_symlink_readpage(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	struct iso_inode_info *ei = ISOFS_I(inode);
+	struct super_block *sb = inode->i_sb;
 	char *link = kmap(page);
 	unsigned long bufsize = ISOFS_BUFFER_SIZE(inode);
 	struct buffer_head *bh;
@@ -678,7 +678,7 @@ static int rock_ridge_symlink_readpage(struct file *file, struct page *page)
 
 	init_rock_state(&rs, inode);
 	block = ei->i_iget5_block;
-	lock_kernel();
+	lock_super(sb);
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh)
 		goto out_noread;
@@ -748,7 +748,7 @@ repeat:
 		goto fail;
 	brelse(bh);
 	*rpnt = '\0';
-	unlock_kernel();
+	unlock_super(sb);
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
@@ -765,7 +765,7 @@ out_bad_span:
 	printk("symlink spans iso9660 blocks\n");
 fail:
 	brelse(bh);
-	unlock_kernel();
+	unlock_super(sb);
 error:
 	SetPageError(page);
 	kunmap(page);
-- 
1.7.1

