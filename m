Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1K3W3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 17:29:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36303 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1K3W3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 17:29:07 -0500
Date: Wed, 30 Nov 2011 22:29:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC][PATCH] trimming includes from linux/security.h
Message-ID: <20111130222903.GX2203@ZenIV.linux.org.uk>
References: <20111130065000.GT2203@ZenIV.linux.org.uk>
 <CAP=VYLozbbfO=90GxuGe9k_V6OghwFdR3uVE-=dpX5be4qPhgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP=VYLozbbfO=90GxuGe9k_V6OghwFdR3uVE-=dpX5be4qPhgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 03:41:04PM -0500, Paul Gortmaker wrote:
> A proper fix would be to somehow really make security.h  a real
> standalone header, via using defines instead of inlines or similar?

Whee... that says something about the amount of places pulling sched.h,
doesn't it?  FWIW, looking at that stuff makes me really wonder why
the hell do we have 3 functions there...  Look: on LSM-infested builds
we get
int security_vm_enough_memory(long pages)
{
        WARN_ON(current->mm == NULL);
        return security_ops->vm_enough_memory(current->mm, pages);
}
int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
{
        WARN_ON(mm == NULL);
        return security_ops->vm_enough_memory(mm, pages);
}
int security_vm_enough_memory_kern(long pages)
{
        /* If current->mm is a kernel thread then we will pass NULL,
           for this specific case that is fine */
        return security_ops->vm_enough_memory(current->mm, pages);
}
and on LSM-free ones
static inline int security_vm_enough_memory(long pages)
{
        WARN_ON(current->mm == NULL);
        return cap_vm_enough_memory(current->mm, pages);
}
static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
{
        WARN_ON(mm == NULL);
        return cap_vm_enough_memory(mm, pages);
}
static inline int security_vm_enough_memory_kern(long pages)
{
        /* If current->mm is a kernel thread then we will pass NULL,
           for this specific case that is fine */
        return cap_vm_enough_memory(current->mm, pages);
}

and looking at the callers, we get this:
	* mmap_region() calls ..._enough_memory(); current->mm has been
already read to local variable and we'd've oopsed already if it had been
NULL.  If anything, that's BUG_ON(!mm) in the beginning of function...
	* do_brk() - ditto.  Just before that call we have
        if (mm->map_count > sysctl_max_map_count)
                return -ENOMEM;
which renders that WARN_ON() rather pointless.
	* mprotect_fixup() - probably a bug, unless it's always called with
vma->vm_mm == current->mm.  Should it call ..._enough_memory_mm() instead?
Looking through the callers shows:
		+ mprotect(2) - we are guaranteed that, all right (and
incidentally we oops if current->mm is NULL; down_write(&current->mm->mmap_sem)
is done first).
		+ setup_arg_pages() - we rely on bprm->vma->mm ==
current->mm here.  And we oops first if it happens to be NULL.  bprm->vma
is set in __bprm_mm_init() and its ->mm is set to bprm->mm we used to have
at that point.  Which couldn't have been NULL *and* is what current->mm is
set to by flush_old_exec().  So we are OK as long as all setup_arg_pages()
follow a successful flush_old_exec() on the same bprm.  Which is true for
all callers (all are ->load_binary() instances).
	So we are actually OK, except that I'd still used ..._enough_memory_mm()
in mprotect_fixup() - will be much easier to verify that what we are doing is
correct, without detours through weird places.
	* vma_to_resize() - current->mm in local variable and we bugger
off to Efault first if it happens to be NULL.
	* acct_stack_growth() - calls ..._enough_memory_mm(), and if mm
happens to be NULL, well, we'd already accessed mm->total_vm, so that
WARN_ON() is too late for anything.
	* insert_vm_struct() - calls ..._enough_memory_mm(), oopses before
that point if mm is NULL (read from mm->mm_rb.rb_node in find_vma_prepare())
	* sys_swapoff() - root-only syscall and we'd better not have it
called with current->mm == NULL.
	* dup_mmap() - ..._enough_memory() is called; shouldn't that
be ..._enough_memory_mm() instead?  I really wonder about that one -
here we end up passing old ->mm to __vm_enough_memory().  Is that the
right thing to do?


Frankly, I would very much prefer to reduce these 3 functions to one
(..._mm() variant, sans the WARN_ON()) and had callers pass current->mm
explicitly.  I.e. something like this (preserving the current behaviour):

collapse security_vm_enough_memory() variants together

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/linux/security.h b/include/linux/security.h
index fab3d99..384485e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1683,9 +1683,7 @@ int security_quotactl(int cmds, int type, int id, struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
 int security_settime(const struct timespec *ts, const struct timezone *tz);
-int security_vm_enough_memory(long pages);
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
-int security_vm_enough_memory_kern(long pages);
 int security_bprm_set_creds(struct linux_binprm *bprm);
 int security_bprm_check(struct linux_binprm *bprm);
 void security_bprm_committing_creds(struct linux_binprm *bprm);
@@ -1923,25 +1921,11 @@ static inline int security_settime(const struct timespec *ts,
 	return cap_settime(ts, tz);
 }
 
-static inline int security_vm_enough_memory(long pages)
-{
-	WARN_ON(current->mm == NULL);
-	return cap_vm_enough_memory(current->mm, pages);
-}
-
 static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
-	WARN_ON(mm == NULL);
 	return cap_vm_enough_memory(mm, pages);
 }
 
