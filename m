Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab1ITMhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:37:50 -0400
Received: from mga05.intel.com ([192.55.52.89]:36730 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753969Ab1ITMht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:37:49 -0400
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] Smack: Use secureexec with SMACK64EXEC
Date: Tue, 20 Sep 2011 15:37:34 +0300
Message-Id: <1316522254-23193-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.4.1
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMACK64EXEC extended attribute allows switching to
another security context when executing a file.

This patch enables secureexec bit in ELF auxiliary
vector so that code cannot be injected from executers
security context.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 security/smack/smack.h     |    5 +++++
 security/smack/smack_lsm.c |   15 ++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 2b6c6a5..e41fb07 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -181,6 +181,11 @@ struct smack_known {
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
index b9c5e14..3ea018d 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -465,12 +465,24 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 
 	isp = dp->d_inode->i_security;
 
-	if (isp->smk_task != NULL)
+	if (isp->smk_task != NULL) {
 		tsp->smk_task = isp->smk_task;
+		bprm->unsafe = SMK_SECUREEXEC_NEEDED;
+	}
 
 	return 0;
 }
 
+int smack_bprm_secureexec(struct linux_binprm *bprm)
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
@@ -3409,6 +3421,7 @@ struct security_operations smack_ops = {
 	.sb_umount = 			smack_sb_umount,
 
 	.bprm_set_creds =		smack_bprm_set_creds,
+	.bprm_secureexec =		smack_bprm_secureexec,
 
 	.inode_alloc_security = 	smack_inode_alloc_security,
 	.inode_free_security = 		smack_inode_free_security,
-- 
1.7.4.1

