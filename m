Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033Ab2JAXW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:22:28 -0400
Received: from 1wt.eu ([62.212.114.60]:35354 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab2JAXBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:24 -0400
Message-Id: <20121001225201.459511496@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Pavel Shilovsky <piastry@etersoft.ru>, Miklos Szeredi <mszeredi@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 091/180] fuse: fix stat call on 32 bit platforms
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <piastry@etersoft.ru>

commit 45c72cd73c788dd18c8113d4a404d6b4a01decf1 upstream.

Now we store attr->ino at inode->i_ino, return attr->ino at the
first time and then return inode->i_ino if the attribute timeout
isn't expired. That's wrong on 32 bit platforms because attr->ino
is 64 bit and inode->i_ino is 32 bit in this case.

Fix this by saving 64 bit ino in fuse_inode structure and returning
it every time we call getattr. Also squash attr->ino into inode->i_ino
explicitly.

Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/fuse/dir.c    |    1 +
 fs/fuse/fuse_i.h |    3 +++
 fs/fuse/inode.c  |   17 ++++++++++++++++-
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 4787ae6..b359543 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -855,6 +855,7 @@ int fuse_update_attributes(struct inode *inode, struct kstat *stat,
 		if (stat) {
 			generic_fillattr(inode, stat);
 			stat->mode = fi->orig_i_mode;
+			stat->ino = fi->orig_ino;
 		}
 	}
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e6d614d..829acee 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -76,6 +76,9 @@ struct fuse_inode {
 	    preserve the original mode */
 	mode_t orig_i_mode;
 
+	/** 64 bit inode number */
+	u64 orig_ino;
+
 	/** Version of last attribute change */
 	u64 attr_version;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1a822ce..c95186c 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -86,6 +86,7 @@ static struct inode *fuse_alloc_inode(struct super_block *sb)
 	fi->nlookup = 0;
 	fi->attr_version = 0;
 	fi->writectr = 0;
+	fi->orig_ino = 0;
 	INIT_LIST_HEAD(&fi->write_files);
 	INIT_LIST_HEAD(&fi->queued_writes);
 	INIT_LIST_HEAD(&fi->writepages);
@@ -140,6 +141,18 @@ static int fuse_remount_fs(struct super_block *sb, int *flags, char *data)
 	return 0;
 }
 
+/*
+ * ino_t is 32-bits on 32-bit arch. We have to squash the 64-bit value down
+ * so that it will fit.
+ */
+static ino_t fuse_squash_ino(u64 ino64)
+{
+	ino_t ino = (ino_t) ino64;
+	if (sizeof(ino_t) < sizeof(u64))
+		ino ^= ino64 >> (sizeof(u64) - sizeof(ino_t)) * 8;
+	return ino;
+}
+
 void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 				   u64 attr_valid)
 {
@@ -149,7 +162,7 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 	fi->attr_version = ++fc->attr_version;
 	fi->i_time = attr_valid;
 
-	inode->i_ino     = attr->ino;
+	inode->i_ino     = fuse_squash_ino(attr->ino);
 	inode->i_mode    = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	inode->i_nlink   = attr->nlink;
 	inode->i_uid     = attr->uid;
@@ -175,6 +188,8 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 	fi->orig_i_mode = inode->i_mode;
 	if (!(fc->flags & FUSE_DEFAULT_PERMISSIONS))
 		inode->i_mode &= ~S_ISVTX;
+
+	fi->orig_ino = attr->ino;
 }
 
 void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
-- 
1.7.2.1.45.g54fbc



