Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1DVAYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:24:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:54018 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab1DVAYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:24:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,252,1301900400"; 
   d="scan'208";a="632359951"
From: Andi Kleen <andi@firstfloor.org>
To: linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, npiggin@kernel.dk, shaohua.li@intel.com,
        sds@tycho.nsa.gov, jmorris@namei.org,
        linux-security-module@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] SECURITY: Move exec_permission RCU checks into security modules
Date: Thu, 21 Apr 2011 17:23:19 -0700
Message-Id: <1303431801-10540-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
References: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Right now all RCU walks fall back to reference walk when CONFIG_SECURITY
is enabled, even though just the standard capability module is active.
This is because security_inode_exec_permission unconditionally fails
RCU walks.

Move this decision to the low level security module. This requires
passing the RCU flags down the security hook. This way at least
the capability module and a few easy cases in selinux/smack work
with RCU walks with CONFIG_SECURITY=y

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/security.h   |    2 +-
 security/capability.c      |    2 +-
 security/security.c        |    6 ++----
 security/selinux/hooks.c   |    6 +++++-
 security/smack/smack_lsm.c |    6 +++++-
 5 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index ca02f17..8ce59ef 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1456,7 +1456,7 @@ struct security_operations {
 			     struct inode *new_dir, struct dentry *new_dentry);
 	int (*inode_readlink) (struct dentry *dentry);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
-	int (*inode_permission) (struct inode *inode, int mask);
+	int (*inode_permission) (struct inode *inode, int mask, unsigned flags);
 	int (*inode_setattr)	(struct dentry *dentry, struct iattr *attr);
 	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
 	int (*inode_setxattr) (struct dentry *dentry, const char *name,
diff --git a/security/capability.c b/security/capability.c
index 2984ea4..bbb5115 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -181,7 +181,7 @@ static int cap_inode_follow_link(struct dentry *dentry,
 	return 0;
 }
 
-static int cap_inode_permission(struct inode *inode, int mask)
+static int cap_inode_permission(struct inode *inode, int mask, unsigned flags)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 1011423..4ba6d4c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -518,16 +518,14 @@ int security_inode_permission(struct inode *inode, int mask)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_permission(inode, mask);
+	return security_ops->inode_permission(inode, mask, 0);
 }
 
 int security_inode_exec_permission(struct inode *inode, unsigned int flags)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	if (flags)
-		return -ECHILD;
-	return security_ops->inode_permission(inode, MAY_EXEC);
+	return security_ops->inode_permission(inode, MAY_EXEC, flags);
 }
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f9c3764..a73f4e4 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2635,7 +2635,7 @@ static int selinux_inode_follow_link(struct dentry *dentry, struct nameidata *na
 	return dentry_has_perm(cred, NULL, dentry, FILE__READ);
 }
 
-static int selinux_inode_permission(struct inode *inode, int mask)
+static int selinux_inode_permission(struct inode *inode, int mask, unsigned flags)
 {
 	const struct cred *cred = current_cred();
 	struct common_audit_data ad;
@@ -2649,6 +2649,10 @@ static int selinux_inode_permission(struct inode *inode, int mask)
 	if (!mask)
 		return 0;
 
+	/* May be droppable after audit */
+	if (flags & IPERM_FLAG_RCU)
+		return -ECHILD;
+
 	COMMON_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.inode = inode;
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index c6f8fca..400a5d5 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -686,7 +686,7 @@ static int smack_inode_rename(struct inode *old_inode,
  *
  * Returns 0 if access is permitted, -EACCES otherwise
  */
-static int smack_inode_permission(struct inode *inode, int mask)
+static int smack_inode_permission(struct inode *inode, int mask, unsigned flags)
 {
 	struct smk_audit_info ad;
 
@@ -696,6 +696,10 @@ static int smack_inode_permission(struct inode *inode, int mask)
 	 */
 	if (mask == 0)
 		return 0;
+
+	/* May be droppable after audit */
+	if (flags & IPERM_FLAG_RCU)
+		return -ECHILD;
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_FS);
 	smk_ad_setfield_u_fs_inode(&ad, inode);
 	return smk_curacc(smk_of_inode(inode), mask, &ad);
-- 
1.7.4.2

