Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab0FOSl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:41:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403Ab0FOSl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:41:56 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 15/38] fallthru: jffs2 fallthru support
Date: Tue, 15 Jun 2010 11:39:45 -0700
Message-Id: <1276627208-17242-16-git-send-email-vaurora@redhat.com>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

Add support for fallthru dentries to jffs2.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/jffs2/dir.c        |   36 +++++++++++++++++++++++++++++++++---
 include/linux/jffs2.h |    6 ++++++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index c259193..98397b3 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -35,6 +35,7 @@ static int jffs2_rename (struct inode *, struct dentry *,
 			 struct inode *, struct dentry *);
 
 static int jffs2_whiteout (struct inode *, struct dentry *, struct dentry *);
+static int jffs2_fallthru (struct inode *, struct dentry *);
 
 const struct file_operations jffs2_dir_operations =
 {
@@ -59,6 +60,7 @@ const struct inode_operations jffs2_dir_inode_operations =
 	.rename =	jffs2_rename,
 	.check_acl =	jffs2_check_acl,
 	.whiteout =     jffs2_whiteout,
+	.fallthru =     jffs2_fallthru,
 	.setattr =	jffs2_setattr,
 	.setxattr =	jffs2_setxattr,
 	.getxattr =	jffs2_getxattr,
@@ -103,10 +105,14 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
 	}
 	if (fd) {
 		spin_lock(&target->d_lock);
-		if (fd->type == DT_WHT)
+		switch (fd->type) {
+		case DT_WHT:
 			target->d_flags |= DCACHE_WHITEOUT;
-		else
+		case JFFS2_DT_FALLTHRU:
+			target->d_flags |= DCACHE_FALLTHRU;
+		default:
 			ino = fd->ino;
+		}
 		spin_unlock(&target->d_lock);
 	}
 	mutex_unlock(&dir_f->sem);
@@ -164,7 +170,10 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 				  fd->name, fd->ino, fd->type, curofs, offset));
 			continue;
 		}
-		if (!fd->ino) {
+		if (fd->type == JFFS2_DT_FALLTHRU)
+			/* XXX Should really do a lookup for the real inode number here */
+			fd->ino = 100;
+		else if (!fd->ino && (fd->type != DT_WHT)) {
 			D2(printk(KERN_DEBUG "Skipping deletion dirent \"%s\"\n", fd->name));
 			offset++;
 			continue;
@@ -793,6 +802,26 @@ static int jffs2_mknod (struct inode *dir_i, struct dentry *dentry, int mode, de
 	return 0;
 }
 
+static int jffs2_fallthru (struct inode *dir, struct dentry *dentry)
+{
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(dir->i_sb);
+	uint32_t now;
+	int ret;
+
+	now = get_seconds();
+	ret = jffs2_do_link(c, JFFS2_INODE_INFO(dir), 0, DT_UNKNOWN,
+			    dentry->d_name.name, dentry->d_name.len, now);
+	if (ret)
+		return ret;
+
+	d_instantiate(dentry, NULL);
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_FALLTHRU;
+	spin_unlock(&dentry->d_lock);
+
+	return 0;
+}
+
 static int jffs2_whiteout (struct inode *dir, struct dentry *old_dentry,
 			   struct dentry *new_dentry)
 {
@@ -825,6 +854,7 @@ static int jffs2_whiteout (struct inode *dir, struct dentry *old_dentry,
 		return ret;
 
 	spin_lock(&new_dentry->d_lock);
+	new_dentry->d_flags &= ~DCACHE_FALLTHRU;
 	new_dentry->d_flags |= DCACHE_WHITEOUT;
 	spin_unlock(&new_dentry->d_lock);
 	d_add(new_dentry, NULL);
diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
index 65533bb..dbe8c93 100644
--- a/include/linux/jffs2.h
+++ b/include/linux/jffs2.h
@@ -114,6 +114,12 @@ struct jffs2_unknown_node
 	jint32_t hdr_crc;
 };
 
+/*
+ * Non-standard directory entry type(s), for on-disk use
+ */
+
+#define                JFFS2_DT_FALLTHRU       (DT_WHT + 1)
+
 struct jffs2_raw_dirent
 {
 	jint16_t magic;
-- 
1.6.3.3

