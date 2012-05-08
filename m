Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2EHSX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:23:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:11241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab2EHSXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:23:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150637105"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com
Subject: [PATCH 14/23] x86, realmode: Replace open-coded ljmpw with a macro
Date: Tue,  8 May 2012 21:22:37 +0300
Message-Id: <1336501366-28617-15-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

We cannot code an ljmpw to the real-mode segment directly, because gas
refuses to assemble an ljmp with a symbolic segment.  Instead of
open-coding it everywhere, define a macro and use it for this case.

This is specifically an ljmpw from a 16-bit segment.  This is okay, as
one should never enter real mode from a 32-bit segment: if one do, the
CPU ends up in a bizarre (and useless) mode sometimes called "unreal
mode" where segments behave like real mode but the default address and
operand sizes is 32 bits.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/realmode/rm/realmode.h          |   16 ++++++++++++++++
 arch/x86/realmode/rm/reboot_32.S         |    6 ++----
 arch/x86/realmode/rm/trampoline_32.S     |    5 ++---
 arch/x86/realmode/rm/trampoline_64.S     |    5 ++---
 arch/x86/realmode/rm/wakeup/wakeup_asm.S |    9 +++------
 5 files changed, 25 insertions(+), 16 deletions(-)
 create mode 100644 arch/x86/realmode/rm/realmode.h

diff --git a/arch/x86/realmode/rm/realmode.h b/arch/x86/realmode/rm/realmode.h
new file mode 100644
index 0000000..15ab633
--- /dev/null
+++ b/arch/x86/realmode/rm/realmode.h
@@ -0,0 +1,16 @@
+#ifndef ARCH_X86_REALMODE_RM_REALMODE_H
+#define ARCH_X86_REALMODE_RM_REALMODE_H
+
+#ifdef __ASSEMBLY__
+
+/*
+ * 16-bit ljmpw to the real_mode_seg
+ *
+ * This must be open-coded since gas will choke on using a
+ * relocatable symbol for the segment portion.
+ */
+#define LJMPW_RM(to)	.byte 0xea ; .word (to), real_mode_seg
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* ARCH_X86_REALMODE_RM_REALMODE_H */
diff --git a/arch/x86/realmode/rm/reboot_32.S b/arch/x86/realmode/rm/reboot_32.S
index 83803c2..e90f8c4 100644
--- a/arch/x86/realmode/rm/reboot_32.S
+++ b/arch/x86/realmode/rm/reboot_32.S
@@ -2,6 +2,7 @@
 #include <linux/init.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
+#include "realmode.h"
 
 /*
  * The following code and data reboots the machine by switching to real
@@ -82,10 +83,7 @@ machine_real_restart_asm16:
 2:
 	andb	$0x10, %dl
 	movl	%edx, %cr0
-	.byte	0xea			/* ljmpw */
-	.word	3f			/* Offset */
-	.word	real_mode_seg		/* Segment */
-
+	LJMPW_RM(3f)
 3:
 	testb	$0, %al
 	jz	bios
diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index 1315ef4..279f82e 100644
--- a/arch/x86/realmode/rm/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
+#include "realmode.h"
 
 	.text
 	.code16
@@ -38,9 +39,7 @@
 trampoline_data:
 	wbinvd			# Needed for NUMA-Q should be harmless for others
 
-	.byte	0xea		# ljmpw
-	.word	1f		# Offset
-	.word	real_mode_seg	# Segment
+	LJMPW_RM(1f)
 1:
 	mov	%cs, %ax	# Code and data in the same place
 	mov	%ax, %ds
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index 77b72b4..7459c52 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -31,6 +31,7 @@
 #include <asm/msr.h>
 #include <asm/segment.h>
 #include <asm/processor-flags.h>
+#include "realmode.h"
 
 	.text
 	.balign PAGE_SIZE
@@ -40,9 +41,7 @@ ENTRY(trampoline_data)
 	cli			# We should be safe anyway
 	wbinvd
 
-	.byte	0xea		# ljmpw
-	.word	1f		# Offset
-	.word	real_mode_seg	# Segment
+	LJMPW_RM(1f)
 1:
 	mov	%cs, %ax	# Code and data in the same place
 	mov	%ax, %ds
diff --git a/arch/x86/realmode/rm/wakeup/wakeup_asm.S b/arch/x86/realmode/rm/wakeup/wakeup_asm.S
index 4c5c5f2..8064e1c 100644
--- a/arch/x86/realmode/rm/wakeup/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup/wakeup_asm.S
@@ -6,6 +6,7 @@
 #include <asm/page_types.h>
 #include <asm/pgtable_types.h>
 #include <asm/processor-flags.h>
+#include "../realmode.h"
 #include "wakeup.h"
 
 		.code16
@@ -36,9 +37,7 @@ wakeup_start:
 	cli
 	cld
 
-	.byte	0xea		/* ljmpw */
-	.word	3f
-	.word	real_mode_seg
+	LJMPW_RM(3f)
 3:
 	/* Apparently some dimwit BIOS programmers don't know how to
 	   program a PM to RM transition, and we might end up here with
@@ -59,9 +58,7 @@ wakeup_start:
 
 	andb	$~X86_CR0_PE, %al
 	movl	%eax, %cr0
-	.byte	0xea		/* ljmpw */
-	.word	3f
-	.word	real_mode_seg
+	LJMPW_RM(3f)
 3:
 	/* Set up segments */
 	movw	%cs, %ax
-- 
1.7.9.5

