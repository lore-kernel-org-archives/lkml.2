Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142Ab0EEJGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:06:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:60841 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775Ab0EEJGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:06:45 -0400
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move
 perf on top of TP
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <4BE0FB68.7080403@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
	 <1272994165.1642.203.camel@laptop>  <4BE0FB68.7080403@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 11:06:40 +0200
Message-ID: <1273050400.1642.229.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 07:00 +0200, Tejun Heo wrote:
> Hello,
> 
> On 05/04/2010 07:29 PM, Peter Zijlstra wrote:
> >> * 0001-0007: Unify the three tracers (tracepoints, perf_events and
> >>   preempt/sched notifiers) in scheduler.
> > 
> > Right, so I really don't like the SCHED_EVENT() thing much, esp the 3
> > different function postfixes.
> 
> Yeap, it's not the prettiest thing.  I thought about renaming all of
> them so that they share the same postfix but then again I need a way
> to tell the script which to enable which is the easiest with
> specifying postfixes as macro argument.  Any better ideas?

Add more NOP functions for the missing bits I guess, but that gets
cumbersome too.

> >> * 0008-0012: Move perf hooks in sched on top of tracepoints if TPs are
> >>              enabled.
> > 
> > This seems to add a terrible amount of overhead for no particular
> > reason.
> 
> Hmm... What overhead?

Well, the perf_{inc,dec}_nr_events() stuff, that's massively painful. If
that is the price to pay for using tracepoints then I'd rather not.

Also, the whole magic dance to keep !CONFIG_TRACEPOINTS working doesn't
make the code any saner.

> What matters more here is avoiding the overhead when perf or whatever
> tracing mechanism is disabled.  When both perf and TPs are compiled in
> but not enabled, moving perf hooks on top of TPs means that the sched
> core code doesn't have to call into extra functions for perf and TPs
> can be nooped.  ie. less overhead.  Also, even when perf is enabled,
> there isn't any inherent extra runtime overhead other than during
> enabling/disabling which again is a much colder path.

Well, in the current code we get the call overhead, but all perf
functions bail on !nr_events. We could invert that and have an inline
function check nr_events and only then do the call.

> The only place where noticeable overhead is added is the extra pair of
> irq enable/disable that I added for sched_out hook.  After glancing
> through what perf does during context switch, I thought that overhead
> wouldn't be anything noticeable but if it is, they can definitely be
> separated.  The only purpose of that change was colocating sched
> notifiers and perf hooks.

Right, recent Intel chips seem to do much better at IRQ disable than say
P4 and IA64, and poking at the PMU MSRs is way more painful, not sure
how it would balance out for PowerPC (or anything other) though.

> Also, if a few more perf hooks are converted to use the same
> mechanism, it would be possible to put perf properly on top of TPs
> other than init/exit code paths which will be cleaner for the rest of
> the kernel and there won't be any extra runtime overhead.
> 
> The code will be much cleaner if perf depends on TPs.  With perf hooks
> completely removed, there won't be much point in SCHED_EVENT and the
> messy ifdefs in perf can also go away.  Would this be a possibility?

Well, I already utterly hate that x86 can't build with !
CONFIG_PERF_EVENTS, also requiring CONFIG_TRACEPOINTS is going the wrong
way.

I've always explicitly avoided depending on tracepoints, and I'd very
much like to keep it that way.

