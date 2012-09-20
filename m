Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2ITLnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:43:20 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51837 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab2ITLnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:43:17 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>
Date: Thu, 20 Sep 2012 04:41:51 -0700
Message-Id: <1348141326-23355-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/VZLp/L+APahzAOt1aUhrwG7Pq8cYJ1sQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0097]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 10/25] userns: Convert ecryptfs to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: Dustin Kirkland <dustin.kirkland@gazzang.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/ecryptfs/main.c      |    5 +++--
 fs/ecryptfs/messaging.c |    5 ++---
 init/Kconfig            |    1 -
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 2768138..1d6ce91 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -544,11 +544,12 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 		goto out_free;
 	}
 
-	if (check_ruid && path.dentry->d_inode->i_uid != current_uid()) {
+	if (check_ruid && !uid_eq(path.dentry->d_inode->i_uid, current_uid())) {
 		rc = -EPERM;
 		printk(KERN_ERR "Mount of device (uid: %d) not owned by "
 		       "requested user (uid: %d)\n",
-		       path.dentry->d_inode->i_uid, current_uid());
+			i_uid_read(path.dentry->d_inode),
+			from_kuid(&init_user_ns, current_uid()));
 		goto out_free;
 	}
 
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index b29bb8b..5fa2471 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -33,7 +33,7 @@ static struct hlist_head *ecryptfs_daemon_hash;
 struct mutex ecryptfs_daemon_hash_mux;
 static int ecryptfs_hash_bits;
 #define ecryptfs_current_euid_hash(uid) \
-		hash_long((unsigned long)current_euid(), ecryptfs_hash_bits)
+	hash_long((unsigned long)from_kuid(&init_user_ns, current_euid()), ecryptfs_hash_bits)
 
 static u32 ecryptfs_msg_counter;
 static struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
@@ -121,8 +121,7 @@ int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon)
 	hlist_for_each_entry(*daemon, elem,
 			    &ecryptfs_daemon_hash[ecryptfs_current_euid_hash()],
 			    euid_chain) {
-		if ((*daemon)->file->f_cred->euid == current_euid() &&
-		    (*daemon)->file->f_cred->user_ns == current_user_ns()) {
+		if (uid_eq((*daemon)->file->f_cred->euid, current_euid())) {
 			rc = 0;
 			goto out;
 		}
diff --git a/init/Kconfig b/init/Kconfig
index 5f846b5..6120bae 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -941,7 +941,6 @@ config UIDGID_CONVERTED
 	depends on CEPH_FS = n
 	depends on CIFS = n
 	depends on CODA_FS = n
-	depends on ECRYPT_FS = n
 	depends on EFS_FS = n
 	depends on EXOFS_FS = n
 	depends on FUSE_FS = n
-- 
1.7.5.4

