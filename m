Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0HBJSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:18:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19525 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab0HBJSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:18:32 -0400
Message-ID: <4C568D2B.205@kernel.org>
Date: Mon, 02 Aug 2010 02:17:31 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v3 1/2] x86, setup: reorgize the early_console_setup
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org>
In-Reply-To: <4C5680D2.4020302@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C568D30.00D3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Seperate early_serial_console from tty.c

will reuse early_serial_console.c/string.c/printf.c/cmdline.c in compressed/misc.c

-v2: according to hpa, don't include string.c etc
-v3: compressed/misc.c must have early_serial_base as static, so move it back to tty.c
     for setup code

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/Makefile               |    8 +-
 arch/x86/boot/boot.h                 |   35 ++++----
 arch/x86/boot/cmdline.c              |    6 -
 arch/x86/boot/early_serial_console.c |  139 +++++++++++++++++++++++++++++++++++
 arch/x86/boot/isdigit.h              |   21 +++++
 arch/x86/boot/printf.c               |    4 -
 arch/x86/boot/tty.c                  |  136 ----------------------------------
 7 files changed, 186 insertions(+), 163 deletions(-)

Index: linux-2.6/arch/x86/boot/tty.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/tty.c
+++ linux-2.6/arch/x86/boot/tty.c
@@ -15,27 +15,12 @@
 
 #include "boot.h"
 
-#define DEFAULT_SERIAL_PORT 0x3f8 /* ttyS0 */
-
-static int	early_serial_base;
+int early_serial_base;
 
 #define XMTRDY          0x20
 
-#define DLAB		0x80
-
 #define TXR             0       /*  Transmit register (WRITE) */
-#define RXR             0       /*  Receive register  (READ)  */
-#define IER             1       /*  Interrupt Enable          */
-#define IIR             2       /*  Interrupt ID              */
-#define FCR             2       /*  FIFO control              */
-#define LCR             3       /*  Line control              */
-#define MCR             4       /*  Modem control             */
 #define LSR             5       /*  Line Status               */
-#define MSR             6       /*  Modem Status              */
-#define DLL             0       /*  Divisor Latch Low         */
-#define DLH             1       /*  Divisor latch High        */
-
-#define DEFAULT_BAUD 9600
 
 /*
  * These functions are in .inittext so they can be used to signal
@@ -152,122 +137,3 @@ int getchar_timeout(void)
 	return 0;		/* Timeout! */
 }
 
