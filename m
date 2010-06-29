Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0F2BTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 21:19:06 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42355 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab0F2BTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 21:19:03 -0400
Content-Type: text/plain; charset=UTF-8
Cc: Jason Baron <jbaron@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>, Ingo Molnar <mingo@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 01/40] ftrace syscalls: don't add events for unmapped syscalls
From: Ian Munsie <imunsie@au1.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
In-reply-to: <1277305339.9181.33.camel@gandalf.stny.rr.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com> <1277287401-28571-2-git-send-email-imunsie@au1.ibm.com> <1277305339.9181.33.camel@gandalf.stny.rr.com>
Date: Tue, 29 Jun 2010 11:18:38 +1000
Message-Id: <1277773447-sup-8783@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Steven Rostedt's message of Thu Jun 24 01:02:19 +1000 2010:
> > diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> > index 34e3580..82246ce 100644
> > --- a/kernel/trace/trace_syscalls.c
> > +++ b/kernel/trace/trace_syscalls.c
> > @@ -431,6 +431,14 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
> >  int init_syscall_trace(struct ftrace_event_call *call)
> >  {
> >      int id;
> > +    int num;
> > +
> > +    num = ((struct syscall_metadata *)call->data)->syscall_nr;
> > +    if (num < 0 || num >= NR_syscalls) {
> > +        pr_debug("syscall %s metadata not mapped, disabling ftrace event\n",
> > +                ((struct syscall_metadata *)call->data)->name);
> > +        return -ENOSYS;
> > +    }
> 
> Perhaps this should be:
> 
>     if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls)
>         return -ENOSYS;
> 
> -- Steve


Hi Steven,

I don't think this should produce a warning - it signifies that a
syscall defined in the code has not successfully matched a syscall at
boot.

That may signify the matching failed, but it may just as likely signify
that the syscall isn't used on that arch (for instance, if an arch uses
an arch specific implementation in favour of a generic implementation,
or doesn't implement a particular syscall at all that is defined in the
generic code).

The problem case is actually the other way around - when a syscall
number from an arch's syscall table has not successfully mapped to some
syscall meta-data. Patch #37 prints out those cases with KERN_DEBUG so
booting a kernel with loglevel=8 can track them down.

This pr_debug may still be useful, for example to help locate unused
syscalls which can be removed if no arch uses them.

Cheers,
-Ian
