Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829Ab2HPPZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:25:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2HPPZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:25:01 -0400
Date: Thu, 16 Aug 2012 17:21:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/2] powerpc: Uprobes port to powerpc
Message-ID: <20120816152112.GA8874@redhat.com>
References: <20120726051902.GA29466@in.ibm.com> <20120726052029.GB29466@in.ibm.com> <20120815165931.GA10059@redhat.com> <1345066913.11751.4.camel@pasglop> <20120816050030.GA12060@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816050030.GA12060@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Ananth N Mavinakayanahalli wrote:
>
> On Thu, Aug 16, 2012 at 07:41:53AM +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2012-08-15 at 18:59 +0200, Oleg Nesterov wrote:
> > > On 07/26, Ananth N Mavinakayanahalli wrote:
> > > >
> > > > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > > >
> > > > This is the port of uprobes to powerpc. Usage is similar to x86.
> > >
> > > I am just curious why this series was ignored by powerpc maintainers...
> >
> > Because it arrived too late for the previous merge window considering my
> > limited bandwidth for reviewing things and that nobody else seems to
> > have reviewed it :-)
> >
> > It's still on track for the next one, and I'm hoping to dedicate most of
> > next week going through patches & doing a powerpc -next.
>
> Thanks Ben!

Great!

> > > Just one question... Shouldn't arch_uprobe_pre_xol() forbid to probe
> > > UPROBE_SWBP_INSN (at least) ?
> > >
> > > (I assume that emulate_step() can't handle this case but of course I
> > >  do not understand arch/powerpc/lib/sstep.c)
> > >
> > > Note that uprobe_pre_sstep_notifier() sets utask->state = UTASK_BP_HIT
> > > without any checks. This doesn't look right if it was UTASK_SSTEP...
> > >
> > > But again, I do not know what powepc will actually do if we try to
> > > single-step over UPROBE_SWBP_INSN.
> >
> > Ananth ?
>
> set_swbp() will return -EEXIST to install_breakpoint if we are trying to
> put a breakpoint on UPROBE_SWBP_INSN.

not really, this -EEXIST (already removed by recent changes) means that
bp was already installed.

But this doesn't matter,

> So, the arch agnostic code itself
> takes care of this case...

Yes. I forgot about install_breakpoint()->is_swbp_insn() check which
returns -ENOTSUPP, somehow I thought arch_uprobe_analyze_insn() does
this.

> or am I missing something?

No, it is me.

> However, I see that we need a powerpc specific is_swbp_insn()
> implementation since we will have to take care of all the trap variants.

Hmm, I am not sure. is_swbp_insn(insn), as it is used in the arch agnostic
code, should only return true if insn == UPROBE_SWBP_INSN (just in case,
this logic needs more fixes but this is offtopic).

If powerpc has another insn(s) which can trigger powerpc's do_int3()
counterpart, they should be rejected by arch_uprobe_analyze_insn().
I think.

> I will need to update the patches based on changes being made by Oleg
> and Sebastien for the single-step issues.

Perhaps you can do this in a separate change?

We need some (simple) changes in the arch agnostic code first, they
should not break poweppc. These changes are still under discussion.
Once we have "__weak  arch_uprobe_step*" you can reimplement these
hooks and fix the problems with single-stepping.

Oleg.