-static void early_serial_init(int port, int baud)
-{
-	unsigned char c;
-	unsigned divisor;
-
-	outb(0x3, port + LCR);	/* 8n1 */
-	outb(0, port + IER);	/* no interrupt */
-	outb(0, port + FCR);	/* no fifo */
-	outb(0x3, port + MCR);	/* DTR + RTS */
-
-	divisor	= 115200 / baud;
-	c = inb(port + LCR);
-	outb(c | DLAB, port + LCR);
-	outb(divisor & 0xff, port + DLL);
-	outb((divisor >> 8) & 0xff, port + DLH);
-	outb(c & ~DLAB, port + LCR);
-
-	early_serial_base = port;
-
-	printf("Early serial console at I/O port 0x%x baud: %d\n", port, baud);
-}
-
-static void parse_earlyprintk(void)
-{
-	int baud = DEFAULT_BAUD;
-	char arg[32];
-	int pos = 0;
-	int port = 0;
-
-	if (cmdline_find_option("earlyprintk", arg, sizeof arg) > 0) {
-		char *e;
-
-		if (!strncmp(arg, "serial", 6)) {
-			port = DEFAULT_SERIAL_PORT;
-			pos += 6;
-		}
-
-		if (arg[pos] == ',')
-			pos++;
-
-		if (!strncmp(arg, "ttyS", 4)) {
-			static const int bases[] = { 0x3f8, 0x2f8 };
-			int idx = 0;
-
-			if (!strncmp(arg + pos, "ttyS", 4))
-				pos += 4;
-
-			if (arg[pos++] == '1')
-				idx = 1;
-
-			port = bases[idx];
-		}
-
-		if (arg[pos] == ',')
-			pos++;
-
-		baud = simple_strtoull(arg + pos, &e, 0);
-		if (baud == 0 || arg + pos == e)
-			baud = DEFAULT_BAUD;
-	}
-
-	if (port)
-		early_serial_init(port, baud);
-}
-
-#define BASE_BAUD (1843200/16)
-static unsigned int probe_baud(int port)
-{
-	unsigned char lcr, dll, dlh;
-	unsigned int quot;
-
-	lcr = inb(port + LCR);
-	outb(lcr | DLAB, port + LCR);
-	dll = inb(port + DLL);
-	dlh = inb(port + DLH);
-	outb(lcr, port + LCR);
-	quot = (dlh << 8) | dll;
-
-	return BASE_BAUD / quot;
-}
-
-static void parse_console_uart8250(void)
-{
-	char optstr[64], *options;
-	int baud = DEFAULT_BAUD;
-	int port = 0;
-
-	/*
-	 * console=uart8250,io,0x3f8,115200n8
-	 * need to make sure it is last one console !
-	 */
-	if (cmdline_find_option("console", optstr, sizeof optstr) <= 0)
-		return;
-
-	options = optstr;
-
-	if (!strncmp(options, "uart8250,io,", 12))
-		port = simple_strtoull(options + 12, &options, 0);
-	else if (!strncmp(options, "uart,io,", 8))
-		port = simple_strtoull(options + 8, &options, 0);
-	else
-		return;
-
-	if (options && (options[0] == ','))
-		baud = simple_strtoull(options + 1, &options, 0);
-	else
-		baud = probe_baud(port);
-
-	if (port)
-		early_serial_init(port, baud);
-}
-
-void console_init(void)
-{
-	parse_earlyprintk();
-
-	if (!early_serial_base)
-		parse_console_uart8250();
-}
Index: linux-2.6/arch/x86/boot/early_serial_console.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/boot/early_serial_console.c
@@ -0,0 +1,139 @@
+#include "boot.h"
+
+#define DEFAULT_SERIAL_PORT 0x3f8 /* ttyS0 */
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
+static void early_serial_init(int port, int baud)
+{
+	unsigned char c;
+	unsigned divisor;
+
+	outb(0x3, port + LCR);	/* 8n1 */
+	outb(0, port + IER);	/* no interrupt */
+	outb(0, port + FCR);	/* no fifo */
+	outb(0x3, port + MCR);	/* DTR + RTS */
+
+	divisor	= 115200 / baud;
+	c = inb(port + LCR);
+	outb(c | DLAB, port + LCR);
+	outb(divisor & 0xff, port + DLL);
+	outb((divisor >> 8) & 0xff, port + DLH);
+	outb(c & ~DLAB, port + LCR);
+
+	early_serial_base = port;
+}
+
+static void parse_earlyprintk(void)
+{
+	int baud = DEFAULT_BAUD;
+	char arg[32];
+	int pos = 0;
+	int port = 0;
+
+	if (cmdline_find_option("earlyprintk", arg, sizeof arg) > 0) {
+		char *e;
+
+		if (!strncmp(arg, "serial", 6)) {
+			port = DEFAULT_SERIAL_PORT;
+			pos += 6;
+		}
+
+		if (arg[pos] == ',')
+			pos++;
+
+		if (!strncmp(arg, "ttyS", 4)) {
+			static const int bases[] = { 0x3f8, 0x2f8 };
+			int idx = 0;
+
+			if (!strncmp(arg + pos, "ttyS", 4))
+				pos += 4;
+
+			if (arg[pos++] == '1')
+				idx = 1;
+
+			port = bases[idx];
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
+	if (port)
+		early_serial_init(port, baud);
+}
+
+#define BASE_BAUD (1843200/16)
+static unsigned int probe_baud(int port)
+{
+	unsigned char lcr, dll, dlh;
+	unsigned int quot;
+
+	lcr = inb(port + LCR);
+	outb(lcr | DLAB, port + LCR);
+	dll = inb(port + DLL);
+	dlh = inb(port + DLH);
+	outb(lcr, port + LCR);
+	quot = (dlh << 8) | dll;
+
+	return BASE_BAUD / quot;
+}
+
+static void parse_console_uart8250(void)
+{
+	char optstr[64], *options;
+	int baud = DEFAULT_BAUD;
+	int port = 0;
+
+	/*
+	 * console=uart8250,io,0x3f8,115200n8
+	 * need to make sure it is last one console !
+	 */
+	if (cmdline_find_option("console", optstr, sizeof optstr) <= 0)
+		return;
+
+	options = optstr;
+
+	if (!strncmp(options, "uart8250,io,", 12))
+		port = simple_strtoull(options + 12, &options, 0);
+	else if (!strncmp(options, "uart,io,", 8))
+		port = simple_strtoull(options + 8, &options, 0);
+	else
+		return;
+
+	if (options && (options[0] == ','))
+		baud = simple_strtoull(options + 1, &options, 0);
+	else
+		baud = probe_baud(port);
+
+	if (port)
+		early_serial_init(port, baud);
+}
+
+void console_init(void)
+{
+	parse_earlyprintk();
+
+	if (!early_serial_base)
+		parse_console_uart8250();
+}
Index: linux-2.6/arch/x86/boot/printf.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/printf.c
+++ linux-2.6/arch/x86/boot/printf.c
@@ -34,7 +34,7 @@ static int skip_atoi(const char **s)
 #define SMALL	32		/* Must be 32 == 0x20 */
 #define SPECIAL	64		/* 0x */
 
-#define do_div(n,base) ({ \
+#define __do_div(n, base) ({ \
 int __res; \
 __res = ((unsigned long) n) % (unsigned) base; \
 n = ((unsigned long) n) / (unsigned) base; \
@@ -83,7 +83,7 @@ static char *number(char *str, long num,
 		tmp[i++] = '0';
 	else
 		while (num != 0)
-			tmp[i++] = (digits[do_div(num, base)] | locase);
+			tmp[i++] = (digits[__do_div(num, base)] | locase);
 	if (i > precision)
 		precision = i;
 	size -= precision;
Index: linux-2.6/arch/x86/boot/cmdline.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/cmdline.c
+++ linux-2.6/arch/x86/boot/cmdline.c
@@ -27,9 +27,8 @@ static inline int myisspace(u8 c)
  * Returns the length of the argument (regardless of if it was
  * truncated to fit in the buffer), or -1 on not found.
  */
-int cmdline_find_option(const char *option, char *buffer, int bufsize)
+int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int bufsize)
 {
-	u32 cmdline_ptr = boot_params.hdr.cmd_line_ptr;
 	addr_t cptr;
 	char c;
 	int len = -1;
@@ -100,9 +99,8 @@ int cmdline_find_option(const char *opti
  * Returns the position of that option (starts counting with 1)
  * or 0 on not found
  */
-int cmdline_find_option_bool(const char *option)
+int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option)
 {
-	u32 cmdline_ptr = boot_params.hdr.cmd_line_ptr;
 	addr_t cptr;
 	char c;
 	int pos = 0, wstart = 0;
Index: linux-2.6/arch/x86/boot/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/boot/Makefile
+++ linux-2.6/arch/x86/boot/Makefile
@@ -26,10 +26,10 @@ targets		:= vmlinux.bin setup.bin setup.
 targets		+= fdimage fdimage144 fdimage288 image.iso mtools.conf
 subdir-		:= compressed
 
-setup-y		+= a20.o bioscall.o cmdline.o copy.o cpu.o cpucheck.o edd.o
-setup-y		+= header.o main.o mca.o memory.o pm.o pmjump.o
-setup-y		+= printf.o regs.o string.o tty.o video.o video-mode.o
-setup-y		+= version.o
+setup-y		+= a20.o bioscall.o cmdline.o copy.o cpu.o cpucheck.o
+setup-y		+= early_serial_console.o edd.o header.o main.o mca.o memory.o
+setup-y		+= pm.o pmjump.o printf.o regs.o string.o tty.o video.o
+setup-y		+= video-mode.o version.o
 setup-$(CONFIG_X86_APM_BOOT) += apm.o
 
 # The link order of the video-*.o modules can matter.  In particular,
Index: linux-2.6/arch/x86/boot/boot.h
===================================================================
--- linux-2.6.orig/arch/x86/boot/boot.h
+++ linux-2.6/arch/x86/boot/boot.h
@@ -200,21 +200,7 @@ static inline int memcmp_gs(const void *
 	return diff;
 }
 
-static inline int isdigit(int ch)
-{
-	return (ch >= '0') && (ch <= '9');
-}
-
-static inline int isxdigit(int ch)
-{
-	if (isdigit(ch))
-		return true;
-
-	if ((ch >= 'a') && (ch <= 'f'))
-		return true;
-
-	return (ch >= 'A') && (ch <= 'F');
-}
+#include "isdigit.h"
 
 /* Heap -- available for dynamic lists. */
 extern char _end[];
@@ -300,8 +286,18 @@ struct biosregs {
 void intcall(u8 int_no, const struct biosregs *ireg, struct biosregs *oreg);
 
 /* cmdline.c */
-int cmdline_find_option(const char *option, char *buffer, int bufsize);
-int cmdline_find_option_bool(const char *option);
+int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int bufsize);
+int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option);
+static inline int cmdline_find_option(const char *option, char *buffer, int bufsize)
+{
+	return __cmdline_find_option(boot_params.hdr.cmd_line_ptr, option, buffer, bufsize);
+}
+
+static inline int cmdline_find_option_bool(const char *option)
+{
+	return __cmdline_find_option_bool(boot_params.hdr.cmd_line_ptr, option);
+}
+
 
 /* cpu.c, cpucheck.c */
 struct cpu_features {
@@ -313,6 +309,10 @@ extern struct cpu_features cpu;
 int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr);
 int validate_cpu(void);
 
+/* early_serial_console.c */
+extern int early_serial_base;
+void console_init(void);
+
 /* edd.c */
 void query_edd(void);
 
@@ -348,7 +348,6 @@ unsigned int atou(const char *s);
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
 
 /* tty.c */
-void console_init(void);
 void puts(const char *);
 void putchar(int);
 int getchar(void);
Index: linux-2.6/arch/x86/boot/isdigit.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/boot/isdigit.h
@@ -0,0 +1,21 @@
+#ifndef BOOT_ISDIGIT_H
+
+#define BOOT_ISDIGIT_H
+
+static inline int isdigit(int ch)
+{
+	return (ch >= '0') && (ch <= '9');
+}
+
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
+#endif
