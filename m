Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab2ITMLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:11:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41427 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2ITMLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:11:34 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 20 Sep 2012 04:41:58 -0700
Message-Id: <1348141326-23355-17-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19bagFmntilvVLqqvxl7Pjo355yTHlCPhM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0272]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: ****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 17/25] userns: Convert minix to use kuid/kgid where appropriate
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
 fs/minix/inode.c |   16 ++++++++--------
 init/Kconfig     |    1 -
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 2a503ad..d0e42c6 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -460,8 +460,8 @@ static struct inode *V1_minix_iget(struct inode *inode)
 		return ERR_PTR(-EIO);
 	}
 	inode->i_mode = raw_inode->i_mode;
-	inode->i_uid = (uid_t)raw_inode->i_uid;
-	inode->i_gid = (gid_t)raw_inode->i_gid;
+	i_uid_write(inode, raw_inode->i_uid);
+	i_gid_write(inode, raw_inode->i_gid);
 	set_nlink(inode, raw_inode->i_nlinks);
 	inode->i_size = raw_inode->i_size;
 	inode->i_mtime.tv_sec = inode->i_atime.tv_sec = inode->i_ctime.tv_sec = raw_inode->i_time;
@@ -493,8 +493,8 @@ static struct inode *V2_minix_iget(struct inode *inode)
 		return ERR_PTR(-EIO);
 	}
 	inode->i_mode = raw_inode->i_mode;
-	inode->i_uid = (uid_t)raw_inode->i_uid;
-	inode->i_gid = (gid_t)raw_inode->i_gid;
+	i_uid_write(inode, raw_inode->i_uid);
+	i_gid_write(inode, raw_inode->i_gid);
 	set_nlink(inode, raw_inode->i_nlinks);
 	inode->i_size = raw_inode->i_size;
 	inode->i_mtime.tv_sec = raw_inode->i_mtime;
@@ -545,8 +545,8 @@ static struct buffer_head * V1_minix_update_inode(struct inode * inode)
 	if (!raw_inode)
 		return NULL;
 	raw_inode->i_mode = inode->i_mode;
-	raw_inode->i_uid = fs_high2lowuid(inode->i_uid);
-	raw_inode->i_gid = fs_high2lowgid(inode->i_gid);
+	raw_inode->i_uid = fs_high2lowuid(i_uid_read(inode));
+	raw_inode->i_gid = fs_high2lowgid(i_gid_read(inode));
 	raw_inode->i_nlinks = inode->i_nlink;
 	raw_inode->i_size = inode->i_size;
 	raw_inode->i_time = inode->i_mtime.tv_sec;
@@ -572,8 +572,8 @@ static struct buffer_head * V2_minix_update_inode(struct inode * inode)
 	if (!raw_inode)
 		return NULL;
 	raw_inode->i_mode = inode->i_mode;
-	raw_inode->i_uid = fs_high2lowuid(inode->i_uid);
-	raw_inode->i_gid = fs_high2lowgid(inode->i_gid);
+	raw_inode->i_uid = fs_high2lowuid(i_uid_read(inode));
+	raw_inode->i_gid = fs_high2lowgid(i_gid_read(inode));
 	raw_inode->i_nlinks = inode->i_nlink;
 	raw_inode->i_size = inode->i_size;
 	raw_inode->i_mtime = inode->i_mtime.tv_sec;
diff --git a/init/Kconfig b/init/Kconfig
index 80edba8..c69e085 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -946,7 +946,6 @@ config UIDGID_CONVERTED
 	depends on HPFS_FS = n
 	depends on JFFS2_FS = n
 	depends on JFS_FS = n
-	depends on MINIX_FS = n
 	depends on NCP_FS = n
 	depends on NFSD = n
 	depends on NFS_FS = n
-- 
1.7.5.4

