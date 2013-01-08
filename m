Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3AHCOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:14:21 -0500
Received: from nm22-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.178]:22656
	"EHLO nm22-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449Ab3AHCJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:24 -0500
X-Yahoo-Newman-Id: 482709.31829.bm@smtp107.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aVCoLsAVM1m83vxqZJFeZHifjp11fnfNVcxTNYw4msQSYtj
 eO6yCoHW5hY32RSEVzM6JCtPBI3._AdeftqVbdUlhLW67OLRjaLVypOz6HJ7
 t7bnTkjxWdIqMd893WiQPaSUUhq_OcMgvy_lmOlq8K6N014ftchTmlEknZrm
 0IaM77nviXorUEG8QzdDbaBo8tW07oX8sJ0iR.wXAWJosEj74Ey0hAoDsd0R
 wByO1x_MrtLpFTGzU5vfW4iXvP6P4GMw6CJVUHB_LYsH72CCUzyk1shCjPlQ
 9kMSIjBfJauRKJKrWDJs2q5D7DxidL1eurwrDmPaeVkFXCwtY7GPQDBPKxqD
 PjH5zeH2U79scV3kIiWqH.MdQUpDwo.Cz2_PKemyocLcoPZjvpX022IFJ2gw
 rxGskcuDA3nvb0jiX9f8CbIOwmlMLyRuqMywmKovNPw9L58UJSEzHDQ2BfFp
 d6q8u
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EB7FE0.9000404@schaufler-ca.com>
Date: Mon, 07 Jan 2013 18:09:36 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v12 7/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com>
In-Reply-To: <50EB7C50.3070605@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v12 7/9] LSM: Multiple concurrent LSMs

Change the infrastructure for Linux Security Modules (LSM)s
from a single vector of hook handlers to a list based method
for handling multiple concurrent modules. 

Abstract access to security blobs.
Remove commoncap calls.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 security/smack/smack.h        |   14 +-
 security/smack/smack_access.c |    2 +-
 security/smack/smack_lsm.c    |  367 ++++++++++++++++++-----------------------
 security/smack/smackfs.c      |   16 +-
 4 files changed, 183 insertions(+), 216 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 99b3612..c012d94 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -20,6 +20,7 @@
 #include <net/netlabel.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
+#include <linux/lsm.h>
 #include <linux/lsm_audit.h>
 
 /*
@@ -203,6 +204,7 @@ struct smk_audit_info {
  * These functions are in smack_lsm.c
  */
 struct inode_smack *new_inode_smack(char *);
+int smk_setcurrent(char *, size_t);
 
 /*
  * These functions are in smack_access.c
@@ -243,18 +245,18 @@ extern struct security_operations smack_ops;
 /*
  * Is the directory transmuting?
  */
-static inline int smk_inode_transmutable(const struct inode *isp)
+static inline int smk_inode_transmutable(struct inode *isp)
 {
-	struct inode_smack *sip = isp->i_security;
+	struct inode_smack *sip = lsm_get_inode(isp, &smack_ops);
 	return (sip->smk_flags & SMK_INODE_TRANSMUTE) != 0;
 }
 
 /*
  * Present a pointer to the smack label in an inode blob.
  */
-static inline char *smk_of_inode(const struct inode *isp)
+static inline char *smk_of_inode(struct inode *isp)
 {
-	struct inode_smack *sip = isp->i_security;
+	struct inode_smack *sip = lsm_get_inode(isp, &smack_ops);
 	return sip->smk_inode;
 }
 
@@ -279,7 +281,9 @@ static inline char *smk_of_forked(const struct task_smack *tsp)
  */
 static inline char *smk_of_current(void)
 {
-	return smk_of_task(current_security());
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
+
+	return tsp->smk_task;
 }
 
 /*
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index db14689..b4b4044 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -197,7 +197,7 @@ out_audit:
  */
 int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 	char *sp = smk_of_task(tsp);
 	int may;
 	int rc;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 38be92c..e625cbe 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -40,7 +40,16 @@
 #include <linux/binfmts.h>
 #include "smack.h"
 
-#define task_security(task)	(task_cred_xxx((task), security))
+static void *task_security(struct task_struct *task)
+{
+	const struct cred *cred;
+
+	rcu_read_lock();
+	cred = __task_cred(task);
+	rcu_read_unlock();
+
+	return lsm_get_cred(cred, &smack_ops);
+}
 
 #define TRANS_TRUE	"TRUE"
 #define TRANS_TRUE_SIZE	4
@@ -162,20 +171,14 @@ static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
  */
 static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 {
-	int rc;
 	struct smk_audit_info ad;
 	char *tsp;
 
-	rc = cap_ptrace_access_check(ctp, mode);
-	if (rc != 0)
-		return rc;
-
 	tsp = smk_of_task(task_security(ctp));
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ctp);
 
-	rc = smk_curacc(tsp, MAY_READWRITE, &ad);
-	return rc;
+	return smk_curacc(tsp, MAY_READWRITE, &ad);
 }
 
 /**
@@ -188,20 +191,14 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
  */
 static int smack_ptrace_traceme(struct task_struct *ptp)
 {
-	int rc;
 	struct smk_audit_info ad;
 	char *tsp;
 
-	rc = cap_ptrace_traceme(ptp);
-	if (rc != 0)
-		return rc;
-
 	tsp = smk_of_task(task_security(ptp));
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ptp);
 
