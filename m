Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab1KGQSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:18:45 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50069 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1KGQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:17:25 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 11/16] ARM: LPAE: Add fault handling support
Date: Mon,  7 Nov 2011 16:16:53 +0000
Message-Id: <1320682618-1182-12-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Nov 2011 16:17:12.0998 (UTC) FILETIME=[B540BC60:01CC9D68]
X-MC-Unique: 111110716172301001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pA7GJEwj015296

The DFSR and IFSR register format is different when LPAE is enabled. In
addition, DFSR and IFSR have similar definitions for the fault type.
This modifies the fault code to correctly handle the new format.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/system.h   |    8 ++++
 arch/arm/kernel/hw_breakpoint.c |    8 ++--
 arch/arm/mm/alignment.c         |    2 +-
 arch/arm/mm/fault.c             |   15 ++++++++
 arch/arm/mm/fault.h             |    8 ++++
 arch/arm/mm/fsr-3level.c        |   68 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 104 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/mm/fsr-3level.c

diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
index 984014b..ada914c 100644
--- a/arch/arm/include/asm/system.h
+++ b/arch/arm/include/asm/system.h
@@ -80,6 +80,14 @@ struct siginfo;
 void arm_notify_die(const char *str, struct pt_regs *regs, struct siginfo *info,
 		unsigned long err, unsigned long trap);
 
+#ifdef CONFIG_ARM_LPAE
+#define FAULT_CODE_ALIGNMENT	33
+#define FAULT_CODE_DEBUG	34
+#else
+#define FAULT_CODE_ALIGNMENT	1
+#define FAULT_CODE_DEBUG	2
+#endif
+
 void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
 				       struct pt_regs *),
 		     int sig, int code, const char *name);
diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index 814a52a9..d6a95ef 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -1016,10 +1016,10 @@ static int __init arch_hw_breakpoint_init(void)
 	}
 
 	/* Register debug fault handler. */
-	hook_fault_code(2, hw_breakpoint_pending, SIGTRAP, TRAP_HWBKPT,
-			"watchpoint debug exception");
-	hook_ifault_code(2, hw_breakpoint_pending, SIGTRAP, TRAP_HWBKPT,
-			"breakpoint debug exception");
+	hook_fault_code(FAULT_CODE_DEBUG, hw_breakpoint_pending, SIGTRAP,
+			TRAP_HWBKPT, "watchpoint debug exception");
+	hook_ifault_code(FAULT_CODE_DEBUG, hw_breakpoint_pending, SIGTRAP,
+			TRAP_HWBKPT, "breakpoint debug exception");
 
 	/* Register hotplug notifier. */
 	register_cpu_notifier(&dbg_reset_nb);
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index c335c76..caf14dc 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -968,7 +968,7 @@ static int __init alignment_init(void)
 		ai_usermode = safe_usermode(ai_usermode, false);
 	}
 
-	hook_fault_code(1, do_alignment, SIGBUS, BUS_ADRALN,
+	hook_fault_code(FAULT_CODE_ALIGNMENT, do_alignment, SIGBUS, BUS_ADRALN,
 			"alignment exception");
 
 	/*
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 2a02716..eb5520f 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -110,8 +110,10 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 
 		pte = pte_offset_map(pmd, addr);
 		printk(", *pte=%08llx", (long long)pte_val(*pte));
+#ifndef CONFIG_ARM_LPAE
 		printk(", *ppte=%08llx",
 		       (long long)pte_val(pte[PTE_HWTABLE_PTRS]));
+#endif
 		pte_unmap(pte);
 	} while(0);
 
@@ -428,6 +430,12 @@ do_translation_fault(unsigned long addr, unsigned int fsr,
 	pmd = pmd_offset(pud, addr);
 	pmd_k = pmd_offset(pud_k, addr);
 
+#ifdef CONFIG_ARM_LPAE
+	/*
+	 * Only one hardware entry per PMD with LPAE.
+	 */
+	index = 0;
+#else
 	/*
 	 * On ARM one Linux PGD entry contains two hardware entries (see page
 	 * tables layout in pgtable.h). We normally guarantee that we always
@@ -437,6 +445,7 @@ do_translation_fault(unsigned long addr, unsigned int fsr,
 	 * for the first of pair.
 	 */
 	index = (addr >> SECTION_SHIFT) & 1;
+#endif
 	if (pmd_none(pmd_k[index]))
 		goto bad_area;
 
@@ -484,7 +493,11 @@ struct fsr_info {
 };
 
 /* FSR definition */
+#ifdef CONFIG_ARM_LPAE
+#include "fsr-3level.c"
+#else
 #include "fsr-2level.c"
+#endif
 
 void __init
 hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int, struct pt_regs *),
