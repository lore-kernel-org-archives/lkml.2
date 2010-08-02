Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0HBXWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:22:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49620 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab0HBXWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:22:20 -0400
Message-ID: <4C5752F2.8030206@kernel.org>
Date: Mon, 02 Aug 2010 16:21:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/2] x86: more early console output from	compressed/misc.c
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org> <4C568D6F.3050004@kernel.org> <20100802174916.GD5544@lenovo> <4C5710C1.8020809@zytor.com> <20100802185410.GE5544@lenovo> <4C57153F.7030107@zytor.com> <4C571DF2.5080100@kernel.org> <4C5731AF.9040009@zytor.com> <4C5733CF.20100@zytor.com> <4C57382E.8050501@zytor.com> <4C574700.1080000@kernel.org> <4C574AB6.5030403@zytor.com> <4C574BEE.7060802@kernel.org>
In-Reply-To: <4C574BEE.7060802@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C5752FE.01B5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 03:51 PM, Yinghai Lu wrote:
> 
> 
> On 08/02/2010 03:46 PM, H. Peter Anvin wrote:
>> First, I'm not quite sure which 1/2 patch you're expecting this to be
>> compiled against.
> 
> -v3
> 
>>
>> On 08/02/2010 03:30 PM, Yinghai Lu wrote:
>>>  
>>> +	if (debug) {
>>> +		putstr("decompress_kernel:\n");
>>> +		printf("  input: [0x%lx-0x%lx], output: 0x%lx, heap: [0x%lx-0x%lx]\n",
>>> +			 (unsigned long)input_data,
>>> +			 (unsigned long)input_data + input_len - 1,
>>> +			 (unsigned long)output,
>>> +			 (unsigned long)heap,
>>> +			 (unsigned long)heap + BOOT_HEAP_SIZE - 1);
>>> +	}
>>> +
>>
>> This seems to be the only user of printf() in the code.  As such, I
>> really suspect it's not worth pulling in all of printf().  I'd be
>> willing to be convinced, but if so I need (a) a concrete usage case, and
>> (b) it should be a separate patch.
> 
> ok, will drop printf.
> 

please check..

Subject: [PATCH -v5 2/2] x86: more early console output from compressed/misc.c

will get

|Decompressing Linux... Parsing ELF... done.
|Booting the kernel.

in serial console.

reuse code from arch/x86/boot/
and we can use printf if needed

-v2: define BOOT_BOOT_H to avoid include boot.h
-v3: early_serial_base need to be static in misc.c ?
-v4: create seperate string.c printf.c cmdline.c early_serial_console.c
     after hpa's patch that allow global variables in compressed/misc stage
-v5: remove printf.c related

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/compressed/Makefile               |    4 -
 arch/x86/boot/compressed/cmdline.c              |   21 +++++++++
 arch/x86/boot/compressed/early_serial_console.c |    5 ++
 arch/x86/boot/compressed/misc.c                 |   56 ++++++++++++++----------
 arch/x86/boot/compressed/misc.h                 |   38 ++++++++++++++++
 arch/x86/boot/compressed/string.c               |    4 +
 arch/x86/boot/main.c                            |    6 --
 7 files changed, 105 insertions(+), 29 deletions(-)

Index: linux-2.6/arch/x86/boot/compressed/misc.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/misc.c
+++ linux-2.6/arch/x86/boot/compressed/misc.c
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
@@ -179,6 +175,14 @@ static void __putstr(int error, const ch
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
@@ -305,8 +309,10 @@ asmlinkage void decompress_kernel(void *
 {
 	real_mode = rmode;
 
-	if (real_mode->hdr.loadflags & QUIET_FLAG)
+	if (cmdline_find_option_bool("quiet"))
 		quiet = 1;
+	if (cmdline_find_option_bool("debug"))
+		debug = 1;
 
 	if (real_mode->screen_info.orig_video_mode == 7) {
 		vidmem = (char *) 0xb0000;
@@ -319,6 +325,10 @@ asmlinkage void decompress_kernel(void *
 	lines = real_mode->screen_info.orig_video_lines;
 	cols = real_mode->screen_info.orig_video_cols;
 
+	console_init();
+	if (debug)
+		putstr("early console in decompress_kernel\n");
+
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
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
Index: linux-2.6/arch/x86/boot/compressed/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/Makefile
+++ linux-2.6/arch/x86/boot/compressed/Makefile
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
 
Index: linux-2.6/arch/x86/boot/compressed/cmdline.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/boot/compressed/cmdline.c
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
Index: linux-2.6/arch/x86/boot/compressed/early_serial_console.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/boot/compressed/early_serial_console.c
@@ -0,0 +1,5 @@
+#include "misc.h"
+
+int early_serial_base;
+
+#include "../early_serial_console.c"
Index: linux-2.6/arch/x86/boot/compressed/misc.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/boot/compressed/misc.h
@@ -0,0 +1,38 @@
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
Index: linux-2.6/arch/x86/boot/compressed/string.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/boot/compressed/string.c
@@ -0,0 +1,4 @@
+#include "misc.h"
+
+#include "../isdigit.h"
+#include "../string.c"
