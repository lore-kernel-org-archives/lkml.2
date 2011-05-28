Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab1E1Hcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 03:32:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58458 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1E1Hcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 03:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YCQFDerVn3EgzToGmN41VjpAVTfzuy6hmCFkyLbug5JErmruOawA8JHjbWzgnYRQYH
         71vzwWq8C/f4I/E/YTY35UeL7bv4OyayfzstwhX0Z2RhWSJGWnE/u2pQ+OkhaVzdO4DQ
         UpBoQHmrVTFse44qqQyA3vbMbfpzd/JAnvcdA=
Date: Sat, 28 May 2011 09:32:24 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
 ptracer
Message-ID: <20110528073224.GB3212@mtj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-11-git-send-email-tj@kernel.org>
 <20110519163246.GF17265@redhat.com>
 <20110519165833.GA19418@redhat.com>
 <20110523114559.GA5279@redhat.com>
 <20110524134411.GE10334@htj.dyndns.org>
 <20110526144402.GA12525@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526144402.GA12525@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Thu, May 26, 2011 at 04:44:02PM +0200, Oleg Nesterov wrote:
> IOW. The tracee is no longer quiescent after PTRACE_JOBCTL_CONT. It is
> still TASK_TRACED (although we could use another state), but it is
> waiting for another jobctl state change. The tracer should wait for
> notification (or call wait) as usual. No need to hide the TRACED->
> RUNNING->TRACED transition during the re-trapping.

Ah, okay, this makes it much clearer to me.  Thanks for the
explanation.

> To me this looks really simpler and more understandable for the user
> space. If the simple tracer doesn't care about SIGCONT it can simply
> do PTRACE_CONT without PTRACE_GETSIGINFO.

But, I'm not sure it achieves that.  Please read on.

> If we add PTRACE_JOBCTL_CONT, I think we can sample the state when
> the task is going into trap. If the tracer cares about the next state
> change, the tracee will trap again.

Oh, this is a separate issue.  Your suggestoin only narrows the window
in which re-trap is allowed to happen.  GETSIGINFO being generated on
request doesn't have much to do with that.  It's determined by who is
considered to be notification consumer.

I suppose you're suggesting STOP_TRAP to be the consumer such that
there will be at least one STOP_TRAP after each group stop state
change and the user is required to fetch what happened after each
STOP_TRAP - ie. the chain of custody becomes event -> TRAP_STOP ->
GETSIGINFO instead of event -> GETSIGINFO.

I did the direct thing primarily because I thought it was a primarily
separate thing from tracee state itself but yeah I can see going
through TRAP_STOP could be better, but I don't think it has anything
to do with when to allow re-trap.

> > Ah, okay, so, it does re-trap on SIGCONT but it happens only after
> > JOBCTLY_PLEASE_NOTIFY is set.  Then the only thing which changes is
> > removal of wait(2) retry logic at the cost of requiring the user to
> > use a new request and stating that WNOHANG wait might fail
> > unexpectedly after PTRACE_JOBCTL_CONT.
> 
> Yes. Except "unexpectedly" is a bit confusing. Once again, the tracee
> is no longer quiescent.

But we better make the behavior consistent.  If it's non-quiescent,
make wait(2) and non-INTERRUPT ptrace requests should fail
consistently; otherwise, users are likely to get it wrong and such
bugs can be very difficult to track down and reproduce.

> I must admit, I am a bit biased because I think this makes the
> implementation more simple. But my point is, _in my opinion_
> PTRACE_JOBCTL_CONT is better from the user-space pov.

I can't agree there.  More on this below.

> > the re-trapping and on-the-fly GETSIGINFO are adding a rather
> > generic async notification mechanism for ptrace,
> 
> For what? Why this is good?

The thing I liked about it was that it's a straight forward mostly
independent event mechanism.  It may be used for other events and it
forces the user to follow event delivery protocol (otherwise, trap
won't clear).  If you forget about GETSIGINFO and consider it to be a
different thing - say PTRACE_GETEVENTS or something - it really is
straight forward.  The entanglement with GETSIGINFO is a bit messy but
that's what we compromise when trying to live with legacy interface.

Anyways, I'm perfectly fine with sticky TRAP_STOP too.  It makes sense
in a different, more group stop specific way.

> It was always true that once the tracee reports the trap it is
> completely quiescent untill debugger resumes it (except SIGKILL).
> This is simple and understandable. Why should we change this?

It's a bit besides the point but just for the record.  It hasn't been
true upto 2.6.40-rc1.  Group stopped tracee could be woken up by
SIGCONT before, so we actually had userland-visible non-quiescent
state.

Anyways, the task is quiescent when viewed from userland.  That's the
whole point of TRAPPING.  Making the re-trapping transparent.  When
viewed from userland, the only difference between TRAPPING and
JOBCTL_CONT is when re-trapping is allowed.

With TRAPPING, re-trapping is allowed whenever tracee is in TRAP_STOP
and the tracee is considered to be in quiescent state through the
whole time - ie. wait(2) and ptrace(2) operatons aren't affected by
generation of new event - I suppose this is the part that you don't
like.

With JOBCTL_CONT, re-trapping is allowed while tracee is in TRAP_STOP
and after JOBCL_CONT is issued and after JOBCTL_CONT is issued the
tracee is considered non-quiescent until the next trap (which can be
caused by group stop event or explicit INTERRUPT request).  As tracee
can be trated as non-quiescent, wait(2) and ptrace(2) don't need to be
transparent against async events - we can just fail them.  Note that
we still need to change wait(2) so that it recognizes the state and
fails.

Hmmm... yeah, I agree, the making-it-transparent part is tricky and
implementation would be simpler with JOBCTL_CONT (BTW I hope we can
find a better name.  It's a bit confusing to me.); however, if we
forget about implementation details and view it from userland POV, I
think TRAPPING is the better behavior.

The notification itself isn't intrusive - for the most part it's just
generation of another exit_code which can be fetched by the user if it
wants to, so there really isn't much to be gained from userland with
JOBCT_CONT.  Its primary appeal is that it can simplify kernel
implementation, which is not a bad thing at all.  It's a bit messier
to use from userland but not by too much and doesn't compromise any
functionality AFAICS, so yeah, maybe.

Thanks.

-- 
tejun
