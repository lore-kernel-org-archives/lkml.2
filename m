Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2JCOo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:44:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48791 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2JCOoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:44:55 -0400
Message-ID: <506C4F29.4090303@gmail.com>
Date: Wed, 03 Oct 2012 16:43:53 +0200
From: Ard Biesheuvel <ard.biesheuvel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
References: <E1T1N2q-0001xm-5X@morero.ard.nu> <20120820180037.GV4232@outflux.net> <CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com> <CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com> <CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com> <CAGXu5jLj6qm+Rv3v2pmJqfEmhZBkKJsMUe0aRqxSa=s=w4wbDw@mail.gmail.com> <20121002153841.a03ad73b.akpm@linux-foundation.org> <alpine.LSU.2.00.1210021733580.1343@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1210021733580.1343@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
 arch/alpha/include/asm/mman.h     |    1 +
 arch/mips/include/asm/mman.h      |    1 +
 arch/parisc/include/asm/mman.h    |    1 +
 arch/powerpc/include/asm/mman.h   |    3 ++-
 arch/xtensa/include/asm/mman.h    |    1 +
 include/asm-generic/mman-common.h |    1 +
 include/linux/mman.h              |    3 ++-
 mm/mmap.c                         |    8 ++++++++
 mm/mprotect.c                     |    8 ++++++++
 9 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/asm/mman.h b/arch/alpha/include/asm/mman.h
index cbeb361..ab46252 100644
--- a/arch/alpha/include/asm/mman.h
+++ b/arch/alpha/include/asm/mman.h
@@ -6,6 +6,7 @@
 #define PROT_EXEC	0x4		/* page can be executed */
 #define PROT_SEM	0x8		/* page may be used for atomic ops */
 #define PROT_NONE	0x0		/* page can not be accessed */
+#define PROT_FINAL	0x80	/* unset page prot bits cannot be set later */
 #define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
 #define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of growsup vma */
 
diff --git a/arch/mips/include/asm/mman.h b/arch/mips/include/asm/mman.h
index 46d3da0..9cd50e4 100644
--- a/arch/mips/include/asm/mman.h
+++ b/arch/mips/include/asm/mman.h
@@ -20,6 +20,7 @@
 #define PROT_EXEC	0x04		/* page can be executed */
 /*			0x08		   reserved for PROT_EXEC_NOFLUSH */
 #define PROT_SEM	0x10		/* page may be used for atomic ops */
+#define PROT_FINAL	0x80		/* unset page prot bits cannot be set later */
 #define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
 #define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of growsup vma */
 
diff --git a/arch/parisc/include/asm/mman.h b/arch/parisc/include/asm/mman.h
index 12219eb..0cf18e3 100644
--- a/arch/parisc/include/asm/mman.h
+++ b/arch/parisc/include/asm/mman.h
@@ -6,6 +6,7 @@
 #define PROT_EXEC	0x4		/* page can be executed */
 #define PROT_SEM	0x8		/* page may be used for atomic ops */
 #define PROT_NONE	0x0		/* page can not be accessed */
+#define PROT_FINAL	0x80	/* unset page prot bits cannot be set later */
 #define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
 #define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of growsup vma */
 
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
diff --git a/arch/xtensa/include/asm/mman.h b/arch/xtensa/include/asm/mman.h
index 25bc6c1..680b3c4 100644
--- a/arch/xtensa/include/asm/mman.h
+++ b/arch/xtensa/include/asm/mman.h
@@ -27,6 +27,7 @@
 #define PROT_EXEC	0x4		/* page can be executed */
 
 #define PROT_SEM	0x10		/* page may be used for atomic ops */
+#define PROT_FINAL	0x80		/* unset page prot bits cannot be set later */
 #define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
 #define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end fo growsup vma */
 
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
index 872441e..292f988 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1101,6 +1101,14 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
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


