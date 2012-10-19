Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030544Ab2JSQ4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab2JSQ4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:56:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/5] x86: Disintegrate asm/svm.h and asm/vmx.h to produce UAPI
 components for perf
To: mingo@kernel.org, tglx@linutronix.de, acme@ghostprotocols.net
Cc: dhowells@redhat.com, davem@davemloft.net, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Fri, 19 Oct 2012 17:56:33 +0100
Message-ID: <20121019165633.23037.83106.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
References: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/svm.h and asm/vmx.h to produce UAPI components for perf to
use:

 (1) The bits outside of the __KERNEL__ guards are moved to an equivalently
     named header under arch/x86/include/uapi/.

 (2) #includes are placed into the remnant files to include the UAPI files.

 (3) The __KERNEL__ guards are erased.

After this, perf no longer needs the -Iarch/foo/include flag and can just
manage with the uapi -I flags.

If these actually want posting to userspace, then they will need a headers-y
line adding to the uapi Kbuild file.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/asm/svm.h      |  133 +--------------------------------------
 arch/x86/include/asm/vmx.h      |   87 +-------------------------
 arch/x86/include/uapi/asm/svm.h |  131 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/vmx.h |  108 ++++++++++++++++++++++++++++++++
 tools/perf/Makefile             |    1 
 5 files changed, 243 insertions(+), 217 deletions(-)
 create mode 100644 arch/x86/include/uapi/asm/svm.h
 create mode 100644 arch/x86/include/uapi/asm/vmx.h

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index cdf5674..a986059 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -1,134 +1,7 @@
 #ifndef __SVM_H
 #define __SVM_H
 
