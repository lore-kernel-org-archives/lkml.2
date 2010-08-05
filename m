Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453Ab0HEUdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:33:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:56280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934221Ab0HEUdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:33:16 -0400
Date: Thu, 5 Aug 2010 20:31:28 GMT
Message-Id: <201008052031.o75KVS8T017124@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/setup for 2.6.36
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 20:31:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cdd854bc42b5e6c79bbbc40c6600d995ffe6e747:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-08-05 09:03:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-setup-for-linus

H. Peter Anvin (2):
      x86, setup: Allow global variables and functions in the decompressor
      x86, setup: move isdigit.h to ctype.h, header files on top.

Pekka Enberg (1):
      x86, setup: Early-boot serial I/O support

Yinghai Lu (4):
      x86, setup: Make the setup code also accept console=uart8250
      x86, setup: Only set early_serial_base after port is initialized
      x86, setup: reorganize the early console setup
      x86, setup: enable early console output from the decompressor

 arch/x86/boot/Makefile                          |    8 +-
 arch/x86/boot/boot.h                            |   28 ++++-
 arch/x86/boot/cmdline.c                         |    6 +-
 arch/x86/boot/compressed/Makefile               |    4 +-
 arch/x86/boot/compressed/cmdline.c              |   21 ++++
 arch/x86/boot/compressed/early_serial_console.c |    5 +
 arch/x86/boot/compressed/head_32.S              |   13 ++
 arch/x86/boot/compressed/head_64.S              |   13 ++
 arch/x86/boot/compressed/misc.c                 |   56 ++++++----
 arch/x86/boot/compressed/misc.h                 |   39 +++++++
 arch/x86/boot/compressed/string.c               |    2 +
 arch/x86/boot/compressed/vmlinux.lds.S          |    6 +
 arch/x86/boot/ctype.h                           |   21 ++++
 arch/x86/boot/early_serial_console.c            |  139 +++++++++++++++++++++++
 arch/x86/boot/main.c                            |    9 +-
 arch/x86/boot/printf.c                          |    4 +-
 arch/x86/boot/string.c                          |   63 ++++++++++
 arch/x86/boot/tty.c                             |   37 +++++-
 18 files changed, 422 insertions(+), 52 deletions(-)
 create mode 100644 arch/x86/boot/compressed/cmdline.c
 create mode 100644 arch/x86/boot/compressed/early_serial_console.c
 create mode 100644 arch/x86/boot/compressed/misc.h
 create mode 100644 arch/x86/boot/compressed/string.c
 create mode 100644 arch/x86/boot/ctype.h
 create mode 100644 arch/x86/boot/early_serial_console.c

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index ec749c2..f7cb086 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -26,10 +26,10 @@ targets		:= vmlinux.bin setup.bin setup.elf bzImage
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
diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 98239d2..c7093bd 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -28,6 +28,7 @@
 #include "bitops.h"
 #include <asm/cpufeature.h>
 #include <asm/processor-flags.h>
+#include "ctype.h"
 
 /* Useful macros */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
@@ -37,6 +38,8 @@
 extern struct setup_header hdr;
 extern struct boot_params boot_params;
 
+#define cpu_relax()	asm volatile("rep; nop")
+
 /* Basic port I/O */
 static inline void outb(u8 v, u16 port)
 {
@@ -198,11 +201,6 @@ static inline int memcmp_gs(const void *s1, addr_t s2, size_t len)
 	return diff;
 }
 
-static inline int isdigit(int ch)
-{
-	return (ch >= '0') && (ch <= '9');
-}
-
 /* Heap -- available for dynamic lists. */
 extern char _end[];
 extern char *HEAP;
@@ -287,8 +285,18 @@ struct biosregs {
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
@@ -300,6 +308,10 @@ extern struct cpu_features cpu;
 int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr);
 int validate_cpu(void);
 
+/* early_serial_console.c */
+extern int early_serial_base;
+void console_init(void);
+
 /* edd.c */
 void query_edd(void);
 
@@ -329,8 +341,10 @@ void initregs(struct biosregs *regs);
 
 /* string.c */
 int strcmp(const char *str1, const char *str2);
