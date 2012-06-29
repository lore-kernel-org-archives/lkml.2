Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2F2IEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 04:04:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab2F2IEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 04:04:16 -0400
Date: Fri, 29 Jun 2012 10:03:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC 09/23] x86_64: Store userspace rsp in system_call fastpath
Message-ID: <20120629080327.GE940@krava.brq.redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
 <1340120894-9465-10-git-send-email-jolsa@redhat.com>
 <20120628120846.GA28527@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628120846.GA28527@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 02:08:49PM +0200, Frederic Weisbecker wrote:
> On Tue, Jun 19, 2012 at 05:48:00PM +0200, Jiri Olsa wrote:
> > hi,
> > I'd need help with this change.. basically it works, but I guess
> > I could alter the FIXUP_TOP_OF_STACK macro as well, so the rsp is
> > not initialized twice in slowpath.
> > 
> > But it seems quite complex.. so not really sure at the moment ;)
> > 
> > ideas?
> > 
> > thanks,
> > jirka
> > 
> > ---
> > Storing the userspace rsp into the pt_regs struct for the
> > system_call fastpath (syscall instruction handler).
> > 
> > Following part of the pt_regs is allocated on stack:
> > (via KERNEL_STACK_OFFSET)
> > 
> >     unsigned long ip;
> >     unsigned long cs;
> >     unsigned long flags;
> >     unsigned long sp;
> >     unsigned long ss;
> > 
> > but only ip is actually saved for fastpath.
> > 
> > For perf post unwind we need at least ip and sp to be able to
> > start the unwind, so storing the old_rsp value to the sp.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Roland McGrath <roland@hack.frob.com>
> > ---
> >  arch/x86/kernel/entry_64.S |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index 111f6bb..0444917 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -516,6 +516,11 @@ GLOBAL(system_call_after_swapgs)
> >  	SAVE_ARGS 8,0
> >  	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
> >  	movq  %rcx,RIP-ARGOFFSET(%rsp)
> > +#ifdef CONFIG_PERF_EVENTS
> > +	/* We need rsp in fast path for perf post unwind. */
> > +	movq  PER_CPU_VAR(old_rsp), %rcx
> > +	movq  %rcx,RSP-ARGOFFSET(%rsp)
> > +#endif
> 
> Another solution is to set/unset some TIF flag in perf_event_sched_in/out
> such that we take the syscall slow path (tracesys) which records every non-scratch
> registers. I can see that old_rsp is not saved in pt_regs by SAVE_REST so this may be
> something to add in tracesys.
> 
> This way we don't bloat the syscall fastpath with a feature only used by some
> developers.

ok, this could work for task related events

but will need to think about how to do this for cpu related events which
hit the same issue and we dont have a task to flag.. maybe do it the same
way as for TIF_SYSCALL_TRACEPOINT and flag everyone ;)

jirka
