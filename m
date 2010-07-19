Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966505Ab0GSTMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:12:52 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59608 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966450Ab0GSTMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:12:46 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V17 04/12] vfs: Allow handle based open on symlinks
Date: Tue, 20 Jul 2010 00:41:59 +0530
Message-Id: <1279566727-16598-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.rc3.43.g24e7a
In-Reply-To: <1279566727-16598-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1279566727-16598-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch update may_open to allow handle based open on symlinks.
The file handle based API use file descritor returned from open_by_handle_at
to do different file system operations. To find the link target name we
need to get a file descriptor on symlinks.

We should be able to read the link target using file handle. The exact
usecase is with respect to implementing READLINK operation on a
userspace NFS server. The request contain the file handle and the
response include target name.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c                  |   24 ++++++++++++++++++++++--
 include/asm-generic/fcntl.h |    1 +
 include/linux/fs.h          |    1 +
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4789839..6f4f9f6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1457,7 +1457,20 @@ int may_open(struct path *path, int acc_mode, int flag)
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFLNK:
-		return -ELOOP;
+		/*
+		 * Allow only if acc_mode contain
+		 * open link request.
+		 */
+		if (!(acc_mode & MAY_OPEN_LINK))
+			return -ELOOP;
+		/*
+		 * Allow open on symlink only with
+		 * open flag O_NOACCESS. We don't
+		 * allow read/write on symlinks
+		 */
+		if (flag != O_NOACCESS)
+			return -ELOOP;
+		break;
 	case S_IFDIR:
 		if (acc_mode & MAY_WRITE)
 			return -EISDIR;
@@ -2046,8 +2059,15 @@ long do_handle_open(int mountdirfd,
 	 */
 	if (open_flag & __O_SYNC)
 		open_flag |= O_DSYNC;
+	/*
+	 * Handle based API allow open on a symlink
+	 */
+	if (S_ISLNK(path->dentry->d_inode->i_mode))
+		acc_mode = MAY_OPEN_LINK;
+	else
+		acc_mode = MAY_OPEN;
 
-	acc_mode = MAY_OPEN | ACC_MODE(open_flag);
+	acc_mode |= ACC_MODE(open_flag);
 
 	/* O_TRUNC implies we need access checks for write permissions */
 	if (open_flag & O_TRUNC)
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index fcd268c..76f172a 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -7,6 +7,7 @@
 #define O_RDONLY	00000000
 #define O_WRONLY	00000001
 #define O_RDWR		00000002
+#define O_NOACCESS	00000003	/* No read/write access */
 #ifndef O_CREAT
 #define O_CREAT		00000100	/* not fcntl */
 #endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 79898ac..b791159 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -53,6 +53,7 @@ struct inodes_stat_t {
 #define MAY_APPEND 8
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
+#define MAY_OPEN_LINK 64
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
1.7.2.rc3.43.g24e7a

