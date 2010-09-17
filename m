Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0IQAiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 20:38:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:50372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab0IQAiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 20:38:22 -0400
Date: Fri, 17 Sep 2010 00:37:42 GMT
Message-Id: <201009170037.o8H0bgWx028053@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 2.6.36-rc5
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Anthony G. Basile" <basile@opensource.dyc.edu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Artur Skawina <art.08.09@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Damien Wyart <damien.wyart@free.fr>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jack Steiner <steiner@sgi.com>, John Drescher <drescherjm@gmail.com>,
        Kai Dietrich <mail@cleeus.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Magnus Granberg <zorry@gentoo.org>, Nix <nix@esperi.org.uk>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, stable@kernel.org
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 00:37:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Note: I was hoping to have available a fix for a binutils 2.16 build
regression as well, but I am still working on setting up an
environment which reproduces it, and I don't want to submit the fix
blind, hence that one might come later.

The following changes since commit 03a7ab083e4d619136d6f07ce70fa9de0bc436fc:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2010-09-16 12:59:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Jack Steiner (1):
      x86, UV: Fix initialization of max_pnode

Tetsuo Handa (1):
      x86, cpufeature: Suppress compiler warning with gcc 3.x

Thomas Gleixner (1):
      x86: hpet: Work around hardware stupidity

basile@opensource.dyc.edu (1):
      x86, build: Disable -fPIE when compiling with CONFIG_CC_STACKPROTECTOR=y

 arch/x86/Makefile                  |    2 +-
 arch/x86/include/asm/cpufeature.h  |    4 ++--
 arch/x86/include/asm/hpet.h        |    1 -
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 +++---
 arch/x86/kernel/early-quirks.c     |   18 ------------------
 arch/x86/kernel/hpet.c             |   31 +++++++++++++++++--------------
 6 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 8aa1b59..e8c8881 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -74,7 +74,7 @@ endif
 
 ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
-        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(biarch)),y)
+        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
                 stackp-y := -fstack-protector
                 KBUILD_CFLAGS += $(stackp-y)
         else
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 781a50b..c6fbb7b 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -296,6 +296,7 @@ extern const char * const x86_power_flags[32];
 
 #endif /* CONFIG_X86_64 */
 
+#if __GNUC__ >= 4
 /*
  * Static testing of CPU features.  Used the same as boot_cpu_has().
  * These are only valid after alternatives have run, but will statically
@@ -304,7 +305,7 @@ extern const char * const x86_power_flags[32];
  */
 static __always_inline __pure bool __static_cpu_has(u16 bit)
 {
-#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
+#if __GNUC__ > 4 || __GNUC_MINOR__ >= 5
 		asm goto("1: jmp %l[t_no]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
@@ -345,7 +346,6 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 #endif
 }
 
-#if __GNUC__ >= 4
 #define static_cpu_has(bit)					\
 (								\
 	__builtin_constant_p(boot_cpu_has(bit)) ?		\
diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 004e6e2..1d5c08a 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -68,7 +68,6 @@ extern unsigned long force_hpet_address;
 extern u8 hpet_blockid;
 extern int hpet_force_user;
 extern u8 hpet_msi_disable;
-extern u8 hpet_readback_cmp;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern void hpet_disable(void);
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 7b598b8..f744f54 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -698,9 +698,11 @@ void __init uv_system_init(void)
 		for (j = 0; j < 64; j++) {
 			if (!test_bit(j, &present))
 				continue;
-			uv_blade_info[blade].pnode = (i * 64 + j);
+			pnode = (i * 64 + j);
+			uv_blade_info[blade].pnode = pnode;
 			uv_blade_info[blade].nr_possible_cpus = 0;
 			uv_blade_info[blade].nr_online_cpus = 0;
+			max_pnode = max(pnode, max_pnode);
 			blade++;
 		}
 	}
@@ -738,7 +740,6 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->scir.offset = uv_scir_offset(apicid);
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
-		max_pnode = max(pnode, max_pnode);
 	}
 
 	/* Add blade/pnode info for nodes without cpus */
@@ -750,7 +751,6 @@ void __init uv_system_init(void)
 		pnode = (paddr >> m_val) & pnode_mask;
 		blade = boot_pnode_to_blade(pnode);
 		uv_node_to_blade[nid] = blade;
-		max_pnode = max(pnode, max_pnode);
 	}
 
 	map_gru_high(max_pnode);
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index e5cc7e8..ebdb85c 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -18,7 +18,6 @@
 #include <asm/apic.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
-#include <asm/hpet.h>
 
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
@@ -192,21 +191,6 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 }
 #endif
 
-/*
- * Force the read back of the CMP register in hpet_next_event()
- * to work around the problem that the CMP register write seems to be
- * delayed. See hpet_next_event() for details.
- *
- * We do this on all SMBUS incarnations for now until we have more
- * information about the affected chipsets.
- */
-static void __init ati_hpet_bugs(int num, int slot, int func)
-{
-#ifdef CONFIG_HPET_TIMER
-	hpet_readback_cmp = 1;
-#endif
-}
-
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -236,8 +220,6 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
-	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID,
-	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_hpet_bugs },
 	{}
 };
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 351f9c0..410fdb3 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -35,7 +35,6 @@
 unsigned long				hpet_address;
 u8					hpet_blockid; /* OS timer block num */
 u8					hpet_msi_disable;
-u8					hpet_readback_cmp;
 
 #ifdef CONFIG_PCI_MSI
 static unsigned long			hpet_num_timers;
@@ -395,23 +394,27 @@ static int hpet_next_event(unsigned long delta,
 	 * at that point and we would wait for the next hpet interrupt
 	 * forever. We found out that reading the CMP register back
 	 * forces the transfer so we can rely on the comparison with
-	 * the counter register below.
+	 * the counter register below. If the read back from the
+	 * compare register does not match the value we programmed
+	 * then we might have a real hardware problem. We can not do
+	 * much about it here, but at least alert the user/admin with
+	 * a prominent warning.
 	 *
-	 * That works fine on those ATI chipsets, but on newer Intel
-	 * chipsets (ICH9...) this triggers due to an erratum: Reading
-	 * the comparator immediately following a write is returning
-	 * the old value.
+	 * An erratum on some chipsets (ICH9,..), results in
+	 * comparator read immediately following a write returning old
+	 * value. Workaround for this is to read this value second
+	 * time, when first read returns old value.
 	 *
-	 * We restrict the read back to the affected ATI chipsets (set
-	 * by quirks) and also run it with hpet=verbose for debugging
-	 * purposes.
+	 * In fact the write to the comparator register is delayed up
+	 * to two HPET cycles so the workaround we tried to restrict
+	 * the readback to those known to be borked ATI chipsets
+	 * failed miserably. So we give up on optimizations forever
+	 * and penalize all HPET incarnations unconditionally.
 	 */
-	if (hpet_readback_cmp || hpet_verbose) {
-		u32 cmp = hpet_readl(HPET_Tn_CMP(timer));
-
-		if (cmp != cnt)
+	if (unlikely((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt)) {
+		if (hpet_readl(HPET_Tn_CMP(timer)) != cnt)
 			printk_once(KERN_WARNING
-			    "hpet: compare register read back failed.\n");
+				"hpet: compare register read back failed.\n");
 	}
 
 	return (s32)(hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
