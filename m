Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab1FTTKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:10:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48885 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab1FTTKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UrLJ5/uxXEwZS1Bh/7OH6biAeWOl0KARrB8UoM7pwefRk2VyW8cvMBaq+SrLldICrJ
         ICLMEPs5DZwM1icy1dQlvdJKBjVtMFA7j6kzj6j5X2TrKo4+2P2AqpmI1QkXePMiaGEm
         LeGULfLq9bJS7Sn95atErxy/EM6z4vMXUIH7k=
Date: Mon, 20 Jun 2011 23:10:07 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        apparmor@lists.ubuntu.com,
        "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        John Johansen <john.johansen@canonical.com>,
        kernel-hardening@lists.openwall.com, serge@hallyn.com
Subject: [RFC v3 1/2] security: add task argument to security_capable()
Message-ID: <20110620191007.GA10978@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes security_capable() to use explicit task
argument instead of current.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 drivers/pci/pci-sysfs.c  |    5 ++++-
 include/linux/security.h |    8 ++++----
 kernel/capability.c      |    2 +-
 security/security.c      |    6 +++---
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 7bcf12a..bc52c66 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -431,7 +431,10 @@ pci_read_config(struct file *filp, struct kobject *kobj,
 	u8 *data = (u8*) buf;
 
 	/* Several chips lock up trying to read undefined config space */
-	if (security_capable(&init_user_ns, filp->f_cred, CAP_SYS_ADMIN) == 0) {
+	if (security_capable(current,
+			     &init_user_ns,
+			     filp->f_cred,
+			     CAP_SYS_ADMIN) == 0) {
 		size = dev->cfg_size;
 	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 		size = 128;
diff --git a/include/linux/security.h b/include/linux/security.h
index 8ce59ef..8509dbf 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1667,8 +1667,8 @@ int security_capset(struct cred *new, const struct cred *old,
 		    const kernel_cap_t *effective,
 		    const kernel_cap_t *inheritable,
 		    const kernel_cap_t *permitted);
-int security_capable(struct user_namespace *ns, const struct cred *cred,
-			int cap);
+int security_capable(struct task_struct *task, struct user_namespace *ns,
+		     const struct cred *cred, int cap);
 int security_real_capable(struct task_struct *tsk, struct user_namespace *ns,
 			int cap);
 int security_real_capable_noaudit(struct task_struct *tsk,
@@ -1865,10 +1865,10 @@ static inline int security_capset(struct cred *new,
 	return cap_capset(new, old, effective, inheritable, permitted);
 }
 
-static inline int security_capable(struct user_namespace *ns,
+static inline int security_capable(struct task_struct *task, struct user_namespace *ns,
 				   const struct cred *cred, int cap)
 {
-	return cap_capable(current, cred, ns, cap, SECURITY_CAP_AUDIT);
+	return cap_capable(task, cred, ns, cap, SECURITY_CAP_AUDIT);
 }
 
 static inline int security_real_capable(struct task_struct *tsk, struct user_namespace *ns, int cap)
diff --git a/kernel/capability.c b/kernel/capability.c
index 283c529..91c2278 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -374,7 +374,7 @@ bool ns_capable(struct user_namespace *ns, int cap)
 		BUG();
 	}
 
-	if (security_capable(ns, current_cred(), cap) == 0) {
+	if (security_capable(current, ns, current_cred(), cap) == 0) {
 		current->flags |= PF_SUPERPRIV;
 		return true;
 	}
diff --git a/security/security.c b/security/security.c
index 4ba6d4c..dd16397 100644
--- a/security/security.c
+++ b/security/security.c
@@ -154,10 +154,10 @@ int security_capset(struct cred *new, const struct cred *old,
 				    effective, inheritable, permitted);
 }
 
-int security_capable(struct user_namespace *ns, const struct cred *cred,
-		     int cap)
+int security_capable(struct task_struct *task, struct user_namespace *ns,
+		     const struct cred *cred, int cap)
 {
-	return security_ops->capable(current, cred, ns, cap,
+	return security_ops->capable(task, cred, ns, cap,
 				     SECURITY_CAP_AUDIT);
 }
 
---
