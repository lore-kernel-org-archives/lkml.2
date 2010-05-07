Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0EGCYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 22:24:14 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47806 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab0EGCYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 22:24:12 -0400
Date: Fri, 7 May 2010 07:54:03 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 10/10] perf: perf interface for uprobes.
Message-ID: <20100507022403.GH7426@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
 <20100506180340.28877.25709.sendpatchset@localhost6.localdomain6>
 <4BE34D1D.2020100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4BE34D1D.2020100@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Could you also rebase your patch on the latest tip tree? :)
> (and remove die() too)

I was aware that I have to rebase the patch to the latest tip.
However I wanted to get a working set out.
Please expect the rebased version in the next version of the posting.

> 
> > Here is a terminal snapshot of placing, using and removing a probe on a
> > process with pid 3329 (corresponding to zsh)
> > 
> > [ Probing a function in the executable using function name  ]
> > -------------------------------------------------------------
> > [root@ABCD]# perf probe -p 3329 zfree@zsh
> 
> Hmm, I'm not sure why we have to specify both of PID and exec name.
> Is that possible to give a symbol as below? (omit exec name)
> 
> # perf probe -p 3329 zfree

Yes, If the symbol name belongs to th execfile then we can omit the
execfile part. However for symbols outside the execname, the
execfile(library file) is a must(atleast for now).

> 
> > Added new event:
> >   probe:p_3329_zfree                       (on 0x446420)
> 
> Hmm, the event name should be simpler, as like as zfree_3329.
> or, we might better make a new event group for each process, as like as
> 'probe_3329:zfree'
> 

Either zfree_3329 or having a new event group for each process is
possible.

> 
> 
> Hmm, if user gave --list with -p, what happened?
> We need to check a bad combination and warn it.
> 

Currently it would ignore -p option. i.e --list overrides.
We could either warn, or error out. What do you suggest?

> >  
> > +	if (session.pid)
> > +		goto end_dwarf;
> > +
> 
> Again, it must be checked that the combination of -p option and dwarf requirement.
> The latest code has perf_probe_event_need_dwarf(), so you can check it easier.
> 

Okay, 

> [...]
> > +	else
> > +		free(pp->function);
> > +	pp->function = zalloc(sizeof(char *) * 20);
> > +	if (!pp->function)
> > +		die("Failed to allocate memory by zalloc.");
> > +	e_snprintf(pp->function, 20, "0x%llx", vaddr);
> > +}
> 
> Well, after rebasing, you'll need to remove die()s from here and
> make it returns errors. 
> 

Okay. 


> [...]
> > @@ -383,7 +450,11 @@ int synthesize_trace_kprobe_event(struct probe_point *pp)
> >  	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
> >  	if (!buf)
> >  		die("Failed to allocate memory by zalloc.");
> > -	ret = e_snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
> > +	if (pp->offset)
> > +		ret = e_snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function,
> > +					pp->offset);
> > +	else
> > +		ret = e_snprintf(buf, MAX_CMDLEN, "%s", pp->function);
> >  	if (ret <= 0)
> >  		goto error;
> >  	len = ret;
> 
> Isn't it a cleanup ?

Can you please elaborate?

> 
> > +void add_trace_uprobe_events(struct probe_point *probes, int nr_probes,
> > +			     bool force_add, pid_t pid)
> > +{
> > +	int fd = open_uprobe_events(O_RDWR, O_APPEND);
> > +	add_trace_probe_events(fd, probes, nr_probes, force_add, pid);
> > +}
> 
> Please close fd in the function which opened it.
> 

Okay.

> 
> >  	memset(&sym, 0, sizeof(sym));
> > -	if (!self->kernel) {
> > +	if (self->kernel || symbol_conf.sort_by_name)
> > +		self->adjust_symbols = 0;
> > +	else {
> >  		self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
> >  				elf_section_by_name(elf, &ehdr, &shdr,
> >  						     ".gnu.prelink_undo",
> >  						     NULL) != NULL);
> > -	} else self->adjust_symbols = 0;
> > +	}
> >  
> >  	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
> >  		struct symbol *f;
> 
> This one changes the symbol.c, so I think you'd better make a
> separate patch for this change.

Okay, I will separate it in the next version.
Thanks Masami for the review.

--
Thanks and Regards
Srikar
