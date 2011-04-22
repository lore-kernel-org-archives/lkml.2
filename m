Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab1DVAYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:24:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:14999 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab1DVAYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:24:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,252,1301900400"; 
   d="scan'208";a="912923518"
From: Andi Kleen <andi@firstfloor.org>
To: linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, npiggin@kernel.dk, shaohua.li@intel.com,
        sds@tycho.nsa.gov, jmorris@namei.org,
        linux-security-module@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] SMACK: Make smack directory access check RCU safe
Date: Thu, 21 Apr 2011 17:23:21 -0700
Message-Id: <1303431801-10540-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
References: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

SMACK already uses RCU internally, so except for auditing,
it's safe to not abort a RCU dcache walk.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 security/smack/smack.h        |   14 ++++++++++++--
 security/smack/smack_access.c |   26 ++++++++++++++++++++------
 security/smack/smack_lsm.c    |    5 +----
 3 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index b449cfd..0cc17e3 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -198,8 +198,18 @@ struct inode_smack *new_inode_smack(char *);
  * These functions are in smack_access.c
  */
 int smk_access_entry(char *, char *, struct list_head *);
-int smk_access(char *, char *, int, struct smk_audit_info *);
-int smk_curacc(char *, u32, struct smk_audit_info *);
+int smk_access_flags(char *, char *, int, struct smk_audit_info *, int);
+static inline int smk_access(char *a, char *b, int c, struct smk_audit_info *d)
+{
+	return smk_access_flags(a, b, c, d, 0);
+}
+int smk_curacc_flags(char *, u32, struct smk_audit_info *, int vfs_flags);
+
+static inline int smk_curacc(char *a, u32 b, struct smk_audit_info *c)
+{
+	return smk_curacc_flags(a, b, c, 0);
+}
+
 int smack_to_cipso(const char *, struct smack_cipso *);
 void smack_from_cipso(u32, char *, char *);
 char *smack_from_secid(const u32);
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 9294c5d..43b20f3 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -128,8 +128,8 @@ int smk_access_entry(char *subject_label, char *object_label,
  * will be on the list, so checking the pointers may be a worthwhile
  * optimization.
  */
-int smk_access(char *subject_label, char *object_label, int request,
-	       struct smk_audit_info *a)
+int smk_access_flags(char *subject_label, char *object_label, int request,
+		     struct smk_audit_info *a, int vfs_flags)
 {
 	int may = MAY_NOT;
 	int rc = 0;
@@ -194,8 +194,17 @@ int smk_access(char *subject_label, char *object_label, int request,
 	rc = -EACCES;
 out_audit:
 #ifdef CONFIG_AUDIT
-	if (a)
+	if (a) {
+		/* 
+		 * If we're in a RCU walk try again without RCU 
+		 * for auditing. While in theory this may skip
+		 * auditing when things change logically it is
+		 * just as if the operation succeeded a bit later.
+		 */
+		if (vfs_flags & IPERM_FLAG_RCU)
+			return -ECHILD;
 		smack_log(subject_label, object_label, request, rc, a);
+	}
 #endif
 	return rc;
 }
@@ -211,7 +220,8 @@ out_audit:
  * non zero otherwise. It allows that current may have the capability
  * to override the rules.
  */
-int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
+int smk_curacc_flags(char *obj_label, u32 mode, struct smk_audit_info *a,
+	       	     int vfs_flags)
 {
 	struct task_smack *tsp = current_security();
 	char *sp = smk_of_task(tsp);
@@ -221,7 +231,7 @@ int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
 	/*
 	 * Check the global rule list
 	 */
-	rc = smk_access(sp, obj_label, mode, NULL);
+	rc = smk_access_flags(sp, obj_label, mode, NULL, vfs_flags);
 	if (rc == 0) {
 		/*
 		 * If there is an entry in the task's rule list
@@ -248,8 +258,12 @@ int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
 
 out_audit:
 #ifdef CONFIG_AUDIT
-	if (a)
+	if (a && rc != -ECHILD) {
+		/* Audit in non RCU mode */
+		if (vfs_flags & IPERM_FLAG_RCU)
+			return -ECHILD;
 		smack_log(sp, obj_label, mode, rc, a);
+	}
 #endif
 	return rc;
 }
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 400a5d5..366d250 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -697,12 +697,9 @@ static int smack_inode_permission(struct inode *inode, int mask, unsigned flags)
 	if (mask == 0)
 		return 0;
 
-	/* May be droppable after audit */
-	if (flags & IPERM_FLAG_RCU)
-		return -ECHILD;
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_FS);
 	smk_ad_setfield_u_fs_inode(&ad, inode);
-	return smk_curacc(smk_of_inode(inode), mask, &ad);
+	return smk_curacc_flags(smk_of_inode(inode), mask, &ad, flags);
 }
 
 /**
-- 
1.7.4.2

