Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab1EaUbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:31:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54652 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758434Ab1EaUbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:31:31 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 4/4] x86, asm: Cleanup thunk_64.S
Date: Tue, 31 May 2011 22:21:54 +0200
Message-Id: <1306873314-32523-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.5.3.401.gfb674
In-Reply-To: <1306873314-32523-1-git-send-email-bp@alien8.de>
References: <1306873314-32523-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop thunk_ra macro in favor of an additional argument to the thunk
macro since their bodies are almost identical. Do a whitespace scrubbing
and use CFI-aware macros for full annotation.

Signed-off-by: Borislav Petkov <bp@alien8.de>
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
-- 
1.7.5.3.401.gfb674

