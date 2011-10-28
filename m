Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1J1MOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:14:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33215 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab1J1MOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:14:06 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: hch@infradead.org
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH 12/13] vfs: count unlinked inodes
Date: Fri, 28 Oct 2011 14:13:31 +0200
Message-Id: <1319804012-16346-13-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
References: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new counter to the superblock that keeps track of unlinked but
not yet deleted inodes.

Do not WARN_ON if set_nlink is called with zero count, just do a
ratelimited printk.  This happens on xfs and probably other
filesystems after an unclean shutdown when the filesystem reads inodes
which already have zero i_nlink.  Reported by Christoph Hellwig.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Tested-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/inode.c         |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |   61 ++++---------------------------------
 2 files changed, 92 insertions(+), 54 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index e2d3633..55447f9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -26,6 +26,7 @@
 #include <linux/ima.h>
 #include <linux/cred.h>
 #include <linux/buffer_head.h> /* for inode_has_buffers */
+#include <linux/ratelimit.h>
 #include "internal.h"
 
 /*
@@ -241,6 +242,11 @@ void __destroy_inode(struct inode *inode)
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
 	fsnotify_inode_delete(inode);
+	if (!inode->i_nlink) {
+		WARN_ON(atomic_long_read(&inode->i_sb->s_remove_count) == 0);
+		atomic_long_dec(&inode->i_sb->s_remove_count);
+	}
+
 #ifdef CONFIG_FS_POSIX_ACL
 	if (inode->i_acl && inode->i_acl != ACL_NOT_CACHED)
 		posix_acl_release(inode->i_acl);
@@ -268,6 +274,85 @@ static void destroy_inode(struct inode *inode)
 		call_rcu(&inode->i_rcu, i_callback);
 }
 
+/**
+ * drop_nlink - directly drop an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  In cases
+ * where we are attempting to track writes to the
+ * filesystem, a decrement to zero means an imminent
+ * write when the file is truncated and actually unlinked
+ * on the filesystem.
+ */
+void drop_nlink(struct inode *inode)
+{
+	WARN_ON(inode->i_nlink == 0);
+	inode->__i_nlink--;
+	if (!inode->i_nlink)
+		atomic_long_inc(&inode->i_sb->s_remove_count);
+}
+EXPORT_SYMBOL(drop_nlink);
+
+/**
+ * clear_nlink - directly zero an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  See
+ * drop_nlink() for why we care about i_nlink hitting zero.
+ */
+void clear_nlink(struct inode *inode)
+{
+	if (inode->i_nlink) {
+		inode->__i_nlink = 0;
+		atomic_long_inc(&inode->i_sb->s_remove_count);
+	}
+}
+EXPORT_SYMBOL(clear_nlink);
+
+/**
+ * set_nlink - directly set an inode's link count
+ * @inode: inode
+ * @nlink: new nlink (should be non-zero)
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.
+ */
+void set_nlink(struct inode *inode, unsigned int nlink)
+{
+	if (!nlink) {
+		printk_ratelimited(KERN_INFO
+			"set_nlink() clearing i_nlink on %s inode %li\n",
+			inode->i_sb->s_type->name, inode->i_ino);
+		clear_nlink(inode);
+	} else {
+		/* Yes, some filesystems do change nlink from zero to one */
+		if (inode->i_nlink == 0)
+			atomic_long_dec(&inode->i_sb->s_remove_count);
+
+		inode->__i_nlink = nlink;
+	}
+}
+EXPORT_SYMBOL(set_nlink);
+
+/**
+ * inc_nlink - directly increment an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  Currently,
+ * it is only here for parity with dec_nlink().
+ */
+void inc_nlink(struct inode *inode)
+{
+	if (WARN_ON(inode->i_nlink == 0))
+		atomic_long_dec(&inode->i_sb->s_remove_count);
+
+	inode->__i_nlink++;
+}
+EXPORT_SYMBOL(inc_nlink);
+
 void address_space_init_once(struct address_space *mapping)
 {
 	memset(mapping, 0, sizeof(*mapping));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b9a4920..d7478da 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1477,6 +1477,9 @@ struct super_block {
 
 	struct shrinker s_shrink;	/* per-sb shrinker handle */
 
+	/* Number of inodes with nlink == 0 but still referenced */
+	atomic_long_t s_remove_count;
+
 	/* Being remounted read-only */
 	int s_readonly_remount;
 };
@@ -1761,31 +1764,10 @@ static inline void mark_inode_dirty_sync(struct inode *inode)
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 }
 
-/**
- * set_nlink - directly set an inode's link count
- * @inode: inode
- * @nlink: new nlink (should be non-zero)
- *
- * This is a low-level filesystem helper to replace any
- * direct filesystem manipulation of i_nlink.
- */
-static inline void set_nlink(struct inode *inode, unsigned int nlink)
-{
-	inode->__i_nlink = nlink;
-}
-
-/**
- * inc_nlink - directly increment an inode's link count
- * @inode: inode
- *
- * This is a low-level filesystem helper to replace any
- * direct filesystem manipulation of i_nlink.  Currently,
- * it is only here for parity with dec_nlink().
- */
-static inline void inc_nlink(struct inode *inode)
-{
-	inode->__i_nlink++;
-}
+extern void inc_nlink(struct inode *inode);
+extern void drop_nlink(struct inode *inode);
+extern void clear_nlink(struct inode *inode);
+extern void set_nlink(struct inode *inode, unsigned int nlink);
 
 static inline void inode_inc_link_count(struct inode *inode)
 {
@@ -1793,35 +1775,6 @@ static inline void inode_inc_link_count(struct inode *inode)
 	mark_inode_dirty(inode);
 }
 
-/**
- * drop_nlink - directly drop an inode's link count
- * @inode: inode
- *
- * This is a low-level filesystem helper to replace any
- * direct filesystem manipulation of i_nlink.  In cases
- * where we are attempting to track writes to the
- * filesystem, a decrement to zero means an imminent
- * write when the file is truncated and actually unlinked
- * on the filesystem.
- */
-static inline void drop_nlink(struct inode *inode)
-{
-	inode->__i_nlink--;
-}
-
-/**
- * clear_nlink - directly zero an inode's link count
- * @inode: inode
- *
- * This is a low-level filesystem helper to replace any
- * direct filesystem manipulation of i_nlink.  See
- * drop_nlink() for why we care about i_nlink hitting zero.
- */
-static inline void clear_nlink(struct inode *inode)
-{
-	inode->__i_nlink = 0;
-}
-
 static inline void inode_dec_link_count(struct inode *inode)
 {
 	drop_nlink(inode);
-- 
1.7.3.4

