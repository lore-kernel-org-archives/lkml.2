Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab0GOP2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:28:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463Ab0GOP2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:28:00 -0400
Date: Thu, 15 Jul 2010 11:27:42 -0400
From: John Villalovos <jvillalo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Huang Ying <ying.huang@intel.com>, Thomas Renninger <trenn@suse.de>,
        "John L. Villalovos" <john.l.villalovos@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Mike Travis <travis@sgi.com>, sodarock@gmail.com
Subject: [PATCH] x86, cpu: Add Intel CPUID flags: ECMD, PLN, PTM and
 TSC_DEADLINE
Message-ID: <20100715152741.GA10482@linuxjohn.usersys.redhat.com>
Reply-To: John Villalovos <jvillalo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86, cpu: Add Intel CPUID flags: ECMD, PLN, PTM and TSC_DEADLINE

The June 2010 revision of the Intel Software Developer's Manual[1] has
added some new CPUID flags in Volume 2A.

The new CPUID flags are:
CPUID.01H:ECX[Bit 24] TSC_DEADLINE: A value of 1 indicates that the
processors local APIC timer supports one-shot operation using a TSC
deadline value.

CPUID.07H:EDX[Bit 4] PLN: Power limit notification controls are
supported if set.

CPUID.07H:EDX[Bit 5] ECMD: Clock modulation duty cycle extension is
supported if set.

CPUID.07H:EDX[Bit 6] PTM: Package thermal management is supported if set.

This patch adds support for these new flags.

It also re-organizes the 'cpuid_bit' structure in
arch/x86/kernel/cpu/addon_cpuid_features.c.  The reason for
re-organizing the structure is so that the data can be easily sorted by
CPUID level, register, and bit.  This will make it easier for future
contributions to keep the data in sorted order.

And fixes one minor spelling mistake in a comment.

1. http://www.intel.com/products/processor/manuals/

Signed-off-by: John L. Villalovos <john.l.villalovos@intel.com>

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4681459..f291828 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -120,6 +120,7 @@
 #define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
 #define X86_FEATURE_MOVBE	(4*32+22) /* MOVBE instruction */
 #define X86_FEATURE_POPCNT      (4*32+23) /* POPCNT instruction */
+#define X86_FEATURE_TSC_DEADLINE (4*32+24) /* TSC-Deadline support */
 #define X86_FEATURE_AES		(4*32+25) /* AES instructions */
 #define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
 #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
@@ -162,6 +163,9 @@
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
+#define X86_FEATURE_PLN		(7*32+ 3) /* Power Limit Notification controls */
+#define X86_FEATURE_ECMD	(7*32+ 4) /* Clock modulation duty cycle extension */
+#define X86_FEATURE_PTM		(7*32+ 5) /* Package Thermal Management */
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 10fa568..a72faef 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -1,5 +1,5 @@
 /*
- *	Routines to indentify additional cpu features that are scattered in
+ *	Routines to identify additional cpu features that are scattered in
  *	cpuid space.
  */
 #include <linux/cpu.h>
@@ -10,10 +10,10 @@
 #include <asm/apic.h>
 
 struct cpuid_bit {
-	u16 feature;
+	u32 level;
 	u8 reg;
 	u8 bit;
-	u32 level;
+	u16 feature;
 };
 
 enum cpuid_regs {
@@ -30,14 +30,17 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	const struct cpuid_bit *cb;
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_IDA,   		CR_EAX, 1, 0x00000006 },
-		{ X86_FEATURE_ARAT,  		CR_EAX, 2, 0x00000006 },
-		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006 },
-		{ X86_FEATURE_CPB,   		CR_EDX, 9, 0x80000007 },
-		{ X86_FEATURE_NPT,   		CR_EDX, 0, 0x8000000a },
-		{ X86_FEATURE_LBRV,  		CR_EDX, 1, 0x8000000a },
-		{ X86_FEATURE_SVML,  		CR_EDX, 2, 0x8000000a },
-		{ X86_FEATURE_NRIPS, 		CR_EDX, 3, 0x8000000a },
+		{ 0x00000006, CR_EAX,  1, X86_FEATURE_IDA		},
+		{ 0x00000006, CR_EAX,  2, X86_FEATURE_ARAT		},
+		{ 0x00000006, CR_EAX,  4, X86_FEATURE_PLN		},
+		{ 0x00000006, CR_EAX,  5, X86_FEATURE_ECMD		},
+		{ 0x00000006, CR_EAX,  6, X86_FEATURE_PTM		},
+		{ 0x00000006, CR_ECX,  0, X86_FEATURE_APERFMPERF	},
+		{ 0x80000007, CR_EDX,  9, X86_FEATURE_CPB		},
+		{ 0x8000000a, CR_EDX,  0, X86_FEATURE_NPT		},
+		{ 0x8000000a, CR_EDX,  1, X86_FEATURE_LBRV		},
+		{ 0x8000000a, CR_EDX,  2, X86_FEATURE_SVML		},
+		{ 0x8000000a, CR_EDX,  3, X86_FEATURE_NRIPS		},
 		{ 0, 0, 0, 0 }
 	};
 
