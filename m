Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab1BKOnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:43:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56133 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab1BKOnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:43:40 -0500
Date: Fri, 11 Feb 2011 14:42:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Sachin Verma <imschnvrm@gmail.com>, Rabin Vincent <rabin@rab.in>,
        Alexander Holler <holler@ahsoftware.de>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        catalin.marinas@arm.com
Subject: Re: ARM: relocation out of range (when loading a module)
Message-ID: <20110211144207.GJ23404@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1101121314470.25498@xanadu.home> <20110112184258.GH11039@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1101121350350.25498@xanadu.home> <AANLkTikLwTdV2B5Dyp_adCxgWcE-+Wb6uiN5MBfnA1_K@mail.gmail.com> <alpine.LFD.2.00.1101270030220.8580@xanadu.home> <20110210154322.GE1742@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1102101405010.14920@xanadu.home> <AANLkTi=KtFf5BU-iH-sUUL=Q30S90bk608JR4zFz2CKf@mail.gmail.com> <alpine.LFD.2.00.1102110838430.14920@xanadu.home> <AANLkTimW9zQ3EcEo8+gcxnS72Wa9VZELvrqdY+jP0B7W@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimW9zQ3EcEo8+gcxnS72Wa9VZELvrqdY+jP0B7W@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 02:25:28PM +0000, Dave Martin wrote:
>  if we can also move the initramfs somewhere less obstructive in the
> future, then so much the better.

This may do it, and it might even work.  Not particularly well tested
yet.  It'd be loads easier if we didn't have to worry about XIP.

 arch/arm/kernel/etm.c         |    2 +-
 arch/arm/kernel/smp.c         |    4 +-
 arch/arm/kernel/vmlinux.lds.S |  133 +++++++++++++++++++++-------------------
 arch/arm/mm/init.c            |    2 +-
 4 files changed, 74 insertions(+), 67 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 11db628..ca477d2 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -114,7 +114,7 @@ static int trace_start(struct tracectx *t)
 		return -EFAULT;
 	}
 
-	etm_setup_address_range(t, 1, (unsigned long)_stext,
+	etm_setup_address_range(t, 1, (unsigned long)_text,
 			(unsigned long)_etext, 0, 0);
 	etm_writel(t, 0, ETMR_TRACEENCTRL2);
 	etm_writel(t, 0, ETMR_TRACESSCTRL);
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 4539ebc..8ad77d3 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -95,7 +95,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 #ifndef CONFIG_HOTPLUG_CPU
 		identity_mapping_add(pgd, __pa(__init_begin), __pa(__init_end));
 #endif
-		identity_mapping_add(pgd, __pa(_stext), __pa(_etext));
+		identity_mapping_add(pgd, __pa(_text), __pa(_etext));
 		identity_mapping_add(pgd, __pa(_sdata), __pa(_edata));
 	}
 
@@ -143,7 +143,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 #ifndef CONFIG_HOTPLUG_CPU
 		identity_mapping_del(pgd, __pa(__init_begin), __pa(__init_end));
 #endif
