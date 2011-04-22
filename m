Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1DVAYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:24:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:11164 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab1DVAYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:24:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,252,1301900400"; 
   d="scan'208";a="423604381"
From: Andi Kleen <andi@firstfloor.org>
To: linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, npiggin@kernel.dk, shaohua.li@intel.com,
        sds@tycho.nsa.gov, jmorris@namei.org,
        linux-security-module@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] SELINUX: Make selinux cache VFS RCU walks safe
Date: Thu, 21 Apr 2011 17:23:20 -0700
Message-Id: <1303431801-10540-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
References: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Now that the security modules can decide whether they support the
dcache RCU walk or not it's possible to make selinux a bit more
RCU friendly. selinux already uses RCU for its internal decision
cache, so this must be already RCU safe.

This patch makes the VFS RCU walk not retry in selinux if it
hit the cache, and only fallback on a cache miss.

I had to add some parameters to pass the state around, otherwise
the patch is quite simple.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 security/selinux/avc.c         |   48 +++++++++++++++++++++++++++++++--------
 security/selinux/hooks.c       |   28 +++++++++++-----------
 security/selinux/include/avc.h |   22 ++++++++++++-----
 security/selinux/ss/services.c |    2 +-
 4 files changed, 68 insertions(+), 32 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 9da6420..9163c5f 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -471,6 +471,7 @@ static void avc_audit_post_callback(struct audit_buffer *ab, void *a)
  * @avd: access vector decisions
  * @result: result from avc_has_perm_noaudit
  * @a:  auxiliary audit data
+ * @flags: VFS walk flags
  *
  * Audit the granting or denial of permissions in accordance
  * with the policy.  This function is typically called by
@@ -481,9 +482,10 @@ static void avc_audit_post_callback(struct audit_buffer *ab, void *a)
  * be performed under a lock, to allow the lock to be released
  * before calling the auditing code.
  */
