Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0C2RtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:49:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43772 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab0C2RtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sjRKvjrBVUNKv4wCJRaQNdun77QCOUkoRUt+Szms7b65Y2ywT0U345Yc2UK56ejC0l
         xsI/M3XCsa24LVfrRiIaQMf1idne5eR1BihVt0bhkwgUsDeLZRU/3ggybXQ3RhDBstN4
         op2C/ZS5y+JWVxtKxsPvMoR9L7BuSTZhRLjg4=
Date: Mon, 29 Mar 2010 19:47:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] perf: Use hot regs with software sched
	switch/migrate events
Message-ID: <20100329174723.GB5101@nowhere>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com> <1269753066-17246-3-git-send-regression-fweisbec@gmail.com> <1269852599.12097.159.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269852599.12097.159.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 10:49:59AM +0200, Peter Zijlstra wrote:
> On Sun, 2010-03-28 at 07:11 +0200, Frederic Weisbecker wrote:
> > Scheduler's task migration events don't work because they always
> > pass NULL regs perf_sw_event(). The event hence gets filtered
> > in perf_swevent_add().
> > 
> > Scheduler's context switches events use task_pt_regs() to get
> > the context when the event occured which is a wrong thing to
> > do as this won't give us the place in the kernel where we went
> > to sleep but the place where we left userspace. The result is
> > even more wrong if we switch from a kernel thread.
> > 
> > Use the hot regs snapshot for both events as they belong to the
> > non-interrupt/exception based events family. Unlike page faults
> > or so that provide the regs matching the exact origin of the event,
> > we need to save the current context.
> > 
> > This makes the task migration event working and fix the context
> > switch callchains and origin ip.
> 
> 
> But after this its no longer possible to profile userspace on context
> switches is it?


Once the callchain on the kernel finishes, we bounce to the userspace
part, using task_pt_regs(). The previous version was incorrect because
it was ignoring the kernel part.

But you makes me wonder... We don't take into account exclude_kernel
or exclude_user with these hot regs.

I think we need several new things:

Every arch does its own:

	if (!is_user)
		perf_callchain_kernel(regs, entry);

	if (current->mm)
		perf_callchain_user(regs, entry);

Plus perf_callchain_user() goes fetching task_pt_regs()
by itself.

This is a check we should do from the core, according
to exclude_kernel, exclude_user, user_mode and current->mm

Archs shouldn't bother about these details.
They should just implement perf_callchain_kernel and perf_callchain_user
rather than a monolithic one that deals with contexts.

Each time we pass regs to perf_event_overflow() we should call
a perf_filter_callchain(struct pt_regs *default) that checks the
exclude_* things and override with task_pt_regs() if needed
(and if current->mm is set) so that even the ip source will
be correct.

And a generic perf_callchain() can deal with perf_callchain_kernel()
and perf_callchain_user() calls, again, according the exclude_*
policies.

I'm going to make a quick fix for perf_fetch_caller_regs() that
passes task_pt_regs if exclude_kernel for perf/urgent,
and I'll do the above cleanups/invasive fixes on perf/core.

