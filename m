Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935097Ab0HFWgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:36:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0HFWgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:36:25 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        Valerie Aurora <vaurora@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 12/38] whiteout: jffs2 whiteout support
Date: Fri,  6 Aug 2010 15:34:58 -0700
Message-Id: <1281134124-17041-13-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

Add support for whiteout dentries to jffs2.

XXX - David Woodhouse suggests several changes and provides an
untested patch.  See:

http://patchwork.ozlabs.org/patch/50466/

XXX - Backward compatibility?  Creating a whiteout on a JFFS2 file
system can only happen if it is deliberately mounted "-o union" so
there is some way to prevent creation of whiteouts on a file system
you want to later mount with an earlier (no support for whiteout) file
system.  However, ext2/3 has much more robust methods (explicit fs
feature flag) to prevent such an occurance.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 fs/jffs2/dir.c        |   72 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/jffs2/fs.c         |    4 +++
 fs/jffs2/super.c      |    2 +-
 include/linux/jffs2.h |    2 +
 4 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 166062a..4798586 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -34,6 +34,8 @@ static int jffs2_mknod (struct inode *,struct dentry *,int,dev_t);
 static int jffs2_rename (struct inode *, struct dentry *,
 			 struct inode *, struct dentry *);
 
+static int jffs2_whiteout (struct inode *, struct dentry *, struct dentry *);
+
 const struct file_operations jffs2_dir_operations =
 {
 	.read =		generic_read_dir,
@@ -56,6 +58,7 @@ const struct inode_operations jffs2_dir_inode_operations =
 	.mknod =	jffs2_mknod,
 	.rename =	jffs2_rename,
 	.check_acl =	jffs2_check_acl,
+	.whiteout =     jffs2_whiteout,
 	.setattr =	jffs2_setattr,
 	.setxattr =	jffs2_setxattr,
 	.getxattr =	jffs2_getxattr,
@@ -98,8 +101,14 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
 			fd = fd_list;
 		}
 	}
-	if (fd)
-		ino = fd->ino;
+	if (fd) {
+		spin_lock(&target->d_lock);
+		if (fd->type == DT_WHT)
+			target->d_flags |= DCACHE_WHITEOUT;
+		else
+			ino = fd->ino;
+		spin_unlock(&target->d_lock);
+	}
 	mutex_unlock(&dir_f->sem);
 	if (ino) {
 		inode = jffs2_iget(dir_i->i_sb, ino);
@@ -502,6 +511,11 @@ static int jffs2_mkdir (struct inode *dir_i, struct dentry *dentry, int mode)
 		return PTR_ERR(inode);
 	}
 
+	if (dentry->d_flags & DCACHE_WHITEOUT) {
+		inode->i_flags |= S_OPAQUE;
+		ri->flags = cpu_to_je16(JFFS2_INO_FLAG_OPAQUE);
+	}
+
 	inode->i_op = &jffs2_dir_inode_operations;
 	inode->i_fop = &jffs2_dir_operations;
 
@@ -784,6 +798,60 @@ static int jffs2_mknod (struct inode *dir_i, struct dentry *dentry, int mode, de
 	return ret;
 }
 
+static int jffs2_whiteout (struct inode *dir, struct dentry *old_dentry,
+			   struct dentry *new_dentry)
+{
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(dir->i_sb);
+	struct jffs2_inode_info *victim_f = NULL;
+	uint32_t now;
+	int ret;
+
+	/* If it's a directory, then check whether it is really empty */
+	if (new_dentry->d_inode) {
+		victim_f = JFFS2_INODE_INFO(old_dentry->d_inode);
+		if (S_ISDIR(old_dentry->d_inode->i_mode)) {
+			struct jffs2_full_dirent *fd;
+
+			mutex_lock(&victim_f->sem);
+			for (fd = victim_f->dents; fd; fd = fd->next) {
+				if (fd->ino) {
+					mutex_unlock(&victim_f->sem);
+					return -ENOTEMPTY;
+				}
+			}
+			mutex_unlock(&victim_f->sem);
+		}
+	}
+
+	now = get_seconds();
+	ret = jffs2_do_link(c, JFFS2_INODE_INFO(dir), 0, DT_WHT,
+			    new_dentry->d_name.name, new_dentry->d_name.len, now);
+	if (ret)
+		return ret;
+
+	spin_lock(&new_dentry->d_lock);
+	new_dentry->d_flags |= DCACHE_WHITEOUT;
+	spin_unlock(&new_dentry->d_lock);
+	d_add(new_dentry, NULL);
+
+	if (victim_f) {
+		/* There was a victim. Kill it off nicely */
+		drop_nlink(old_dentry->d_inode);
+		/* Don't oops if the victim was a dirent pointing to an
+		   inode which didn't exist. */
+		if (victim_f->inocache) {
+			mutex_lock(&victim_f->sem);
+			if (S_ISDIR(old_dentry->d_inode->i_mode))
+				victim_f->inocache->pino_nlink = 0;
+			else
+				victim_f->inocache->pino_nlink--;
+			mutex_unlock(&victim_f->sem);
+		}
+	}
+
+	return 0;
+}
+
 static int jffs2_rename (struct inode *old_dir_i, struct dentry *old_dentry,
 			 struct inode *new_dir_i, struct dentry *new_dentry)
 {
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 459d39d..cdb2667 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -301,6 +301,10 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 
 		inode->i_op = &jffs2_dir_inode_operations;
 		inode->i_fop = &jffs2_dir_operations;
+
+		if (je16_to_cpu(latest_node.flags) & JFFS2_INO_FLAG_OPAQUE)
+			inode->i_flags |= S_OPAQUE;
+
 		break;
 	}
 	case S_IFREG:
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 511e2d6..f998679 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -170,7 +170,7 @@ static int jffs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_op = &jffs2_super_operations;
 	sb->s_export_op = &jffs2_export_ops;
-	sb->s_flags = sb->s_flags | MS_NOATIME;
+	sb->s_flags = sb->s_flags | MS_NOATIME | MS_WHITEOUT;
 	sb->s_xattr = jffs2_xattr_handlers;
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
index 0874ab5..cc6347f 100644
--- a/include/linux/jffs2.h
+++ b/include/linux/jffs2.h
@@ -87,6 +87,8 @@
 #define JFFS2_INO_FLAG_USERCOMPR  2	/* User has requested a specific
 					   compression type */
 
+#define JFFS2_INO_FLAG_OPAQUE     4	/* Directory is opaque (for union mounts) */
+
 
 /* These can go once we've made sure we've caught all uses without
    byteswapping */
-- 
1.6.3.3

