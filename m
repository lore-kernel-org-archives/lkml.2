Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2DHFNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:13:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51528 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2DHFM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:26 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:21 -0700
Message-Id: <1333862139-31737-25-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+cH0JUEHPSw3PtGd5KSLhf8ne6Z7fKcRE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 25/43] userns: Store uid and gid types in vfs structures with kuid_t and kgid_t types
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

The conversion of all of the users is not done yet there are too many to change
in one go and leave the code reviewable. For now I change just the header and
a few trivial users and rely on CONFIG_UIDGID_STRICT_TYPE_CHECKS not being set
to ensure that the code will still compile during the transition.

Helper functions i_uid_read, i_uid_write, i_gid_read, i_gid_write are added
so that in most cases filesystems can avoid the complexities of multiple user
namespaces and can concentrate on moving their raw numeric values into and
out of the vfs data structures.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/inode.c         |    6 +++---
 include/linux/fs.h |   36 +++++++++++++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index f0c4ace..deb72f6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -135,8 +135,8 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_fop = &empty_fops;
 	inode->__i_nlink = 1;
 	inode->i_opflags = 0;
-	inode->i_uid = 0;
-	inode->i_gid = 0;
+	i_uid_write(inode, 0);
+	i_gid_write(inode, 0);
 	atomic_set(&inode->i_writecount, 0);
 	inode->i_size = 0;
 	inode->i_blocks = 0;
@@ -1732,7 +1732,7 @@ EXPORT_SYMBOL(inode_init_owner);
  */
 bool inode_owner_or_capable(const struct inode *inode)
 {
-	if (current_fsuid() == inode->i_uid)
+	if (uid_eq(current_fsuid(), inode->i_uid))
 		return true;
 	if (inode_capable(inode, CAP_FOWNER))
 		return true;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a6c5efb..797eb26 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -402,6 +402,7 @@ struct inodes_stat_t {
 #include <linux/atomic.h>
 #include <linux/shrinker.h>
 #include <linux/migrate_mode.h>
+#include <linux/uidgid.h>
 
 #include <asm/byteorder.h>
 
@@ -469,8 +470,8 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 struct iattr {
 	unsigned int	ia_valid;
 	umode_t		ia_mode;
-	uid_t		ia_uid;
-	gid_t		ia_gid;
+	kuid_t		ia_uid;
+	kgid_t		ia_gid;
 	loff_t		ia_size;
 	struct timespec	ia_atime;
 	struct timespec	ia_mtime;
@@ -761,8 +762,8 @@ struct posix_acl;
 struct inode {
 	umode_t			i_mode;
 	unsigned short		i_opflags;
-	uid_t			i_uid;
-	gid_t			i_gid;
+	kuid_t			i_uid;
+	kgid_t			i_gid;
 	unsigned int		i_flags;
 
 #ifdef CONFIG_FS_POSIX_ACL
@@ -927,6 +928,31 @@ static inline void i_size_write(struct inode *inode, loff_t i_size)
 #endif
 }
 
+/* Helper functions so that in most cases filesystems will
+ * not need to deal directly with kuid_t and kgid_t and can
+ * instead deal with the raw numeric values that are stored
+ * in the filesystem.
+ */
+static inline uid_t i_uid_read(const struct inode *inode)
+{
+	return from_kuid(&init_user_ns, inode->i_uid);
+}
+
+static inline gid_t i_gid_read(const struct inode *inode)
+{
+	return from_kgid(&init_user_ns, inode->i_gid);
+}
+
+static inline void i_uid_write(struct inode *inode, uid_t uid)
+{
+	inode->i_uid = make_kuid(&init_user_ns, uid);
+}
+
+static inline void i_gid_write(struct inode *inode, gid_t gid)
+{
+	inode->i_gid = make_kgid(&init_user_ns, gid);
+}
+
 static inline unsigned iminor(const struct inode *inode)
 {
 	return MINOR(inode->i_rdev);
@@ -943,7 +969,7 @@ struct fown_struct {
 	rwlock_t lock;          /* protects pid, uid, euid fields */
 	struct pid *pid;	/* pid or -pgrp where SIGIO should be sent */
 	enum pid_type pid_type;	/* Kind of process group SIGIO should be sent to */
-	uid_t uid, euid;	/* uid/euid of process setting the owner */
+	kuid_t uid, euid;	/* uid/euid of process setting the owner */
 	int signum;		/* posix.1b rt signal to be delivered on IO */
 };
 
-- 
1.7.2.5

