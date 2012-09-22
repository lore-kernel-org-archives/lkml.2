Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab2IVBf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:35:29 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56099 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab2IVBf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:35:26 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Date: Fri, 21 Sep 2012 18:35:03 -0700
Message-Id: <1348277712-30055-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
References: <877grmj115.fsf@xmission.com>
 <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18ZgyaMwyFJsoCiqiWCxtt+uN8ZbWVte2s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 02/11] userns: Convert bfs to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/bfs/inode.c |    8 ++++----
 init/Kconfig   |    1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 9870417..b242beb 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -76,8 +76,8 @@ struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 	BFS_I(inode)->i_sblock =  le32_to_cpu(di->i_sblock);
 	BFS_I(inode)->i_eblock =  le32_to_cpu(di->i_eblock);
 	BFS_I(inode)->i_dsk_ino = le16_to_cpu(di->i_ino);
-	inode->i_uid =  le32_to_cpu(di->i_uid);
-	inode->i_gid =  le32_to_cpu(di->i_gid);
+	i_uid_write(inode, le32_to_cpu(di->i_uid));
+	i_gid_write(inode,  le32_to_cpu(di->i_gid));
 	set_nlink(inode, le32_to_cpu(di->i_nlink));
 	inode->i_size = BFS_FILESIZE(di);
 	inode->i_blocks = BFS_FILEBLOCKS(di);
@@ -139,8 +139,8 @@ static int bfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	di->i_ino = cpu_to_le16(ino);
 	di->i_mode = cpu_to_le32(inode->i_mode);
-	di->i_uid = cpu_to_le32(inode->i_uid);
-	di->i_gid = cpu_to_le32(inode->i_gid);
+	di->i_uid = cpu_to_le32(i_uid_read(inode));
+	di->i_gid = cpu_to_le32(i_gid_read(inode));
 	di->i_nlink = cpu_to_le32(inode->i_nlink);
 	di->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
 	di->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
diff --git a/init/Kconfig b/init/Kconfig
index a358f4a..fd91d2b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -930,7 +930,6 @@ config UIDGID_CONVERTED
 	depends on 9P_FS = n
 	depends on AFS_FS = n
 	depends on AUTOFS4_FS = n
-	depends on BFS_FS = n
 	depends on BTRFS_FS = n
 	depends on CEPH_FS = n
 	depends on CIFS = n
-- 
1.7.5.4

