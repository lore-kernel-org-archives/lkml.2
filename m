Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415Ab0EECD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:03:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36018 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab0EECDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:03:24 -0400
Date: Tue, 4 May 2010 19:02:48 -0700
Message-Id: <201005050202.o4522mSu019958@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 2.6.34-rc7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       Liang Li <liang.li@windriver.com>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Prarit Bhargava <prarit@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Renninger <trenn@suse.de>, Wang Chen <wangchen@cn.fujitsu.com>,
       Yinghai Lu <yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Five more patches.  I had originally included David Howell's rwsem
patch as well, but I saw you picked it up from email.

The following changes since commit 66f41d4c5c8a5deed66fdcc84509376c9a0bf9d8:
  Linus Torvalds (1):
        Linux 2.6.34-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git x86-fixes-for-linus

Ingo Molnar (1):
      x86: Fix parse_reservetop() build failure on certain configs

Liang Li (1):
      x86: Fix 'reservetop=' functionality

Mark Langsdorf (1):
      powernow-k8: Fix frequency reporting

Prarit Bhargava (1):
      x86: Fix NULL pointer access in irq_force_complete_move() for Xen guests

 arch/x86/include/asm/io.h                 |    1 +
 arch/x86/kernel/apic/io_apic.c            |    3 +++
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 ++-
 arch/x86/mm/ioremap.c                     |   14 ++++++++++++++
 arch/x86/mm/pgtable_32.c                  |    2 ++
 5 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index a1dcfa3..30a3e97 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -347,6 +347,7 @@ extern void __iomem *early_ioremap(resource_size_t phys_addr,
 extern void __iomem *early_memremap(resource_size_t phys_addr,
 				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
+extern void fixup_early_ioremap(void);
 
 #define IO_SPACE_LIMIT 0xffff
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 127b871..eb2789c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2545,6 +2545,9 @@ void irq_force_complete_move(int irq)
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg = desc->chip_data;
 
+	if (!cfg)
+		return;
+
 	__irq_complete_move(&desc, cfg->vector);
 }
 #else
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index d360b56..b6215b9 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -929,7 +929,8 @@ static int fill_powernow_table_pstate(struct powernow_k8_data *data,
 		powernow_table[i].index = index;
 
 		/* Frequency may be rounded for these */
-		if (boot_cpu_data.x86 == 0x10 || boot_cpu_data.x86 == 0x11) {
+		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
+				 || boot_cpu_data.x86 == 0x11) {
 			powernow_table[i].frequency =
 				freq_from_fid_did(lo & 0x3f, (lo >> 6) & 7);
 		} else
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 5eb1ba7..12e4d2d 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -448,6 +448,20 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
 static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
 static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
 
+void __init fixup_early_ioremap(void)
+{
+	int i;
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i]) {
+			WARN_ON(1);
+			break;
+		}
+	}
+
+	early_ioremap_init();
+}
+
 static int __init check_early_ioremap_leak(void)
 {
 	int count = 0;
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 1a8faf0..7928540 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -18,6 +18,7 @@
 #include <asm/e820.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
+#include <asm/io.h>
 
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
@@ -128,6 +129,7 @@ static int __init parse_reservetop(char *arg)
 
 	address = memparse(arg, &arg);
 	reserve_top_address(address);
+	fixup_early_ioremap();
 	return 0;
 }
 early_param("reservetop", parse_reservetop);
