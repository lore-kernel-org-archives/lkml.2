Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab1BPHsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:48:14 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:57507 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab1BPHsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:48:09 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 04/12] unicore32 additional architecture files: low-level lib: ocd debug
Date: Wed, 16 Feb 2011 15:48:04 +0800
Message-ID: <014901cbcdad$d7d46b90$877d42b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvNrc929CPH5Qd5Q3OdML9fwv+law==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message-Id: <06d7425e545689763d420f50bb0e9fad2833eb74.1297842537.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
References: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Sat, 15 Jan 2011 18:22:19 +0800

This patch implements low-level debug libraries with On-Chip-Debugger hardware support.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/unicore32/include/mach/ocd.h    |   36 ++++++++++++++
 arch/unicore32/kernel/debug-macro.S  |   89 ++++++++++++++++++++++++++++++++++
 arch/unicore32/kernel/debug.S        |   85 ++++++++++++++++++++++++++++++++
 arch/unicore32/kernel/early_printk.c |   59 ++++++++++++++++++++++
 4 files changed, 269 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/mach/ocd.h
 create mode 100644 arch/unicore32/kernel/debug-macro.S
 create mode 100644 arch/unicore32/kernel/debug.S
 create mode 100644 arch/unicore32/kernel/early_printk.c

diff --git a/arch/unicore32/include/mach/ocd.h b/arch/unicore32/include/mach/ocd.h
new file mode 100644
index 0000000..189fd71
--- /dev/null
+++ b/arch/unicore32/include/mach/ocd.h
@@ -0,0 +1,36 @@
+/*
+ * linux/arch/unicore32/include/mach/ocd.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MACH_PUV3_OCD_H__
+#define __MACH_PUV3_OCD_H__
+
+#if defined(CONFIG_DEBUG_OCD)
+static inline void ocd_putc(unsigned int c)
+{
+	int status, i = 0x2000000;
+
+	do {
+		if (--i < 0)
+			return;
+
+		asm volatile ("movc %0, p1.c0, #0" : "=r" (status));
+	} while (status & 2);
+
+	asm("movc p1.c1, %0, #1" : : "r" (c));
+}
+
+#define putc(ch)	ocd_putc(ch)
+#else
+#define putc(ch)
+#endif
+
+#endif
diff --git a/arch/unicore32/kernel/debug-macro.S b/arch/unicore32/kernel/debug-macro.S
new file mode 100644
index 0000000..2711d6d
--- /dev/null
+++ b/arch/unicore32/kernel/debug-macro.S
@@ -0,0 +1,89 @@
+/*
+ * linux/arch/unicore32/kernel/debug-macro.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Debugging macro include header
+ */
+#include <generated/asm-offsets.h>
+#include <mach/hardware.h>
+
+		.macro	put_word_ocd, rd, rx=r16
+1001:		movc		\rx, p1.c0, #0
+		cand.a	\rx, #2
+		bne	1001b
+		movc		p1.c1, \rd, #1
+		.endm
+
+#ifdef CONFIG_DEBUG_OCD
+		/* debug using UniCore On-Chip-Debugger */
+		.macro	addruart, rx
+		.endm
+
+		.macro	senduart, rd, rx
+		put_word_ocd	\rd, \rx
+		.endm
+
+		.macro	busyuart, rd, rx
+		.endm
+
+		.macro	waituart, rd, rx
+		.endm
+#else
+#define UART_CLK_DEFAULT        3686400 * 20
+	/* Uartclk = MCLK/ 2, The MCLK on my board is 3686400 * 40  */
+#define BAUD_RATE_DEFAULT	115200
+	/* The baud rate of the serial port */
+
+#define UART_DIVISOR_DEFAULT	(UART_CLK_DEFAULT \
+				/ (16 * BAUD_RATE_DEFAULT) - 1)
+
+		.macro	addruart,rx
+		mrc	p0, #0, \rx, c1, c0
+		tst	\rx, #1			@ MMU enabled?
+		moveq	\rx, #0xee000000	@ physical base address
+		movne	\rx, #0x6e000000	@ virtual address
+
+		@ We probe for the active serial port here
+		@ However, now we assume UART0 is active:	epip4d
+		@ We assume r1 and r2 can be clobbered.
+
+		movl 	r2, #UART_DIVISOR_DEFAULT
+		mov 	r1, #0x80
+		str	r1, [\rx, #UART_LCR_OFFSET]
+		and	r1, r2, #0xff00
+		mov	r1, r1, lsr #8
+		str	r1, [\rx, #UART_DLH_OFFSET]
+		and	r1, r2, #0xff
+		str	r1, [\rx, #UART_DLL_OFFSET]
+		mov 	r1, #0x7
+		str	r1, [\rx, #UART_FCR_OFFSET]
+		mov 	r1, #0x3
+		str	r1, [\rx, #UART_LCR_OFFSET]
+		mov 	r1, #0x0
+		str	r1, [\rx, #UART_IER_OFFSET]
+		.endm
+
+		.macro	senduart,rd,rx
+		str	\rd, [\rx, #UART_THR_OFFSET]
+		.endm
+
+		.macro	waituart,rd,rx
+1001:		ldr	\rd, [\rx, #UART_LSR_OFFSET]
+		tst	\rd, #UART_LSR_THRE
+		beq	1001b
+		.endm
+
+		.macro	busyuart,rd,rx
+1001:		ldr	\rd, [\rx, #UART_LSR_OFFSET]
+		tst	\rd, #UART_LSR_TEMT
+		bne	1001b
+		.endm
+#endif
+
diff --git a/arch/unicore32/kernel/debug.S b/arch/unicore32/kernel/debug.S
new file mode 100644
index 0000000..029fd12
--- /dev/null
+++ b/arch/unicore32/kernel/debug.S
@@ -0,0 +1,85 @@
+/*
+ * linux/arch/unicore32/kernel/debug.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  32-bit debugging code
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+		.text
+
+/*
+ * Some debugging routines (useful if you've got MM problems and
+ * printk isn't working).  For DEBUGGING ONLY!!!  Do not leave
+ * references to these in a production kernel!
+ */
+#include "debug-macro.S"
+
+/*
+ * Useful debugging routines
+ */
+ENTRY(printhex8)
+		mov	r1, #8
+		b	printhex
+ENDPROC(printhex8)
+
+ENTRY(printhex4)
+		mov	r1, #4
+		b	printhex
+ENDPROC(printhex4)
+
+ENTRY(printhex2)
+		mov	r1, #2
+printhex:	adr	r2, hexbuf
+		add	r3, r2, r1
+		mov	r1, #0
+		stb	r1, [r3]
+1:		and	r1, r0, #15
+		mov	r0, r0 >> #4
+		csub.a	r1, #10
+		beg	2f
+		add	r1, r1, #'0' - 'a' + 10
+2:		add	r1, r1, #'a' - 10
+		stb.w	r1, [r3+], #-1
+		cxor.a	r3, r2
+		bne	1b
+		mov	r0, r2
+		b	printascii
+ENDPROC(printhex2)
+
+		.ltorg
+
+ENTRY(printascii)
+		addruart r3
+		b	2f
+1:		waituart r2, r3
+		senduart r1, r3
+		busyuart r2, r3
+		cxor.a	r1, #'\n'
+		cmoveq	r1, #'\r'
+		beq	1b
+2:		cxor.a	r0, #0
+		beq	3f
+		ldb.w	r1, [r0]+, #1
+		cxor.a	r1, #0
+		bne	1b
+3:		mov	pc, lr
+ENDPROC(printascii)
+
+ENTRY(printch)
+		addruart r3
+		mov	r1, r0
+		mov	r0, #0
+		b	1b
+ENDPROC(printch)
+
+hexbuf:		.space 16
+
diff --git a/arch/unicore32/kernel/early_printk.c b/arch/unicore32/kernel/early_printk.c
new file mode 100644
index 0000000..3922255
--- /dev/null
+++ b/arch/unicore32/kernel/early_printk.c
@@ -0,0 +1,59 @@
+/*
+ * linux/arch/unicore32/kernel/early_printk.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/console.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <mach/ocd.h>
+
+/* On-Chip-Debugger functions */
+
+static void early_ocd_write(struct console *con, const char *s, unsigned n)
+{
+	while (*s && n-- > 0) {
+		if (*s == '\n')
+			ocd_putc((int)'\r');
+		ocd_putc((int)*s);
+		s++;
+	}
+}
+
+static struct console early_ocd_console = {
+	.name =		"earlyocd",
+	.write =	early_ocd_write,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
+
+/* Direct interface for emergencies */
+static struct console *early_console = &early_ocd_console;
+
+static int __initdata keep_early;
+
+static int __init setup_early_printk(char *buf)
+{
+	if (!buf)
+		return 0;
+
+	if (strstr(buf, "keep"))
+		keep_early = 1;
+
+	if (!strncmp(buf, "ocd", 3))
+		early_console = &early_ocd_console;
+
+	if (keep_early)
+		early_console->flags &= ~CON_BOOT;
+	else
+		early_console->flags |= CON_BOOT;
+	register_console(early_console);
+	return 0;
+}
+early_param("earlyprintk", setup_early_printk);
-- 
1.6.2.2


