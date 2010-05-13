Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190Ab0EMPsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:48:37 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:50599 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144Ab0EMPsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:48:36 -0400
X-Spam-Processed: digidescorp.com, Thu, 13 May 2010 10:48:35 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.144.166.44
X-Return-Path: prvs=17491102c2=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH][noMMU] microblaze: allow PAGE_SIZE configuration
Date: Thu, 13 May 2010 10:48:27 -0500
Message-Id: <1273765707-26035-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow developer to configure memory page size at compile time.
Larger pages can improve performance on some workloads.

Based on PowerPC code.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
--- a/arch/microblaze/include/asm/page.h	2010-05-13 09:55:59.000000000 -0500
+++ b/arch/microblaze/include/asm/page.h	2010-05-13 10:39:51.000000000 -0500
@@ -23,8 +23,16 @@
 #ifdef __KERNEL__
 
 /* PAGE_SHIFT determines the page size */
-#define PAGE_SHIFT	(12)
-#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
+#if defined(CONFIG_MICROBLAZE_32K_PAGES)
+#define PAGE_SHIFT		15
+#elif defined(CONFIG_MICROBLAZE_16K_PAGES)
+#define PAGE_SHIFT		14
+#elif defined(CONFIG_MICROBLAZE_8K_PAGES)
+#define PAGE_SHIFT		13
+#else
+#define PAGE_SHIFT		12
+#endif
+#define PAGE_SIZE	(ASM_CONST(1) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #define LOAD_OFFSET	ASM_CONST((CONFIG_KERNEL_START-CONFIG_KERNEL_BASE_ADDR))
diff -uprN a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig	2010-05-13 09:55:59.000000000 -0500
+++ b/arch/microblaze/Kconfig	2010-05-13 10:39:16.000000000 -0500
@@ -223,6 +223,36 @@ config TASK_SIZE
 	hex "Size of user task space" if TASK_SIZE_BOOL
 	default "0x80000000"
 
+choice
+	prompt "Page size"
+	default MICROBLAZE_4K_PAGES
+	depends on ADVANCED_OPTIONS
+	help
+	  Select the kernel logical page size. Increasing the page size
+	  will reduce software overhead at each page boundary, allow
+	  hardware prefetch mechanisms to be more effective, and allow
+	  larger dma transfers increasing IO efficiency and reducing
+	  overhead. However the utilization of memory will increase.
+	  For example, each cached file will using a multiple of the
+	  page size to hold its contents and the difference between the
+	  end of file and the end of page is wasted.
+
+	  If unsure, choose 4K_PAGES.
+
+config MICROBLAZE_4K_PAGES
+	bool "4k page size"
+
+config MICROBLAZE_8K_PAGES
+	bool "8k page size" if !MMU
+
+config MICROBLAZE_16K_PAGES
+	bool "16k page size" if !MMU
+
+config MICROBLAZE_32K_PAGES
+	bool "32k page size" if !MMU
+
+endchoice
+
 endmenu
 
 source "mm/Kconfig"
diff -uprN a/arch/microblaze/kernel/cpu/mb.c b/arch/microblaze/kernel/cpu/mb.c
--- a/arch/microblaze/kernel/cpu/mb.c	2010-05-13 09:55:59.000000000 -0500
+++ b/arch/microblaze/kernel/cpu/mb.c	2010-05-13 10:40:38.000000000 -0500
@@ -126,6 +126,7 @@ static int show_cpuinfo(struct seq_file 
 			cpuinfo.pvr_user1,
 			cpuinfo.pvr_user2);
 
+	count += seq_printf(m, "Page size:\t%lu\n", PAGE_SIZE);
 	return 0;
 }
 
diff -uprN a/arch/microblaze/kernel/vmlinux.lds.S b/arch/microblaze/kernel/vmlinux.lds.S
--- a/arch/microblaze/kernel/vmlinux.lds.S	2010-05-13 09:55:59.000000000 -0500
+++ b/arch/microblaze/kernel/vmlinux.lds.S	2010-05-10 15:32:30.000000000 -0500
@@ -55,7 +55,7 @@ SECTIONS {
 	 */
 	.sdata2 : AT(ADDR(.sdata2) - LOAD_OFFSET) {
 		_ssrw = .;
-		. = ALIGN(4096); /* page aligned when MMU used - origin 0x8 */
+		. = ALIGN(PAGE_SIZE); /* page aligned when MMU used */
 		*(.sdata2)
 	. = ALIGN(8);
 	_essrw = .;
@@ -70,7 +70,7 @@ SECTIONS {
 	/* Reserve some low RAM for r0 based memory references */
 	. = ALIGN(0x4) ;
 	r0_ram = . ;
-	. = . +  4096;	/* a page should be enough */
+	. = . +  PAGE_SIZE;	/* a page should be enough */
 
 	/* Under the microblaze ABI, .sdata and .sbss must be contiguous */
 	. = ALIGN(8);
@@ -120,7 +120,7 @@ SECTIONS {
 
 	__init_end_before_initramfs = .;
 
-	.init.ramfs ALIGN(4096) : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
+	.init.ramfs ALIGN(PAGE_SIZE) : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
 		__initramfs_start = .;
 		*(.init.ramfs)
 		__initramfs_end = .;
@@ -132,11 +132,11 @@ SECTIONS {
  * so that __init_end == __bss_start. This will make image.elf
  * consistent with the image.bin
  */
-		/* . = ALIGN(4096); */
+		/* . = ALIGN(PAGE_SIZE); */
 	}
 	__init_end = .;
 
-	.bss ALIGN (4096) : AT(ADDR(.bss) - LOAD_OFFSET) {
+	.bss ALIGN (PAGE_SIZE) : AT(ADDR(.bss) - LOAD_OFFSET) {
 		/* page aligned when MMU used */
 		__bss_start = . ;
 			*(.bss*)
@@ -145,7 +145,7 @@ SECTIONS {
 		__bss_stop = . ;
 		_ebss = . ;
 	}
-	. = ALIGN(4096);
+	. = ALIGN(PAGE_SIZE);
 	_end = .;
 
 	DISCARDS

