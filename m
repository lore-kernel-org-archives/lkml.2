Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab1ALSDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:03:13 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:41714 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1ALSDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:03:10 -0500
Subject: [PATCH v2] arm: Defer vetting of atags to setup.c
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@canonical.com>
Date: Wed, 12 Jan 2011 11:03:07 -0700
Message-ID: <20110112180257.6824.33147.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the debug macros no longer depend on atag data, the vetting can
be deferred to setup_arch() in setup.c which simplifies the code
somewhat.

This patch removes __vet_atags() from head.S and moves it setup_arch().
I've tried to preserve the existing behaviour in this patch so the
extra atags vetting is only using when CONFIG_MMU is selected.

v2: Move removal of __machine_type_lookup to a separate patch.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/kernel/head-common.S |   51 +++++++----------------------------------
 arch/arm/kernel/head.S        |    1 -
 arch/arm/kernel/setup.c       |   16 +++++++++++++
 3 files changed, 25 insertions(+), 43 deletions(-)

diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index c84b57d..8bb1829 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -11,50 +11,8 @@
  *
  */
 
-#define ATAG_CORE 0x54410001
-#define ATAG_CORE_SIZE ((2*4 + 3*4) >> 2)
-#define ATAG_CORE_SIZE_EMPTY ((2*4) >> 2)
-
-/*
- * Exception handling.  Something went wrong and we can't proceed.  We
- * ought to tell the user, but since we don't have any guarantee that
- * we're even running on the right architecture, we do virtually nothing.
- *
- * If CONFIG_DEBUG_LL is set we try to print out something about the error
- * and hope for the best (useful if bootloader fails to pass a proper
- * machine ID for example).
- */
 	__HEAD
 
-/* Determine validity of the r2 atags pointer.  The heuristic requires
- * that the pointer be aligned, in the first 16k of physical RAM and
- * that the ATAG_CORE marker is first and present.  Future revisions
- * of this function may be more lenient with the physical address and
- * may also be able to move the ATAGS block if necessary.
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
@@ -158,6 +116,15 @@ __lookup_processor_type_data:
 	.long	__proc_info_end
 	.size	__lookup_processor_type_data, . - __lookup_processor_type_data
 
+/*
+ * Exception handling.  Something went wrong and we can't proceed.  We
+ * ought to tell the user, but since we don't have any guarantee that
+ * we're even running on the right architecture, we do virtually nothing.
+ *
+ * If CONFIG_DEBUG_LL is set we try to print out something about the error
+ * and hope for the best (useful if bootloader fails to pass a proper
+ * machine ID for example).
+ */
 __error_p:
 #ifdef CONFIG_DEBUG_LL
 	adr	r0, str_p1
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 19f3909..4b0cf4a 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -92,7 +92,6 @@ ENTRY(stext)
 	 * r1 = machine no, r2 = atags,
 	 * r9 = cpuid, r10 = procinfo
 	 */
-	bl	__vet_atags
 #ifdef CONFIG_SMP_ON_UP
 	bl	__fixup_smp
 #endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 77266a8..47cf110 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -851,6 +851,22 @@ void __init setup_arch(char **cmdline_p)
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

