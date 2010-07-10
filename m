Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0GJSOh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 14:14:37 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:45435 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0GJSOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 14:14:36 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jul 2010 14:14:36 EDT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [RFC/PATCH] x86: Early-boot serial I/O support
Date: Sat, 10 Jul 2010 21:07:57 +0300
Message-Id: <1278785277-22629-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds serial I/O support to very early boot printf(). It's useful for
debugging boot code when running Linux under KVM, for example. The actual code
was lifted from early printk.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/boot/boot.h |    1 +
 arch/x86/boot/main.c |    3 ++
 arch/x86/boot/tty.c  |   65 +++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 98239d2..5b37014 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -333,6 +333,7 @@ size_t strnlen(const char *s, size_t maxlen);
 unsigned int atou(const char *s);
 
 /* tty.c */
+void serial_init(void);
 void puts(const char *);
 void putchar(int);
 int getchar(void);
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 140172b..1437efe 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -127,6 +127,9 @@ static void init_heap(void)
 
 void main(void)
 {
+	/* Initialize serial console */
+	serial_init();
+
 	/* First, copy the boot header into the "zeropage" */
 	copy_boot_params();
 
diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
index 01ec69c..2f0def5 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -10,8 +10,7 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * Very simple screen I/O
- * XXX: Probably should add very simple serial I/O?
+ * Very simple screen and serial I/O
  */
 
 #include "boot.h"
@@ -20,13 +19,58 @@
  * These functions are in .inittext so they can be used to signal
  * error during initialization.
  */
+static int early_serial_base = 0x3f8;  /* ttyS0 */
 
-void __attribute__((section(".inittext"))) putchar(int ch)
+#define XMTRDY          0x20
+
+#define DLAB		0x80
+
+#define TXR             0       /*  Transmit register (WRITE) */
+#define RXR             0       /*  Receive register  (READ)  */
+#define IER             1       /*  Interrupt Enable          */
+#define IIR             2       /*  Interrupt ID              */
+#define FCR             2       /*  FIFO control              */
+#define LCR             3       /*  Line control              */
+#define MCR             4       /*  Modem control             */
+#define LSR             5       /*  Line Status               */
+#define MSR             6       /*  Modem Status              */
+#define DLL             0       /*  Divisor Latch Low         */
+#define DLH             1       /*  Divisor latch High        */
+
+#define DEFAULT_BAUD 9600
+
+void __attribute__((section(".inittext"))) serial_init(void)
 {
-	struct biosregs ireg;
+	unsigned baud = DEFAULT_BAUD;
+	unsigned char c;
+	unsigned divisor;
+
+	outb(0x3, early_serial_base + LCR);	/* 8n1 */
+	outb(0, early_serial_base + IER);	/* no interrupt */
+	outb(0, early_serial_base + FCR);	/* no fifo */
+	outb(0x3, early_serial_base + MCR);	/* DTR + RTS */
+
+	divisor	= 115200 / baud;
+	c = inb(early_serial_base + LCR);
+	outb(c | DLAB, early_serial_base + LCR);
+	outb(divisor & 0xff, early_serial_base + DLL);
+	outb((divisor >> 8) & 0xff, early_serial_base + DLH);
+	outb(c & ~DLAB, early_serial_base + LCR);
+}
 
-	if (ch == '\n')
-		putchar('\r');	/* \n -> \r\n */
+static void __attribute__((section(".inittext"))) serial_putchar(int ch)
+{
+	unsigned timeout = 0xffff;
+
+	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
+		;
+
+	outb(ch, early_serial_base + TXR);
+}
+
+static void __attribute__((section(".inittext"))) bios_putchar(int ch)
+{
+	struct biosregs ireg;
 
 	initregs(&ireg);
 	ireg.bx = 0x0007;
@@ -36,6 +80,15 @@ void __attribute__((section(".inittext"))) putchar(int ch)
 	intcall(0x10, &ireg, NULL);
 }
 
+void __attribute__((section(".inittext"))) putchar(int ch)
+{
+	if (ch == '\n')
+		putchar('\r');	/* \n -> \r\n */
+
+	bios_putchar(ch);
+	serial_putchar(ch);
+}
+
 void __attribute__((section(".inittext"))) puts(const char *str)
 {
 	while (*str)
-- 
1.6.3.3

