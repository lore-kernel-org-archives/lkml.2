Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2B1OUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:20:05 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:35613 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab2B1OUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:20:01 -0500
Date: Tue, 28 Feb 2012 19:47:43 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20120228141743.GA32472@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
 <20120227091212.GA7092@elte.hu>
 <20120228132601.GC32211@linux.vnet.ibm.com>
 <20120228135251.GA8279@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120228135251.GA8279@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022814-5518-0000-0000-000002914422
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2012-02-28 14:52:51]:

> 
> * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
> 
> > > > Where possible, we check and skip singlestepping the 
> > > > breakpointed instructions. For now we skip single byte as 
> > > > well as few multibyte nop instructions. However this can 
> > > > be extended to other instructions too.
> > > 
> > > Is this an optimization - allowing a NOP to be inserted for 
> > > easy probe insertion?
> > 
> > Yes, Its an optimization by which we avoid singlestep 
> > exception.
> 
> That would be nice to comment in the code - nowhere in the 
> 'skip' logic is this fact mentioned, and it's really useful 
> information to pretty much anyone reading the code.
> 
> It's also a nice optimization, there's no need to obfuscate its 
> existence.


okay, Will add. 

> 
> > > > +	case DIE_INT3:
> > > > +		/* Run your handler here */
> > > > +		if (uprobe_bkpt_notifier(regs))
> > > > +			ret = NOTIFY_STOP;
> > > 
> > > This comment looks somewhat out of place.
> > > 
> > > Also, I have not noticed this in the first patch, but 'bkpt' is 
> > > not a standard way to refer to breakpoints: we either use 
> > > 'breakpoint' or 'bp'.
> > 
> > This is again one of those things that I changed from bp to 
> > bkpt based on LKML feedback. I am okay to go back to bp.
> 
> :-/ I can understand it somewhat, 'bp' also means other things.
> 
> 'hwbp' is a common name - you could use 'swbp' which would pair 
> with that nicely?
> 

Okay.
However most of these functions call are called from within uprobes.c
and have a uprobe prefix. So there is enough context for people to link
bp to breakpoint.

> 
> Correct - and that still isolates the arch code from the core 
> uprobes code.
> 
> We could also introduce 'struct generic_arch_uprobe_task' and 
> embedd that inside arch_uprobe via a short field name, to make 
> it easy to access: ->gen.field or so.
> 
> You can also leave it as-is for now, I'll reconsider how things 
> look like with the patch following these bits and then make a 
> new suggestion if I see a better way.
> 

Will leave this as-is for now and wait for your suggestions.

> 
> > > > +/*
> > > > + * There could be threads that have hit the breakpoint and are entering the
> > > > + * notifier code and trying to acquire the uprobes_treelock. The thread
> > > > + * calling delete_uprobe() that is removing the uprobe from the rb_tree can
> > > > + * race with these threads and might acquire the uprobes_treelock compared
> > > > + * to some of the breakpoint hit threads. In such a case, the breakpoint hit
> > > > + * threads will not find the uprobe. Hence wait till the current breakpoint
> > > > + * hit threads acquire the uprobes_treelock before the uprobe is removed
> > > > + * from the rbtree.
> > > 
> > > Hm, the last sentence does not parse for me. (even if it's 
> > > correct English it might make sense to rephrase it to be clearer 
> > > what is meant.)
> > > 
> > 
> > Would this be okay with you.
> > 
> > The current unregistering thread waits till all other threads 
> > that have hit a breakpoint to acquire the uprobes_treelock 
> > before the uprobe is removed from the rbtree.
> 
> s/is removed/are removed
> 
> ?
> 

At a time, we are unregistering just one probe,(atleast for now.)
Wondering if "before uprobes are remove from rbtree." sounds as if more
than one uprobe is being removed at one instance.

> If yes then indeed this reads better.
> 
> > [...]
> >
> > If the thread was not in the middle of a uprobe hit then we go 
> > through the regular signal handling.
> > 
> > Since there is no way this thread can hit a uprobe once a 
> > thread has entered get_signal_to_deliver(kernel code), I dont 
> > see a reason to move it under relock:
> 
> Ok, fair enough.
> 
Okay,

-- 
Thanks and Regards
Srikar

