Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2ITMND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:13:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41414 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2ITMLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:11:32 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>
Date: Thu, 20 Sep 2012 04:41:53 -0700
Message-Id: <1348141326-23355-12-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+2GuUXrlI6WwSjnEGMz+jiES560v8huu4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0019]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 12/25] userns: Convert exofs to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@tonian.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/exofs/inode.c |    8 ++++----
 init/Kconfig     |    1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 5badb0c..190c3d6 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1163,8 +1163,8 @@ struct inode *exofs_iget(struct super_block *sb, unsigned long ino)
 
 	/* copy stuff from on-disk struct to in-memory struct */
 	inode->i_mode = le16_to_cpu(fcb.i_mode);
-	inode->i_uid = le32_to_cpu(fcb.i_uid);
-	inode->i_gid = le32_to_cpu(fcb.i_gid);
+	i_uid_write(inode, le32_to_cpu(fcb.i_uid));
+	i_gid_write(inode, le32_to_cpu(fcb.i_gid));
 	set_nlink(inode, le16_to_cpu(fcb.i_links_count));
 	inode->i_ctime.tv_sec = (signed)le32_to_cpu(fcb.i_ctime);
 	inode->i_atime.tv_sec = (signed)le32_to_cpu(fcb.i_atime);
@@ -1376,8 +1376,8 @@ static int exofs_update_inode(struct inode *inode, int do_sync)
 	fcb = &args->fcb;
 
 	fcb->i_mode = cpu_to_le16(inode->i_mode);
-	fcb->i_uid = cpu_to_le32(inode->i_uid);
-	fcb->i_gid = cpu_to_le32(inode->i_gid);
+	fcb->i_uid = cpu_to_le32(i_uid_read(inode));
+	fcb->i_gid = cpu_to_le32(i_gid_read(inode));
 	fcb->i_links_count = cpu_to_le16(inode->i_nlink);
 	fcb->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
 	fcb->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
diff --git a/init/Kconfig b/init/Kconfig
index 51084b0..39e55d6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -941,7 +941,6 @@ config UIDGID_CONVERTED
 	depends on CEPH_FS = n
 	depends on CIFS = n
 	depends on CODA_FS = n
-	depends on EXOFS_FS = n
 	depends on FUSE_FS = n
 	depends on GFS2_FS = n
 	depends on HFS_FS = n
-- 
1.7.5.4

