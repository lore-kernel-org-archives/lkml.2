Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab0HBJT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:19:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22094 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab0HBJT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:19:56 -0400
Message-ID: <4C568D6F.3050004@kernel.org>
Date: Mon, 02 Aug 2010 02:18:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v3 2/2] x86: more early console output from compressed/misc.c
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org>
In-Reply-To: <4C568D2B.205@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C568D89.0063,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


will get

|Decompressing Linux... Parsing ELF... done.
|Booting the kernel.

in serial console.

reuse code from arch/x86/boot/
and we can use printf if needed

-v2: define BOOT_BOOT_H to avoid include boot.h
-v3: early_serial_base need to be static in misc.c ?

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/compressed/misc.c |   65 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/boot/main.c            |    6 +--
 2 files changed, 66 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/boot/compressed/misc.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/misc.c
+++ linux-2.6/arch/x86/boot/compressed/misc.c
@@ -125,12 +125,14 @@ static void error(char *m);
  */
 static struct boot_params *real_mode;		/* Pointer to real-mode data */
 static int quiet;
+static int debug;
 
 void *memset(void *s, int c, size_t n);
 void *memcpy(void *dest, const void *src, size_t n);
 
 static void __putstr(int, const char *);
 #define putstr(__x)  __putstr(0, __x)
+#define puts(__x)  __putstr(0, __x)
 
 #ifdef CONFIG_X86_64
 #define memptr long
@@ -145,6 +147,11 @@ static char *vidmem;
 static int vidport;
 static int lines, cols;
 
+#define BOOT_BOOT_H
+#include "../isdigit.h"
+#include "../string.c"
+#include "../printf.c"
+
 #ifdef CONFIG_KERNEL_GZIP
 #include "../../../../lib/decompress_inflate.c"
 #endif
@@ -161,6 +168,28 @@ static int lines, cols;
 #include "../../../../lib/decompress_unlzo.c"
 #endif
 
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
+static inline int cmdline_find_option(const char *option, char *buffer, int bufsize)
+{
+	return __cmdline_find_option(real_mode->hdr.cmd_line_ptr, option, buffer, bufsize);
+}
+static inline int cmdline_find_option_bool(const char *option)
+{
+	return __cmdline_find_option_bool(real_mode->hdr.cmd_line_ptr, option);
+}
+static int early_serial_base;
+#include "../early_serial_console.c"
+
 static void scroll(void)
 {
 	int i;
@@ -170,6 +199,16 @@ static void scroll(void)
 		vidmem[i] = ' ';
 }
 
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
 static void __putstr(int error, const char *s)
 {
 	int x, y, pos;
@@ -179,6 +218,14 @@ static void __putstr(int error, const ch
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
@@ -305,8 +352,10 @@ asmlinkage void decompress_kernel(void *
 {
 	real_mode = rmode;
 
-	if (real_mode->hdr.loadflags & QUIET_FLAG)
+	if (cmdline_find_option_bool("quiet"))
 		quiet = 1;
+	if (cmdline_find_option_bool("debug"))
+		debug = 1;
 
 	if (real_mode->screen_info.orig_video_mode == 7) {
 		vidmem = (char *) 0xb0000;
@@ -319,9 +368,23 @@ asmlinkage void decompress_kernel(void *
 	lines = real_mode->screen_info.orig_video_lines;
 	cols = real_mode->screen_info.orig_video_cols;
 
+	console_init();
+	if (debug)
+		putstr("early console in decompress_kernel\n");
+
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
+	if (debug) {
+		putstr("decompress_kernel:\n");
+		printf("  input: [0x%lx-0x%lx], output: 0x%lx, heap: [0x%lx-0x%lx]\n",
+			 (unsigned long)input_data,
+			 (unsigned long)input_data + input_len - 1,
+			 (unsigned long)output,
+			 (unsigned long)heap,
+			 (unsigned long)heap + BOOT_HEAP_SIZE - 1);
+	}
+
 	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
 		error("Destination address inappropriately aligned");
 #ifdef CONFIG_X86_64
Index: linux-2.6/arch/x86/boot/main.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/main.c
+++ linux-2.6/arch/x86/boot/main.c
@@ -132,6 +132,8 @@ void main(void)
 
 	/* Initialize the early-boot console */
 	console_init();
+	if (cmdline_find_option_bool("debug"))
+		puts("early console in setup code\n");
 
 	/* End of heap check */
 	init_heap();
@@ -171,10 +173,6 @@ void main(void)
 	/* Set the video mode */
 	set_video();
 
-	/* Parse command line for 'quiet' and pass it to decompressor. */
-	if (cmdline_find_option_bool("quiet"))
-		boot_params.hdr.loadflags |= QUIET_FLAG;
-
 	/* Do the last things and invoke protected mode */
 	go_to_protected_mode();
 }
