Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab0JMUrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:47:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46063 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab0JMUrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=ptthxIf6TUvjBTvRphkaZvXiy8CRgix2F5rrUmK/xUmmwj2bGiqS+P0XqyVcFDCW2d
         reYvSDwMQmRM54UTDlUuEtEtnqOhTLZ2izLlW2Xl2BdQzAzn7Mj/mDLyEpXDFGRAwXJ1
         YsAjNAAfUBXFnSyPhJz1ju9pPnKOvToKYbeX8=
From: Edward Shishkin <edward.shishkin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org
Subject: [patch 2/2] vfs: relax count check in rw_verify_area
Date: Wed, 13 Oct 2010 22:46:21 +0200
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.i686; KDE/4.3.3; i686; ; )
Cc: Eric Sandeen <sandeen@redhat.com>, lmcilroy@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010132246.21744.edward.shishkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase count limit in rw_verify_area().

Signed-off-by: Edward Shishkin <edward@redhat.com>
---
 fs/read_write.c    |   17 +++++++----------
 fs/splice.c        |    4 ++--
 include/linux/fs.h |    2 +-
 3 files changed, 10 insertions(+), 13 deletions(-)

--- linux-2.6.36-rc7.orig/fs/read_write.c
+++ linux-2.6.36-rc7/fs/read_write.c
@@ -223,21 +223,20 @@ bad:
 #endif
 
 /*
- * rw_verify_area doesn't like huge counts. We limit
- * them to something that fits in "int" so that others
- * won't have to do range checks all the time.
+ * We limit huge counts to something that fits in "ssize_t"
  */
-#define MAX_RW_COUNT (INT_MAX & PAGE_CACHE_MASK)
+#define MAX_RW_COUNT ((~(size_t)0) >> 1 & PAGE_CACHE_MASK)
 
-int rw_verify_area(int read_write, struct file *file, loff_t *ppos, size_t count)
+ssize_t rw_verify_area(int read_write, struct file *file, loff_t *ppos,
+		       size_t count)
 {
 	struct inode *inode;
 	loff_t pos;
 	int retval = -EINVAL;
 
 	inode = file->f_path.dentry->d_inode;
-	if (unlikely((ssize_t) count < 0))
-		return retval;
+	if (unlikely(count > MAX_RW_COUNT))
+		count = MAX_RW_COUNT;
 	pos = *ppos;
 	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
 		return retval;
@@ -251,9 +250,7 @@ int rw_verify_area(int read_write, struc
 	}
 	retval = security_file_permission(file,
 				read_write == READ ? MAY_READ : MAY_WRITE);
-	if (retval)
-		return retval;
-	return count > MAX_RW_COUNT ? MAX_RW_COUNT : count;
+	return retval ? retval : count;
 }
 
 static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
--- linux-2.6.36-rc7.orig/fs/splice.c
+++ linux-2.6.36-rc7/fs/splice.c
@@ -1097,7 +1097,7 @@ static long do_splice_from(struct pipe_i
 {
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *,
 				loff_t *, size_t, unsigned int);
-	int ret;
+	ssize_t ret;
 
 	if (unlikely(!(out->f_mode & FMODE_WRITE)))
 		return -EBADF;
@@ -1126,7 +1126,7 @@ static long do_splice_to(struct file *in
 {
 	ssize_t (*splice_read)(struct file *, loff_t *,
 			       struct pipe_inode_info *, size_t, unsigned int);
-	int ret;
+	ssize_t ret;
 
 	if (unlikely(!(in->f_mode & FMODE_READ)))
 		return -EBADF;
--- linux-2.6.36-rc7.orig/include/linux/fs.h
+++ linux-2.6.36-rc7/include/linux/fs.h
@@ -1824,7 +1824,7 @@ extern int current_umask(void);
 /* /sys/fs */
 extern struct kobject *fs_kobj;
 
-extern int rw_verify_area(int, struct file *, loff_t *, size_t);
+extern ssize_t rw_verify_area(int, struct file *, loff_t *, size_t);
 
 #define FLOCK_VERIFY_READ  1
 #define FLOCK_VERIFY_WRITE 2
