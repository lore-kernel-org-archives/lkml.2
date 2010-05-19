Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0ESRZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:25:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33252 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab0ESRYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=T0z/Q7ctETYte3tB5TkuUMQg53qigCGyN2lM7nYGjRbHtaBvZuuV3JO69cCisCn+tV
         hXeSv60cWtOqbQtk8bfGhnY40A0IbXq8KRCcApUpwEerlHz6QXZ8mpccyPXEAtznu7Kr
         e/EHaBDKPMKKpyAQBCYEdxuFAaZsXMIGM4MTY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Autofs <autofs@linux.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/8] autofs: Pushdown the bkl from ioctl
Date: Wed, 19 May 2010 19:24:09 +0200
Message-Id: <1274289855-10001-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pushdown the bkl to autofs_root_ioctl.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Autofs <autofs@linux.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 fs/autofs/root.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 8713c7c..dc16b3c 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -25,12 +25,12 @@ static int autofs_root_symlink(struct inode *,struct dentry *,const char *);
 static int autofs_root_unlink(struct inode *,struct dentry *);
 static int autofs_root_rmdir(struct inode *,struct dentry *);
 static int autofs_root_mkdir(struct inode *,struct dentry *,int);
-static int autofs_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
+static long autofs_root_ioctl(struct file *, unsigned int, unsigned long);
 
 const struct file_operations autofs_root_operations = {
 	.read		= generic_read_dir,
 	.readdir	= autofs_root_readdir,
-	.ioctl		= autofs_root_ioctl,
+	.unlocked_ioctl	= autofs_root_ioctl,
 };
 
 const struct inode_operations autofs_root_inode_operations = {
@@ -545,7 +545,7 @@ static inline int autofs_expire_run(struct super_block *sb,
  * ioctl()'s on the root directory is the chief method for the daemon to
  * generate kernel reactions
  */
-static int autofs_root_ioctl(struct inode *inode, struct file *filp,
+static int autofs_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 			     unsigned int cmd, unsigned long arg)
 {
 	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
@@ -579,3 +579,16 @@ static int autofs_root_ioctl(struct inode *inode, struct file *filp,
 		return -ENOSYS;
 	}
 }
+
+static long autofs_root_ioctl(struct file *filp,
+			     unsigned int cmd, unsigned long arg)
+{
+	long ret;
+	struct inode *inode = filp->f_dentry->d_inode;
+
+	lock_kernel();
+	ret = autofs_root_ioctl_unlocked(inode, filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
-- 
1.6.2.3

