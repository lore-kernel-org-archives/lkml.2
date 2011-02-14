Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab1BNOvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:51:02 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45654 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab1BNOvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:51:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w4TRYDUZJWRo4eAR2TFYMKK8jrM3+Ozvb3ujpTl8+q8pQNMXl4OoHoDCFeV8zcDyKQ
         +wR35IWQiwKM1Mk2Rtm4sDC7AKV83hBielL3pGVsQMhOT810qyc9AdMMd0y//okvyzlg
         6L1aJ+v2uRWCynRzq6FMAfzl2l8xQ5HM03ge4=
Date: Mon, 14 Feb 2011 15:50:24 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110214145024.GN18742@htj.dyndns.org>
References: <20110204144858.GI12133@htj.dyndns.org>
 <20110204170602.GB15301@redhat.com>
 <20110205133926.GM12133@htj.dyndns.org>
 <20110207134235.GB22538@redhat.com>
 <20110207141135.GA16992@htj.dyndns.org>
 <20110207153723.GA27997@redhat.com>
 <20110207163121.GB16992@htj.dyndns.org>
 <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
 <20110209212526.GA9999@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209212526.GA9999@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.  Sorry about the delay.

On Wed, Feb 09, 2011 at 10:25:26PM +0100, Oleg Nesterov wrote:
> >   Note that { the task is put into TASK_TRACED state and group stop
> >   resume by SIGCONT is ignored. | the task is put into TASK_STOPPED
> >   state and the following PTRACE request will transition it into
> >   TASK_TRACED.  If SIGCONT is received before transition to
> >   TASK_TRACED is made, the task will resume execution.  If PTRACE
> >   request faces with SIGCONT, PTRACE request may fail. }
> 
> To me, the first variant looks better. But, only because it is closer
> to the current behaviour. I mean, it is better to change the things
> incrementally.

Alright, it's the first variant then.

> But in the longer term - I do not know. Personally, I like the
> TASK_STOPPED variant. To the point, I was thinking that (perhaps)
> we can change ptrace_stop() so that it simply calls do_signal_stop()
> if it notices ->group_stop_count != 0.

I don't know.  IMHO it's enough to give the ptracer a way to honor
group stop and notification so things like strace can stay more or
less transparent.  I don't think it's something we need to enforce.

> >   The ptracer may resume execution of the task using PTRACE_CONT
> >   without affecting other tasks in the group.
> 
> And this is what I do not like. I just can't accept the fact there
> is a running thread in the SIGNAL_STOP_STOPPED group.

Let's agree to disagree here.  I agree it's weird but don't think it's
necessarily a bad thing that needs to be changed.

> But yes: this is what the current code does, I am not sure we can
> change this, and both PTRACE_CONT-doesnt-resume-until-SIGCONT and
> PTRACE_CONT-acts-as-SIGCONT are not "perfect" too.

Yeap.

> > I'm not sure how much of an actual problem it is given that our
> > notification to real parent hasn't worked at all till now
> 
> Yes! and this is very good argument in favour of all your objections ;)

My objections to what?  The one thing that I'm really against is
allowing group stop to override PTRACE_CONT and that's visible
regardless of notifications.  Other than that, I think we're pretty
much in agreement now, aren't we?

> > but we can definitely implement proper TASK_STOPPED ->
> > TRACED transition on the next PTRACE request.
> 
> I guess, you mean that the current code bypasses the
> ptrace_stop()->arch_ptrace_stop_needed() code while doing s/STOPPED/TRACED ?

Yes.

> Oh, currently I am ignoring this, my only concern is how this all
> looks to the userland. But this is the good point, and I have to admit
> that I never realized this is just wrong. Yes, I agree, we should do
> something, but this is not visible to user-space (except this should
> fix the bug ;)

Mostly not but there's the obscure window where the tracee goes
through TASK_RUNNING which can be visible from userland from another
task of the ptracer group, which I think is ignorable as long as it's
properly masked from the ptracing task itself.  I wanted to make sure
we agree on that one.

> > If we don't go that route, another solution would be to add a ptrace
> > call which can listen to SIGCONT.  ie. PTRACE_WAIT_CONT or whatever
> > which the ptracer can call once it knows the tracee entered group
> > stop.
> 
> Perhaps... Or something else, but surely there is a room for improvements.
> Fortunately, the changes like this are "safe". I mean, they can
> break nothing. Just we should try to not make them wrong ;)

