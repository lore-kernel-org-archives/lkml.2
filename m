Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2ITMW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:22:58 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54924 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2ITMLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:11:30 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Date: Thu, 20 Sep 2012 04:41:59 -0700
Message-Id: <1348141326-23355-18-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18zfSk+FTaoDQQchtx/Ps5UdpXO56teLss=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0037]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 18/25] userns: Convert nillfs2 to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/nilfs2/inode.c |    8 ++++----
 init/Kconfig      |    1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6e2c3db..4d31d2c 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -401,8 +401,8 @@ int nilfs_read_inode_common(struct inode *inode,
 	int err;
 
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
-	inode->i_uid = (uid_t)le32_to_cpu(raw_inode->i_uid);
-	inode->i_gid = (gid_t)le32_to_cpu(raw_inode->i_gid);
+	i_uid_write(inode, le32_to_cpu(raw_inode->i_uid));
+	i_gid_write(inode, le32_to_cpu(raw_inode->i_gid));
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 	inode->i_size = le64_to_cpu(raw_inode->i_size);
 	inode->i_atime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
@@ -590,8 +590,8 @@ void nilfs_write_inode_common(struct inode *inode,
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
-	raw_inode->i_uid = cpu_to_le32(inode->i_uid);
-	raw_inode->i_gid = cpu_to_le32(inode->i_gid);
+	raw_inode->i_uid = cpu_to_le32(i_uid_read(inode));
+	raw_inode->i_gid = cpu_to_le32(i_gid_read(inode));
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
 	raw_inode->i_size = cpu_to_le64(inode->i_size);
 	raw_inode->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
diff --git a/init/Kconfig b/init/Kconfig
index c69e085..90c9e06 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -949,7 +949,6 @@ config UIDGID_CONVERTED
 	depends on NCP_FS = n
 	depends on NFSD = n
 	depends on NFS_FS = n
-	depends on NILFS2_FS = n
 	depends on NTFS_FS = n
 	depends on OCFS2_FS = n
 	depends on OMFS_FS = n
-- 
1.7.5.4

