Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1I1Ksr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:48:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:48318 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab1I1Ksp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:48:45 -0400
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] Smack: fix domain transfer issues
Date: Wed, 28 Sep 2011 13:48:29 +0300
Message-Id: <1317206909-24443-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.4.1
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When domain changes, Smack should check for ptracing
and shared state. Additionally, it should clear unsafe
personality bits and turn on the secureexec bit. This
patch addresses these issues.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 security/smack/smack.h     |    5 ++++
 security/smack/smack_lsm.c |   46 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 174d3be..7b37615 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -187,6 +187,11 @@ struct smack_known {
 #define SMK_NUM_ACCESS_TYPE 4
 
 /*
+ * Passed in the bprm->unsafe field
+ */
+#define SMK_SECUREEXEC_NEEDED 0x8000
+
+/*
  * Smack audit data; is empty if CONFIG_AUDIT not set
  * to save some stack
  */
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 2e71c3f..b3766ac 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -5,12 +5,13 @@
  *
  *  Authors:
  *	Casey Schaufler <casey@schaufler-ca.com>
- *	Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>
+ *	Jarkko Sakkinen <jarkko.sakkinen@intel.com>
  *
  *  Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
  *  Copyright (C) 2009 Hewlett-Packard Development Company, L.P.
  *                Paul Moore <paul@paul-moore.com>
  *  Copyright (C) 2010 Nokia Corporation
+ *  Copyright (C) 2011 Intel Corporation.
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License version 2,
@@ -441,11 +442,17 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
  * BPRM hooks
  */
 
+/**
+ * smack_bprm_set_creds - Smack exec that handles the domain transfer.
+ * @bprm: binprm for exec
+ *
+ * Returns 0 on success.
+ */
 static int smack_bprm_set_creds(struct linux_binprm *bprm)
 {
+	struct inode *inode = bprm->file->f_path.dentry->d_inode;
 	struct task_smack *tsp = bprm->cred->security;
 	struct inode_smack *isp;
-	struct dentry *dp;
 	int rc;
 
 	rc = cap_bprm_set_creds(bprm);
@@ -455,22 +462,40 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	if (bprm->cred_prepared)
 		return 0;
 
-	if (bprm->file == NULL || bprm->file->f_dentry == NULL)
-		return 0;
-
-	dp = bprm->file->f_dentry;
+	isp = inode->i_security;
 
-	if (dp->d_inode == NULL)
+	if (isp->smk_task == NULL || isp->smk_task == tsp->smk_task)
 		return 0;
 
-	isp = dp->d_inode->i_security;
+	if (bprm->unsafe & LSM_UNSAFE_SHARE)
+		return -EPERM;
 
-	if (isp->smk_task != NULL)
-		tsp->smk_task = isp->smk_task;
+	if (bprm->unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP))
+		return -EPERM;
+
+	tsp->smk_task = isp->smk_task;
+	bprm->per_clear |= PER_CLEAR_ON_SETID;
+	bprm->unsafe |= SMK_SECUREEXEC_NEEDED;
 
 	return 0;
 }
 
+/**
+ * smack_bprm_secureexec - Return the decision to use secureexec.
+ * @bprm: binprm for exec
+ *
+ * Returns 0 on success.
+ */
+static int smack_bprm_secureexec(struct linux_binprm *bprm)
+{
+	int ret = cap_bprm_secureexec(bprm);
+
+	if (!ret && (bprm->unsafe & SMK_SECUREEXEC_NEEDED))
+		ret = 1;
+
+	return ret;
+}
+
 /*
  * Inode hooks
  */
@@ -3452,6 +3477,7 @@ struct security_operations smack_ops = {
 	.sb_umount = 			smack_sb_umount,
 
 	.bprm_set_creds =		smack_bprm_set_creds,
+	.bprm_secureexec =		smack_bprm_secureexec,
 
 	.inode_alloc_security = 	smack_inode_alloc_security,
 	.inode_free_security = 		smack_inode_free_security,
-- 
1.7.4.1

