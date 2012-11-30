Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2K3XOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 18:14:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38739 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2K3XOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 18:14:41 -0500
Date: Fri, 30 Nov 2012 15:13:33 -0800
Message-Id: <201211302313.qAUNDXMK022697@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 3.7
Cc: <stable@kernel.org>, Duncan Laurie <dlaurie@chromium.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Melanie Blower <melanie.blower@intel.com>,
        Olof Johansson <olofj@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Palatin <vpalatin@chromium.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 15:13:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d17:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/urgent

H. Peter Anvin (2):
      x86, kvm: Remove incorrect redundant assembly constraint
      x86-32: Unbreak booting on some 486 clones

Vincent Palatin (1):
      x86, fpu: Avoid FPU lazy restore after suspend

 arch/x86/include/asm/fpu-internal.h |   15 +++++++++------
 arch/x86/kernel/head_32.S           |    9 +++++++--
 arch/x86/kernel/smpboot.c           |    5 +++++
 arch/x86/kvm/emulate.c              |    3 +--
 4 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 831dbb9..41ab26e 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -399,14 +399,17 @@ static inline void drop_init_fpu(struct task_struct *tsk)
 typedef struct { int preload; } fpu_switch_t;
 
 /*
- * FIXME! We could do a totally lazy restore, but we need to
- * add a per-cpu "this was the task that last touched the FPU
- * on this CPU" variable, and the task needs to have a "I last
- * touched the FPU on this CPU" and check them.
+ * Must be run with preemption disabled: this clears the fpu_owner_task,
+ * on this CPU.
  *
- * We don't do that yet, so "fpu_lazy_restore()" always returns
- * false, but some day..
+ * This will disable any lazy FPU state restore of the current FPU state,
+ * but if the current thread owns the FPU, it will still be saved by.
  */
+static inline void __cpu_disable_lazy_restore(unsigned int cpu)
+{
+	per_cpu(fpu_owner_task, cpu) = NULL;
+}
+
 static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
 {
 	return new == this_cpu_read_stable(fpu_owner_task) &&
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 957a47a..4dac2f6 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -292,8 +292,8 @@ default_entry:
  *	be using the global pages. 
  *
  *	NOTE! If we are on a 486 we may have no cr4 at all!
- *	Specifically, cr4 exists if and only if CPUID exists,
- *	which in turn exists if and only if EFLAGS.ID exists.
+ *	Specifically, cr4 exists if and only if CPUID exists
+ *	and has flags other than the FPU flag set.
  */
 	movl $X86_EFLAGS_ID,%ecx
 	pushl %ecx
@@ -308,6 +308,11 @@ default_entry:
 	testl %ecx,%eax
 	jz 6f			# No ID flag = no CPUID = no CR4
 
+	movl $1,%eax
+	cpuid
+	andl $~1,%edx		# Ignore CPUID.FPU
+	jz 6f			# No flags or only CPUID.FPU = no CR4
+
 	movl pa(mmu_cr4_features),%eax
 	movl %eax,%cr4
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c80a33b..f3e2ec8 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -68,6 +68,8 @@
 #include <asm/mwait.h>
 #include <asm/apic.h>
 #include <asm/io_apic.h>
+#include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
@@ -818,6 +820,9 @@ int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
+	/* the FPU context is blank, nobody can own it */
+	__cpu_disable_lazy_restore(cpu);
+
 	err = do_boot_cpu(apicid, cpu, tidle);
 	if (err) {
 		pr_debug("do_boot_cpu failed %d\n", err);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 39171cb..bba39bf 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -426,8 +426,7 @@ static void invalidate_registers(struct x86_emulate_ctxt *ctxt)
 			_ASM_EXTABLE(1b, 3b)				\
 			: "=m" ((ctxt)->eflags), "=&r" (_tmp),		\
 			  "+a" (*rax), "+d" (*rdx), "+qm"(_ex)		\
-			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val),	\
-			  "a" (*rax), "d" (*rdx));			\
+			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val));	\
 	} while (0)
 
 /* instruction has only one source operand, destination is implicit (e.g. mul, div, imul, idiv) */
