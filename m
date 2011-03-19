Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab1CSSMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 14:12:44 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57001 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab1CSSMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 14:12:43 -0400
Date: Sat, 19 Mar 2011 23:42:35 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: greg@kroah.com
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, anton@samba.org,
        benh@kernel.crashing.org, mananth@in.ibm.com
Subject: [1/3] powerpc/kexec: Fix race in kexec shutdown
Message-ID: <20110319181235.GB23832@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   powerpc/kexec: Fix race in kexec shutdown

   Commit: commit 1fc711f7ffb01089efc58042cfdbac8573d1b59a upstream

   In kexec_prepare_cpus, the primary CPU IPIs the secondary CPUs to
   kexec_smp_down().  kexec_smp_down() calls kexec_smp_wait() which sets
   the hw_cpu_id() to -1.  The primary does this while leaving IRQs on
   which means the primary can take a timer interrupt which can lead to
   the IPIing one of the secondary CPUs (say, for a scheduler re-balance)
   but since the secondary CPU now has a hw_cpu_id = -1, we IPI CPU
   -1... Kaboom!

   We are hitting this case regularly on POWER7 machines.

   There is also a second race, where the primary will tear down the MMU
   mappings before knowing the secondaries have entered real mode.

   Also, the secondaries are clearing out any pending IPIs before
   guaranteeing that no more will be received.

   This changes kexec_prepare_cpus() so that we turn off IRQs in the
   primary CPU much earlier.  It adds a paca flag to say that the
   secondaries have entered the kexec_smp_down() IPI and turned off IRQs,
   rather than overloading hw_cpu_id with -1.  This new paca flag is
   again used to in indicate when the secondaries has entered real mode.

   It also ensures that all CPUs have their IRQs off before we clear out
   any pending IPI requests (in kexec_cpu_down()) to ensure there are no
   trailing IPIs left unacknowledged.

   Signed-off-by: Michael Neuling <mikey@neuling.org>
   Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
   Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
   cc: Anton Blanchard <anton@samba.org>
---
 arch/powerpc/include/asm/kexec.h       |    4 ++
 arch/powerpc/include/asm/paca.h        |    3 +-
 arch/powerpc/kernel/asm-offsets.c      |    1 +
 arch/powerpc/kernel/machine_kexec_64.c |   48 ++++++++++++++++++++++---------
 arch/powerpc/kernel/misc_64.S          |    8 +++--
 arch/powerpc/kernel/paca.c             |    2 +
 6 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/kexec.h b/arch/powerpc/include/asm/kexec.h
index 7e06b43..a6ca6da 100644
--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -31,6 +31,10 @@
 #define KEXEC_ARCH KEXEC_ARCH_PPC
 #endif

+#define KEXEC_STATE_NONE 0
+#define KEXEC_STATE_IRQS_OFF 1
+#define KEXEC_STATE_REAL_MODE 2
+
 #ifndef __ASSEMBLY__
 #include <linux/cpumask.h>
 #include <asm/reg.h>
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 7d8514c..8108f1e 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -56,7 +56,7 @@ struct paca_struct {
	struct lppaca *lppaca_ptr;	/* Pointer to LpPaca for PLIC */
 #endif /* CONFIG_PPC_BOOK3S */
	/*
-	 * MAGIC: the spinlock functions in arch/powerpc/lib/locks.c
+	 * MAGIC: the spinlock functions in arch/powerpc/lib/locks.c
	 * load lock_token and paca_index with a single lwz
	 * instruction.  They must travel together and be properly
	 * aligned.
@@ -76,6 +76,7 @@ struct paca_struct {
	s16 hw_cpu_id;			/* Physical processor number */
	u8 cpu_start;			/* At startup, processor spins until */
					/* this becomes non-zero. */
+	u8 kexec_state;         /* set when kexec down has irqs off */
 #ifdef CONFIG_PPC_STD_MMU_64
	struct slb_shadow *slb_shadow_ptr;

diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 692c056..7d65650 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -183,6 +183,7 @@ int main(void)
 #endif /* CONFIG_PPC_STD_MMU_64 */
	DEFINE(PACAEMERGSP, offsetof(struct paca_struct, emergency_sp));
	DEFINE(PACAHWCPUID, offsetof(struct paca_struct, hw_cpu_id));
+	DEFINE(PACAKEXECSTATE, offsetof(struct paca_struct, kexec_state));
	DEFINE(PACA_STARTPURR, offsetof(struct paca_struct, startpurr));
	DEFINE(PACA_STARTSPURR, offsetof(struct paca_struct, startspurr));
	DEFINE(PACA_USER_TIME, offsetof(struct paca_struct, user_time));
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 1a8de63..2e4c61c 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -156,16 +156,23 @@ void kexec_copy_flush(struct kimage *image)

 #ifdef CONFIG_SMP

-/* FIXME: we should schedule this function to be called on all cpus based
- * on calling the interrupts, but we would like to call it off irq level
- * so that the interrupt controller is clean.
- */
+static int kexec_all_irq_disabled;
+
 static void kexec_smp_down(void *arg)
 {
+	local_irq_disable();
+	mb(); /* make sure our irqs are disabled before we say they are */
+	get_paca()->kexec_state = KEXEC_STATE_IRQS_OFF;
+	while (kexec_all_irq_disabled == 0)
+		cpu_relax();
+	mb(); /* make sure all irqs are disabled before this */
+	/*
+	 * Now every CPU has IRQs off, we can clear out any pending
+	 * IPIs and be sure that no more will come in after this.
+	 */
	if (ppc_md.kexec_cpu_down)
		ppc_md.kexec_cpu_down(0, 1);

-	local_irq_disable();
	kexec_smp_wait();
	/* NOTREACHED */
 }
@@ -193,20 +200,18 @@ static void wake_offline_cpus(void)
	}
 }

