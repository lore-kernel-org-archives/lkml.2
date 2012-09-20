Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab2ITMLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:11:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54919 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2ITMLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:11:30 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 20 Sep 2012 04:41:54 -0700
Message-Id: <1348141326-23355-13-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1952djkEC3ZHiODzE161F6W0LKoX094UXE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0341]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 13/25] userns: Convert hfs to use kuid and kgid where appropriate
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
 fs/hfs/hfs_fs.h |    4 ++--
 fs/hfs/inode.c  |    4 ++--
 fs/hfs/super.c  |   16 +++++++++++++---
 init/Kconfig    |    1 -
 4 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 8275175..693df9f 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -134,8 +134,8 @@ struct hfs_sb_info {
 						   permissions on all files */
 	umode_t s_dir_umask;			/* The umask applied to the
 						   permissions on all dirs */
-	uid_t s_uid;				/* The uid of all files */
-	gid_t s_gid;				/* The gid of all files */
+	kuid_t s_uid;				/* The uid of all files */
+	kgid_t s_gid;				/* The gid of all files */
 
 	int session, part;
 	struct nls_table *nls_io, *nls_disk;
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index ee1bc55..5d5c22d 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -594,9 +594,9 @@ int hfs_inode_setattr(struct dentry *dentry, struct iattr * attr)
 
 	/* no uig/gid changes and limit which mode bits can be set */
 	if (((attr->ia_valid & ATTR_UID) &&
-	     (attr->ia_uid != hsb->s_uid)) ||
+	     (!uid_eq(attr->ia_uid, hsb->s_uid))) ||
 	    ((attr->ia_valid & ATTR_GID) &&
-	     (attr->ia_gid != hsb->s_gid)) ||
+	     (!gid_eq(attr->ia_gid, hsb->s_gid))) ||
 	    ((attr->ia_valid & ATTR_MODE) &&
 	     ((S_ISDIR(inode->i_mode) &&
 	       (attr->ia_mode != inode->i_mode)) ||
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 4eb873e..0b63d13 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -138,7 +138,9 @@ static int hfs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",creator=%.4s", (char *)&sbi->s_creator);
 	if (sbi->s_type != cpu_to_be32(0x3f3f3f3f))
 		seq_printf(seq, ",type=%.4s", (char *)&sbi->s_type);
-	seq_printf(seq, ",uid=%u,gid=%u", sbi->s_uid, sbi->s_gid);
+	seq_printf(seq, ",uid=%u,gid=%u",
+			from_kuid_munged(&init_user_ns, sbi->s_uid),
+			from_kgid_munged(&init_user_ns, sbi->s_gid));
 	if (sbi->s_file_umask != 0133)
 		seq_printf(seq, ",file_umask=%o", sbi->s_file_umask);
 	if (sbi->s_dir_umask != 0022)
@@ -254,14 +256,22 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
 				printk(KERN_ERR "hfs: uid requires an argument\n");
 				return 0;
 			}
-			hsb->s_uid = (uid_t)tmp;
+			hsb->s_uid = make_kuid(current_user_ns(), (uid_t)tmp);
+			if (!uid_valid(hsb->s_uid)) {
+				printk(KERN_ERR "hfs: invalid uid %d\n", tmp);
+				return 0;
+			}
 			break;
 		case opt_gid:
 			if (match_int(&args[0], &tmp)) {
 				printk(KERN_ERR "hfs: gid requires an argument\n");
 				return 0;
 			}
-			hsb->s_gid = (gid_t)tmp;
+			hsb->s_gid = make_kgid(current_user_ns(), (gid_t)tmp);
+			if (!gid_valid(hsb->s_gid)) {
+				printk(KERN_ERR "hfs: invalid gid %d\n", tmp);
+				return 0;
+			}
 			break;
 		case opt_umask:
 			if (match_octal(&args[0], &tmp)) {
diff --git a/init/Kconfig b/init/Kconfig
index 39e55d6..6038d64 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -943,7 +943,6 @@ config UIDGID_CONVERTED
 	depends on CODA_FS = n
 	depends on FUSE_FS = n
 	depends on GFS2_FS = n
-	depends on HFS_FS = n
 	depends on HFSPLUS_FS = n
 	depends on HPFS_FS = n
 	depends on ISO9660_FS = n
-- 
1.7.5.4

