Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2ALPkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:40:06 -0500
Received: from mail.openrapids.net ([64.15.138.104]:42553 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754024Ab2ALPkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:40:04 -0500
Date: Thu, 12 Jan 2012 10:39:57 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, "Ted Ts'o" <tytso@mit.edu>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>, lttng-dev@lists.lttng.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [lttng-dev] Perf ABI (was: Re: [PATCH 09/11] sched: export
	task_prio to GPL modules)
Message-ID: <20120112153957.GA20514@Krystal>
References: <20111208232709.GA19820@kroah.com> <20111219104915.GA19861@elte.hu> <20111219153053.GA21548@Krystal> <20111220110813.GA19105@elte.hu> <20111223164629.GA30474@Krystal> <20111223172155.GA14117@thunk.org> <20111223181641.GA12681@Krystal> <20111225174613.GA12732@thunk.org> <20120112140905.GA30377@Krystal> <1326380042.7642.73.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1326380042.7642.73.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:05:31 up 645 days, 55 min,  5 users,  load average: 1.16,
	1.14, 1.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2012-01-12 at 09:09 -0500, Mathieu Desnoyers wrote:
> 
> 
> > It is important to clarify that tracing is, in my opinion, not part of
> > the runtime support, which makes it very different by nature from
> > filesystems and kernel runtime support. So I agree with Linus' argument
> > about not breaking userspace when applied to runtime support, because
> > being unable to even boot a system due to an ABI breakage is very much
> > unwanted. However, I think it should not be applied as-is to tracing,
> > because you cannot make a system unusable due to a tracer ABI breakage:
> > if a tracer can be packaged in a set of standalone modules, that clearly
> > shows it is not part of the system runtime support.
> 
> Correct that tracing is not something that needs to make the system run,
> but that's still no excuse to make ABI changes any different. Note, we
> don't change things within the /proc/stat or /proc/*/stat and that's not
> required to make the system run. We can add onto those files, but we
> can't change what the current numbers mean.

This is because this stat ABI is volountarily exposed like this. It does
not mean that this is the case everywhere else in the kernel. And it
might not be the right way to expose it: I bet that PeterZ would really
like to get the thread priority value removed from /proc/*/stat, because
it exposes something "internal" to the scheduler from his point of view,
but this particular ABI has chosen to evolve without ever retiring a
value previously exported.

> 
> > 
> > That being said, ABI versioning could still handle ABI changes without
> > significantly impacting the users: when an ABI breakage is needed, we
> > can keep the old code around for a while and expose both the old and new
> > ABIs. This would ensure that the user-level tools can query for the
> > specific ABI major version(s) they support. That should improve the user
> > experience by providing "deprecated" console warnings for a few kernel
> > releases before the old code ends up being removed.
> 
> ABI version numbers are meaningless, and prone to be broken. The change
> would have to be added with the commit that updates the change otherwise
> git bisecting can get screwed up too.

Of course, the commit that updates the code would "fork" to a new ABI if
it ever need to diverge from the old one.

> The way ABI changes in the kernel have always been was to look at the
> file itself and have the tool be able to determine what version of the
> ABI is there based on what files exists, or what exists in the file.
> I've done this with trace-cmd and ftrace. The debugfs system has changed
> a lot, and trace-cmd can handle each change. I never had a need for a
> version number to do this. I simply have trace-cmd look at what is
> available and what isn't.
> 
> If you need to know if a syscall exists, you try it and if you get
> -ENOSYS, then you know it doesn't exist. We have no need for an
> arbitrary version number that is meaningless. The existence of (or lack
> of) tells us all we need to know.

pipe()/pipe2()
dup()/dup2()/dup3()
umount()/umount2()
mmap()/mmap2()
madvise()/madvise1()
eventfd()/eventfd2()

Those look very much like major version numbers to me. And these are
entirely compatible with your statement above about using -ENOSYS to
detect if the major version number is implemented or not.

If your only concern is that the major version number should be part of
the ABI name (as in the examples above), that can be arranged.

> 
> > 
> > So, in summary:
> > 
> >   * Old kernels vs new tools:
> > 
> > New tools can query for the latest ABI they know, and fall-back on older
> > ABIs, with limited features.
> > 
> >   * New kernels vs old tools:
> > 
> > Keeping around the old ABI for a deprecation phase lets old tools work on
> > a bleeding edge kernel while the ABI change is being introduced, which
> > should satisfy the kernel developer use-case.
> 
> We've done this without version numbers. Just look at all the udev
> changes.

Are you seriously refering to udev as an example of how to handle
changes, or as one of the worse ABI breakage mess that happened in the
Linux kernel history ? My own experience as a Linux users (in the
era around 2.6.12 kernels if my memory serves me right) lead me to think
it's the latter. And because udev is part of the runtime support, that
indeed led to non-bootable systems and lots of frustrated users.

Thanks,

Mathieu

> 
> -- Steve
> 
> 
> 
> _______________________________________________
> lttng-dev mailing list
> lttng-dev@lists.lttng.org
> http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
