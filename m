Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab1KSAIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:08:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146Ab1KSAIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:08:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:06 2011
Message-Id: <20111119000006.140588439@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [24/26] powerpc: Copy down exception vectors after feature fixups
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit d715e433b7ad19c02fc4becf0d5e9a59f97925de upstream.

kdump fails because we try to execute an HV only instruction. Feature
fixups are being applied after we copy the exception vectors down to 0
so they miss out on any updates.

We have always had this issue but it only became critical in v3.0
when we added CFAR support (breaks POWER5) and v3.1 when we added
POWERNV (breaks everyone).

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/sections.h |    2 +-
 arch/powerpc/include/asm/synch.h    |    1 +
 arch/powerpc/kernel/kvm.c           |    1 -
 arch/powerpc/kernel/setup_32.c      |    2 ++
 arch/powerpc/kernel/setup_64.c      |    1 +
 arch/powerpc/lib/feature-fixups.c   |   23 +++++++++++++++++++++++
 6 files changed, 28 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/sections.h
+++ b/arch/powerpc/include/asm/sections.h
@@ -8,7 +8,7 @@
 
 #ifdef __powerpc64__
 
-extern char _end[];
+extern char __end_interrupts[];
 
 static inline int in_kernel_text(unsigned long addr)
 {
--- a/arch/powerpc/include/asm/synch.h
+++ b/arch/powerpc/include/asm/synch.h
@@ -13,6 +13,7 @@
 extern unsigned int __start___lwsync_fixup, __stop___lwsync_fixup;
 extern void do_lwsync_fixups(unsigned long value, void *fixup_start,
 			     void *fixup_end);
+extern void do_final_fixups(void);
 
 static inline void eieio(void)
 {
--- a/arch/powerpc/kernel/kvm.c
+++ b/arch/powerpc/kernel/kvm.c
@@ -131,7 +131,6 @@ static void kvm_patch_ins_b(u32 *inst, i
 	/* On relocatable kernels interrupts handlers and our code
 	   can be in different regions, so we don't patch them */
 
-	extern u32 __end_interrupts;
 	if ((ulong)inst < (ulong)&__end_interrupts)
 		return;
 #endif
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -107,6 +107,8 @@ notrace unsigned long __init early_init(
 			 PTRRELOC(&__start___lwsync_fixup),
 			 PTRRELOC(&__stop___lwsync_fixup));
 
+	do_final_fixups();
+
 	return KERNELBASE + offset;
 }
 
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -352,6 +352,7 @@ void __init setup_system(void)
 			  &__start___fw_ftr_fixup, &__stop___fw_ftr_fixup);
 	do_lwsync_fixups(cur_cpu_spec->cpu_features,
 			 &__start___lwsync_fixup, &__stop___lwsync_fixup);
+	do_final_fixups();
 
 	/*
 	 * Unflatten the device-tree passed by prom_init or kexec
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -18,6 +18,8 @@
 #include <linux/init.h>
 #include <asm/cputable.h>
 #include <asm/code-patching.h>
+#include <asm/page.h>
+#include <asm/sections.h>
 
 
 struct fixup_entry {
@@ -128,6 +130,27 @@ void do_lwsync_fixups(unsigned long valu
 	}
 }
 
+void do_final_fixups(void)
+{
+#if defined(CONFIG_PPC64) && defined(CONFIG_RELOCATABLE)
+	int *src, *dest;
+	unsigned long length;
+
+	if (PHYSICAL_START == 0)
+		return;
+
+	src = (int *)(KERNELBASE + PHYSICAL_START);
+	dest = (int *)KERNELBASE;
+	length = (__end_interrupts - _stext) / sizeof(int);
+
+	while (length--) {
+		patch_instruction(dest, *src);
+		src++;
+		dest++;
+	}
+#endif
+}
+
 #ifdef CONFIG_FTR_FIXUP_SELFTEST
 
 #define check(x)	\


