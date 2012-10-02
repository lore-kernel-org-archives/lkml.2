Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2JBQHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab2JBQG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:06:59 -0400
Date: Tue, 2 Oct 2012 18:06:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCHv2] perf x86_64: Fix rsp register for system call fast path
Message-ID: <20121002160626.GA26598@krava.brq.redhat.com>
References: <1349112712-2590-1-git-send-email-jolsa@redhat.com>
 <1349174644.7780.23.camel@twins>
 <20121002145815.GH6379@krava.brq.redhat.com>
 <20121002154914.GC10605@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002154914.GC10605@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 05:49:26PM +0200, Frederic Weisbecker wrote:
> On Tue, Oct 02, 2012 at 04:58:15PM +0200, Jiri Olsa wrote:
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 915b876..11d62ff 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -34,6 +34,7 @@
> >  #include <asm/timer.h>
> >  #include <asm/desc.h>
> >  #include <asm/ldt.h>
> > +#include <asm/syscall.h>
> >  
> >  #include "perf_event.h"
> >  
> > @@ -1699,6 +1700,52 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
> >  	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
> >  }
> >  
> > +#ifdef CONFIG_X86_64
> > +__weak int arch_sample_regs_user(struct pt_regs *oregs, struct pt_regs *regs)
> > +{
> > +	int kernel = !user_mode(regs);
> > +
> > +	if (kernel) {
> > +		if (current->mm)
> > +			regs = task_pt_regs(current);
> > +		else
> > +			regs = NULL;
> > +	}
> 
> Shouldn't the above stay in generic code?

could be.. I guess I thought that having the regs retrieval
plus the fixup at the same place feels better/compact ;)

but could change that if needed

SNIP

> 
> That said, a race is there already: if the syscall is interrupted before
> SAVE_ARGS and co.

yep

> 
> I'm trying to scratch my head to find a solution to detect the race and
> bail out instead of recording erroneous values but I can't find one.
> 
> Anyway this is still better than what we have now.
> 
> Another solution could be to force syscall slow path and have some variable
> set there that tells us we are in a syscall and every regs have been saved.
> 
> But we probably don't want to force syscall slow path...

I was trying something like that as well, but the one I sent looks
far less hacky to me.. :)

jirka
