Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab2IUA3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:29:48 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:55554 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585Ab2IUA3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:29:42 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        John Johansen <john.johansen@canonical.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 20 Sep 2012 17:28:44 -0700
Message-Id: <1348187330-6616-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18FhhHtdC/uZQU95qs6JDk0lUfFSez8yxw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 08/14] userns: Teach security_path_chown to take kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Don't make the security modules deal with raw user space uid and
gids instead pass in a kuid_t and a kgid_t so that security modules
only have to deal with internal kernel uids and gids.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <james.l.morris@oracle.com>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/open.c                |    2 +-
 include/linux/security.h |    6 +++---
 security/apparmor/lsm.c  |    2 +-
 security/capability.c    |    2 +-
 security/security.c      |    2 +-
 security/tomoyo/tomoyo.c |   12 +++++++-----
 6 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index f3d96e7..2b25739 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -534,7 +534,7 @@ static int chown_common(struct path *path, uid_t user, gid_t group)
 		newattrs.ia_valid |=
 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	mutex_lock(&inode->i_mutex);
-	error = security_path_chown(path, user, group);
+	error = security_path_chown(path, uid, gid);
 	if (!error)
 		error = notify_change(path->dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
diff --git a/include/linux/security.h b/include/linux/security.h
index 4e5a73c..ebb92cb 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1437,7 +1437,7 @@ struct security_operations {
 	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
 			    struct path *new_dir, struct dentry *new_dentry);
 	int (*path_chmod) (struct path *path, umode_t mode);
-	int (*path_chown) (struct path *path, uid_t uid, gid_t gid);
+	int (*path_chown) (struct path *path, kuid_t uid, kgid_t gid);
 	int (*path_chroot) (struct path *path);
 #endif
 
@@ -2832,7 +2832,7 @@ int security_path_link(struct dentry *old_dentry, struct path *new_dir,
 int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
 			 struct path *new_dir, struct dentry *new_dentry);
 int security_path_chmod(struct path *path, umode_t mode);
-int security_path_chown(struct path *path, uid_t uid, gid_t gid);
+int security_path_chown(struct path *path, kuid_t uid, kgid_t gid);
 int security_path_chroot(struct path *path);
 #else	/* CONFIG_SECURITY_PATH */
 static inline int security_path_unlink(struct path *dir, struct dentry *dentry)
@@ -2888,7 +2888,7 @@ static inline int security_path_chmod(struct path *path, umode_t mode)
 	return 0;
 }
 
-static inline int security_path_chown(struct path *path, uid_t uid, gid_t gid)
+static inline int security_path_chown(struct path *path, kuid_t uid, kgid_t gid)
 {
 	return 0;
 }
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 8ea39aa..8c2a7f6 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -352,7 +352,7 @@ static int apparmor_path_chmod(struct path *path, umode_t mode)
 	return common_perm_mnt_dentry(OP_CHMOD, path->mnt, path->dentry, AA_MAY_CHMOD);
 }
 
-static int apparmor_path_chown(struct path *path, uid_t uid, gid_t gid)
+static int apparmor_path_chown(struct path *path, kuid_t uid, kgid_t gid)
 {
 	struct path_cond cond =  { path->dentry->d_inode->i_uid,
 				   path->dentry->d_inode->i_mode
diff --git a/security/capability.c b/security/capability.c
index 61095df..a40aac6 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -284,7 +284,7 @@ static int cap_path_chmod(struct path *path, umode_t mode)
 	return 0;
 }
 
-static int cap_path_chown(struct path *path, uid_t uid, gid_t gid)
+static int cap_path_chown(struct path *path, kuid_t uid, kgid_t gid)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 860aeb3..f9a2f2e 100644
--- a/security/security.c
+++ b/security/security.c
@@ -434,7 +434,7 @@ int security_path_chmod(struct path *path, umode_t mode)
 	return security_ops->path_chmod(path, mode);
 }
 
-int security_path_chown(struct path *path, uid_t uid, gid_t gid)
+int security_path_chown(struct path *path, kuid_t uid, kgid_t gid)
 {
 	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index c2d04a5..d88eb3a 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -373,13 +373,15 @@ static int tomoyo_path_chmod(struct path *path, umode_t mode)
  *
  * Returns 0 on success, negative value otherwise.
  */
-static int tomoyo_path_chown(struct path *path, uid_t uid, gid_t gid)
+static int tomoyo_path_chown(struct path *path, kuid_t uid, kgid_t gid)
 {
 	int error = 0;
-	if (uid != (uid_t) -1)
-		error = tomoyo_path_number_perm(TOMOYO_TYPE_CHOWN, path, uid);
-	if (!error && gid != (gid_t) -1)
-		error = tomoyo_path_number_perm(TOMOYO_TYPE_CHGRP, path, gid);
+	if (uid_valid(uid))
+		error = tomoyo_path_number_perm(TOMOYO_TYPE_CHOWN, path,
+						from_kuid(&init_user_ns, uid));
+	if (!error && gid_valid(gid))
+		error = tomoyo_path_number_perm(TOMOYO_TYPE_CHGRP, path,
+						from_kgid(&init_user_ns, gid));
 	return error;
 }
 
-- 
1.7.5.4

