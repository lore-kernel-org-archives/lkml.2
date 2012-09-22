Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222Ab2IVBgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:36:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60683 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476Ab2IVBf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:35:59 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Date: Fri, 21 Sep 2012 18:35:10 -0700
Message-Id: <1348277712-30055-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
References: <877grmj115.fsf@xmission.com>
 <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19JHFHgR6jNulJA53fOZGM+vdI1YdgUnQg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0039]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 09/11] userns: Convert ubifs to use kuid/kgid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/ubifs/budget.c  |    4 ++--
 fs/ubifs/debug.c   |    4 ++--
 fs/ubifs/journal.c |    4 ++--
 fs/ubifs/sb.c      |    4 ++--
 fs/ubifs/super.c   |    4 ++--
 fs/ubifs/ubifs.h   |    4 ++--
 init/Kconfig       |    1 -
 7 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index bc4f94b..969489e 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -272,8 +272,8 @@ long long ubifs_calc_available(const struct ubifs_info *c, int min_idx_lebs)
  */
 static int can_use_rp(struct ubifs_info *c)
 {
-	if (current_fsuid() == c->rp_uid || capable(CAP_SYS_RESOURCE) ||
-	    (c->rp_gid != 0 && in_group_p(c->rp_gid)))
+	if (uid_eq(current_fsuid(), c->rp_uid) || capable(CAP_SYS_RESOURCE) ||
+	    (!gid_eq(c->rp_gid, GLOBAL_ROOT_GID) && in_group_p(c->rp_gid)))
 		return 1;
 	return 0;
 }
diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index bb31672..340d1af 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -243,8 +243,8 @@ void ubifs_dump_inode(struct ubifs_info *c, const struct inode *inode)
 	printk(KERN_ERR "\tsize           %llu\n",
 	       (unsigned long long)i_size_read(inode));
 	printk(KERN_ERR "\tnlink          %u\n", inode->i_nlink);
-	printk(KERN_ERR "\tuid            %u\n", (unsigned int)inode->i_uid);
-	printk(KERN_ERR "\tgid            %u\n", (unsigned int)inode->i_gid);
+	printk(KERN_ERR "\tuid            %u\n", (unsigned int)i_uid_read(inode));
+	printk(KERN_ERR "\tgid            %u\n", (unsigned int)i_gid_read(inode));
 	printk(KERN_ERR "\tatime          %u.%u\n",
 	       (unsigned int)inode->i_atime.tv_sec,
 	       (unsigned int)inode->i_atime.tv_nsec);
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 12c0f15..afaad07 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -469,8 +469,8 @@ static void pack_inode(struct ubifs_info *c, struct ubifs_ino_node *ino,
 	ino->ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
 	ino->mtime_sec  = cpu_to_le64(inode->i_mtime.tv_sec);
 	ino->mtime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
-	ino->uid   = cpu_to_le32(inode->i_uid);
-	ino->gid   = cpu_to_le32(inode->i_gid);
+	ino->uid   = cpu_to_le32(i_uid_read(inode));
+	ino->gid   = cpu_to_le32(i_gid_read(inode));
 	ino->mode  = cpu_to_le32(inode->i_mode);
 	ino->flags = cpu_to_le32(ui->flags);
 	ino->size  = cpu_to_le64(ui->ui_size);
diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index 15e2fc5..52c21f4 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -611,8 +611,8 @@ int ubifs_read_superblock(struct ubifs_info *c)
 	c->fanout        = le32_to_cpu(sup->fanout);
 	c->lsave_cnt     = le32_to_cpu(sup->lsave_cnt);
 	c->rp_size       = le64_to_cpu(sup->rp_size);
-	c->rp_uid        = le32_to_cpu(sup->rp_uid);
-	c->rp_gid        = le32_to_cpu(sup->rp_gid);
+	c->rp_uid        = make_kuid(&init_user_ns, le32_to_cpu(sup->rp_uid));
+	c->rp_gid        = make_kgid(&init_user_ns, le32_to_cpu(sup->rp_gid));
 	sup_flags        = le32_to_cpu(sup->flags);
 	if (!c->mount_opts.override_compr)
 		c->default_compr = le16_to_cpu(sup->default_compr);
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 1c766c3..f39bad9 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -130,8 +130,8 @@ struct inode *ubifs_iget(struct super_block *sb, unsigned long inum)
 
 	inode->i_flags |= (S_NOCMTIME | S_NOATIME);
 	set_nlink(inode, le32_to_cpu(ino->nlink));
-	inode->i_uid   = le32_to_cpu(ino->uid);
-	inode->i_gid   = le32_to_cpu(ino->gid);
+	i_uid_write(inode, le32_to_cpu(ino->uid));
+	i_gid_write(inode, le32_to_cpu(ino->gid));
 	inode->i_atime.tv_sec  = (int64_t)le64_to_cpu(ino->atime_sec);
 	inode->i_atime.tv_nsec = le32_to_cpu(ino->atime_nsec);
 	inode->i_mtime.tv_sec  = (int64_t)le64_to_cpu(ino->mtime_sec);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 1e5a086..64f2367 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1426,8 +1426,8 @@ struct ubifs_info {
 
 	long long rp_size;
 	long long report_rp_size;
-	uid_t rp_uid;
-	gid_t rp_gid;
+	kuid_t rp_uid;
+	kgid_t rp_gid;
 
 	/* The below fields are used only during mounting and re-mounting */
 	unsigned int empty:1;
diff --git a/init/Kconfig b/init/Kconfig
index d88f945..21adc1c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -939,7 +939,6 @@ config UIDGID_CONVERTED
 	depends on NFSD = n
 	depends on NFS_FS = n
 	depends on OCFS2_FS = n
-	depends on UBIFS_FS = n
 	depends on UDF_FS = n
 	depends on UFS_FS = n
 	depends on XFS_FS = n
-- 
1.7.5.4

