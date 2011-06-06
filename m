Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1FFILl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:11:41 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:33722 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab1FFILh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:11:37 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] x86/devicetree: add missing early_init_dt_setup_initrd_arch stub
Date: Mon, 6 Jun 2011 10:15:49 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-server; KDE/4.6.2; x86_64; ; )
Organization: Freebox
Cc: tglx@linutronix.de, Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Maxime Bizon <mbizon@freebox.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061015.50039.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <ffainelli@freebox.fr>

This patch fixes the following build failure:

drivers/built-in.o: In function `early_init_dt_check_for_initrd':
/home/florian/dev/kernel/x86/linux-2.6-x86/drivers/of/fdt.c:571:
undefined reference to `early_init_dt_setup_initrd_arch'
make: *** [.tmp_vmlinux1] Error 1

which happens as soon as we enable initrd support on a x86 devicetree
platform such as Intel CE4100.

Tested on a custom Intel CE4100 board.

CC:stable@kernel.org
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
Grant,

MIPS, PowerPC, Microblaze and now x86 all have the same way of implementing
this, would it rather make sense to get this merged to generic devicetree functions
and let this be overriden if needed?

Stable: this is a candidate for 2.6.39.2

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 690bc84..9aeb78a 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/of_pci.h>
+#include <linux/initrd.h>
 
 #include <asm/hpet.h>
 #include <asm/irq_controller.h>
@@ -98,6 +99,16 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
 }
 
+#ifdef CONFIG_BLK_DEV_INITRD
+void __init early_init_dt_setup_initrd_arch(unsigned long start,
+					    unsigned long end)
+{
+	initrd_start = (unsigned long)__va(start);
+	initrd_end = (unsigned long)__va(end);
+	initrd_below_start_ok = 1;
+}
+#endif
+
 void __init add_dtb(u64 data)
 {
 	initial_dtb = data + offsetof(struct setup_data, data);
-- 
1.7.4.1