-#define SVM_EXIT_READ_CR0      0x000
-#define SVM_EXIT_READ_CR3      0x003
-#define SVM_EXIT_READ_CR4      0x004
-#define SVM_EXIT_READ_CR8      0x008
-#define SVM_EXIT_WRITE_CR0     0x010
-#define SVM_EXIT_WRITE_CR3     0x013
-#define SVM_EXIT_WRITE_CR4     0x014
-#define SVM_EXIT_WRITE_CR8     0x018
-#define SVM_EXIT_READ_DR0      0x020
-#define SVM_EXIT_READ_DR1      0x021
-#define SVM_EXIT_READ_DR2      0x022
-#define SVM_EXIT_READ_DR3      0x023
-#define SVM_EXIT_READ_DR4      0x024
-#define SVM_EXIT_READ_DR5      0x025
-#define SVM_EXIT_READ_DR6      0x026
-#define SVM_EXIT_READ_DR7      0x027
-#define SVM_EXIT_WRITE_DR0     0x030
-#define SVM_EXIT_WRITE_DR1     0x031
-#define SVM_EXIT_WRITE_DR2     0x032
-#define SVM_EXIT_WRITE_DR3     0x033
-#define SVM_EXIT_WRITE_DR4     0x034
-#define SVM_EXIT_WRITE_DR5     0x035
-#define SVM_EXIT_WRITE_DR6     0x036
-#define SVM_EXIT_WRITE_DR7     0x037
-#define SVM_EXIT_EXCP_BASE     0x040
-#define SVM_EXIT_INTR          0x060
-#define SVM_EXIT_NMI           0x061
-#define SVM_EXIT_SMI           0x062
-#define SVM_EXIT_INIT          0x063
-#define SVM_EXIT_VINTR         0x064
-#define SVM_EXIT_CR0_SEL_WRITE 0x065
-#define SVM_EXIT_IDTR_READ     0x066
-#define SVM_EXIT_GDTR_READ     0x067
-#define SVM_EXIT_LDTR_READ     0x068
-#define SVM_EXIT_TR_READ       0x069
-#define SVM_EXIT_IDTR_WRITE    0x06a
-#define SVM_EXIT_GDTR_WRITE    0x06b
-#define SVM_EXIT_LDTR_WRITE    0x06c
-#define SVM_EXIT_TR_WRITE      0x06d
-#define SVM_EXIT_RDTSC         0x06e
-#define SVM_EXIT_RDPMC         0x06f
-#define SVM_EXIT_PUSHF         0x070
-#define SVM_EXIT_POPF          0x071
-#define SVM_EXIT_CPUID         0x072
-#define SVM_EXIT_RSM           0x073
-#define SVM_EXIT_IRET          0x074
-#define SVM_EXIT_SWINT         0x075
-#define SVM_EXIT_INVD          0x076
-#define SVM_EXIT_PAUSE         0x077
-#define SVM_EXIT_HLT           0x078
-#define SVM_EXIT_INVLPG        0x079
-#define SVM_EXIT_INVLPGA       0x07a
-#define SVM_EXIT_IOIO          0x07b
-#define SVM_EXIT_MSR           0x07c
-#define SVM_EXIT_TASK_SWITCH   0x07d
-#define SVM_EXIT_FERR_FREEZE   0x07e
-#define SVM_EXIT_SHUTDOWN      0x07f
-#define SVM_EXIT_VMRUN         0x080
-#define SVM_EXIT_VMMCALL       0x081
-#define SVM_EXIT_VMLOAD        0x082
-#define SVM_EXIT_VMSAVE        0x083
-#define SVM_EXIT_STGI          0x084
-#define SVM_EXIT_CLGI          0x085
-#define SVM_EXIT_SKINIT        0x086
-#define SVM_EXIT_RDTSCP        0x087
-#define SVM_EXIT_ICEBP         0x088
-#define SVM_EXIT_WBINVD        0x089
-#define SVM_EXIT_MONITOR       0x08a
-#define SVM_EXIT_MWAIT         0x08b
-#define SVM_EXIT_MWAIT_COND    0x08c
-#define SVM_EXIT_XSETBV        0x08d
-#define SVM_EXIT_NPF           0x400
-
-#define SVM_EXIT_ERR           -1
-
-#define SVM_EXIT_REASONS \
-	{ SVM_EXIT_READ_CR0,    "read_cr0" }, \
-	{ SVM_EXIT_READ_CR3,    "read_cr3" }, \
-	{ SVM_EXIT_READ_CR4,    "read_cr4" }, \
-	{ SVM_EXIT_READ_CR8,    "read_cr8" }, \
-	{ SVM_EXIT_WRITE_CR0,   "write_cr0" }, \
-	{ SVM_EXIT_WRITE_CR3,   "write_cr3" }, \
-	{ SVM_EXIT_WRITE_CR4,   "write_cr4" }, \
-	{ SVM_EXIT_WRITE_CR8,   "write_cr8" }, \
-	{ SVM_EXIT_READ_DR0,    "read_dr0" }, \
-	{ SVM_EXIT_READ_DR1,    "read_dr1" }, \
-	{ SVM_EXIT_READ_DR2,    "read_dr2" }, \
-	{ SVM_EXIT_READ_DR3,    "read_dr3" }, \
-	{ SVM_EXIT_WRITE_DR0,   "write_dr0" }, \
-	{ SVM_EXIT_WRITE_DR1,   "write_dr1" }, \
-	{ SVM_EXIT_WRITE_DR2,   "write_dr2" }, \
-	{ SVM_EXIT_WRITE_DR3,   "write_dr3" }, \
-	{ SVM_EXIT_WRITE_DR5,   "write_dr5" }, \
-	{ SVM_EXIT_WRITE_DR7,   "write_dr7" }, \
-	{ SVM_EXIT_EXCP_BASE + DB_VECTOR,       "DB excp" }, \
-	{ SVM_EXIT_EXCP_BASE + BP_VECTOR,       "BP excp" }, \
-	{ SVM_EXIT_EXCP_BASE + UD_VECTOR,       "UD excp" }, \
-	{ SVM_EXIT_EXCP_BASE + PF_VECTOR,       "PF excp" }, \
-	{ SVM_EXIT_EXCP_BASE + NM_VECTOR,       "NM excp" }, \
-	{ SVM_EXIT_EXCP_BASE + MC_VECTOR,       "MC excp" }, \
-	{ SVM_EXIT_INTR,        "interrupt" }, \
-	{ SVM_EXIT_NMI,         "nmi" }, \
-	{ SVM_EXIT_SMI,         "smi" }, \
-	{ SVM_EXIT_INIT,        "init" }, \
-	{ SVM_EXIT_VINTR,       "vintr" }, \
-	{ SVM_EXIT_CPUID,       "cpuid" }, \
-	{ SVM_EXIT_INVD,        "invd" }, \
-	{ SVM_EXIT_HLT,         "hlt" }, \
-	{ SVM_EXIT_INVLPG,      "invlpg" }, \
-	{ SVM_EXIT_INVLPGA,     "invlpga" }, \
-	{ SVM_EXIT_IOIO,        "io" }, \
-	{ SVM_EXIT_MSR,         "msr" }, \
-	{ SVM_EXIT_TASK_SWITCH, "task_switch" }, \
-	{ SVM_EXIT_SHUTDOWN,    "shutdown" }, \
-	{ SVM_EXIT_VMRUN,       "vmrun" }, \
-	{ SVM_EXIT_VMMCALL,     "hypercall" }, \
-	{ SVM_EXIT_VMLOAD,      "vmload" }, \
-	{ SVM_EXIT_VMSAVE,      "vmsave" }, \
-	{ SVM_EXIT_STGI,        "stgi" }, \
-	{ SVM_EXIT_CLGI,        "clgi" }, \
-	{ SVM_EXIT_SKINIT,      "skinit" }, \
-	{ SVM_EXIT_WBINVD,      "wbinvd" }, \
-	{ SVM_EXIT_MONITOR,     "monitor" }, \
-	{ SVM_EXIT_MWAIT,       "mwait" }, \
-	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
-	{ SVM_EXIT_NPF,         "npf" }
-
-#ifdef __KERNEL__
+#include <uapi/asm/svm.h>
 
 enum {
 	INTERCEPT_INTR,
@@ -402,6 +275,4 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_STGI   ".byte 0x0f, 0x01, 0xdc"
 #define SVM_INVLPGA ".byte 0x0f, 0x01, 0xdf"
 
-#endif
-
-#endif
+#endif /* __SVM_H */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 36ec21c..f0dff1b 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -25,88 +25,7 @@
  *
  */
 
-#define VMX_EXIT_REASONS_FAILED_VMENTRY         0x80000000
-
-#define EXIT_REASON_EXCEPTION_NMI       0
-#define EXIT_REASON_EXTERNAL_INTERRUPT  1
-#define EXIT_REASON_TRIPLE_FAULT        2
-
-#define EXIT_REASON_PENDING_INTERRUPT   7
-#define EXIT_REASON_NMI_WINDOW          8
-#define EXIT_REASON_TASK_SWITCH         9
-#define EXIT_REASON_CPUID               10
-#define EXIT_REASON_HLT                 12
-#define EXIT_REASON_INVD                13
-#define EXIT_REASON_INVLPG              14
-#define EXIT_REASON_RDPMC               15
-#define EXIT_REASON_RDTSC               16
-#define EXIT_REASON_VMCALL              18
-#define EXIT_REASON_VMCLEAR             19
-#define EXIT_REASON_VMLAUNCH            20
-#define EXIT_REASON_VMPTRLD             21
-#define EXIT_REASON_VMPTRST             22
-#define EXIT_REASON_VMREAD              23
-#define EXIT_REASON_VMRESUME            24
-#define EXIT_REASON_VMWRITE             25
-#define EXIT_REASON_VMOFF               26
-#define EXIT_REASON_VMON                27
-#define EXIT_REASON_CR_ACCESS           28
-#define EXIT_REASON_DR_ACCESS           29
-#define EXIT_REASON_IO_INSTRUCTION      30
-#define EXIT_REASON_MSR_READ            31
-#define EXIT_REASON_MSR_WRITE           32
-#define EXIT_REASON_INVALID_STATE       33
-#define EXIT_REASON_MWAIT_INSTRUCTION   36
-#define EXIT_REASON_MONITOR_INSTRUCTION 39
-#define EXIT_REASON_PAUSE_INSTRUCTION   40
-#define EXIT_REASON_MCE_DURING_VMENTRY  41
-#define EXIT_REASON_TPR_BELOW_THRESHOLD 43
-#define EXIT_REASON_APIC_ACCESS         44
-#define EXIT_REASON_EPT_VIOLATION       48
-#define EXIT_REASON_EPT_MISCONFIG       49
-#define EXIT_REASON_WBINVD              54
-#define EXIT_REASON_XSETBV              55
-#define EXIT_REASON_INVPCID             58
-
-#define VMX_EXIT_REASONS \
-	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
-	{ EXIT_REASON_EXTERNAL_INTERRUPT,    "EXTERNAL_INTERRUPT" }, \
-	{ EXIT_REASON_TRIPLE_FAULT,          "TRIPLE_FAULT" }, \
-	{ EXIT_REASON_PENDING_INTERRUPT,     "PENDING_INTERRUPT" }, \
-	{ EXIT_REASON_NMI_WINDOW,            "NMI_WINDOW" }, \
-	{ EXIT_REASON_TASK_SWITCH,           "TASK_SWITCH" }, \
-	{ EXIT_REASON_CPUID,                 "CPUID" }, \
-	{ EXIT_REASON_HLT,                   "HLT" }, \
-	{ EXIT_REASON_INVLPG,                "INVLPG" }, \
-	{ EXIT_REASON_RDPMC,                 "RDPMC" }, \
-	{ EXIT_REASON_RDTSC,                 "RDTSC" }, \
-	{ EXIT_REASON_VMCALL,                "VMCALL" }, \
-	{ EXIT_REASON_VMCLEAR,               "VMCLEAR" }, \
-	{ EXIT_REASON_VMLAUNCH,              "VMLAUNCH" }, \
-	{ EXIT_REASON_VMPTRLD,               "VMPTRLD" }, \
-	{ EXIT_REASON_VMPTRST,               "VMPTRST" }, \
-	{ EXIT_REASON_VMREAD,                "VMREAD" }, \
-	{ EXIT_REASON_VMRESUME,              "VMRESUME" }, \
-	{ EXIT_REASON_VMWRITE,               "VMWRITE" }, \
-	{ EXIT_REASON_VMOFF,                 "VMOFF" }, \
-	{ EXIT_REASON_VMON,                  "VMON" }, \
-	{ EXIT_REASON_CR_ACCESS,             "CR_ACCESS" }, \
-	{ EXIT_REASON_DR_ACCESS,             "DR_ACCESS" }, \
-	{ EXIT_REASON_IO_INSTRUCTION,        "IO_INSTRUCTION" }, \
-	{ EXIT_REASON_MSR_READ,              "MSR_READ" }, \
-	{ EXIT_REASON_MSR_WRITE,             "MSR_WRITE" }, \
-	{ EXIT_REASON_MWAIT_INSTRUCTION,     "MWAIT_INSTRUCTION" }, \
-	{ EXIT_REASON_MONITOR_INSTRUCTION,   "MONITOR_INSTRUCTION" }, \
-	{ EXIT_REASON_PAUSE_INSTRUCTION,     "PAUSE_INSTRUCTION" }, \
-	{ EXIT_REASON_MCE_DURING_VMENTRY,    "MCE_DURING_VMENTRY" }, \
-	{ EXIT_REASON_TPR_BELOW_THRESHOLD,   "TPR_BELOW_THRESHOLD" }, \
-	{ EXIT_REASON_APIC_ACCESS,           "APIC_ACCESS" }, \
-	{ EXIT_REASON_EPT_VIOLATION,         "EPT_VIOLATION" }, \
-	{ EXIT_REASON_EPT_MISCONFIG,         "EPT_MISCONFIG" }, \
-	{ EXIT_REASON_WBINVD,                "WBINVD" }
-
-#ifdef __KERNEL__
-
+#include <uapi/asm/vmx.h>
 #include <linux/types.h>
 
 /*
@@ -526,6 +445,4 @@ enum vm_instruction_error_number {
 	VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID = 28,
 };
 
-#endif
-
-#endif
+#endif /* VMX_H */
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
new file mode 100644
index 0000000..0e58fcf
--- /dev/null
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -0,0 +1,131 @@
+#ifndef _UAPI_ASM_SVM_H
+#define _UAPI_ASM_SVM_H
+
+#define SVM_EXIT_READ_CR0      0x000
+#define SVM_EXIT_READ_CR3      0x003
+#define SVM_EXIT_READ_CR4      0x004
+#define SVM_EXIT_READ_CR8      0x008
+#define SVM_EXIT_WRITE_CR0     0x010
+#define SVM_EXIT_WRITE_CR3     0x013
+#define SVM_EXIT_WRITE_CR4     0x014
+#define SVM_EXIT_WRITE_CR8     0x018
+#define SVM_EXIT_READ_DR0      0x020
+#define SVM_EXIT_READ_DR1      0x021
+#define SVM_EXIT_READ_DR2      0x022
+#define SVM_EXIT_READ_DR3      0x023
+#define SVM_EXIT_READ_DR4      0x024
+#define SVM_EXIT_READ_DR5      0x025
+#define SVM_EXIT_READ_DR6      0x026
+#define SVM_EXIT_READ_DR7      0x027
+#define SVM_EXIT_WRITE_DR0     0x030
+#define SVM_EXIT_WRITE_DR1     0x031
+#define SVM_EXIT_WRITE_DR2     0x032
+#define SVM_EXIT_WRITE_DR3     0x033
+#define SVM_EXIT_WRITE_DR4     0x034
+#define SVM_EXIT_WRITE_DR5     0x035
+#define SVM_EXIT_WRITE_DR6     0x036
+#define SVM_EXIT_WRITE_DR7     0x037
+#define SVM_EXIT_EXCP_BASE     0x040
+#define SVM_EXIT_INTR          0x060
+#define SVM_EXIT_NMI           0x061
+#define SVM_EXIT_SMI           0x062
+#define SVM_EXIT_INIT          0x063
+#define SVM_EXIT_VINTR         0x064
+#define SVM_EXIT_CR0_SEL_WRITE 0x065
+#define SVM_EXIT_IDTR_READ     0x066
+#define SVM_EXIT_GDTR_READ     0x067
+#define SVM_EXIT_LDTR_READ     0x068
+#define SVM_EXIT_TR_READ       0x069
+#define SVM_EXIT_IDTR_WRITE    0x06a
+#define SVM_EXIT_GDTR_WRITE    0x06b
+#define SVM_EXIT_LDTR_WRITE    0x06c
+#define SVM_EXIT_TR_WRITE      0x06d
+#define SVM_EXIT_RDTSC         0x06e
+#define SVM_EXIT_RDPMC         0x06f
+#define SVM_EXIT_PUSHF         0x070
+#define SVM_EXIT_POPF          0x071
+#define SVM_EXIT_CPUID         0x072
+#define SVM_EXIT_RSM           0x073
+#define SVM_EXIT_IRET          0x074
+#define SVM_EXIT_SWINT         0x075
+#define SVM_EXIT_INVD          0x076
+#define SVM_EXIT_PAUSE         0x077
+#define SVM_EXIT_HLT           0x078
+#define SVM_EXIT_INVLPG        0x079
+#define SVM_EXIT_INVLPGA       0x07a
+#define SVM_EXIT_IOIO          0x07b
+#define SVM_EXIT_MSR           0x07c
+#define SVM_EXIT_TASK_SWITCH   0x07d
+#define SVM_EXIT_FERR_FREEZE   0x07e
+#define SVM_EXIT_SHUTDOWN      0x07f
+#define SVM_EXIT_VMRUN         0x080
+#define SVM_EXIT_VMMCALL       0x081
+#define SVM_EXIT_VMLOAD        0x082
+#define SVM_EXIT_VMSAVE        0x083
+#define SVM_EXIT_STGI          0x084
+#define SVM_EXIT_CLGI          0x085
+#define SVM_EXIT_SKINIT        0x086
+#define SVM_EXIT_RDTSCP        0x087
+#define SVM_EXIT_ICEBP         0x088
+#define SVM_EXIT_WBINVD        0x089
+#define SVM_EXIT_MONITOR       0x08a
+#define SVM_EXIT_MWAIT         0x08b
+#define SVM_EXIT_MWAIT_COND    0x08c
+#define SVM_EXIT_XSETBV        0x08d
+#define SVM_EXIT_NPF           0x400
+
+#define SVM_EXIT_ERR           -1
+
+#define SVM_EXIT_REASONS \
+	{ SVM_EXIT_READ_CR0,    "read_cr0" }, \
+	{ SVM_EXIT_READ_CR3,    "read_cr3" }, \
+	{ SVM_EXIT_READ_CR4,    "read_cr4" }, \
+	{ SVM_EXIT_READ_CR8,    "read_cr8" }, \
+	{ SVM_EXIT_WRITE_CR0,   "write_cr0" }, \
+	{ SVM_EXIT_WRITE_CR3,   "write_cr3" }, \
+	{ SVM_EXIT_WRITE_CR4,   "write_cr4" }, \
+	{ SVM_EXIT_WRITE_CR8,   "write_cr8" }, \
+	{ SVM_EXIT_READ_DR0,    "read_dr0" }, \
+	{ SVM_EXIT_READ_DR1,    "read_dr1" }, \
+	{ SVM_EXIT_READ_DR2,    "read_dr2" }, \
+	{ SVM_EXIT_READ_DR3,    "read_dr3" }, \
+	{ SVM_EXIT_WRITE_DR0,   "write_dr0" }, \
+	{ SVM_EXIT_WRITE_DR1,   "write_dr1" }, \
+	{ SVM_EXIT_WRITE_DR2,   "write_dr2" }, \
+	{ SVM_EXIT_WRITE_DR3,   "write_dr3" }, \
+	{ SVM_EXIT_WRITE_DR5,   "write_dr5" }, \
+	{ SVM_EXIT_WRITE_DR7,   "write_dr7" }, \
+	{ SVM_EXIT_EXCP_BASE + DB_VECTOR,       "DB excp" }, \
+	{ SVM_EXIT_EXCP_BASE + BP_VECTOR,       "BP excp" }, \
+	{ SVM_EXIT_EXCP_BASE + UD_VECTOR,       "UD excp" }, \
+	{ SVM_EXIT_EXCP_BASE + PF_VECTOR,       "PF excp" }, \
+	{ SVM_EXIT_EXCP_BASE + NM_VECTOR,       "NM excp" }, \
+	{ SVM_EXIT_EXCP_BASE + MC_VECTOR,       "MC excp" }, \
+	{ SVM_EXIT_INTR,        "interrupt" }, \
+	{ SVM_EXIT_NMI,         "nmi" }, \
+	{ SVM_EXIT_SMI,         "smi" }, \
+	{ SVM_EXIT_INIT,        "init" }, \
+	{ SVM_EXIT_VINTR,       "vintr" }, \
+	{ SVM_EXIT_CPUID,       "cpuid" }, \
+	{ SVM_EXIT_INVD,        "invd" }, \
+	{ SVM_EXIT_HLT,         "hlt" }, \
+	{ SVM_EXIT_INVLPG,      "invlpg" }, \
+	{ SVM_EXIT_INVLPGA,     "invlpga" }, \
+	{ SVM_EXIT_IOIO,        "io" }, \
+	{ SVM_EXIT_MSR,         "msr" }, \
+	{ SVM_EXIT_TASK_SWITCH, "task_switch" }, \
+	{ SVM_EXIT_SHUTDOWN,    "shutdown" }, \
+	{ SVM_EXIT_VMRUN,       "vmrun" }, \
+	{ SVM_EXIT_VMMCALL,     "hypercall" }, \
+	{ SVM_EXIT_VMLOAD,      "vmload" }, \
+	{ SVM_EXIT_VMSAVE,      "vmsave" }, \
+	{ SVM_EXIT_STGI,        "stgi" }, \
+	{ SVM_EXIT_CLGI,        "clgi" }, \
+	{ SVM_EXIT_SKINIT,      "skinit" }, \
+	{ SVM_EXIT_WBINVD,      "wbinvd" }, \
+	{ SVM_EXIT_MONITOR,     "monitor" }, \
+	{ SVM_EXIT_MWAIT,       "mwait" }, \
+	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
+	{ SVM_EXIT_NPF,         "npf" }
+
+#endif /* _UAPI_ASM_SVM_H */
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
new file mode 100644
index 0000000..501097a
--- /dev/null
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -0,0 +1,108 @@
+/*
+ * vmx.h: VMX Architecture related definitions
+ * Copyright (c) 2004, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * A few random additions are:
+ * Copyright (C) 2006 Qumranet
+ *    Avi Kivity <avi@qumranet.com>
+ *    Yaniv Kamay <yaniv@qumranet.com>
+ *
+ */
+
+#ifndef _UAPI_ASM_VMX_H
+#define _UAPI_ASM_VMX_H
+
+#define VMX_EXIT_REASONS_FAILED_VMENTRY         0x80000000
+
+#define EXIT_REASON_EXCEPTION_NMI       0
+#define EXIT_REASON_EXTERNAL_INTERRUPT  1
+#define EXIT_REASON_TRIPLE_FAULT        2
+
+#define EXIT_REASON_PENDING_INTERRUPT   7
+#define EXIT_REASON_NMI_WINDOW          8
+#define EXIT_REASON_TASK_SWITCH         9
+#define EXIT_REASON_CPUID               10
+#define EXIT_REASON_HLT                 12
+#define EXIT_REASON_INVD                13
+#define EXIT_REASON_INVLPG              14
+#define EXIT_REASON_RDPMC               15
+#define EXIT_REASON_RDTSC               16
+#define EXIT_REASON_VMCALL              18
+#define EXIT_REASON_VMCLEAR             19
+#define EXIT_REASON_VMLAUNCH            20
+#define EXIT_REASON_VMPTRLD             21
+#define EXIT_REASON_VMPTRST             22
+#define EXIT_REASON_VMREAD              23
+#define EXIT_REASON_VMRESUME            24
+#define EXIT_REASON_VMWRITE             25
+#define EXIT_REASON_VMOFF               26
+#define EXIT_REASON_VMON                27
+#define EXIT_REASON_CR_ACCESS           28
+#define EXIT_REASON_DR_ACCESS           29
+#define EXIT_REASON_IO_INSTRUCTION      30
+#define EXIT_REASON_MSR_READ            31
+#define EXIT_REASON_MSR_WRITE           32
+#define EXIT_REASON_INVALID_STATE       33
+#define EXIT_REASON_MWAIT_INSTRUCTION   36
+#define EXIT_REASON_MONITOR_INSTRUCTION 39
+#define EXIT_REASON_PAUSE_INSTRUCTION   40
+#define EXIT_REASON_MCE_DURING_VMENTRY  41
+#define EXIT_REASON_TPR_BELOW_THRESHOLD 43
+#define EXIT_REASON_APIC_ACCESS         44
+#define EXIT_REASON_EPT_VIOLATION       48
+#define EXIT_REASON_EPT_MISCONFIG       49
+#define EXIT_REASON_WBINVD              54
+#define EXIT_REASON_XSETBV              55
+#define EXIT_REASON_INVPCID             58
+
+#define VMX_EXIT_REASONS \
+	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
+	{ EXIT_REASON_EXTERNAL_INTERRUPT,    "EXTERNAL_INTERRUPT" }, \
+	{ EXIT_REASON_TRIPLE_FAULT,          "TRIPLE_FAULT" }, \
+	{ EXIT_REASON_PENDING_INTERRUPT,     "PENDING_INTERRUPT" }, \
+	{ EXIT_REASON_NMI_WINDOW,            "NMI_WINDOW" }, \
+	{ EXIT_REASON_TASK_SWITCH,           "TASK_SWITCH" }, \
+	{ EXIT_REASON_CPUID,                 "CPUID" }, \
+	{ EXIT_REASON_HLT,                   "HLT" }, \
+	{ EXIT_REASON_INVLPG,                "INVLPG" }, \
+	{ EXIT_REASON_RDPMC,                 "RDPMC" }, \
+	{ EXIT_REASON_RDTSC,                 "RDTSC" }, \
+	{ EXIT_REASON_VMCALL,                "VMCALL" }, \
+	{ EXIT_REASON_VMCLEAR,               "VMCLEAR" }, \
+	{ EXIT_REASON_VMLAUNCH,              "VMLAUNCH" }, \
+	{ EXIT_REASON_VMPTRLD,               "VMPTRLD" }, \
+	{ EXIT_REASON_VMPTRST,               "VMPTRST" }, \
+	{ EXIT_REASON_VMREAD,                "VMREAD" }, \
+	{ EXIT_REASON_VMRESUME,              "VMRESUME" }, \
+	{ EXIT_REASON_VMWRITE,               "VMWRITE" }, \
+	{ EXIT_REASON_VMOFF,                 "VMOFF" }, \
+	{ EXIT_REASON_VMON,                  "VMON" }, \
+	{ EXIT_REASON_CR_ACCESS,             "CR_ACCESS" }, \
+	{ EXIT_REASON_DR_ACCESS,             "DR_ACCESS" }, \
+	{ EXIT_REASON_IO_INSTRUCTION,        "IO_INSTRUCTION" }, \
+	{ EXIT_REASON_MSR_READ,              "MSR_READ" }, \
+	{ EXIT_REASON_MSR_WRITE,             "MSR_WRITE" }, \
+	{ EXIT_REASON_MWAIT_INSTRUCTION,     "MWAIT_INSTRUCTION" }, \
+	{ EXIT_REASON_MONITOR_INSTRUCTION,   "MONITOR_INSTRUCTION" }, \
+	{ EXIT_REASON_PAUSE_INSTRUCTION,     "PAUSE_INSTRUCTION" }, \
+	{ EXIT_REASON_MCE_DURING_VMENTRY,    "MCE_DURING_VMENTRY" }, \
+	{ EXIT_REASON_TPR_BELOW_THRESHOLD,   "TPR_BELOW_THRESHOLD" }, \
+	{ EXIT_REASON_APIC_ACCESS,           "APIC_ACCESS" }, \
+	{ EXIT_REASON_EPT_VIOLATION,         "EPT_VIOLATION" }, \
+	{ EXIT_REASON_EPT_MISCONFIG,         "EPT_MISCONFIG" }, \
+	{ EXIT_REASON_WBINVD,                "WBINVD" }
+
+#endif /* _UAPI_ASM_VMX_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9024a42..d998628 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -178,7 +178,6 @@ BASIC_CFLAGS = \
 	-Iarch/$(ARCH)/include \
 	-I$(objtree)/arch/$(ARCH)/include/generated/uapi \
 	-I$(srctree)/arch/$(ARCH)/include/uapi \
-	-I$(srctree)/arch/$(ARCH)/include \
 	-I$(objtree)/include/generated/uapi \
 	-I$(srctree)/include/uapi \
 	-I$(OUTPUT)util \

