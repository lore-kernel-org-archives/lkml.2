Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab1EQWnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:43:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:7744 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab1EQWmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:42:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,227,1304319600"; 
   d="scan'208";a="3050269"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Avi Kivity" <avi@redhat.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 5/9] x86/lib/clear_page_64.S: Support clear_page() with enhanced REP MOVSB/STOSB
Date: Tue, 17 May 2011 15:29:14 -0700
Message-Id: <1305671358-14478-6-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Intel processors are adding enhancements to REP MOVSB/STOSB and the use of
REP MOVSB/STOSB for optimal memcpy/memset or similar functions is recommended.
Enhancement availability is indicated by CPUID.7.0.EBX[9] (Enhanced REP MOVSB/
STOSB).

Support clear_page() with rep stosb for processor supporting enhanced REP MOVSB
/STOSB. On processors supporting enhanced REP MOVSB/STOSB, the alternative
clear_page_c_e function using enhanced REP STOSB overrides the original function
and the fast string function.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/lib/clear_page_64.S |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index aa4326b..0e109d3 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -1,5 +1,6 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/alternative-asm.h>
 
 /*
  * Zero a page. 	
@@ -14,6 +15,15 @@ ENTRY(clear_page_c)
 	CFI_ENDPROC
 ENDPROC(clear_page_c)
 
+ENTRY(clear_page_c_e)
+	CFI_STARTPROC
+	movl $4096,%ecx
+	xorl %eax,%eax
+	rep stosb
+	ret
+	CFI_ENDPROC
+ENDPROC(clear_page_c_e)
+
 ENTRY(clear_page)
 	CFI_STARTPROC
 	xorl   %eax,%eax
@@ -38,21 +48,26 @@ ENTRY(clear_page)
 .Lclear_page_end:
 ENDPROC(clear_page)
 
-	/* Some CPUs run faster using the string instructions.
-	   It is also a lot simpler. Use this when possible */
+	/*
+	 * Some CPUs support enhanced REP MOVSB/STOSB instructions.
+	 * It is recommended to use this when possible.
+	 * If enhanced REP MOVSB/STOSB is not available, try to use fast string.
+	 * Otherwise, use original function.
+	 *
+	 */
 
 #include <asm/cpufeature.h>
 
 	.section .altinstr_replacement,"ax"
 1:	.byte 0xeb					/* jmp <disp8> */
 	.byte (clear_page_c - clear_page) - (2f - 1b)	/* offset */
-2:
+2: 	.byte 0xeb					/* jmp <disp8> */
+	.byte (clear_page_c_e - clear_page) - (3f - 2b)	/* offset */
+3:
 	.previous
 	.section .altinstructions,"a"
-	.align 8
-	.quad clear_page
-	.quad 1b
-	.word X86_FEATURE_REP_GOOD
-	.byte .Lclear_page_end - clear_page
-	.byte 2b - 1b
+	altinstruction_entry clear_page,1b,X86_FEATURE_REP_GOOD,\
+			     .Lclear_page_end-clear_page, 2b-1b
+	altinstruction_entry clear_page,2b,X86_FEATURE_ERMS,   \
+			     .Lclear_page_end-clear_page,3b-2b
 	.previous
-- 
1.7.2

