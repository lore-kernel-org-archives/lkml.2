Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1GZQux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:50:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:3018 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab1GZQup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:50:45 -0400
X-IronPort-AV: E=Sophos;i="4.67,270,1309752000"; 
   d="scan'208";a="15267152"
Subject: Re: git commit 9fd67b4ed0714ab718f1f9bd14c344af336a6df7 (x86-64:
 Give vvars their own page) breaks Xen PV guests (64-bit).
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Andrew Lutomirski <luto@mit.edu>, "jj@chaosbits.net" <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>,
        "mikpe@it.uu.se" <mikpe@it.uu.se>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "brgerst@gmail.com" <brgerst@gmail.com>,
        "Louis.Rilling@kerlabs.com" <Louis.Rilling@kerlabs.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "pageexec@freemail.hu" <pageexec@freemail.hu>,
        "mingo@elte.hu" <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110726161808.GA5333@dumpdata.com>
References: <20110725155442.GA21759@dumpdata.com>
	 <20110725161009.GA9193@dumpdata.com>
	 <CAObL_7F9+Wn1DBf5te7BHoAe3CbEzR=pxTqy_S_vpkwcG57NKQ@mail.gmail.com>
	 <20110726161808.GA5333@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 26 Jul 2011 17:46:35 +0100
Message-ID: <1311698795.24408.79.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 12:18 -0400, Konrad Rzeszutek Wilk wrote:
> > > However, this is what I get later on, any ideas?
> > 
> > > [    0.585880] init[1] illegal int 0xcc from 32-bit mode ip:ffffffffff600400 cs:e033 sp:7fff230ca088 ax:ffffffffff600400 si:7faee3e822bf di:7fff230ca158
> > 
> > That will, indeed, crash your system.
> > 
> > 0xe033 is FLAT_RING3_CS64
> > 
> > Jeremy / other Xen people:  I'm trying to implement a lightweight
> > check to distinguish a trap from a sane (i.e. allowable for syscalls)
> > 64-bit user context from anything else.  There seems to be precedent
> > for using ->cs == __USER_CS to detect 64-bitness; for example, step.c
> > contains:
> > 
> > #ifdef CONFIG_X86_64
> >                 case 0x40 ... 0x4f:
> >                         if (regs->cs != __USER_CS)
> >                                 /* 32-bit mode: register increment */
> >                                 return 0;
> >                         /* 64-bit mode: REX prefix */
> >                         continue;
> > #endif
> > 
> > The prefetch opcode checker in mm/fault.c does something similar.
> > 
> > Even the sysret code in xen/xen-asm_64.S does:
> > 
> >         pushq %r11
> >         pushq $__USER_CS
> >         pushq %rcx
> > 
> > So I'm at a bit of a loss.
> > 
> > You could probably hack it up and get your kernel to boot by allowing
> > __USER_CS and 0xe033 in that check, but I'd rather understand it
> 
> Did this little hack:
> 
> 
> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
> index dda7dff..5d0cf37 100644
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -131,7 +131,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
>  	 * Real 64-bit user mode code has cs == __USER_CS.  Anything else
>  	 * is bogus.
>  	 */
> -	if (regs->cs != __USER_CS) {
> +	if ((regs->cs != __USER_CS) && (regs->cs != FLAT_RING3_CS64)) {


While it is possible to run on the Xen provided convenience flat
segments, is there any reason not to just switch to using the Linux
selector values as early as possible on boot?

(I expect the reason for your seg faults is that kernel also runs in
ring3 for 64 bit PV Xen, i.e. FLAT_KERNEL_CS64 == FLAT_RING3_CS64,
although I thought we ensured that the on-stack representations of the
selectors was correct for the actual privilege level (to allow for
simple checks of kernel vs non-kernel segments e.g. with seg@~3 type
constructs). The error doesn't print the CS so it's hard to tell for
sure so I'm guessing).

Ian.

>  		/*
>  		 * If we trapped from kernel mode, we might as well OOPS now
>  		 * instead of returning to some random address and OOPSing
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index f987bde..0e4c13c 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1916,6 +1916,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
>  # endif
>  #else
>  	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
> +	case VVAR_PAGE:
>  #endif
>  	case FIX_TEXT_POKE0:
>  	case FIX_TEXT_POKE1:
> 
> And getting this on 64-bit:
> 
>  started: BusyBox v1.14.3 (2011-07-26 11:43:49 EDT)
> [    0.578603] rcS[1128]: segfault at ffffffffff5ff0a0 ip 00007fff40b7380a sp 00007fff40b5c0f0 error 4
> [    0.578847] rcS used greatest stack depth: 5024 bytes left
> [    0.581897] sh[1131]: segfault at ffffffffff5ff0a0 ip 00007fffb93ff80a sp 00007fffb92bbd70 error 4
> [    1.587637] sh[1137]: segfault at ffffffffff5ff0a0 ip 00007ffffa5ff80a sp 00007ffffa522560 error 4
> [    2.592295] sh[1141]: segfault at ffffffffff5ff0a0 ip 00007ffffcb3f80a sp 00007ffffca98af0 error 4
> [    3.596344] sh[1145]: segfault at ffffffffff5ff0a0 ip 00007fff2e3ff80a sp 00007fff2e3e3370 error 4
> [    4.599812] sh[1149]: segfault at ffffffffff5ff0a0 ip 00007fff62dff80a sp 00007fff62ca9f10 error 4
> [    5.605835] sh[1153]: segfault at ffffffffff5ff0a0 ip 00007fff117ff80a sp 00007fff1175e7f0 error 4
> [    6.609438] sh[1157]: segfault at ffffffffff5ff0a0 ip 00007fff91bff80a sp 00007fff91bd71c0 error 4
> [    7.614714] sh[1161]: segfault at ffffffffff5ff0a0 ip 00007fff396b280a sp 00007fff3968ede0 error 4
> [    8.620374] sh[1165]: segfault at ffffffffff5ff0a0 ip 00007fffd398b80a sp 00007fffd38ecd70 error 4
> [    9.625512] sh[1169]: segfault at ffffffffff5ff0a0 ip 00007fff617d980a sp 00007fff61776070 error 4
> [   10.630246] sh[1173]: segfault at ffffffffff5ff0a0 ip 00007fff89fff80a sp 00007fff89f7f3b0 error 4
> [   11.635588] sh[1177]: segfault at ffffffffff5ff0a0 ip 00007fffa95ff80a sp 00007fffa95ea7c0 error 4
> [   12.640491] sh[1181]: segfault at ffffffffff5ff0a0 ip 00007fff28cd180a sp 00007fff28c524f0 error 4
> 
> ..


