Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab2FOSx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:53:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56893 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187Ab2FOSxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:53:55 -0400
Date: Fri, 15 Jun 2012 20:53:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120615185350.GA19356@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 161270fc1f9ddfc17154e0d49291472a9cdef7db x86/smp: Fix topology checks on AMD MCM CPUs

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86/smp: Fix topology checks on AMD MCM CPUs

Martin Pelikan (1):
      x86, um: Correct syscall table type attributes breaking gcc 4.8

Wanpeng Li (1):
      x86/mm: Fix some kernel-doc warnings


 arch/x86/kernel/smpboot.c       | 7 +++++--
 arch/x86/mm/ioremap.c           | 4 ++--
 arch/x86/mm/pageattr.c          | 2 +-
 arch/x86/um/sys_call_table_32.c | 4 ++--
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fd019d7..c3a6bac 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -349,9 +349,12 @@ static bool __cpuinit match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 
 static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
-	if (c->phys_proc_id == o->phys_proc_id)
-		return topology_sane(c, o, "mc");
+	if (c->phys_proc_id == o->phys_proc_id) {
+		if (cpu_has(c, X86_FEATURE_AMD_DCM))
+			return true;
 
+		return topology_sane(c, o, "mc");
+	}
 	return false;
 }
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index be1ef57..78fe3f1 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -180,7 +180,7 @@ err_free_memtype:
 
 /**
  * ioremap_nocache     -   map bus memory into CPU space
- * @offset:    bus address of the memory
+ * @phys_addr:    bus address of the memory
  * @size:      size of the resource to map
  *
  * ioremap_nocache performs a platform specific sequence of operations to
@@ -217,7 +217,7 @@ EXPORT_SYMBOL(ioremap_nocache);
 
 /**
  * ioremap_wc	-	map memory into CPU space write combined
- * @offset:	bus address of the memory
+ * @phys_addr:	bus address of the memory
  * @size:	size of the resource to map
  *
  * This version of ioremap ensures that the memory is marked write combining.
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e1ebde3..a718e0d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -122,7 +122,7 @@ within(unsigned long addr, unsigned long start, unsigned long end)
 
 /**
  * clflush_cache_range - flush a cache range with clflush
- * @addr:	virtual start address
+ * @vaddr:	virtual start address
  * @size:	number of bytes to flush
  *
  * clflush is an unordered instruction which needs fencing with mfence
diff --git a/arch/x86/um/sys_call_table_32.c b/arch/x86/um/sys_call_table_32.c
index 416bd40..68d1dc9 100644
--- a/arch/x86/um/sys_call_table_32.c
+++ b/arch/x86/um/sys_call_table_32.c
@@ -39,9 +39,9 @@
 #undef __SYSCALL_I386
 #define __SYSCALL_I386(nr, sym, compat) [ nr ] = sym,
 
-typedef void (*sys_call_ptr_t)(void);
+typedef asmlinkage void (*sys_call_ptr_t)(void);
 
-extern void sys_ni_syscall(void);
+extern asmlinkage void sys_ni_syscall(void);
 
 const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
 	/*
