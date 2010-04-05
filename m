Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab0DEWLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 18:11:32 -0400
Received: from imr2.ericy.com ([198.24.6.3]:43351 "EHLO imr2.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab0DEWL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 18:11:26 -0400
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if
 CONFIG_VGA_CONSOLE is undefined
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: linux-kernel@vger.kernel.org, hpa@zytor.com
CC: penberg@cs.helsinki.fi, mingo@redhat.com, x86@kernel.org
In-Reply-To: <4BBA51F3.7070808@zytor.com>
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>
	 <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com>
	 <1270491029.1477.453.camel@groeck-laptop>  <4BBA3021.9090504@zytor.com>
	 <1270497725.1477.488.camel@groeck-laptop>  <4BBA473D.9040004@zytor.com>
	 <1270501481.1477.521.camel@groeck-laptop>  <4BBA51F3.7070808@zytor.com>
Content-Type: text/plain
Organization: Ericsson
Date: Mon, 5 Apr 2010 15:12:59 -0700
Message-ID: <1270505579.1477.584.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-05 at 17:11 -0400, H. Peter Anvin wrote:
> On 04/05/2010 02:04 PM, Guenter Roeck wrote:
> > 
> > Would you accept a minimized patch like this ?
> > 
> >  /* Direct interface for emergencies */
> > +#ifdef CONFIG_VGA_CONSOLE
> >  static struct console *early_console = &early_vga_console;
> > +#else
> > +static struct console *early_console = &early_serial_console;
> > +#endif
> >  static int __initdata early_console_initialized;
> > 
> > This would prevent the problem while minimizing changes, and at the same
> > time permit early messages to be written to the serial console.
> > 
> 
> I'm unhappy about it, because *those early messages shouldn't exist in
> the first place*.  It seems to be an indication that we're invoking
> setup_early_printk() too late.  The whole playing around with max_xpos
> and max_ypos instead of using boot_params.screen_info directly is
> particularly bleacherous.
> 
> I would at least like to see if the improper invocation of
> early_printk() can be avoided.
> 
There are several such invocations.

1) arch/x86/kernel/head_64.S:
ENTRY(early_idt_handler)
...
	leaq early_idt_msg(%rip),%rdi
	call early_printk

This displays "PANIC: early exception %02lx rip %lx:%lx error %lx cr2 %
lx\n" and subsequently calls dump_stack. The handler is initialized from
x86_64_start_kernel().

2) arch/x86/kernel/head64.c:x86_64_start_kernel():
	if (console_loglevel == 10)
		early_printk("Kernel alive\n");

3) init/main.c: start_kernel()
	printk(KERN_NOTICE "%s", linux_banner);
    and
	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);

4) arch/x86/kernel/setup.c:setup_arch()
	Several.

After that I gave up looking.

Not sure if or how those can be avoided.

Moving setup_early_printk() into x86_64_start_kernel() might be an
option, but that would require much more significant changes.

Guenter


