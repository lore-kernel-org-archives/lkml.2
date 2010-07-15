Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934911Ab0GOWbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 18:31:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53522 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934838Ab0GOWbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 18:31:34 -0400
Message-ID: <4C3F8B46.7080809@kernel.org>
Date: Thu, 15 Jul 2010 15:27:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86,setup: add serial_console_port_base in boot_params
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C3F8C11.003D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


to save the early_serial_base.

Also bootloader could fill that field, so setup code could reuse it.

decompress code could reuse early serial console from setup code.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/x86/zero-page.txt  |    1 +
 arch/x86/boot/compressed/misc.c  |   25 +++++++++++++++++++++++++
 arch/x86/boot/tty.c              |    7 ++++++-
 arch/x86/include/asm/bootparam.h |    3 ++-
 4 files changed, 34 insertions(+), 2 deletions(-)

Index: linux-2.6/Documentation/x86/zero-page.txt
===================================================================
--- linux-2.6.orig/Documentation/x86/zero-page.txt
+++ linux-2.6/Documentation/x86/zero-page.txt
@@ -12,6 +12,7 @@ Offset	Proto	Name		Meaning
 000/040	ALL	screen_info	Text mode or frame buffer information
 				(struct screen_info)
 040/014	ALL	apm_bios_info	APM BIOS information (struct apm_bios_info)
+054/002 ALL	serial_console_port_base early serial console preset
 058/008	ALL	tboot_addr      Physical address of tboot shared page
 060/010	ALL	ist_info	Intel SpeedStep (IST) BIOS support information
 				(struct ist_info)
Index: linux-2.6/arch/x86/boot/compressed/misc.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/misc.c
+++ linux-2.6/arch/x86/boot/compressed/misc.c
@@ -125,6 +125,11 @@ static void error(char *m);
  */
 static struct boot_params *real_mode;		/* Pointer to real-mode data */
 static int quiet;
+static int early_serial_base;
+
+#define XMTRDY          0x20
+#define TXR             0       /*  Transmit register (WRITE) */
+#define LSR             5       /*  Line Status               */
 
 void *memset(void *s, int c, size_t n);
 void *memcpy(void *dest, const void *src, size_t n);
@@ -170,6 +175,16 @@ static void scroll(void)
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
@@ -179,6 +194,14 @@ static void __putstr(int error, const ch
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
@@ -319,6 +342,8 @@ asmlinkage void decompress_kernel(void *
 	lines = real_mode->screen_info.orig_video_lines;
 	cols = real_mode->screen_info.orig_video_cols;
 
+	early_serial_base = real_mode->serial_console_port_base;
+
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
Index: linux-2.6/arch/x86/boot/tty.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/tty.c
+++ linux-2.6/arch/x86/boot/tty.c
@@ -266,8 +266,13 @@ static void parse_console_uart8250(void)
 
 void console_init(void)
 {
-	parse_earlyprintk();
+	early_serial_base = boot_params.serial_console_port_base;
+
+	if (!early_serial_base)
+		parse_earlyprintk();
 
 	if (!early_serial_base)
 		parse_console_uart8250();
+
+	boot_params.serial_console_port_base = early_serial_base;
 }
Index: linux-2.6/arch/x86/include/asm/bootparam.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/bootparam.h
+++ linux-2.6/arch/x86/include/asm/bootparam.h
@@ -93,7 +93,8 @@ struct efi_info {
 struct boot_params {
 	struct screen_info screen_info;			/* 0x000 */
 	struct apm_bios_info apm_bios_info;		/* 0x040 */
-	__u8  _pad2[4];					/* 0x054 */
+	__u16  serial_console_port_base;		/* 0x054 */
+	__u8  _pad2[2];					/* 0x056 */
 	__u64  tboot_addr;				/* 0x058 */
 	struct ist_info ist_info;			/* 0x060 */
 	__u8  _pad3[16];				/* 0x070 */
