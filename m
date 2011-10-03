Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab1JCWGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 18:06:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab1JCWG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 18:06:29 -0400
Date: Tue, 4 Oct 2011 00:06:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm00@gmail.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, hongjiu.lu@intel.com,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH v2] binfmt_elf: Fix PIE execution with randomization
 disabled (was Re: [RFC PATCH] binfmt_elf: Fix PIE execution with randomization
 disabled)
In-Reply-To: <20111003150305.936fc46e.akpm00@gmail.com>
Message-ID: <alpine.LNX.2.00.1110040004330.31654@pobox.suse.cz>
References: <20110929195359.GJ16720@zod.bos.redhat.com> <20110929141929.43df799d.akpm00@gmail.com> <alpine.LFD.2.02.1109291958210.9106@xanadu.home> <20110930021629.GL16720@zod.bos.redhat.com> <alpine.LNX.2.00.1110031651400.31654@pobox.suse.cz>
 <20111003150345.GP16720@zod.bos.redhat.com> <alpine.LNX.2.00.1110031709230.31654@pobox.suse.cz> <20111003150305.936fc46e.akpm00@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Andrew Morton wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> > Subject: [PATCH] binfmt_elf: fix PIE execution with randomization disabled
> > 
> > The case of address space randomization being disabled in runtime through
> > randomize_va_space sysctl is not treated properly in load_elf_binary(),
> > resulting in SIGKILL coming at exec() time for certain PIE-linked binaries
> > in case the randomization has been disabled at runtime prior to calling
> > exec().
> > 
> > Handle the randomize_va_space == 0 case the same way as if we were not
> > supporting .text randomization at all.
> > 
> > Based on original patch by H.J. Lu <hongjiu.lu@intel.com> and
> > Josh Boyer <jwboyer@redhat.com>
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Jiri Kosina <jkosina@suse.cz>
> > Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Cc: Russell King <rmk@arm.linux.org.uk>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> >  fs/binfmt_elf.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index dd0fdfc..bb11fe4 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -795,7 +795,10 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
> >  			 * might try to exec.  This is because the brk will
> >  			 * follow the loader, and is not movable.  */
> >  #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> > -			load_bias = 0;
> > +			if (current->flags & PF_RANDOMIZE)
> > +				load_bias = 0;
> > +			else
> > +				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> >  #else
> >  			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> >  #endif
> 
> Guys, it took several people several days and 10+ emails to work out
> what's happening in there, and the first attempt to fix it was buggy. 
> This is all a huuuuge signal that the code is unobvious, hard to
> understand, hard to maintain.

It's unfortunately true. Rewriting the ELF binary loader is on my list of 
very-long-term TODOs. It has became quite a monster over decades.

> Please, let's get a good code comment in there while it's fresh in your 
> minds.  So the next person who comes along doesn't have the same amount 
> of difficulty?

I have to run now, I will resend the patch to you with an explanatory 
comment added in about 8 hours from now.

Thanks,

-- 
Jiri Kosina
SUSE Labs
