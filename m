Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab0ESR0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:26:19 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53492 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab0ESRYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=GV2XMEthCK1nlML9bWpMitCq0WN39Ogf0vKGN1eSKhFhMA/Jt7MtRkAaj3wsd6m9+h
         s8IYhUevTwWGh7McQna26DgY6wg+uoqC3xd3DcjPu6fU8cA2dgkLs6WQQxOVeCzIEcqm
         MgC2ykmR/4w3cA0bthBuR98jB181nhqfuGIVQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       Ecryptfs <ecryptfs-devel@lists.launchpad.net>,
       Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/8] ecryptfs: Pushdown the bkl from ioctl
Date: Wed, 19 May 2010 19:24:08 +0200
Message-Id: <1274289855-10001-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pushdown the bkl to ecryptfs_ioctl.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Cc: Ecryptfs <ecryptfs-devel@lists.launchpad.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 fs/ecryptfs/file.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index e7440a6..9352613 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -294,12 +294,12 @@ static int ecryptfs_fasync(int fd, struct file *file, int flag)
 	return rc;
 }
 
-static int ecryptfs_ioctl(struct inode *inode, struct file *file,
+static long ecryptfs_ioctl(struct file *file,
 			  unsigned int cmd, unsigned long arg);
 
 const struct file_operations ecryptfs_dir_fops = {
 	.readdir = ecryptfs_readdir,
-	.ioctl = ecryptfs_ioctl,
+	.unlocked_ioctl = ecryptfs_ioctl,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
 	.release = ecryptfs_release,
@@ -315,7 +315,7 @@ const struct file_operations ecryptfs_main_fops = {
 	.write = do_sync_write,
 	.aio_write = generic_file_aio_write,
 	.readdir = ecryptfs_readdir,
-	.ioctl = ecryptfs_ioctl,
+	.unlocked_ioctl = ecryptfs_ioctl,
 	.mmap = generic_file_mmap,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
@@ -326,8 +326,8 @@ const struct file_operations ecryptfs_main_fops = {
 };
 
 static int
-ecryptfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	       unsigned long arg)
+ecryptfs_ioctl_unlocked(struct inode *inode, struct file *file,
+			unsigned int cmd, unsigned long arg)
 {
 	int rc = 0;
 	struct file *lower_file = NULL;
@@ -341,3 +341,16 @@ ecryptfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		rc = -ENOTTY;
 	return rc;
 }
+
+static long ecryptfs_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
+{
+	long ret;
+	struct inode *inode = file->f_dentry->d_inode;
+
+	lock_kernel();
+	ret = ecryptfs_ioctl_unlocked(inode, file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
-- 
1.6.2.3