@@ -553,6 +566,7 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
 	arm_notify_die("", regs, &info, ifsr, 0);
 }
 
+#ifndef CONFIG_ARM_LPAE
 static int __init exceptions_init(void)
 {
 	if (cpu_architecture() >= CPU_ARCH_ARMv6) {
@@ -575,3 +589,4 @@ static int __init exceptions_init(void)
 }
 
 arch_initcall(exceptions_init);
+#endif
diff --git a/arch/arm/mm/fault.h b/arch/arm/mm/fault.h
index 25b45c1..cf08bdf 100644
--- a/arch/arm/mm/fault.h
+++ b/arch/arm/mm/fault.h
@@ -8,11 +8,19 @@
 #define FSR_WRITE		(1 << 11)
 #define FSR_FS4			(1 << 10)
 #define FSR_FS3_0		(15)
+#define FSR_FS5_0		(0x3f)
 
+#ifdef CONFIG_ARM_LPAE
+static inline int fsr_fs(unsigned int fsr)
+{
+	return fsr & FSR_FS5_0;
+}
+#else
 static inline int fsr_fs(unsigned int fsr)
 {
 	return (fsr & FSR_FS3_0) | (fsr & FSR_FS4) >> 6;
 }
+#endif
 
 void do_bad_area(unsigned long addr, unsigned int fsr, struct pt_regs *regs);
 unsigned long search_exception_table(unsigned long addr);
diff --git a/arch/arm/mm/fsr-3level.c b/arch/arm/mm/fsr-3level.c
new file mode 100644
index 0000000..05a4e94
--- /dev/null
+++ b/arch/arm/mm/fsr-3level.c
@@ -0,0 +1,68 @@
+static struct fsr_info fsr_info[] = {
+	{ do_bad,		SIGBUS,  0,		"unknown 0"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 1"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 2"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 3"			},
+	{ do_bad,		SIGBUS,  0,		"reserved translation fault"	},
+	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 1 translation fault"	},
+	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 2 translation fault"	},
+	{ do_page_fault,	SIGSEGV, SEGV_MAPERR,	"level 3 translation fault"	},
+	{ do_bad,		SIGBUS,  0,		"reserved access flag fault"	},
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"level 1 access flag fault"	},
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"level 2 access flag fault"	},
+	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 access flag fault"	},
+	{ do_bad,		SIGBUS,  0,		"reserved permission fault"	},
+	{ do_bad,		SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
+	{ do_sect_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
+	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
+	{ do_bad,		SIGBUS,  0,		"synchronous external abort"	},
+	{ do_bad,		SIGBUS,  0,		"asynchronous external abort"	},
+	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
+	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
+	{ do_bad,		SIGBUS,  0,		"asynchronous parity error"	},
+	{ do_bad,		SIGBUS,  0,		"unknown 26"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 27"			},
+	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
+	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
+	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
+	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk" },
+	{ do_bad,		SIGBUS,  0,		"unknown 32"			},
+	{ do_bad,		SIGBUS,  BUS_ADRALN,	"alignment fault"		},
+	{ do_bad,		SIGBUS,  0,		"debug event"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 35"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 36"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 37"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 38"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 39"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 40"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 41"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 42"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 43"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 44"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 45"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 46"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 47"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 48"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 49"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 50"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 51"			},
+	{ do_bad,		SIGBUS,  0,		"implementation fault (lockdown abort)" },
+	{ do_bad,		SIGBUS,  0,		"unknown 53"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 54"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 55"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 56"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 57"			},
+	{ do_bad,		SIGBUS,  0,		"implementation fault (coprocessor abort)" },
+	{ do_bad,		SIGBUS,  0,		"unknown 59"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 60"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 61"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 62"			},
+	{ do_bad,		SIGBUS,  0,		"unknown 63"			},
+};
+
+#define ifsr_info	fsr_info

