Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab0EYSR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:17:59 -0400
Received: from kroah.org ([198.145.64.141]:44433 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933511Ab0EYSRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:17:40 -0400
X-Mailbox-Line: From gregkh@clark.site Tue May 25 11:12:14 2010
Message-Id: <20100525181214.531527016@clark.site>
User-Agent: quilt/0.48-8.10
Date: Tue, 25 May 2010 11:09:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Morris <jmorris@namei.org>, Alan Cox <alan@redhat.com>
Subject: [25/25] nfsd: fix vm overcommit crash
In-Reply-To: <20100525181259.GA18630@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@redhat.com>

commit 731572d39fcd3498702eda4600db4c43d51e0b26 upstream.

Junjiro R.  Okajima reported a problem where knfsd crashes if you are
using it to export shmemfs objects and run strict overcommit.  In this
situation the current->mm based modifier to the overcommit goes through a
NULL pointer.

We could simply check for NULL and skip the modifier but we've caught
other real bugs in the past from mm being NULL here - cases where we did
need a valid mm set up (eg the exec bug about a year ago).

To preserve the checks and get the logic we want shuffle the checking
around and add a new helper to the vm_ security wrappers

Also fix a current->mm reference in nommu that should use the passed mm

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix build]
Reported-by: Junjiro R. Okajima <hooanon05@yahoo.co.jp>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/security.h |    6 ++++++
 mm/mmap.c                |    3 ++-
 mm/nommu.c               |    3 ++-
 mm/shmem.c               |    8 ++++----
 security/security.c      |    9 +++++++++
 5 files changed, 23 insertions(+), 6 deletions(-)

--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1590,6 +1590,7 @@ int security_syslog(int type);
 int security_settime(struct timespec *ts, struct timezone *tz);
 int security_vm_enough_memory(long pages);
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
+int security_vm_enough_memory_kern(long pages);
 int security_bprm_alloc(struct linux_binprm *bprm);
 void security_bprm_free(struct linux_binprm *bprm);
 void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
@@ -1824,6 +1825,11 @@ static inline int security_vm_enough_mem
 {
 	return cap_vm_enough_memory(current->mm, pages);
 }
+
+static inline int security_vm_enough_memory_kern(long pages)
+{
+	return cap_vm_enough_memory(current->mm, pages);
+}
 
 static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -178,7 +178,8 @@ int __vm_enough_memory(struct mm_struct
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= mm->total_vm / 32;
+	if (mm)
+		allowed -= mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1432,7 +1432,8 @@ int __vm_enough_memory(struct mm_struct
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= current->mm->total_vm / 32;
+	if (mm)
+		allowed -= mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -163,8 +163,8 @@ static inline struct shmem_sb_info *SHME
  */
 static inline int shmem_acct_size(unsigned long flags, loff_t size)
 {
-	return (flags & VM_ACCOUNT)?
-		security_vm_enough_memory(VM_ACCT(size)): 0;
+	return (flags & VM_ACCOUNT) ?
+		security_vm_enough_memory_kern(VM_ACCT(size)) : 0;
 }
 
 static inline void shmem_unacct_size(unsigned long flags, loff_t size)
@@ -181,8 +181,8 @@ static inline void shmem_unacct_size(uns
  */
 static inline int shmem_acct_block(unsigned long flags)
 {
-	return (flags & VM_ACCOUNT)?
-		0: security_vm_enough_memory(VM_ACCT(PAGE_CACHE_SIZE));
+	return (flags & VM_ACCOUNT) ?
+		0 : security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE));
 }
 
 static inline void shmem_unacct_blocks(unsigned long flags, long pages)
--- a/security/security.c
+++ b/security/security.c
@@ -195,14 +195,23 @@ int security_settime(struct timespec *ts
 
 int security_vm_enough_memory(long pages)
 {
+	WARN_ON(current->mm == NULL);
 	return security_ops->vm_enough_memory(current->mm, pages);
 }
 
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
+	WARN_ON(mm == NULL);
 	return security_ops->vm_enough_memory(mm, pages);
 }
 
+int security_vm_enough_memory_kern(long pages)
+{
+	/* If current->mm is a kernel thread then we will pass NULL,
+	   for this specific case that is fine */
+	return security_ops->vm_enough_memory(current->mm, pages);
+}
+
 int security_bprm_alloc(struct linux_binprm *bprm)
 {
 	return security_ops->bprm_alloc_security(bprm);


