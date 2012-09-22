Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab2IVBhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:37:18 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56159 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636Ab2IVBgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:36:04 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Jan Kara <jack@suse.cz>
Date: Fri, 21 Sep 2012 18:35:11 -0700
Message-Id: <1348277712-30055-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
References: <877grmj115.fsf@xmission.com>
 <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/HIrlYPzjIL47J5dI3vn3W63LhxXc3KL4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0792]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 
X-Spam-Combo: ****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 10/11] userns: Convert the udf filesystem to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Jan Kara <jack@suse.cz>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/udf/inode.c |   20 ++++++++++++--------
 init/Kconfig   |    1 -
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fafaad7..2e6fb4d 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1250,6 +1250,8 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	unsigned int link_count;
+	uid_t i_uid;
+	gid_t i_gid;
 
 	fe = (struct fileEntry *)bh->b_data;
 	efe = (struct extendedFileEntry *)bh->b_data;
@@ -1309,17 +1311,19 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	}
 
 	read_lock(&sbi->s_cred_lock);
-	inode->i_uid = le32_to_cpu(fe->uid);
-	if (inode->i_uid == -1 ||
+	i_uid = le32_to_cpu(fe->uid);
+	if (i_uid == -1 ||
 	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_UID_IGNORE) ||
 	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_UID_SET))
-		inode->i_uid = UDF_SB(inode->i_sb)->s_uid;
+		i_uid = UDF_SB(inode->i_sb)->s_uid;
+	i_uid_write(inode, i_uid);
 
-	inode->i_gid = le32_to_cpu(fe->gid);
-	if (inode->i_gid == -1 ||
+	i_gid = le32_to_cpu(fe->gid);
+	if (i_gid == -1 ||
 	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_GID_IGNORE) ||
 	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_GID_SET))
-		inode->i_gid = UDF_SB(inode->i_sb)->s_gid;
+		i_gid = UDF_SB(inode->i_sb)->s_gid;
+	i_gid_write(inode, i_gid);
 
 	if (fe->icbTag.fileType != ICBTAG_FILE_TYPE_DIRECTORY &&
 			sbi->s_fmode != UDF_INVALID_MODE)
@@ -1539,12 +1543,12 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_UID_FORGET))
 		fe->uid = cpu_to_le32(-1);
 	else
-		fe->uid = cpu_to_le32(inode->i_uid);
+		fe->uid = cpu_to_le32(i_uid_read(inode));
 
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_GID_FORGET))
 		fe->gid = cpu_to_le32(-1);
 	else
-		fe->gid = cpu_to_le32(inode->i_gid);
+		fe->gid = cpu_to_le32(i_gid_read(inode));
 
 	udfperms = ((inode->i_mode & S_IRWXO)) |
 		   ((inode->i_mode & S_IRWXG) << 2) |
diff --git a/init/Kconfig b/init/Kconfig
index 21adc1c..6f9819a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -939,7 +939,6 @@ config UIDGID_CONVERTED
 	depends on NFSD = n
 	depends on NFS_FS = n
 	depends on OCFS2_FS = n
-	depends on UDF_FS = n
 	depends on UFS_FS = n
 	depends on XFS_FS = n
 
-- 
1.7.5.4

