Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2ITMMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:12:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54935 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab2ITMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:11:33 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 20 Sep 2012 04:41:56 -0700
Message-Id: <1348141326-23355-15-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+2RHBrHZxzcJDuMMWtAcpT94tSZyAEMKo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1272]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 15/25] userns: Convert isofs to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/isofs/inode.c |   17 +++++++++++------
 fs/isofs/isofs.h |    4 ++--
 fs/isofs/rock.c  |    4 ++--
 init/Kconfig     |    1 -
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 29037c3..a7d8e6c 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -21,6 +21,7 @@
 #include <linux/cdrom.h>
 #include <linux/parser.h>
 #include <linux/mpage.h>
+#include <linux/user_namespace.h>
 
 #include "isofs.h"
 #include "zisofs.h"
@@ -171,8 +172,8 @@ struct iso9660_options{
 	unsigned int blocksize;
 	umode_t fmode;
 	umode_t dmode;
-	gid_t gid;
-	uid_t uid;
+	kgid_t gid;
+	kuid_t uid;
 	char *iocharset;
 	/* LVE */
 	s32 session;
@@ -383,8 +384,8 @@ static int parse_options(char *options, struct iso9660_options *popt)
 	popt->fmode = popt->dmode = ISOFS_INVALID_MODE;
 	popt->uid_set = 0;
 	popt->gid_set = 0;
-	popt->gid = 0;
-	popt->uid = 0;
+	popt->gid = GLOBAL_ROOT_GID;
+	popt->uid = GLOBAL_ROOT_UID;
 	popt->iocharset = NULL;
 	popt->utf8 = 0;
 	popt->overriderockperm = 0;
@@ -460,13 +461,17 @@ static int parse_options(char *options, struct iso9660_options *popt)
 		case Opt_uid:
 			if (match_int(&args[0], &option))
 				return 0;
-			popt->uid = option;
+			popt->uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(popt->uid))
+				return 0;
 			popt->uid_set = 1;
 			break;
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
-			popt->gid = option;
+			popt->gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(popt->gid))
+				return 0;
 			popt->gid_set = 1;
 			break;
 		case Opt_mode:
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index 3620ad1..9916723 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -52,8 +52,8 @@ struct isofs_sb_info {
 
 	umode_t s_fmode;
 	umode_t s_dmode;
-	gid_t s_gid;
-	uid_t s_uid;
+	kgid_t s_gid;
+	kuid_t s_uid;
 	struct nls_table *s_nls_iocharset; /* Native language support table */
 };
 
diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index 70e79d0..c0bf424 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -364,8 +364,8 @@ repeat:
 		case SIG('P', 'X'):
 			inode->i_mode = isonum_733(rr->u.PX.mode);
 			set_nlink(inode, isonum_733(rr->u.PX.n_links));
-			inode->i_uid = isonum_733(rr->u.PX.uid);
-			inode->i_gid = isonum_733(rr->u.PX.gid);
+			i_uid_write(inode, isonum_733(rr->u.PX.uid));
+			i_gid_write(inode, isonum_733(rr->u.PX.gid));
 			break;
 		case SIG('P', 'N'):
 			{
diff --git a/init/Kconfig b/init/Kconfig
index 9cf8cb1..88f6571 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -944,7 +944,6 @@ config UIDGID_CONVERTED
 	depends on FUSE_FS = n
 	depends on GFS2_FS = n
 	depends on HPFS_FS = n
-	depends on ISO9660_FS = n
 	depends on JFFS2_FS = n
 	depends on JFS_FS = n
 	depends on LOGFS = n
-- 
1.7.5.4

