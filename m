Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2ALOJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:09:14 -0500
Received: from mail.openrapids.net ([64.15.138.104]:45488 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753525Ab2ALOJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:09:09 -0500
Date: Thu, 12 Jan 2012 09:09:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        lttng-dev@lists.lttng.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Perf ABI (was: Re: [lttng-dev] [PATCH 09/11] sched: export
	task_prio to GPL modules)
Message-ID: <20120112140905.GA30377@Krystal>
References: <20111206214446.GD1247@kroah.com> <20111208052354.GC9485@elte.hu> <20111208232709.GA19820@kroah.com> <20111219104915.GA19861@elte.hu> <20111219153053.GA21548@Krystal> <20111220110813.GA19105@elte.hu> <20111223164629.GA30474@Krystal> <20111223172155.GA14117@thunk.org> <20111223181641.GA12681@Krystal> <20111225174613.GA12732@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111225174613.GA12732@thunk.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:22:06 up 414 days, 18:25,  6 users,  load average: 0.06, 0.04,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ted Ts'o (tytso@mit.edu) wrote:
> On Fri, Dec 23, 2011 at 01:16:41PM -0500, Mathieu Desnoyers wrote:
[...]
> > - The trace data format
> >   - Both versioned _and_ self-described.
> >   Self-description of the event/field layout allows the same tools to
> >   understand traces gathered on different kernel versions, on different
> >   architectures, with different tracer configurations.
> >   Versioning on top of the self-described trace format allows changes
> >   to what the trace self-description can express.
> 
> So there are two ways to do this.  One is to make changes be backwards
> compatible, so that the trace data format only breaks if you use the
> new feature; if it doesn't you encode things the old fashioned way.
> The other way of doing things is to randomly break users whenever the
> tracing developers decide to add some random new feature, regardless
> of whether or not a partiuclar user finds that new feature to be
> useful.
> 
> The first is acceptable.  The second, IMHO, is not.  Linus has said
> quite strongly that WE DO NOT BREAK USERSPACE.   Period.

Please allow me to look into what needs to be kept compatible for a good
user experience (for both Linux end users and kernel developers) in the
case of tracing:

Let's first describe what we really utterly don't want: random breakages
between the kernel and user-level tracing control/transport/analysis
tools. Consequently, I think we could say that it would be unacceptable
for userspace tools to break for every slight change of kernel code. If
that would be the case (as it was with the approach SystemTap was taking
before they started hooking into the kernel with tracepoints), then we'd
need to regenerate the tools for pretty much every -rc kernel, and for
each local development tree, which would make those tools useless to
kernel developers.

It is important to clarify that tracing is, in my opinion, not part of
the runtime support, which makes it very different by nature from
filesystems and kernel runtime support. So I agree with Linus' argument
about not breaking userspace when applied to runtime support, because
being unable to even boot a system due to an ABI breakage is very much
unwanted. However, I think it should not be applied as-is to tracing,
because you cannot make a system unusable due to a tracer ABI breakage:
if a tracer can be packaged in a set of standalone modules, that clearly
shows it is not part of the system runtime support.

That being said, ABI versioning could still handle ABI changes without
significantly impacting the users: when an ABI breakage is needed, we
can keep the old code around for a while and expose both the old and new
ABIs. This would ensure that the user-level tools can query for the
specific ABI major version(s) they support. That should improve the user
experience by providing "deprecated" console warnings for a few kernel
releases before the old code ends up being removed.

So, in summary:

  * Old kernels vs new tools:

New tools can query for the latest ABI they know, and fall-back on older
ABIs, with limited features.

  * New kernels vs old tools:

Keeping around the old ABI for a deprecation phase lets old tools work on
a bleeding edge kernel while the ABI change is being introduced, which
should satisfy the kernel developer use-case.

Best regards,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
