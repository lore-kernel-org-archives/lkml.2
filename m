Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0C3TOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 15:14:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64173 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0C3TOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 15:14:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tFhf87e+5Nt50amVfFuou/bBHZUK6P0LXlnWAJHz9hXhdgQV6voX2XN6DfMzyZdh5E
         hE5XxhSMXN3D0JFNT3uslvVix9KmiE71Y782b3kdi9E0ySCEeLS4CljC1PQMxgT68Wpf
         7FrqSe4sUPlMcXwdkWbOZNYwlLxQRkdmu7Q6s=
Date: Tue, 30 Mar 2010 21:14:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] perf: Use hot regs with software sched
	switch/migrate events
Message-ID: <20100330191401.GF5078@nowhere>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com> <1269753066-17246-3-git-send-regression-fweisbec@gmail.com> <1269852599.12097.159.camel@laptop> <20100329174723.GB5101@nowhere> <1269885938.12097.367.camel@laptop> <20100329224352.GC12254@nowhere> <1269975292.5258.597.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269975292.5258.597.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 08:54:52PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-03-30 at 00:43 +0200, Frederic Weisbecker wrote:
> 
> > Actually I have doubts about what should be the strict sense
> > of exclude_kernel.
> > 
> > Does that mean we exclude any event that happened in the kernel?
> > Or does that mean we exclude the part that happened in the kernel?
> > 
> > Depending on the case, we do either.
> > 
> > In perf_swevent_hrtimer(), we simply go back to task_pt_regs()
> > if exclude_kernel.
> > 
> > But in other software events, we don't such fix, we actually
> > filter out the event if it is not user_mode().
> > 
> > So, I'm a bit confused on what to do.
> > I'm tempted to adopt the meaning from perf_swevent_hrtimer()
> > for software events too, I'm not sure...
> 
> Yes, that is indeed a good point. Problem is that perf_swevent_hrtimer()
> is not quite correct either, since strictly speaking its timeline should
> stop on the excluded region, but implementing that would make context
> switches horribly expensive.



No we wouldn't need that. We would just need to change the regs
check.

Currently we have this:

	regs = get_irq_regs();
	/*
	 * In case we exclude kernel IPs or are somehow not in interrupt
	 * context, provide the next best thing, the user IP.
	 */
	if ((event->attr.exclude_kernel || !regs) &&
			!event->attr.exclude_user)
		regs = task_pt_regs(current);


According to the strict meaning of exclude_kernel (event that happened in
userspace), we should have this:


	regs = get_irq_regs();

	if ((event->attr.exclude_kernel && regs)
		return ret;

	if (!regs && !event->attr.exclude_user && current->mm)
		regs = task_pt_regs(current);

	if (regs)
		overflow()


Note the current code is also buggy because we call task_pt_regs()
whenever we are a kernel thread or not.


> 
> That said, the option that would be most correct is to simply not count
> these events, and in that respect the current behaviour seems best.


Ok. But in this case I'm not sure what to do with the context switch
software event. The new hot regs thing now capture the kernel context,
whereas before it was only capturing userspace exit point.

Are you fine with that? The callchain will still go to userspace too.


> Maybe we can make a new perf feature that would for each kernel event
> (hw pmu included) report on the userspace state, would that be useful?


I'm not sure it would be useful...

