Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab0C3LXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:23:54 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:41767 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab0C3LXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:23:41 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 26/29] x86: Add get_centaur_ram_top()
Date: Tue, 30 Mar 2010 04:20:00 -0700
Message-Id: <1269948003-17221-27-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
References: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BB1DF12.013D,ss=1,fgs=0
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
index 57c938a..be6e1e6 100644
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
index 2535579..cfe55c1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -884,6 +884,8 @@ void __init setup_arch(char **cmdline_p)
 	if (mtrr_trim_uncached_memory(max_pfn))
 		max_pfn = e820_end_of_ram_pfn();
 
+	get_centaur_ram_top();
+
 #ifdef CONFIG_X86_32
 	/* max_low_pfn get updated here */
 	find_low_pfn_range();
-- 
1.6.4.2

