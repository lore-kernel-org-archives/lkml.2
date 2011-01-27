Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1A0NXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:23:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40952 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1A0NXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:23:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z9mHTx17hHrP2DbWAQBeR3cpoFoc1ngrqqZN3YIxcLksODM0vWl17OUgFB0vD1/c1P
         /Un40pkLXkQWqr05Dg1PVTpt/31yy37pO5HXlDUSRO2Yd0XJcbShVX1krW8VV43c1E2H
         mYlpkcXABe2L5WKLf8zu178kEjrXLH/Ae9H5A=
Date: Thu, 27 Jan 2011 14:23:15 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
 and TRACED
Message-ID: <20110127132315.GB24925@htj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
 <20110118021133.C14FA1807B7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118021133.C14FA1807B7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, sorry about the delay.

On Mon, Jan 17, 2011 at 06:11:33PM -0800, Roland McGrath wrote:
> > 1. When attaching to a STOPPED task or a traced task stops for group
> >    stop, the tracee now enters TRACED instead of STOPPED.  This is
> >    visible via fs/proc but, more importantly, SIGCONT is ignored if a
> >    task is TRACED.
> 
> That is probably OK, but I'm still not entirely sure about it.
> 
> >    This may, for example, affect the operation of strace but given how
> >    strace always need to issue further ptrace operations on trap to
> >    determine what's going on, I doubt it would actually be worse.
> 
> I'm not clear on what effect on strace you have in mind.

I was trying to imagine a case where this could cause a problem.  If
there is a program which PTRACE_ATTACH's and then immediately follows
with SIGCONT and expects it to be processed, the end result wouldn't
be what it expects, but I don't think this is an actual problem we
need to worry about.

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
> This seems more problematic to me.  I don't like that start/stop window
> at all.

Which case are you worried about?  Another thread doing WNOHANG
wait(2) or the same ptracer trying to re-attach immediately after
detaching?  Or both?

> Saying "wait may fail" is not sufficiently precise to be helpful.  Please
> be more clear.  If "fail" means ECHILD, that is unacceptable.  If "fail"
> means a WNOHANG wait returns 0 when userland already "knows" that the
> thread is topped, that might be more acceptable.

It's the latter.  The only thing which changes is that the task might
not be in the exact expected state for brief amount of time.

For the initial STOPPED -> TRACED transition, the race window doesn't
exist for the ptracer itself.  It's only visible if someone else than
the ptrace does the wait(2) which is a pretty convoluted use case to
begin with.

For TRACED -> STOPPED -> TRACED transition (attach right after
detach), it is visible to the ptracer but again I don't think this is
even remotely reasonable use case.  Plus, it never worked.  We've been
issuing SIGCONT unconditionally on TRACED -> STOPPED anyway.

Thank you.

-- 
tejun