+int strncmp(const char *cs, const char *ct, size_t count);
 size_t strnlen(const char *s, size_t maxlen);
 unsigned int atou(const char *s);
+unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
 
 /* tty.c */
 void puts(const char *);
diff --git a/arch/x86/boot/cmdline.c b/arch/x86/boot/cmdline.c
index a1d3563..6b3b6f7 100644
--- a/arch/x86/boot/cmdline.c
+++ b/arch/x86/boot/cmdline.c
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
@@ -100,9 +99,8 @@ int cmdline_find_option(const char *option, char *buffer, int bufsize)
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
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index fbb47da..0c22955 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.lzo head_$(BITS).o misc.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -23,7 +23,7 @@ LDFLAGS_vmlinux := -T
 
 hostprogs-y	:= mkpiggy
 
-$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o $(obj)/piggy.o FORCE
+$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o $(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o $(obj)/piggy.o FORCE
 	$(call if_changed,ld)
 	@:
 
diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
new file mode 100644
index 0000000..cb62f78
--- /dev/null
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -0,0 +1,21 @@
+#include "misc.h"
+
+static unsigned long fs;
+static inline void set_fs(unsigned long seg)
+{
+	fs = seg << 4;  /* shift it back */
+}
+typedef unsigned long addr_t;
+static inline char rdfs8(addr_t addr)
+{
+	return *((char *)(fs + addr));
+}
+#include "../cmdline.c"
+int cmdline_find_option(const char *option, char *buffer, int bufsize)
+{
+	return __cmdline_find_option(real_mode->hdr.cmd_line_ptr, option, buffer, bufsize);
+}
+int cmdline_find_option_bool(const char *option)
+{
+	return __cmdline_find_option_bool(real_mode->hdr.cmd_line_ptr, option);
+}
diff --git a/arch/x86/boot/compressed/early_serial_console.c b/arch/x86/boot/compressed/early_serial_console.c
new file mode 100644
index 0000000..261e81f
--- /dev/null
+++ b/arch/x86/boot/compressed/early_serial_console.c
@@ -0,0 +1,5 @@
+#include "misc.h"
+
+int early_serial_base;
+
+#include "../early_serial_console.c"
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index f543b70..67a655a 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -124,6 +124,19 @@ relocated:
 	rep	stosl
 
 /*
+ * Adjust our own GOT
+ */
+	leal	_got(%ebx), %edx
+	leal	_egot(%ebx), %ecx
+1:
+	cmpl	%ecx, %edx
+	jae	2f
+	addl	%ebx, (%edx)
+	addl	$4, %edx
+	jmp	1b
+2:
+
+/*
  * Do the decompression, and jump to the new kernel..
  */
 	leal	z_extract_offset_negative(%ebx), %ebp
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index faff0dc..52f85a1 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -280,6 +280,19 @@ relocated:
 	rep	stosq
 
 /*
+ * Adjust our own GOT
+ */
+	leaq	_got(%rip), %rdx
+	leaq	_egot(%rip), %rcx
+1:
+	cmpq	%rcx, %rdx
+	jae	2f
+	addq	%rbx, (%rdx)
+	addq	$8, %rdx
+	jmp	1b
+2:
+	
+/*
  * Do the decompression, and jump to the new kernel..
  */
 	pushq	%rsi			/* Save the real mode argument */
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 51e2407..8f7bef8 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -9,23 +9,7 @@
  * High loaded stuff by Hans Lermen & Werner Almesberger, Feb. 1996
  */
 
-/*
- * we have to be careful, because no indirections are allowed here, and
- * paravirt_ops is a kind of one. As it will only run in baremetal anyway,
- * we just keep it from happening
- */
-#undef CONFIG_PARAVIRT
-#ifdef CONFIG_X86_32
-#define _ASM_X86_DESC_H 1
-#endif
-
-#include <linux/linkage.h>
-#include <linux/screen_info.h>
-#include <linux/elf.h>
-#include <linux/io.h>
-#include <asm/page.h>
-#include <asm/boot.h>
-#include <asm/bootparam.h>
+#include "misc.h"
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
@@ -123,15 +107,13 @@ static void error(char *m);
 /*
  * This is set up by the setup-routine at boot-time
  */
-static struct boot_params *real_mode;		/* Pointer to real-mode data */
+struct boot_params *real_mode;		/* Pointer to real-mode data */
 static int quiet;
+static int debug;
 
 void *memset(void *s, int c, size_t n);
 void *memcpy(void *dest, const void *src, size_t n);
 
-static void __putstr(int, const char *);
-#define putstr(__x)  __putstr(0, __x)
-
 #ifdef CONFIG_X86_64
 #define memptr long
 #else
@@ -170,7 +152,21 @@ static void scroll(void)
 		vidmem[i] = ' ';
 }
 
