Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab1EXVjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:39:49 -0400
Received: from service87.mimecast.com ([94.185.240.25]:34794 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933501Ab1EXVjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:47 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v6 12/18] ARM: LPAE: Add fault handling support
Date: Tue, 24 May 2011 22:39:18 +0100
Message-Id: <1306273164-18217-13-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 May 2011 21:39:48.0380 (UTC) FILETIME=[1AF965C0:01CC1A5B]
X-MC-Unique: 111052422394401101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4OLfIFI005058

The DFSR and IFSR register format is different when LPAE is enabled. In
addition, DFSR and IFSR have the similar definitions for the fault type.
This modifies modifies the fault code to correctly handle the new
format.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/alignment.c |    8 ++++-
 arch/arm/mm/fault.c     |   80 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 724ba3b..bc98a6e 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -906,6 +906,12 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	return 0;
 }
 
+#ifdef CONFIG_ARM_LPAE
+#define ALIGNMENT_FAULT		33
+#else
+#define ALIGNMENT_FAULT		1
+#endif
+
 /*
  * This needs to be done after sysctl_init, otherwise sys/ will be
  * overwritten.  Actually, this shouldn't be in sys/ at all since
@@ -939,7 +945,7 @@ static int __init alignment_init(void)
 		ai_usermode = UM_FIXUP;
 	}
 
-	hook_fault_code(1, do_alignment, SIGBUS, BUS_ADRALN,
+	hook_fault_code(ALIGNMENT_FAULT, do_alignment, SIGBUS, BUS_ADRALN,
 			"alignment exception");
 
 	/*
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index ee76923..e06918b 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -33,10 +33,15 @@
 #define FSR_WRITE		(1 << 11)
 #define FSR_FS4			(1 << 10)
 #define FSR_FS3_0		(15)
+#define FSR_FS5_0		(0x3f)
 
 static inline int fsr_fs(unsigned int fsr)
 {
+#ifdef CONFIG_ARM_LPAE
+	return fsr & FSR_FS5_0;
+#else
 	return (fsr & FSR_FS3_0) | (fsr & FSR_FS4) >> 6;
+#endif
 }
 
 #ifdef CONFIG_MMU
@@ -122,8 +127,10 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 
 		pte = pte_offset_map(pmd, addr);
 		printk(", *pte=%08llx", (long long)pte_val(*pte));
+#ifndef CONFIG_ARM_LPAE
 		printk(", *ppte=%08llx",
 		       (long long)pte_val(pte[PTE_HWTABLE_PTRS]));
+#endif
 		pte_unmap(pte);
 	} while(0);
 
@@ -490,6 +497,72 @@ static struct fsr_info {
 	int	code;
 	const char *name;
 } fsr_info[] = {
+#ifdef CONFIG_ARM_LPAE
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
+#else	/* !CONFIG_ARM_LPAE */
 	/*
 	 * The following are the standard ARMv3 and ARMv4 aborts.  ARMv5
 	 * defines these to be "precise" aborts.
@@ -531,6 +604,7 @@ static struct fsr_info {
 	{ do_bad,		SIGBUS,  0,		"unknown 29"			   },
 	{ do_bad,		SIGBUS,  0,		"unknown 30"			   },
 	{ do_bad,		SIGBUS,  0,		"unknown 31"			   }
+#endif	/* CONFIG_ARM_LPAE */
 };
 
 void __init
@@ -569,6 +643,9 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 }
 
 
+#ifdef CONFIG_ARM_LPAE
+#define ifsr_info	fsr_info
+#else	/* !CONFIG_ARM_LPAE */
 static struct fsr_info ifsr_info[] = {
 	{ do_bad,		SIGBUS,  0,		"unknown 0"			   },
 	{ do_bad,		SIGBUS,  0,		"unknown 1"			   },
@@ -603,6 +680,7 @@ static struct fsr_info ifsr_info[] = {
 	{ do_bad,		SIGBUS,  0,		"unknown 30"			   },
 	{ do_bad,		SIGBUS,  0,		"unknown 31"			   },
 };
+#endif	/* CONFIG_ARM_LPAE */
 
 void __init
 hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int, struct pt_regs *),
@@ -638,6 +716,7 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
 
 static int __init exceptions_init(void)
 {
+#ifndef CONFIG_ARM_LPAE
 	if (cpu_architecture() >= CPU_ARCH_ARMv6) {
 		hook_fault_code(4, do_translation_fault, SIGSEGV, SEGV_MAPERR,
 				"I-cache maintenance fault");
@@ -653,6 +732,7 @@ static int __init exceptions_init(void)
 		hook_fault_code(6, do_bad, SIGSEGV, SEGV_MAPERR,
 				"section access flag fault");
 	}
+#endif
 
 	return 0;
 }

