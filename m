Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab0HACma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 22:42:30 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34779 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab0HACm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 22:42:28 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org
Subject: Re: [PATCH] x86,setup: add serial_console_port_base in boot_params
References: <4C3F8B46.7080809@kernel.org> <20100731083409.GC5859@lenovo>
	<4C5469AF.2010608@zytor.com> <20100731183211.GB29357@lenovo>
	<4C548F7D.6000509@zytor.com> <4C54D3AD.8020906@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 31 Jul 2010 19:42:14 -0700
In-Reply-To: <4C54D3AD.8020906@kernel.org> (Yinghai Lu's message of "Sat\, 31 Jul 2010 18\:53\:49 -0700")
Message-ID: <m14offuk8p.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 07/31/2010 02:02 PM, H. Peter Anvin wrote:
>> On 07/31/2010 11:32 AM, Cyrill Gorcunov wrote:
>>>>
>>>> No, this is the internal part of the boot protocol, so it's not an issue.
>>>>
>>>
>>> Peter, I didn't mean any issue here, I meant that bootloaders don't know about
>>> this field yet and they will have to update own sources to pass port value
>>> at proper place of boot params. Or I miss something?
>>>
>> 
>> Boot loaders that use the 16-bit entry point are unaffected.
>> 
>> Boot loaders which use the 32-bit entry point but properly clears the
>> zero page simply will not have the feature.
>> 
>> Boot loaders which use the 32-bit entry point but doesn't clear the zero
>> page are broken.
>> 
> can you if this one is right for kexec path?

I am walking out the door, but this seems like nonsense to me.

The kexec console_serial option today is a debugging feature for
when you to debug the purgatory code.  Only once in a bluemoon
should it be useful, so I don't see why we would add it here.
The kexec purgatory is silent by default.

Further I don't see why we would add something to the zero page
when we have a perfectly good way to pass this information via
the kernel command line.  strstr and strtoul are trivial little
functions so I don't see why anything would need to parse anything
other than console= or early_printk=.  The difference in code size
is negligible.

This option in the zero page appears very fragile. There are a lot of
dimensions that we are skipping.  I admit we can detect most of them
by reading the serial port.  But we still have the assumption that the
serial port is an 8259 serial port in i/o space and not mmio space.

*runs out the door before another silly email comes*

Eric
>
> [PATCH] kexec-tools: pass serial console base for early console in kernel
>
> when kexec is used with "console_serial", set serial_console_port_base in boot_params.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  doc/linux-i386-zero-page.txt      |    1 +
>  include/x86/x86-linux.h           |    3 ++-
>  kexec/arch/i386/kexec-x86.h       |    1 +
>  kexec/arch/i386/x86-linux-setup.c |    4 ++++
>  kexec/arch/x86_64/kexec-x86_64.c  |    9 +--------
>  5 files changed, 9 insertions(+), 9 deletions(-)
>
> Index: kexec-tools/doc/linux-i386-zero-page.txt
> ===================================================================
> --- kexec-tools.orig/doc/linux-i386-zero-page.txt
> +++ kexec-tools/doc/linux-i386-zero-page.txt
> @@ -22,6 +22,7 @@ Offset	Type		Description
>  			  0x90000 + contents of CL_OFFSET
>  			(only taken, when CL_MAGIC = 0xA33F)
>   0x40	20 bytes	struct apm_bios_info, APM_BIOS_INFO
> + 0x54   2 bytes		serial console base
>   0x60	16 bytes	Intel SpeedStep (IST) BIOS support information
>   0x80	16 bytes	hd0-disk-parameter from intvector 0x41
>   0x90	16 bytes	hd1-disk-parameter from intvector 0x46
> Index: kexec-tools/include/x86/x86-linux.h
> ===================================================================
> --- kexec-tools.orig/include/x86/x86-linux.h
> +++ kexec-tools/include/x86/x86-linux.h
> @@ -40,7 +40,6 @@ struct apm_bios_info {
>  	uint16_t cseg_len;	/* 0x4e */
>  	uint16_t cseg_16_len;	/* 0x50 */
>  	uint16_t dseg_len;	/* 0x52 */
> -	uint8_t  reserved[44];	/* 0x54 */
>  };
>  
>  /*
> @@ -105,6 +104,8 @@ struct x86_linux_param_header {
>  	uint8_t  reserved4[12];			/* 0x34 -- 0x3f reserved for future expansion */
>  
>  	struct apm_bios_info apm_bios_info;	/* 0x40 */
> +	uint16_t  serial_console_port_base;	/* 0x54 */
> +	uint8_t  reserved41[42];		/* 0x56 */
>  	struct drive_info_struct drive_info;	/* 0x80 */
>  	struct sys_desc_table sys_desc_table;	/* 0xa0 */
>  	uint32_t alt_mem_k;			/* 0x1e0 */
> Index: kexec-tools/kexec/arch/i386/x86-linux-setup.c
> ===================================================================
> --- kexec-tools.orig/kexec/arch/i386/x86-linux-setup.c
> +++ kexec-tools/kexec/arch/i386/x86-linux-setup.c
> @@ -100,6 +100,9 @@ void setup_linux_bootloader_parameters(
>  	cmdline_ptr = ((char *)real_mode) + cmdline_offset;
>  	memcpy(cmdline_ptr, cmdline, cmdline_len);
>  	cmdline_ptr[cmdline_len - 1] = '\0';
> +
> +	if (arch_options.console_serial)
> +		real_mode->serial_console_port_base = arch_options.serial_base;
>  }
>  
>  int setup_linux_vesafb(struct x86_linux_param_header *real_mode)
> @@ -422,6 +425,7 @@ void setup_linux_system_parameters(struc
>  
>  	/* Default APM info */
>  	memset(&real_mode->apm_bios_info, 0, sizeof(real_mode->apm_bios_info));
> +
>  	/* Default drive info */
>  	memset(&real_mode->drive_info, 0, sizeof(real_mode->drive_info));
>  	/* Default sysdesc table */
> Index: kexec-tools/kexec/arch/i386/kexec-x86.h
> ===================================================================
> --- kexec-tools.orig/kexec/arch/i386/kexec-x86.h
> +++ kexec-tools/kexec/arch/i386/kexec-x86.h
> @@ -51,6 +51,7 @@ struct arch_options_t {
>  	uint8_t  	console_serial;
>  	enum coretype	core_header_type;
>  };
> +extern struct arch_options_t arch_options;
>  
>  int multiboot_x86_probe(const char *buf, off_t len);
>  int multiboot_x86_load(int argc, char **argv, const char *buf, off_t len,
> Index: kexec-tools/kexec/arch/x86_64/kexec-x86_64.c
> ===================================================================
> --- kexec-tools.orig/kexec/arch/x86_64/kexec-x86_64.c
> +++ kexec-tools/kexec/arch/x86_64/kexec-x86_64.c
> @@ -55,14 +55,7 @@ void arch_usage(void)
>  		);
>  }
>  
> -static struct {
> -	uint8_t  reset_vga;
> -	uint16_t serial_base;
> -	uint32_t serial_baud;
> -	uint8_t  console_vga;
> -	uint8_t  console_serial;
> -	int core_header_type;
> -} arch_options = {
> +struct arch_options_t arch_options = {
>  	.reset_vga   = 0,
>  	.serial_base = 0x3f8,
>  	.serial_baud = 0,
