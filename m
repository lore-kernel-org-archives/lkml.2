Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab0HABzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 21:55:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35862 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0HABzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 21:55:43 -0400
Message-ID: <4C54D3AD.8020906@kernel.org>
Date: Sat, 31 Jul 2010 18:53:49 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org
Subject: Re: [PATCH] x86,setup: add serial_console_port_base in boot_params
References: <4C3F8B46.7080809@kernel.org> <20100731083409.GC5859@lenovo> <4C5469AF.2010608@zytor.com> <20100731183211.GB29357@lenovo> <4C548F7D.6000509@zytor.com>
In-Reply-To: <4C548F7D.6000509@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C54D3EA.0019,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2010 02:02 PM, H. Peter Anvin wrote:
> On 07/31/2010 11:32 AM, Cyrill Gorcunov wrote:
>>>
>>> No, this is the internal part of the boot protocol, so it's not an issue.
>>>
>>
>> Peter, I didn't mean any issue here, I meant that bootloaders don't know about
>> this field yet and they will have to update own sources to pass port value
>> at proper place of boot params. Or I miss something?
>>
> 
> Boot loaders that use the 16-bit entry point are unaffected.
> 
> Boot loaders which use the 32-bit entry point but properly clears the
> zero page simply will not have the feature.
> 
> Boot loaders which use the 32-bit entry point but doesn't clear the zero
> page are broken.
> 
can you if this one is right for kexec path?

Thanks

Yinghai

[PATCH] kexec-tools: pass serial console base for early console in kernel

when kexec is used with "console_serial", set serial_console_port_base in boot_params.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 doc/linux-i386-zero-page.txt      |    1 +
 include/x86/x86-linux.h           |    3 ++-
 kexec/arch/i386/kexec-x86.h       |    1 +
 kexec/arch/i386/x86-linux-setup.c |    4 ++++
 kexec/arch/x86_64/kexec-x86_64.c  |    9 +--------
 5 files changed, 9 insertions(+), 9 deletions(-)

Index: kexec-tools/doc/linux-i386-zero-page.txt
===================================================================
--- kexec-tools.orig/doc/linux-i386-zero-page.txt
+++ kexec-tools/doc/linux-i386-zero-page.txt
@@ -22,6 +22,7 @@ Offset	Type		Description
 			  0x90000 + contents of CL_OFFSET
 			(only taken, when CL_MAGIC = 0xA33F)
  0x40	20 bytes	struct apm_bios_info, APM_BIOS_INFO
+ 0x54   2 bytes		serial console base
  0x60	16 bytes	Intel SpeedStep (IST) BIOS support information
  0x80	16 bytes	hd0-disk-parameter from intvector 0x41
  0x90	16 bytes	hd1-disk-parameter from intvector 0x46
Index: kexec-tools/include/x86/x86-linux.h
===================================================================
--- kexec-tools.orig/include/x86/x86-linux.h
+++ kexec-tools/include/x86/x86-linux.h
@@ -40,7 +40,6 @@ struct apm_bios_info {
 	uint16_t cseg_len;	/* 0x4e */
 	uint16_t cseg_16_len;	/* 0x50 */
 	uint16_t dseg_len;	/* 0x52 */
-	uint8_t  reserved[44];	/* 0x54 */
 };
 
 /*
@@ -105,6 +104,8 @@ struct x86_linux_param_header {
 	uint8_t  reserved4[12];			/* 0x34 -- 0x3f reserved for future expansion */
 
 	struct apm_bios_info apm_bios_info;	/* 0x40 */
+	uint16_t  serial_console_port_base;	/* 0x54 */
+	uint8_t  reserved41[42];		/* 0x56 */
 	struct drive_info_struct drive_info;	/* 0x80 */
 	struct sys_desc_table sys_desc_table;	/* 0xa0 */
 	uint32_t alt_mem_k;			/* 0x1e0 */
Index: kexec-tools/kexec/arch/i386/x86-linux-setup.c
===================================================================
--- kexec-tools.orig/kexec/arch/i386/x86-linux-setup.c
+++ kexec-tools/kexec/arch/i386/x86-linux-setup.c
@@ -100,6 +100,9 @@ void setup_linux_bootloader_parameters(
 	cmdline_ptr = ((char *)real_mode) + cmdline_offset;
 	memcpy(cmdline_ptr, cmdline, cmdline_len);
 	cmdline_ptr[cmdline_len - 1] = '\0';
+
+	if (arch_options.console_serial)
+		real_mode->serial_console_port_base = arch_options.serial_base;
 }
 
 int setup_linux_vesafb(struct x86_linux_param_header *real_mode)
@@ -422,6 +425,7 @@ void setup_linux_system_parameters(struc
 
 	/* Default APM info */
 	memset(&real_mode->apm_bios_info, 0, sizeof(real_mode->apm_bios_info));
+
 	/* Default drive info */
 	memset(&real_mode->drive_info, 0, sizeof(real_mode->drive_info));
 	/* Default sysdesc table */
Index: kexec-tools/kexec/arch/i386/kexec-x86.h
===================================================================
--- kexec-tools.orig/kexec/arch/i386/kexec-x86.h
+++ kexec-tools/kexec/arch/i386/kexec-x86.h
@@ -51,6 +51,7 @@ struct arch_options_t {
 	uint8_t  	console_serial;
 	enum coretype	core_header_type;
 };
+extern struct arch_options_t arch_options;
 
 int multiboot_x86_probe(const char *buf, off_t len);
 int multiboot_x86_load(int argc, char **argv, const char *buf, off_t len,
Index: kexec-tools/kexec/arch/x86_64/kexec-x86_64.c
===================================================================
--- kexec-tools.orig/kexec/arch/x86_64/kexec-x86_64.c
+++ kexec-tools/kexec/arch/x86_64/kexec-x86_64.c
@@ -55,14 +55,7 @@ void arch_usage(void)
 		);
 }
 
-static struct {
-	uint8_t  reset_vga;
-	uint16_t serial_base;
-	uint32_t serial_baud;
-	uint8_t  console_vga;
-	uint8_t  console_serial;
-	int core_header_type;
-} arch_options = {
+struct arch_options_t arch_options = {
 	.reset_vga   = 0,
 	.serial_base = 0x3f8,
 	.serial_baud = 0,
