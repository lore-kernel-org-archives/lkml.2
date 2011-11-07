Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab1KGQU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:20:58 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49685 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab1KGQRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:17:18 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 04/16] ARM: LPAE: Move the FSR definitions to separate files
Date: Mon,  7 Nov 2011 16:16:46 +0000
Message-Id: <1320682618-1182-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Nov 2011 16:17:11.0076 (UTC) FILETIME=[B41B7640:01CC9D68]
X-MC-Unique: 111110716171601701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pA7GLQ86015344

The FSR structure is different with LPAE and this patch moves the
classic MMU specific definition to a separate fsr-2level.c file that is
included in fault.c. It also moves the fsr_fs and FSR bits to the
fault.h file.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/fault.c      |   96 ++--------------------------------------------
 arch/arm/mm/fault.h      |   19 +++++++++-
 arch/arm/mm/fsr-2level.c |   78 +++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+), 93 deletions(-)
 create mode 100644 arch/arm/mm/fsr-2level.c

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index aa33949..2a02716 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -27,19 +27,6 @@
 
 #include "fault.h"
 
-/*
- * Fault status register encodings.  We steal bit 31 for our own purposes.
- */
-#define FSR_LNX_PF		(1 << 31)
-#define FSR_WRITE		(1 << 11)
-#define FSR_FS4			(1 << 10)
-#define FSR_FS3_0		(15)
-
-static inline int fsr_fs(unsigned int fsr)
-{
-	return (fsr & FSR_FS3_0) | (fsr & FSR_FS4) >> 6;
-}
-
 #ifdef CONFIG_MMU
 
 #ifdef CONFIG_KPROBES
@@ -489,55 +476,16 @@ do_bad(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	return 1;
 }
 
-static struct fsr_info {
+struct fsr_info {
 	int	(*fn)(unsigned long addr, unsigned int fsr, struct pt_regs *regs);
 	int	sig;
 	int	code;
 	const char *name;
-} fsr_info[] = {
-	/*
-	 * The following are the standard ARMv3 and ARMv4 aborts.  ARMv5
-	 * defines these to be "precise" aborts.
-	 */
-	{ do_bad,		SIGSEGV, 0,		"vector exception"		   },
-	{ do_bad,		SIGBUS,	 BUS_ADRALN,	"alignment exception"		   },
-	{ do_bad,		SIGKILL, 0,		"terminal exception"		   },
-	{ do_bad,		SIGBUS,	 BUS_ADRALN,	"alignment exception"		   },
-	{ do_bad,		SIGBUS,	 0,		"external abort on linefetch"	   },
-	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"section translation fault"	   },
-	{ do_bad,		SIGBUS,	 0,		"external abort on linefetch"	   },
-	{ do_page_fault,	SIGSEGV, SEGV_MAPERR,	"page translation fault"	   },
-	{ do_bad,		SIGBUS,	 0,		"external abort on non-linefetch"  },
-	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"section domain fault"		   },
-	{ do_bad,		SIGBUS,	 0,		"external abort on non-linefetch"  },
-	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"page domain fault"		   },
-	{ do_bad,		SIGBUS,	 0,		"external abort on translation"	   },
-	{ do_sect_fault,	SIGSEGV, SEGV_ACCERR,	"section permission fault"	   },
-	{ do_bad,		SIGBUS,	 0,		"external abort on translation"	   },
-	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"page permission fault"		   },
-	/*
-	 * The following are "imprecise" aborts, which are signalled by bit
-	 * 10 of the FSR, and may not be recoverable.  These are only
-	 * supported if the CPU abort handler supports bit 10.
-	 */
-	{ do_bad,		SIGBUS,  0,		"unknown 16"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 17"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 18"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 19"			   },
-	{ do_bad,		SIGBUS,  0,		"lock abort"			   }, /* xscale */
-	{ do_bad,		SIGBUS,  0,		"unknown 21"			   },
-	{ do_bad,		SIGBUS,  BUS_OBJERR,	"imprecise external abort"	   }, /* xscale */
-	{ do_bad,		SIGBUS,  0,		"unknown 23"			   },
-	{ do_bad,		SIGBUS,  0,		"dcache parity error"		   }, /* xscale */
-	{ do_bad,		SIGBUS,  0,		"unknown 25"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 26"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 27"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 28"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 29"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 30"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 31"			   }
 };
 
+/* FSR definition */
+#include "fsr-2level.c"
+
 void __init
 hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int, struct pt_regs *),
 		int sig, int code, const char *name)
@@ -573,42 +521,6 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	arm_notify_die("", regs, &info, fsr, 0);
 }
 
-
-static struct fsr_info ifsr_info[] = {
-	{ do_bad,		SIGBUS,  0,		"unknown 0"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 1"			   },
-	{ do_bad,		SIGBUS,  0,		"debug event"			   },
-	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"section access flag fault"	   },
-	{ do_bad,		SIGBUS,  0,		"unknown 4"			   },
-	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"section translation fault"	   },
-	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"page access flag fault"	   },
-	{ do_page_fault,	SIGSEGV, SEGV_MAPERR,	"page translation fault"	   },
-	{ do_bad,		SIGBUS,	 0,		"external abort on non-linefetch"  },
-	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"section domain fault"		   },
-	{ do_bad,		SIGBUS,  0,		"unknown 10"			   },
-	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"page domain fault"		   },
-	{ do_bad,		SIGBUS,	 0,		"external abort on translation"	   },
-	{ do_sect_fault,	SIGSEGV, SEGV_ACCERR,	"section permission fault"	   },
-	{ do_bad,		SIGBUS,	 0,		"external abort on translation"	   },
-	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"page permission fault"		   },
-	{ do_bad,		SIGBUS,  0,		"unknown 16"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 17"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 18"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 19"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 20"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 21"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 22"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 23"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 24"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 25"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 26"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 27"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 28"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 29"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 30"			   },
-	{ do_bad,		SIGBUS,  0,		"unknown 31"			   },
-};
-
 void __init
 hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int, struct pt_regs *),
 		 int sig, int code, const char *name)