-	rc = smk_curacc(tsp, MAY_READWRITE, &ad);
-	return rc;
+	return smk_curacc(tsp, MAY_READWRITE, &ad);
 }
 
 /**
@@ -252,7 +249,7 @@ static int smack_sb_alloc_security(struct super_block *sb)
 	sbsp->smk_hat = smack_known_hat.smk_known;
 	sbsp->smk_initialized = 0;
 
-	sb->s_security = sbsp;
+	lsm_set_super(sb, sbsp, &smack_ops);
 
 	return 0;
 }
@@ -264,8 +261,10 @@ static int smack_sb_alloc_security(struct super_block *sb)
  */
 static void smack_sb_free_security(struct super_block *sb)
 {
-	kfree(sb->s_security);
-	sb->s_security = NULL;
+	struct superblock_smack *sbsp = lsm_get_super(sb, &smack_ops);
+
+	kfree(sbsp);
+	lsm_set_super(sb, NULL, &smack_ops);
 }
 
 /**
@@ -325,7 +324,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 {
 	struct dentry *root = sb->s_root;
 	struct inode *inode = root->d_inode;
-	struct superblock_smack *sp = sb->s_security;
+	struct superblock_smack *sp = lsm_get_super(sb, &smack_ops);
 	struct inode_smack *isp;
 	char *op;
 	char *commap;
@@ -368,9 +367,9 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 	/*
 	 * Initialize the root inode.
 	 */
-	isp = inode->i_security;
+	isp = lsm_get_inode(inode, &smack_ops);
 	if (isp == NULL)
-		inode->i_security = new_inode_smack(sp->smk_root);
+		lsm_set_inode(inode, new_inode_smack(sp->smk_root), &smack_ops);
 	else
 		isp->smk_inode = sp->smk_root;
 
@@ -386,7 +385,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
  */
 static int smack_sb_statfs(struct dentry *dentry)
 {
-	struct superblock_smack *sbp = dentry->d_sb->s_security;
+	struct superblock_smack *sbp = lsm_get_super(dentry->d_sb, &smack_ops);
 	int rc;
 	struct smk_audit_info ad;
 
@@ -411,12 +410,13 @@ static int smack_sb_statfs(struct dentry *dentry)
 static int smack_sb_mount(const char *dev_name, struct path *path,
 			  const char *type, unsigned long flags, void *data)
 {
-	struct superblock_smack *sbp = path->dentry->d_sb->s_security;
+	struct superblock_smack *sbp;
 	struct smk_audit_info ad;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, *path);
 
+	sbp = lsm_get_super(path->dentry->d_sb, &smack_ops);
 	return smk_curacc(sbp->smk_floor, MAY_WRITE, &ad);
 }
 
@@ -440,7 +440,7 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, path);
 
-	sbp = path.dentry->d_sb->s_security;
+	sbp = lsm_get_super(path.dentry->d_sb, &smack_ops);
 	return smk_curacc(sbp->smk_floor, MAY_WRITE, &ad);
 }
 
