Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab2AXRiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:38:25 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43131 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab2AXRiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:38:23 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v1] vfs: fix IMA lockdep circular locking dependency
Date: Tue, 24 Jan 2012 12:34:32 -0500
Message-Id: <1327426472-25275-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012417-7282-0000-0000-000005E38091
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Changelog v1:
- Instead of just pre-allocating the iint in a new hook, do ALL of the
work in the new/moved ima_file_mmap() hook. (Based on Eric Paris' suggestion.)
- Removed do_mmap_with_sem() helper function.
- export ima_file_mmap()

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 arch/x86/ia32/ia32_aout.c         |   12 ++++++++++++
 fs/binfmt_aout.c                  |   12 ++++++++++++
 fs/binfmt_elf.c                   |   10 ++++++++++
 fs/binfmt_flat.c                  |    6 ++++++
 fs/binfmt_som.c                   |    6 ++++++
 mm/mmap.c                         |    6 ++++++
 mm/nommu.c                        |    6 ++++++
 security/integrity/ima/ima_main.c |    1 +
 security/security.c               |    7 +------
 9 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index fd84387..7e44352 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -25,6 +25,7 @@
 #include <linux/personality.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
+#include <linux/ima.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -380,6 +381,13 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			goto beyond_if;
 		}
 
+		error = ima_file_mmap(bprm->file,
+				      PROT_READ | PROT_WRITE | PROT_EXEC);
+		if (error < 0) {
+			send_sig(SIGKILL, current, 0);
+			return error;
+		}
+
 		down_write(&current->mm->mmap_sem);
 		error = do_mmap(bprm->file, N_TXTADDR(ex), ex.a_text,
 				PROT_READ | PROT_EXEC,
@@ -491,6 +499,10 @@ static int load_aout_library(struct file *file)
 		retval = 0;
 		goto out;
 	}
+	error = ima_file_mmap(file, PROT_READ | PROT_WRITE | PROT_EXEC);
+	if (error < 0)
+		goto out;
+
 	/* Now use mmap to map the library into memory. */
 	down_write(&current->mm->mmap_sem);
 	error = do_mmap(file, start_addr, ex.a_text + ex.a_data,
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index a6395bd..74cd792 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/coredump.h>
 #include <linux/slab.h>
+#include <linux/ima.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -320,6 +321,13 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 			goto beyond_if;
 		}
 
+		error = ima_file_mmap(bprm->file,
+				      PROT_READ | PROT_WRITE | PROT_EXEC);
+		if (error < 0) {
+			send_sig(SIGKILL, current, 0);
+			return error;
+		}
+
 		down_write(&current->mm->mmap_sem);
 		error = do_mmap(bprm->file, N_TXTADDR(ex), ex.a_text,
 			PROT_READ | PROT_EXEC,
@@ -426,6 +434,10 @@ static int load_aout_library(struct file *file)
 		retval = 0;
 		goto out;
 	}
+	retval = ima_file_mmap(file, PROT_READ | PROT_WRITE | PROT_EXEC);
+	if (retval < 0)
+		goto out;
+
 	/* Now use mmap to map the library into memory. */
 	down_write(&current->mm->mmap_sem);
 	error = do_mmap(file, start_addr, ex.a_text + ex.a_data,
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bcb884e..26289d3 100644
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
@@ -322,6 +323,7 @@ static unsigned long elf_map(struct file *filep, unsigned long addr,
 	unsigned long map_addr;
 	unsigned long size = eppnt->p_filesz + ELF_PAGEOFFSET(eppnt->p_vaddr);
 	unsigned long off = eppnt->p_offset - ELF_PAGEOFFSET(eppnt->p_vaddr);
+	unsigned long ret;
 	addr = ELF_PAGESTART(addr);
 	size = ELF_PAGEALIGN(size);
 
@@ -330,6 +332,10 @@ static unsigned long elf_map(struct file *filep, unsigned long addr,
 	if (!size)
 		return addr;
 
+	ret = ima_file_mmap(filep, prot);
+	if (ret < 0)
+		return ret;
+
 	down_write(&current->mm->mmap_sem);
 	/*
 	* total_size is the size of the ELF (interpreter) image.
@@ -1050,6 +1056,10 @@ static int load_elf_library(struct file *file)
 	while (eppnt->p_type != PT_LOAD)
 		eppnt++;
 
+	error = ima_file_mmap(file, PROT_READ | PROT_WRITE | PROT_EXEC);
+	if (error < 0)
+		goto out_free_ph;
+
 	/* Now use mmap to map the library into memory. */
 	down_write(&current->mm->mmap_sem);
 	error = do_mmap(file,
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 1bffbe0..b3b98d2 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/binfmts.h>
 #include <linux/personality.h>
+#include <linux/ima.h>
 #include <linux/init.h>
 #include <linux/flat.h>
 #include <linux/syscalls.h>
@@ -543,6 +544,11 @@ static int load_flat_file(struct linux_binprm * bprm,
 		 */
 		DBG_FLT("BINFMT_FLAT: ROM mapping of file (we hope)\n");
 
+		ret = ima_file_mmap(bprm->file,
+				    PROT_READ | PROT_WRITE | PROT_EXEC);
+		if (ret < 0)
+			goto err;
+
 		down_write(&current->mm->mmap_sem);
 		textpos = do_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC,
 				  MAP_PRIVATE|MAP_EXECUTABLE, 0);
diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index cc8560f..47421f2 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/shm.h>
 #include <linux/personality.h>
+#include <linux/ima.h>
 #include <linux/init.h>
 
 #include <asm/uaccess.h>
@@ -147,6 +148,11 @@ static int map_som_binary(struct file *file,
 	code_size = SOM_PAGEALIGN(hpuxhdr->exec_tsize);
 	current->mm->start_code = code_start;
 	current->mm->end_code = code_start + code_size;
+
+	retval = ima_file_mmap(file, prot);
+	if (retval < 0)
+		goto out;
+
 	down_write(&current->mm->mmap_sem);
 	retval = do_mmap(file, code_start, code_size, prot,
 			flags, SOM_PAGESTART(hpuxhdr->exec_tfile));
diff --git a/mm/mmap.c b/mm/mmap.c
index 3f758c7..025e99b 100644
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
@@ -1108,10 +1109,15 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 
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
index b982290..13b427d 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -27,6 +27,7 @@
 #include <linux/mount.h>
 #include <linux/personality.h>
 #include <linux/security.h>
+#include <linux/ima.h>
 #include <linux/syscalls.h>
 #include <linux/audit.h>
 
@@ -1486,10 +1487,15 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 
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
index 1eff5cb..5b222eb 100644
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
index d754249..556c64c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -673,12 +673,7 @@ int security_file_mmap(struct file *file, unsigned long reqprot,
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
1.7.6.5

