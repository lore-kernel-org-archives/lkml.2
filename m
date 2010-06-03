Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0FCUuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:50:16 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58336 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0FCUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kn+tnls7FfgV8NCSH6wYI3rAojbDRISlkN8cS6zlOlKHmpBt1cUoScPQ57rRR1zEWi
         u1LpuOxxk0PXp5IILBy5EViKzircUgddrOkkmPx95tl0ul4+fACHFhtbLYCS41Gl8K4z
         X7xavw/JWE56n9C9OBDHWhVbcvjc4I0CzEsjY=
Date: Thu, 3 Jun 2010 22:50:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: make save_stack_address()
	!CONFIG_FRAME_POINTER friendly
Message-ID: <20100603205018.GF5234@nowhere>
References: <20100603193239.GA31530@redhat.com> <4C080850.1090907@linux.intel.com> <20100603200655.GE5234@nowhere> <20100603203155.GA1163@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603203155.GA1163@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:31:55PM +0200, Oleg Nesterov wrote:
> On 06/03, Frederic Weisbecker wrote:
> >
> > On Thu, Jun 03, 2010 at 12:53:52PM -0700, Arjan van de Ven wrote:
> > > On 6/3/2010 12:32 PM, Oleg Nesterov wrote:
> > >> If CONFIG_FRAME_POINTER=n, print_context_stack() shouldn't neglect the
> > >> non-reliable addresses on stack, this is all we have if dump_trace(bp)
> > >> is called with the wrong or zero bp.
> > >>
> > >> For example, /proc/pid/stack doesn't work if CONFIG_FRAME_POINTER=n.
> > >>
> > >> This patch obviously has no effect if CONFIG_FRAME_POINTER=y, otherwise
> > >> it reverts 1650743c "x86: don't save unreliable stack trace entries".
> > >
> > > would be nice if there was a compile time thing to detect if frame
> > > pointers are on ratehr than an ifdef.
> >
> > I wanted to suggest that too, but since only one place got the ifdef
> > after the second patch.
> >
> > But yeah, something like this could be reused:
> >
> > 	if (reliable_frame_pointer(reliable))
> > 		return ...;
> 
> Do you mean it makes sense to add the helper which depends on
> FRAME_POINTER ?



Having in asm/stacktrace.h:

#ifdef CONFIG_FRAME_POINTER
static inline int reliable_frame_pointer(int reliable)
{
	return reliable;
}
#else
static inline int reliable_frame_pointer(int reliable)
{
	return 1;
}
#endif


But if we have only one user I'm not sure it's worth it.


 
> > > you're now also changing the rules; until now, you would ALWAYS get a
> > > backtrace without noise....
> > > now that's changing quite a bit. How are various tools (like perf and
> > > sysprof) going to cope with that?
> >
> >
> >
> > perf and sysprof have their own stacktrace ops, so they aren't affected.
> > I think the rest is /proc/pid/task, lockdep, latencytop, ftrace, kmemleak,
> > etc...
> >
> > For the kernel parts it's in fact desired.
> > And with ftrace we are changing some rules, but this is desired too, without
> > frame pointers we would have nothing anyway. And it's quite easy to
> > find out a stacktrace is not entirely reliable at a glance.
> 
> Frederic, Arjan. Honestly, I have no opinion if this change makes
> things better or worse for, say, lockdep.
> 
> But note that this only affects the !CONFIG_FRAME_POINTER case.
> Looking into Kconfig's I don't even understand how the bug reporters
> managed to set CONFIG_STACKTRACE without !CONFIG_FRAME_POINTER.
> 
> So, should I redo this patch to fix /proc/pid/stack ? Say, we
> can change the meaning of stack_trace-<skip, if it is < 0, then
> save_stack_address() ignores reliable. Yes, this is hack.


No, people may want to ignore reliable and also to skip
entries.

I think your patches as is are the right way to go: by default provide
as much information as we can.

And those who care about reliability can use their own stack ops, which
is what perf does for example. If needed we can still add a new
save_stack_trace_reliable() in the future.