-static void kexec_prepare_cpus(void)
+static void kexec_prepare_cpus_wait(int wait_state)
 {
	int my_cpu, i, notified=-1;

	wake_offline_cpus();
-	smp_call_function(kexec_smp_down, NULL, /* wait */0);
	my_cpu = get_cpu();
-
-	/* check the others cpus are now down (via paca hw cpu id == -1) */
+	/* Make sure each CPU has atleast made it to the state we need */
	for (i=0; i < NR_CPUS; i++) {
		if (i == my_cpu)
			continue;

-		while (paca[i].hw_cpu_id != -1) {
+		while (paca[i].kexec_state < wait_state) {
			barrier();
			if (!cpu_possible(i)) {
				printk("kexec: cpu %d hw_cpu_id %d is not"
@@ -226,20 +231,35 @@ static void kexec_prepare_cpus(void)
			}
			if (i != notified) {
				printk( "kexec: waiting for cpu %d (physical"
-						" %d) to go down\n",
-						i, paca[i].hw_cpu_id);
+						" %d) to enter %i state\n",
+					i, paca[i].hw_cpu_id, wait_state);
				notified = i;
			}
		}
	}
+	mb();
+}
+
+static void kexec_prepare_cpus(void)
+{
+
+	smp_call_function(kexec_smp_down, NULL, /* wait */0);
+	local_irq_disable();
+	mb(); /* make sure IRQs are disabled before we say they are */
+	get_paca()->kexec_state = KEXEC_STATE_IRQS_OFF;
+
+	kexec_prepare_cpus_wait(KEXEC_STATE_IRQS_OFF);
+	/* we are sure every CPU has IRQs off at this point */
+	kexec_all_irq_disabled = 1;

	/* after we tell the others to go down */
	if (ppc_md.kexec_cpu_down)
		ppc_md.kexec_cpu_down(0, 0);

-	put_cpu();
+/* Before removing MMU mapings make sure all CPUs have entered real mode */
+	kexec_prepare_cpus_wait(KEXEC_STATE_REAL_MODE);

-	local_irq_disable();
+	put_cpu();
 }

 #else /* ! SMP */
diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
index a5cf9c1..499a133 100644
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -24,6 +24,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/cputable.h>
 #include <asm/thread_info.h>
+#include <asm/kexec.h>

	.text

@@ -471,6 +472,10 @@ _GLOBAL(kexec_wait)
 1:	mflr	r5
	addi	r5,r5,kexec_flag-1b

+	li      r4,KEXEC_STATE_REAL_MODE
+	stb     r4,PACAKEXECSTATE(r13)
+	SYNC
+
 99:	HMT_LOW
 #ifdef CONFIG_KEXEC		/* use no memory without kexec */
	lwz	r4,0(r5)
@@ -494,14 +499,11 @@ kexec_flag:
  * note: this is a terminal routine, it does not save lr
  *
  * get phys id from paca
- * set paca id to -1 to say we got here
  * switch to real mode
  * join other cpus in kexec_wait(phys_id)
  */
 _GLOBAL(kexec_smp_wait)
	lhz	r3,PACAHWCPUID(r13)
-	li	r4,-1
-	sth	r4,PACAHWCPUID(r13)	/* let others know we left */
	bl	real_mode
	b	.kexec_wait

diff --git a/arch/powerpc/kernel/paca.c b/arch/powerpc/kernel/paca.c
index d16b1ea..bf6598d 100644
--- a/arch/powerpc/kernel/paca.c
+++ b/arch/powerpc/kernel/paca.c
@@ -14,6 +14,7 @@
 #include <asm/paca.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
+#include <asm/kexec.h>

 /* This symbol is provided by the linker - let it fill in the paca
  * field correctly */
@@ -97,6 +98,7 @@ void __init initialise_pacas(void)
		new_paca->kernelbase = (unsigned long) _stext;
		new_paca->kernel_msr = MSR_KERNEL;
		new_paca->hw_cpu_id = 0xffff;
+		new_paca->kexec_state = KEXEC_STATE_NONE;
		new_paca->__current = &init_task;
 #ifdef CONFIG_PPC_STD_MMU_64
		new_paca->slb_shadow_ptr = &slb_shadow[cpu];
