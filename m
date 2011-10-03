Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab1JCQNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:13:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58237 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1JCQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:13:49 -0400
Date: Mon, 3 Oct 2011 12:13:44 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: "Lu, Hongjiu" <hongjiu.lu@intel.com>
cc: Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@redhat.com>,
        Andrew Morton <akpm00@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: RE: [PATCH v2] binfmt_elf: Fix PIE execution with randomization
 disabled (was Re: [RFC PATCH] binfmt_elf: Fix PIE execution with randomization
 disabled)
In-Reply-To: <9DA5872FEF993D41B7173F58FCF6BE94E0906494@orsmsx504.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1110031210570.9106@xanadu.home>
References: <20110929195359.GJ16720@zod.bos.redhat.com> <20110929141929.43df799d.akpm00@gmail.com> <alpine.LFD.2.02.1109291958210.9106@xanadu.home> <20110930021629.GL16720@zod.bos.redhat.com> <alpine.LNX.2.00.1110031651400.31654@pobox.suse.cz>
 <20111003150345.GP16720@zod.bos.redhat.com> <alpine.LNX.2.00.1110031709230.31654@pobox.suse.cz> <alpine.LFD.2.02.1110031150470.9106@xanadu.home> <9DA5872FEF993D41B7173F58FCF6BE94E0906494@orsmsx504.amr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Lu, Hongjiu wrote:

> Why not
> 
> #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> #define CHECK_PF_RANDOMIZE 1
> #else
> #define CHECK_PF_RANDOMIZE 0
> #endif
> 			if (CHECK_PF_RANDOMIZE && (current->flags & PF_RANDOMIZE))
> 				load_bias = 0;
> 			else
> 				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> 

Whatever.  I don't have a strong opinion on the shed color.


> > -----Original Message-----
> > From: Nicolas Pitre [mailto:nicolas.pitre@linaro.org]
> > Sent: Monday, October 03, 2011 8:56 AM
> > To: Jiri Kosina
> > Cc: Josh Boyer; Andrew Morton; Ingo Molnar; Lu, Hongjiu; linux-
> > kernel@vger.kernel.org; Andrew Morton; Russell King
> > Subject: Re: [PATCH v2] binfmt_elf: Fix PIE execution with randomization
> > disabled (was Re: [RFC PATCH] binfmt_elf: Fix PIE execution with randomization
> > disabled)
> > 
> > On Mon, 3 Oct 2011, Jiri Kosina wrote:
> > 
> > > How about the patch below instead? It survives my testing, and I believe
> > > it handles both cases properly.
> > >
> > > Confirmation from the original bug reporter would obviously be a nice
> > > bonus too :)
> > >
> > >
> > >
> > >
> > > From: Jiri Kosina <jkosina@suse.cz>
> > > Subject: [PATCH] binfmt_elf: fix PIE execution with randomization disabled
> > >
> > > The case of address space randomization being disabled in runtime through
> > > randomize_va_space sysctl is not treated properly in load_elf_binary(),
> > > resulting in SIGKILL coming at exec() time for certain PIE-linked binaries
> > > in case the randomization has been disabled at runtime prior to calling
> > > exec().
> > >
> > > Handle the randomize_va_space == 0 case the same way as if we were not
> > > supporting .text randomization at all.
> > >
> > > Based on original patch by H.J. Lu <hongjiu.lu@intel.com> and
> > > Josh Boyer <jwboyer@redhat.com>
> > >
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Jiri Kosina <jkosina@suse.cz>
> > > Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> > > Cc: Russell King <rmk@arm.linux.org.uk>
> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> > 
> > However I'd suggest a change to deal with style issues:
> > 
> > > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > > index dd0fdfc..bb11fe4 100644
> > > --- a/fs/binfmt_elf.c
> > > +++ b/fs/binfmt_elf.c
> > > @@ -795,7 +795,10 @@ static int load_elf_binary(struct linux_binprm *bprm,
> > struct pt_regs *regs)
> > >  			 * might try to exec.  This is because the brk will
> > >  			 * follow the loader, and is not movable.  */
> > >  #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> > > -			load_bias = 0;
> > > +			if (current->flags & PF_RANDOMIZE)
> > > +				load_bias = 0;
> > > +			else
> > > +				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> > >  #else
> > >  			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> > >  #endif
> > 
> > What about this instead, saving 3 lines out of 8:
> > 
> > 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> > #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> > 			if (current->flags & PF_RANDOMIZE)
> > 				load_bias = 0;
> > #endif
> > 
> > 
> > ?
> > 
> > 
> > Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
