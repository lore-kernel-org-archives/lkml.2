Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab1JCQC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:02:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:15078 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab1JCQCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:02:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,480,1312182000"; 
   d="scan'208";a="22826051"
From: "Lu, Hongjiu" <hongjiu.lu@intel.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>, Jiri Kosina <jkosina@suse.cz>
CC: Josh Boyer <jwboyer@redhat.com>, Andrew Morton <akpm00@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>
Date: Mon, 3 Oct 2011 09:02:47 -0700
Subject: RE: [PATCH v2] binfmt_elf: Fix PIE execution with randomization
 disabled (was Re: [RFC PATCH] binfmt_elf: Fix PIE execution with
 randomization disabled)
Thread-Topic: [PATCH v2] binfmt_elf: Fix PIE execution with randomization
 disabled (was Re: [RFC PATCH] binfmt_elf: Fix PIE execution with
 randomization disabled)
Thread-Index: AcyB5RG81F6M1WAtQhqrtYrQNdQoAAAAHptQ
Message-ID: <9DA5872FEF993D41B7173F58FCF6BE94E0906494@orsmsx504.amr.corp.intel.com>
References: <20110929195359.GJ16720@zod.bos.redhat.com>
 <20110929141929.43df799d.akpm00@gmail.com>
 <alpine.LFD.2.02.1109291958210.9106@xanadu.home>
 <20110930021629.GL16720@zod.bos.redhat.com>
 <alpine.LNX.2.00.1110031651400.31654@pobox.suse.cz>
 <20111003150345.GP16720@zod.bos.redhat.com>
 <alpine.LNX.2.00.1110031709230.31654@pobox.suse.cz>
 <alpine.LFD.2.02.1110031150470.9106@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1110031150470.9106@xanadu.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why not

#if defined(CONFIG_X86) || defined(CONFIG_ARM)
#define CHECK_PF_RANDOMIZE 1
#else
#define CHECK_PF_RANDOMIZE 0
#endif
			if (CHECK_PF_RANDOMIZE && (current->flags & PF_RANDOMIZE))
				load_bias = 0;
			else
				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);

H.J.

> -----Original Message-----
> From: Nicolas Pitre [mailto:nicolas.pitre@linaro.org]
> Sent: Monday, October 03, 2011 8:56 AM
> To: Jiri Kosina
> Cc: Josh Boyer; Andrew Morton; Ingo Molnar; Lu, Hongjiu; linux-
> kernel@vger.kernel.org; Andrew Morton; Russell King
> Subject: Re: [PATCH v2] binfmt_elf: Fix PIE execution with randomization
> disabled (was Re: [RFC PATCH] binfmt_elf: Fix PIE execution with randomization
> disabled)
> 
> On Mon, 3 Oct 2011, Jiri Kosina wrote:
> 
> > How about the patch below instead? It survives my testing, and I believe
> > it handles both cases properly.
> >
> > Confirmation from the original bug reporter would obviously be a nice
> > bonus too :)
> >
> >
> >
> >
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
> 
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> 
> However I'd suggest a change to deal with style issues:
> 
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index dd0fdfc..bb11fe4 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -795,7 +795,10 @@ static int load_elf_binary(struct linux_binprm *bprm,
> struct pt_regs *regs)
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
> What about this instead, saving 3 lines out of 8:
> 
> 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> 			if (current->flags & PF_RANDOMIZE)
> 				load_bias = 0;
> #endif
> 
> 
> ?
> 
> 
> Nicolas
