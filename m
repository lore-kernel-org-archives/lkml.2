Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab2I3XuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 19:50:04 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:50460 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab2I3XtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 19:49:06 -0400
Date: Sun, 30 Sep 2012 17:21:16 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [ARM] Use AT() in the linker script to create correct
 program headers
Message-ID: <20120930232116.GC30637@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The standard linux asm-generic/vmlinux.lds.h already supports this,
and it seems other architectures do as well.

The goal is to create an ELF file that has correct program headers. We
want to see the VirtAddr be the runtime address of the kernel with the
MMU turned on, and PhysAddr be the physical load address for the section
with no MMU.

This allows ELF based boot loaders to properly load vmlinux:

$ readelf -l vmlinux
Entry point 0x8000
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x008000 0xc0008000 0x00008000 0x372244 0x3a4310 RWE 0x8000

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 arch/arm/include/asm/memory.h |    2 +-
 arch/arm/kernel/vmlinux.lds.S |   47 ++++++++++++++++++++++++----------------
 2 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 5f6ddcc..4ce5b6d 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -283,7 +283,7 @@ static inline __deprecated void *bus_to_virt(unsigned long x)
 #define arch_is_coherent()		0
 #endif
 
-#endif
+#endif /* __ASSEMBLY__ */
 
 #include <asm-generic/memory_model.h>
 
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 36ff15b..07942b6 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -3,6 +3,13 @@
  * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
  */
 
+/* If we have a known, fixed physical load address then set LOAD_OFFSET
+   and generate an ELF that has the physical load address in the program
+   headers. */
+#ifndef CONFIG_ARM_PATCH_PHYS_VIRT
+#define LOAD_OFFSET (PAGE_OFFSET - PHYS_OFFSET)
+#endif
+
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
@@ -39,7 +46,7 @@
 #endif
 
 OUTPUT_ARCH(arm)
-ENTRY(stext)
+ENTRY(phys_start)
 
 #ifndef __ARMEB__
 jiffies = jiffies_64;
@@ -86,11 +93,13 @@ SECTIONS
 #else
 	. = PAGE_OFFSET + TEXT_OFFSET;
 #endif
-	.head.text : {
+	.head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {
 		_text = .;
+		phys_start = . - LOAD_OFFSET;
 		HEAD_TEXT
 	}
-	.text : {			/* Real text segment		*/
+	/* Real text segment */
+	.text :  AT(ADDR(.text) - LOAD_OFFSET) {
 		_stext = .;		/* Text and read-only data	*/
 			__exception_text_start = .;
 			*(.exception.text)
@@ -119,12 +128,12 @@ SECTIONS
 	 * Stack unwinding tables
 	 */
 	. = ALIGN(8);
-	.ARM.unwind_idx : {
+	.ARM.unwind_idx : AT(ADDR(.ARM.unwind_idx) - LOAD_OFFSET) {
 		__start_unwind_idx = .;
 		*(.ARM.exidx*)
 		__stop_unwind_idx = .;
 	}
-	.ARM.unwind_tab : {
+	.ARM.unwind_tab : AT(ADDR(.ARM.unwind_tab) - LOAD_OFFSET) {
 		__start_unwind_tab = .;
 		*(.ARM.extab*)
 		__stop_unwind_tab = .;
@@ -139,35 +148,35 @@ SECTIONS
 #endif
 
 	INIT_TEXT_SECTION(8)
-	.exit.text : {
+	.exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
 		ARM_EXIT_KEEP(EXIT_TEXT)
 	}
-	.init.proc.info : {
+	.init.proc.info : AT(ADDR(.init.proc.info) - LOAD_OFFSET) {
 		ARM_CPU_DISCARD(PROC_INFO)
 	}
-	.init.arch.info : {
+	.init.arch.info : AT(ADDR(.init.arch.info) - LOAD_OFFSET) {
 		__arch_info_begin = .;
 		*(.arch.info.init)
 		__arch_info_end = .;
 	}
-	.init.tagtable : {
+	.init.tagtable : AT(ADDR(.init.tagtable) - LOAD_OFFSET) {
 		__tagtable_begin = .;
 		*(.taglist.init)
 		__tagtable_end = .;
 	}
 #ifdef CONFIG_SMP_ON_UP
-	.init.smpalt : {
+	.init.smpalt : AT(ADDR(.init.smpalt) - LOAD_OFFSET) {
 		__smpalt_begin = .;
 		*(.alt.smp.init)
 		__smpalt_end = .;
 	}
 #endif
-	.init.pv_table : {
+	.init.pv_table : AT(ADDR(.init.pv_table) - LOAD_OFFSET) {
 		__pv_table_begin = .;
 		*(.pv_table)
 		__pv_table_end = .;
 	}
-	.init.data : {
+	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
 #ifndef CONFIG_XIP_KERNEL
 		INIT_DATA
 #endif
@@ -178,7 +187,7 @@ SECTIONS
 		INIT_RAM_FS
 	}
 #ifndef CONFIG_XIP_KERNEL
-	.exit.data : {
+	.exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
 		ARM_EXIT_KEEP(EXIT_DATA)
 	}
 #endif
@@ -196,7 +205,7 @@ SECTIONS
 	__data_loc = .;
 #endif
 
-	.data : AT(__data_loc) {
+	.data : AT(__data_loc - LOAD_OFFSET) {
 		_data = .;		/* address in memory */
 		_sdata = .;
 
@@ -245,7 +254,7 @@ SECTIONS
 	 * free it after init has commenced and TCM contents have
 	 * been copied to its destination.
 	 */
-	.tcm_start : {
+	.tcm_start : AT(ADDR(.tcm_start) - LOAD_OFFSET) {
 		. = ALIGN(PAGE_SIZE);
 		__tcm_start = .;
 		__itcm_start = .;
@@ -257,7 +266,7 @@ SECTIONS
 	 * and we'll upload the contents from RAM to TCM and free
 	 * the used RAM after that.
 	 */
-	.text_itcm ITCM_OFFSET : AT(__itcm_start)
+	.text_itcm ITCM_OFFSET : AT(__itcm_start - LOAD_OFFSET)
 	{
 		__sitcm_text = .;
 		*(.tcm.text)
@@ -272,12 +281,12 @@ SECTIONS
 	 */
 	. = ADDR(.tcm_start) + SIZEOF(.tcm_start) + SIZEOF(.text_itcm);
 
-	.dtcm_start : {
+	.dtcm_start : AT(ADDR(.dtcm_start) - LOAD_OFFSET) {
 		__dtcm_start = .;
 	}
 
 	/* TODO: add remainder of ITCM as well, that can be used for data! */
-	.data_dtcm DTCM_OFFSET : AT(__dtcm_start)
+	.data_dtcm DTCM_OFFSET : AT(__dtcm_start - LOAD_OFFSET)
 	{
 		. = ALIGN(4);
 		__sdtcm_data = .;
@@ -290,7 +299,7 @@ SECTIONS
 	. = ADDR(.dtcm_start) + SIZEOF(.data_dtcm);
 
 	/* End marker for freeing TCM copy in linked object */
-	.tcm_end : AT(ADDR(.dtcm_start) + SIZEOF(.data_dtcm)){
+	.tcm_end : AT(ADDR(.dtcm_start) + SIZEOF(.data_dtcm) - LOAD_OFFSET){
 		. = ALIGN(PAGE_SIZE);
 		__tcm_end = .;
 	}
-- 
1.7.4.1

