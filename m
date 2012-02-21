Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab2BUTxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:53:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab2BUTxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 72/73] jffs2: Add fallthru support [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        Valerie Aurora <vaurora@redhat.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Date: Tue, 21 Feb 2012 18:06:37 +0000
Message-ID: <20120221180637.25235.22281.stgit@warthog.procyon.org.uk>
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

Add support for fallthru dentries to jffs2.

XXX - untested changes from David Woodhouse and Valerie Aurora.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---

 fs/jffs2/dir.c        |   44 ++++++++++++++++++++++++++++++++++++++++----
 include/linux/jffs2.h |    6 ++++++
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index fe7468d..e294f1d 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -36,6 +36,7 @@ static int jffs2_rename (struct inode *, struct dentry *,
 			 struct inode *, struct dentry *);
 
 static int jffs2_whiteout (struct inode *, struct dentry *, struct dentry *);
+static int jffs2_fallthru (struct inode *, struct dentry *);
 
 const struct file_operations jffs2_dir_operations =
 {
@@ -60,6 +61,7 @@ const struct inode_operations jffs2_dir_inode_operations =
 	.rename =	jffs2_rename,
 	.get_acl =	jffs2_get_acl,
 	.whiteout =     jffs2_whiteout,
+	.fallthru =     jffs2_fallthru,
 	.setattr =	jffs2_setattr,
 	.setxattr =	jffs2_setxattr,
 	.getxattr =	jffs2_getxattr,
@@ -102,10 +104,14 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
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
@@ -127,6 +133,8 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct jffs2_full_dirent *fd;
 	unsigned long offset, curofs;
+	ino_t ino;
+	char d_type;
 
 	D1(printk(KERN_DEBUG "jffs2_readdir() for dir_i #%lu\n", filp->f_path.dentry->d_inode->i_ino));
 
@@ -159,13 +167,20 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 				  fd->name, fd->ino, fd->type, curofs, offset));
 			continue;
 		}
-		if (!fd->ino) {
+		if (fd->type == JFFS2_DT_FALLTHRU) {
+			/* XXX placeholder until generic_readdir_fallthru() arrives */
+			ino = 1;
+			d_type = DT_UNKNOWN;
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
@@ -783,6 +798,26 @@ static int jffs2_mknod (struct inode *dir_i, struct dentry *dentry, umode_t mode
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
@@ -815,6 +850,7 @@ static int jffs2_whiteout (struct inode *dir, struct dentry *old_dentry,
 		return ret;
 
 	spin_lock(&new_dentry->d_lock);
+	new_dentry->d_flags &= ~DCACHE_FALLTHRU;
 	new_dentry->d_flags |= DCACHE_WHITEOUT;
 	spin_unlock(&new_dentry->d_lock);
 	d_add(new_dentry, NULL);
diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
index 6404e01..1749127 100644
--- a/include/linux/jffs2.h
+++ b/include/linux/jffs2.h
@@ -115,6 +115,12 @@ struct jffs2_unknown_node
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

