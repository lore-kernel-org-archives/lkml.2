Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab1FUNdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:33:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:40018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab1FUNdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:33:54 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 14/22] 14: x86: uprobes exception
 notifier for x86.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <1308663084.26237.145.camel@twins>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607130101.28590.99984.sendpatchset@localhost6.localdomain6>
	 <1308663084.26237.145.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Jun 2011 15:32:47 +0200
Message-ID: <1308663167.26237.146.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 15:31 +0200, Peter Zijlstra wrote:
> On Tue, 2011-06-07 at 18:31 +0530, Srikar Dronamraju wrote:
> > @@ -844,6 +845,19 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
> >         if (thread_info_flags & _TIF_SIGPENDING)
> >                 do_signal(regs);
> >  
> > +       if (thread_info_flags & _TIF_UPROBE) {
> > +               clear_thread_flag(TIF_UPROBE);
> > +#ifdef CONFIG_X86_32
> > +               /*
> > +                * On x86_32, do_notify_resume() gets called with
> > +                * interrupts disabled. Hence enable interrupts if they
> > +                * are still disabled.
> > +                */
> > +               local_irq_enable();
> > +#endif
> > +               uprobe_notify_resume(regs);
> > +       } 
> 
> Would it make sense to do TIF_UPROBE before TIF_SIGPENDING? That way
> when uprobe decides it ought to have send a signal we don't have to do
> another loop through all this.


Also, it might be good to unify x86_86 and i386 on the interrupt thing,
instead of propagating this difference (unless of course there's a good
reason they're different, but I really don't know this code well).
