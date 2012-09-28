Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031Ab2I1ENW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:13:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:48025 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750705Ab2I1ENV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:13:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/BJIgXikjByJhcBvl8jYiH9GRMX2EIw9RTe3EShd
	Punz1CaMI/Qm00
Message-ID: <1348805595.7072.18.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Fri, 28 Sep 2012 06:13:15 +0200
In-Reply-To: <CA+55aFwnos6qFMi6R9uGxY2QtkUVm3hEc_Lgx1R0+AZt5V=SRA@mail.gmail.com>
References: <20120926163233.GA5339@x1.osrc.amd.com>
	 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
	 <20120926213723.GA27692@liondog.tnic>
	 <1348722568.7059.115.camel@marge.simpson.net>
	 <20120927054742.GA4370@gmail.com>
	 <1348727665.7059.160.camel@marge.simpson.net>
	 <20120927064142.GB5996@gmail.com>
	 <1348728852.7059.171.camel@marge.simpson.net>
	 <20120927071011.GA8980@gmail.com>
	 <CA+55aFyxjdir-LZneBTk1JQV0cVSRFzEK9Jpxje2SJqA6aP3Yg@mail.gmail.com>
	 <20120927180507.GD8527@x1.osrc.amd.com>
	 <CA+55aFyTrcmx3Uf7UGU=-K=BwTym8aN15fTo==cV2bCK6so0Fg@mail.gmail.com>
	 <1348770584.3292.44.camel@twins>
	 <CA+55aFwnos6qFMi6R9uGxY2QtkUVm3hEc_Lgx1R0+AZt5V=SRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 12:40 -0700, Linus Torvalds wrote: 
> On Thu, Sep 27, 2012 at 11:29 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > Don't forget to run the desktop interactivity benchmarks after you're
> > done wriggling with this knob... wakeup preemption is important for most
> > those.
> 
> So I don't think we want to *just* wiggle that knob per se. We
> definitely don't want to hurt latency on actual interactive asks. But
> it's interesting that it helps psql so much, and that there seems to
> be some interaction with the select_idle_sibling().
> 
> So I do have a few things I react to when looking at that wakeup granularity..
> 
> I wonder about this comment, for example:
> 
>          * By using 'se' instead of 'curr' we penalize light tasks, so
>          * they get preempted easier. That is, if 'se' < 'curr' then
>          * the resulting gran will be larger, therefore penalizing the
>          * lighter, if otoh 'se' > 'curr' then the resulting gran will
>          * be smaller, again penalizing the lighter task.
> 
> why would we want to preempt light tasks easier? It sounds backwards
> to me. If they are light, we have *less* reason to preempt them, since
> they are more likely to just go to sleep on their own, no?

At, that particular 'light' refers to se->load.weight.

> Another question is whether the fact that this same load interacts
> with select_idle_sibling() is perhaps a sign that maybe the preemption
> logic is all fine, but it interacts badly with the "pick new cpu"
> code. In particular, after having changed rq's, is the vruntime really
> comparable? IOW, maybe this is an interaction between "place_entity()"
> and then the immediately following (?) call to check wakeup
> preemption?

I think vruntime should be fine.  We set take the delta between the
task's vruntime when it went to sleep and it's previous rq min_vruntime
to capture progress made while it slept, and apply the relative offset
in the task's new home so a task can migrate and still have a chance to
preempt on wakeup.

> The fact that *either* changing select_idle_sibling() *or* changing
> the wakeup preemption granularity seems to have such a huge impact
> does seem to tie them together somehow for this particular load. No?

The way I read it, Boris had wakeup preemption disabled.

-Mike

