Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab0FOLzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:55:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757519Ab0FOLzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:55:10 -0400
Date: Tue, 15 Jun 2010 13:51:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 7/14] x86 support for Uprobes
Message-ID: <20100615115155.GA4831@redhat.com>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6> <20100614082913.29068.86825.sendpatchset@localhost6.localdomain6> <20100614175423.GG23754@infradead.org> <20100615062332.GE13800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615062332.GE13800@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15, Srikar Dronamraju wrote:
>
> * Christoph Hellwig <hch@infradead.org> [2010-06-14 13:54:23]:
>
> > On Mon, Jun 14, 2010 at 01:59:13PM +0530, Srikar Dronamraju wrote:
> > > @@ -850,7 +850,19 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
> > >
> > >  	if (thread_info_flags & _TIF_UPROBE) {
> > >  		clear_thread_flag(TIF_UPROBE);
> > > +#ifdef CONFIG_X86_32
> > > +		/*
> > > +		 * On x86_32, do_notify_resume() gets called with
> > > +		 * interrupts disabled. Hence enable interrupts if they
> > > +		 * are still disabled.
> > > +		 */
> > > +		native_irq_enable();
> > > +#endif
> > >  		uprobe_notify_resume(regs);
> > > +
> > > +#ifdef CONFIG_X86_32
> > > +		native_irq_disable();
> > > +#endif
> >
> > I'm no x86 port guru, but this looks rather worriesome to me.  Why does
> > do_notify_resume have different calling conventions on 32 vs 64-bit?
> > And if there is a good reason that 32-bit has them disabled, why is
> > enabling them in the middle of do_notify_resume okay?
>
> Thanks for bringing this up. I have no idea about why do_notify_resume()
> gets called with interrupts disabled in 32 bit.

Perhaps just because there is no reason to explicitly enable irqs?

> I would be happy to know
> the reason and rework based on inputs. I did query a few people about
> this but I havent got an answer on why we they are disabled on 32 bit and
> if its Okay to enable at this place.

I think it is OK to enable interrupts. do_notify_resume() calls do_signal()
which enables them anyway.

But there is another question I already asked. Why the code uses
native_irq_enable()? IIRC, you explained that local_irq_enable() doesn't
work for unkown reason. This is strange, and imho should be explained.

And I do not see a need to disable irqs again.

Oleg.

