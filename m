Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1FCX3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:29:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:50741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab1FCX3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:29:43 -0400
Date: Fri, 3 Jun 2011 23:29:35 GMT
From: tip-bot for Borislav Petkov <bp@alien8.de>
Message-ID: <tip-38e6b75d3b6f4b9445eb6486e28fc716acda44ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, bp@alien8.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, hpa@linux.intel.com
In-Reply-To: <1306873314-32523-5-git-send-email-bp@alien8.de>
References: <1306873314-32523-5-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, asm: Cleanup thunk_64.S
Git-Commit-ID: 38e6b75d3b6f4b9445eb6486e28fc716acda44ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 23:29:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38e6b75d3b6f4b9445eb6486e28fc716acda44ae
Gitweb:     http://git.kernel.org/tip/38e6b75d3b6f4b9445eb6486e28fc716acda44ae
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Tue, 31 May 2011 22:21:54 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 3 Jun 2011 14:38:55 -0700

x86, asm: Cleanup thunk_64.S

Drop thunk_ra macro in favor of an additional argument to the thunk
macro since their bodies are almost identical. Do a whitespace scrubbing
and use CFI-aware macros for full annotation.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1306873314-32523-5-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/lib/thunk_64.S |   46 +++++++++++++++++++---------------------------
 1 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index 782b082..d5b088b 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -5,50 +5,42 @@
  * Added trace_hardirqs callers - Copyright 2007 Steven Rostedt, Red Hat, Inc.
  * Subject to the GNU public license, v.2. No warranty of any kind.
  */
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+#include <asm/calling.h>
+#include <asm/rwlock.h>
 
-	#include <linux/linkage.h>
-	#include <asm/dwarf2.h>
-	#include <asm/calling.h>			
-	#include <asm/rwlock.h>
-		
-	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */ 	
-	.macro thunk name,func
-	.globl \name
-\name:	
-	CFI_STARTPROC
-	SAVE_ARGS
-	call \func
-	jmp  restore
-	CFI_ENDPROC
-	.endm
-
-#ifdef CONFIG_TRACE_IRQFLAGS
-	/* put return address in rdi (arg1) */
-	.macro thunk_ra name,func
+	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */
+	.macro THUNK name, func, put_ret_addr_in_rdi=0
 	.globl \name
 \name:
 	CFI_STARTPROC
+
+	/* this one pushes 9 elems, the next one would be %rIP */
 	SAVE_ARGS
-	/* SAVE_ARGS pushs 9 elements */
-	/* the next element would be the rip */
-	movq 9*8(%rsp), %rdi
+
+	.if \put_ret_addr_in_rdi
+	movq_cfi_restore 9*8, rdi
+	.endif
+
 	call \func
 	jmp  restore
 	CFI_ENDPROC
 	.endm
 
-	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
-	thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller
+#ifdef CONFIG_TRACE_IRQFLAGS
+	THUNK trace_hardirqs_on_thunk,trace_hardirqs_on_caller,1
+	THUNK trace_hardirqs_off_thunk,trace_hardirqs_off_caller,1
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-	thunk lockdep_sys_exit_thunk,lockdep_sys_exit
+	THUNK lockdep_sys_exit_thunk,lockdep_sys_exit
 #endif
-	
+
 	/* SAVE_ARGS below is used only for the .cfi directives it contains. */
 	CFI_STARTPROC
 	SAVE_ARGS
 restore:
 	RESTORE_ARGS
-	ret	
+	ret
 	CFI_ENDPROC
