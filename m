Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0HBPKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:10:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59949 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0HBPKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RXIx/Jg+Q/58Jg+adqz8Pjmw+JJwNL4ocnAl4bsBbANWKNhZwKmoFdlJ17944aZjW0
         wsg6h68YLf26mOtqkh0xFTQ9okFA61LtnG3/FDTM5bY6FV1183xjm0abgerEOXoYL4Ku
         vZPvD9I4xNcdbLjaN9I2VG3xxqjEWY8vuFy50=
Date: Mon, 2 Aug 2010 19:09:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, setup: reorgize the early_console_setup
Message-ID: <20100802150958.GA5544@lenovo>
References: <4C56701B.1030000@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C56701B.1030000@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 12:13:31AM -0700, Yinghai Lu wrote:
> 
> Seperate early_console_setup from tty.c
> also make main.c to include printf.c/string.c/cmdline.c
> 
> will reuse early_serial_console.c/string.c/printf.c/cmdline.c in compressed/misc.c
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---

Hi Yinghai, I'll try to find some time for review though it looks somehow
too 'big' for me :)

Actually by reading your initial approach (which was much smaller in size) I
thought we end up in something like the patch below, though I'll review this
seris. So just to share (I've tested it under qemu). The idea is the same as
your was, so I pushed all constant parts into header and use it when needed
passing serial line base port via boot_params.

---
 arch/x86/boot/boot.h             |    2 -
 arch/x86/boot/compressed/misc.c  |   18 +++++++++++++
 arch/x86/boot/main.c             |    2 -
 arch/x86/boot/tty.c              |   51 ++++++++++-----------------------------
 arch/x86/boot/tty.h              |   45 ++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/bootparam.h |    2 -
 arch/x86/kernel/early_printk.c   |   36 +++------------------------
 7 files changed, 85 insertions(+), 71 deletions(-)

Index: linux-2.6.git/arch/x86/boot/boot.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/boot/boot.h
+++ linux-2.6.git/arch/x86/boot/boot.h
@@ -348,7 +348,7 @@ unsigned int atou(const char *s);
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
 
 /* tty.c */
-void console_init(void);
+void console_init(struct boot_params *boot_params);
 void puts(const char *);
 void putchar(int);
 int getchar(void);
Index: linux-2.6.git/arch/x86/boot/compressed/misc.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/boot/compressed/misc.c
+++ linux-2.6.git/arch/x86/boot/compressed/misc.c
@@ -27,6 +27,8 @@
 #include <asm/boot.h>
 #include <asm/bootparam.h>
 
+#include "../tty.h"
+
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
  * at run time, but no relocation processing is performed.
@@ -180,6 +182,21 @@ static void __putstr(int error, const ch
 		return;
 #endif
 
+	/*
+	 * write to  early serial console first
+	 * then we may write to video memory
+	 */
+	if (real_mode->early_serial_base) {
+		int ch, base = real_mode->early_serial_base;
+		const char *str = s;
+		while ((ch = *str++)) {
+			/* \n -> \r\n */
+			if (ch == '\n')
+				__serial_putchar('\r', base);
+			__serial_putchar(ch, base);
+		}
+	}
+
 	if (real_mode->screen_info.orig_video_mode == 0 &&
 	    lines == 0 && cols == 0)
 		return;
@@ -342,5 +359,6 @@ asmlinkage void decompress_kernel(void *
 	parse_elf(output);
 	if (!quiet)
 		putstr("done.\nBooting the kernel.\n");
+
 	return;
 }
Index: linux-2.6.git/arch/x86/boot/main.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/boot/main.c
+++ linux-2.6.git/arch/x86/boot/main.c
@@ -131,7 +131,7 @@ void main(void)
 	copy_boot_params();
 
 	/* Initialize the early-boot console */
-	console_init();
+	console_init(&boot_params);
 
 	/* End of heap check */
 	init_heap();
Index: linux-2.6.git/arch/x86/boot/tty.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/boot/tty.c
+++ linux-2.6.git/arch/x86/boot/tty.c
@@ -14,44 +14,15 @@
  */
 
 #include "boot.h"
+#include "tty.h"
 
-#define DEFAULT_SERIAL_PORT 0x3f8 /* ttyS0 */
-
-static int	early_serial_base;
-
-#define XMTRDY          0x20
-
-#define DLAB		0x80
-
-#define TXR             0       /*  Transmit register (WRITE) */
-#define RXR             0       /*  Receive register  (READ)  */
-#define IER             1       /*  Interrupt Enable          */
-#define IIR             2       /*  Interrupt ID              */
-#define FCR             2       /*  FIFO control              */
-#define LCR             3       /*  Line control              */
-#define MCR             4       /*  Modem control             */
-#define LSR             5       /*  Line Status               */
-#define MSR             6       /*  Modem Status              */
-#define DLL             0       /*  Divisor Latch Low         */
-#define DLH             1       /*  Divisor latch High        */
-
-#define DEFAULT_BAUD 9600
+static int early_serial_base;
 
 /*
  * These functions are in .inittext so they can be used to signal
  * error during initialization.
  */
 
-static void __attribute__((section(".inittext"))) serial_putchar(int ch)
-{
-	unsigned timeout = 0xffff;
-
-	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
-		cpu_relax();
-
-	outb(ch, early_serial_base + TXR);
-}
-
 static void __attribute__((section(".inittext"))) bios_putchar(int ch)
 {
 	struct biosregs ireg;
@@ -66,13 +37,14 @@ static void __attribute__((section(".ini
 
 void __attribute__((section(".inittext"))) putchar(int ch)
 {
+	/* \n -> \r\n */
 	if (ch == '\n')
-		putchar('\r');	/* \n -> \r\n */
+		putchar('\r');
 
 	bios_putchar(ch);
 
-	if (early_serial_base != 0)
-		serial_putchar(ch);
+	if (early_serial_base)
+		__serial_putchar(ch, early_serial_base);
 }
 
 void __attribute__((section(".inittext"))) puts(const char *str)
@@ -193,7 +165,10 @@ static void parse_earlyprintk(void)
 			pos++;
 
 		if (!strncmp(arg, "ttyS", 4)) {
-			static const int bases[] = { 0x3f8, 0x2f8 };
+			static const int bases[] = {
+				SERIAL_PORT_TTYS0,
+				SERIAL_PORT_TTYS1,
+			};
 			int idx = 0;
 
 			if (!strncmp(arg + pos, "ttyS", 4))
@@ -217,7 +192,6 @@ static void parse_earlyprintk(void)
 		early_serial_init(port, baud);
 }
 
-#define BASE_BAUD (1843200/16)
 static unsigned int probe_baud(int port)
 {
 	unsigned char lcr, dll, dlh;
@@ -264,10 +238,13 @@ static void parse_console_uart8250(void)
 		early_serial_init(port, baud);
 }
 
-void console_init(void)
+void console_init(struct boot_params *boot_params)
 {
 	parse_earlyprintk();
 
 	if (!early_serial_base)
 		parse_console_uart8250();
+
+	if (early_serial_base)
+		boot_params->early_serial_base = early_serial_base;
 }
Index: linux-2.6.git/arch/x86/boot/tty.h
=====================================================================
--- /dev/null
+++ linux-2.6.git/arch/x86/boot/tty.h
@@ -0,0 +1,45 @@
+#ifndef BOOT_TTY_H
+#define BOOT_TTY_H
+
+#include <linux/compiler.h>
+#include <asm/boot.h>
+
+#define SERIAL_PORT_TTYS0	0x3f8
+#define SERIAL_PORT_TTYS1	0x2f8
+
+#define DEFAULT_SERIAL_PORT	SERIAL_PORT_TTYS0
+
+#define XMTRDY		0x20
+#define DLAB		0x80
+
+#define TXR	0	/* Transmit register (WRITE)	*/
+#define RXR	0	/* Receive register  (READ)	*/
+#define IER	1	/* Interrupt Enable		*/
+#define IIR	2	/* Interrupt ID			*/
+#define FCR	2	/* FIFO control			*/
+#define LCR	3	/* Line control			*/
+#define MCR	4	/* Modem control		*/
+#define LSR	5	/* Line Status			*/
+#define MSR	6	/* Modem Status			*/
+#define DLL	0	/* Divisor Latch Low		*/
+#define DLH	1	/* Divisor latch High		*/
+
+#define DEFAULT_BAUD	9600
+#define BASE_BAUD	(1843200 / 16)
+
+/*
+ * wait for serial line being ready to transmit data
+ * and write out a character then
+ */
+static __always_inline int __serial_putchar(int ch, int base)
+{
+	unsigned int timeout = 0xffff;
+
+	while ((inb(base + LSR) & XMTRDY) == 0 && --timeout)
+		cpu_relax();
+
+	outb(ch, base + TXR);
+	return timeout ? 0 : -1;
+}
+
+#endif /* BOOT_TTY_H */
Index: linux-2.6.git/arch/x86/include/asm/bootparam.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/bootparam.h
+++ linux-2.6.git/arch/x86/include/asm/bootparam.h
@@ -93,7 +93,7 @@ struct efi_info {
 struct boot_params {
 	struct screen_info screen_info;			/* 0x000 */
 	struct apm_bios_info apm_bios_info;		/* 0x040 */
-	__u8  _pad2[4];					/* 0x054 */
+	__u32 early_serial_base;			/* 0x054 */
 	__u64  tboot_addr;				/* 0x058 */
 	struct ist_info ist_info;			/* 0x060 */
 	__u8  _pad3[16];				/* 0x070 */
Index: linux-2.6.git/arch/x86/kernel/early_printk.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/early_printk.c
+++ linux-2.6.git/arch/x86/kernel/early_printk.c
@@ -17,6 +17,8 @@
 #include <asm/pgtable.h>
 #include <linux/usb/ehci_def.h>
 
+#include "../boot/tty.h"
+
 /* Simple VGA output */
 #define VGABASE		(__ISA_IO_base + 0xb8000)
 
@@ -73,46 +75,18 @@ static struct console early_vga_console 
 
 /* Serial functions loosely based on a similar package from Klaus P. Gerlicher */
 
-static int early_serial_base = 0x3f8;  /* ttyS0 */
-
-#define XMTRDY          0x20
-
-#define DLAB		0x80
-
-#define TXR             0       /*  Transmit register (WRITE) */
-#define RXR             0       /*  Receive register  (READ)  */
-#define IER             1       /*  Interrupt Enable          */
-#define IIR             2       /*  Interrupt ID              */
-#define FCR             2       /*  FIFO control              */
-#define LCR             3       /*  Line control              */
-#define MCR             4       /*  Modem control             */
-#define LSR             5       /*  Line Status               */
-#define MSR             6       /*  Modem Status              */
-#define DLL             0       /*  Divisor Latch Low         */
-#define DLH             1       /*  Divisor latch High        */
-
-static int early_serial_putc(unsigned char ch)
-{
-	unsigned timeout = 0xffff;
-
-	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
-		cpu_relax();
-	outb(ch, early_serial_base + TXR);
-	return timeout ? 0 : -1;
-}
+static int early_serial_base = DEFAULT_SERIAL_PORT;
 
 static void early_serial_write(struct console *con, const char *s, unsigned n)
 {
 	while (*s && n-- > 0) {
 		if (*s == '\n')
-			early_serial_putc('\r');
-		early_serial_putc(*s);
+			__serial_putchar('\r', early_serial_base);
+		__serial_putchar(*s, early_serial_base);
 		s++;
 	}
 }
 
-#define DEFAULT_BAUD 9600
-
 static __init void early_serial_init(char *s)
 {
 	unsigned char c;
