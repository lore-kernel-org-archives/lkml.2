Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2ENCr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:47:58 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48981 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab2ENCr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:47:56 -0400
From: Mimi Zohar <zohar@us.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] vfs: fix IMA lockdep circular locking dependency
Date: Sun, 13 May 2012 22:47:11 -0400
Message-Id: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
X-Mailer: git-send-email 1.7.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051402-5112-0000-0000-000007F80B91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

This patch has been updated to move the ima_file_mmap() call from
security_file_mmap() to the new vm_mmap() function.

---

The circular lockdep is caused by allocating the 'iint' for mmapped
files.  Originally when an 'iint' was allocated for every inode
in inode_alloc_security(), before the inode was accessible, no
locking was necessary.  Commits bc7d2a3e and 196f518 changed this
behavior and allocated the 'iint' on a per need basis, resulting in
the mmap_sem being taken before the i_mutex for mmapped files.

Possible unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
lock(&mm->mmap_sem);
                              lock(&sb->s_type->i_mutex_key);
                              lock(&mm->mmap_sem);
lock(&sb->s_type->i_mutex_key);

The existing security_file_mmap() hook is after the mmap_sem is taken.
This patch moves the ima_file_mmap() call from security_file_mmap() to
prior to the mmap_sem being taken.

Changelog v2:
- With commit "6be5ceb VM: add "vm_mmap()" helper function", moving the
ima_file_mmap() call is simplified.  This patch moves the ima_file_mmap()
call to vm_mmap(), and to binfmt_elf.c: elf_map().

Changelog v1:
- Instead of just pre-allocating the iint in a new hook, do ALL of the
work in the new/moved ima_file_mmap() hook. (Based on Eric Paris' suggestion.)
- Removed do_mmap_with_sem() helper function.
- export ima_file_mmap()

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Eric Paris <eparis@redhat.com>
---
 fs/binfmt_elf.c                   |    6 ++++++
 mm/mmap.c                         |   11 +++++++++++
 mm/nommu.c                        |   11 +++++++++++
 security/integrity/ima/ima_main.c |    1 +
 security/security.c               |    7 +------
 5 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 16f7354..0d0514f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -28,6 +28,7 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/security.h>
+#include <linux/ima.h>
 #include <linux/random.h>
 #include <linux/elf.h>
 #include <linux/utsname.h>
@@ -321,6 +322,7 @@ static unsigned long elf_map(struct file *filep, unsigned long addr,
 	unsigned long map_addr;
 	unsigned long size = eppnt->p_filesz + ELF_PAGEOFFSET(eppnt->p_vaddr);
 	unsigned long off = eppnt->p_offset - ELF_PAGEOFFSET(eppnt->p_vaddr);
+	unsigned long ret;
 	addr = ELF_PAGESTART(addr);
 	size = ELF_PAGEALIGN(size);
 
@@ -329,6 +331,10 @@ static unsigned long elf_map(struct file *filep, unsigned long addr,
 	if (!size)
 		return addr;
 
+	ret = ima_file_mmap(filep, prot);
+	if (ret < 0)
+		return ret;
+
 	down_write(&current->mm->mmap_sem);
 	/*
 	* total_size is the size of the ELF (interpreter) image.
diff --git a/mm/mmap.c b/mm/mmap.c
index 848ef52..87e6948 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -20,6 +20,7 @@
 #include <linux/fs.h>
 #include <linux/personality.h>
 #include <linux/security.h>
+#include <linux/ima.h>
 #include <linux/hugetlb.h>
 #include <linux/profile.h>
 #include <linux/export.h>
@@ -1109,9 +1110,14 @@ unsigned long vm_mmap(struct file *file, unsigned long addr,
 	unsigned long ret;
 	struct mm_struct *mm = current->mm;
 
+	ret = ima_file_mmap(file, prot);
+	if (ret < 0)
+		goto err;
+
 	down_write(&mm->mmap_sem);
 	ret = do_mmap(file, addr, len, prot, flag, offset);
 	up_write(&mm->mmap_sem);
+err:
 	return ret;
 }
 EXPORT_SYMBOL(vm_mmap);
@@ -1147,10 +1153,15 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
+	retval = ima_file_mmap(file, prot);
+	if (retval < 0)
+		goto err_out;
+
 	down_write(&current->mm->mmap_sem);
 	retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
 	up_write(&current->mm->mmap_sem);
 
+err_out:
 	if (file)
 		fput(file);
 out:
diff --git a/mm/nommu.c b/mm/nommu.c
index bb8f4f0..2b13bd3 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -27,6 +27,7 @@
 #include <linux/mount.h>
 #include <linux/personality.h>
 #include <linux/security.h>
+#include <linux/ima.h>
 #include <linux/syscalls.h>
 #include <linux/audit.h>
 
@@ -1490,9 +1491,14 @@ unsigned long vm_mmap(struct file *file, unsigned long addr,
 	unsigned long ret;
 	struct mm_struct *mm = current->mm;
 
+	ret = ima_file_mmap(file, prot);
+	if (ret < 0)
+		goto err;
+
 	down_write(&mm->mmap_sem);
 	ret = do_mmap(file, addr, len, prot, flag, offset);
 	up_write(&mm->mmap_sem);
+err:
 	return ret;
 }
 EXPORT_SYMBOL(vm_mmap);
@@ -1513,10 +1519,15 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
+	retval = ima_file_mmap(file, prot);
+	if (retval < 0)
+		goto err_out;
+
 	down_write(&current->mm->mmap_sem);
 	retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
 	up_write(&current->mm->mmap_sem);
 
+err_out:
 	if (file)
 		fput(file);
 out:
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index b17be79..91eda7f 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -176,6 +176,7 @@ int ima_file_mmap(struct file *file, unsigned long prot)
 					 MAY_EXEC, FILE_MMAP);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ima_file_mmap);
 
 /**
  * ima_bprm_check - based on policy, collect/store measurement.
diff --git a/security/security.c b/security/security.c
index bf619ff..e50bbf4 100644
--- a/security/security.c
+++ b/security/security.c
@@ -661,12 +661,7 @@ int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
 			unsigned long addr, unsigned long addr_only)
 {
-	int ret;
-
-	ret = security_ops->file_mmap(file, reqprot, prot, flags, addr, addr_only);
-	if (ret)
-		return ret;
-	return ima_file_mmap(file, prot);
+	return security_ops->file_mmap(file, reqprot, prot, flags, addr, addr_only);
 }
 
 int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
-- 
1.7.7.6

