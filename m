Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab0ESRYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:24:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33252 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab0ESRYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Dr9sgaIp6dZbODtmD4fHVsX1F7jpe/4TnQyujqojIxyWw4O4/0z3eBioPDCUuXU7FG
         3takTMKtkF45tRrwgsO/3CtMTxxRzJLuFYNtPPqL01ibFbgbHN2tpdc5Tikf1Ogz9HDV
         rSGK9lABP/eawgMayE09ZYHKGacbeLsVaZKn4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ian Kent <raven@themaw.net>,
       Autofs <autofs@linux.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/8] autofs4: Pushdown the bkl from ioctl
Date: Wed, 19 May 2010 19:24:10 +0200
Message-Id: <1274289855-10001-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pushdown the bkl to autofs4_root_ioctl.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Kent <raven@themaw.net>
Cc: Autofs <autofs@linux.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 fs/autofs4/root.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index e8e5e63..db4117e 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -18,13 +18,14 @@
 #include <linux/slab.h>
 #include <linux/param.h>
 #include <linux/time.h>
+#include <linux/smp_lock.h>
 #include "autofs_i.h"
 
 static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
 static int autofs4_dir_unlink(struct inode *,struct dentry *);
 static int autofs4_dir_rmdir(struct inode *,struct dentry *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
-static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
+static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
@@ -38,7 +39,7 @@ const struct file_operations autofs4_root_operations = {
 	.read		= generic_read_dir,
 	.readdir	= dcache_readdir,
 	.llseek		= dcache_dir_lseek,
-	.ioctl		= autofs4_root_ioctl,
+	.unlocked_ioctl	= autofs4_root_ioctl,
 };
 
 const struct file_operations autofs4_dir_operations = {
@@ -902,8 +903,8 @@ int is_autofs4_dentry(struct dentry *dentry)
  * ioctl()'s on the root directory is the chief method for the daemon to
  * generate kernel reactions
  */
-static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
-			     unsigned int cmd, unsigned long arg)
+static int autofs4_root_ioctl_unlocked(struct inode *inode, struct file *filp,
+				       unsigned int cmd, unsigned long arg)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(inode->i_sb);
 	void __user *p = (void __user *)arg;
@@ -947,3 +948,16 @@ static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
 		return -ENOSYS;
 	}
 }
+
+static long autofs4_root_ioctl(struct file *filp,
+			       unsigned int cmd, unsigned long arg)
+{
+	long ret;
+	struct inode *inode = filp->f_dentry->d_inode;
+
+	lock_kernel();
+	ret = autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
-- 
1.6.2.3

