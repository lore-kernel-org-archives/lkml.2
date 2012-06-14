Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab2FOACO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:02:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab2FOAA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:56 -0400
Message-Id: <20120614235627.435526100@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:57:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pavel Shilovsky <piastry@etersoft.ru>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 40/42] fuse: fix stat call on 32 bit platforms
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/fuse/dir.c    |    1 +
 fs/fuse/fuse_i.h |    3 +++
 fs/fuse/inode.c  |   17 ++++++++++++++++-
 3 files changed, 20 insertions(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -863,6 +863,7 @@ int fuse_update_attributes(struct inode
 		if (stat) {
 			generic_fillattr(inode, stat);
 			stat->mode = fi->orig_i_mode;
+			stat->ino = fi->orig_ino;
 		}
 	}
 
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -82,6 +82,9 @@ struct fuse_inode {
 	    preserve the original mode */
 	umode_t orig_i_mode;
 
+	/** 64 bit inode number */
+	u64 orig_ino;
+
 	/** Version of last attribute change */
 	u64 attr_version;
 
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -91,6 +91,7 @@ static struct inode *fuse_alloc_inode(st
 	fi->nlookup = 0;
 	fi->attr_version = 0;
 	fi->writectr = 0;
+	fi->orig_ino = 0;
 	INIT_LIST_HEAD(&fi->write_files);
 	INIT_LIST_HEAD(&fi->queued_writes);
 	INIT_LIST_HEAD(&fi->writepages);
@@ -139,6 +140,18 @@ static int fuse_remount_fs(struct super_
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
@@ -148,7 +161,7 @@ void fuse_change_attributes_common(struc
 	fi->attr_version = ++fc->attr_version;
 	fi->i_time = attr_valid;
 
-	inode->i_ino     = attr->ino;
+	inode->i_ino     = fuse_squash_ino(attr->ino);
 	inode->i_mode    = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	set_nlink(inode, attr->nlink);
 	inode->i_uid     = attr->uid;
@@ -174,6 +187,8 @@ void fuse_change_attributes_common(struc
 	fi->orig_i_mode = inode->i_mode;
 	if (!(fc->flags & FUSE_DEFAULT_PERMISSIONS))
 		inode->i_mode &= ~S_ISVTX;
+
+	fi->orig_ino = attr->ino;
 }
 
 void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,


