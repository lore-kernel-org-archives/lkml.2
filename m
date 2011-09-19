Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab1ISTmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 15:42:50 -0400
Received: from nm25-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.228]:33278 "HELO
	nm25-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750899Ab1ISTmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 15:42:49 -0400
X-Yahoo-Newman-Id: 188210.6000.bm@omp1052.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: AnTy744VM1kk.dq7skUVUCgrYRmHSxpShCK6_DHklPZ2lke
 wEZUSVPWwaCRzv7sUQ11i0d2qZ4hNa3iFSk2Yk.Rh0_zjHHStY8aqPMeCmUl
 UghyNn9WjgzB.s3iTjJRTKMcgoYHlByim3S9Z._0yP07eUhG2ZLIXQ_pgn2Z
 ifsmAc78KFpA0lhIWw2JVg3_.COiOoVHI.x13t6y_DZJ_soQbj6ABBkSi521
 D5k3ZRWMxgkHB1IufKtZQVKmQqDxbDF0AqRcIMWEWqmI_6TaBz9cYMej11sA
 z6sugBuE33niF2z16DqUFkrHRxUZsTgdPVYYcLdkGWwDJxYpP04K7YakDUVG
 tEomALyBCJ74tTEct.6KRUl.LLbQwSsPQgsYZd7zCYiFwbTKIoHWauvl.AvN
 _IJ14sex_3zuqWKvcl1rUNw2zN_LJWfVXqmvkRuoFuoBa5aZo._JIESDpDg-
 -
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E779AF6.3030105@schaufler-ca.com>
Date: Mon, 19 Sep 2011 12:41:42 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: Repair processing of fcntl
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Al Viro pointed out that the processing of fcntl done
by Smack appeared poorly designed. He was right. There
are three things that required change. Most obviously,
the list of commands that really imply writing is limited
to those involving file locking and signal handling.
The initialization if the file security blob was
incomplete, requiring use of a heretofore unused LSM hook.
Finally, the audit information coming from a helper
masked the identity of the LSM hook. This patch corrects
all three of these defects.

This is targeted for the smack-next tree pending comments.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 security/smack/smack_lsm.c |   67 +++++++++++++++++++++++++++----------------
 1 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index b9c5e14..a0d3eaa 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1088,36 +1088,31 @@ static int smack_file_lock(struct file *file, unsigned int cmd)
  * @cmd: what action to check
  * @arg: unused
  *
+ * Generally these operations are harmless.
+ * File locking operations present an obvious mechanism
+ * for passing information, so they require write access.
+ *
  * Returns 0 if current has access, error code otherwise
  */
 static int smack_file_fcntl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
 {
 	struct smk_audit_info ad;
-	int rc;
+	int rc = 0;
 
-	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
-	smk_ad_setfield_u_fs_path(&ad, file->f_path);
 
 	switch (cmd) {
-	case F_DUPFD:
-	case F_GETFD:
-	case F_GETFL:
 	case F_GETLK:
-	case F_GETOWN:
-	case F_GETSIG:
-		rc = smk_curacc(file->f_security, MAY_READ, &ad);
-		break;
-	case F_SETFD:
-	case F_SETFL:
 	case F_SETLK:
 	case F_SETLKW:
 	case F_SETOWN:
 	case F_SETSIG:
+		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
+		smk_ad_setfield_u_fs_path(&ad, file->f_path);
 		rc = smk_curacc(file->f_security, MAY_WRITE, &ad);
 		break;
 	default:
-		rc = smk_curacc(file->f_security, MAY_READWRITE, &ad);
+		break;
 	}
 
 	return rc;
@@ -1315,6 +1310,24 @@ static int smack_file_receive(struct file *file)
 	return smk_curacc(file->f_security, may, &ad);
 }
 
+/**
+ * smack_dentry_open - Smack dentry open processing
+ * @file: the object
+ * @cred: unused
+ *
+ * Set the security blob in the file structure.
+ *
+ * Returns 0
+ */
+static int smack_dentry_open(struct file *file, const struct cred *cred)
+{
+	struct inode_smack *isp = file->f_path.dentry->d_inode->i_security;
+
+	file->f_security = isp->smk_inode;
+
+	return 0;
+}
+
 /*
  * Task hooks
  */
