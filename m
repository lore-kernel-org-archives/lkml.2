Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1IZSYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:24:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:63354 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab1IZSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:24:31 -0400
From: Doug Anderson <dianders@chromium.org>
To: Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>
Cc: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Doug Anderson <dianders@chromium.org>, Simon Glass <sjg@chromium.org>,
        Allen Martin <AMartin@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: tegra: Make earlyprintk choose a UART at runtime.
Date: Mon, 26 Sep 2011 11:23:45 -0700
Message-Id: <1317061425-1030-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change we automatically detect which UART to use for
earlyprintk (and for printing during decompression).  The
detection involves coordination with the bootloader: it's expected
that the bootloader will leave a 'D' (for [D]ebug) in the UART
scratchpad register for whichever UART we should use for debugging.

If we don't find any UART that specified, we'll fall back to the
UART that was specified during config time:
CONFIG_TEGRA_DEBUG_UART_XXX.

As a side effect of this change, earlyprintk will no longer fail
if you've specified CONFIG_TEGRA_DEBUG_UART_NONE.

This change is in line with what is documented in the
Documentation/arm/Booting file.  In other words: it's expected
that the bootloader initialize one serial port so that the
kernel can detect it.

Other approaches considered:
* Hardcode based on machine ID (as many other ARM boards do).
  OK, but nice to not have yet another place to add per-board
  code.  Better to have bootloader parse device tree and pass us
  this info.
* Check for TXE bit (like SA1110).  Nice (and doesn't require
  a bootloader change), but a little less explicit.  Also: if
  bootloader (for some reason) uses another UART, it needs to
  remember to turn it off before jumping to the kernel or we may
  print to it.  NOTE: adapting this patch to check TXE is easy
  for me to move to if maintainers would prefer it.
* Check for which UART clock is enabled.  Similar to TXE
  solution, but might be more robust of reads from an unclocked
  UART hang the system.
* Communicate from decompression code to assembly with magic
  memory area (like OMAP_UART_INFO).  Would prefer to avoid for
  the downsides described in the OMAP patch that added this,
  especially the fact that running without a zImage would (I
  think) make earlyprintk fail.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/mach-tegra/include/mach/debug-macro.S |  155 ++++++++++++++++++++++--
 arch/arm/mach-tegra/include/mach/uncompress.h  |   50 ++++++--
 2 files changed, 181 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/debug-macro.S b/arch/arm/mach-tegra/include/mach/debug-macro.S
index e0ebe65..8a4190a 100644
--- a/arch/arm/mach-tegra/include/mach/debug-macro.S
+++ b/arch/arm/mach-tegra/include/mach/debug-macro.S
@@ -1,11 +1,12 @@
 /*
  * arch/arm/mach-tegra/include/mach/debug-macro.S
  *
- * Copyright (C) 2010 Google, Inc.
+ * Copyright (C) 2011 Google, Inc.
  *
  * Author:
  *	Colin Cross <ccross@google.com>
  *	Erik Gilling <konkers@google.com>
+ *	Doug Anderson <dianders@chromium.org>
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -18,18 +19,150 @@
  *
  */
 
+#include <linux/serial_reg.h>
+
+#include <asm/memory.h>
+
 #include <mach/io.h>
 #include <mach/iomap.h>
 
