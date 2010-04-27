Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0D0Uai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:30:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60977 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab0D0Uah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:30:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@logfs.org>
Subject: [PATCH] logfs: kill BKL
Date: Tue, 27 Apr 2010 22:30:06 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <201004271738.50505.arnd@arndb.de> <20100427201247.GE5586@nowhere>
In-Reply-To: <20100427201247.GE5586@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201004272230.07545.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/UzwaGUfU0JxJ4wpsYgQouVfa5LLwXXAl7CxZ
 jJ9t16FagQ068h9tAkC5/fLDwCiTkiVDyR5hiitI+lVGzU4ylQ
 qn/wMPbtrlZ9MK2l0E5Wg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

logfs does not need the BKL, so use ->unlocked_ioctl instead
of ->ioctl in file operations.
---
On Tuesday 27 April 2010 22:12:52 Frederic Weisbecker wrote:
> 
> I've applied this series in bkl/ioctl, it passed allyesconfig in sparc.
> I will apply the others from you and John tomorrow or so (and will enjoy
> my part as well). Jörn, please queue this patch if you want to, as you prefer,
> we can host it as well if necessary.

I believe that this is the one that Jörn would prefer to go in. I hope I
got it right by editing the patch.

diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 2396a85..a801b5e 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -821,7 +821,7 @@ const struct inode_operations logfs_dir_iops = {
 };
 const struct file_operations logfs_dir_fops = {
 	.fsync		= logfs_fsync,
-	.ioctl		= logfs_ioctl,
+	.unlocked_ioctl	= logfs_ioctl,
 	.readdir	= logfs_readdir,
 	.read		= generic_read_dir,
 };
diff --git a/fs/logfs/file.c b/fs/logfs/file.c
index 370f367..1dbc342 100644
--- a/fs/logfs/file.c
+++ b/fs/logfs/file.c
@@ -171,9 +172,9 @@ static int logfs_releasepage(struct page *page, gfp_t only_xfs_uses_this)
 }
 
 
-int logfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		unsigned long arg)
+long logfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct logfs_inode *li = logfs_inode(inode);
 	unsigned int oldflags, flags;
 	int err;
@@ -243,7 +255,7 @@ const struct file_operations logfs_reg_fops = {
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.fsync		= logfs_fsync,
-	.ioctl		= logfs_ioctl,
+	.unlocked_ioctl	= logfs_ioctl,
 	.llseek		= generic_file_llseek,
 	.mmap		= generic_file_readonly_mmap,
 	.open		= generic_file_open,
diff --git a/fs/logfs/logfs.h b/fs/logfs/logfs.h
index 0a3df1a..8432c51 100644
--- a/fs/logfs/logfs.h
+++ b/fs/logfs/logfs.h
@@ -501,8 +501,8 @@ extern const struct inode_operations logfs_reg_iops;
 extern const struct file_operations logfs_reg_fops;
 extern const struct address_space_operations logfs_reg_aops;
 int logfs_readpage(struct file *file, struct page *page);
-int logfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		unsigned long arg);
+long logfs_ioctl(struct file *file, unsigned int cmd,
+		 unsigned long arg);
 int logfs_fsync(struct file *file, struct dentry *dentry, int datasync);
 
 /* gc.c */
