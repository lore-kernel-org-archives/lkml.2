Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2ITLnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:43:12 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51796 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab2ITLm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:42:56 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 20 Sep 2012 04:41:48 -0700
Message-Id: <1348141326-23355-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18hwbEvWYWwIJBcJvqROmU+JoOT5Qs0rwA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1356]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 07/25] userns: Convert adfs to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/adfs/adfs.h  |    4 ++--
 fs/adfs/inode.c |    4 ++--
 fs/adfs/super.c |   21 +++++++++++++--------
 init/Kconfig    |    1 -
 4 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/adfs/adfs.h b/fs/adfs/adfs.h
index 718ac1f..585adaf 100644
--- a/fs/adfs/adfs.h
+++ b/fs/adfs/adfs.h
@@ -46,8 +46,8 @@ struct adfs_sb_info {
 	struct adfs_discmap *s_map;	/* bh list containing map		 */
 	struct adfs_dir_ops *s_dir;	/* directory operations			 */
 
-	uid_t		s_uid;		/* owner uid				 */
-	gid_t		s_gid;		/* owner gid				 */
+	kuid_t		s_uid;		/* owner uid				 */
+	kgid_t		s_gid;		/* owner gid				 */
 	umode_t		s_owner_mask;	/* ADFS owner perm -> unix perm		 */
 	umode_t		s_other_mask;	/* ADFS other perm -> unix perm		 */
 	int		s_ftsuffix;	/* ,xyz hex filetype suffix option */
diff --git a/fs/adfs/inode.c b/fs/adfs/inode.c
index 1dab6a1..e9bad50 100644
--- a/fs/adfs/inode.c
+++ b/fs/adfs/inode.c
@@ -304,8 +304,8 @@ adfs_notify_change(struct dentry *dentry, struct iattr *attr)
 	 * we can't change the UID or GID of any file -
 	 * we have a global UID/GID in the superblock
 	 */
-	if ((ia_valid & ATTR_UID && attr->ia_uid != ADFS_SB(sb)->s_uid) ||
-	    (ia_valid & ATTR_GID && attr->ia_gid != ADFS_SB(sb)->s_gid))
+	if ((ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, ADFS_SB(sb)->s_uid)) ||
+	    (ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, ADFS_SB(sb)->s_gid)))
 		error = -EPERM;
 
 	if (error)
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index bdaec92..22a0d7e 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/statfs.h>
+#include <linux/user_namespace.h>
 #include "adfs.h"
 #include "dir_f.h"
 #include "dir_fplus.h"
@@ -130,10 +131,10 @@ static int adfs_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct adfs_sb_info *asb = ADFS_SB(root->d_sb);
 
-	if (asb->s_uid != 0)
-		seq_printf(seq, ",uid=%u", asb->s_uid);
-	if (asb->s_gid != 0)
-		seq_printf(seq, ",gid=%u", asb->s_gid);
+	if (!uid_eq(asb->s_uid, GLOBAL_ROOT_UID))
+		seq_printf(seq, ",uid=%u", from_kuid_munged(&init_user_ns, asb->s_uid));
+	if (!gid_eq(asb->s_gid, GLOBAL_ROOT_GID))
+		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, asb->s_gid));
 	if (asb->s_owner_mask != ADFS_DEFAULT_OWNER_MASK)
 		seq_printf(seq, ",ownmask=%o", asb->s_owner_mask);
 	if (asb->s_other_mask != ADFS_DEFAULT_OTHER_MASK)
@@ -175,12 +176,16 @@ static int parse_options(struct super_block *sb, char *options)
 		case Opt_uid:
 			if (match_int(args, &option))
 				return -EINVAL;
-			asb->s_uid = option;
+			asb->s_uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(asb->s_uid))
+				return -EINVAL;
 			break;
 		case Opt_gid:
 			if (match_int(args, &option))
 				return -EINVAL;
-			asb->s_gid = option;
+			asb->s_gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(asb->s_gid))
+				return -EINVAL;
 			break;
 		case Opt_ownmask:
 			if (match_octal(args, &option))
@@ -369,8 +374,8 @@ static int adfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_fs_info = asb;
 
 	/* set default options */
-	asb->s_uid = 0;
-	asb->s_gid = 0;
+	asb->s_uid = GLOBAL_ROOT_UID;
+	asb->s_gid = GLOBAL_ROOT_GID;
 	asb->s_owner_mask = ADFS_DEFAULT_OWNER_MASK;
 	asb->s_other_mask = ADFS_DEFAULT_OTHER_MASK;
 	asb->s_ftsuffix = 0;
diff --git a/init/Kconfig b/init/Kconfig
index 485c60a..20ddf0d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -933,7 +933,6 @@ config UIDGID_CONVERTED
 
 	# Filesystems
 	depends on 9P_FS = n
-	depends on ADFS_FS = n
 	depends on AFFS_FS = n
 	depends on AFS_FS = n
 	depends on AUTOFS4_FS = n
-- 
1.7.5.4

