Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab1EXVVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:21:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:48455 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab1EXVVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:21:17 -0400
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <BANLkTinSOFAioAe2v5c6PRB9EKjJJNMg9w@mail.gmail.com>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
	 <20110524034023.GB25230@elte.hu>
	 <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
	 <20110524173326.GA7635@gere.osrc.amd.com>
	 <BANLkTinSOFAioAe2v5c6PRB9EKjJJNMg9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 23:24:34 +0200
Message-ID: <1306272274.2497.73.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 10:56 -0700, Tony Luck wrote:
> Dragging PeterZ to this thread, since we are now talking about scheduler.
> 
> On Tue, May 24, 2011 at 10:33 AM, Borislav Petkov <bp@amd64.org> wrote:
> > On Tue, May 24, 2011 at 09:57:46AM -0700, Luck, Tony wrote:
> >> So can we talk about this part for a while before returning to the
> >> "how to report this" discussion?
> >>
> >> So here's the situation - we are in the NMI handler when we find from
> >> looking at the machine check bank registers that we have a recoverable
> >> error. We know the physical address, and we know the task (which might
> >> have been in user or kernel context). I can package that information
> >> into a perf/event ... but then how can I mark the current task as
> >> not-fit-for-execution?
> >
> > Maybe something like
> >
> > set_current_state(TASK_UNINTERRUPTIBLE);
> >
> > finish work in NMI context
> >
> > do remaining work in process context like sending appropriate signals
> > etc; finally:
> >
> > set_task_state(tsk, TASK_RUNNING)
> 
> That looks pretty easy - are their any weird side effects that I should
> be worried about?  My perf/event can't really include the "task" pointer
> (that sounds way too internal) - but I can provide the process id, so
> the "RAS daemon" that sees this event can look up the task to do that
> final set_task_state(tsk, TASK_RUNNING).
> 
> Does this work in the threaded case? In the case where the task was in
> kernel context (but in a CONFIG_PREEMT=y kernel at some point
> where preemption is allowed)?


Right, so you can't do things like that from NMI context, but what perf
can do is raise a self-IPI and continue from IRQ context (question for
the HW folks, can there be cycles between the NMI iret and IRQ assert
from whatever context was before the NMI hit?)

>From IRQ context we can wake threads, set TIF_flags etc. you can
basically do what SIGSTOP does and put the task in TASK_STOPPED state,
wake your handler thread and set TIF_NEED_RESCHED. Then the handler
thread will be scheduled depending on your handler's sched policy.



