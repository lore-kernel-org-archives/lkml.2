Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab0HBUSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:18:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45586 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab0HBUSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E0he5qvcJrzJ9rN4k4bfSy7wJh4q4DRkshxxFzZesVUDvfMQ72OtVybVkSAaXfQ05V
         rYaMaajmDTgppIbHoZKDuveM3BNPu2r2dUuMV9faAqdtOd7E0lpRPiV+m0aEdbiKWDVX
         SPNDFcE1LXT5sSk+IwVH/HO+95CMuVRr/1vVc=
Date: Tue, 3 Aug 2010 00:17:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, setup: reorgize the early_console_setup
Message-ID: <20100802201750.GG5544@lenovo>
References: <4C56701B.1030000@kernel.org> <20100802150958.GA5544@lenovo> <4C571B25.3080806@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C571B25.3080806@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 12:23:17PM -0700, Yinghai Lu wrote:
> On 08/02/2010 08:09 AM, Cyrill Gorcunov wrote:
> > On Mon, Aug 02, 2010 at 12:13:31AM -0700, Yinghai Lu wrote:
> >>
> >> Seperate early_console_setup from tty.c
> >> also make main.c to include printf.c/string.c/cmdline.c
> >>
> >> will reuse early_serial_console.c/string.c/printf.c/cmdline.c in compressed/misc.c
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> >> ---
> > 
> > Hi Yinghai, I'll try to find some time for review though it looks somehow
> > too 'big' for me :)
> > 
> > Actually by reading your initial approach (which was much smaller in size) I
> > thought we end up in something like the patch below, though I'll review this
> > seris. So just to share (I've tested it under qemu). The idea is the same as
> > your was, so I pushed all constant parts into header and use it when needed
> > passing serial line base port via boot_params.
> 
> Eric doesn't like early_serial_console_base in zero page. and said that is fragile.
> 

yeah, and Peter noted too as well, I missed Eric's mail in first place.

> So try to include string.c/printf.c/cmdline.c/early_serial_console.c in arch/x86/boot/compressed/misc.c
> and analyze that command line again.
> 
> then kexec path will get support too. that is from arch/x86/boot/compressed/head_32.S or head_64.S, startup_32.
> and skip arch/x86/boot/main.c
> 
> later with following patch for 3, we get all covered in c code.
> 1. arch/x86/boot/main.c: setup code.
> 2. arch/x86/boot/compressed/misc.c: decompress_kernel code : the 2 -v3 patches that i sent last night.
> 3. arch/x86/kernel/head64.c: real kernel.
> 
> maybe we can make early_serial_console.c and early_printk.c to share some .h etc later.
> 

yes, sounds tempting for me ;)

> Thanks
> 
> Yinghai
> 
> [PATCH -v2] x86: Setup early console as early as possible
> 
> Analyze "console=uart8250,io,0x3f8,115200n8" in i386_start_kernel/x86_64_start_kernel,
> and call setup_early_serial8250_console() to init early serial console.
> 
> only can handle io port kind of 8250. because mmio need ioremap.
> 
> -v2: use boot_params.hdr.version instead of adding another variable, Suggested by hpa
>      update after using x86 memblock patchset
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
...
> +
> +	p += 8;	/* sizeof "console=" */
> +	q = strchr(p, ' ');
> +	if ((q - p) >= sizeof(constr))
> +		return;
> +

I think the better would be to explicitly point q=0 here, ie if (!q || ...)
(yes, it'll trigger with former too but anyway this would be somewhat cleaner)

> +	memset(constr, 0, sizeof(constr));
> +	memcpy(constr, p, q - p);
> +
> +	lockdep_init();
> +
> +	setup_early_serial8250_console(constr);
> +#endif
> +}

...
  
> +	/* make sure if it is copied already */
> +	if (boot_params.hdr.version)
> +		return;
> +

And Yinghai, lets be more verbose here a bit, since for those who will
be reading this code later might be non-obvious why we have checked for
'version' here. I guess something like "an easy way to check if boot_params
were already copied". Actually it's clean from commit message but I think
we first read code comments and commit messages after, agreed? ;-)

>  	memcpy(&boot_params, real_mode_data, sizeof boot_params);
>  	if (boot_params.hdr.cmd_line_ptr) {
>  		command_line = __va(boot_params.hdr.cmd_line_ptr);
> @@ -74,6 +78,10 @@ void __init x86_64_start_kernel(char * r
>  	/* clear bss before set_intr_gate with early_idt_handler */
>  	clear_bss();
>  
... 

Other then that looks good for me, thanks! My Reviewed-by if needed.
 
	-- Cyrill
