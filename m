Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab0LJUhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:37:20 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57882 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab0LJUhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:37:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=ZSIyuy3096soHWECbqSut+cJb2RB7RkRMb3hT/Bea/3qBC1HgZbOjzQaFNxHI+DK6G
         VN8RTTGBl9Zx3DDqsAZZhBAAFq3EZ/it56hf1e8sks46Ubp1Ngo7YcaeLrcbDcOYkXYI
         pTVgNVBAjHf2FHHjJI/WrYqZ0XEm0Bg6RDV1Q=
From: Edward Shishkin <edward.shishkin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fs: relax count limitation in rw_verify_area, TAKE 2
Date: Fri, 10 Dec 2010 21:36:18 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.i686; KDE/4.3.3; i686; ; )
Cc: esandeen@redhat.com, viro@zeniv.linux.org.uk, lmcilroy@redhat.com,
        hch@infradead.org, rring@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012102136.18572.edward.shishkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relax synthetic limitation introduced by rw_verify_area().

We limit @count to something that fits in ssize_t instead of
int, so that the kernel now permits single reads and writes of
up to 2^63 bytes on 64-bit systems (whereas it was previously
limited to 2^31), because:

1. This is more conformable to man pages, where @count
   should be of size_t (but not more than SSIZE_MAX for
   predictable results).

2. Old limitation restricts size of atomic writes that
   can be performed by a local file system: 2G can be
   not enough in the near future.

3. Some applications of our users don't work with the
   old limitation (and it is really hard to fix them).

The following subsystems were tested with this patch applied:

direct-io,
ntfs,
squashfs,
cifs,
ecryptfs,
ext[2,3,4]
hfs,
hfsplus,
reiserfs,
xfs,
jfs,
nfs,
gfs2,
btrfs,
isofs

Everything works fine. While testing the new relaxed
limitation there were found and fixed truncation bugs
in direct-io and ecryptfs. The fixups are in upstream
already.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
---
 fs/read_write.c    |   16 ++++++----------
 fs/splice.c        |    4 ++--
 include/linux/fs.h |    4 ++--
 3 files changed, 10 insertions(+), 14 deletions(-)

--- linux-2.6.37-rc4.orig/fs/read_write.c
+++ linux-2.6.37-rc4/fs/read_write.c
@@ -236,21 +236,19 @@ bad:
 }
 #endif
 
-
 /*
- * rw_verify_area doesn't like huge counts. We limit
- * them to something that fits in "int" so that others
- * won't have to do range checks all the time.
+ * We limit huge counts to something that fits in "ssize_t"
  */
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
 	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0)) {
 		retval = __negative_fpos_check(file, pos, count);
@@ -267,9 +265,7 @@ int rw_verify_area(int read_write, struc
 	}
 	retval = security_file_permission(file,
 				read_write == READ ? MAY_READ : MAY_WRITE);
-	if (retval)
-		return retval;
-	return count > MAX_RW_COUNT ? MAX_RW_COUNT : count;
+	return retval ? retval : count;
 }
 
 static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
--- linux-2.6.37-rc4.orig/fs/splice.c
+++ linux-2.6.37-rc4/fs/splice.c
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
--- linux-2.6.37-rc4.orig/include/linux/fs.h
+++ linux-2.6.37-rc4/include/linux/fs.h
@@ -1866,8 +1866,8 @@ extern int current_umask(void);
 /* /sys/fs */
 extern struct kobject *fs_kobj;
 
-#define MAX_RW_COUNT (INT_MAX & PAGE_CACHE_MASK)
-extern int rw_verify_area(int, struct file *, loff_t *, size_t);
+#define MAX_RW_COUNT ((~(size_t)0) >> 1 & PAGE_CACHE_MASK)
+extern ssize_t rw_verify_area(int, struct file *, loff_t *, size_t);
 
 #define FLOCK_VERIFY_READ  1
 #define FLOCK_VERIFY_WRITE 2
