Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1A1UbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:31:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1A1UbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:31:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 09/16] ptrace: make do_signal_stop() use ptrace_stop()
 if the task is being ptraced
In-Reply-To: Tejun Heo's message of  Thursday, 27 January 2011 14:56:31 +0100 <20110127135631.GD24925@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
	<1291654624-6230-10-git-send-email-tj@kernel.org>
	<20101223122634.GA365@redhat.com>
	<20110117220923.EA622180996@magilla.sf.frob.com>
	<20110127135631.GD24925@htj.dyndns.org>
X-Zippy-Says: Now that we're in LOVE, you can BUY this GOLDFISH for a 48% DISCOUNT.
Message-Id: <20110128203018.8998B183C1E@magilla.sf.frob.com>
Date: Fri, 28 Jan 2011 12:30:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think we're getting a bit off course here.  

I was thinking out loud to share the rationale behind my reactions.

> The CONT problem in this context isn't generic at all.  In principle,
> CONT doesn't (immediately) work on a ptraced task.  We basically just had
> this window where STOPPED -> TRACED transition was delayed in which CONT
> worked.  It's more of a behavioral inconsistency than anything else.

SIGCONT works just fine on a process that is being traced.  It only resumes
on a process that is in job control stop rather than tracing stop, but then
it works normally.  The other effects of SIGCONT (to clear all pending stop
signals at generation time, and to make a SIGCONT signal pending for later
delivery if it's not ignored or default-ignored) always work.  It is a
further wrinkle that any ptrace operation on a thread that is in job
control stop morphs that into tracing stop.  But it's just not true to say
that "in principle" SIGCONT doesn't work.

> If a task was RUNNING when PTRACE_ATTACH happens, when the tracer
> wait(2) completes, the task is TRACED and won't immediately respond to
> CONT.  If a task was STOPPED, CONT can still wake up between the
> completion of wait(2) and the first ptrace command on the tracee.
> It's a subtle inconsistency which I don't believe anyone could have
> taken advantag of.

I think you underestimate the fiddliness of userland ptrace users.

> As for the generic discussion of group stop vs. ptrace, yeah, there's
> a lot to discuss and as I already wrote before I don't think there
> will be a single behavior which would satisfy all the requirements.  I
> think it would be best to iron out the existing inconsistencies in a
> way which doesn't break the current users and then gradually introduce
> a few more ptrace operations which have well defined and more flexible
> interaction with group stop.

I agree with that overall sentiment, as I think I said before.

> As I wrote in another reply, the visibility is masked from the tracer
> and only visible if the user does a pretty convoluted thing.  Unless
> there's such current user, I think we can clearly define what's
> guaranteed regarding ptrace/wait interaction and leave cases outside
> of it as undefined.

I don't really buy the "masked" claim.

> Sure, I definitely agree but at the same time that doesn't mean we
> shouldn't improve ptrace at all.  It just means it's delicate and we
> should proceed carefully, which we shall.

And so we are.  I'm just pushing on the degree of caution.

> Yeap, definitely.  I want to make things just clean enough so that it
> doesn't hinder introduction of improvements while not breaking the
> existing users, but things like silent STOPPED -> TRACED transition
> are outright buggy and have to be fixed one way or the other.  We
> can't ignore them.

I don't agree with "outright buggy".  It's a well-defined situation that
has been well understood for quite some time, by possibility as many as
three people.

> There are two extremes.  You can put ptrace under group stop or
> completely the other way around.  I think there are valid use cases
> for both of them.  I'll try to summarize it later.

I look forward to that elucidation.  I can't really imagine a rationale I'd
accept for anything contrary to what I said about the supremacy of group stops.

> Heh, I was the late one this time.  I'll soon repost the refreshed
> STOPPED <-> TRACED patchset.  I think we're mostly in agreement
> regarding that part.

Mostly.  Mostly. ;-)


Thanks,
Roland
