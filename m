Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1A0KV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:21:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:49070 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1A0KVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:21:55 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 13/20] 13: x86: x86 specific probe
 handling
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Roland McGrath <roland@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20110127094041.GR19725@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095947.23751.75003.sendpatchset@localhost6.localdomain6>
	 <1295963783.28776.1061.camel@laptop>
	 <20110127094041.GR19725@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 11:22:13 +0100
Message-ID: <1296123733.15234.53.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 15:10 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2011-01-25 14:56:22]:
> 
> > On Thu, 2010-12-16 at 15:29 +0530, Srikar Dronamraju wrote:
> > > 
> > > +void arch_uprobe_enable_sstep(struct pt_regs *regs)
> > > +{
> > > +       /*
> > > +        * Enable single-stepping by
> > > +        * - Set TF on stack
> > > +        * - Set TIF_SINGLESTEP: Guarantees that TF is set when
> > > +        *      returning to user mode.
> > > +        *  - Indicate that TF is set by us.
> > > +        */
> > > +       regs->flags |= X86_EFLAGS_TF;
> > > +       set_thread_flag(TIF_SINGLESTEP);
> > > +       set_thread_flag(TIF_FORCED_TF);
> > > +}
> > > +
> > > +void arch_uprobe_disable_sstep(struct pt_regs *regs)
> > > +{
> > > +       /* Disable single-stepping by clearing what we set */
> > > +       clear_thread_flag(TIF_SINGLESTEP);
> > > +       clear_thread_flag(TIF_FORCED_TF);
> > > +       regs->flags &= ~X86_EFLAGS_TF;
> > > +} 
> > 
> > Why not use the code from arch/x86/kernel/step.c?
> 
> user_enable_single_step and user_disable_single_step that are
> defined in arch/x86/kernel/step.c cant be called in interrupt context.

Right, because of is_setting_trap_flag()..

> Initially we were looking at enabling/disabling singlestep in
> interrupt context. Even now we disable singlestep in post notifier in
> interrupt context.
> 
> Though  arch/x86/kernel/step.c has a static function
> enable_single_step which is identical to arch_uprobe_enable_sstep;
> there is no equivalent function for arch_uprobe_disable_sstep.

Its not even close to identical, its very careful to deal with user-mode
already doing single step.

But I'll leave this to the x86 people who actually know the intricacies
of the single step cruft, I was just wondering why you weren't using (or
extending) the existing code.
