Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab0DFUSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:18:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59624 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab0DFUR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:17:56 -0400
Message-ID: <4BBB96D7.1040302@zytor.com>
Date: Tue, 06 Apr 2010 13:17:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: guenter.roeck@ericsson.com
CC: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mingo@redhat.com,
       x86@kernel.org
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if CONFIG_VGA_CONSOLE
 is undefined
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>	 <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com>	 <1270491029.1477.453.camel@groeck-laptop>  <4BBA3021.9090504@zytor.com>	 <1270497725.1477.488.camel@groeck-laptop>  <4BBA473D.9040004@zytor.com>	 <1270501481.1477.521.camel@groeck-laptop>  <4BBA51F3.7070808@zytor.com> <1270505579.1477.584.camel@groeck-laptop>
In-Reply-To: <1270505579.1477.584.camel@groeck-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2010 03:12 PM, Guenter Roeck wrote:
>>
>> I'm unhappy about it, because *those early messages shouldn't exist in
>> the first place*.  It seems to be an indication that we're invoking
>> setup_early_printk() too late.  The whole playing around with max_xpos
>> and max_ypos instead of using boot_params.screen_info directly is
>> particularly bleacherous.
>>
>> I would at least like to see if the improper invocation of
>> early_printk() can be avoided.
>>
> There are several such invocations.
> 
> 1) arch/x86/kernel/head_64.S:
> ENTRY(early_idt_handler)
> ...
> 	leaq early_idt_msg(%rip),%rdi
> 	call early_printk
> 
> This displays "PANIC: early exception %02lx rip %lx:%lx error %lx cr2 %
> lx\n" and subsequently calls dump_stack. The handler is initialized from
> x86_64_start_kernel().
> 
> 2) arch/x86/kernel/head64.c:x86_64_start_kernel():
> 	if (console_loglevel == 10)
> 		early_printk("Kernel alive\n");
> 
> 3) init/main.c: start_kernel()
> 	printk(KERN_NOTICE "%s", linux_banner);
>     and
> 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
> 
> 4) arch/x86/kernel/setup.c:setup_arch()
> 	Several.
> 
> After that I gave up looking.
> 
> Not sure if or how those can be avoided.
> 
> Moving setup_early_printk() into x86_64_start_kernel() might be an
> option, but that would require much more significant changes.
> 

Okay... that leaves a few very ugly options.

I think spewing onto a potentially uninitialized (or not even present)
serial port is worse than losing the messages.  It seems to be pretty
much a no-brainer to have:

	if (boot_params.screen_info.orig_video_isVGA != 1)
		return;

... in early_vga_write(), and is something we should do regardless.

Calling early_serial_write() before early_serial_init() is distinctly
not safe... depending on boot conditions you might end up with a glacial
boot.

Therefore, the only sensible way to get the early messages out is really
to push setup_early_printk() as early as possible.

	-hpa


