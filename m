Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030394Ab2HWKyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:54:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44534 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030305Ab2HWKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:54:48 -0400
Date: Thu, 23 Aug 2012 12:54:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120823105441.GA12301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 36bf50d7697be18c6bfd0401e037df10bff1e573 x86, microcode, AMD: Fix broken ucode patch size check

This tree contains assorted fixlets: an alternatives patching 
crash fix, an irq migration/hotplug interaction fix, a fix for 
large AMD microcode images and a comment fixlet.

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86, microcode, AMD: Fix broken ucode patch size check

Avi Kivity (1):
      x86/alternatives: Fix p6 nops on non-modular kernels

Liu, Chuansheng (1):
      x86/fixup_irq: Use cpu_online_mask instead of cpu_all_mask

Richard Weinberger (1):
      x86/spinlocks: Fix comment in spinlock.h


 arch/x86/include/asm/spinlock.h | 3 +--
 arch/x86/kernel/alternative.c   | 2 +-
 arch/x86/kernel/irq.c           | 2 +-
 arch/x86/kernel/microcode_amd.c | 7 ++++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index b315a33..33692ea 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -12,8 +12,7 @@
  * Simple spin lock operations.  There are two variants, one clears IRQ's
  * on the local processor, one does not.
  *
- * These are fair FIFO ticket locks, which are currently limited to 256
- * CPUs.
+ * These are fair FIFO ticket locks, which support up to 2^16 CPUs.
  *
  * (the type definitions are in asm/spinlock_types.h)
  */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index afb7ff7..ced4534 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -165,7 +165,7 @@ static const unsigned char * const k7_nops[ASM_NOP_MAX+2] =
 #endif
 
 #ifdef P6_NOP1
-static const unsigned char  __initconst_or_module p6nops[] =
+static const unsigned char p6nops[] =
 {
 	P6_NOP1,
 	P6_NOP2,
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 7ad683d..d44f782 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -270,7 +270,7 @@ void fixup_irqs(void)
 
 		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			break_affinity = 1;
-			affinity = cpu_all_mask;
+			affinity = cpu_online_mask;
 		}
 
 		chip = irq_data_get_irq_chip(data);
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 8a2ce8f..82746f9 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -143,11 +143,12 @@ static int get_matching_microcode(int cpu, const u8 *ucode_ptr,
 				  unsigned int *current_size)
 {
 	struct microcode_header_amd *mc_hdr;
-	unsigned int actual_size;
+	unsigned int actual_size, patch_size;
 	u16 equiv_cpu_id;
 
 	/* size of the current patch we're staring at */
-	*current_size = *(u32 *)(ucode_ptr + 4) + SECTION_HDR_SIZE;
+	patch_size = *(u32 *)(ucode_ptr + 4);
+	*current_size = patch_size + SECTION_HDR_SIZE;
 
 	equiv_cpu_id = find_equiv_id();
 	if (!equiv_cpu_id)
@@ -174,7 +175,7 @@ static int get_matching_microcode(int cpu, const u8 *ucode_ptr,
 	/*
 	 * now that the header looks sane, verify its size
 	 */
-	actual_size = verify_ucode_size(cpu, *current_size, leftover_size);
+	actual_size = verify_ucode_size(cpu, patch_size, leftover_size);
 	if (!actual_size)
 		return 0;
 
