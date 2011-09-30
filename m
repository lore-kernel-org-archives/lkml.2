Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab1I3Jqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:46:32 -0400
Received: from mga10.intel.com ([192.55.52.92]:3225 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753940Ab1I3Jqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:46:30 -0400
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] Smack: domain transition protections (v2)
Date: Fri, 30 Sep 2011 12:46:15 +0300
Message-Id: <1317375975-13427-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.4.1
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protections for domain transition:

- BPRM unsafe flags
- Secureexec
- Clear unsafe personality bits.
- Clear parent death signal

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 security/smack/smack.h     |    2 +
 security/smack/smack_lsm.c |   62 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 174d3be..d377099 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -60,12 +60,14 @@ struct inode_smack {
 struct task_smack {
 	char			*smk_task;	/* label for access control */
 	char			*smk_forked;	/* label when forked */
+	int			smk_flags;	/* smack task flags */
 	struct list_head	smk_rules;	/* per task access rules */
 	struct mutex		smk_rules_lock;	/* lock for the rules */
 };
 
 #define	SMK_INODE_INSTANT	0x01	/* inode is instantiated */
 #define	SMK_INODE_TRANSMUTE	0x02	/* directory is transmuting */
+#define	SMK_TASK_TRANSITION	0x01	/* task needs secureexec mode */
 
 /*
  * A label access rule.
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 2e71c3f..78e0056 100644
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
-	struct task_smack *tsp = bprm->cred->security;
+	struct inode *inode = bprm->file->f_path.dentry->d_inode;
+	struct task_smack *bsp = bprm->cred->security;
 	struct inode_smack *isp;
-	struct dentry *dp;
 	int rc;
 
 	rc = cap_bprm_set_creds(bprm);
@@ -455,20 +462,51 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	if (bprm->cred_prepared)
 		return 0;
 
-	if (bprm->file == NULL || bprm->file->f_dentry == NULL)
+	isp = inode->i_security;
+	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
 		return 0;
 
-	dp = bprm->file->f_dentry;
+	if (bprm->unsafe)
+		return -EPERM;
 
-	if (dp->d_inode == NULL)
-		return 0;
+	bsp->smk_task = isp->smk_task;
+	bsp->smk_flags = SMK_TASK_TRANSITION;
+	bprm->per_clear |= PER_CLEAR_ON_SETID;
 
-	isp = dp->d_inode->i_security;
+	return 0;
+}
+
+/**
+ * smack_bprm_committing_creds - Prepare to install the new credentials
+ * from bprm.
+ *
+ * @bprm: binprm for exec
+ */
+static void smack_bprm_committing_creds(struct linux_binprm *bprm)
+{
+	struct task_smack *bsp = bprm->cred->security;
 
-	if (isp->smk_task != NULL)
-		tsp->smk_task = isp->smk_task;
+	if (!(bsp->smk_flags & SMK_TASK_TRANSITION))
+		return;
 
-	return 0;
+	current->pdeath_signal = 0;
+}
+
+/**
+ * smack_bprm_secureexec - Return the decision to use secureexec.
+ * @bprm: binprm for exec
+ *
+ * Returns 0 on success.
+ */
+static int smack_bprm_secureexec(struct linux_binprm *bprm)
+{
+	struct task_smack *tsp = current_security();
+	int ret = cap_bprm_secureexec(bprm);
+
+	if (!ret && (tsp->smk_flags & SMK_TASK_TRANSITION))
+		ret = 1;
+
+	return ret;
 }
 
 /*
@@ -3452,6 +3490,8 @@ struct security_operations smack_ops = {
 	.sb_umount = 			smack_sb_umount,
 
 	.bprm_set_creds =		smack_bprm_set_creds,
+	.bprm_committing_creds =	smack_bprm_committing_creds,
+	.bprm_secureexec =		smack_bprm_secureexec,
 
 	.inode_alloc_security = 	smack_inode_alloc_security,
 	.inode_free_security = 		smack_inode_free_security,
-- 
1.7.4.1