-	.macro  addruart, rp, rv
-        ldr     \rp, =IO_APB_PHYS       @ physical
-        ldr     \rv, =IO_APB_VIRT        @ virtual
-	orr	\rp, \rp, #(TEGRA_DEBUG_UART_BASE & 0xFF)
-	orr	\rp, \rp, #(TEGRA_DEBUG_UART_BASE & 0xFF00)
-	orr	\rv, \rv, #(TEGRA_DEBUG_UART_BASE & 0xFF)
-	orr	\rv, \rv, #(TEGRA_DEBUG_UART_BASE & 0xFF00)
-	.endm
+#define UART_SHIFT			2
+#define TEGRA_DEBUG_UART_OFFSET		(TEGRA_DEBUG_UART_BASE & 0xFFFF)
+
+#define tegra_uart_v2p(x)		((x) - PAGE_OFFSET + PLAT_PHYS_OFFSET)
+
+		/*
+		 * Order matters for this section; code below assumes that
+		 * phys is 4 from config and virt is 8 from config.
+		 *
+		 * By default, we'll start the UART by looking at whatever
+		 * was specified by CONFIG_TEGRA_DEBUG_UART_XXX, but on the
+		 * first use of addruart we'll search all UARTs for one with
+		 * a 'D' in the scratchpad register.  If we find one, we'll
+		 * use it instead.
+		 */
+		.pushsection .data
+tegra_uart_config:	.word	0
+tegra_uart_phys:	.word	IO_APB_PHYS + TEGRA_DEBUG_UART_OFFSET
+tegra_uart_virt:	.word	IO_APB_VIRT + TEGRA_DEBUG_UART_OFFSET
+		.popsection
+
+
+		/* Put address of tegra_uart_config into \ra */
+		.macro	get_uart_config_addr, ra
+		mrc	p15, 0, \ra, c1, c0
+		tst	\ra, #1					@ MMU enabled?
+		ldreq	\ra, =tegra_uart_v2p(tegra_uart_config)	@ not enabled
+		ldrne	\ra, =tegra_uart_config			@ enabled
+		.endm
+
+		/* Check whether a given UART is the debug UART; sets cond. */
+		.macro	check_uart, rio, rtmp, uart_base
+		orr	\rtmp, \rio, #(\uart_base & 0xFF)
+		orr	\rtmp, \rtmp, #(\uart_base & 0xFF00)
+		ldrb	\rtmp, [\rtmp, #(UART_SCR << UART_SHIFT)]
+		cmp	\rtmp, #'D'
+		.endm
+
+		/*
+		 * Store the given UART in the data section; needs two
+		 * temp registers to work with.
+		 */
+		.macro	store_uart, rx, ry, uart_base
+		get_uart_config_addr \rx
+		ldr	\ry, =(IO_APB_PHYS + (\uart_base & 0xFFFF))
+		str	\ry, [\rx, #4]
+		ldr	\ry, =(IO_APB_VIRT + (\uart_base & 0xFFFF))
+		str	\ry, [\rx, #8]
+		.endm
+
+
+		/*
+		 * Get phys and virt addr of the debug UART.  Return results in
+		 * registers \rp and \rv, which are the only two registers
+		 * we get to work with.  Code is loosely based on OMAP
+		 * version of debug-macro.S.
+		 */
+		.macro	addruart, rp, rv
+
+10:		get_uart_config_addr \rp
+		ldr	\rv, [\rp, #0]
+		cmp	\rv, #1			@ is port configured?
+		beq	99f			@ ...yes? jump to end
+
+		mov	\rv, #1 		@ store so next time we are
+		str	\rv, [\rp, #0]		@ consider oursevles configured
+
+		/* Use \rp to hold IO base address while we search for 'D' */
+		mrc	p15, 0, \rp, c1, c0
+		tst	\rp, #1			@ MMU enabled?
+		ldreq	\rp, =IO_APB_PHYS	@ MMU not enabled
+		ldrne	\rp, =IO_APB_VIRT	@ MMU enabled
+
+		/* Check for UARTA */
+		check_uart \rp, \rv, TEGRA_UARTA_BASE
+		bne	21f			@ not UARTA
+		store_uart \rp, \rv, TEGRA_UARTA_BASE
+		b	10b
+
+		/* Check for UARTB */
+21:		check_uart \rp, \rv, TEGRA_UARTB_BASE
+		bne	22f			@ not UARTB
+		store_uart \rp, \rv, TEGRA_UARTB_BASE
+		b	10b
+
+		/* Check for UARTC */
+22:		check_uart \rp, \rv, TEGRA_UARTC_BASE
+		bne	23f			@ not UARTC
+		store_uart \rp, \rv, TEGRA_UARTC_BASE
+		b	10b
+
+		/* Check for UARTD */
+23:		check_uart \rp, \rv, TEGRA_UARTD_BASE
+		bne	24f			@ not UARTD
+		store_uart \rp, \rv, TEGRA_UARTD_BASE
+		b	10b
+
+		/* Check for UARTE */
+24:		check_uart \rp, \rv, TEGRA_UARTE_BASE
+		bne	10b			@ not UARTE; give up
+		store_uart \rp, \rv, TEGRA_UARTE_BASE
+		b	10b
+
+		/* When you jump to here \rp has addr of tegra_uart_config */
+99:		ldr	\rv, [\rp, #8]		@ virt is 8 bytes after config
+		ldr	\rp, [\rp, #4]		@ phys is 4 bytes after config
+		.endm
+
+/*
+ * Code below is swiped from <asm/hardware/debug-8250.S>, but add an extra
+ * check to make sure that we aren't in the CONFIG_TEGRA_DEBUG_UART_NONE case.
+ * We use the fact that all 5 valid UARTS addresses all have something in the
+ * 2nd-to-lowest byte.
+ */
+		.macro	senduart,rd,rx
+		tst	\rx, #0x0000ff00
+		strneb	\rd, [\rx, #UART_TX << UART_SHIFT]
+1001:
+		.endm
 
-#define UART_SHIFT	2
-#include <asm/hardware/debug-8250.S>
+		.macro	busyuart,rd,rx
+		tst	\rx, #0x0000ff00
+		beq	1002f
+1001:		ldrb	\rd, [\rx, #UART_LSR << UART_SHIFT]
+		and	\rd, \rd, #UART_LSR_TEMT | UART_LSR_THRE
+		teq	\rd, #UART_LSR_TEMT | UART_LSR_THRE
+		bne	1001b
+1002:
+		.endm
 
+		.macro	waituart,rd,rx
+#ifdef FLOW_CONTROL
+		tst	\rx, #0x0000ff00
+		beq	1002f
+1001:		ldrb	\rd, [\rx, #UART_MSR << UART_SHIFT]
+		tst	\rd, #UART_MSR_CTS
+		beq	1001b
+1002:
+#endif
+		.endm
diff --git a/arch/arm/mach-tegra/include/mach/uncompress.h b/arch/arm/mach-tegra/include/mach/uncompress.h
index 4e83237..2f776bd 100644
--- a/arch/arm/mach-tegra/include/mach/uncompress.h
+++ b/arch/arm/mach-tegra/include/mach/uncompress.h
@@ -1,11 +1,12 @@
 /*
  * arch/arm/mach-tegra/include/mach/uncompress.h
  *
- * Copyright (C) 2010 Google, Inc.
+ * Copyright (C) 2011 Google, Inc.
  *
  * Author:
  *	Colin Cross <ccross@google.com>
  *	Erik Gilling <konkers@google.com>
+ *	Doug Anderson <dianders@chromium.org>
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -21,40 +22,63 @@
 #ifndef __MACH_TEGRA_UNCOMPRESS_H
 #define __MACH_TEGRA_UNCOMPRESS_H
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/serial_reg.h>
 
 #include <mach/iomap.h>
 
+u32 uart_base;
+
+#define DEBUG_UART_SHIFT	2
+
 static void putc(int c)
 {
-	volatile u8 *uart = (volatile u8 *)TEGRA_DEBUG_UART_BASE;
-	int shift = 2;
+	volatile u8 *uart = (volatile u8 *)uart_base;
 
 	if (uart == NULL)
 		return;
 
-	while (!(uart[UART_LSR << shift] & UART_LSR_THRE))
+	while (!(uart[UART_LSR << DEBUG_UART_SHIFT] & UART_LSR_THRE))
 		barrier();
-	uart[UART_TX << shift] = c;
+	uart[UART_TX << DEBUG_UART_SHIFT] = c;
 }
 
 static inline void flush(void)
 {
 }
 
+/*
+ * Setup before decompression.  This is where we do UART selection for
+ * earlyprintk and init the uart_base register.
+ */
 static inline void arch_decomp_setup(void)
 {
-	volatile u8 *uart = (volatile u8 *)TEGRA_DEBUG_UART_BASE;
-	int shift = 2;
+	static const u32 uarts[] = {
+		TEGRA_UARTA_BASE,
+		TEGRA_UARTB_BASE,
+		TEGRA_UARTC_BASE,
+		TEGRA_UARTD_BASE,
+		TEGRA_UARTE_BASE,
+	};
+	const u32 num_uarts = ARRAY_SIZE(uarts);
+	u32 i;
 
-	if (uart == NULL)
-		return;
+	/*
+	 * Look for the first UART that has a 'D' in the scratchpad register,
+	 * which should be set by the bootloader to tell us which UART to use
+	 * for debugging.  If nothing found, we'll fall back to what's
+	 * specified in TEGRA_DEBUG_UART_BASE.
+	 */
+	uart_base = TEGRA_DEBUG_UART_BASE;
+	for (i = 0; i < num_uarts; i++) {
+		volatile u8 *uart = (volatile u8 *)uarts[i];
 
-	uart[UART_LCR << shift] |= UART_LCR_DLAB;
-	uart[UART_DLL << shift] = 0x75;
-	uart[UART_DLM << shift] = 0x0;
-	uart[UART_LCR << shift] = 3;
+		if (uart[UART_SCR << DEBUG_UART_SHIFT] == 'D') {
+			uart_base = uarts[i];
+			break;
+		}
+	}
 }
 
 static inline void arch_decomp_wdog(void)
-- 
1.7.3.1

