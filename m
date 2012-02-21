Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2BUSG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:06:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab2BUSGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:06:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 71/73] jffs2: Add whiteout support [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        Valerie Aurora <vaurora@redhat.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Date: Tue, 21 Feb 2012 18:06:28 +0000
Message-ID: <20120221180628.25235.56734.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

Add support for whiteout dentries to jffs2.

XXX - David Woodhouse suggests several changes and provides an untested patch.
See:

http://patchwork.ozlabs.org/patch/50466/

XXX - Backward compatibility?  Creating a whiteout on a JFFS2 file system can
only happen if it is deliberately mounted "-o union" so there is some way to
prevent creation of whiteouts on a file system you want to later mount with an
earlier (no support for whiteout) file system.  However, ext2/3 has much more
robust methods (explicit fs feature flag) to prevent such an occurance.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---

 fs/jffs2/dir.c        |   72 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/jffs2/fs.c         |    4 +++
 fs/jffs2/super.c      |    2 +
 include/linux/jffs2.h |    2 +
 4 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 973ac58..fe7468d 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -35,6 +35,8 @@ static int jffs2_mknod (struct inode *,struct dentry *,umode_t,dev_t);
 static int jffs2_rename (struct inode *, struct dentry *,
 			 struct inode *, struct dentry *);
 
+static int jffs2_whiteout (struct inode *, struct dentry *, struct dentry *);
+
 const struct file_operations jffs2_dir_operations =
 {
 	.read =		generic_read_dir,
@@ -57,6 +59,7 @@ const struct inode_operations jffs2_dir_inode_operations =
 	.mknod =	jffs2_mknod,
 	.rename =	jffs2_rename,
 	.get_acl =	jffs2_get_acl,
+	.whiteout =     jffs2_whiteout,
 	.setattr =	jffs2_setattr,
 	.setxattr =	jffs2_setxattr,
 	.getxattr =	jffs2_getxattr,
@@ -97,8 +100,14 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
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
@@ -491,6 +500,11 @@ static int jffs2_mkdir (struct inode *dir_i, struct dentry *dentry, umode_t mode
 		return PTR_ERR(inode);
 	}
 
+	if (dentry->d_flags & DCACHE_WHITEOUT) {
+		inode->i_flags |= S_OPAQUE;
+		ri->flags = cpu_to_je16(JFFS2_INO_FLAG_OPAQUE);
+	}
+
 	inode->i_op = &jffs2_dir_inode_operations;
 	inode->i_fop = &jffs2_dir_operations;
 
@@ -769,6 +783,60 @@ static int jffs2_mknod (struct inode *dir_i, struct dentry *dentry, umode_t mode
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
index 2e01238..b286ce5 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -303,6 +303,10 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 
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
index f2d96b5..9fb059a 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -295,7 +295,7 @@ static int jffs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_op = &jffs2_super_operations;
 	sb->s_export_op = &jffs2_export_ops;
-	sb->s_flags = sb->s_flags | MS_NOATIME;
+	sb->s_flags = sb->s_flags | MS_NOATIME | MS_WHITEOUT;
 	sb->s_xattr = jffs2_xattr_handlers;
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
index a18b719..6404e01 100644
--- a/include/linux/jffs2.h
+++ b/include/linux/jffs2.h
@@ -88,6 +88,8 @@
 #define JFFS2_INO_FLAG_USERCOMPR  2	/* User has requested a specific
 					   compression type */
 
+#define JFFS2_INO_FLAG_OPAQUE     4	/* Directory is opaque (for union mounts) */
+
 
 /* These can go once we've made sure we've caught all uses without
    byteswapping */

