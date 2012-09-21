Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab2IUA34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:29:56 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41767 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585Ab2IUA3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:29:52 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Thu, 20 Sep 2012 17:28:46 -0700
Message-Id: <1348187330-6616-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19PNC+wBzJ9YvCWFNkmSsiyY2/ARksWTMM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 10/14] userns: Convert s390 hypfs to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/s390/hypfs/inode.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 6767b43..124ec1a 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -31,8 +31,8 @@ static struct dentry *hypfs_create_update_file(struct super_block *sb,
 					       struct dentry *dir);
 
 struct hypfs_sb_info {
-	uid_t uid;			/* uid used for files and dirs */
-	gid_t gid;			/* gid used for files and dirs */
+	kuid_t uid;			/* uid used for files and dirs */
+	kgid_t gid;			/* gid used for files and dirs */
 	struct dentry *update_file;	/* file to trigger update */
 	time_t last_update;		/* last update time in secs since 1970 */
 	struct mutex lock;		/* lock to protect update process */
@@ -229,6 +229,8 @@ static int hypfs_parse_options(char *options, struct super_block *sb)
 {
 	char *str;
 	substring_t args[MAX_OPT_ARGS];
+	kuid_t uid;
+	kgid_t gid;
 
 	if (!options)
 		return 0;
@@ -243,12 +245,18 @@ static int hypfs_parse_options(char *options, struct super_block *sb)
 		case opt_uid:
 			if (match_int(&args[0], &option))
 				return -EINVAL;
-			hypfs_info->uid = option;
+			uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(uid))
+				return -EINVAL;
+			hypfs_info->uid = uid;
 			break;
 		case opt_gid:
 			if (match_int(&args[0], &option))
 				return -EINVAL;
-			hypfs_info->gid = option;
+			gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(gid))
+				return -EINVAL;
+			hypfs_info->gid = gid;
 			break;
 		case opt_err:
 		default:
@@ -263,8 +271,8 @@ static int hypfs_show_options(struct seq_file *s, struct dentry *root)
 {
 	struct hypfs_sb_info *hypfs_info = root->d_sb->s_fs_info;
 
-	seq_printf(s, ",uid=%u", hypfs_info->uid);
-	seq_printf(s, ",gid=%u", hypfs_info->gid);
+	seq_printf(s, ",uid=%u", from_kuid_munged(&init_user_ns, hypfs_info->uid));
+	seq_printf(s, ",gid=%u", from_kgid_munged(&init_user_ns, hypfs_info->gid));
 	return 0;
 }
 
-- 
1.7.5.4

