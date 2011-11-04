Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1KDCPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:15:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43482 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1KDCPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:15:21 -0400
MIME-Version: 1.0
In-Reply-To: <201111032026.FIF95800.HOJFOFFtQMSVLO@I-love.SAKURA.ne.jp>
References: <CAH-7YMmx0J+pQFfrU4KW2ahFDPL3udvAUgPy4_Hf19HP46MZHw@mail.gmail.com>
	<CAH-7YMmAM8e051PopL92WhqSvqz23_eWKjfZbuaLZ4_UhGR5jw@mail.gmail.com>
	<alpine.LRH.2.00.1110271718510.5714@tundra.namei.org>
	<alpine.LRH.2.00.1110281044410.11733@tundra.namei.org>
	<CAH-7YMnsKTg-CgBaHXzzYV4WBxRGxBbEfHpUUMS9UyzV+12d1g@mail.gmail.com>
	<201111032026.FIF95800.HOJFOFFtQMSVLO@I-love.SAKURA.ne.jp>
Date: Fri, 4 Nov 2011 10:15:20 +0800
Message-ID: <CAH-7YM=+K3DC=zAUSjD9kRU4afA1P37o6wfSTt9WjS__bMgWrQ@mail.gmail.com>
Subject: Re: [PATCH] ACL supports to mqueue
From: Zhou Peng <ailvpeng25@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: James Morris <jmorris@namei.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hughd@google.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        John Johansen <john.johansen@canonical.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 7:26 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> I'm not the person to judge the need of this feature, but
>
> | +static const struct inode_operations mqueue_inode_operations = {
> | +#ifdef CONFIG_MQUEUE_POSIX_ACL
> | +     .setxattr    = generic_setxattr,
> | +     .getxattr    = generic_getxattr,
> | +     .listxattr   = generic_listxattr,
> | +     .removexattr = generic_removexattr,
> | +     .check_acl   = generic_check_acl,
> | +     .setattr     = mqueue_setattr,
> | +#endif
> |  };
>
> no need to define mqueue_inode_operations if !CONFIG_MQUEUE_POSIX_ACL. ;-)

Thank you Tetsuo Handa.
The fixed patch is listed in line below.
-----

This patch adds ACL supports to mqueue filesystem.
Based on Linux 3.0.4.

Signed-off-by: Zhou Peng <zhoupeng@nfs.iscas.ac.cn>

diff --git a/fs/Kconfig b/fs/Kconfig
index 19891aa..dbf0aca 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -151,6 +151,14 @@ config TMPFS_XATTR

 	  If unsure, say N.

+config MQUEUE_POSIX_ACL
+       bool "Mqueue POSIX Access Control Lists support"
+       depends on POSIX_MQUEUE
+       select GENERIC_ACL
+       help
+         Mqueue is a file system which is used to suport POSIX msg queue.
+	 Say y to get Access Control Lists support for mqueue file system.
+
 config HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || IA64 || SPARC64 || (S390 && 64BIT) || \
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 14fb6d6..73cdee2 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -10,6 +10,9 @@
  *
  * Audit:                   George Wilson           (ltcgcw@us.ibm.com)
  *
+ * ACL:
+ * Copyright (c) 2011       Zhou Peng               (ailvpeng25@gmail.com)
+ *
  * This file is released under the GPL.
  */

@@ -33,6 +36,9 @@
 #include <linux/pid.h>
 #include <linux/ipc_namespace.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
+#include <linux/posix_acl.h>
+#include <linux/generic_acl.h>

 #include <net/sock.h>
 #include "util.h"
@@ -76,6 +82,9 @@ struct mqueue_inode_info {
 };

 static const struct inode_operations mqueue_dir_inode_operations;
+#ifdef CONFIG_MQUEUE_POSIX_ACL
+static const struct inode_operations mqueue_inode_operations;
+#endif
 static const struct file_operations mqueue_file_operations;
 static const struct super_operations mqueue_super_ops;
 static void remove_notification(struct mqueue_inode_info *info);
@@ -84,6 +93,14 @@ static struct kmem_cache *mqueue_inode_cachep;

 static struct ctl_table_header * mq_sysctl_table;