@@ -457,18 +457,13 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
 static int smack_bprm_set_creds(struct linux_binprm *bprm)
 {
 	struct inode *inode = bprm->file->f_path.dentry->d_inode;
-	struct task_smack *bsp = bprm->cred->security;
+	struct task_smack *bsp = lsm_get_cred(bprm->cred, &smack_ops);
 	struct inode_smack *isp;
-	int rc;
-
-	rc = cap_bprm_set_creds(bprm);
-	if (rc != 0)
-		return rc;
 
 	if (bprm->cred_prepared)
 		return 0;
 
-	isp = inode->i_security;
+	isp = lsm_get_inode(inode, &smack_ops);
 	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
 		return 0;
 
@@ -489,7 +484,7 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
  */
 static void smack_bprm_committing_creds(struct linux_binprm *bprm)
 {
-	struct task_smack *bsp = bprm->cred->security;
+	struct task_smack *bsp = lsm_get_cred(bprm->cred, &smack_ops);
 
 	if (bsp->smk_task != bsp->smk_forked)
 		current->pdeath_signal = 0;
@@ -503,13 +498,9 @@ static void smack_bprm_committing_creds(struct linux_binprm *bprm)
  */
 static int smack_bprm_secureexec(struct linux_binprm *bprm)
 {
-	struct task_smack *tsp = current_security();
-	int ret = cap_bprm_secureexec(bprm);
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
-	if (!ret && (tsp->smk_task != tsp->smk_forked))
-		ret = 1;
-
-	return ret;
+	return (tsp->smk_task != tsp->smk_forked);
 }
 
 /*
@@ -524,9 +515,12 @@ static int smack_bprm_secureexec(struct linux_binprm *bprm)
  */
 static int smack_inode_alloc_security(struct inode *inode)
 {
-	inode->i_security = new_inode_smack(smk_of_current());
-	if (inode->i_security == NULL)
+	struct inode_smack *isp = new_inode_smack(smk_of_current());
+
+	if (isp == NULL)
 		return -ENOMEM;
+
+	lsm_set_inode(inode, isp, &smack_ops);
 	return 0;
 }
 
@@ -538,8 +532,8 @@ static int smack_inode_alloc_security(struct inode *inode)
  */
 static void smack_inode_free_security(struct inode *inode)
 {
-	kfree(inode->i_security);
-	inode->i_security = NULL;
+	kfree(lsm_get_inode(inode, &smack_ops));
+	lsm_set_inode(inode, NULL, &smack_ops);
 }
 
 /**
@@ -558,7 +552,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 				     void **value, size_t *len)
 {
 	struct smack_known *skp;
-	struct inode_smack *issp = inode->i_security;
+	struct inode_smack *issp = lsm_get_inode(inode, &smack_ops);
 	char *csp = smk_of_current();
 	char *isp = smk_of_inode(inode);
 	char *dsp = smk_of_inode(dir);
@@ -863,7 +857,7 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 				      const void *value, size_t size, int flags)
 {
 	char *nsp;
-	struct inode_smack *isp = dentry->d_inode->i_security;
+	struct inode_smack *isp = lsm_get_inode(dentry->d_inode, &smack_ops);
 
 	if (strcmp(name, XATTR_NAME_SMACK) == 0) {
 		nsp = smk_import(value, size);
@@ -938,7 +932,7 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE, &ad);
 
 	if (rc == 0) {
-		isp = dentry->d_inode->i_security;
+		isp = lsm_get_inode(dentry->d_inode, &smack_ops);
 		isp->smk_task = NULL;
 		isp->smk_mmap = NULL;
 	}
@@ -955,9 +949,8 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
  *
  * Returns the size of the attribute or an error code
  */
-static int smack_inode_getsecurity(const struct inode *inode,
-				   const char *name, void **buffer,
-				   bool alloc)
+static int smack_inode_getsecurity(const struct inode *inode, const char *name,
+					void **buffer, bool alloc)
 {
 	struct socket_smack *ssp;
 	struct socket *sock;
@@ -968,7 +961,7 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	int rc = 0;
 
 	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
-		isp = smk_of_inode(inode);
+		isp = smk_of_inode(ip);
 		ilen = strlen(isp) + 1;
 		*buffer = isp;
 		return ilen;
@@ -985,7 +978,7 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	if (sock == NULL || sock->sk == NULL)
 		return -EOPNOTSUPP;
 
-	ssp = sock->sk->sk_security;
+	ssp = lsm_get_sock(sock->sk, &smack_ops);
 
 	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
 		isp = ssp->smk_in;
@@ -1015,13 +1008,11 @@ static int smack_inode_getsecurity(const struct inode *inode,
 static int smack_inode_listsecurity(struct inode *inode, char *buffer,
 				    size_t buffer_size)
 {
-	int len = strlen(XATTR_NAME_SMACK);
+	const int len = sizeof(XATTR_NAME_SMACK);
 
-	if (buffer != NULL && len <= buffer_size) {
+	if (buffer != NULL && len <= buffer_size)
 		memcpy(buffer, XATTR_NAME_SMACK, len);
-		return len;
-	}
-	return -EINVAL;
+	return len;
 }
 
 /**
@@ -1031,7 +1022,7 @@ static int smack_inode_listsecurity(struct inode *inode, char *buffer,
  */
 static void smack_inode_getsecid(const struct inode *inode, u32 *secid)
 {
-	struct inode_smack *isp = inode->i_security;
+	struct inode_smack *isp = lsm_get_inode(inode, &smack_ops);
 
 	*secid = smack_to_secid(isp->smk_inode);
 }
@@ -1070,7 +1061,7 @@ static int smack_file_permission(struct file *file, int mask)
  */
 static int smack_file_alloc_security(struct file *file)
 {
-	file->f_security = smk_of_current();
+	lsm_set_file(file, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -1083,7 +1074,7 @@ static int smack_file_alloc_security(struct file *file)
  */
 static void smack_file_free_security(struct file *file)
 {
-	file->f_security = NULL;
+	lsm_set_file(file, NULL, &smack_ops);
 }
 
 /**
@@ -1101,15 +1092,16 @@ static int smack_file_ioctl(struct file *file, unsigned int cmd,
 {
 	int rc = 0;
 	struct smk_audit_info ad;
+	char *fsp = lsm_get_file(file, &smack_ops);
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, file->f_path);
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
-		rc = smk_curacc(file->f_security, MAY_WRITE, &ad);
+		rc = smk_curacc(fsp, MAY_WRITE, &ad);
 
 	if (rc == 0 && (_IOC_DIR(cmd) & _IOC_READ))
-		rc = smk_curacc(file->f_security, MAY_READ, &ad);
+		rc = smk_curacc(fsp, MAY_READ, &ad);
 
 	return rc;
 }
@@ -1127,7 +1119,7 @@ static int smack_file_lock(struct file *file, unsigned int cmd)
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, file->f_path);
-	return smk_curacc(file->f_security, MAY_WRITE, &ad);
+	return smk_curacc(lsm_get_file(file, &smack_ops), MAY_WRITE, &ad);
 }
 
 /**
@@ -1157,7 +1149,7 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
 	case F_SETSIG:
 		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 		smk_ad_setfield_u_fs_path(&ad, file->f_path);
-		rc = smk_curacc(file->f_security, MAY_WRITE, &ad);
+		rc = smk_curacc(lsm_get_file(file, &smack_ops), MAY_WRITE, &ad);
 		break;
 	default:
 		break;
@@ -1201,12 +1193,12 @@ static int smack_mmap_file(struct file *file,
 	if (dp->d_inode == NULL)
 		return 0;
 
-	isp = dp->d_inode->i_security;
+	isp = lsm_get_inode(dp->d_inode, &smack_ops);
 	if (isp->smk_mmap == NULL)
 		return 0;
 	msmack = isp->smk_mmap;
 
-	tsp = current_security();
+	tsp = lsm_get_cred(current_cred(), &smack_ops);
 	sp = smk_of_current();
 	skp = smk_find_entry(sp);
 	rc = 0;
@@ -1285,7 +1277,7 @@ static int smack_mmap_file(struct file *file,
  */
 static int smack_file_set_fowner(struct file *file)
 {
-	file->f_security = smk_of_current();
+	lsm_set_file(file, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -1305,22 +1297,24 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 {
 	struct file *file;
 	int rc;
-	char *tsp = smk_of_task(tsk->cred->security);
+	char *tsp = smk_of_task(lsm_get_cred(tsk->cred, &smack_ops));
+	char *fsp;
 	struct smk_audit_info ad;
 
 	/*
 	 * struct fown_struct is never outside the context of a struct file
 	 */
 	file = container_of(fown, struct file, f_owner);
+	fsp = lsm_get_file(file, &smack_ops);
 
 	/* we don't log here as rc can be overriden */
-	rc = smk_access(file->f_security, tsp, MAY_WRITE, NULL);
+	rc = smk_access(fsp, tsp, MAY_WRITE, NULL);
 	if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
 		rc = 0;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, tsk);
-	smack_log(file->f_security, tsp, MAY_WRITE, rc, &ad);
+	smack_log(fsp, tsp, MAY_WRITE, rc, &ad);
 	return rc;
 }
 
@@ -1345,7 +1339,7 @@ static int smack_file_receive(struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		may |= MAY_WRITE;
 
-	return smk_curacc(file->f_security, may, &ad);
+	return smk_curacc(lsm_get_file(file, &smack_ops), may, &ad);
 }
 
 /**
@@ -1359,9 +1353,10 @@ static int smack_file_receive(struct file *file)
  */
 static int smack_file_open(struct file *file, const struct cred *cred)
 {
-	struct inode_smack *isp = file->f_path.dentry->d_inode->i_security;
+	struct inode_smack *isp;
 
-	file->f_security = isp->smk_inode;
+	isp = lsm_get_inode(file->f_path.dentry->d_inode, &smack_ops);
+	lsm_set_file(file, isp->smk_inode, &smack_ops);
 
 	return 0;
 }
@@ -1387,7 +1382,7 @@ static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 	if (tsp == NULL)
 		return -ENOMEM;
 
-	cred->security = tsp;
+	lsm_set_cred(cred, tsp, &smack_ops);
 
 	return 0;
 }
@@ -1400,14 +1395,14 @@ static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
  */
 static void smack_cred_free(struct cred *cred)
 {
-	struct task_smack *tsp = cred->security;
+	struct task_smack *tsp = lsm_get_cred(cred, &smack_ops);
 	struct smack_rule *rp;
 	struct list_head *l;
 	struct list_head *n;
 
 	if (tsp == NULL)
 		return;
-	cred->security = NULL;
+	lsm_set_cred(cred, NULL, &smack_ops);
 
 	list_for_each_safe(l, n, &tsp->smk_rules) {
 		rp = list_entry(l, struct smack_rule, list);
@@ -1428,7 +1423,7 @@ static void smack_cred_free(struct cred *cred)
 static int smack_cred_prepare(struct cred *new, const struct cred *old,
 			      gfp_t gfp)
 {
-	struct task_smack *old_tsp = old->security;
+	struct task_smack *old_tsp = lsm_get_cred(old, &smack_ops);
 	struct task_smack *new_tsp;
 	int rc;
 
@@ -1440,7 +1435,7 @@ static int smack_cred_prepare(struct cred *new, const struct cred *old,
 	if (rc != 0)
 		return rc;
 
-	new->security = new_tsp;
+	lsm_set_cred(new, new_tsp, &smack_ops);
 	return 0;
 }
 
@@ -1453,8 +1448,8 @@ static int smack_cred_prepare(struct cred *new, const struct cred *old,
  */
 static void smack_cred_transfer(struct cred *new, const struct cred *old)
 {
-	struct task_smack *old_tsp = old->security;
-	struct task_smack *new_tsp = new->security;
+	struct task_smack *old_tsp = lsm_get_cred(old, &smack_ops);
+	struct task_smack *new_tsp = lsm_get_cred(new, &smack_ops);
 
 	new_tsp->smk_task = old_tsp->smk_task;
 	new_tsp->smk_forked = old_tsp->smk_task;
@@ -1474,7 +1469,7 @@ static void smack_cred_transfer(struct cred *new, const struct cred *old)
  */
 static int smack_kernel_act_as(struct cred *new, u32 secid)
 {
-	struct task_smack *new_tsp = new->security;
+	struct task_smack *new_tsp = lsm_get_cred(new, &smack_ops);
 	char *smack = smack_from_secid(secid);
 
 	if (smack == NULL)
@@ -1495,8 +1490,8 @@ static int smack_kernel_act_as(struct cred *new, u32 secid)
 static int smack_kernel_create_files_as(struct cred *new,
 					struct inode *inode)
 {
-	struct inode_smack *isp = inode->i_security;
-	struct task_smack *tsp = new->security;
+	struct inode_smack *isp = lsm_get_inode(inode, &smack_ops);
+	struct task_smack *tsp = lsm_get_cred(new, &smack_ops);
 
 	tsp->smk_forked = isp->smk_inode;
 	tsp->smk_task = isp->smk_inode;
@@ -1576,12 +1571,7 @@ static void smack_task_getsecid(struct task_struct *p, u32 *secid)
  */
 static int smack_task_setnice(struct task_struct *p, int nice)
 {
-	int rc;
-
-	rc = cap_task_setnice(p, nice);
-	if (rc == 0)
-		rc = smk_curacc_on_task(p, MAY_WRITE, __func__);
-	return rc;
+	return smk_curacc_on_task(p, MAY_WRITE, __func__);
 }
 
 /**
@@ -1593,12 +1583,7 @@ static int smack_task_setnice(struct task_struct *p, int nice)
  */
 static int smack_task_setioprio(struct task_struct *p, int ioprio)
 {
-	int rc;
-
-	rc = cap_task_setioprio(p, ioprio);
-	if (rc == 0)
-		rc = smk_curacc_on_task(p, MAY_WRITE, __func__);
-	return rc;
+	return smk_curacc_on_task(p, MAY_WRITE, __func__);
 }
 
 /**
@@ -1622,12 +1607,7 @@ static int smack_task_getioprio(struct task_struct *p)
  */
 static int smack_task_setscheduler(struct task_struct *p)
 {
-	int rc;
-
-	rc = cap_task_setscheduler(p);
-	if (rc == 0)
-		rc = smk_curacc_on_task(p, MAY_WRITE, __func__);
-	return rc;
+	return smk_curacc_on_task(p, MAY_WRITE, __func__);
 }
 
 /**
@@ -1715,7 +1695,7 @@ static int smack_task_wait(struct task_struct *p)
  */
 static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
 {
-	struct inode_smack *isp = inode->i_security;
+	struct inode_smack *isp = lsm_get_inode(inode, &smack_ops);
 	isp->smk_inode = smk_of_task(task_security(p));
 }
 
@@ -1746,7 +1726,7 @@ static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
 	ssp->smk_out = csp;
 	ssp->smk_packet = NULL;
 
-	sk->sk_security = ssp;
+	lsm_set_sock(sk, ssp, &smack_ops);
 
 	return 0;
 }
@@ -1759,7 +1739,8 @@ static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
  */
 static void smack_sk_free_security(struct sock *sk)
 {
-	kfree(sk->sk_security);
+	kfree(lsm_get_sock(sk, &smack_ops));
+	lsm_set_sock(sk, NULL, &smack_ops);
 }
 
 /**
@@ -1812,7 +1793,7 @@ static char *smack_host_label(struct sockaddr_in *sip)
 static int smack_netlabel(struct sock *sk, int labeled)
 {
 	struct smack_known *skp;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	int rc = 0;
 
 	/*
@@ -1856,7 +1837,7 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
 	int rc;
 	int sk_lbl;
 	char *hostsp;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	struct smk_audit_info ad;
 
 	rcu_read_lock();
@@ -1899,7 +1880,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 				   const void *value, size_t size, int flags)
 {
 	char *sp;
-	struct inode_smack *nsp = inode->i_security;
+	struct inode_smack *nsp = lsm_get_inode(inode, &smack_ops);
 	struct socket_smack *ssp;
 	struct socket *sock;
 	int rc = 0;
@@ -1926,7 +1907,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 	if (sock == NULL || sock->sk == NULL)
 		return -EOPNOTSUPP;
 
-	ssp = sock->sk->sk_security;
+	ssp = lsm_get_sock(sock->sk, &smack_ops);
 
 	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
 		ssp->smk_in = sp;
@@ -2017,7 +1998,7 @@ static int smack_flags_to_may(int flags)
  */
 static int smack_msg_msg_alloc_security(struct msg_msg *msg)
 {
-	msg->security = smk_of_current();
+	lsm_set_msg(msg, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2029,7 +2010,7 @@ static int smack_msg_msg_alloc_security(struct msg_msg *msg)
  */
 static void smack_msg_msg_free_security(struct msg_msg *msg)
 {
-	msg->security = NULL;
+	lsm_set_msg(msg, NULL, &smack_ops);
 }
 
 /**
@@ -2040,7 +2021,7 @@ static void smack_msg_msg_free_security(struct msg_msg *msg)
  */
 static char *smack_of_shm(struct shmid_kernel *shp)
 {
-	return (char *)shp->shm_perm.security;
+	return lsm_get_ipc(&shp->shm_perm, &smack_ops);
 }
 
 /**
@@ -2051,9 +2032,7 @@ static char *smack_of_shm(struct shmid_kernel *shp)
  */
 static int smack_shm_alloc_security(struct shmid_kernel *shp)
 {
-	struct kern_ipc_perm *isp = &shp->shm_perm;
-
-	isp->security = smk_of_current();
+	lsm_set_ipc(&shp->shm_perm, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2065,9 +2044,7 @@ static int smack_shm_alloc_security(struct shmid_kernel *shp)
  */
 static void smack_shm_free_security(struct shmid_kernel *shp)
 {
-	struct kern_ipc_perm *isp = &shp->shm_perm;
-
-	isp->security = NULL;
+	lsm_set_ipc(&shp->shm_perm, NULL, &smack_ops);
 }
 
 /**
@@ -2079,14 +2056,13 @@ static void smack_shm_free_security(struct shmid_kernel *shp)
  */
 static int smk_curacc_shm(struct shmid_kernel *shp, int access)
 {
-	char *ssp = smack_of_shm(shp);
 	struct smk_audit_info ad;
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
 	ad.a.u.ipc_id = shp->shm_perm.id;
 #endif
-	return smk_curacc(ssp, access, &ad);
+	return smk_curacc(smack_of_shm(shp), access, &ad);
 }
 
 /**
@@ -2098,10 +2074,7 @@ static int smk_curacc_shm(struct shmid_kernel *shp, int access)
  */
 static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
 {
-	int may;
-
-	may = smack_flags_to_may(shmflg);
-	return smk_curacc_shm(shp, may);
+	return smk_curacc_shm(shp, smack_flags_to_may(shmflg));
 }
 
 /**
@@ -2149,10 +2122,7 @@ static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
 static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
 			   int shmflg)
 {
-	int may;
-
-	may = smack_flags_to_may(shmflg);
-	return smk_curacc_shm(shp, may);
+	return smk_curacc_shm(shp, smack_flags_to_may(shmflg));
 }
 
 /**
@@ -2163,7 +2133,7 @@ static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
  */
 static char *smack_of_sem(struct sem_array *sma)
 {
-	return (char *)sma->sem_perm.security;
+	return lsm_get_ipc(&sma->sem_perm, &smack_ops);
 }
 
 /**
@@ -2174,9 +2144,7 @@ static char *smack_of_sem(struct sem_array *sma)
  */
 static int smack_sem_alloc_security(struct sem_array *sma)
 {
-	struct kern_ipc_perm *isp = &sma->sem_perm;
-
-	isp->security = smk_of_current();
+	lsm_set_ipc(&sma->sem_perm, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2188,9 +2156,7 @@ static int smack_sem_alloc_security(struct sem_array *sma)
  */
 static void smack_sem_free_security(struct sem_array *sma)
 {
-	struct kern_ipc_perm *isp = &sma->sem_perm;
-
-	isp->security = NULL;
+	lsm_set_ipc(&sma->sem_perm, NULL, &smack_ops);
 }
 
 /**
@@ -2221,10 +2187,7 @@ static int smk_curacc_sem(struct sem_array *sma, int access)
  */
 static int smack_sem_associate(struct sem_array *sma, int semflg)
 {
-	int may;
-
-	may = smack_flags_to_may(semflg);
-	return smk_curacc_sem(sma, may);
+	return smk_curacc_sem(sma, smack_flags_to_may(semflg));
 }
 
 /**
@@ -2292,9 +2255,7 @@ static int smack_sem_semop(struct sem_array *sma, struct sembuf *sops,
  */
 static int smack_msg_queue_alloc_security(struct msg_queue *msq)
 {
-	struct kern_ipc_perm *kisp = &msq->q_perm;
-
-	kisp->security = smk_of_current();
+	lsm_set_ipc(&msq->q_perm, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2306,9 +2267,7 @@ static int smack_msg_queue_alloc_security(struct msg_queue *msq)
  */
 static void smack_msg_queue_free_security(struct msg_queue *msq)
 {
-	struct kern_ipc_perm *kisp = &msq->q_perm;
-
-	kisp->security = NULL;
+	lsm_set_ipc(&msq->q_perm, NULL, &smack_ops);
 }
 
 /**
@@ -2319,7 +2278,7 @@ static void smack_msg_queue_free_security(struct msg_queue *msq)
  */
 static char *smack_of_msq(struct msg_queue *msq)
 {
-	return (char *)msq->q_perm.security;
+	return lsm_get_ipc(&msq->q_perm, &smack_ops);
 }
 
 /**
@@ -2350,10 +2309,7 @@ static int smk_curacc_msq(struct msg_queue *msq, int access)
  */
 static int smack_msg_queue_associate(struct msg_queue *msq, int msqflg)
 {
-	int may;
-
-	may = smack_flags_to_may(msqflg);
-	return smk_curacc_msq(msq, may);
+	return smk_curacc_msq(msq, smack_flags_to_may(msqflg));
 }
 
 /**
@@ -2400,10 +2356,7 @@ static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 static int smack_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 				  int msqflg)
 {
-	int may;
-
-	may = smack_flags_to_may(msqflg);
-	return smk_curacc_msq(msq, may);
+	return smk_curacc_msq(msq, smack_flags_to_may(msqflg));
 }
 
 /**
@@ -2431,15 +2384,14 @@ static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
  */
 static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
 {
-	char *isp = ipp->security;
-	int may = smack_flags_to_may(flag);
 	struct smk_audit_info ad;
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
 	ad.a.u.ipc_id = ipp->id;
 #endif
-	return smk_curacc(isp, may, &ad);
+	return smk_curacc(lsm_get_ipc(ipp, &smack_ops),
+				smack_flags_to_may(flag), &ad);
 }
 
 /**
@@ -2449,9 +2401,7 @@ static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
  */
 static void smack_ipc_getsecid(struct kern_ipc_perm *ipp, u32 *secid)
 {
-	char *smack = ipp->security;
-
-	*secid = smack_to_secid(smack);
+	*secid = smack_to_secid(lsm_get_ipc(ipp, &smack_ops));
 }
 
 /**
@@ -2477,7 +2427,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	if (inode == NULL)
 		return;
 
-	isp = inode->i_security;
+	isp = lsm_get_inode(inode, &smack_ops);
 
 	mutex_lock(&isp->smk_lock);
 	/*
@@ -2488,7 +2438,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		goto unlockandout;
 
 	sbp = inode->i_sb;
-	sbsp = sbp->s_security;
+	sbsp = lsm_get_super(sbp, &smack_ops);
 	/*
 	 * We're going to use the superblock default label
 	 * if there's no label on the file.
@@ -2670,40 +2620,26 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 }
 
 /**
- * smack_setprocattr - Smack process attribute setting
- * @p: the object task
- * @name: the name of the attribute in /proc/.../attr
+ * smk_setcurrent - Set Smack process attribute setting
  * @value: the value to set
  * @size: the size of the value
  *
- * Sets the Smack value of the task. Only setting self
- * is permitted and only with privilege
+ * Sets the Smack value of the task. Only with privilege
  *
  * Returns the length of the smack label or an error code
  */
-static int smack_setprocattr(struct task_struct *p, char *name,
-			     void *value, size_t size)
+int smk_setcurrent(char *value, size_t size)
 {
 	struct task_smack *tsp;
 	struct cred *new;
 	char *newsmack;
 
-	/*
-	 * Changing another process' Smack value is too dangerous
-	 * and supports no sane use case.
-	 */
-	if (p != current)
-		return -EPERM;
-
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (value == NULL || size == 0 || size >= SMK_LONGLABEL)
 		return -EINVAL;
 
-	if (strcmp(name, "current") != 0)
-		return -EINVAL;
-
 	newsmack = smk_import(value, size);
 	if (newsmack == NULL)
 		return -EINVAL;
@@ -2718,7 +2654,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (new == NULL)
 		return -ENOMEM;
 
-	tsp = new->security;
+	tsp = lsm_get_cred(new, &smack_ops);
 	tsp->smk_task = newsmack;
 
 	commit_creds(new);
@@ -2726,6 +2662,33 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 }
 
 /**
+ * smack_setprocattr - Smack process attribute setting
+ * @p: the object task
+ * @name: the name of the attribute in /proc/.../attr
+ * @value: the value to set
+ * @size: the size of the value
+ *
+ * Sets the Smack value of the task. Only setting self
+ * is permitted and only with privilege
+ *
+ * Returns the length of the smack label or an error code
+ */
+static int smack_setprocattr(struct task_struct *p, char *name,
+			     void *value, size_t size)
+{
+	/*
+	 * Changing another process' Smack value is too dangerous
+	 * and supports no sane use case.
+	 */
+	if (p != current)
+		return -EPERM;
+	if (strcmp(name, "current") != 0)
+		return -EINVAL;
+
+	return smk_setcurrent(value, size);
+}
+
+/**
  * smack_unix_stream_connect - Smack access on UDS
  * @sock: one sock
  * @other: the other sock
@@ -2737,9 +2700,9 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 static int smack_unix_stream_connect(struct sock *sock,
 				     struct sock *other, struct sock *newsk)
 {
-	struct socket_smack *ssp = sock->sk_security;
-	struct socket_smack *osp = other->sk_security;
-	struct socket_smack *nsp = newsk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sock, &smack_ops);
+	struct socket_smack *osp = lsm_get_sock(other, &smack_ops);
+	struct socket_smack *nsp = lsm_get_sock(newsk, &smack_ops);
 	struct smk_audit_info ad;
 	int rc = 0;
 
@@ -2774,8 +2737,8 @@ static int smack_unix_stream_connect(struct sock *sock,
  */
 static int smack_unix_may_send(struct socket *sock, struct socket *other)
 {
-	struct socket_smack *ssp = sock->sk->sk_security;
-	struct socket_smack *osp = other->sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sock->sk, &smack_ops);
+	struct socket_smack *osp = lsm_get_sock(other->sk, &smack_ops);
 	struct smk_audit_info ad;
 	int rc = 0;
 
@@ -2894,7 +2857,7 @@ static char *smack_from_secattr(struct netlbl_lsm_secattr *sap,
 static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct netlbl_lsm_secattr secattr;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	char *csp;
 	int rc;
 	struct smk_audit_info ad;
@@ -2953,7 +2916,7 @@ static int smack_socket_getpeersec_stream(struct socket *sock,
 	int slen = 1;
 	int rc = 0;
 
-	ssp = sock->sk->sk_security;
+	ssp = lsm_get_sock(sock->sk, &smack_ops);
 	if (ssp->smk_packet != NULL) {
 		rcp = ssp->smk_packet;
 		slen = strlen(rcp) + 1;
@@ -3000,14 +2963,14 @@ static int smack_socket_getpeersec_dgram(struct socket *sock,
 		family = sock->sk->sk_family;
 
 	if (family == PF_UNIX) {
-		ssp = sock->sk->sk_security;
+		ssp = lsm_get_sock(sock->sk, &smack_ops);
 		s = smack_to_secid(ssp->smk_out);
 	} else if (family == PF_INET || family == PF_INET6) {
 		/*
 		 * Translate what netlabel gave us.
 		 */
 		if (sock != NULL && sock->sk != NULL)
-			ssp = sock->sk->sk_security;
+			ssp = lsm_get_sock(sock->sk, &smack_ops);
 		netlbl_secattr_init(&secattr);
 		rc = netlbl_skbuff_getattr(skb, family, &secattr);
 		if (rc == 0) {
@@ -3038,7 +3001,7 @@ static void smack_sock_graft(struct sock *sk, struct socket *parent)
 	    (sk->sk_family != PF_INET && sk->sk_family != PF_INET6))
 		return;
 
-	ssp = sk->sk_security;
+	ssp = lsm_get_sock(sk, &smack_ops);
 	ssp->smk_in = ssp->smk_out = smk_of_current();
 	/* cssp->smk_packet is already set in smack_inet_csk_clone() */
 }
@@ -3057,7 +3020,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 {
 	u16 family = sk->sk_family;
 	struct smack_known *skp;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	struct netlbl_lsm_secattr secattr;
 	struct sockaddr_in addr;
 	struct iphdr *hdr;
@@ -3131,7 +3094,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 static void smack_inet_csk_clone(struct sock *sk,
 				 const struct request_sock *req)
 {
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 
 	if (req->peer_secid != 0)
 		ssp->smk_packet = smack_from_secid(req->peer_secid);
@@ -3161,7 +3124,8 @@ static void smack_inet_csk_clone(struct sock *sk,
 static int smack_key_alloc(struct key *key, const struct cred *cred,
 			   unsigned long flags)
 {
-	key->security = smk_of_task(cred->security);
+	lsm_set_key(key, smk_of_task(lsm_get_cred(cred, &smack_ops)),
+			&smack_ops);
 	return 0;
 }
 
@@ -3173,7 +3137,7 @@ static int smack_key_alloc(struct key *key, const struct cred *cred,
  */
 static void smack_key_free(struct key *key)
 {
-	key->security = NULL;
+	lsm_set_key(key, NULL, &smack_ops);
 }
 
 /*
@@ -3190,16 +3154,18 @@ static int smack_key_permission(key_ref_t key_ref,
 {
 	struct key *keyp;
 	struct smk_audit_info ad;
-	char *tsp = smk_of_task(cred->security);
+	char *tsp = smk_of_task(lsm_get_cred(cred, &smack_ops));
+	char *ksp;
 
 	keyp = key_ref_to_ptr(key_ref);
 	if (keyp == NULL)
 		return -EINVAL;
+	ksp = lsm_get_key(keyp, &smack_ops);
 	/*
 	 * If the key hasn't been initialized give it access so that
 	 * it may do so.
 	 */
-	if (keyp->security == NULL)
+	if (ksp == NULL)
 		return 0;
 	/*
 	 * This should not occur
@@ -3211,8 +3177,7 @@ static int smack_key_permission(key_ref_t key_ref,
 	ad.a.u.key_struct.key = keyp->serial;
 	ad.a.u.key_struct.key_desc = keyp->description;
 #endif
-	return smk_access(tsp, keyp->security,
-				 MAY_READWRITE, &ad);
+	return smk_access(tsp, ksp, MAY_READWRITE, &ad);
 }
 #endif /* CONFIG_KEYS */
 
@@ -3577,6 +3542,7 @@ static __init void init_smack_known_list(void)
  */
 static __init int smack_init(void)
 {
+	int rc;
 	struct cred *cred;
 	struct task_smack *tsp;
 
@@ -3594,17 +3560,14 @@ static __init int smack_init(void)
 	 * Set the security state for the initial task.
 	 */
 	cred = (struct cred *) current->cred;
-	cred->security = tsp;
+
+	rc = lsm_set_init_cred(cred, tsp, &smack_ops);
+	if (rc != 0)
+		panic("smack: Unable to initialize credentials.\n");
 
 	/* initialize the smack_known_list */
 	init_smack_known_list();
 
-	/*
-	 * Register with LSM
-	 */
-	if (register_security(&smack_ops))
-		panic("smack: Unable to register with kernel.\n");
-
 	return 0;
 }
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 76a5dca..60071ef 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -108,7 +108,7 @@ struct smack_master_list {
 	struct smack_rule	*smk_rule;
 };
 
-LIST_HEAD(smack_rule_list);
+static LIST_HEAD(smack_rule_list);
 
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 
@@ -1582,7 +1582,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
 	char *data;
-	char *sp = smk_of_task(current->cred->security);
+	char *sp = smk_of_task(lsm_get_cred(current->cred, &smack_ops));
 	int rc = count;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
@@ -1696,14 +1696,14 @@ static const struct file_operations smk_logging_ops = {
 
 static void *load_self_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_seq_start(s, pos, &tsp->smk_rules);
 }
 
 static void *load_self_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_seq_next(s, v, pos, &tsp->smk_rules);
 }
@@ -1750,7 +1750,7 @@ static int smk_open_load_self(struct inode *inode, struct file *file)
 static ssize_t smk_write_load_self(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_write_rules_list(file, buf, count, ppos, &tsp->smk_rules,
 				    &tsp->smk_rules_lock, SMK_FIXED24_FMT);
@@ -1905,14 +1905,14 @@ static const struct file_operations smk_load2_ops = {
 
 static void *load_self2_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_seq_start(s, pos, &tsp->smk_rules);
 }
 
 static void *load_self2_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_seq_next(s, v, pos, &tsp->smk_rules);
 }
@@ -1958,7 +1958,7 @@ static int smk_open_load_self2(struct inode *inode, struct file *file)
 static ssize_t smk_write_load_self2(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_write_rules_list(file, buf, count, ppos, &tsp->smk_rules,
 				    &tsp->smk_rules_lock, SMK_LONG_FMT);

