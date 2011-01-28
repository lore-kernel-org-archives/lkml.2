Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1A1VGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 16:06:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab1A1VGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 16:06:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
 and TRACED
In-Reply-To: Tejun Heo's message of  Thursday, 27 January 2011 14:23:15 +0100 <20110127132315.GB24925@htj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
	<20110118021133.C14FA1807B7@magilla.sf.frob.com>
	<20110127132315.GB24925@htj.dyndns.org>
Emacs: the definitive fritterware.
Message-Id: <20110128210612.D4EDC183C1E@magilla.sf.frob.com>
Date: Fri, 28 Jan 2011 13:06:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello, sorry about the delay.

No problem.  I am often behind on these threads too.  I'm trying to get
mostly caught up today, but probably won't really have full feedback about
your new iteration of patches, and I will then be gone until Tuesday.

> I was trying to imagine a case where this could cause a problem.  If
> there is a program which PTRACE_ATTACH's and then immediately follows
> with SIGCONT and expects it to be processed, the end result wouldn't
> be what it expects, but I don't think this is an actual problem we
> need to worry about.

I'm just never that sure about such changes.  If a process was already
known to be stopped before PTRACE_ATTACH, then the entirely reasonable
expectation is that SIGCONT will resume it.  Not only that, SIGCONT will
clear the pending SIGSTOP posted by PTRACE_ATTACH, so it won't immediately
stop again either.

> > This seems more problematic to me.  I don't like that start/stop window
> > at all.
> 
> Which case are you worried about?  Another thread doing WNOHANG
> wait(2) or the same ptracer trying to re-attach immediately after
> detaching?  Or both?

Well, as you can tell, I'm pretty much worried about everything, and
even moreso when I don't know what it might be.  There has before been a
torture-test case for race conditions that did PTRACE_DETACH and
PTRACE_ATTACH in a tight loop, and we probably shouldn't regress on that
case.  It may have been purely for torture purposes, but I think it may
originally have been motivated by replicating a real-world race scenario
where arcane things could matter.

The main specific thing that comes to mind for me is about wait.  Say I
previously did a wait, WNOHANG or not, and saw WIFSTOPPED--or, I just
came along after that wait had happened (e.g. by the shell in the normal
job control situation) and checked /proc/pid/status to verify that it
was stopped.  Now I "know" that it is stopped, has no wait status to
report, and the only way it would be woken is by SIGKILL or SIGCONT.
I've decided that nobody is going to send those, because nobody will.

So then I do PTRACE_ATTACH, and go into a wait (perhaps it's part of my
generic event loop because I am waiting for other children/tracees too).
I should not get any new wait report for that tracee, because it's
already stopped and didn't run at all.  If I do get one, it confuses me.

Or instead, say I knew it was already stopped and then I did
PTRACE_ATTACH.  Since I know it's already stopped, I know that I can
immediately do a ptrace operation on it.  If there is a window in which
it's running again, ptrace will give me ESRCH.  That confuses me.

> > Saying "wait may fail" is not sufficiently precise to be helpful.  Please
> > be more clear.  If "fail" means ECHILD, that is unacceptable.  If "fail"
> > means a WNOHANG wait returns 0 when userland already "knows" that the
> > thread is topped, that might be more acceptable.
> 
> It's the latter.  The only thing which changes is that the task might
> not be in the exact expected state for brief amount of time.
> 
> For the initial STOPPED -> TRACED transition, the race window doesn't
> exist for the ptracer itself.  It's only visible if someone else than
> the ptrace does the wait(2) which is a pretty convoluted use case to
> begin with.

I'm not sure I follow this.  If the real parent is racing with
PTRACE_ATTACH, that's fine, there's already that race.  Once
PTRACE_ATTACH has returned, then the real parent is preempted from
seeing any wait results.  If the real parent uses WNOHANG, then it's
always going to return 0.  The only callers of wait* that can see the
tracee are the threads in the process that just did PTRACE_ATTACH.

> For TRACED -> STOPPED -> TRACED transition (attach right after
> detach), it is visible to the ptracer but again I don't think this is
> even remotely reasonable use case.  Plus, it never worked.  We've been
> issuing SIGCONT unconditionally on TRACED -> STOPPED anyway.

I don't understand what "issuing" means.  The active verbs that apply to
signals are "generate" and "deliver".


Thanks,
Roland
