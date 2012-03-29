Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936698Ab2C3W7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:59:06 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934801Ab2C3VFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:33 -0400
Message-Id: <201203302105.q2UL54vY006284@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 14:52:00 -0400
Subject: [PATCH] arch/tile: work around a hardware issue with the return-address stack
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:04.0225 (UTC) FILETIME=[C730D510:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In certain circumstances we need to do a bunch of jump-and-link
instructions to fill the hardware return-address stack with nonzero values.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/traps.h |    6 +++++-
 arch/tile/kernel/intvec_64.S  |   12 ++++++++++++
 arch/tile/kernel/traps.c      |    6 +++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/tile/include/asm/traps.h b/arch/tile/include/asm/traps.h
index 5f20f92..e28c3df 100644
--- a/arch/tile/include/asm/traps.h
+++ b/arch/tile/include/asm/traps.h
@@ -64,7 +64,11 @@ void do_breakpoint(struct pt_regs *, int fault_num);
 
 
 #ifdef __tilegx__
+/* kernel/single_step.c */
 void gx_singlestep_handle(struct pt_regs *, int fault_num);
+
+/* kernel/intvec_64.S */
+void fill_ra_stack(void);
 #endif
 
-#endif /* _ASM_TILE_SYSCALLS_H */
+#endif /* _ASM_TILE_TRAPS_H */
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 3c1f626..709e224 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -1164,6 +1164,18 @@ int_unalign:
 	push_extra_callee_saves r0
 	j       do_trap
 
+/* Fill the return address stack with nonzero entries. */
+STD_ENTRY(fill_ra_stack)
+	{
+	 move	r0, lr
+	 jal	1f
+	}
+1:	jal	2f
+2:	jal	3f
+3:	jal	4f
+4:	jrp	r0
+	STD_ENDPROC(fill_ra_stack)
+
 /* Include .intrpt1 array of interrupt vectors */
 	.section ".intrpt1", "ax"
 
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 4f47b8a..1e91fda 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -288,7 +288,10 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 		address = regs->pc;
 		break;
 #ifdef __tilegx__
-	case INT_ILL_TRANS:
+	case INT_ILL_TRANS: {
+		/* Avoid a hardware erratum with the return address stack. */
+		fill_ra_stack();
+
 		signo = SIGSEGV;
 		code = SEGV_MAPERR;
 		if (reason & SPR_ILL_TRANS_REASON__I_STREAM_VA_RMASK)
@@ -296,6 +299,7 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 		else
 			address = 0;  /* FIXME: GX: single-step for address */
 		break;
+	}
 #endif
 	default:
 		panic("Unexpected do_trap interrupt number %d", fault_num);
-- 
1.6.5.2

