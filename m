Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab2IVBff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:35:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60612 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2IVBfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:35:32 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Chris Mason <chris.mason@fusionio.com>
Date: Fri, 21 Sep 2012 18:35:04 -0700
Message-Id: <1348277712-30055-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
References: <877grmj115.fsf@xmission.com>
 <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19fs8psMvlzVsYbo2I9TES98Nm5wlWUHTA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 03/11] userns: Convert btrfs to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Chris Mason <chris.mason@fusionio.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/btrfs/delayed-inode.c |    8 ++++----
 fs/btrfs/inode.c         |    8 ++++----
 fs/btrfs/ioctl.c         |    6 +++---
 init/Kconfig             |    1 -
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 335605c..f908c51 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1715,8 +1715,8 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 				  struct btrfs_inode_item *inode_item,
 				  struct inode *inode)
 {
-	btrfs_set_stack_inode_uid(inode_item, inode->i_uid);
-	btrfs_set_stack_inode_gid(inode_item, inode->i_gid);
+	btrfs_set_stack_inode_uid(inode_item, i_uid_read(inode));
+	btrfs_set_stack_inode_gid(inode_item, i_gid_read(inode));
 	btrfs_set_stack_inode_size(inode_item, BTRFS_I(inode)->disk_i_size);
 	btrfs_set_stack_inode_mode(inode_item, inode->i_mode);
 	btrfs_set_stack_inode_nlink(inode_item, inode->i_nlink);
@@ -1764,8 +1764,8 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 
 	inode_item = &delayed_node->inode_item;
 
-	inode->i_uid = btrfs_stack_inode_uid(inode_item);
-	inode->i_gid = btrfs_stack_inode_gid(inode_item);
+	i_uid_write(inode, btrfs_stack_inode_uid(inode_item));
+	i_gid_write(inode, btrfs_stack_inode_gid(inode_item));
 	btrfs_i_size_write(inode, btrfs_stack_inode_size(inode_item));
 	inode->i_mode = btrfs_stack_inode_mode(inode_item);
 	set_nlink(inode, btrfs_stack_inode_nlink(inode_item));
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 83baec2..5368714 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2570,8 +2570,8 @@ static void btrfs_read_locked_inode(struct inode *inode)
 				    struct btrfs_inode_item);
 	inode->i_mode = btrfs_inode_mode(leaf, inode_item);
 	set_nlink(inode, btrfs_inode_nlink(leaf, inode_item));
-	inode->i_uid = btrfs_inode_uid(leaf, inode_item);
-	inode->i_gid = btrfs_inode_gid(leaf, inode_item);
+	i_uid_write(inode, btrfs_inode_uid(leaf, inode_item));
+	i_gid_write(inode, btrfs_inode_gid(leaf, inode_item));
 	btrfs_i_size_write(inode, btrfs_inode_size(leaf, inode_item));
 
 	tspec = btrfs_inode_atime(inode_item);
@@ -2649,8 +2649,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode_item *item,
 			    struct inode *inode)
 {
-	btrfs_set_inode_uid(leaf, item, inode->i_uid);
-	btrfs_set_inode_gid(leaf, item, inode->i_gid);
+	btrfs_set_inode_uid(leaf, item, i_uid_read(inode));
+	btrfs_set_inode_gid(leaf, item, i_gid_read(inode));
 	btrfs_set_inode_size(leaf, item, BTRFS_I(inode)->disk_i_size);
 	btrfs_set_inode_mode(leaf, item, inode->i_mode);
 	btrfs_set_inode_nlink(leaf, item, inode->i_nlink);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bc2f6ff..1292682 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -575,13 +575,13 @@ fail:
 */
 static inline int btrfs_check_sticky(struct inode *dir, struct inode *inode)
 {
-	uid_t fsuid = current_fsuid();
+	kuid_t fsuid = current_fsuid();
 
 	if (!(dir->i_mode & S_ISVTX))
 		return 0;
-	if (inode->i_uid == fsuid)
+	if (uid_eq(inode->i_uid, fsuid))
 		return 0;
-	if (dir->i_uid == fsuid)
+	if (uid_eq(dir->i_uid, fsuid))
 		return 0;
 	return !capable(CAP_FOWNER);
 }
diff --git a/init/Kconfig b/init/Kconfig
index fd91d2b..44f580f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -930,7 +930,6 @@ config UIDGID_CONVERTED
 	depends on 9P_FS = n
 	depends on AFS_FS = n
 	depends on AUTOFS4_FS = n
-	depends on BTRFS_FS = n
 	depends on CEPH_FS = n
 	depends on CIFS = n
 	depends on CODA_FS = n
-- 
1.7.5.4

