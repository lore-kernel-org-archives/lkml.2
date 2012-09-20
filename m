Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab2ITMLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:11:40 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54950 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2ITMLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:11:35 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>
Date: Thu, 20 Sep 2012 04:41:57 -0700
Message-Id: <1348141326-23355-16-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+kjcMPlEe6guuFaqG1zdVRVwO9dIeYoKE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0013]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 16/25] userns: Convert logfs to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/logfs/inode.c     |    4 ++--
 fs/logfs/readwrite.c |    8 ++++----
 init/Kconfig         |    1 -
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index a422f42..43f61c2 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -192,8 +192,8 @@ static void logfs_init_inode(struct super_block *sb, struct inode *inode)
 	li->li_height	= 0;
 	li->li_used_bytes = 0;
 	li->li_block	= NULL;
-	inode->i_uid	= 0;
-	inode->i_gid	= 0;
+	i_uid_write(inode, 0);
+	i_gid_write(inode, 0);
 	inode->i_size	= 0;
 	inode->i_blocks	= 0;
 	inode->i_ctime	= CURRENT_TIME;
diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index f1cb512..a8d492d 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -119,8 +119,8 @@ static void logfs_disk_to_inode(struct logfs_disk_inode *di, struct inode*inode)
 	inode->i_mode	= be16_to_cpu(di->di_mode);
 	li->li_height	= di->di_height;
 	li->li_flags	= be32_to_cpu(di->di_flags);
-	inode->i_uid	= be32_to_cpu(di->di_uid);
-	inode->i_gid	= be32_to_cpu(di->di_gid);
+	i_uid_write(inode, be32_to_cpu(di->di_uid));
+	i_gid_write(inode, be32_to_cpu(di->di_gid));
 	inode->i_size	= be64_to_cpu(di->di_size);
 	logfs_set_blocks(inode, be64_to_cpu(di->di_used_bytes));
 	inode->i_atime	= be64_to_timespec(di->di_atime);
@@ -156,8 +156,8 @@ static void logfs_inode_to_disk(struct inode *inode, struct logfs_disk_inode*di)
 	di->di_height	= li->li_height;
 	di->di_pad	= 0;
 	di->di_flags	= cpu_to_be32(li->li_flags);
-	di->di_uid	= cpu_to_be32(inode->i_uid);
-	di->di_gid	= cpu_to_be32(inode->i_gid);
+	di->di_uid	= cpu_to_be32(i_uid_read(inode));
+	di->di_gid	= cpu_to_be32(i_gid_read(inode));
 	di->di_size	= cpu_to_be64(i_size_read(inode));
 	di->di_used_bytes = cpu_to_be64(li->li_used_bytes);
 	di->di_atime	= timespec_to_be64(inode->i_atime);
diff --git a/init/Kconfig b/init/Kconfig
index 88f6571..80edba8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -946,7 +946,6 @@ config UIDGID_CONVERTED
 	depends on HPFS_FS = n
 	depends on JFFS2_FS = n
 	depends on JFS_FS = n
-	depends on LOGFS = n
 	depends on MINIX_FS = n
 	depends on NCP_FS = n
 	depends on NFSD = n
-- 
1.7.5.4

