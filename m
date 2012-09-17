Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab2IQA6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:58:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33917 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754651Ab2IQAvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:25 -0400
Message-Id: <20120917003631.647906145@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 039/135] powerpc: Restore correct DSCR in context switch
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/asm-offsets.c |    1 +
 arch/powerpc/kernel/entry_64.S    |   23 +++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 85b05c4..e899572 100644
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
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 4b01a25..b40e0b4 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -370,6 +370,12 @@ _GLOBAL(ret_from_fork)
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
@@ -509,9 +515,6 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_1T_SEGMENT)
 	mr	r1,r8		/* start using new stack pointer */
 	std	r7,PACAKSAVE(r13)
 
-	ld	r6,_CCR(r1)
-	mtcrf	0xFF,r6
-
 #ifdef CONFIG_ALTIVEC
 BEGIN_FTR_SECTION
 	ld	r0,THREAD_VRSAVE(r4)
@@ -520,14 +523,22 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
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