@@ -1455,15 +1468,17 @@ static int smack_kernel_create_files_as(struct cred *new,
 /**
  * smk_curacc_on_task - helper to log task related access
  * @p: the task object
- * @access : the access requested
+ * @access: the access requested
+ * @caller: name of the calling function for audit
  *
  * Return 0 if access is permitted
  */
-static int smk_curacc_on_task(struct task_struct *p, int access)
+static int smk_curacc_on_task(struct task_struct *p, int access,
+				const char *caller)
 {
 	struct smk_audit_info ad;
 
-	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
+	smk_ad_init(&ad, caller, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, p);
 	return smk_curacc(smk_of_task(task_security(p)), access, &ad);
 }
@@ -1477,7 +1492,7 @@ static int smk_curacc_on_task(struct task_struct *p, int access)
  */
 static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
 {
-	return smk_curacc_on_task(p, MAY_WRITE);
+	return smk_curacc_on_task(p, MAY_WRITE, __func__);
 }
 
 /**
@@ -1488,7 +1503,7 @@ static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
  */
 static int smack_task_getpgid(struct task_struct *p)
 {
-	return smk_curacc_on_task(p, MAY_READ);
+	return smk_curacc_on_task(p, MAY_READ, __func__);
 }
 
 /**
@@ -1499,7 +1514,7 @@ static int smack_task_getpgid(struct task_struct *p)
  */
 static int smack_task_getsid(struct task_struct *p)
 {
-	return smk_curacc_on_task(p, MAY_READ);
+	return smk_curacc_on_task(p, MAY_READ, __func__);
 }
 
 /**
@@ -1527,7 +1542,7 @@ static int smack_task_setnice(struct task_struct *p, int nice)
 
 	rc = cap_task_setnice(p, nice);
 	if (rc == 0)
-		rc = smk_curacc_on_task(p, MAY_WRITE);
+		rc = smk_curacc_on_task(p, MAY_WRITE, __func__);
 	return rc;
 }
 
@@ -1544,7 +1559,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
 
 	rc = cap_task_setioprio(p, ioprio);
 	if (rc == 0)
-		rc = smk_curacc_on_task(p, MAY_WRITE);
+		rc = smk_curacc_on_task(p, MAY_WRITE, __func__);
 	return rc;
 }
 
@@ -1556,7 +1571,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
  */
 static int smack_task_getioprio(struct task_struct *p)
 {
-	return smk_curacc_on_task(p, MAY_READ);
+	return smk_curacc_on_task(p, MAY_READ, __func__);
 }
 
 /**
@@ -1573,7 +1588,7 @@ static int smack_task_setscheduler(struct task_struct *p)
 
 	rc = cap_task_setscheduler(p);
 	if (rc == 0)
-		rc = smk_curacc_on_task(p, MAY_WRITE);
+		rc = smk_curacc_on_task(p, MAY_WRITE, __func__);
 	return rc;
 }
 
@@ -1585,7 +1600,7 @@ static int smack_task_setscheduler(struct task_struct *p)
  */
 static int smack_task_getscheduler(struct task_struct *p)
 {
-	return smk_curacc_on_task(p, MAY_READ);
+	return smk_curacc_on_task(p, MAY_READ, __func__);
 }
 
 /**
@@ -1596,7 +1611,7 @@ static int smack_task_getscheduler(struct task_struct *p)
  */
 static int smack_task_movememory(struct task_struct *p)
 {
-	return smk_curacc_on_task(p, MAY_WRITE);
+	return smk_curacc_on_task(p, MAY_WRITE, __func__);
 }
 
 /**
@@ -3440,6 +3455,8 @@ struct security_operations smack_ops = {
 	.file_send_sigiotask = 		smack_file_send_sigiotask,
 	.file_receive = 		smack_file_receive,
 
+	.dentry_open =			smack_dentry_open,
+
 	.cred_alloc_blank =		smack_cred_alloc_blank,
 	.cred_free =			smack_cred_free,
 	.cred_prepare =			smack_cred_prepare,



