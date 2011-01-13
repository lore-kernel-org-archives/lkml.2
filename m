Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab1AMPFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:05:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61009 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab1AMPFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:05:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ETmg5ZKLxuh2kSfy8WPOh/EfP55hxdyKkJeiNRYAwta8inNLRuvCIQZE4F9HyKBfob
         /Sf1x4QnGNFwCuVpjOpawF9ukkH3Z6jdC2aLWq7VYhM1yD5CcrNghWbaYQCt3LzzPEVk
         ggeCK9vN23cnJT7GQSMcjgwb+u/ujw0bib18I=
Date: Thu, 13 Jan 2011 16:05:01 +0100
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
 and TRACED
Message-ID: <20110113150501.GA12596@htj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
 <20110112214350.GC13830@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112214350.GC13830@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.  (Please ignore the other reply.  I pressed the wrong keys
and it went out prematurely.)

On Wed, Jan 12, 2011 at 10:43:50PM +0100, Jan Kratochvil wrote:
> FSF GDB for `T (stopped)' processes currently does:
>   PTRACE_ATTACH
>   check /proc/%d/status for `T (stopped)' (by GDB's pid_is_stopped)
>     if found then kill (PID, SIGSTOP) && ptrace (PTRACE_CONT, PID, 0, 0).
>   waitpid (pid, &status, 0) - so that this one does not get stuck if the stop
>                               event was already eaten out before.
> 
> If the `T (stopped)' will now always FAIL then at leat the waitpid then should
> never get stuck.

Now the child will always stop inside ptrace_stop() which
unconditionally sets ->exit_code (the state wait(2) consumes) so it
won't get stuck unless someone else consumes it inbetween, of course.

> > 2. The transition between STOPPED and TRACED involves a short window
> >    of RUNNING inbetween.  On attach, the transition is hidden from the
> >    tracer using GROUP_STOP_TRAPPING but it still is visible to other
> >    threads in the tracer's group.  IOW, if another thread performs
> >    WNOHANG wait(2) on the tracee while attach is in progress, the
> >    wait(2) may fail even if the tracee is known to be in stopped state
> >    before.
> > 
> >    The same problem exists the other direction during detach.
> >    Currently, the code doesn't try to hide this transition even from
> >    the tracer.  IOW, if the tracer attaches to a stopped task,
> >    detaches, reattaches and then performs WNOHANG wait(2), the wait(2)
> >    may fail.  However, given the previous behavior where the tracee is
> >    always woken up by wake_up_process() on detach, this is highly
> >    unlikely to cause any problem.
> 
> FSF gdbserver --multi does PTRACE_ATTACH followed by waitpid (WNOHANG) and it
> fails if it returns ECHILD on the first try.
> 
> 	ptrace(PTRACE_ATTACH, 22049, 0, 0)      = 0
> 	wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}], WNOHANG, NULL) = 22049
> 
> It may be also a gdbserver bug, though.

How is that supposed to work even with the current code?  Does it
check whether the target thread is stopped before doing that?  Reading
gdbserver manpage....  Hmm... doesn't help much.  Can you please help
me understanding what it expects there?

Thank you.

-- 
tejun
