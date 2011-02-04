Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1BDNNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 08:13:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1BDNNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:13:21 -0500
Date: Fri, 4 Feb 2011 14:04:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110204130455.GA3671@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <1296227324-25295-11-git-send-email-tj@kernel.org> <20110203204122.GA26371@redhat.com> <20110203204154.GB26371@redhat.com> <20110203213640.1F516180995@magilla.sf.frob.com> <20110203214450.GA29496@redhat.com> <20110204105343.GA12133@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204105343.GA12133@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Tejun Heo wrote:
>
> Hello, Oleg, Roland.
>
> On Thu, Feb 03, 2011 at 10:44:50PM +0100, Oleg Nesterov wrote:
> > On 02/03, Roland McGrath wrote:
> > >
> > > IMHO this sort of band-aid does not really help the overall situation.
> > > It takes something that is intricate and fiddly and just fiddles it a
> > > bit more.  Userland will still have to handle older kernels where this
> > > behavior is not there.  If userland does anything that relies on this
> > > new behavior, then it will have to try somehow to figure out which
> > > kernel versions have which behavior and adapt, etc.
> >
> > Absolutely agreed.
> >
> > As I said, I am not sure this patch makes sense. I only sent it
> > because I have to react to the bug report.
> >
> > > When the old behaviors are unhelpful like this, I think it is really
> > > better to add new mechanisms instead.
> >
> > Agreed!
> >
> > Can't resist, let me repeat... imho ptrace is unfixable ;)
>
> Hmm... I can't reproduce the problem here,

Very strange. Do you mean the test-case doesn't die? (on vanilla kernel).

> but isn't the problematic
> part here the mixing of ptrace and group stop and sliently
> transforming group stop into ptrace

Not exactly,

> and ptracer consuming the usual
> exit code instead of the ptrace specific one?

Well, unless the task dies nobody except ptrace can use ->exit_code.

The problem is:

	- the task T stops, it sets ->exit_code exactly because
	  the tracer can attach after that

	- the tracer attaches, does wait(), consumes exit_code
	  and exits

	- another tracer attaches, but exit_code == 0

There is no STOPPED/TRACED transformation at all.

> Also, I don't agree with the notion that doing something entirely new
> would magically solve all the problems.  Improvements are achieved
> through evolution.  For ptrace, the situation definitely is aggravated
> by the use of wait

... and reparenting, and signals.

> and weird interaction with group stop,

Yes. And to me the main problem is not the current behaviour. The
problem is that we never tried to define the correct behavior.
OK, real_parent can miss the notification. We can fix this, but
for what? The tracer can resume the thread "silently", this doesn't
look very good anyway.

But even this doesn't matter. We can not change ptrace API so that,
say, it does not reparent the tracee. Once we do this, we already
have the new API.

So, personally I think we need the new API. And we already have
utrace which allows to implement "anything" on top of it, including
the old ptrace for compatibility.

> Actually, I think such approach is significantly harmful to
> improvements of the existing code base.  Instead of encouraging
> investigating the actual problems and making sensible tradeoffs, such
> approach discourages making reasonable tradeoffs with the false
> expectation that something in the future will magically solve the
> problems.  In a lot of cases, there are no unicorns.  Proceeding
> forward while managing damage at reasonable level is usually the right
> way to go.

Well, perhaps I am wrong, this is only my opinion.

Oleg.

