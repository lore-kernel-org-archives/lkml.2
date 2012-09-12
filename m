Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab2IMA1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:27:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2ILXeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:34:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 081/108] powerpc: Restore correct DSCR in context switch
Date: Wed, 12 Sep 2012 16:29:19 -0700
Message-Id: <20120912232458.990407866@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 714332858bfd40dcf8f741498336d93875c23aa7 upstream.

During a context switch we always restore the per thread DSCR value.
If we aren't doing explicit DSCR management
(ie thread.dscr_inherit == 0) and the default DSCR changed while
the process has been sleeping we end up with the wrong value.

Check thread.dscr_inherit and select the default DSCR or per thread
DSCR as required.

This was found with the following test case, when running with
more threads than CPUs (ie forcing context switching):

http://ozlabs.org/~anton/junkcode/dscr_default_test.c

With the four patches applied I can run a combination of all
test cases successfully at the same time:

http://ozlabs.org/~anton/junkcode/dscr_default_test.c
http://ozlabs.org/~anton/junkcode/dscr_explicit_test.c
http://ozlabs.org/~anton/junkcode/dscr_inherit_test.c

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/asm-offsets.c |    1 +
 arch/powerpc/kernel/entry_64.S    |   23 +++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -76,6 +76,7 @@ int main(void)
 	DEFINE(SIGSEGV, SIGSEGV);
 	DEFINE(NMI_MASK, NMI_MASK);
 	DEFINE(THREAD_DSCR, offsetof(struct thread_struct, dscr));
+	DEFINE(THREAD_DSCR_INHERIT, offsetof(struct thread_struct, dscr_inherit));
 #else
 	DEFINE(THREAD_INFO, offsetof(struct task_struct, stack));
 #endif /* CONFIG_PPC64 */
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -369,6 +369,12 @@ _GLOBAL(ret_from_fork)
 	li	r3,0
 	b	syscall_exit
 
+	.section	".toc","aw"
+DSCR_DEFAULT:
+	.tc dscr_default[TC],dscr_default
+
+	.section	".text"
+
 /*
  * This routine switches between two different tasks.  The process
  * state of one is saved on its kernel stack.  Then the state
@@ -508,9 +514,6 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_1T_SEG
 	mr	r1,r8		/* start using new stack pointer */
 	std	r7,PACAKSAVE(r13)
 
-	ld	r6,_CCR(r1)
-	mtcrf	0xFF,r6
-
 #ifdef CONFIG_ALTIVEC
 BEGIN_FTR_SECTION
 	ld	r0,THREAD_VRSAVE(r4)
@@ -519,14 +522,22 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 #endif /* CONFIG_ALTIVEC */
 #ifdef CONFIG_PPC64
 BEGIN_FTR_SECTION
+	lwz	r6,THREAD_DSCR_INHERIT(r4)
+	ld	r7,DSCR_DEFAULT@toc(2)
 	ld	r0,THREAD_DSCR(r4)
-	cmpd	r0,r25
-	beq	1f
+	cmpwi	r6,0
+	bne	1f
+	ld	r0,0(r7)
+1:	cmpd	r0,r25
+	beq	2f
 	mtspr	SPRN_DSCR,r0
-1:	
+2:
 END_FTR_SECTION_IFSET(CPU_FTR_DSCR)
 #endif
 
+	ld	r6,_CCR(r1)
+	mtcrf	0xFF,r6
+
 	/* r3-r13 are destroyed -- Cort */
 	REST_8GPRS(14, r1)
 	REST_10GPRS(22, r1)


