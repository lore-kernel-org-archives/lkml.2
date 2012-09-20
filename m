Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2ITLnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:43:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51920 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab2ITLnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:43:04 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 20 Sep 2012 04:41:49 -0700
Message-Id: <1348141326-23355-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18LkpZnNtQVUThOLRLN8JVnDeLL6vQQdaQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0133]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 08/25] userns: Convert befs to use kuid/kgid where appropriate
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
 fs/befs/befs.h     |    4 ++--
 fs/befs/linuxvfs.c |   27 +++++++++++++++++++--------
 init/Kconfig       |    1 -
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/befs/befs.h b/fs/befs/befs.h
index d9a40ab..b266428 100644
--- a/fs/befs/befs.h
+++ b/fs/befs/befs.h
@@ -20,8 +20,8 @@ typedef u64 befs_blocknr_t;
  */
 
 typedef struct befs_mount_options {
-	gid_t gid;
-	uid_t uid;
+	kgid_t gid;
+	kuid_t uid;
 	int use_gid;
 	int use_uid;
 	int debug;
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index cf7f3c6..7f73a69 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -15,6 +15,7 @@
 #include <linux/vfs.h>
 #include <linux/parser.h>
 #include <linux/namei.h>
+#include <linux/sched.h>
 
 #include "befs.h"
 #include "btree.h"
@@ -352,9 +353,11 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	 */   
 
 	inode->i_uid = befs_sb->mount_opts.use_uid ?
-	    befs_sb->mount_opts.uid : (uid_t) fs32_to_cpu(sb, raw_inode->uid);
+		befs_sb->mount_opts.uid :
+		make_kuid(&init_user_ns, fs32_to_cpu(sb, raw_inode->uid));
 	inode->i_gid = befs_sb->mount_opts.use_gid ?
-	    befs_sb->mount_opts.gid : (gid_t) fs32_to_cpu(sb, raw_inode->gid);
+		befs_sb->mount_opts.gid :
+		make_kgid(&init_user_ns, fs32_to_cpu(sb, raw_inode->gid));
 
 	set_nlink(inode, 1);
 
@@ -674,10 +677,12 @@ parse_options(char *options, befs_mount_options * opts)
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int option;
+	kuid_t uid;
+	kgid_t gid;
 
 	/* Initialize options */
-	opts->uid = 0;
-	opts->gid = 0;
+	opts->uid = GLOBAL_ROOT_UID;
+	opts->gid = GLOBAL_ROOT_GID;
 	opts->use_uid = 0;
 	opts->use_gid = 0;
 	opts->iocharset = NULL;
@@ -696,23 +701,29 @@ parse_options(char *options, befs_mount_options * opts)
 		case Opt_uid:
 			if (match_int(&args[0], &option))
 				return 0;
-			if (option < 0) {
+			uid = INVALID_UID;
+			if (option >= 0)
+				uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(uid)) {
 				printk(KERN_ERR "BeFS: Invalid uid %d, "
 						"using default\n", option);
 				break;
 			}
-			opts->uid = option;
+			opts->uid = uid;
 			opts->use_uid = 1;
 			break;
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
-			if (option < 0) {
+			gid = INVALID_GID;
+			if (option >= 0)
+				gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(gid)) {
 				printk(KERN_ERR "BeFS: Invalid gid %d, "
 						"using default\n", option);
 				break;
 			}
-			opts->gid = option;
+			opts->gid = gid;
 			opts->use_gid = 1;
 			break;
 		case Opt_charset:
diff --git a/init/Kconfig b/init/Kconfig
index 20ddf0d..d9bb344 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -936,7 +936,6 @@ config UIDGID_CONVERTED
 	depends on AFFS_FS = n
 	depends on AFS_FS = n
 	depends on AUTOFS4_FS = n
-	depends on BEFS_FS = n
 	depends on BFS_FS = n
 	depends on BTRFS_FS = n
 	depends on CEPH_FS = n
-- 
1.7.5.4

