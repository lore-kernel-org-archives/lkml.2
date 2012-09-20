Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2ITLmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:42:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51890 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab2ITLmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:42:49 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        William Irwin <wli@holomorphy.com>
Date: Thu, 20 Sep 2012 04:41:46 -0700
Message-Id: <1348141326-23355-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/6PtTlHQsY1P8SATAfzQWlL4GCT82HEqc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.0 XMBody_17 BODY: Spammy words in all caps
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0011]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 05/25] userns: Convert hugetlbfs to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Note sysctl_hugetlb_shm_group can only be written in the root user
in the initial user namespace, so we can assume sysctl_hugetlb_shm_group
is in the initial user namespace.

Cc: William Irwin <wli@holomorphy.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/hugetlbfs/inode.c |   16 +++++++++++-----
 init/Kconfig         |    1 -
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 8349a89..6e572c4 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -42,8 +42,8 @@ static const struct inode_operations hugetlbfs_dir_inode_operations;
 static const struct inode_operations hugetlbfs_inode_operations;
 
 struct hugetlbfs_config {
-	uid_t   uid;
-	gid_t   gid;
+	kuid_t   uid;
+	kgid_t   gid;
 	umode_t mode;
 	long	nr_blocks;
 	long	nr_inodes;
@@ -785,13 +785,17 @@ hugetlbfs_parse_options(char *options, struct hugetlbfs_config *pconfig)
 		case Opt_uid:
 			if (match_int(&args[0], &option))
  				goto bad_val;
-			pconfig->uid = option;
+			pconfig->uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(pconfig->uid))
+				goto bad_val;
 			break;
 
 		case Opt_gid:
 			if (match_int(&args[0], &option))
  				goto bad_val;
-			pconfig->gid = option;
+			pconfig->gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(pconfig->gid))
+				goto bad_val;
 			break;
 
 		case Opt_mode:
@@ -924,7 +928,9 @@ static struct vfsmount *hugetlbfs_vfsmount;
 
 static int can_do_hugetlb_shm(void)
 {
-	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
+	kgid_t shm_group;
+	shm_group = make_kgid(&init_user_ns, sysctl_hugetlb_shm_group);
+	return capable(CAP_IPC_LOCK) || in_group_p(shm_group);
 }
 
 struct file *hugetlb_file_setup(const char *name, unsigned long addr,
diff --git a/init/Kconfig b/init/Kconfig
index 96007af..7ee6e19 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -954,7 +954,6 @@ config UIDGID_CONVERTED
 	depends on HFS_FS = n
 	depends on HFSPLUS_FS = n
 	depends on HPFS_FS = n
-	depends on HUGETLBFS = n
 	depends on ISO9660_FS = n
 	depends on JFFS2_FS = n
 	depends on JFS_FS = n
-- 
1.7.5.4

