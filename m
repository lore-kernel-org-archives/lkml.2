Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2KTPsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:48:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab2KTPsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:48:05 -0500
Date: Tue, 20 Nov 2012 16:48:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Amnon Shiloh <u3557@miso.sublimeip.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch_check_bp_in_kernelspace: fix the range check
Message-ID: <20121120154824.GA17534@redhat.com>
References: <20121109182943.GA2789@redhat.com> <20121109183026.GA2719@redhat.com> <20121119174728.GA11365@redhat.com> <1353349500.6276.9.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353349500.6276.9.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Steven Rostedt wrote:
>
> On Mon, 2012-11-19 at 18:47 +0100, Oleg Nesterov wrote:
> >
> > Just I think Amnon has a point, shouldn't we change this change like below?
> > (on top of this fixlet).
> >
> > Oleg.
> >
> > --- x/arch/x86/kernel/hw_breakpoint.c
> > +++ x/arch/x86/kernel/hw_breakpoint.c
> > @@ -188,6 +188,11 @@ static int get_hbp_len(u8 hbp_len)
> >  	return len_in_bytes;
> >  }
> >
> > +static inline bool bp_in_gate(unsigned long start, unsigned long end)
> > +{
> > +	return in_gate_area_no_mm(start) && in_gate_area_no_mm(end);
> > +}
> > +
> >  /*
> >   * Check for virtual address in kernel space.
> >   */
> > @@ -200,7 +205,8 @@ int arch_check_bp_in_kernelspace(struct
> >  	va = info->address;
> >  	len = get_hbp_len(info->len);
> >
> > -	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
> > +	return ((va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE)) &&
> > +		!bp_in_gate(va, va + len - 1);
>
> So we want to allow non privileged to add a breakpoint in a vsyscall
> area even if it happens to lay in kernel space?

Yes,

> Is this really what we want?

I am not sure, that is why I am asking.

Hmm... I have to admit, I didn't even know this code was completely
rewritten, and a long ago... and in the default mode it works via
emulate_vsyscall() from page-fault, iow not in user_mode().

> I mean, isn't syscall tracing in the kernel
> done by a flag set to the task's structure. If the task has a flag set,
> then it does the slow (ptrace) path which handles the breakpoint for the
> user.

Well yes, with the new implementation __vsyscall_page simply does
syscall, so I guess (say) strace will "just work". But, afaics, only
if vsyscall_mode == NATIVE.

So perhaps bp in vsyscall_page still makes sense...

> But here, there's no prejudice between tasks. All tasks will now hit the
> breakpoint regardless of if it is being traced or not.
  ^^^^^^^^^^

This is hardware breakpoint, it is per-task.

Oleg.

