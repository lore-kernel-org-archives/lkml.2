Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2ITMW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:22:56 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:54174 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab2ITMLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:11:31 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bob Copeland <me@bobcopeland.com>
Date: Thu, 20 Sep 2012 04:42:01 -0700
Message-Id: <1348141326-23355-20-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18eP3waMD6JmKbhC7Sqq5T2aghYQVJjpvM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 20/25] userns: Convert omfs to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Bob Copeland <me@bobcopeland.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/omfs/inode.c |    8 ++++++--
 fs/omfs/omfs.h  |    4 ++--
 init/Kconfig    |    1 -
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index e6213b3..25d715c 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -391,12 +391,16 @@ static int parse_options(char *options, struct omfs_sb_info *sbi)
 		case Opt_uid:
 			if (match_int(&args[0], &option))
 				return 0;
-			sbi->s_uid = option;
+			sbi->s_uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(sbi->s_uid))
+				return 0;
 			break;
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
-			sbi->s_gid = option;
+			sbi->s_gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(sbi->s_gid))
+				return 0;
 			break;
 		case Opt_umask:
 			if (match_octal(&args[0], &option))
diff --git a/fs/omfs/omfs.h b/fs/omfs/omfs.h
index 8941f12..f0f8bc7 100644
--- a/fs/omfs/omfs.h
+++ b/fs/omfs/omfs.h
@@ -19,8 +19,8 @@ struct omfs_sb_info {
 	unsigned long **s_imap;
 	int s_imap_size;
 	struct mutex s_bitmap_lock;
-	int s_uid;
-	int s_gid;
+	kuid_t s_uid;
+	kgid_t s_gid;
 	int s_dmask;
 	int s_fmask;
 };
diff --git a/init/Kconfig b/init/Kconfig
index 0f65a02..390e629 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -950,7 +950,6 @@ config UIDGID_CONVERTED
 	depends on NFSD = n
 	depends on NFS_FS = n
 	depends on OCFS2_FS = n
-	depends on OMFS_FS = n
 	depends on QNX4FS_FS = n
 	depends on QNX6FS_FS = n
 	depends on REISERFS_FS = n
-- 
1.7.5.4

