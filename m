Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab2IVBfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:35:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56120 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2IVBfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:35:38 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Date: Fri, 21 Sep 2012 18:35:05 -0700
Message-Id: <1348277712-30055-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
References: <877grmj115.fsf@xmission.com>
 <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+hwBcMtIvebh4rigkovg9JR/vhbATl0k0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4779]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 04/11] userns: Convert hpfs to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/hpfs/hpfs_fn.h |    4 ++--
 fs/hpfs/inode.c   |   19 +++++++++++--------
 fs/hpfs/namei.c   |    8 ++++----
 fs/hpfs/super.c   |   18 +++++++++++-------
 init/Kconfig      |    1 -
 5 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index ac1ead1..7102aae 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -63,8 +63,8 @@ struct hpfs_sb_info {
 	unsigned sb_dmap;		/* sector number of dnode bit map */
 	unsigned sb_n_free;		/* free blocks for statfs, or -1 */
 	unsigned sb_n_free_dnodes;	/* free dnodes for statfs, or -1 */
-	uid_t sb_uid;			/* uid from mount options */
-	gid_t sb_gid;			/* gid from mount options */
+	kuid_t sb_uid;			/* uid from mount options */
+	kgid_t sb_gid;			/* gid from mount options */
 	umode_t sb_mode;		/* mode from mount options */
 	unsigned sb_eas : 2;		/* eas: 0-ignore, 1-ro, 2-rw */
 	unsigned sb_err : 2;		/* on errs: 0-cont, 1-ro, 2-panic */
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index ed671e0..804a9a8 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/user_namespace.h>
 #include "hpfs_fn.h"
 
 void hpfs_init_inode(struct inode *i)
@@ -60,14 +61,14 @@ void hpfs_read_inode(struct inode *i)
 	if (hpfs_sb(i->i_sb)->sb_eas) {
 		if ((ea = hpfs_get_ea(i->i_sb, fnode, "UID", &ea_size))) {
 			if (ea_size == 2) {
-				i->i_uid = le16_to_cpu(*(__le16*)ea);
+				i_uid_write(i, le16_to_cpu(*(__le16*)ea));
 				hpfs_inode->i_ea_uid = 1;
 			}
 			kfree(ea);
 		}
 		if ((ea = hpfs_get_ea(i->i_sb, fnode, "GID", &ea_size))) {
 			if (ea_size == 2) {
-				i->i_gid = le16_to_cpu(*(__le16*)ea);
+				i_gid_write(i, le16_to_cpu(*(__le16*)ea));
 				hpfs_inode->i_ea_gid = 1;
 			}
 			kfree(ea);
@@ -149,13 +150,13 @@ static void hpfs_write_inode_ea(struct inode *i, struct fnode *fnode)
 		hpfs_error(i->i_sb, "fnode %08x has some unknown HPFS386 stuctures", i->i_ino);
 	} else*/ if (hpfs_sb(i->i_sb)->sb_eas >= 2) {
 		__le32 ea;
-		if ((i->i_uid != hpfs_sb(i->i_sb)->sb_uid) || hpfs_inode->i_ea_uid) {
-			ea = cpu_to_le32(i->i_uid);
+		if (!uid_eq(i->i_uid, hpfs_sb(i->i_sb)->sb_uid) || hpfs_inode->i_ea_uid) {
+			ea = cpu_to_le32(i_uid_read(i));
 			hpfs_set_ea(i, fnode, "UID", (char*)&ea, 2);
 			hpfs_inode->i_ea_uid = 1;
 		}
-		if ((i->i_gid != hpfs_sb(i->i_sb)->sb_gid) || hpfs_inode->i_ea_gid) {
-			ea = cpu_to_le32(i->i_gid);
+		if (!gid_eq(i->i_gid, hpfs_sb(i->i_sb)->sb_gid) || hpfs_inode->i_ea_gid) {
+			ea = cpu_to_le32(i_gid_read(i));
 			hpfs_set_ea(i, fnode, "GID", (char *)&ea, 2);
 			hpfs_inode->i_ea_gid = 1;
 		}
@@ -261,9 +262,11 @@ int hpfs_setattr(struct dentry *dentry, struct iattr *attr)
 	hpfs_lock(inode->i_sb);
 	if (inode->i_ino == hpfs_sb(inode->i_sb)->sb_root)
 		goto out_unlock;
-	if ((attr->ia_valid & ATTR_UID) && attr->ia_uid >= 0x10000)
+	if ((attr->ia_valid & ATTR_UID) &&
+	    from_kuid(&init_user_ns, attr->ia_uid) >= 0x10000)
 		goto out_unlock;
-	if ((attr->ia_valid & ATTR_GID) && attr->ia_gid >= 0x10000)
+	if ((attr->ia_valid & ATTR_GID) &&
+	    from_kgid(&init_user_ns, attr->ia_gid) >= 0x10000)
 		goto out_unlock;
 	if ((attr->ia_valid & ATTR_SIZE) && attr->ia_size > inode->i_size)
 		goto out_unlock;
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index bc90824..345713d 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -91,8 +91,8 @@ static int hpfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	inc_nlink(dir);
 	insert_inode_hash(result);
 
-	if (result->i_uid != current_fsuid() ||
-	    result->i_gid != current_fsgid() ||
+	if (!uid_eq(result->i_uid, current_fsuid()) ||
+	    !gid_eq(result->i_gid, current_fsgid()) ||
 	    result->i_mode != (mode | S_IFDIR)) {
 		result->i_uid = current_fsuid();
 		result->i_gid = current_fsgid();
@@ -179,8 +179,8 @@ static int hpfs_create(struct inode *dir, struct dentry *dentry, umode_t mode, b
 
 	insert_inode_hash(result);
 
-	if (result->i_uid != current_fsuid() ||
-	    result->i_gid != current_fsgid() ||
+	if (!uid_eq(result->i_uid, current_fsuid()) ||
+	    !gid_eq(result->i_gid, current_fsgid()) ||
 	    result->i_mode != (mode | S_IFREG)) {
 		result->i_uid = current_fsuid();
 		result->i_gid = current_fsgid();
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 706a12c..a152783 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -251,7 +251,7 @@ static const match_table_t tokens = {
 	{Opt_err, NULL},
 };
 
-static int parse_opts(char *opts, uid_t *uid, gid_t *gid, umode_t *umask,
+static int parse_opts(char *opts, kuid_t *uid, kgid_t *gid, umode_t *umask,
 		      int *lowercase, int *eas, int *chk, int *errs,
 		      int *chkdsk, int *timeshift)
 {
@@ -276,12 +276,16 @@ static int parse_opts(char *opts, uid_t *uid, gid_t *gid, umode_t *umask,
 		case Opt_uid:
 			if (match_int(args, &option))
 				return 0;
-			*uid = option;
+			*uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(*uid))
+				return 0;
 			break;
 		case Opt_gid:
 			if (match_int(args, &option))
 				return 0;
-			*gid = option;
+			*gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(*gid))
+				return 0;
 			break;
 		case Opt_umask:
 			if (match_octal(args, &option))
@@ -378,8 +382,8 @@ HPFS filesystem options:\n\
 
 static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
 {
-	uid_t uid;
-	gid_t gid;
+	kuid_t uid;
+	kgid_t gid;
 	umode_t umask;
 	int lowercase, eas, chk, errs, chkdsk, timeshift;
 	int o;
@@ -455,8 +459,8 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 	struct hpfs_sb_info *sbi;
 	struct inode *root;
 
-	uid_t uid;
-	gid_t gid;
+	kuid_t uid;
+	kgid_t gid;
 	umode_t umask;
 	int lowercase, eas, chk, errs, chkdsk, timeshift;
 
diff --git a/init/Kconfig b/init/Kconfig
index 44f580f..1db1b0f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -935,7 +935,6 @@ config UIDGID_CONVERTED
 	depends on CODA_FS = n
 	depends on FUSE_FS = n
 	depends on GFS2_FS = n
-	depends on HPFS_FS = n
 	depends on JFFS2_FS = n
 	depends on JFS_FS = n
 	depends on NCP_FS = n
-- 
1.7.5.4