-static void __putstr(int error, const char *s)
+#define XMTRDY          0x20
+
+#define TXR             0       /*  Transmit register (WRITE) */
+#define LSR             5       /*  Line Status               */
+static void serial_putchar(int ch)
+{
+	unsigned timeout = 0xffff;
+
+	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
+		cpu_relax();
+
+	outb(ch, early_serial_base + TXR);
+}
+
+void __putstr(int error, const char *s)
 {
 	int x, y, pos;
 	char c;
@@ -179,6 +175,14 @@ static void __putstr(int error, const char *s)
 	if (!error)
 		return;
 #endif
+	if (early_serial_base) {
+		const char *str = s;
+		while (*str) {
+			if (*str == '\n')
+				serial_putchar('\r');
+			serial_putchar(*str++);
+		}
+	}
 
 	if (real_mode->screen_info.orig_video_mode == 0 &&
 	    lines == 0 && cols == 0)
@@ -305,8 +309,10 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 {
 	real_mode = rmode;
 
-	if (real_mode->hdr.loadflags & QUIET_FLAG)
+	if (cmdline_find_option_bool("quiet"))
 		quiet = 1;
+	if (cmdline_find_option_bool("debug"))
+		debug = 1;
 
 	if (real_mode->screen_info.orig_video_mode == 7) {
 		vidmem = (char *) 0xb0000;
@@ -319,6 +325,10 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	lines = real_mode->screen_info.orig_video_lines;
 	cols = real_mode->screen_info.orig_video_cols;
 
+	console_init();
+	if (debug)
+		putstr("early console in decompress_kernel\n");
+
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
new file mode 100644
index 0000000..3f19c81
--- /dev/null
+++ b/arch/x86/boot/compressed/misc.h
@@ -0,0 +1,39 @@
+#ifndef BOOT_COMPRESSED_MISC_H
+#define BOOT_COMPRESSED_MISC_H
+
+/*
+ * we have to be careful, because no indirections are allowed here, and
+ * paravirt_ops is a kind of one. As it will only run in baremetal anyway,
+ * we just keep it from happening
+ */
+#undef CONFIG_PARAVIRT
+#ifdef CONFIG_X86_32
+#define _ASM_X86_DESC_H 1
+#endif
+
+#include <linux/linkage.h>
+#include <linux/screen_info.h>
+#include <linux/elf.h>
+#include <linux/io.h>
+#include <asm/page.h>
+#include <asm/boot.h>
+#include <asm/bootparam.h>
+
+#define BOOT_BOOT_H
+#include "../ctype.h"
+
+/* misc.c */
+extern struct boot_params *real_mode;		/* Pointer to real-mode data */
+void __putstr(int error, const char *s);
+#define putstr(__x)  __putstr(0, __x)
+#define puts(__x)  __putstr(0, __x)
+
+/* cmdline.c */
+int cmdline_find_option(const char *option, char *buffer, int bufsize);
+int cmdline_find_option_bool(const char *option);
+
+/* early_serial_console.c */
+extern int early_serial_base;
+void console_init(void);
+
+#endif
diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
new file mode 100644
index 0000000..19b3e69
--- /dev/null
+++ b/arch/x86/boot/compressed/string.c
@@ -0,0 +1,2 @@
+#include "misc.h"
+#include "../string.c"
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index 5ddabce..34d047c 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -41,6 +41,12 @@ SECTIONS
 		*(.rodata.*)
 		_erodata = . ;
 	}
+	.got : {
+		_got = .;
+		KEEP(*(.got.plt))
+		KEEP(*(.got))
+		_egot = .;
+	}
 	.data :	{
 		_data = . ;
 		*(.data)
diff --git a/arch/x86/boot/ctype.h b/arch/x86/boot/ctype.h
new file mode 100644
index 0000000..25e1340
--- /dev/null
+++ b/arch/x86/boot/ctype.h
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
diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
new file mode 100644
index 0000000..030f4b9
--- /dev/null
+++ b/arch/x86/boot/early_serial_console.c
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
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 140172b..40358c8 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -130,6 +130,11 @@ void main(void)
 	/* First, copy the boot header into the "zeropage" */
 	copy_boot_params();
 
+	/* Initialize the early-boot console */
+	console_init();
+	if (cmdline_find_option_bool("debug"))
+		puts("early console in setup code\n");
+
 	/* End of heap check */
 	init_heap();
 
@@ -168,10 +173,6 @@ void main(void)
 	/* Set the video mode */
 	set_video();
 
-	/* Parse command line for 'quiet' and pass it to decompressor. */
-	if (cmdline_find_option_bool("quiet"))
-		boot_params.hdr.loadflags |= QUIET_FLAG;
-
 	/* Do the last things and invoke protected mode */
 	go_to_protected_mode();
 }
diff --git a/arch/x86/boot/printf.c b/arch/x86/boot/printf.c
index 50e47cd..cdac91c 100644
--- a/arch/x86/boot/printf.c
+++ b/arch/x86/boot/printf.c
@@ -34,7 +34,7 @@ static int skip_atoi(const char **s)
 #define SMALL	32		/* Must be 32 == 0x20 */
 #define SPECIAL	64		/* 0x */
 
-#define do_div(n,base) ({ \
+#define __do_div(n, base) ({ \
 int __res; \
 __res = ((unsigned long) n) % (unsigned) base; \
 n = ((unsigned long) n) / (unsigned) base; \
@@ -83,7 +83,7 @@ static char *number(char *str, long num, int base, int size, int precision,
 		tmp[i++] = '0';
 	else
 		while (num != 0)
-			tmp[i++] = (digits[do_div(num, base)] | locase);
+			tmp[i++] = (digits[__do_div(num, base)] | locase);
 	if (i > precision)
 		precision = i;
 	size -= precision;
diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index f94b7a0..3cbc405 100644
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
@@ -48,3 +64,50 @@ unsigned int atou(const char *s)
 		i = i * 10 + (*s++ - '0');
 	return i;
 }
+
+/* Works only for digits and letters, but small and fast */
+#define TOLOWER(x) ((x) | 0x20)
+
+static unsigned int simple_guess_base(const char *cp)
+{
+	if (cp[0] == '0') {
+		if (TOLOWER(cp[1]) == 'x' && isxdigit(cp[2]))
+			return 16;
+		else
+			return 8;
+	} else {
+		return 10;
+	}
+}
+
+/**
+ * simple_strtoull - convert a string to an unsigned long long
+ * @cp: The start of the string
+ * @endp: A pointer to the end of the parsed string will be placed here
+ * @base: The number base to use
+ */
+
+unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
+{
+	unsigned long long result = 0;
+
+	if (!base)
+		base = simple_guess_base(cp);
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
index 01ec69c..def2451 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -10,23 +10,36 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * Very simple screen I/O
- * XXX: Probably should add very simple serial I/O?
+ * Very simple screen and serial I/O
  */
 
 #include "boot.h"
 
+int early_serial_base;
+
+#define XMTRDY          0x20
+
+#define TXR             0       /*  Transmit register (WRITE) */
+#define LSR             5       /*  Line Status               */
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
@@ -36,6 +49,17 @@ void __attribute__((section(".inittext"))) putchar(int ch)
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
@@ -112,3 +136,4 @@ int getchar_timeout(void)
 
 	return 0;		/* Timeout! */
 }
+
