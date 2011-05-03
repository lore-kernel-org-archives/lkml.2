Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1ECLpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 07:45:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1ECLpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 07:45:03 -0400
Date: Tue, 3 May 2011 13:44:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110503114450.GA21675@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Boris Ostrovsky (1):
      x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors

H. Peter Anvin (1):
      x86, reboot: Fix relocations in reboot_32.S

Yinghai Lu (1):
      x86, NUMA: Fix empty memblk detection in numa_cleanup_meminfo()


 arch/x86/kernel/cpu/amd.c   |    2 +-
 arch/x86/kernel/reboot_32.S |   12 ++++++------
 arch/x86/mm/numa_64.c       |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3532d3b..bb9eb29 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -698,7 +698,7 @@ cpu_dev_register(amd_cpu_dev);
  */
 
 const int amd_erratum_400[] =
-	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0x0f, 0x4, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
 EXPORT_SYMBOL_GPL(amd_erratum_400);
 
diff --git a/arch/x86/kernel/reboot_32.S b/arch/x86/kernel/reboot_32.S
index 29092b3..1d5c46d 100644
--- a/arch/x86/kernel/reboot_32.S
+++ b/arch/x86/kernel/reboot_32.S
@@ -21,26 +21,26 @@ r_base = .
 	/* Get our own relocated address */
 	call	1f
 1:	popl	%ebx
-	subl	$1b, %ebx
+	subl	$(1b - r_base), %ebx
 
 	/* Compute the equivalent real-mode segment */
 	movl	%ebx, %ecx
 	shrl	$4, %ecx
 	
 	/* Patch post-real-mode segment jump */
-	movw	dispatch_table(%ebx,%eax,2),%ax
-	movw	%ax, 101f(%ebx)
-	movw	%cx, 102f(%ebx)
+	movw	(dispatch_table - r_base)(%ebx,%eax,2),%ax
+	movw	%ax, (101f - r_base)(%ebx)
+	movw	%cx, (102f - r_base)(%ebx)
 
 	/* Set up the IDT for real mode. */
-	lidtl	machine_real_restart_idt(%ebx)
+	lidtl	(machine_real_restart_idt - r_base)(%ebx)
 
 	/*
 	 * Set up a GDT from which we can load segment descriptors for real
 	 * mode.  The GDT is not used in real mode; it is just needed here to
 	 * prepare the descriptors.
 	 */
-	lgdtl	machine_real_restart_gdt(%ebx)
+	lgdtl	(machine_real_restart_gdt - r_base)(%ebx)
 
 	/*
 	 * Load the data segment registers with 16-bit compatible values
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index e8c00cc..85b52fc 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -306,7 +306,7 @@ int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 		bi->end = min(bi->end, high);
 
 		/* and there's no empty block */
-		if (bi->start == bi->end) {
+		if (bi->start >= bi->end) {
 			numa_remove_memblk_from(i--, mi);
 			continue;
 		}
