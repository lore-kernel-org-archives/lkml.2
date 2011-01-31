Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab1AaOjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:39:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1AaOjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YKnZYPTHVikAs0OcAaonuARt6EhDdJ9YCvnln3T0BiAs8t4U7xvEumZ+hpPZMw0qSk
         wVmobZTnZ8ON6BY59bckNNf92eW0CKc6Bpq3WFfVJ2kQCgbQ1wlUTzoKkIa8dcgDGbmE
         nsoPEcuBYaxyX570vCxJWdfA3fovPMdZncDEk=
Date: Mon, 31 Jan 2011 15:39:36 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 09/16] ptrace: make do_signal_stop() use ptrace_stop()
 if the task is being ptraced
Message-ID: <20110131143936.GJ7459@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-10-git-send-email-tj@kernel.org>
 <20101223122634.GA365@redhat.com>
 <20110117220923.EA622180996@magilla.sf.frob.com>
 <20110127135631.GD24925@htj.dyndns.org>
 <20110128203018.8998B183C1E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128203018.8998B183C1E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Roland.

On Fri, Jan 28, 2011 at 12:30:18PM -0800, Roland McGrath wrote:
> > I think we're getting a bit off course here.  
> 
> I was thinking out loud to share the rationale behind my reactions.

I see.

> > The CONT problem in this context isn't generic at all.  In principle,
> > CONT doesn't (immediately) work on a ptraced task.  We basically just had
> > this window where STOPPED -> TRACED transition was delayed in which CONT
> > worked.  It's more of a behavioral inconsistency than anything else.
> 
> SIGCONT works just fine on a process that is being traced.  It only resumes
> on a process that is in job control stop rather than tracing stop, but then
> it works normally.

I'm afraid it's not that clear.  I wish it were but it simply isn't.
There's no clear distinction between group stopped and trapped state
as group stopped tasks silently transit to trapped state in racy,
non-obvious and buggy (in that it skips arch hooks) manner.

The ambiguity in completion and notification of group stop also
contributes to non-deterministic behavior.  Before the patchset, a
ptrace task would happily report that it participated in group stop
triggering group stop notification (which also is buggy and wouldn't
reach the parent reliably BTW) even when it's stopping for ptrace
trap.  SIGCONT may or may not work depending _both_ on where the task
has stopped and whether the tracee has received another ptrace call
after that or not.

There's nothing even resembling consistency in that direction and it's
no wonder userland had so many problems and needed to grow hacks to
work around quirky behaviors.

The ironic upper side of all those inconsistencies is that we can flip
the behavior to one side and be relatively safe as the userland must
have been dealing with non-deterministic behavior until now.

So, I really can't agree that the current behavior regarding group
stop is "just fine".  It's utterly incoherent.  It simply is that the
userland learned to cope with it and we can and better make it
consistent within the limits of the current inconsistent behavior.

