Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1BNTCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:02:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab1BNTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:02:18 -0500
Date: Mon, 14 Feb 2011 19:53:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214185338.GF15847@redhat.com>
References: <20110204170602.GB15301@redhat.com> <20110205133926.GM12133@htj.dyndns.org> <20110207134235.GB22538@redhat.com> <20110207141135.GA16992@htj.dyndns.org> <20110207153723.GA27997@redhat.com> <20110207163121.GB16992@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <20110209212526.GA9999@redhat.com> <20110214145024.GN18742@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214145024.GN18742@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Tejun Heo wrote:
>
> Hello, Oleg.  Sorry about the delay.
>
> On Wed, Feb 09, 2011 at 10:25:26PM +0100, Oleg Nesterov wrote:
> > >   Note that { the task is put into TASK_TRACED state and group stop
> > >   resume by SIGCONT is ignored. | the task is put into TASK_STOPPED
> > >   state and the following PTRACE request will transition it into
> > >   TASK_TRACED.  If SIGCONT is received before transition to
> > >   TASK_TRACED is made, the task will resume execution.  If PTRACE
> > >   request faces with SIGCONT, PTRACE request may fail. }
> >
> > To me, the first variant looks better. But, only because it is closer
> > to the current behaviour. I mean, it is better to change the things
> > incrementally.
>
> Alright, it's the first variant then.
>
> > But in the longer term - I do not know. Personally, I like the
> > TASK_STOPPED variant. To the point, I was thinking that (perhaps)
> > we can change ptrace_stop() so that it simply calls do_signal_stop()
> > if it notices ->group_stop_count != 0.
>
> I don't know.  IMHO it's enough to give the ptracer a way to honor
> group stop and notification so things like strace can stay more or
> less transparent.  I don't think it's something we need to enforce.

Agreed, I don't know too.

> > And this is what I do not like. I just can't accept the fact there
> > is a running thread in the SIGNAL_STOP_STOPPED group.
>
> Let's agree to disagree here.  I agree it's weird but don't think it's
> necessarily a bad thing that needs to be changed.

Yes, I see.

> > Yes! and this is very good argument in favour of all your objections ;)
>
> My objections to what?  The one thing that I'm really against is
> allowing group stop to override PTRACE_CONT and that's visible
> regardless of notifications.  Other than that, I think we're pretty
> much in agreement now, aren't we?

Ah, OK, good.

> > Oh, currently I am ignoring this, my only concern is how this all
> > looks to the userland. But this is the good point, and I have to admit
> > that I never realized this is just wrong. Yes, I agree, we should do
> > something, but this is not visible to user-space (except this should
> > fix the bug ;)
>
> Mostly not but there's the obscure window where the tracee goes
> through TASK_RUNNING which can be visible from userland from another
> task of the ptracer group, which I think is ignorable as long as it's
> properly masked from the ptracing task itself.  I wanted to make sure
> we agree on that one.

I think we are.

> > Sure, if we are talking about SIGCONT from "nowhere". But, the same
> > way ^Z is not reliable too.
>
> It doesn't even have to be from "nowhere".  A process can be raising
> SIGCONT itself.  To me, the whole thing feels more like an
> administration aid by design than a strict monitor/control mechanism.

Yes, this is true.

> > I hate this from the time when I noticed that the application doesn't
> > respond to ^Z under strace. And I used strace exactly because I wanted
> > do debug some (I can't recall exactly) problems with jctl. That is all.
> >
> > But in any case. Some users run the services under ptrace. I mean,
> > the application borns/runs/dies under ptrace. That is why personally
> > I certainly do not like anything which delays until detach (say,
> > the-tracee-doesnt-participate-in-group-stop-until-detach logic).
>
> I see, so let's make them participate in the group stop and notify the
> real parent of the group stop.

Great.

> As long as PTRACE_CONT behavior isn't
> changed, I don't object.

Well, this is important. And, the changes above depend on this. I mean,
if we do not change PTRACE_CONT behavior, then the tracee should remember
if it already participated in this group stop (like you previous patches
did).

I do not think I can add something else to this discussion. But as you
already noticed, Denys has joined the club ;)

And I hope Jan and Roland can comment this too.

I won't argue any longer (at least I'll try ;), I understand your concerns.

Oleg.

