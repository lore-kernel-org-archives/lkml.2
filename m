Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1EMSfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:35:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab1EMSfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:35:43 -0400
Date: Fri, 13 May 2011 20:34:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 10/11] ptrace: move JOBCTL_TRAPPING wait to wait(2) and
	ptrace_check_attach()
Message-ID: <20110513183416.GA31415@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-11-git-send-email-tj@kernel.org> <20110511164947.GA26383@redhat.com> <20110511195333.GE24245@mtj.dyndns.org> <20110512155910.GD18599@redhat.com> <20110512160709.GL1030@htj.dyndns.org> <20110512182006.GA25850@redhat.com> <20110513091311.GC6500@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513091311.GC6500@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Tejun Heo wrote:
>
> On Thu, May 12, 2011 at 08:20:06PM +0200, Oleg Nesterov wrote:
> > Now about GROUP_STOP_TRAPPING. To simplify the discussion, lets
> > forget about this series,
> >
> > ...
> >
> > Problem: TRAPPING can be set outside of do_signal_stop() paths, and
> > I think we should avoid this as much as possible.
>
> For PTRACE_DETACH, this was true but it isn't true for notification
> re-traps.  Notification re-traps happen iff JOBCTL_TRAPPED

Yes I see, and task_clear_jobctl_trapping() was moved into
get_signal_to_deliver().

So, if we return to this series then "outside of do_signal_stop()" is
not accurate.

> > (I am ignoring the problem this patch addresses temporary, I think
> >  we can fix it a bit differently).
>
> Just leaving it alone also is an option.  We can just mandate
> ptrace(2) users to always perform sleeping wait(2) after PTRACE_SEIZE.
> If it can be fixed easily, sure.  If not, let's leave it alone.

Let's leave it alone in this thread, unless I missed something this is
simple. Or I missed something and it is not that simple ;)

> > Say, the thread group was stopped, the tracer PTRACE_CONT's T1, it calls
> > sys_execve() and reports the trap from syscall_trace_enter().
> >
> > The tracer does ptrace(T1, DETACH) + ptrace(T1, SEIZE) and hangs forever.
> >
> > Once again, this is only one example. coredump, vfork, probably something
> > else. In short: I think that TRAPPING-outside-of-do_signal_stop is the
> > can of worms.
>
> Yeap, fully agreed.  We need something different for detach case;
> however, for re-trap, tracee is known to be in signal delivery path
> and should be okay, I think.  Right?

I think this is right, but there were so many issues, that is why I
suggested to ignore this series temporary. And, to be honest, because
I was a bit confused, somehow I thought you are going to add more
TRAPPING's.

So, we agree that we can only set TRAPPING iff we know what the tracee
should do "really soon". Great.

I have other concerns, but I noticed you have already sent V2. Let's
continue there.

Oleg.