-static inline int security_vm_enough_memory_kern(long pages)
-{
-	/* If current->mm is a kernel thread then we will pass NULL,
-	   for this specific case that is fine */
-	return cap_vm_enough_memory(current->mm, pages);
-}
-
 static inline int security_bprm_set_creds(struct linux_binprm *bprm)
 {
 	return cap_bprm_set_creds(bprm);
diff --git a/kernel/fork.c b/kernel/fork.c
index da4a6a1..dac8e63 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -351,7 +351,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		charge = 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
 			unsigned int len = (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
-			if (security_vm_enough_memory(len))
+			if (security_vm_enough_memory_mm(oldmm, len)) /* sic */
 				goto fail_nomem;
 			charge = len;
 		}
diff --git a/mm/mmap.c b/mm/mmap.c
index 28efb6d..a6900f8 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1248,7 +1248,7 @@ munmap_back:
 	 */
 	if (accountable_mapping(file, vm_flags)) {
 		charged = len >> PAGE_SHIFT;
-		if (security_vm_enough_memory(charged))
+		if (security_vm_enough_memory_mm(mm, charged))
 			return -ENOMEM;
 		vm_flags |= VM_ACCOUNT;
 	}
@@ -2202,7 +2202,7 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	if (mm->map_count > sysctl_max_map_count)
 		return -ENOMEM;
 
-	if (security_vm_enough_memory(len >> PAGE_SHIFT))
+	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
 	/* Can we just expand an old private anonymous mapping? */
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 5a688a2..9599fa2 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -168,7 +168,7 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 		if (!(oldflags & (VM_ACCOUNT|VM_WRITE|VM_HUGETLB|
 						VM_SHARED|VM_NORESERVE))) {
 			charged = nrpages;
-			if (security_vm_enough_memory(charged))
+			if (security_vm_enough_memory_mm(mm, charged))
 				return -ENOMEM;
 			newflags |= VM_ACCOUNT;
 		}
diff --git a/mm/mremap.c b/mm/mremap.c
index d6959cb..eb6f39d 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -320,7 +320,7 @@ static struct vm_area_struct *vma_to_resize(unsigned long addr,
 
 	if (vma->vm_flags & VM_ACCOUNT) {
 		unsigned long charged = (new_len - old_len) >> PAGE_SHIFT;
-		if (security_vm_enough_memory(charged))
+		if (security_vm_enough_memory_mm(mm, charged))
 			goto Efault;
 		*p = charged;
 	}
diff --git a/mm/shmem.c b/mm/shmem.c
index c288256..262e495 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -127,7 +127,7 @@ static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
 static inline int shmem_acct_size(unsigned long flags, loff_t size)
 {
 	return (flags & VM_NORESERVE) ?
-		0 : security_vm_enough_memory_kern(VM_ACCT(size));
+		0 : security_vm_enough_memory_mm(current->mm, VM_ACCT(size));
 }
 
 static inline void shmem_unacct_size(unsigned long flags, loff_t size)
@@ -145,7 +145,7 @@ static inline void shmem_unacct_size(unsigned long flags, loff_t size)
 static inline int shmem_acct_block(unsigned long flags)
 {
 	return (flags & VM_NORESERVE) ?
-		security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE)) : 0;
+		security_vm_enough_memory_mm(current->mm, VM_ACCT(PAGE_CACHE_SIZE)) : 0;
 }
 
 static inline void shmem_unacct_blocks(unsigned long flags, long pages)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b1cd120..f678b98 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1562,6 +1562,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	BUG_ON(!current->mm);
+
 	pathname = getname(specialfile);
 	err = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
@@ -1589,7 +1591,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		spin_unlock(&swap_lock);
 		goto out_dput;
 	}
-	if (!security_vm_enough_memory(p->pages))
+	if (!security_vm_enough_memory_mm(current->mm, p->pages))
 		vm_unacct_memory(p->pages);
 	else {
 		err = -ENOMEM;
diff --git a/security/security.c b/security/security.c
index f5f2df2..6b9e648 100644
--- a/security/security.c
+++ b/security/security.c
@@ -208,25 +208,11 @@ int security_settime(const struct timespec *ts, const struct timezone *tz)
 	return security_ops->settime(ts, tz);
 }
 
-int security_vm_enough_memory(long pages)
-{
-	WARN_ON(current->mm == NULL);
-	return security_ops->vm_enough_memory(current->mm, pages);
-}
-
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
-	WARN_ON(mm == NULL);
 	return security_ops->vm_enough_memory(mm, pages);
 }
 
-int security_vm_enough_memory_kern(long pages)
-{
-	/* If current->mm is a kernel thread then we will pass NULL,
-	   for this specific case that is fine */
-	return security_ops->vm_enough_memory(current->mm, pages);
-}
-
 int security_bprm_set_creds(struct linux_binprm *bprm)
 {
 	return security_ops->bprm_set_creds(bprm);
