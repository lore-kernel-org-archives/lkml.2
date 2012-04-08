Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab2DHFNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:13:32 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51577 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2DHFMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:31 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:37 -0700
Message-Id: <1333862139-31737-41-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19cMgH4NUNfhm1IPicuclrJSwhe7E7Ey+g=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 41/43] userns: Convert tmpfs to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/shmem_fs.h |    4 ++--
 mm/shmem.c               |   22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 79ab255..bef2cf0 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -28,8 +28,8 @@ struct shmem_sb_info {
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_inodes;  /* How many are left for allocation */
 	spinlock_t stat_lock;	    /* Serialize shmem_sb_info changes */
-	uid_t uid;		    /* Mount uid for root directory */
-	gid_t gid;		    /* Mount gid for root directory */
+	kuid_t uid;		    /* Mount uid for root directory */
+	kgid_t gid;		    /* Mount gid for root directory */
 	umode_t mode;		    /* Mount mode for root directory */
 	struct mempolicy *mpol;     /* default memory policy for mappings */
 };
diff --git a/mm/shmem.c b/mm/shmem.c
index f99ff3e..d7b433a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2075,6 +2075,8 @@ static int shmem_parse_options(char *options, struct shmem_sb_info *sbinfo,
 			       bool remount)
 {
 	char *this_char, *value, *rest;
+	uid_t uid;
+	gid_t gid;
 
 	while (options != NULL) {
 		this_char = options;
@@ -2134,15 +2136,21 @@ static int shmem_parse_options(char *options, struct shmem_sb_info *sbinfo,
 		} else if (!strcmp(this_char,"uid")) {
 			if (remount)
 				continue;
-			sbinfo->uid = simple_strtoul(value, &rest, 0);
+			uid = simple_strtoul(value, &rest, 0);
 			if (*rest)
 				goto bad_val;
+			sbinfo->uid = make_kuid(current_user_ns(), uid);
+			if (!uid_valid(sbinfo->uid))
+				goto bad_val;
 		} else if (!strcmp(this_char,"gid")) {
 			if (remount)
 				continue;
-			sbinfo->gid = simple_strtoul(value, &rest, 0);
+			gid = simple_strtoul(value, &rest, 0);
 			if (*rest)
 				goto bad_val;
+			sbinfo->gid = make_kgid(current_user_ns(), gid);
+			if (!gid_valid(sbinfo->gid))
+				goto bad_val;
 		} else if (!strcmp(this_char,"mpol")) {
 			if (mpol_parse_str(value, &sbinfo->mpol, 1))
 				goto bad_val;
@@ -2210,10 +2218,12 @@ static int shmem_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",nr_inodes=%lu", sbinfo->max_inodes);
 	if (sbinfo->mode != (S_IRWXUGO | S_ISVTX))
 		seq_printf(seq, ",mode=%03ho", sbinfo->mode);
-	if (sbinfo->uid != 0)
-		seq_printf(seq, ",uid=%u", sbinfo->uid);
-	if (sbinfo->gid != 0)
-		seq_printf(seq, ",gid=%u", sbinfo->gid);
+	if (!uid_eq(sbinfo->uid, GLOBAL_ROOT_UID))
+		seq_printf(seq, ",uid=%u",
+				from_kuid_munged(&init_user_ns, sbinfo->uid));
+	if (!gid_eq(sbinfo->gid, GLOBAL_ROOT_GID))
+		seq_printf(seq, ",gid=%u",
+				from_kgid_munged(&init_user_ns, sbinfo->gid));
 	shmem_show_mpol(seq, sbinfo->mpol);
 	return 0;
 }
-- 
1.7.2.5

