Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1ERUmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:42:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:56231 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab1ERUl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:41:59 -0400
Date: Wed, 18 May 2011 20:41:52 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-e365c9df2f2f001450decf9512412d2d5bd1cdef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1305671358-14478-6-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-6-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, mem: clear_page_64.S: Support clear_page() with enhanced REP MOVSB/STOSB
Git-Commit-ID: e365c9df2f2f001450decf9512412d2d5bd1cdef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 20:41:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e365c9df2f2f001450decf9512412d2d5bd1cdef
Gitweb:     http://git.kernel.org/tip/e365c9df2f2f001450decf9512412d2d5bd1cdef
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 17 May 2011 15:29:14 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 17 May 2011 15:40:27 -0700

x86, mem: clear_page_64.S: Support clear_page() with enhanced REP MOVSB/STOSB

Intel processors are adding enhancements to REP MOVSB/STOSB and the use of
REP MOVSB/STOSB for optimal memcpy/memset or similar functions is recommended.
Enhancement availability is indicated by CPUID.7.0.EBX[9] (Enhanced REP MOVSB/
STOSB).

Support clear_page() with rep stosb for processor supporting enhanced REP MOVSB
/STOSB. On processors supporting enhanced REP MOVSB/STOSB, the alternative
clear_page_c_e function using enhanced REP STOSB overrides the original function
and the fast string function.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1305671358-14478-6-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/lib/clear_page_64.S |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index aa4326b..f2145cf 100644
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
+2:	.byte 0xeb					/* jmp <disp8> */
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
