Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934846Ab0EENQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:16:45 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:65023 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934809Ab0EENQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=k1ofyS3NTp8zM4bhhdZWI9mzJQCaUWVc/VgsMKP+svY3IiDUfLXhVADnAuUKjzXBa3
         WdUyjcKSKS7SLh1F+gSBtba8Fudzxm414aZoxNSRFt7CtMzhD4lEqrcnNZoEGtWb168A
         IfNYCtG5zEjnCTwbTy5kvh/+F63dqkRKE0TKs=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>
Subject: [PATCH 4/6] ncpfs: BKL ioctl pushdown
Date: Wed,  5 May 2010 15:15:37 +0200
Message-Id: <1273065339-21669-5-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ncp_ioctl to an unlocked_ioctl and push down the bkl into it.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 fs/ncpfs/dir.c         |    2 +-
 fs/ncpfs/file.c        |    2 +-
 fs/ncpfs/ioctl.c       |   27 ++++++++++++++++-----------
 include/linux/ncp_fs.h |    2 +-
 4 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 7edfcd4..92dde6f 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -51,7 +51,7 @@ const struct file_operations ncp_dir_operations =
 {
 	.read		= generic_read_dir,
 	.readdir	= ncp_readdir,
-	.ioctl		= ncp_ioctl,
+	.unlocked_ioctl	= ncp_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ncp_compat_ioctl,
 #endif
diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index 1daabb9..b938708 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -295,7 +295,7 @@ const struct file_operations ncp_file_operations =
 	.llseek 	= ncp_remote_llseek,
 	.read		= ncp_file_read,
 	.write		= ncp_file_write,
-	.ioctl		= ncp_ioctl,
+	.unlocked_ioctl	= ncp_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ncp_compat_ioctl,
 #endif
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 60a5e28..023c03d 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -20,6 +20,7 @@
 #include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 
 #include <linux/ncp_fs.h>
 
@@ -261,9 +262,9 @@ ncp_get_charsets(struct ncp_server* server, struct ncp_nls_ioctl __user *arg)
 }
 #endif /* CONFIG_NCPFS_NLS */
 
-static int __ncp_ioctl(struct inode *inode, struct file *filp,
-	      unsigned int cmd, unsigned long arg)
+static long __ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	struct ncp_server *server = NCP_SERVER(inode);
 	int result;
 	struct ncp_ioctl_request request;
@@ -841,11 +842,11 @@ static int ncp_ioctl_need_write(unsigned int cmd)
 	}
 }
 
-int ncp_ioctl(struct inode *inode, struct file *filp,
-	      unsigned int cmd, unsigned long arg)
+long ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	int ret;
+	long ret;
 
+	lock_kernel();
 	if (ncp_ioctl_need_write(cmd)) {
 		/*
 		 * inside the ioctl(), any failures which
@@ -853,24 +854,28 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 		 * -EACCESS, so it seems consistent to keep
 		 *  that here.
 		 */
-		if (mnt_want_write(filp->f_path.mnt))
-			return -EACCES;
+		if (mnt_want_write(filp->f_path.mnt)) {
+			ret = -EACCES;
+			goto out;
+		}
 	}
-	ret = __ncp_ioctl(inode, filp, cmd, arg);
+	ret = __ncp_ioctl(filp, cmd, arg);
 	if (ncp_ioctl_need_write(cmd))
 		mnt_drop_write(filp->f_path.mnt);
+
+out:
+	unlock_kernel();
 	return ret;
 }
 
 #ifdef CONFIG_COMPAT
 long ncp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
+	long ret;
 
 	lock_kernel();
 	arg = (unsigned long) compat_ptr(arg);
-	ret = ncp_ioctl(inode, file, cmd, arg);
+	ret = ncp_ioctl(file, cmd, arg);
 	unlock_kernel();
 	return ret;
 }
diff --git a/include/linux/ncp_fs.h b/include/linux/ncp_fs.h
index 30b06c8..4522aed 100644
--- a/include/linux/ncp_fs.h
+++ b/include/linux/ncp_fs.h
@@ -210,7 +210,7 @@ int ncp_date_dos2unix(__le16 time, __le16 date);
 void ncp_date_unix2dos(int unix_date, __le16 * time, __le16 * date);
 
 /* linux/fs/ncpfs/ioctl.c */
-int ncp_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+long ncp_ioctl(struct file *, unsigned int, unsigned long);
 long ncp_compat_ioctl(struct file *, unsigned int, unsigned long);
 
 /* linux/fs/ncpfs/sock.c */
-- 
1.6.6.1

