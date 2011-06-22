Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab1FVPDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:03:17 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52516 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab1FVPDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:03:16 -0400
Date: Wed, 22 Jun 2011 20:24:24 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 14/22] 14: x86: uprobes exception
 notifier for x86.
Message-ID: <20110622145424.GG16471@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607130101.28590.99984.sendpatchset@localhost6.localdomain6>
 <1308663084.26237.145.camel@twins>
 <1308663167.26237.146.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1308663167.26237.146.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-06-21 15:32:47]:

> On Tue, 2011-06-21 at 15:31 +0200, Peter Zijlstra wrote:
> > On Tue, 2011-06-07 at 18:31 +0530, Srikar Dronamraju wrote:
> > > @@ -844,6 +845,19 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
> > >         if (thread_info_flags & _TIF_SIGPENDING)
> > >                 do_signal(regs);
> > >  
> > > +       if (thread_info_flags & _TIF_UPROBE) {
> > > +               clear_thread_flag(TIF_UPROBE);
> > > +#ifdef CONFIG_X86_32
> > > +               /*
> > > +                * On x86_32, do_notify_resume() gets called with
> > > +                * interrupts disabled. Hence enable interrupts if they
> > > +                * are still disabled.
> > > +                */
> > > +               local_irq_enable();
> > > +#endif
> > > +               uprobe_notify_resume(regs);
> > > +       } 
> > 
> > Would it make sense to do TIF_UPROBE before TIF_SIGPENDING? That way
> > when uprobe decides it ought to have send a signal we don't have to do
> > another loop through all this.
> 

Okay, 

> 
> Also, it might be good to unify x86_86 and i386 on the interrupt thing,
> instead of propagating this difference (unless of course there's a good
> reason they're different, but I really don't know this code well).

I am not sure if this has changed lately. So I will try removing the
local_irq_enable. 

Oleg, Roland, do you know why do_notify_resume() gets called with
interrupts disabled on i386? 

-- 
Thanks and Regards
Srikar
