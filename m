Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab2IVBgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:36:13 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56149 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200Ab2IVBfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:35:54 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Phillip Lougher <phillip@squashfs.org.uk>
Date: Fri, 21 Sep 2012 18:35:09 -0700
Message-Id: <1348277712-30055-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
References: <877grmj115.fsf@xmission.com>
 <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/M9RXd5AUzEvwFO2tPi83UwcoC3bKpuoc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0056]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 08/11] userns: Convert squashfs to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Phillip Lougher <phillip@squashfs.org.uk>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/squashfs/inode.c |    8 ++++++--
 init/Kconfig        |    1 -
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/inode.c b/fs/squashfs/inode.c
index 81afbcc..a1ce5ce 100644
--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -56,16 +56,20 @@
 static int squashfs_new_inode(struct super_block *sb, struct inode *inode,
 				struct squashfs_base_inode *sqsh_ino)
 {
+	uid_t i_uid;
+	gid_t i_gid;
 	int err;
 
-	err = squashfs_get_id(sb, le16_to_cpu(sqsh_ino->uid), &inode->i_uid);
+	err = squashfs_get_id(sb, le16_to_cpu(sqsh_ino->uid), &i_uid);
 	if (err)
 		return err;
 
-	err = squashfs_get_id(sb, le16_to_cpu(sqsh_ino->guid), &inode->i_gid);
+	err = squashfs_get_id(sb, le16_to_cpu(sqsh_ino->guid), &i_gid);
 	if (err)
 		return err;
 
+	i_uid_write(inode, i_uid);
+	i_gid_write(inode, i_gid);
 	inode->i_ino = le32_to_cpu(sqsh_ino->inode_number);
 	inode->i_mtime.tv_sec = le32_to_cpu(sqsh_ino->mtime);
 	inode->i_atime.tv_sec = inode->i_mtime.tv_sec;
diff --git a/init/Kconfig b/init/Kconfig
index 8b11f29..d88f945 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -939,7 +939,6 @@ config UIDGID_CONVERTED
 	depends on NFSD = n
 	depends on NFS_FS = n
 	depends on OCFS2_FS = n
-	depends on SQUASHFS = n
 	depends on UBIFS_FS = n
 	depends on UDF_FS = n
 	depends on UFS_FS = n
-- 
1.7.5.4

