Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab1AKCQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 21:16:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36658 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1AKCP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 21:15:56 -0500
Subject: [RFC] arm: Defer lookup of machine_type and vet of atags to setup.c
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@canonical.com>
Date: Mon, 10 Jan 2011 19:15:53 -0700
Message-ID: <20110111015409.18291.87166.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the debug macros no longer depend on the machine type
information, both the machine type lookup and the atags vetting can be
deferred to setup_arch() in setup.c which simplifies the code
somewhat.

This patch removes both __machine_type_lookup and __vet_atags() from
head.S.  The atags vetting is moved to setup_arch().  machine_type
lookup is already called from setup_machine() in addition to where it
was called from head.S.

I've tried to preserve the existing behaviour in this patch so the
extra atags vetting is only using when CONFIG_MMU is selected.  I may
be being overly cautious, and if so then it is probably possible to
simplify the code further.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Hi Russell,

I'm not sure if this is a valid change or not, but from what I can
tell it looks like machine and atag processing no longer needs
to be handled as early as head.S.  Please take a look and let me know
what you think.

I've boot tested this on Tegra and versatile qemu, but that's about
it.

Thanks,
g.

 arch/arm/kernel/head-common.S |   35 -----------------------------------
 arch/arm/kernel/head.S        |    5 -----
 arch/arm/kernel/setup.c       |   16 ++++++++++++++++
 3 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index bbecaac..7956a48 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -11,10 +11,6 @@
  *
  */
 
-#define ATAG_CORE 0x54410001
-#define ATAG_CORE_SIZE ((2*4 + 3*4) >> 2)
-#define ATAG_CORE_SIZE_EMPTY ((2*4) >> 2)
-
 /*
  * Exception handling.  Something went wrong and we can't proceed.  We
  * ought to tell the user, but since we don't have any guarantee that
@@ -101,37 +97,6 @@ __lookup_machine_type_data:
 	.long	__arch_info_end
 	.size	__lookup_machine_type_data, . - __lookup_machine_type_data
 
-/* Determine validity of the r2 atags pointer.  The heuristic requires
- * that the pointer be aligned, in the first 16k of physical RAM and
- * that the ATAG_CORE marker is first and present.  Future revisions
- * of this function may be more lenient with the physical address and
- * may also be able to move the ATAGS block if necessary.
- *
- * r8  = machinfo
- *
- * Returns:
- *  r2 either valid atags pointer, or zero
- *  r5, r6 corrupted
- */
-__vet_atags:
-	tst	r2, #0x3			@ aligned?
-	bne	1f
-
-	ldr	r5, [r2, #0]			@ is first tag ATAG_CORE?
-	cmp	r5, #ATAG_CORE_SIZE
-	cmpne	r5, #ATAG_CORE_SIZE_EMPTY
-	bne	1f
-	ldr	r5, [r2, #4]
-	ldr	r6, =ATAG_CORE
-	cmp	r5, r6
-	bne	1f
-
-	mov	pc, lr				@ atag pointer is ok
-
-1:	mov	r2, #0
-	mov	pc, lr
-ENDPROC(__vet_atags)
-
 /*
  * The following fragment of code is executed with the MMU on in MMU mode,
  * and uses absolute addresses; this is not position independent.
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 6bd82d2..9c0e938 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -87,11 +87,6 @@ ENTRY(stext)
 	movs	r10, r5				@ invalid processor (r5=0)?
  THUMB( it	eq )		@ force fixup-able long branch encoding
 	beq	__error_p			@ yes, error 'p'
-	bl	__lookup_machine_type		@ r5=machinfo
-	movs	r8, r5				@ invalid machine (r5=0)?
- THUMB( it	eq )		@ force fixup-able long branch encoding
-	beq	__error_a			@ yes, error 'a'
-	bl	__vet_atags
 #ifdef CONFIG_SMP_ON_UP
 	bl	__fixup_smp
 #endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 336f14e..cd28089 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -814,6 +814,22 @@ void __init setup_arch(char **cmdline_p)
 	if (mdesc->soft_reboot)
 		reboot_setup("s");
 
+#if defined(CONFIG_MMU)
+	/*
+	 * Determine validity of the atags pointer.  The heuristic requires
+	 * that the pointer be aligned, and that the ATAG_CORE marker is
+	 * first and present.
+	 */
+	if (__atags_pointer & 0x3)
+		__atags_pointer = 0;
+	if (__atags_pointer) {
+		struct tag *t = phys_to_virt(__atags_pointer);
+		if ((t->hdr.size != tag_size(tag_core)) &&
+		    (t->hdr.size != sizeof(struct tag_header)) &&
+		    (t->hdr.tag != ATAG_CORE))
+			__atags_pointer = 0;
+	}
+#endif
 	if (__atags_pointer)
 		tags = phys_to_virt(__atags_pointer);
 	else if (mdesc->boot_params)

