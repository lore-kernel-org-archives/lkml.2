Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0HBTYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:24:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32858 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab0HBTYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:24:11 -0400
Message-ID: <4C571B25.3080806@kernel.org>
Date: Mon, 02 Aug 2010 12:23:17 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, setup: reorgize the early_console_setup
References: <4C56701B.1030000@kernel.org> <20100802150958.GA5544@lenovo>
In-Reply-To: <20100802150958.GA5544@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C571B2A.02B2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 08:09 AM, Cyrill Gorcunov wrote:
> On Mon, Aug 02, 2010 at 12:13:31AM -0700, Yinghai Lu wrote:
>>
>> Seperate early_console_setup from tty.c
>> also make main.c to include printf.c/string.c/cmdline.c
>>
>> will reuse early_serial_console.c/string.c/printf.c/cmdline.c in compressed/misc.c
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
> 
> Hi Yinghai, I'll try to find some time for review though it looks somehow
> too 'big' for me :)
> 
> Actually by reading your initial approach (which was much smaller in size) I
> thought we end up in something like the patch below, though I'll review this
> seris. So just to share (I've tested it under qemu). The idea is the same as
> your was, so I pushed all constant parts into header and use it when needed
> passing serial line base port via boot_params.

Eric doesn't like early_serial_console_base in zero page. and said that is fragile.

So try to include string.c/printf.c/cmdline.c/early_serial_console.c in arch/x86/boot/compressed/misc.c
and analyze that command line again.

then kexec path will get support too. that is from arch/x86/boot/compressed/head_32.S or head_64.S, startup_32.
and skip arch/x86/boot/main.c

later with following patch for 3, we get all covered in c code.
1. arch/x86/boot/main.c: setup code.
2. arch/x86/boot/compressed/misc.c: decompress_kernel code : the 2 -v3 patches that i sent last night.
3. arch/x86/kernel/head64.c: real kernel.

maybe we can make early_serial_console.c and early_printk.c to share some .h etc later.

Thanks

Yinghai

[PATCH -v2] x86: Setup early console as early as possible

Analyze "console=uart8250,io,0x3f8,115200n8" in i386_start_kernel/x86_64_start_kernel,
and call setup_early_serial8250_console() to init early serial console.

only can handle io port kind of 8250. because mmio need ioremap.

-v2: use boot_params.hdr.version instead of adding another variable, Suggested by hpa
     update after using x86 memblock patchset

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/setup.h |    2 ++
 arch/x86/kernel/head.c       |   27 +++++++++++++++++++++++++++
 arch/x86/kernel/head32.c     |    2 ++
 arch/x86/kernel/head64.c     |   13 +++++++++++--
 kernel/printk.c              |    4 ++++
 5 files changed, 46 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -42,6 +42,8 @@ static inline void visws_early_detect(vo
 #endif
 
 extern unsigned long saved_video_mode;
+int setup_early_serial8250_console(char *cmdline);
+void setup_early_console(void);
 
 extern void reserve_standard_io_resources(void);
 extern void i386_reserve_resources(void);
Index: linux-2.6/arch/x86/kernel/head.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head.c
+++ linux-2.6/arch/x86/kernel/head.c
@@ -54,3 +54,30 @@ void __init reserve_ebda_region(void)
 	/* reserve all memory between lowmem and the 1MB mark */
 	memblock_x86_reserve_range(lowmem, 0x100000, "* BIOS reserved");
 }
+
+
+void __init setup_early_console(void)
+{
+#ifdef CONFIG_SERIAL_8250_CONSOLE
+	char constr[64], *p, *q;
+
+	/* Can not handle mmio type 8250 uart yet, too early */
+	p = strstr(boot_command_line, "console=uart8250,io,");
+	if (!p)
+		p = strstr(boot_command_line, "console=uart,io,");
+	if (!p)
+		return;
+
+	p += 8;	/* sizeof "console=" */
+	q = strchr(p, ' ');
+	if ((q - p) >= sizeof(constr))
+		return;
+
+	memset(constr, 0, sizeof(constr));
+	memcpy(constr, p, q - p);
+
+	lockdep_init();
+
+	setup_early_serial8250_console(constr);
+#endif
+}
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -31,6 +31,8 @@ static void __init i386_default_early_se
 
 void __init i386_start_kernel(void)
 {
+	setup_early_console();
+
 	memblock_init();
 
 #ifdef CONFIG_X86_TRAMPOLINE
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -46,6 +46,10 @@ static void __init copy_bootdata(char *r
 {
 	char * command_line;
 
+	/* make sure if it is copied already */
+	if (boot_params.hdr.version)
+		return;
+
 	memcpy(&boot_params, real_mode_data, sizeof boot_params);
 	if (boot_params.hdr.cmd_line_ptr) {
 		command_line = __va(boot_params.hdr.cmd_line_ptr);
@@ -74,6 +78,10 @@ void __init x86_64_start_kernel(char * r
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
+	/* boot_params is in bss */
+	copy_bootdata(__va(real_mode_data));
+	setup_early_console();
+
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
@@ -97,9 +105,10 @@ void __init x86_64_start_kernel(char * r
 
 void __init x86_64_start_reservations(char *real_mode_data)
 {
-	memblock_init();
-
 	copy_bootdata(__va(real_mode_data));
+	setup_early_console();
+
+	memblock_init();
 
 	memblock_x86_reserve_range(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -1204,6 +1204,10 @@ void register_console(struct console *ne
 	if (console_drivers && newcon->flags & CON_BOOT) {
 		/* find the last or real console */
 		for_each_console(bcon) {
+			/* not again */
+			if (bcon == newcon)
+				return;
+
 			if (!(bcon->flags & CON_BOOT)) {
 				printk(KERN_INFO "Too late to register bootconsole %s%d\n",
 					newcon->name, newcon->index);
