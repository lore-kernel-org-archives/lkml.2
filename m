Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1CKCF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:05:57 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:51291 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1CKCF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:05:56 -0500
Date: Fri, 11 Mar 2011 03:05:40 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] jump label: introduce static_branch() interface
Message-ID: <20110311020540.GA26622@linux-mips.org>
References: <cover.1299702291.git.jbaron@redhat.com>
 <49b4727c7bfee19c2b7284b3339076ed827f3142.1299702291.git.jbaron@redhat.com>
 <1299790616.15854.417.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299790616.15854.417.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 03:56:56PM -0500, Steven Rostedt wrote:

> On Wed, 2011-03-09 at 15:47 -0500, Jason Baron wrote:
> 
> >  arch/mips/include/asm/jump_label.h  |   22 +-
> >  arch/mips/kernel/jump_label.c       |    2 +-
> >  arch/sparc/include/asm/jump_label.h |   25 +-
> >  arch/x86/include/asm/alternative.h  |    3 +-
> >  arch/x86/include/asm/jump_label.h   |   26 +-
> >  arch/x86/kernel/alternative.c       |    2 +-
> >  arch/x86/kernel/jump_label.c        |    2 +-
> >  arch/x86/kernel/module.c            |    1 +
> >  include/asm-generic/vmlinux.lds.h   |   14 +-
> >  include/linux/dynamic_debug.h       |    2 -
> >  include/linux/jump_label.h          |   86 ++++---
> >  include/linux/jump_label_ref.h      |   44 ---
> >  include/linux/perf_event.h          |   26 +-
> >  include/linux/tracepoint.h          |   22 +-
> >  kernel/jump_label.c                 |  537 ++++++++++++++---------------------
> >  kernel/perf_event.c                 |    4 +-
> >  kernel/tracepoint.c                 |   23 +-
> >  17 files changed, 352 insertions(+), 489 deletions(-)
> >  delete mode 100644 include/linux/jump_label_ref.h
> > 
> > diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
> > index 7622ccf..1881b31 100644
> > --- a/arch/mips/include/asm/jump_label.h
> > +++ b/arch/mips/include/asm/jump_label.h
> > @@ -20,16 +20,18 @@
> >  #define WORD_INSN ".word"
> >  #endif
> >  
> > -#define JUMP_LABEL(key, label)						\
> > -	do {								\
> > -		asm goto("1:\tnop\n\t"					\
> > -			"nop\n\t"					\
> > -			".pushsection __jump_table,  \"a\"\n\t"		\
> > -			WORD_INSN " 1b, %l[" #label "], %0\n\t"		\
> > -			".popsection\n\t"				\
> > -			: :  "i" (key) :  : label);			\
> > -	} while (0)
> > -
> > +static __always_inline bool arch_static_branch(struct jump_label_key *key)
> > +{
> > +	asm goto("1:\tnop\n\t"
> > +		"nop\n\t"
> > +		".pushsection __jump_table,  \"aw\"\n\t"
> > +		WORD_INSN " 1b, %l[l_yes], %0\n\t"
> > +		".popsection\n\t"
> > +		: :  "i" (key) : : l_yes);
> > +	return false;
> > +l_yes:
> > +	return true;
> > +}
> >  
> >  #endif /* __KERNEL__ */
> >  
> > diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
> > index 6001610..09ac7ca 100644
> > --- a/arch/mips/kernel/jump_label.c
> > +++ b/arch/mips/kernel/jump_label.c
> > @@ -6,11 +6,11 @@
> >   * Copyright (c) 2010 Cavium Networks, Inc.
> >   */
> >  
> > -#include <linux/jump_label.h>
> >  #include <linux/kernel.h>
> >  #include <linux/memory.h>
> >  #include <linux/mutex.h>
> >  #include <linux/types.h>
> > +#include <linux/jump_label.h>
> >  #include <linux/cpu.h>
> >  
> >  #include <asm/cacheflush.h>
> 
> Hi Ralf,
> 
> Can I get your Acked-by on this patch.

You could have gotten it quicker if I had been on cc ...

I'm happy with the change to arch/mips/include/asm/jump_label.h and
assuming that the change to arch/mips/kernel/jump_label.c will be dropped

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
