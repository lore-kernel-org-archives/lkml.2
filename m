Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab1IQLoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 07:44:30 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38937 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab1IQLo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 07:44:29 -0400
Subject: Re: [PATCH v2 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Matt Domsch <Matt_Domsch@Dell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>,
        "Hargrave, Jordan" <Jordan_Hargrave@Dell.com>
In-Reply-To: <4E71F33C.2010809@gmail.com>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
	 <1315838094-2307-11-git-send-email-matt@console-pimps.org>
	 <4E6F69A1.9030406@gmail.com>
	 <1316016478.3466.74.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110915045231.GA32136@emperor.us.dell.com> <4E71B196.1060504@gmail.com>
	 <20110915115255.GA4669@emperor.us.dell.com>  <4E71F33C.2010809@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Sep 2011 12:44:26 +0100
Message-ID: <1316259866.3578.20.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 14:44 +0200, Maarten Lankhorst wrote:
> Thanks, that makes much more sense. The man page makes mention
> of extra arguments, but it kind of looked like the way to pass it was by
> using -u -@ - which didn't work of course. :)
> 
> So for reference:
> efibootmgr -L 'EFI Native Linux Boot' -l '\vmlinuz.efi' -d /dev/sdb -u root=/dev/sdb2 console=ttyS0,115200n8
> 
> or as ASCII (reads much prettier in efibootmgr -v)
> efibootmgr -L 'EFI Native Linux Boot' -l '\vmlinuz.efi' -d /dev/sdb root=/dev/sdb2 console=ttyS0,115200n8
> 
> This is the fixed patch I'm using for booting native linux kernel,
> with passing args tested for UCS-2 and ASCII. It seems that
> options_size can be halved safely, otherwise too much data is
> copied from input.

Thanks for looking at this Maarten. I've been staring at this code for
far too long to notice buglets like this ;-)

> I keep the first word, since otherwise the first argument is stripped off,
> and it's probably harmless for the kernel to read something like
> \vmlinuz.efi when you don't do a direct boot.
> 
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 6c34828..f77f9f5 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -619,12 +619,12 @@ static efi_status_t make_boot_params(struct boot_params *boot_params,
>  	unsigned long cmdline;
>  	u8 nr_entries;
>  	u16 *s2;
> -	u8 *s1;
> +	u8 *s1, *s2_8;
>  	int i;
>  
>  	hdr->type_of_loader = 0x21;
>  
> -	status = low_alloc(options_size, 1, &cmdline);
> +	status = low_alloc(options_size+1, 1, &cmdline);
>  	if (status != EFI_SUCCESS)
>  		goto fail;

If no options were passed to the stub then we really don't want to do
the allocation at all. Speaking of 'options_size', have you tested the
values that get passed in from image->load_options? Running with the
OVMF firmware under qemu I get sizes that are always larger than the
NUL-byte in the argument string. For example, executing "bzImage foo"
results in image->load_options being 38!

Remember that ->options_size represents 16-bit characters and cmdline is
going to be ASCII. options_size will always be larger than the value we
need, so there's no need for the +1. At the moment we're actually
allocating too much memory and that needs to be fixed.

> @@ -633,27 +633,29 @@ static efi_status_t make_boot_params(struct boot_params *boot_params,
>  	/* Convert unicode cmdline to ascii */
>  	s1 = (u8 *)(unsigned long)hdr->cmd_line_ptr;
>  	s2 = (u16 *)options;
> +	s2_8 = (u8*)options;
>  
> -	if (s2 && options_size) {
> -		/* Skip first word, that's the kernel name */
> -		while (*s2 && *s2 != ' ' && *s2 != '\n') {
> -			options_size--;
> -			s2++;
> -		}
> -
> -		/* skip space */
> -		if (*s2 == ' ') {
> -			options_size--;
> -			s2++;
> -		}
> -
> -		while (options_size-- != 0) {
> +	if (options_size < 2 || !s2) {
> +		*s1 = '\0';
> +	} else if (s2_8[1] && s2_8[1] < 0x80 && s2_8[0] < 0x80) {
> +		/* Passed as ASCII */
> +		s2 = NULL;
> +		memcpy(s1, s2_8, options_size);
> +		hdr->cmdline_size = options_size;
> +	} else {
> +		options_size /= 2; /* Passed as UCS-2 */
> +		while (options_size-- != 0 && *s2) {
>  			*s1++ = *s2++;
>  			hdr->cmdline_size++;
>  		}
> -
>  		*s1 = '\0';
> +		s1 = (u8 *)(unsigned long)hdr->cmd_line_ptr;
>  	}
> +	if (hdr->cmdline_size && s1[hdr->cmdline_size - 1] == '\0')
> +		hdr->cmdline_size--;
> +	if (hdr->cmdline_size && s1[hdr->cmdline_size - 1] == '\n')
> +		hdr->cmdline_size--;
> +	s1[hdr->cmdline_size] = '\0';
>  
>  	hdr->ramdisk_image = 0;
>  	hdr->ramdisk_size = 0;

Hmm... I'm really not convinced that we need to support ASCII cmdline
arguments, sorry. efibootmgr has support for UCS-2, so that's what
should be used.

Thanks for the review!

-- 
Matt Fleming, Intel Open Source Technology Center