-		identity_mapping_del(pgd, __pa(_stext), __pa(_etext));
+		identity_mapping_del(pgd, __pa(_text), __pa(_etext));
 		identity_mapping_del(pgd, __pa(_sdata), __pa(_edata));
 	}
 
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 45b5651..9cd098b 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -32,46 +32,98 @@ jiffies = jiffies_64 + 4;
 
 SECTIONS
 {
+	/*
+	 * unwind exit sections must be discarded before the rest of the
+	 * unwind sections get included.
+	 */
+	/DISCARD/ : {
+		*(.ARM.exidx.exit.text)
+		*(.ARM.extab.exit.text)
+		ARM_CPU_DISCARD(*(.ARM.exidx.cpuexit.text))
+		ARM_CPU_DISCARD(*(.ARM.extab.cpuexit.text))
+#ifndef CONFIG_HOTPLUG
+		*(.ARM.exidx.devexit.text)
+		*(.ARM.extab.devexit.text)
+#endif
+#ifndef CONFIG_MMU
+		*(.fixup)
+		*(__ex_table)
+#endif
+#ifndef CONFIG_SMP_ON_UP
+		*(.alt.smp.init)
+#endif
+	}
+
 #ifdef CONFIG_XIP_KERNEL
 	. = XIP_VIRT_ADDR(CONFIG_XIP_PHYS_ADDR);
 #else
 	. = PAGE_OFFSET + TEXT_OFFSET;
 #endif
 
-	.init : {			/* Init code and data		*/
-		_stext = .;
-		_sinittext = .;
-			HEAD_TEXT
-			INIT_TEXT
-		_einittext = .;
+	_text = .;
+	HEAD_TEXT_SECTION
+
+	.text : {			/* Real text segment		*/
+		_stext = .;		/* Text and read-only data	*/
+		__exception_text_start = .;
+		*(.exception.text)
+		__exception_text_end = .;
+		IRQENTRY_TEXT
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		KPROBES_TEXT
+#ifdef CONFIG_MMU
+		*(.fixup)
+#endif
+		*(.gnu.warning)
+		*(.glue_7)
+		*(.glue_7t)
+		. = ALIGN(4);
+		*(.got)			/* Global offset table		*/
+		ARM_CPU_KEEP(PROC_INFO)
+		_etext = .;		/* End of text and rodata section */
+	}
+
+#ifndef CONFIG_XIP_KERNEL
+	. = ALIGN(PAGE_SIZE);
+	__init_begin = .;
+#endif
+	INIT_TEXT_SECTION(0)
+	.init.proc.info : {
 		ARM_CPU_DISCARD(PROC_INFO)
+	}
+	.init.arch.info : {
 		__arch_info_begin = .;
 			*(.arch.info.init)
 		__arch_info_end = .;
+	}
+	.init.tagtable : {
 		__tagtable_begin = .;
 			*(.taglist.init)
 		__tagtable_end = .;
+	}
 #ifdef CONFIG_SMP_ON_UP
+	.init.smpalt : {
 		__smpalt_begin = .;
 			*(.alt.smp.init)
 		__smpalt_end = .;
+	}
 #endif
-
+	.init.pv_table : {
 		__pv_table_begin = .;
 			*(.pv_table)
 		__pv_table_end = .;
-
+	}
+	.init.data : {
+#ifndef CONFIG_XIP_KERNEL
+		INIT_DATA
+#endif
 		INIT_SETUP(16)
-
 		INIT_CALLS
 		CON_INITCALL
 		SECURITY_INITCALL
 		INIT_RAM_FS
-
-#ifndef CONFIG_XIP_KERNEL
-		__init_begin = _stext;
-		INIT_DATA
-#endif
 	}
 
 	PERCPU(PAGE_SIZE)
@@ -79,49 +131,10 @@ SECTIONS
 #ifndef CONFIG_XIP_KERNEL
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
-#endif
 
-	/*
-	 * unwind exit sections must be discarded before the rest of the
-	 * unwind sections get included.
-	 */
-	/DISCARD/ : {
-		*(.ARM.exidx.exit.text)
-		*(.ARM.extab.exit.text)
-		ARM_CPU_DISCARD(*(.ARM.exidx.cpuexit.text))
-		ARM_CPU_DISCARD(*(.ARM.extab.cpuexit.text))
-#ifndef CONFIG_HOTPLUG
-		*(.ARM.exidx.devexit.text)
-		*(.ARM.extab.devexit.text)
+	_data = .;
+	_sdata = .;
 #endif
-#ifndef CONFIG_MMU
-		*(.fixup)
-		*(__ex_table)
-#endif
-	}
-
-	.text : {			/* Real text segment		*/
-		_text = .;		/* Text and read-only data	*/
-			__exception_text_start = .;
-			*(.exception.text)
-			__exception_text_end = .;
-			IRQENTRY_TEXT
-			TEXT_TEXT
-			SCHED_TEXT
-			LOCK_TEXT
-			KPROBES_TEXT
-#ifdef CONFIG_MMU
-			*(.fixup)
-#endif
-			*(.gnu.warning)
-			*(.rodata)
-			*(.rodata.*)
-			*(.glue_7)
-			*(.glue_7t)
-		. = ALIGN(4);
-		*(.got)			/* Global offset table		*/
-			ARM_CPU_KEEP(PROC_INFO)
-	}
 
 	RO_DATA(PAGE_SIZE)
 
@@ -142,8 +155,6 @@ SECTIONS
 	}
 #endif
 
-	_etext = .;			/* End of text and rodata section */
-
 #ifdef CONFIG_XIP_KERNEL
 	__data_loc = ALIGN(4);		/* location in binary */
 	. = PAGE_OFFSET + TEXT_OFFSET;
@@ -153,8 +164,10 @@ SECTIONS
 #endif
 
 	.data : AT(__data_loc) {
+#ifdef CONFIG_XIP_KERNEL
 		_data = .;		/* address in memory */
 		_sdata = .;
+#endif
 
 		/*
 		 * first, the init task union, aligned
@@ -259,12 +272,6 @@ SECTIONS
 
 	/* Default discards */
 	DISCARDS
-
-#ifndef CONFIG_SMP_ON_UP
-	/DISCARD/ : {
-		*(.alt.smp.init)
-	}
-#endif
 }
 
 /*
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index cddd684..9e3c3c3 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -294,7 +294,7 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 #ifdef CONFIG_XIP_KERNEL
 	memblock_reserve(__pa(_sdata), _end - _sdata);
 #else
-	memblock_reserve(__pa(_stext), _end - _stext);
+	memblock_reserve(__pa(_text), _end - _text);
 #endif
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (phys_initrd_size &&

