Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab0HCHRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:17:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36991 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab0HCHRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:17:16 -0400
Message-ID: <4C57C1DE.9050400@kernel.org>
Date: Tue, 03 Aug 2010 00:14:38 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v3] x86: Setup early console as early as possible
References: <4C56701B.1030000@kernel.org> <20100802150958.GA5544@lenovo> <4C571B25.3080806@kernel.org> <20100802201750.GG5544@lenovo>
In-Reply-To: <20100802201750.GG5544@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C57C22E.027C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Analyze "console=uart8250,io,0x3f8,115200n8" in i386_start_kernel/x86_64_start_kernel,
and call setup_early_serial8250_console() to init early serial console.

only can handle io port kind of 8250. because mmio need ioremap.

-v2: use boot_params.hdr.version instead of adding another variable, Suggested by hpa
     update after using x86 memblock patchset
-v3: x86 memblock can not make into with 2.6.36 now
     so update this patch to be applied before x86 memblock patchset again.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/setup.h |    2 ++
 arch/x86/kernel/head.c       |   26 ++++++++++++++++++++++++++
 arch/x86/kernel/head32.c     |    2 ++
 arch/x86/kernel/head64.c     |   13 ++++++++++++-
 kernel/printk.c              |    4 ++++
 5 files changed, 46 insertions(+), 1 deletion(-)

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
@@ -53,3 +53,29 @@ void __init reserve_ebda_region(void)
 	/* reserve all memory between lowmem and the 1MB mark */
 	reserve_early_overlap_ok(lowmem, 0x100000, "BIOS reserved");
 }
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
@@ -30,6 +30,8 @@ static void __init i386_default_early_se
 
 void __init i386_start_kernel(void)
 {
+	setup_early_console();
+
 #ifdef CONFIG_X86_TRAMPOLINE
 	/*
 	 * But first pinch a few for the stack/trampoline stuff
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -73,6 +73,10 @@ void __init x86_64_start_kernel(char * r
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
+	/* boot_params is in bss */
+	copy_bootdata(__va(real_mode_data));
+	setup_early_console();
+
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
@@ -96,7 +100,14 @@ void __init x86_64_start_kernel(char * r
 
 void __init x86_64_start_reservations(char *real_mode_data)
 {
-	copy_bootdata(__va(real_mode_data));
+	/*
+	 * hdr.version is always not 0, so check it to see
+	 *  if boot_params is copied or not.
+	 */
+	if (!boot_params.hdr.version) {
+		copy_bootdata(__va(real_mode_data));
+		setup_early_console();
+	}
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -1203,6 +1203,10 @@ void register_console(struct console *ne
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
