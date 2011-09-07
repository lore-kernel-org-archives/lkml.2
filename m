Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1IGNfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 09:35:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:56751 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1IGNfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 09:35:08 -0400
From: John Ogness <john.ogness@linutronix.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Dave Martin <dave.martin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: alignment: setup alignment handler earlier
Date: Wed, 07 Sep 2011 15:35:04 +0200
Message-ID: <87ehzstr07.fsf@vostro.fn.ogness.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6f3f381800367127dc6430d9b9fa9bd6fc6d8ed0 Mon Sep 17 00:00:00 2001
From: John Ogness <john.ogness@linutronix.de>

The alignment exception handler is setup fairly late in
the boot process (fs_initcall). However, with newer gcc
versions and the compiler option -fconserve-stack, code
accessing unaligned data is generated in functions that
are called earlier, for example pcpu_dump_alloc_info().
This results in unhandled alignment exceptions during
boot. By setting up the exception handler sooner, we
reduce the window where a compiler may generate code
accessing unaligned data.

Here is a minimal example that shows the issue seen with
pcpu_dump_alloc_info():

=========== begin align_test.c ==========
extern void exfunc(char *str);
void somefunc(void)
{
        char mystr[] = "--------";  /* 9 bytes */
        exfunc(mystr);
}
============ end align_test.c ===========

Using the cross toolchain:
arm-none-linux-gnueabi-gcc (Sourcery G++ Lite 2011.03-41) 4.5.2

$ arm-none-linux-gnueabi-gcc \
     -march=armv6 \
     -mtune=arm1136j-s \
     -marm \
     -Os \
     -fconserve-stack \
     -c align_test.c

The object dump of align_test.o shows:

00000000 <somefunc>:
   0:   e92d401f        push    {r0, r1, r2, r3, r4, lr}
   4:   e28d0007        add     r0, sp, #7
   8:   e59f3020        ldr     r3, [pc, #32]   ; 30 <somefunc+0x30>
   c:   e5932000        ldr     r2, [r3]
  10:   e58d2007        str     r2, [sp, #7]
  ...
  ...

At address 0x10 there is unaligned access.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
Patch against linux-next-20110831.
 arch/arm/include/asm/setup.h |    1 +
 arch/arm/kernel/setup.c      |    2 ++
 arch/arm/mm/alignment.c      |   10 +++++++---
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index a3ca303..b3e18f8 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -232,6 +232,7 @@ extern struct meminfo meminfo;
 extern int arm_add_memory(phys_addr_t start, unsigned long size);
 extern void early_print(const char *str, ...);
 extern void dump_machine_table(void);
+extern int __init alignment_init(void);
 
 #endif  /*  __KERNEL__  */
 
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 0ca06f7..0f1b2b5 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -950,6 +950,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	early_trap_init();
 
+	alignment_init();
+
 	if (mdesc->init_early)
 		mdesc->init_early();
 }
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 715eb1d..5f013cb 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -950,7 +950,7 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
  * it isn't a sysctl, and it doesn't contain sysctl information.
  * We now locate it in /proc/cpu/alignment instead.
  */
-static int __init alignment_init(void)
+static int __init alignment_sysfs_init(void)
 {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *res;
@@ -960,7 +960,13 @@ static int __init alignment_init(void)
 	if (!res)
 		return -ENOMEM;
 #endif
+	return 0;
+}
+
+fs_initcall(alignment_sysfs_init);
 
+int __init alignment_init(void)
+{
 	if (cpu_is_v6_unaligned()) {
 		cr_alignment &= ~CR_A;
 		cr_no_alignment &= ~CR_A;
@@ -985,5 +991,3 @@ static int __init alignment_init(void)
 
 	return 0;
 }
-
-fs_initcall(alignment_init);
-- 
1.7.2.5
