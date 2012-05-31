Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab2EaBIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 21:08:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab2EaBIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 21:08:04 -0400
Date: Wed, 30 May 2012 18:07:35 -0700
Message-Id: <201205310107.q4V17Zcg016996@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Additional x86 fixes for 3.5
Cc: <stable@vger.kernel.org>, Andre Przywara <andre.przywara@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Frank Arnold <frank.arnold@amd.com>, "H. Peter Anvin" <hpa@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Jan Beulich <jbeulich@suse.com>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        John Dykstra <jdykstra@cray.com>, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 18:07:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 731a7378b81c2f5fa88ca1ae20b83d548d5613dc:

  Merge branch 'x86-trampoline-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2012-05-29 20:14:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

The head of this tree is 1ab46fd319bcf1fcd9fb6311727d532b580e4eba.

Borislav Petkov (2):
      x86/bitops: Move BIT_64() for a wider use
      x86/mce: Fix 32-bit build

H. Peter Anvin (2):
      x86, realmode: Unbreak the ia64 build of drivers/acpi/sleep.c
      Merge branch 'x86/trampoline' into x86/urgent

Ingo Molnar (1):
      Merge branch 'x86/mce' into x86/urgent

Jan Beulich (1):
      x86: hpet: Fix copy-and-paste mistake in earlier change

John Dykstra (1):
      x86/mm/pat: Improve scaling of pat_pagerange_is_ram()

Konrad Rzeszutek Wilk (1):
      x86, amd, xen: Avoid NULL pointer paravirt references

zhenzhong.duan (1):
      x86, mtrr: Fix a type overflow in range_to_mtrr func

 arch/x86/include/asm/acpi.h        |    7 ++--
 arch/x86/include/asm/bitops.h      |    2 +
 arch/x86/kernel/cpu/mcheck/mce.c   |    6 ++--
 arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
 arch/x86/kernel/hpet.c             |    2 +-
 arch/x86/mm/pat.c                  |   58 +++++++++++++++++++++++-------------
 arch/x86/xen/enlighten.c           |    3 ++
 drivers/acpi/sleep.c               |    8 +----
 drivers/edac/mce_amd.h             |    2 -
 9 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 724aa44..0c44630 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -29,6 +29,7 @@
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mpspec.h>
+#include <asm/realmode.h>
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -116,10 +117,8 @@ static inline void acpi_disable_pci(void)
 /* Low-level suspend routine. */
 extern int acpi_suspend_lowlevel(void);
 
-extern const unsigned char acpi_wakeup_code[];
-
-/* early initialization routine */
-extern void acpi_reserve_wakeup_memory(void);
+/* Physical address to resume after wakeup */
+#define acpi_wakeup_address ((unsigned long)(real_mode_header->wakeup_start))
 
 /*
  * Check if the CPU can handle C2 and deeper
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index b97596e..a6983b2 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -15,6 +15,8 @@
 #include <linux/compiler.h>
 #include <asm/alternative.h>
 
+#define BIT_64(n)			(U64_C(1) << (n))
+
 /*
  * These have to be done with inline assembly: that way the bit-setting
  * is guaranteed to be atomic. All bit operations return 0 if the bit
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b772dd6..b4180f4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1472,9 +1472,9 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 				 rdmsrl(msrs[i], val);
 
 				 /* CntP bit set? */
