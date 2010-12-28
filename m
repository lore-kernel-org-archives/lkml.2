Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab0L1Atk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 19:49:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44707 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0L1Ati (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 19:49:38 -0500
Message-ID: <4D1933E0.7090305@kernel.org>
Date: Mon, 27 Dec 2010 16:48:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] x86, 64bit: Move out cleanup higmap [_brk_end, _end)
 out of init_memory_mapping()
References: <4D0C072D.1040201@kernel.org> <4D19320B.7030007@kernel.org>
In-Reply-To: <4D19320B.7030007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is not related to init_memory_mapping(),  and init_memory_mapping() is
getting more bigger.

So make it as seperated function and call it from reserve_brk() and that is
point when _brk_end is concluded.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   24 ++++++++++++++++++++++++
 arch/x86/mm/init.c      |   19 -------------------
 2 files changed, 24 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -293,10 +293,32 @@ static void __init init_gbpages(void)
 	else
 		direct_gbpages = 0;
 }
+
+static void __init cleanup_highmap_brk_end(void)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+
+	mmu_cr4_features = read_cr4();
+
+	/*
+	 * _brk_end cannot change anymore, but it and _end may be
+	 * located on different 2M pages. cleanup_highmap(), however,
+	 * can only consider _end when it runs, so destroy any
+	 * mappings beyond _brk_end here.
+	 */
+	pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
+	pmd = pmd_offset(pud, _brk_end - 1);
+	while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
+		pmd_clear(pmd);
+}
 #else
 static inline void init_gbpages(void)
 {
 }
+static inline void cleanup_highmap_brk_end(void)
+{
+}
 #endif
 
 static void __init reserve_brk(void)
@@ -307,6 +329,8 @@ static void __init reserve_brk(void)
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
 	_brk_start = 0;
+
+	cleanup_highmap_brk_end();
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -270,25 +270,6 @@ unsigned long __init_refok init_memory_m
 	load_cr3(swapper_pg_dir);
 #endif
 
-#ifdef CONFIG_X86_64
-	if (!after_bootmem && !start) {
-		pud_t *pud;
-		pmd_t *pmd;
-
-		mmu_cr4_features = read_cr4();
-
-		/*
-		 * _brk_end cannot change anymore, but it and _end may be
-		 * located on different 2M pages. cleanup_highmap(), however,
-		 * can only consider _end when it runs, so destroy any
-		 * mappings beyond _brk_end here.
-		 */
-		pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
-		pmd = pmd_offset(pud, _brk_end - 1);
-		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
-			pmd_clear(pmd);
-	}
-#endif
 	__flush_tlb_all();
 
 	if (!after_bootmem && e820_table_end > e820_table_start)
