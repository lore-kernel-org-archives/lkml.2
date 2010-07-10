Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0GJTk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 15:40:28 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:33362 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab0GJTkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 15:40:24 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2] x86: Early-boot serial I/O support
Date: Sat, 10 Jul 2010 22:40:20 +0300
Message-Id: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds serial I/O support to very early boot printf(). It's useful for
debugging boot code when running Linux under KVM, for example. The actual code
was lifted from early printk.

Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
v1 -> v2:

  - Use 'earlyprintk' kernel parameter to determine whether to use
    early serial or not as suggested by Yinghai and hpa.

 arch/x86/boot/boot.h   |   16 +++++++
 arch/x86/boot/main.c   |    3 +
 arch/x86/boot/string.c |   41 ++++++++++++++++++
 arch/x86/boot/tty.c    |  111 +++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 165 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 98239d2..f05b5ac 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -37,6 +37,8 @@
 extern struct setup_header hdr;
 extern struct boot_params boot_params;
 
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory")
+
 /* Basic port I/O */
 static inline void outb(u8 v, u16 port)
 {
@@ -203,6 +205,17 @@ static inline int isdigit(int ch)
 	return (ch >= '0') && (ch <= '9');
 }
 
+static inline int isxdigit(int ch)
+{
+	if (isdigit(ch))
+		return true;
+
+	if ((ch >= 'a') && (ch <= 'f'))
+		return true;
+
+	return (ch >= 'A') && (ch <= 'F');
+}
+
 /* Heap -- available for dynamic lists. */
 extern char _end[];
 extern char *HEAP;
@@ -329,10 +342,13 @@ void initregs(struct biosregs *regs);
 
 /* string.c */
 int strcmp(const char *str1, const char *str2);
+int strncmp(const char *cs, const char *ct, size_t count);
 size_t strnlen(const char *s, size_t maxlen);
 unsigned int atou(const char *s);
+unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
 
 /* tty.c */
+void console_init(void);
 void puts(const char *);
 void putchar(int);
 int getchar(void);
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 140172b..4ef1a33 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -130,6 +130,9 @@ void main(void)
 	/* First, copy the boot header into the "zeropage" */
 	copy_boot_params();
 
+	/* Initialize the early-boot console */
+	console_init();
+
 	/* End of heap check */
 	init_heap();
 
diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index f94b7a0..aba29df 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -30,6 +30,22 @@ int strcmp(const char *str1, const char *str2)
 	return 0;
 }
 
+int strncmp(const char *cs, const char *ct, size_t count)
+{
+	unsigned char c1, c2;
+
+	while (count) {
+		c1 = *cs++;
+		c2 = *ct++;
+		if (c1 != c2)
+			return c1 < c2 ? -1 : 1;
+		if (!c1)
+			break;
+		count--;
+	}
+	return 0;
+}
+
 size_t strnlen(const char *s, size_t maxlen)
 {
 	const char *es = s;
@@ -48,3 +64,28 @@ unsigned int atou(const char *s)
 		i = i * 10 + (*s++ - '0');
 	return i;
 }
+
+/* Works only for digits and letters, but small and fast */
+#define TOLOWER(x) ((x) | 0x20)
+
+unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
+{
+	unsigned long long result = 0;
+
+	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
+		cp += 2;
+
+	while (isxdigit(*cp)) {
+		unsigned int value;
+
+		value = isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
+		if (value >= base)
+			break;
+		result = result * base + value;
+		cp++;
+	}
+	if (endp)
+		*endp = (char *)cp;
+
+	return result;
+}
diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
index 01ec69c..f3ceee2 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -10,23 +10,51 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * Very simple screen I/O
- * XXX: Probably should add very simple serial I/O?
+ * Very simple screen and serial I/O
  */
 
 #include "boot.h"
 
+#define DEFAULT_SERIAL_PORT 0x3f8 /* ttyS0 */
+
+static int	early_serial_base;
+
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
 /*
  * These functions are in .inittext so they can be used to signal
  * error during initialization.
  */
 
-void __attribute__((section(".inittext"))) putchar(int ch)
+static void __attribute__((section(".inittext"))) serial_putchar(int ch)
 {
-	struct biosregs ireg;
+	unsigned timeout = 0xffff;
 
-	if (ch == '\n')
-		putchar('\r');	/* \n -> \r\n */
+	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
+		cpu_relax();
+
+	outb(ch, early_serial_base + TXR);
+}
+
+static void __attribute__((section(".inittext"))) bios_putchar(int ch)
+{
+	struct biosregs ireg;
 
 	initregs(&ireg);
 	ireg.bx = 0x0007;
@@ -36,6 +64,17 @@ void __attribute__((section(".inittext"))) putchar(int ch)
 	intcall(0x10, &ireg, NULL);
 }
 
+void __attribute__((section(".inittext"))) putchar(int ch)
+{
+	if (ch == '\n')
+		putchar('\r');	/* \n -> \r\n */
+
+	bios_putchar(ch);
+
+	if (early_serial_base != 0)
+		serial_putchar(ch);
+}
+
 void __attribute__((section(".inittext"))) puts(const char *str)
 {
 	while (*str)
@@ -112,3 +151,63 @@ int getchar_timeout(void)
 
 	return 0;		/* Timeout! */
 }
+
+static void early_serial_init(int baud)
+{
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
+
+void console_init(void)
+{
+	int baud = DEFAULT_BAUD;
+	char arg[32];
+	int pos = 0;
+
+	if (cmdline_find_option("earlyprintk", arg, sizeof arg) > 0) {
+		char *e;
+
+		if (!strncmp(arg, "serial", 6)) {
+			early_serial_base = DEFAULT_SERIAL_PORT;
+			pos += 6;
+		}
+
+		if (arg[pos] == ',')
+			pos++;
+
+		if (!strncmp(arg, "ttyS", 4)) {
+			static const int bases[] = { 0x3f8, 0x2f8 };
+			int port = 0;
+
+			if (!strncmp(arg + pos, "ttyS", 4))
+				pos += 4;
+
+			if (arg[pos++] == '1')
+				port = 1;
+
+			early_serial_base = bases[port];
+		}
+
+		if (arg[pos] == ',')
+			pos++;
+
+		baud = simple_strtoull(arg + pos, &e, 0);
+		if (baud == 0 || arg + pos == e)
+			baud = DEFAULT_BAUD;
+	}
+
+	if (early_serial_base != 0)
+		early_serial_init(baud);
+}
-- 
1.6.3.3

