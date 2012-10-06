Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2JFRYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 13:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab2JFRYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 13:24:08 -0400
Date: Sat, 6 Oct 2012 19:25:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] uprobes: Fix handle_swbp() vs unregister() +
	register() race
Message-ID: <20121006172531.GB9819@redhat.com>
References: <20120930194119.GA11278@redhat.com> <20120930194211.GA11333@redhat.com> <20121006093311.GB9145@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121006093311.GB9145@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-09-30 21:42:11]:
>
> > @@ -1391,6 +1392,16 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
> >  	if (!uprobe && test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags))
> >  		mmf_recalc_uprobes(mm);
> >  	up_read(&mm->mmap_sem);
> > +	/*
> > +	 * TODO: move copy_insn/etc into _register and remove this hack.
> > +	 * After we hit the bp, _unregister + _register can install the
> > +	 * new and not-yet-analyzed uprobe at the same address, restart.
> > +	 */
> > +	smp_rmb(); /* pairs with wmb() in install_breakpoint() */
> > +	if (uprobe && unlikely(!(uprobe->flags & UPROBE_COPY_INSN))) {
> > +		uprobe = NULL;
> > +		*is_swbp = 0;
> > +	}
> >
> >  	return uprobe;
> >  }
>
> Should we be adding this check handle_swbp() around can_skip_step()?
>
> The earliest we access arch.insn is in can_skip_step. So we give some
> more time for the instruction to be copied.

handle_swbp:

	if (can_skip_sstep(uprobe, regs))
		goto out;

but if we hit a non-UPROBE_COPY_INSN uprobe, we need "goto restart".

> Also it will probably be a little cleaner, (Not having to drop a uprobe
> reference, not having to reset is_swbp.)

We can change handler_chain() (which also checks UPROBE_RUN_HANDLER)
to return "bool restart", not sure this will be more clean.

And if we change handler_chain(), I think it should return bitmask,

	for (uc = uprobe->consumers; uc; uc = uc->next)
		ret |= uc->handler(...);

	return ret;

for the future changes... (say, we can remove bp if consumers do not
want to trace this task). Not sure it makes sense to change it right
now.

So. Should I leave this patch as is? Or do you want me to move this
check into handler_chain() and make it return "bool restart"?

Oleg.

