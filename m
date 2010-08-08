Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0HHPzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:55:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab0HHPzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:55:21 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 24/39] fallthru: jffs2 fallthru support
Date: Sun,  8 Aug 2010 11:52:41 -0400
Message-Id: <1281282776-5447-25-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

Add support for fallthru dentries to jffs2.

XXX - untested changes including generic_readdir_fallthru()

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/jffs2/dir.c        |   49 +++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/jffs2.h |    6 ++++++
 2 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 4798586..453e695 100644
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
@@ -131,6 +137,8 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct jffs2_full_dirent *fd;
 	unsigned long offset, curofs;
+	ino_t ino;
+	char d_type;
 
 	D1(printk(KERN_DEBUG "jffs2_readdir() for dir_i #%lu\n", filp->f_path.dentry->d_inode->i_ino));
 
@@ -164,13 +172,25 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 				  fd->name, fd->ino, fd->type, curofs, offset));
 			continue;
 		}
-		if (!fd->ino) {
+		if (fd->type == JFFS2_DT_FALLTHRU) {
+			int err;
+			err = generic_readdir_fallthru(filp->f_path.dentry, fd->name, strlen(fd->name),
+						       &ino, &d_type);
+			if (err) {
+				D2(printk(KERN_DEBUG "Skipping fallthru dirent \"%s\"\n", fd->name));
+				offset++;
+				continue;
+			}
+		} else if (!fd->ino && (fd->type != DT_WHT)) {
 			D2(printk(KERN_DEBUG "Skipping deletion dirent \"%s\"\n", fd->name));
 			offset++;
 			continue;
+		} else {
+			ino = fd->ino;
+			d_type = fd->type;
 		}
 		D2(printk(KERN_DEBUG "Dirent %ld: \"%s\", ino #%u, type %d\n", offset, fd->name, fd->ino, fd->type));
-		if (filldir(dirent, fd->name, strlen(fd->name), offset, fd->ino, fd->type) < 0)
+		if (filldir(dirent, fd->name, strlen(fd->name), offset, ino, d_type) < 0)
 			break;
 		offset++;
 	}
@@ -798,6 +818,26 @@ static int jffs2_mknod (struct inode *dir_i, struct dentry *dentry, int mode, de
 	return ret;
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
@@ -830,6 +870,7 @@ static int jffs2_whiteout (struct inode *dir, struct dentry *old_dentry,
 		return ret;
 
 	spin_lock(&new_dentry->d_lock);
+	new_dentry->d_flags &= ~DCACHE_FALLTHRU;
 	new_dentry->d_flags |= DCACHE_WHITEOUT;
 	spin_unlock(&new_dentry->d_lock);
 	d_add(new_dentry, NULL);
diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
index cc6347f..f3cedf6 100644
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

