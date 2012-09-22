Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab2IVBlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:41:32 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56713 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178Ab2IVBl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:41:29 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Evgeniy Dushistov <dushistov@mail.ru>
Date: Fri, 21 Sep 2012 18:35:12 -0700
Message-Id: <1348277712-30055-11-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
References: <877grmj115.fsf@xmission.com>
 <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Kyk6IpmfFcioBt7ebl6oVp0tcRsGNOkM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0280]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 
X-Spam-Combo: ****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 11/11] userns: Convert the ufs filesystem to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/ufs/inode.c |   16 ++++++++--------
 init/Kconfig   |    1 -
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index dd7c89d..eb6d0b7 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -597,8 +597,8 @@ static int ufs1_read_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 	/*
 	 * Linux now has 32-bit uid and gid, so we can support EFT.
 	 */
-	inode->i_uid = ufs_get_inode_uid(sb, ufs_inode);
-	inode->i_gid = ufs_get_inode_gid(sb, ufs_inode);
+	i_uid_write(inode, ufs_get_inode_uid(sb, ufs_inode));
+	i_gid_write(inode, ufs_get_inode_gid(sb, ufs_inode));
 
 	inode->i_size = fs64_to_cpu(sb, ufs_inode->ui_size);
 	inode->i_atime.tv_sec = fs32_to_cpu(sb, ufs_inode->ui_atime.tv_sec);
@@ -645,8 +645,8 @@ static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
         /*
          * Linux now has 32-bit uid and gid, so we can support EFT.
          */
-	inode->i_uid = fs32_to_cpu(sb, ufs2_inode->ui_uid);
-	inode->i_gid = fs32_to_cpu(sb, ufs2_inode->ui_gid);
+	i_uid_write(inode, fs32_to_cpu(sb, ufs2_inode->ui_uid));
+	i_gid_write(inode, fs32_to_cpu(sb, ufs2_inode->ui_gid));
 
 	inode->i_size = fs64_to_cpu(sb, ufs2_inode->ui_size);
 	inode->i_atime.tv_sec = fs64_to_cpu(sb, ufs2_inode->ui_atime);
@@ -745,8 +745,8 @@ static void ufs1_update_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 	ufs_inode->ui_mode = cpu_to_fs16(sb, inode->i_mode);
 	ufs_inode->ui_nlink = cpu_to_fs16(sb, inode->i_nlink);
 
-	ufs_set_inode_uid(sb, ufs_inode, inode->i_uid);
-	ufs_set_inode_gid(sb, ufs_inode, inode->i_gid);
+	ufs_set_inode_uid(sb, ufs_inode, i_uid_read(inode));
+	ufs_set_inode_gid(sb, ufs_inode, i_gid_read(inode));
 		
 	ufs_inode->ui_size = cpu_to_fs64(sb, inode->i_size);
 	ufs_inode->ui_atime.tv_sec = cpu_to_fs32(sb, inode->i_atime.tv_sec);
@@ -789,8 +789,8 @@ static void ufs2_update_inode(struct inode *inode, struct ufs2_inode *ufs_inode)
 	ufs_inode->ui_mode = cpu_to_fs16(sb, inode->i_mode);
 	ufs_inode->ui_nlink = cpu_to_fs16(sb, inode->i_nlink);
 
-	ufs_inode->ui_uid = cpu_to_fs32(sb, inode->i_uid);
-	ufs_inode->ui_gid = cpu_to_fs32(sb, inode->i_gid);
+	ufs_inode->ui_uid = cpu_to_fs32(sb, i_uid_read(inode));
+	ufs_inode->ui_gid = cpu_to_fs32(sb, i_gid_read(inode));
 
 	ufs_inode->ui_size = cpu_to_fs64(sb, inode->i_size);
 	ufs_inode->ui_atime = cpu_to_fs64(sb, inode->i_atime.tv_sec);
diff --git a/init/Kconfig b/init/Kconfig
index 6f9819a..577916d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -939,7 +939,6 @@ config UIDGID_CONVERTED
 	depends on NFSD = n
 	depends on NFS_FS = n
 	depends on OCFS2_FS = n
-	depends on UFS_FS = n
 	depends on XFS_FS = n
 
 config UIDGID_STRICT_TYPE_CHECKS
-- 
1.7.5.4

