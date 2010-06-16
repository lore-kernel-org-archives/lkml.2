Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab0FPFsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:48:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28721 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab0FPFqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:46:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 34/37] x86: Add get_centaur_ram_top()
Date: Tue, 15 Jun 2010 22:42:43 -0700
Message-Id: <1276666966-14259-35-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
References: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C186510.0039,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can avoid to access e820.map[] directly.

later we could move e820 to static and _initdata

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/e820.h   |    9 ++++++
 arch/x86/kernel/cpu/centaur.c |   53 +-------------------------------------
 arch/x86/kernel/e820.c        |   56 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c       |    2 +
 4 files changed, 69 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 334281f..cd7de51 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -76,6 +76,15 @@ struct e820map {
 /* see comment in arch/x86/kernel/e820.c */
 extern struct e820map e820;
 
+#if defined(CONFIG_X86_OOSTORE) && defined(CONFIG_CPU_SUP_CENTAUR)
+extern int centaur_ram_top;
+void get_centaur_ram_top(void);
+#else
+static inline void get_centaur_ram_top(void)
+{
+}
+#endif
+
 extern unsigned long pci_mem_start;
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index e58d978..bb49358 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -37,63 +37,14 @@ static void __cpuinit centaur_mcr_insert(int reg, u32 base, u32 size, int key)
 	mtrr_centaur_report_mcr(reg, lo, hi);	/* Tell the mtrr driver */
 }
 
-/*
- * Figure what we can cover with MCR's
- *
- * Shortcut: We know you can't put 4Gig of RAM on a winchip
- */
-static u32 __cpuinit ramtop(void)
-{
-	u32 clip = 0xFFFFFFFFUL;
-	u32 top = 0;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		unsigned long start, end;
-
-		if (e820.map[i].addr > 0xFFFFFFFFUL)
-			continue;
-		/*
-		 * Don't MCR over reserved space. Ignore the ISA hole
-		 * we frob around that catastrophe already
-		 */
-		if (e820.map[i].type == E820_RESERVED) {
-			if (e820.map[i].addr >= 0x100000UL &&
-			    e820.map[i].addr < clip)
-				clip = e820.map[i].addr;
-			continue;
-		}
-		start = e820.map[i].addr;
-		end = e820.map[i].addr + e820.map[i].size;
-		if (start >= end)
-			continue;
-		if (end > top)
-			top = end;
-	}
-	/*
-	 * Everything below 'top' should be RAM except for the ISA hole.
-	 * Because of the limited MCR's we want to map NV/ACPI into our
-	 * MCR range for gunk in RAM
-	 *
-	 * Clip might cause us to MCR insufficient RAM but that is an
-	 * acceptable failure mode and should only bite obscure boxes with
-	 * a VESA hole at 15Mb
-	 *
-	 * The second case Clip sometimes kicks in is when the EBDA is marked
-	 * as reserved. Again we fail safe with reasonable results
-	 */
-	if (top > clip)
-		top = clip;
-
-	return top;
-}
+int __cpuinitdata centaur_ram_top;
 
 /*
  * Compute a set of MCR's to give maximum coverage
  */
 static int __cpuinit centaur_mcr_compute(int nr, int key)
 {
-	u32 mem = ramtop();
+	u32 mem = centaur_ram_top;
 	u32 root = power2(mem);
 	u32 base = root;
 	u32 top = root;
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 025e139..baa38df 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1131,6 +1131,62 @@ void __init setup_memory_map(void)
 	e820_print_map(who);
 }
 
+#if defined(CONFIG_X86_OOSTORE) && defined(CONFIG_CPU_SUP_CENTAUR)
+/*
+ * Figure what we can cover with MCR's
+ *
+ * Shortcut: We know you can't put 4Gig of RAM on a winchip
+ */
+void __init get_centaur_ram_top(void)
+{
+	u32 clip = 0xFFFFFFFFUL;
+	u32 top = 0;
+	int i;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR)
+		return;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		unsigned long start, end;
+
+		if (e820.map[i].addr > 0xFFFFFFFFUL)
+			continue;
+		/*
+		 * Don't MCR over reserved space. Ignore the ISA hole
+		 * we frob around that catastrophe already
+		 */
+		if (e820.map[i].type == E820_RESERVED) {
+			if (e820.map[i].addr >= 0x100000UL &&
+			    e820.map[i].addr < clip)
+				clip = e820.map[i].addr;
+			continue;
+		}
+		start = e820.map[i].addr;
+		end = e820.map[i].addr + e820.map[i].size;
+		if (start >= end)
+			continue;
+		if (end > top)
+			top = end;
+	}
+	/*
+	 * Everything below 'top' should be RAM except for the ISA hole.
+	 * Because of the limited MCR's we want to map NV/ACPI into our
+	 * MCR range for gunk in RAM
+	 *
+	 * Clip might cause us to MCR insufficient RAM but that is an
+	 * acceptable failure mode and should only bite obscure boxes with
+	 * a VESA hole at 15Mb
+	 *
+	 * The second case Clip sometimes kicks in is when the EBDA is marked
+	 * as reserved. Again we fail safe with reasonable results
+	 */
+	if (top > clip)
+		top = clip;
+
+	centaur_ram_top = top;
+}
+#endif
+
 void __init init_lmb_memory(void)
 {
 	lmb_init();
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index dc6b77b..20b3548 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -905,6 +905,8 @@ void __init setup_arch(char **cmdline_p)
 	if (mtrr_trim_uncached_memory(max_pfn))
 		max_pfn = e820_end_of_ram_pfn();
 
+	get_centaur_ram_top();
+
 #ifdef CONFIG_X86_32
 	/* max_low_pfn get updated here */
 	find_low_pfn_range();
-- 
1.6.4.2

