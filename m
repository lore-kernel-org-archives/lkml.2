Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1JUVsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 17:48:08 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:40148 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1JUVsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 17:48:06 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Oct 2011 17:48:06 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/lkml
CC: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, selinux@tycho.nsa.gov,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] LSM: Do not apply mmap_min_addr check to PROT_NONE mappings
X-Windows: form follows malfunction.
Message-Id: <20111021213916.914462C0A5@topped-with-meat.com>
Date: Fri, 21 Oct 2011 14:39:16 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=fe7WOzsF c=1 sm=1 a=ZDme2XLiiH0A:10
		a=kj9zAlcOel0A:10 a=hOe2yjtxAAAA:8 a=-vePlRyWxTST9IrOb0oA:9
		a=kTwKQkNoINoqp1dcbTMA:7 a=CjuIK1q_8ugA:10 a=q1Xwa7CiaDdQKT98:21
		a=TVmYOR459IlvUwRk:21 a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An mmap with PROT_NONE is done specifically to ensure that an address will
fault.  So doing this on addresses below mmap_min_addr is not seeking a
"dangerous" operation.  Conversely, it's an attempt to ensure robustness in
case mmap_min_addr is less restrictive than the user wants to be.

Since we might let a low mapping exist at all without a check, we add
another check to prevent mprotect from granting access to such a mapping.

Signed-off-by: Roland McGrath <roland@hack.frob.com>
---
 include/linux/security.h |    5 ++-
 security/apparmor/lsm.c  |    7 ++++++
 security/capability.c    |    6 -----
 security/commoncap.c     |   48 ++++++++++++++++++++++++++++++++++++---------
 security/selinux/hooks.c |    8 ++++++-
 5 files changed, 55 insertions(+), 19 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index ebd2a53..aba8071 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -73,6 +73,8 @@ extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_file_mmap(struct file *file, unsigned long reqprot,
 			 unsigned long prot, unsigned long flags,
 			 unsigned long addr, unsigned long addr_only);
+extern int cap_file_mprotect(struct vm_area_struct *vma,
+			     unsigned long reqprot, unsigned long prot);
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
@@ -2213,7 +2215,7 @@ static inline int security_file_mprotect(struct vm_area_struct *vma,
 					 unsigned long reqprot,
 					 unsigned long prot)
 {
-	return 0;
+	return cap_file_mprotect(vma, reqprot, prot);
 }
 
 static inline int security_file_lock(struct file *file, unsigned int cmd)
@@ -3044,4 +3046,3 @@ static inline void free_secdata(void *secdata)
 #endif /* CONFIG_SECURITY */
 
 #endif /* ! __LINUX_SECURITY_H */
-
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 3783202..d2a9693 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -508,6 +508,13 @@ static int apparmor_file_mmap(struct file *file, unsigned long reqprot,
 static int apparmor_file_mprotect(struct vm_area_struct *vma,
 				  unsigned long reqprot, unsigned long prot)
 {
+        int rc;
+
+	/* do DAC check */
+	rc = cap_file_mprotect(vma, reqprot, prot);
+	if (rc)
+		return rc;
+
 	return common_mmap(OP_FMPROT, vma->vm_file, prot,
 			   !(vma->vm_flags & VM_SHARED) ? MAP_PRIVATE : 0);
 }
diff --git a/security/capability.c b/security/capability.c
index 2984ea4..3c60f07 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -316,12 +316,6 @@ static int cap_file_ioctl(struct file *file, unsigned int command,
 	return 0;
 }
 
-static int cap_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
-			     unsigned long prot)
-{
-	return 0;
-}
-
 static int cap_file_lock(struct file *file, unsigned int cmd)
 {
 	return 0;
diff --git a/security/commoncap.c b/security/commoncap.c
index a93b3b7..0d4685a 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -942,11 +942,26 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
+static int cap_mmap_min_addr(unsigned long addr)
+{
+	int ret = 0;
+
+	if (addr < dac_mmap_min_addr) {
+		ret = cap_capable(current, current_cred(), &init_user_ns,
+				  CAP_SYS_RAWIO, SECURITY_CAP_AUDIT);
+		/* set PF_SUPERPRIV if it turns out we allow the low mmap */
+		if (ret == 0)
+			current->flags |= PF_SUPERPRIV;
+	}
+
+	return ret;
+}
+
 /*
  * cap_file_mmap - check if able to map given addr
  * @file: unused
  * @reqprot: unused
- * @prot: unused
+ * @prot: protection being requested
  * @flags: unused
  * @addr: address attempting to be mapped
  * @addr_only: unused
@@ -960,14 +975,27 @@ int cap_file_mmap(struct file *file, unsigned long reqprot,
 		  unsigned long prot, unsigned long flags,
 		  unsigned long addr, unsigned long addr_only)
 {
-	int ret = 0;
+	if (addr_only || prot != PROT_NONE)
+		return cap_mmap_min_addr(addr);
+	return 0;
+}
 
-	if (addr < dac_mmap_min_addr) {
-		ret = cap_capable(current, current_cred(), &init_user_ns, CAP_SYS_RAWIO,
-				  SECURITY_CAP_AUDIT);
-		/* set PF_SUPERPRIV if it turns out we allow the low mmap */
-		if (ret == 0)
-			current->flags |= PF_SUPERPRIV;
-	}
-	return ret;
+/*
+ * cap_file_mprotect - check if able to mprotect given addr
+ * @vma: entry being changed
+ * @reqprot: unused
+ * @prot: protection being changed to
+ *
+ * If the process is attempting to change memory below dac_mmap_min_addr to
+ * anything but PROT_NONE, they need CAP_SYS_RAWIO.  The other parameters
+ * to this function are unused by the capability security module.  Returns
+ * 0 if this mapping should be allowed -EPERM if not.
+ */
+int cap_file_mprotect(struct vm_area_struct *vma,
+		      unsigned long reqprot,
+		      unsigned long prot)
+{
+	if (prot != PROT_NONE)
+		return cap_mmap_min_addr(vma->vm_start);
+	return 0;
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 266a229..76e6f04 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3086,13 +3086,19 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 				 unsigned long prot)
 {
 	const struct cred *cred = current_cred();
+	int rc;
 
 	if (selinux_checkreqprot)
 		prot = reqprot;
 
+	/* do DAC check on address space usage */
+	rc = cap_file_mprotect(vma, reqprot, prot)
+	if (rc)
+		return rc;
+
 	if (default_noexec &&
 	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
-		int rc = 0;
+		rc = 0;
 		if (vma->vm_start >= vma->vm_mm->start_brk &&
 		    vma->vm_end <= vma->vm_mm->brk) {
 			rc = cred_has_perm(cred, cred, PROCESS__EXECHEAP);