-void avc_audit(u32 ssid, u32 tsid,
+int avc_audit(u32 ssid, u32 tsid,
 	       u16 tclass, u32 requested,
-	       struct av_decision *avd, int result, struct common_audit_data *a)
+	       struct av_decision *avd, int result, struct common_audit_data *a,
+	       unsigned flags)
 {
 	struct common_audit_data stack_data;
 	u32 denied, audited;
@@ -515,7 +517,18 @@ void avc_audit(u32 ssid, u32 tsid,
 	else
 		audited = requested & avd->auditallow;
 	if (!audited)
-		return;
+		return 0;
+
+	/* 
+	 * When in a RCU walk do the audit on the RCU retry (until
+	 * someone makes audit RCU safe)
+	 * Note this may drop some audits when the situation changes during
+	 * retry. However this is logically just as if the operation happened
+	 * a little later.
+	 */
+	if (flags & IPERM_FLAG_RCU)
+		return -ECHILD;
+
 	if (!a) {
 		a = &stack_data;
 		COMMON_AUDIT_DATA_INIT(a, NONE);
@@ -529,6 +542,7 @@ void avc_audit(u32 ssid, u32 tsid,
 	a->lsm_pre_audit = avc_audit_pre_callback;
 	a->lsm_post_audit = avc_audit_post_callback;
 	common_lsm_audit(a);
+	return 0;
 }
 
 /**
@@ -726,6 +740,7 @@ int avc_ss_reset(u32 seqno)
  * @requested: requested permissions, interpreted based on @tclass
  * @flags:  AVC_STRICT or 0
  * @avd: access vector decisions
+ * @vfsflags: VFS walk flags
  *
  * Check the AVC to determine whether the @requested permissions are granted
  * for the SID pair (@ssid, @tsid), interpreting the permissions
@@ -741,7 +756,8 @@ int avc_ss_reset(u32 seqno)
 int avc_has_perm_noaudit(u32 ssid, u32 tsid,
 			 u16 tclass, u32 requested,
 			 unsigned flags,
-			 struct av_decision *in_avd)
+			 struct av_decision *in_avd,
+			 unsigned vfsflags)
 {
 	struct avc_node *node;
 	struct av_decision avd_entry, *avd;
@@ -756,6 +772,10 @@ int avc_has_perm_noaudit(u32 ssid, u32 tsid,
 	if (!node) {
 		rcu_read_unlock();
 
+		/* Try again later if RCU */
+		if (vfsflags & IPERM_FLAG_RCU)
+			return -ECHILD;
+
 		if (in_avd)
 			avd = in_avd;
 		else
@@ -793,6 +813,7 @@ int avc_has_perm_noaudit(u32 ssid, u32 tsid,
  * @tclass: target security class
  * @requested: requested permissions, interpreted based on @tclass
  * @auditdata: auxiliary audit data
+ * @flags: VFS walk flags
  *
  * Check the AVC to determine whether the @requested permissions are granted
  * for the SID pair (@ssid, @tsid), interpreting the permissions
@@ -802,14 +823,21 @@ int avc_has_perm_noaudit(u32 ssid, u32 tsid,
  * permissions are granted, -%EACCES if any permissions are denied, or
  * another -errno upon other errors.
  */
-int avc_has_perm(u32 ssid, u32 tsid, u16 tclass,
-		 u32 requested, struct common_audit_data *auditdata)
+int avc_has_perm_flags(u32 ssid, u32 tsid, u16 tclass,
+		       u32 requested, struct common_audit_data *auditdata,
+		       unsigned flags)
 {
 	struct av_decision avd;
-	int rc;
-
-	rc = avc_has_perm_noaudit(ssid, tsid, tclass, requested, 0, &avd);
-	avc_audit(ssid, tsid, tclass, requested, &avd, rc, auditdata);
+	int rc, rc2;
+
+	rc = avc_has_perm_noaudit(ssid, tsid, tclass, requested, 0, &avd,
+				  flags);
+	if (rc == -ECHILD)
+		return rc;
+	rc2 = avc_audit(ssid, tsid, tclass, requested, &avd, rc, auditdata,
+			flags);
+	if (rc2 == -ECHILD)
+		return rc2;
 	return rc;
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a73f4e4..ea8c755 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1445,9 +1445,12 @@ static int task_has_capability(struct task_struct *tsk,
 		BUG();
 	}
 
-	rc = avc_has_perm_noaudit(sid, sid, sclass, av, 0, &avd);
-	if (audit == SECURITY_CAP_AUDIT)
-		avc_audit(sid, sid, sclass, av, &avd, rc, &ad);
+	rc = avc_has_perm_noaudit(sid, sid, sclass, av, 0, &avd, 0);
+	if (audit == SECURITY_CAP_AUDIT) {
+		int rc2 = avc_audit(sid, sid, sclass, av, &avd, rc, &ad, 0);
+		if (rc2 == -ECHILD)
+			return rc2;
+	}
 	return rc;
 }
 
@@ -1467,7 +1470,8 @@ static int task_has_system(struct task_struct *tsk,
 static int inode_has_perm(const struct cred *cred,
 			  struct inode *inode,
 			  u32 perms,
-			  struct common_audit_data *adp)
+			  struct common_audit_data *adp,
+			  unsigned flags)
 {
 	struct inode_security_struct *isec;
 	struct common_audit_data ad;
@@ -1487,7 +1491,7 @@ static int inode_has_perm(const struct cred *cred,
 		ad.u.fs.inode = inode;
 	}
 
-	return avc_has_perm(sid, isec->sid, isec->sclass, perms, adp);
+	return avc_has_perm_flags(sid, isec->sid, isec->sclass, perms, adp, flags);
 }
 
 /* Same as inode_has_perm, but pass explicit audit data containing
@@ -1504,7 +1508,7 @@ static inline int dentry_has_perm(const struct cred *cred,
 	COMMON_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.path.mnt = mnt;
 	ad.u.fs.path.dentry = dentry;
-	return inode_has_perm(cred, inode, av, &ad);
+	return inode_has_perm(cred, inode, av, &ad, 0);
 }
 
 /* Check whether a task can use an open file descriptor to
@@ -1540,7 +1544,7 @@ static int file_has_perm(const struct cred *cred,
 	/* av is zero if only checking access to the descriptor. */
 	rc = 0;
 	if (av)
-		rc = inode_has_perm(cred, inode, av, &ad);
+		rc = inode_has_perm(cred, inode, av, &ad, 0);
 
 out:
 	return rc;
@@ -2103,7 +2107,7 @@ static inline void flush_unauthorized_files(const struct cred *cred,
 			file = file_priv->file;
 			inode = file->f_path.dentry->d_inode;
 			if (inode_has_perm(cred, inode,
-					   FILE__READ | FILE__WRITE, NULL)) {
+					   FILE__READ | FILE__WRITE, NULL, 0)) {
 				drop_tty = 1;
 			}
 		}
@@ -2649,10 +2653,6 @@ static int selinux_inode_permission(struct inode *inode, int mask, unsigned flag
 	if (!mask)
 		return 0;
 
-	/* May be droppable after audit */
-	if (flags & IPERM_FLAG_RCU)
-		return -ECHILD;
-
 	COMMON_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.inode = inode;
 
@@ -2661,7 +2661,7 @@ static int selinux_inode_permission(struct inode *inode, int mask, unsigned flag
 
 	perms = file_mask_to_av(inode->i_mode, mask);
 
-	return inode_has_perm(cred, inode, perms, &ad);
+	return inode_has_perm(cred, inode, perms, &ad, flags);
 }
 
 static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
@@ -3209,7 +3209,7 @@ static int selinux_dentry_open(struct file *file, const struct cred *cred)
 	 * new inode label or new policy.
 	 * This check is not redundant - do not remove.
 	 */
-	return inode_has_perm(cred, inode, open_file_to_av(file), NULL);
+	return inode_has_perm(cred, inode, open_file_to_av(file), NULL, 0);
 }
 
 /* task security operations */
diff --git a/security/selinux/include/avc.h b/security/selinux/include/avc.h
index 5615081..65d6e52 100644
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -54,21 +54,29 @@ struct avc_cache_stats {
 
 void __init avc_init(void);
 
-void avc_audit(u32 ssid, u32 tsid,
+int avc_audit(u32 ssid, u32 tsid,
 	       u16 tclass, u32 requested,
 	       struct av_decision *avd,
 	       int result,
-	       struct common_audit_data *a);
+	      struct common_audit_data *a, unsigned flags);
 
 #define AVC_STRICT 1 /* Ignore permissive mode. */
 int avc_has_perm_noaudit(u32 ssid, u32 tsid,
 			 u16 tclass, u32 requested,
 			 unsigned flags,
-			 struct av_decision *avd);
-
-int avc_has_perm(u32 ssid, u32 tsid,
-		 u16 tclass, u32 requested,
-		 struct common_audit_data *auditdata);
+			 struct av_decision *avd, unsigned vfsflags);
+
+int avc_has_perm_flags(u32 ssid, u32 tsid,
+		       u16 tclass, u32 requested,
+		       struct common_audit_data *auditdata,
+		       unsigned);
+
+static inline int avc_has_perm(u32 ssid, u32 tsid,
+			       u16 tclass, u32 requested,
+			       struct common_audit_data *auditdata)
+{
+	return avc_has_perm_flags(ssid, tsid, tclass, requested, auditdata, 0);
+}
 
 u32 avc_policy_seqno(void);
 
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 6ef4af4..4749202 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2212,7 +2212,7 @@ out_unlock:
 		rc = avc_has_perm_noaudit(fromsid, mysids[i],
 					  SECCLASS_PROCESS, /* kernel value */
 					  PROCESS__TRANSITION, AVC_STRICT,
-					  NULL);
+					  NULL, 0);
 		if (!rc)
 			mysids2[j++] = mysids[i];
 		cond_resched();
-- 
1.7.4.2