diff --git a/arch/arm/mm/fault.h b/arch/arm/mm/fault.h
index 49e9e38..25b45c1 100644
--- a/arch/arm/mm/fault.h
+++ b/arch/arm/mm/fault.h
@@ -1,3 +1,20 @@
-void do_bad_area(unsigned long addr, unsigned int fsr, struct pt_regs *regs);
+#ifndef __ARCH_ARM_FAULT_H
+#define __ARCH_ARM_FAULT_H
+
+/*
+ * Fault status register encodings.  We steal bit 31 for our own purposes.
+ */
+#define FSR_LNX_PF		(1 << 31)
+#define FSR_WRITE		(1 << 11)
+#define FSR_FS4			(1 << 10)
+#define FSR_FS3_0		(15)
+
+static inline int fsr_fs(unsigned int fsr)
+{
+	return (fsr & FSR_FS3_0) | (fsr & FSR_FS4) >> 6;
+}
 
+void do_bad_area(unsigned long addr, unsigned int fsr, struct pt_regs *regs);
 unsigned long search_exception_table(unsigned long addr);
+
+#endif	/* __ARCH_ARM_FAULT_H */
diff --git a/arch/arm/mm/fsr-2level.c b/arch/arm/mm/fsr-2level.c
new file mode 100644
index 0000000..9260894
--- /dev/null
+++ b/arch/arm/mm/fsr-2level.c
@@ -0,0 +1,78 @@
+static struct fsr_info fsr_info[] = {
+	/*
+	 * The following are the standard ARMv3 and ARMv4 aborts.  ARMv5
+	 * defines these to be "precise" aborts.
+	 */
+	{ do_bad,		SIGSEGV, 0,		"vector exception"		   },
+	{ do_bad,		SIGBUS,	 BUS_ADRALN,	"alignment exception"		   },
+	{ do_bad,		SIGKILL, 0,		"terminal exception"		   },
+	{ do_bad,		SIGBUS,	 BUS_ADRALN,	"alignment exception"		   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on linefetch"	   },
+	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"section translation fault"	   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on linefetch"	   },
+	{ do_page_fault,	SIGSEGV, SEGV_MAPERR,	"page translation fault"	   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on non-linefetch"  },
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"section domain fault"		   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on non-linefetch"  },
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"page domain fault"		   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on translation"	   },
+	{ do_sect_fault,	SIGSEGV, SEGV_ACCERR,	"section permission fault"	   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on translation"	   },
+	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"page permission fault"		   },
+	/*
+	 * The following are "imprecise" aborts, which are signalled by bit
+	 * 10 of the FSR, and may not be recoverable.  These are only
+	 * supported if the CPU abort handler supports bit 10.
+	 */
+	{ do_bad,		SIGBUS,  0,		"unknown 16"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 17"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 18"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 19"			   },
+	{ do_bad,		SIGBUS,  0,		"lock abort"			   }, /* xscale */
+	{ do_bad,		SIGBUS,  0,		"unknown 21"			   },
+	{ do_bad,		SIGBUS,  BUS_OBJERR,	"imprecise external abort"	   }, /* xscale */
+	{ do_bad,		SIGBUS,  0,		"unknown 23"			   },
+	{ do_bad,		SIGBUS,  0,		"dcache parity error"		   }, /* xscale */
+	{ do_bad,		SIGBUS,  0,		"unknown 25"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 26"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 27"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 28"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 29"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 30"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 31"			   }
+};
+
+static struct fsr_info ifsr_info[] = {
+	{ do_bad,		SIGBUS,  0,		"unknown 0"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 1"			   },
+	{ do_bad,		SIGBUS,  0,		"debug event"			   },
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"section access flag fault"	   },
+	{ do_bad,		SIGBUS,  0,		"unknown 4"			   },
+	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"section translation fault"	   },
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"page access flag fault"	   },
+	{ do_page_fault,	SIGSEGV, SEGV_MAPERR,	"page translation fault"	   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on non-linefetch"  },
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"section domain fault"		   },
+	{ do_bad,		SIGBUS,  0,		"unknown 10"			   },
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"page domain fault"		   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on translation"	   },
+	{ do_sect_fault,	SIGSEGV, SEGV_ACCERR,	"section permission fault"	   },
+	{ do_bad,		SIGBUS,	 0,		"external abort on translation"	   },
+	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"page permission fault"		   },
+	{ do_bad,		SIGBUS,  0,		"unknown 16"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 17"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 18"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 19"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 20"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 21"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 22"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 23"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 24"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 25"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 26"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 27"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 28"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 29"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 30"			   },
+	{ do_bad,		SIGBUS,  0,		"unknown 31"			   },
+};

