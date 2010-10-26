Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab0JZCya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402Ab0JZCy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 14/43] MN10300: Remove monitor/JTAG functions
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:54:16 +0100
Message-ID: <20101026025416.23512.94406.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Remove the monitor trap function and the set_jtag_stub function as they're not
really necessary.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/exceptions.h |    5 ++---
 arch/mn10300/kernel/entry.S           |   25 -------------------------
 arch/mn10300/kernel/traps.c           |   22 ----------------------
 arch/mn10300/mm/fault.c               |    5 -----
 4 files changed, 2 insertions(+), 55 deletions(-)


diff --git a/arch/mn10300/include/asm/exceptions.h b/arch/mn10300/include/asm/exceptions.h
index fa16466..3f3826a 100644
--- a/arch/mn10300/include/asm/exceptions.h
+++ b/arch/mn10300/include/asm/exceptions.h
@@ -15,8 +15,8 @@
 
 /*
  * define the breakpoint instruction opcode to use
- * - note that the JTAG unit steals 0xFF, so we want to avoid that if we can
- *   (can use 0xF7)
+ * - note that the JTAG unit steals 0xFF, so you can't use JTAG and GDBSTUB at
+ *   the same time.
  */
 #define GDBSTUB_BKPT		0xFF
 
@@ -90,7 +90,6 @@ enum exception_code {
 
 extern void __set_intr_stub(enum exception_code code, void *handler);
 extern void set_intr_stub(enum exception_code code, void *handler);
-extern void set_jtag_stub(enum exception_code code, void *handler);
 
 struct pt_regs;
 
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index 3d394b4..b82ce7b 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -216,31 +216,6 @@ ENTRY(irq_handler)
 
 ###############################################################################
 #
-# Monitor Signal handler entry point
-#
-###############################################################################
-ENTRY(monitor_signal)
-	movbu	(0xae000001),d1
-	cmp	1,d1
-	beq	monsignal
-	ret	[],0
-
-monsignal:
-	or	EPSW_NMID,epsw
-	mov	d0,a0
-	mov	a0,sp
-	mov	(REG_EPSW,fp),d1
-	and	~EPSW_nSL,d1
-	mov	d1,(REG_EPSW,fp)
-	movm	(sp),[d2,d3,a2,a3,exreg0,exreg1,exother]
-	mov	(sp),a1
-	mov	a1,usp
-	movm	(sp),[other]
-	add	4,sp
-here:	jmp	0x8e000008-here+0x8e000008
-
-###############################################################################
-#
 # Double Fault handler entry point
 # - note that there will not be a stack, D0/A0 will hold EPSW/PC as were
 #
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index 91365ad..a64604b 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -538,28 +538,6 @@ void __init set_intr_stub(enum exception_code code, void *handler)
 }
 
 /*
- * set an interrupt stub to invoke the JTAG unit and then jump to a handler
- */
-void __init set_jtag_stub(enum exception_code code, void *handler)
-{
-	unsigned long addr;
-	u8 *vector = (u8 *)(CONFIG_INTERRUPT_VECTOR_BASE + code);
-
-	addr = (unsigned long) handler - ((unsigned long) vector + 1);
-	vector[0] = 0xff;		/* PI to jump into JTAG debugger */
-	vector[1] = 0xdc;		/* jmp handler */
-	vector[2] = addr;
-	vector[3] = addr >> 8;
-	vector[4] = addr >> 16;
-	vector[5] = addr >> 24;
-	vector[6] = 0xcb;
-	vector[7] = 0xcb;
-
-	mn10300_dcache_flush_inv();
-	flush_icache_range((unsigned long) vector, (unsigned long) vector + 8);
-}
-
-/*
  * initialise the exception table
  */
 void __init trap_init(void)
diff --git a/arch/mn10300/mm/fault.c b/arch/mn10300/mm/fault.c
index 81f153f..906e4c8 100644
--- a/arch/mn10300/mm/fault.c
+++ b/arch/mn10300/mm/fault.c
@@ -100,8 +100,6 @@ static void print_pagetable_entries(pgd_t *pgdir, unsigned long address)
 }
 #endif
 
-asmlinkage void monitor_signal(struct pt_regs *);
-
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
@@ -279,7 +277,6 @@ good_area:
  */
 bad_area:
 	up_read(&mm->mmap_sem);
-	monitor_signal(regs);
 
 	/* User mode accesses just cause a SIGSEGV */
 	if ((fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_USR) {
@@ -292,7 +289,6 @@ bad_area:
 	}
 
 no_context:
-	monitor_signal(regs);
 	/* Are we prepared to handle this kernel fault?  */
 	if (fixup_exception(regs))
 		return;
@@ -345,7 +341,6 @@ out_of_memory:
 
 do_sigbus:
 	up_read(&mm->mmap_sem);
-	monitor_signal(regs);
 
 	/*
 	 * Send a sigbus, regardless of whether we were in kernel

