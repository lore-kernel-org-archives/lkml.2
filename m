Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab2GYOfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:35:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35945 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148Ab2GYOfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:35:08 -0400
Date: Wed, 25 Jul 2012 16:35:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/boot changes for v3.6
Message-ID: <20120725143501.GA31090@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-boot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-boot-for-linus

   HEAD: c5e5c42a68be66cb87573e5c2fcce6f1b5d82bd5 x86, doc: Assign a bootloader ID for "Minimal Linux Bootloader"

Kernel image size reduction and assorted fixes and other small 
improvements.

 Thanks,

	Ingo

------------------>
Gokul Caushik (1):
      x86, boot: Exclude cmdline.c if you can't use it

H. Peter Anvin (1):
      x86, doc: Assign a bootloader ID for "Minimal Linux Bootloader"

Joe Millenbach (6):
      x86, boot: Removed quiet flag and switched quiet output to debug flag
      x86, boot: Wrap debug printing in a new debug_putstr function
      x86, boot: Changed error putstr path to match new debug_putstr format
      x86, boot: Switch output functions from command-line flags to conditional compilation
      x86, boot: Removed unused debug flag and set code
      x86, boot: Exclude early_serial_console.c if can't use it.


 Documentation/x86/boot.txt                      |    5 +++-
 arch/x86/boot/compressed/cmdline.c              |    4 +++
 arch/x86/boot/compressed/early_serial_console.c |    4 +++
 arch/x86/boot/compressed/misc.c                 |   31 ++++++-----------------
 arch/x86/boot/compressed/misc.h                 |   27 +++++++++++++++++---
 5 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 7c3a880..473b32f 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -363,7 +363,8 @@ Protocol:	2.00+
   ext_loader_type <- 0x05
   ext_loader_ver  <- 0x23
 
-  Assigned boot loader ids:
+  Assigned boot loader ids (hexadecimal):
+
 	0  LILO			(0x00 reserved for pre-2.00 bootloader)
 	1  Loadlin
 	2  bootsect-loader	(0x20, all other values reserved)
@@ -378,6 +379,8 @@ Protocol:	2.00+
 	C  Arcturus Networks uCbootloader
 	E  Extended		(see ext_loader_type)
 	F  Special		(0xFF = undefined)
+       10  Reserved
+       11  Minimal Linux Bootloader <http://sebastian-plotz.blogspot.de>
 
   Please contact <hpa@zytor.com> if you need a bootloader ID
   value assigned.
diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index cb62f78..10f6b11 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -1,5 +1,7 @@
 #include "misc.h"
 
+#ifdef CONFIG_EARLY_PRINTK
+
 static unsigned long fs;
 static inline void set_fs(unsigned long seg)
 {
@@ -19,3 +21,5 @@ int cmdline_find_option_bool(const char *option)
 {
 	return __cmdline_find_option_bool(real_mode->hdr.cmd_line_ptr, option);
 }
+
+#endif
diff --git a/arch/x86/boot/compressed/early_serial_console.c b/arch/x86/boot/compressed/early_serial_console.c
index 261e81f..d3d003c 100644
--- a/arch/x86/boot/compressed/early_serial_console.c
+++ b/arch/x86/boot/compressed/early_serial_console.c
@@ -1,5 +1,9 @@
 #include "misc.h"
 
+#ifdef CONFIG_EARLY_PRINTK
+
 int early_serial_base;
 
 #include "../early_serial_console.c"
+
+#endif
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 7116dcb..88f7ff6 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -108,8 +108,6 @@ static void error(char *m);
  * This is set up by the setup-routine at boot-time
  */
 struct boot_params *real_mode;		/* Pointer to real-mode data */
-static int quiet;
-static int debug;
 
 void *memset(void *s, int c, size_t n);
 void *memcpy(void *dest, const void *src, size_t n);
@@ -170,15 +168,11 @@ static void serial_putchar(int ch)
 	outb(ch, early_serial_base + TXR);
 }
 
-void __putstr(int error, const char *s)
+void __putstr(const char *s)
 {
 	int x, y, pos;
 	char c;
 
-#ifndef CONFIG_X86_VERBOSE_BOOTUP
-	if (!error)
-		return;
-#endif
 	if (early_serial_base) {
 		const char *str = s;
 		while (*str) {
@@ -265,9 +259,9 @@ void *memcpy(void *dest, const void *src, size_t n)
 
 static void error(char *x)
 {
-	__putstr(1, "\n\n");
-	__putstr(1, x);
-	__putstr(1, "\n\n -- System halted");
+	error_putstr("\n\n");
+	error_putstr(x);
+	error_putstr("\n\n -- System halted");
 
 	while (1)
 		asm("hlt");
@@ -294,8 +288,7 @@ static void parse_elf(void *output)
 		return;
 	}
 
-	if (!quiet)
-		putstr("Parsing ELF... ");
+	debug_putstr("Parsing ELF... ");
 
 	phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
 	if (!phdrs)
@@ -332,11 +325,6 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 {
 	real_mode = rmode;
 
-	if (cmdline_find_option_bool("quiet"))
-		quiet = 1;
-	if (cmdline_find_option_bool("debug"))
-		debug = 1;
-
 	if (real_mode->screen_info.orig_video_mode == 7) {
 		vidmem = (char *) 0xb0000;
 		vidport = 0x3b4;
@@ -349,8 +337,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	cols = real_mode->screen_info.orig_video_cols;
 
 	console_init();
-	if (debug)
-		putstr("early console in decompress_kernel\n");
+	debug_putstr("early console in decompress_kernel\n");
 
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
@@ -369,11 +356,9 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 		error("Wrong destination address");
 #endif
 
-	if (!quiet)
-		putstr("\nDecompressing Linux... ");
+	debug_putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
-	if (!quiet)
-		putstr("done.\nBooting the kernel.\n");
+	debug_putstr("done.\nBooting the kernel.\n");
 	return;
 }
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 3f19c81..0e6dc0e 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -24,9 +24,21 @@
 
 /* misc.c */
 extern struct boot_params *real_mode;		/* Pointer to real-mode data */
-void __putstr(int error, const char *s);
-#define putstr(__x)  __putstr(0, __x)
-#define puts(__x)  __putstr(0, __x)
+void __putstr(const char *s);
+#define error_putstr(__x)  __putstr(__x)
+
+#ifdef CONFIG_X86_VERBOSE_BOOTUP
+
+#define debug_putstr(__x)  __putstr(__x)
+
+#else
+
+static inline void debug_putstr(const char *s)
+{ }
+
+#endif
+
+#ifdef CONFIG_EARLY_PRINTK
 
 /* cmdline.c */
 int cmdline_find_option(const char *option, char *buffer, int bufsize);
@@ -36,4 +48,13 @@ int cmdline_find_option_bool(const char *option);
 extern int early_serial_base;
 void console_init(void);
 
+#else
+
+/* early_serial_console.c */
+static const int early_serial_base;
+static inline void console_init(void)
+{ }
+
+#endif
+
 #endif
