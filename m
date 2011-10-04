Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1JDG3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 02:29:24 -0400
Received: from mga07.intel.com ([143.182.124.22]:46255 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751149Ab1JDG3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 02:29:22 -0400
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] Smack: domain transition protections (v3)
Date: Tue,  4 Oct 2011 09:29:06 +0300
Message-Id: <1317709746-8303-1-git-send-email-jarkko.sakkinen@intel.com>
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
 security/smack/smack_lsm.c |   59 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 2e71c3f..f1ef41c 100644
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
@@ -455,20 +462,48 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	if (bprm->cred_prepared)
 		return 0;
 
-	if (bprm->file == NULL || bprm->file->f_dentry == NULL)
+	isp = inode->i_security;
+	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
 		return 0;
 
-	dp = bprm->file->f_dentry;
+	if (bprm->unsafe)
+		return -EPERM;
+
+	bsp->smk_task = isp->smk_task;
+	bprm->per_clear |= PER_CLEAR_ON_SETID;
 
-	if (dp->d_inode == NULL)
-		return 0;
+	return 0;
+}
 
-	isp = dp->d_inode->i_security;
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
+	if (bsp->smk_task != bsp->smk_forked)
+		current->pdeath_signal = 0;
+}
 
-	return 0;
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
+	if (!ret && (tsp->smk_task != tsp->smk_forked))
+		ret = 1;
+
+	return ret;
 }
 
 /*
@@ -3452,6 +3487,8 @@ struct security_operations smack_ops = {
 	.sb_umount = 			smack_sb_umount,
 
 	.bprm_set_creds =		smack_bprm_set_creds,
+	.bprm_committing_creds =	smack_bprm_committing_creds,
+	.bprm_secureexec =		smack_bprm_secureexec,
 
 	.inode_alloc_security = 	smack_inode_alloc_security,
 	.inode_free_security = 		smack_inode_free_security,
-- 
1.7.4.1

