Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab2B1Nx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:53:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34647 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab2B1Nx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:53:26 -0500
Date: Tue, 28 Feb 2012 14:52:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH] uprobes/core: handle breakpoint and signal step
 exception.
Message-ID: <20120228135251.GA8279@elte.hu>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
 <20120227091212.GA7092@elte.hu>
 <20120228132601.GC32211@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228132601.GC32211@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> > > Where possible, we check and skip singlestepping the 
> > > breakpointed instructions. For now we skip single byte as 
> > > well as few multibyte nop instructions. However this can 
> > > be extended to other instructions too.
> > 
> > Is this an optimization - allowing a NOP to be inserted for 
> > easy probe insertion?
> 
> Yes, Its an optimization by which we avoid singlestep 
> exception.

That would be nice to comment in the code - nowhere in the 
'skip' logic is this fact mentioned, and it's really useful 
information to pretty much anyone reading the code.

It's also a nice optimization, there's no need to obfuscate its 
existence.

> > > +	case DIE_INT3:
> > > +		/* Run your handler here */
> > > +		if (uprobe_bkpt_notifier(regs))
> > > +			ret = NOTIFY_STOP;
> > 
> > This comment looks somewhat out of place.
> > 
> > Also, I have not noticed this in the first patch, but 'bkpt' is 
> > not a standard way to refer to breakpoints: we either use 
> > 'breakpoint' or 'bp'.
> 
> This is again one of those things that I changed from bp to 
> bkpt based on LKML feedback. I am okay to go back to bp.

:-/ I can understand it somewhat, 'bp' also means other things.

'hwbp' is a common name - you could use 'swbp' which would pair 
with that nicely?

> > > +bool arch_uprobe_skip_sstep(struct pt_regs *regs, struct arch_uprobe *auprobe)
> > > +{
> > > +	int i;
> > > +
> > > +	for (i = 0; i < MAX_UINSN_BYTES; i++) {
> > > +		if ((auprobe->insn[i] == 0x66))
> > > +			continue;
> > > +
> > > +		if (auprobe->insn[i] == 0x90)
> > > +			return true;
> > > +
> > > +		if (i == (MAX_UINSN_BYTES - 1))
> > > +			break;
> > 
> > Looks like the loop could run from 0 to MAX_UINSN_BYTES-2 and 
> > then this break would be superfluous.
> > 
> 
> Even if we were to run from 0 to MAX_UINSN_BYTES - 2, we would 
> have to add extra code to handle 0x66* 0x90 (where 0x90 is 
> stored at index i == MAX_UINSN_BYTES - 1. So I would like to 
> keep this code as is.

Ok.

> > > +/*
> > > + * uprobe_task: Metadata of a task while it singlesteps.
> > > + */
> > > +struct uprobe_task {
> > > +	unsigned long xol_vaddr;
> > > +	unsigned long vaddr;
> > 
> > These two fields are never actually used outside of architecture 
> > code.
> > 
> > Unless there's a good reason to keep them outside I'd 
> > suggest to move them into struct arch_uprobe_task. This has 
> > another benefit: we can pass struct arch_uprobe_task to the 
> > architecture methods, instead of struct uprobe_task. This 
> > would allow the moving of the struct uprobe_task into 
> > uprobes.c - no code outside uprobes.c needs to know its 
> > structure.
> 
> The Xol layer(which is the next patch) uses them in arch 
> agnostic way. Also vaddr/xol_vaddr are populated/used in arch 
> agnostic way. We could still move them to arch_uprobe_task but 
> we will then have to ensure that every other arch defines them 
> the way uprobes understands.

Correct - and that still isolates the arch code from the core 
uprobes code.

We could also introduce 'struct generic_arch_uprobe_task' and 
embedd that inside arch_uprobe via a short field name, to make 
it easy to access: ->gen.field or so.

You can also leave it as-is for now, I'll reconsider how things 
look like with the patch following these bits and then make a 
new suggestion if I see a better way.

> > > +static inline unsigned long get_uprobe_bkpt_addr(struct pt_regs *regs)
> > > +{
> > > +	return 0;
> > > +}
> > 
> > Please use the standard uprobe method naming pattern for 
> > get_uprobe_bkpt_addr().
> 
> do you mean uprobe_get_bp_addr ?

Yeah, that sounds good.

> > > +/*
> > > + * There could be threads that have hit the breakpoint and are entering the
> > > + * notifier code and trying to acquire the uprobes_treelock. The thread
> > > + * calling delete_uprobe() that is removing the uprobe from the rb_tree can
> > > + * race with these threads and might acquire the uprobes_treelock compared
> > > + * to some of the breakpoint hit threads. In such a case, the breakpoint hit
> > > + * threads will not find the uprobe. Hence wait till the current breakpoint
> > > + * hit threads acquire the uprobes_treelock before the uprobe is removed
> > > + * from the rbtree.
> > 
> > Hm, the last sentence does not parse for me. (even if it's 
> > correct English it might make sense to rephrase it to be clearer 
> > what is meant.)
> > 
> 
> Would this be okay with you.
> 
> The current unregistering thread waits till all other threads 
> that have hit a breakpoint to acquire the uprobes_treelock 
> before the uprobe is removed from the rbtree.

s/is removed/are removed

?

If yes then indeed this reads better.

> [...]
>
> If the thread was not in the middle of a uprobe hit then we go 
> through the regular signal handling.
> 
> Since there is no way this thread can hit a uprobe once a 
> thread has entered get_signal_to_deliver(kernel code), I dont 
> see a reason to move it under relock:

Ok, fair enough.

Thanks,

	Ingo