-				 if (val & BIT(62)) {
-					 val &= ~BIT(62);
-					 wrmsrl(msrs[i], val);
+				 if (val & BIT_64(62)) {
+					val &= ~BIT_64(62);
+					wrmsrl(msrs[i], val);
 				 }
 			 }
 
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index ac140c7..bdda2e6 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -266,7 +266,7 @@ range_to_mtrr(unsigned int reg, unsigned long range_startk,
 		if (align > max_align)
 			align = max_align;
 
-		sizek = 1 << align;
+		sizek = 1UL << align;
 		if (debug_print) {
 			char start_factor = 'K', size_factor = 'K';
 			unsigned long start_base, size_base;
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 9cc7b43..1460a5d 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -870,7 +870,7 @@ int __init hpet_enable(void)
 	else
 		pr_warn("HPET initial state will not be saved\n");
 	cfg &= ~(HPET_CFG_ENABLE | HPET_CFG_LEGACY);
-	hpet_writel(cfg, HPET_Tn_CFG(i));
+	hpet_writel(cfg, HPET_CFG);
 	if (cfg)
 		pr_warn("HPET: Unrecognized bits %#x set in global cfg\n",
 			cfg);
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index f11729f..3d68ef6 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -158,31 +158,47 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 	return req_type;
 }
 
+struct pagerange_state {
+	unsigned long		cur_pfn;
+	int			ram;
+	int			not_ram;
+};
+
+static int
+pagerange_is_ram_callback(unsigned long initial_pfn, unsigned long total_nr_pages, void *arg)
+{
+	struct pagerange_state *state = arg;
+
+	state->not_ram	|= initial_pfn > state->cur_pfn;
+	state->ram	|= total_nr_pages > 0;
+	state->cur_pfn	 = initial_pfn + total_nr_pages;
+
+	return state->ram && state->not_ram;
+}
+
 static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
 {
-	int ram_page = 0, not_rampage = 0;
-	unsigned long page_nr;
+	int ret = 0;
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long end_pfn = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	struct pagerange_state state = {start_pfn, 0, 0};
 
-	for (page_nr = (start >> PAGE_SHIFT); page_nr < (end >> PAGE_SHIFT);
-	     ++page_nr) {
-		/*
-		 * For legacy reasons, physical address range in the legacy ISA
-		 * region is tracked as non-RAM. This will allow users of
-		 * /dev/mem to map portions of legacy ISA region, even when
-		 * some of those portions are listed(or not even listed) with
-		 * different e820 types(RAM/reserved/..)
-		 */
-		if (page_nr >= (ISA_END_ADDRESS >> PAGE_SHIFT) &&
-		    page_is_ram(page_nr))
-			ram_page = 1;
-		else
-			not_rampage = 1;
-
-		if (ram_page == not_rampage)
-			return -1;
+	/*
+	 * For legacy reasons, physical address range in the legacy ISA
+	 * region is tracked as non-RAM. This will allow users of
+	 * /dev/mem to map portions of legacy ISA region, even when
+	 * some of those portions are listed(or not even listed) with
+	 * different e820 types(RAM/reserved/..)
+	 */
+	if (start_pfn < ISA_END_ADDRESS >> PAGE_SHIFT)
+		start_pfn = ISA_END_ADDRESS >> PAGE_SHIFT;
+
+	if (start_pfn < end_pfn) {
+		ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
+				&state, pagerange_is_ram_callback);
 	}
 
-	return ram_page;
+	return (ret > 0) ? -1 : (state.ram ? 1 : 0);
 }
 
 /*
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 75f33b2..e74df95 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1116,7 +1116,10 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.wbinvd = native_wbinvd,
 
 	.read_msr = native_read_msr_safe,
+	.rdmsr_regs = native_rdmsr_safe_regs,
 	.write_msr = xen_write_msr_safe,
+	.wrmsr_regs = native_wrmsr_safe_regs,
+
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index ebaa045..74ee4ab 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -25,8 +25,6 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
-#include <asm/realmode.h>
-
 #include "internal.h"
 #include "sleep.h"
 
@@ -93,13 +91,11 @@ static struct notifier_block tts_notifier = {
 static int acpi_sleep_prepare(u32 acpi_state)
 {
 #ifdef CONFIG_ACPI_SLEEP
-	unsigned long wakeup_pa = real_mode_header->wakeup_start;
 	/* do we have a wakeup address for S2 and S3? */
 	if (acpi_state == ACPI_STATE_S3) {
-		if (!wakeup_pa)
+		if (!acpi_wakeup_address)
 			return -EFAULT;
-		acpi_set_firmware_waking_vector(
-				(acpi_physical_address)wakeup_pa);
+		acpi_set_firmware_waking_vector(acpi_wakeup_address);
 
 	}
 	ACPI_FLUSH_CPU_CACHE();
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index c6074c5..8c87a5e 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -5,8 +5,6 @@
 
 #include <asm/mce.h>
 
-#define BIT_64(n)			(U64_C(1) << (n))
-
 #define EC(x)				((x) & 0xffff)
 #define XEC(x, mask)			(((x) >> 16) & mask)
 
