Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2HNTwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:52:08 -0400
Received: from ec2-46-137-96-110.eu-west-1.compute.amazonaws.com ([46.137.96.110]:35492
	"EHLO morero.ard.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab2HNTwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:52:06 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2012 15:52:06 EDT
Message-Id: <E1T1N2q-0001xm-5X@morero.ard.nu>
From: Ard Biesheuvel <ard.biesheuvel@gmail.com>
Date: Tue, 14 Aug 2012 21:11:11 +0200
Subject: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the PROT_FINAL flag to
the mmap() and mprotect() syscalls.

The PROT_FINAL flag indicates that the requested set
of protection bits should be final, i.e., it shall
not be allowed for a subsequent mprotect call to
set protection bits that were not set already.

This is mainly intended for the dynamic linker,
which sets up the address space on behalf of
dynamic binaries. By using this flag, it can
prevent exploited code from remapping read-only
executable code or data sections read-write.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@gmail.com>
---
 arch/powerpc/include/asm/mman.h   |    3 ++-
 include/asm-generic/mman-common.h |    1 +
 include/linux/mman.h              |    3 ++-
 mm/mmap.c                         |    9 +++++++++
 mm/mprotect.c                     |    8 ++++++++
 5 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/mman.h b/arch/powerpc/include/asm/mman.h
index d4a7f64..c0014eb 100644
--- a/arch/powerpc/include/asm/mman.h
+++ b/arch/powerpc/include/asm/mman.h
@@ -52,7 +52,8 @@ static inline pgprot_t arch_vm_get_page_prot(unsigned long vm_flags)
 
 static inline int arch_validate_prot(unsigned long prot)
 {
-	if (prot & ~(PROT_READ | PROT_WRITE | PROT_EXEC | PROT_SEM | PROT_SAO))
+	if (prot & ~(PROT_READ | PROT_WRITE | PROT_EXEC | PROT_SEM
+		     | PROT_SAO | PROT_FINAL))
 		return 0;
 	if ((prot & PROT_SAO) && !cpu_has_feature(CPU_FTR_SAO))
 		return 0;
diff --git a/include/asm-generic/mman-common.h b/include/asm-generic/mman-common.h
index d030d2c..5687993 100644
--- a/include/asm-generic/mman-common.h
+++ b/include/asm-generic/mman-common.h
@@ -10,6 +10,7 @@
 #define PROT_WRITE	0x2		/* page can be written */
 #define PROT_EXEC	0x4		/* page can be executed */
 #define PROT_SEM	0x8		/* page may be used for atomic ops */
+#define PROT_FINAL	0x80		/* unset page prot bits cannot be set later */
 #define PROT_NONE	0x0		/* page can not be accessed */
 #define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
 #define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of growsup vma */
diff --git a/include/linux/mman.h b/include/linux/mman.h
index 8b74e9b..c11b1ab 100644
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -51,7 +51,8 @@ static inline void vm_unacct_memory(long pages)
  */
 static inline int arch_validate_prot(unsigned long prot)
 {
-	return (prot & ~(PROT_READ | PROT_WRITE | PROT_EXEC | PROT_SEM)) == 0;
+	return (prot & ~(PROT_READ | PROT_WRITE | PROT_EXEC
+			 | PROT_SEM | PROT_FINAL)) == 0;
 }
 #define arch_validate_prot arch_validate_prot
 #endif
diff --git a/mm/mmap.c b/mm/mmap.c
index e3e8691..a043fa9 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1101,6 +1101,15 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 		}
 	}
 
+	/*
+	 * PROT_FINAL indicates that prot bits not requested by this
+	 * mmap() call cannot be added later
+	 */
+	if (prot & PROT_FINAL)
+		vm_flags &= ~(VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+			    | (vm_flags << 4);
+
+
 	return mmap_region(file, addr, len, flags, vm_flags, pgoff);
 }
 
diff --git a/mm/mprotect.c b/mm/mprotect.c
index a409926..7a39f73 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -301,6 +301,14 @@ SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 			goto out;
 		}
 
+		/*
+		 * PROT_FINAL indicates that prot bits removed by this
+		 * mprotect() call cannot be added later
+		 */
+		if (prot & PROT_FINAL)
+			newflags &= ~(VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+				    | (newflags << 4);
+
 		error = security_file_mprotect(vma, reqprot, prot);
 		if (error)
 			goto out;
-- 
1.7.9.5