But if we go with the first option and strace and friends can stay
mostly transparent, I don't think we'll really need this change.  It's
a bit hairy but still usable.

> > In either case, the fundamentals of ptrace operation don't really
> > change.  All ptrace operations are still per-task and ptracer almost
> > always has control over execution of the tracee.  Sure, it allows
> > ptraced task to escape group stop but it seems defined clear enough
> > and IMHO actually is a helpful debugging feature.
> 
> Heh, I think we found the place where we can't convince each other.
> What if we toss a coin?

Right, let's leave it alone for now.

> > After all, it's not like stop signals can be used for absoultely
> > reliable job control.  There's an inherent race against SIGCONT.
> 
> Sure, if we are talking about SIGCONT from "nowhere". But, the same
> way ^Z is not reliable too.

It doesn't even have to be from "nowhere".  A process can be raising
SIGCONT itself.  To me, the whole thing feels more like an
administration aid by design than a strict monitor/control mechanism.
This is quite subjective, I agree.

> > but other than the conceptual integrity it widely changes the
> > assumptions and is less useful than the current behavior.
> 
> Hmm, this is what we currently have?

I'm a bit lost on what you mean above but I was still talking about
PTRACE_CONT being able to escape group stop.

> > The debugger is still notified and can override it.
> 
> Hmm... no, it can't? Of course it is notified after the tracee
> participates and calls do_signal_stop() and gdb can resume it then.
> But it can't prevent the tracee from stopping.

That was what I meant.  It can't prevent group stop from happening but
it knows when it happens and can escape it.

> > I can't really agree there.  First, to me, it seems like too radical a
> > change
> 
> (I assume you mean PTRACE_CONT-doesnt-resume variant?)

Yeah, maybe I was a bit too obsessed with it?  :-)

> > > Given that SIGCHLD doesn't queue and with or without your changes
> > > we send it per-thread, it is not trivial for gdb to detect the
> > > group-stop anyway. Again, the kernel should help somehow.
> >
> > Hmmm?  Isn't this discoverable from the exit code from wait?
> 
> Sure. Probably I misunderstood. I thought, you mean we need something
> like per-process "the whole group is stopped" notification for the
> debugger.

Oh, I didn't mean that.  Just the usual trace task specific
notification.

> > I think it's worse.  With your changes, debuggers can't diddle the
> > tasks behind group stop's back which the current users already expect.
> 
> OK, I certainly misunderstood you, and now I can't restore the context.
> Could you spell?

I was still talking about PTRACE_CONT escaping the tracee from group
stop.

> > Heh, I'm not asking for proof that it is more useful. :-) But I'm still
> > curious why you think it's important because the benefits aren't
> > apparent to me.  Roland and you seem to share this opinion without
> > much dicussion so maybe I'm missing something?
> 
> I can't!
> 
> I hate this from the time when I noticed that the application doesn't
> respond to ^Z under strace. And I used strace exactly because I wanted
> do debug some (I can't recall exactly) problems with jctl. That is all.
> 
> But in any case. Some users run the services under ptrace. I mean,
> the application borns/runs/dies under ptrace. That is why personally
> I certainly do not like anything which delays until detach (say,
> the-tracee-doesnt-participate-in-group-stop-until-detach logic).

I see, so let's make them participate in the group stop and notify the
real parent of the group stop.  As long as PTRACE_CONT behavior isn't
changed, I don't object.

> > If I change the patchset such that group stop while ptraced first
> > enters TASK_STOPPED and then transitions into TASK_TRACED on the next
> > PTRACE call,
> 
> Again, I am not sure I understand what exactly you mean... If you
> mean that it is wrong to simply change the state of the tracee in
> ptrace_check_attach() without arch_ptrace_stop() - I agree, this
> probably should be fixed.

Yeap, that one.

> I am wondering, if there is a simpler change... probably not.
> 
> But. this looks a bit off-topic (I mean, this looks orthogonal
> to the other things we are discussing), or I missed something else?

Hmmmm... maybe I'm missing something but I think we're in kind of
agreement now.  I'm gonna change the patchset such that SIGSTOP while
being ptraced would group stop the tracee so that SIGCONT can wake it
up, which will makes the only changes visible to userland the odd race
window things.

> > there will be race window which would be visible
> 
> Personally, I think this is fine.

Alright.

Thanks.

-- 
tejun