+#ifdef CONFIG_MQUEUE_POSIX_ACL
+static const struct xattr_handler *mqueue_xattr_handlers[] = {
+	&generic_acl_access_handler,
+	&generic_acl_default_handler,
+	NULL
+};
+#endif
+
 static inline struct mqueue_inode_info *MQUEUE_I(struct inode *inode)
 {
 	return container_of(inode, struct mqueue_inode_info, vfs_inode);
@@ -122,12 +139,19 @@ static struct inode *mqueue_get_inode(struct
super_block *sb,
 		inode->i_gid = current_fsgid();
 		inode->i_mtime = inode->i_ctime = inode->i_atime =
 				CURRENT_TIME;
+#ifdef CONFIG_MQUEUE_POSIX_ACL
+		cache_no_acl(inode);
+#endif

 		if (S_ISREG(mode)) {
 			struct mqueue_inode_info *info;
 			struct task_struct *p = current;
 			unsigned long mq_bytes, mq_msg_tblsz;

+#ifdef CONFIG_MQUEUE_POSIX_ACL			
+			inode->i_op = &mqueue_inode_operations;
+#endif
+
 			inode->i_fop = &mqueue_file_operations;
 			inode->i_size = FILENT_SIZE;
 			/* mqueue specific info */
@@ -192,6 +216,11 @@ static int mqueue_fill_super(struct super_block
*sb, void *data, int silent)
 	sb->s_magic = MQUEUE_MAGIC;
 	sb->s_op = &mqueue_super_ops;

+#ifdef CONFIG_MQUEUE_POSIX_ACL
+	sb->s_xattr = mqueue_xattr_handlers;
+	sb->s_flags |= MS_POSIXACL;
+#endif
+
 	inode = mqueue_get_inode(sb, ns, S_IFDIR | S_ISVTX | S_IRWXUGO,
 				NULL);
 	if (!inode) {
@@ -322,6 +351,16 @@ static int mqueue_create(struct inode *dir,
struct dentry *dentry,
 		goto out_unlock;
 	}

+#ifdef CONFIG_MQUEUE_POSIX_ACL
+	error = generic_acl_init(inode, dir);
+	if (error) {
+		iput(inode);
+		spin_lock(&mq_lock);
+		ipc_ns->mq_queues_count--;
+		goto out_unlock;
+	}
+#endif
+
 	put_ipc_ns(ipc_ns);
 	dir->i_size += DIRENT_SIZE;
 	dir->i_ctime = dir->i_mtime = dir->i_atime = CURRENT_TIME;
@@ -1217,11 +1256,47 @@ out:
 	return ret;
 }

+#ifdef CONFIG_MQUEUE_POSIX_ACL
+static int mqueue_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	error = simple_setattr(dentry, attr);
+	if (error)
+		return error;
+
+	if (attr->ia_valid & ATTR_MODE)
+		error = generic_acl_chmod(inode);
+
+	return error;
+}
+#endif
+
 static const struct inode_operations mqueue_dir_inode_operations = {
 	.lookup = simple_lookup,
 	.create = mqueue_create,
 	.unlink = mqueue_unlink,
+#ifdef CONFIG_MQUEUE_POSIX_ACL
+	.setxattr    = generic_setxattr,
+	.getxattr    = generic_getxattr,
+	.listxattr   = generic_listxattr,
+	.removexattr = generic_removexattr,
+	.check_acl   = generic_check_acl,
+	.setattr     = mqueue_setattr,
+#endif
+};
+
+#ifdef CONFIG_MQUEUE_POSIX_ACL
+static const struct inode_operations mqueue_inode_operations = {
+	.setxattr    = generic_setxattr,
+	.getxattr    = generic_getxattr,
+	.listxattr   = generic_listxattr,
+	.removexattr = generic_removexattr,
+	.check_acl   = generic_check_acl,
+	.setattr     = mqueue_setattr,
 };
+#endif

 static const struct file_operations mqueue_file_operations = {
 	.flush = mqueue_flush_file,
--
Zhou Peng
