Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1DYU12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:27:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562Ab1DYU1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:27:25 -0400
From: Eric Paris <eparis@redhat.com>
To: andi@firstfloor.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk, shaohua.li@intel.com, sds@tycho.nsa.gov,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, Eric Paris <eparis@redhat.com>
Subject: [PATCH] SELINUX: Make selinux cache VFS RCU walks safe
Date: Mon, 25 Apr 2011 16:26:29 -0400
Message-Id: <1303763189-26748-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the security modules can decide whether they support the
dcache RCU walk or not it's possible to make selinux a bit more
RCU friendly.  The SELinux AVC and security server access decision
code is RCU safe.  A specific piece of the LSM audit code may not
be RCU safe.

This patch makes the VFS RCU walk retry if it would hit the non RCU
safe chunk of code.  It will normally just work under RCU.  This is
done simply by passing the VFS RCU state as a flag down into the
avc_audit() code and returning ECHILD there if it would have an issue.

Based-on-patch-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 security/selinux/avc.c         |   36 +++++++++++++++++++++++++++++-------
 security/selinux/hooks.c       |   26 +++++++++++++-------------
 security/selinux/include/avc.h |   18 +++++++++++++-----
 3 files changed, 55 insertions(+), 25 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 9da6420..1d027e2 100644
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
@@ -515,11 +517,24 @@ void avc_audit(u32 ssid, u32 tsid,
 	else
 		audited = requested & avd->auditallow;
 	if (!audited)
-		return;
+		return 0;
+
 	if (!a) {
 		a = &stack_data;
 		COMMON_AUDIT_DATA_INIT(a, NONE);
 	}
+
+	/*
+	 * When in a RCU walk do the audit on the RCU retry.  This is because
+	 * the collection of the dname in an inode audit message is not RCU
+	 * safe.  Note this may drop some audits when the situation changes
+	 * during retry. However this is logically just as if the operation
+	 * happened a little later.
+	 */
+	if ((a->type == LSM_AUDIT_DATA_FS) &&
+	    (flags & IPERM_FLAG_RCU))
+		return -ECHILD;
+
 	a->selinux_audit_data.tclass = tclass;
 	a->selinux_audit_data.requested = requested;
 	a->selinux_audit_data.ssid = ssid;
@@ -529,6 +544,7 @@ void avc_audit(u32 ssid, u32 tsid,
 	a->lsm_pre_audit = avc_audit_pre_callback;
 	a->lsm_post_audit = avc_audit_post_callback;
 	common_lsm_audit(a);
+	return 0;
 }
 
 /**
@@ -793,6 +809,7 @@ int avc_has_perm_noaudit(u32 ssid, u32 tsid,
  * @tclass: target security class
  * @requested: requested permissions, interpreted based on @tclass
  * @auditdata: auxiliary audit data
+ * @flags: VFS walk flags
  *
  * Check the AVC to determine whether the @requested permissions are granted
  * for the SID pair (@ssid, @tsid), interpreting the permissions
@@ -802,14 +819,19 @@ int avc_has_perm_noaudit(u32 ssid, u32 tsid,
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
+	int rc, rc2;
 
 	rc = avc_has_perm_noaudit(ssid, tsid, tclass, requested, 0, &avd);
-	avc_audit(ssid, tsid, tclass, requested, &avd, rc, auditdata);
+
+	rc2 = avc_audit(ssid, tsid, tclass, requested, &avd, rc, auditdata,
+			flags);
+	if (rc2)
+		return rc2;
 	return rc;
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9a220be..ed5f29a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1447,8 +1447,11 @@ static int task_has_capability(struct task_struct *tsk,
 	}
 
 	rc = avc_has_perm_noaudit(sid, sid, sclass, av, 0, &avd);
-	if (audit == SECURITY_CAP_AUDIT)
-		avc_audit(sid, sid, sclass, av, &avd, rc, &ad);
+	if (audit == SECURITY_CAP_AUDIT) {
+		int rc2 = avc_audit(sid, sid, sclass, av, &avd, rc, &ad, 0);
+		if (rc2)
+			return rc2;
+	}
 	return rc;
 }
 
@@ -1468,7 +1471,8 @@ static int task_has_system(struct task_struct *tsk,
 static int inode_has_perm(const struct cred *cred,
 			  struct inode *inode,
 			  u32 perms,
-			  struct common_audit_data *adp)
+			  struct common_audit_data *adp,
+			  unsigned flags)
 {
 	struct inode_security_struct *isec;
 	struct common_audit_data ad;
@@ -1488,7 +1492,7 @@ static int inode_has_perm(const struct cred *cred,
 		ad.u.fs.inode = inode;
 	}
 
-	return avc_has_perm(sid, isec->sid, isec->sclass, perms, adp);
+	return avc_has_perm_flags(sid, isec->sid, isec->sclass, perms, adp, flags);
 }
 
 /* Same as inode_has_perm, but pass explicit audit data containing
@@ -1505,7 +1509,7 @@ static inline int dentry_has_perm(const struct cred *cred,
 	COMMON_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.path.mnt = mnt;
 	ad.u.fs.path.dentry = dentry;
-	return inode_has_perm(cred, inode, av, &ad);
+	return inode_has_perm(cred, inode, av, &ad, 0);
 }
 
 /* Check whether a task can use an open file descriptor to
@@ -1541,7 +1545,7 @@ static int file_has_perm(const struct cred *cred,
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
@@ -3208,7 +3208,7 @@ static int selinux_dentry_open(struct file *file, const struct cred *cred)
 	 * new inode label or new policy.
 	 * This check is not redundant - do not remove.
 	 */
-	return inode_has_perm(cred, inode, open_file_to_av(file), NULL);
+	return inode_has_perm(cred, inode, open_file_to_av(file), NULL, 0);
 }
 
 /* task security operations */
diff --git a/security/selinux/include/avc.h b/security/selinux/include/avc.h
index 5615081..e77b2ac 100644
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -54,11 +54,11 @@ struct avc_cache_stats {
 
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
@@ -66,9 +66,17 @@ int avc_has_perm_noaudit(u32 ssid, u32 tsid,
 			 unsigned flags,
 			 struct av_decision *avd);
 
-int avc_has_perm(u32 ssid, u32 tsid,
-		 u16 tclass, u32 requested,
-		 struct common_audit_data *auditdata);
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
 
-- 
1.7.1

