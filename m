Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0GLWBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:01:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:36961 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab0GLWBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:01:40 -0400
Date: Mon, 12 Jul 2010 22:00:54 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@cs.helsinki.fi, gorcunov@gmail.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@cs.helsinki.fi, gorcunov@gmail.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1278835617-11368-1-git-send-email-penberg@cs.helsinki.fi>
References: <1278835617-11368-1-git-send-email-penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] x86, setup: Early-boot serial I/O support
Message-ID: <tip-fa97bdf92709adaaf8b9a5164a895e262a4fcf60@git.kernel.org>
Git-Commit-ID: fa97bdf92709adaaf8b9a5164a895e262a4fcf60
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 12 Jul 2010 22:00:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa97bdf92709adaaf8b9a5164a895e262a4fcf60
Gitweb:     http://git.kernel.org/tip/fa97bdf92709adaaf8b9a5164a895e262a4fcf60
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Sun, 11 Jul 2010 11:06:57 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 12 Jul 2010 14:46:00 -0700

x86, setup: Early-boot serial I/O support

This patch adds serial I/O support to the real-mode setup (very early
boot) printf(). It's useful for debugging boot code when running Linux
under KVM, for example. The actual code was lifted from early printk.

Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1278835617-11368-1-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/boot.h   |   16 +++++++
 arch/x86/boot/main.c   |    3 +
 arch/x86/boot/string.c |   41 ++++++++++++++++++
 arch/x86/boot/tty.c    |  111 +++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 165 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 98239d2..46c4c5c 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -37,6 +37,8 @@
 extern struct setup_header hdr;
 extern struct boot_params boot_params;
 
+#define cpu_relax()	asm volatile("rep; nop")
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
