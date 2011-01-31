Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1AaXSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:18:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55480 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1AaXSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:18:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: matthieu castet <castet.matthieu@free.fr>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
Date: Tue, 1 Feb 2011 00:17:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Kees Cook <kees.cook@canonical.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
References: <4D41E86D.8060205@free.fr> <20110131213847.GF4557@outflux.net> <4D474194.2000709@free.fr>
In-Reply-To: <4D474194.2000709@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102010017.40986.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 01, 2011, matthieu castet wrote:
> Kees Cook a écrit :
> > Hi,
> > 
> > On Thu, Jan 27, 2011 at 06:24:14PM -0800, H. Peter Anvin wrote:
> >> On 01/27/2011 03:00 PM, Kees Cook wrote:
> >>> Yikes, good catch.
> >>>
> >>> arch/x86/kernel/trampoline_64.S uses:
> >>>         movw    $(trampoline_stack_end - r_base), %sp
> >>>
> >>> arch/x86/boot/compressed/head_64.S uses:
> >>>         movl    $boot_stack_end, %eax
> >>>         addl    %ebp, %eax
> >>>         movl    %eax, %esp
> >>>
> >>> what would be safe for arch/x86/kernel/head_32.S ? It uses "stack_start",
> >>> but later after paging set-up. Is the following sane to solve this?
> >>>
> >> To run it before paging is set up, you can't use stack, start; you
> >> have to use a pointer based on physical address.  You have two
> >> problems with using stack_start: you're using a linear address to
> >> access stack_start, and stack_start itself contains a linear
> >> address.
> >>
> >> It's not entirely clear to me why we don't initialize %ss to
> >> __BOOT_DS with the other segment registers, but it would make most
> >> sense to me:
> >>
> >> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> >> index fc293dc..c10f9ba 100644
> >> --- a/arch/x86/kernel/head_32.S
> >> +++ b/arch/x86/kernel/head_32.S
> >> @@ -99,7 +99,12 @@ ENTRY(startup_32)
> >>         movl %eax,%es
> >>         movl %eax,%fs
> >>         movl %eax,%gs
> >> +       movl %eax,%ss
> >>  2:
> >> +/*
> >> + * Set up an initial stack
> >> + */
> >> +       movl $pa(init_thread_union+THREAD_SIZE), %esp
> >>
> >>  /*
> >>   * Clear BSS first so that there are no surprises...
> > 
> > This doesn't appear to work for me. While I can boot fine, doing CPU
> > hotplugging hangs the system. :(
> > 
> This is weird because the patch only touch first cpu (startup_32 entry) and cpu hotplug go to 
> startup_32_smp.
> 
> Here a untested patch that move the stack setup in the common path.

Well, in my not so humble opinion the amount of random fixes required by the
entire NX protection of kernel "data" pages is simply unacceptable.

Please revert the whole thing and do it once again from scratch and possibly
without breaking stuff left and right.  I guess you've learnt enough so far
that this should be doable for 2.6.39 without introducing major issues like
_boot_ problems (let alone the broken resume).

Thanks,
Rafael
