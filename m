Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1BUQWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:22:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60563 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab1BUQWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:22:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i2WMPxnzzQXjEjM9/A9HordTa7WsJtrju23VmL2dmNWLt1G4yqKho+DGPRXbHgyF7M
         q6+B4Sq0MaMGGFecYba0STWUEfp/UIr9CiaQGNxvbncMMYmn3Mby3STehcaVc3ABgN9Z
         iqd13y/3j6sh93sP6PYm68KxsGl//fKs1hhfw=
Date: Mon, 21 Feb 2011 17:22:06 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110221162206.GN31267@htj.dyndns.org>
References: <20110214175144.GC15847@redhat.com>
 <AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com>
 <20110214190141.GA19221@redhat.com>
 <AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com>
 <20110214200130.GA21559@redhat.com>
 <20110215152448.GL3160@htj.dyndns.org>
 <20110215173149.239601807B7@magilla.sf.frob.com>
 <20110215202747.GA20560@redhat.com>
 <20110218170212.GS21209@htj.dyndns.org>
 <20110218193709.GA9700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218193709.GA9700@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, :-)

On Fri, Feb 18, 2011 at 08:37:09PM +0100, Oleg Nesterov wrote:
> > Still trying to follow the new discussion.
> 
> And how it goes?
> 
> As for me, I am not sure I can follow it ;)

The issues Denys brought up are okay but I still haven't gotten my
head wrapped around what Jan and you are talking about.  Urgh... :-)

> > Instead of having simple "a ptracer stops in TASK_TRACED and its
> > execution is under the control of ptrace",
> 
> In fact, I am not sure I really disagree with this part, but see below.
> 
> > The patch which puts the tracee into TASK_TRACED
> > on ATTACH already fix two problems discussed in this thread without
> > doing anything wonky.  I think it says a lot.
> 
> Yes. One off-topice note... if we are talking about this patch only,
> I do not think it makes sense to add the new member into task_struct
> so that STOPPED/TRACED transition can always report the exactly correct
> ->exit_code. I think we can just use group_exit_code ?: SIGSTOP.
> But, again, this is off-topic.

It shares the task->group_stop which is needed for other things
anyway, but yeah, if we're sure it's either that or SIGSTOP that would
definitely be better.  Hmmm, but it can be other things.  There are
many signals which can trigger group stop.  Maybe this is not
important but then again preserving this doesn't cost us much either.

BTW, I plan on separating out all ptrace related stuff into a separate
struct as it's not used by most tasks anyway, so I don't think we need
to be too concerned about several more fields.

> > As it currently stands, SIGSTOP/CONT while ptraced doesn't work
> 
> And this is probably where we disagree the most. I think this is bug,
> and this should be fixed.

I don't think we disagree that it is a bug.  I want to fix it too but
we definitely seem to disagree on how.  I want to give more control to
the ptracer so that the tracer has enough information and control to
follow the group stop semantics if it wants to and you want to give
more control to group stop so that it overrides the tracer and always
does the right thing regarding group stop.

> > and even if we bend the rules subtly and provide sneaky ways like
> > the above, userland needs to be modified to make use of it anyway.
> 
> Yes. But with the current code we can't modify, say, strace so
> that SIGSTOP/CONT can work "correctly".

Agreed, not possible.  The kernel needs to be improved one way or the
other.

> > I think it would be far cleaner to simply make ptracee always stop
> > in TASK_TRACED and give the ptracer a way to notice what's
> > happening to the tracee
> 
> Well. If we accept the proposed PTRACE_CONT-needs-SIGCONT behaviour,
> then I think this probably makes sense. The tracee stops under ptrace,
> the possible SIGCONT shouldn't abuse debugger which wants to know, say,
> the state of registers.

The objections I have against PTRACE_CONT-needs-SIGCONT are,

* It will be very different from the current behavior.

* ptrace, sans the odd SIGSTOP on attach which we should remove, is
  per-task.  Sending out SIGCONT on PTRACE_CONT would break that.  I
  really don't think that's a good idea.

* PTRACE_CONT would be behaving completely differently depending on
  whether it's resuming from group stop or other traps.

> To be honest, I don't understand whether I changed my mind now, or
> I was never against this particular change in behaviour.
> 
> Once debugger does PTRACE_CONT, the tracee becomes TASK_STOPPED and
> now it is "visible" to SIGCONT (or the tracee resumes if SIGCONT has
> come in between).
> 
> But I think you will equally blame this TRACED/STOPPED transition
> as "behavioral subtleties" and I can understand you even if I disagree.
> And yes, this leads to other questions. But note that this greatly
> simplifies things. The tracee can never participate in the same
> group-stop twice.

But that's not really because the problem is solved.  The problem is
put out of scope by forcing the tracer to always override group stop.
That's a rather big departure from the current behavior and capability
and I frankly think is not a good direction to head to.  It's like
giving up useful features for conceptual purity.  We can make it work
without regressing on capabilities.

Thanks.

-- 
tejun