> The other effects of SIGCONT (to clear all pending stop
> signals at generation time, and to make a SIGCONT signal pending for later
> delivery if it's not ignored or default-ignored) always work.  It is a
> further wrinkle that any ptrace operation on a thread that is in job
> control stop morphs that into tracing stop.  But it's just not true to say
> that "in principle" SIGCONT doesn't work.

I really don't think "it may work depending on where it stops and
whether there's another ptrace call afterwards" can be called working
in any principle.  It is broken.

> > If a task was RUNNING when PTRACE_ATTACH happens, when the tracer
> > wait(2) completes, the task is TRACED and won't immediately respond to
> > CONT.  If a task was STOPPED, CONT can still wake up between the
> > completion of wait(2) and the first ptrace command on the tracee.
> > It's a subtle inconsistency which I don't believe anyone could have
> > taken advantag of.
> 
> I think you underestimate the fiddliness of userland ptrace users.

Give me one realistic scenario where the above would actually affect
userland, or better, an actually used program which breaks due to the
above change.  I might look like coming off too aggressively but to me
it seems like the don't-change-the-current-behavior principle is being
taken too far.  I do agree that we shouldn't be breaking existing
users but at the same time there should be a balance - a trade-off at
the right point.  Almost all ptrace users follow up PTRACE_ATTACH,
wait sequence with another PTRACE request, and the above change would
increase behavioral consistency.

If there actually is an user, we can change the behavior such that
SIGCONT is followed until the second PTRACE request, which should
probably be implemented by making the first ptrace_check_attach()
call, instead of PTRACE_ATTACH, put the tracee into TRACED state.  I
think it should be doable but that behavior is extremely subtle and
thus likely to cause more confusion for its users.  Its description
would go like the following,

  PTRACE_ATTACH stops the tracee and the tracer can wait for it with
  wait(2); however, regardless of wait(2) success, SIGCONT is allowed
  to wake up the tracee until the next ptrace request and if SIGCONT
  is received before the next ptrace request, the ptrace request might
  fail with -ESRCH.  Once the next ptrace request has succeeded,
  further SIGCONT are ignored until the task participates in another
  group stop which can't be determined reliably by the tracer.

With the proposed patchset, it becomes,

  PTRACE_ATTACH stops the tracee and the tracer can wait for it with
  wait(2).  Once attached, whenever wait(2) indicates task stop, it is
  guaranteed that all ptrace requests don't fail with -ESRCH and the
  tracee stays stopped until continued or detached by the tracer or
  killed with SIGKILL.

To me, arguing that the first description is better sounds quite far
fetched.  If we _absolutely_ have to, well, we'll have to, but let's
not mold ourselves into that mess if at all possible.

> > As for the generic discussion of group stop vs. ptrace, yeah, there's
> > a lot to discuss and as I already wrote before I don't think there
> > will be a single behavior which would satisfy all the requirements.  I
> > think it would be best to iron out the existing inconsistencies in a
> > way which doesn't break the current users and then gradually introduce
> > a few more ptrace operations which have well defined and more flexible
> > interaction with group stop.
> 
> I agree with that overall sentiment, as I think I said before.

Awesome. :-)

> > As I wrote in another reply, the visibility is masked from the tracer
> > and only visible if the user does a pretty convoluted thing.  Unless
> > there's such current user, I think we can clearly define what's
> > guaranteed regarding ptrace/wait interaction and leave cases outside
> > of it as undefined.
> 
> I don't really buy the "masked" claim.

Hah?  It's not a claim that I'm trying to sell out of thin air.  It's
actually masked.  There's no way for the tracer to see it (outside the
/proc state, that is).  It's properly and completely masked from the
tracer.

> > Sure, I definitely agree but at the same time that doesn't mean we
> > shouldn't improve ptrace at all.  It just means it's delicate and we
> > should proceed carefully, which we shall.
> 
> And so we are.  I'm just pushing on the degree of caution.

Yeah, your reviews are much appreciated.  Please don't take the heated
arguments as attacks.  :-)

> > Yeap, definitely.  I want to make things just clean enough so that it
> > doesn't hinder introduction of improvements while not breaking the
> > existing users, but things like silent STOPPED -> TRACED transition
> > are outright buggy and have to be fixed one way or the other.  We
> > can't ignore them.
> 
> I don't agree with "outright buggy".  It's a well-defined situation that
> has been well understood for quite some time, by possibility as many as
> three people.

We'll have to agree to disagree on that.  To me, the overall behavior
seems extremely inconsistent and filled with implementation details
leaking out to userland without clearly defined intentions.  As I
wrote in another reply, the only upside seems to be that we probably
have quite a leeway in changing the behavior thanks to the
inconsistencies as userland already has had to deal with them.  In
many cases, we should be able to choose one mode of operation among
the various inconsistent behaviors and stick with it without breaking
userland.

> > There are two extremes.  You can put ptrace under group stop or
> > completely the other way around.  I think there are valid use cases
> > for both of them.  I'll try to summarize it later.
> 
> I look forward to that elucidation.  I can't really imagine a
> rationale I'd accept for anything contrary to what I said about the
> supremacy of group stops.

But, with or without future use cases, currently group stop is already
inferior to ptrace and that is very visible to userland.  There is no
way we can change that without breaking the current users.  It doesn't
even fall inside the range of inconsistent behaviors.

> > Heh, I was the late one this time.  I'll soon repost the refreshed
> > STOPPED <-> TRACED patchset.  I think we're mostly in agreement
> > regarding that part.
> 
> Mostly.  Mostly. ;-)

Thank you.  :-)

-- 
tejun
