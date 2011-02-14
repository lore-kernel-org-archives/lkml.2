Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1BNQAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:00:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740Ab1BNQAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:00:18 -0500
Date: Mon, 14 Feb 2011 16:51:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214155136.GC8761@redhat.com>
References: <20110204130455.GA3671@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <20110209212526.GA9999@redhat.com> <201102140001.47218.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102140001.47218.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Denys Vlasenko wrote:
>
> On Wednesday 09 February 2011 22:25, Oleg Nesterov wrote:
> >
> > But yes: this is what the current code does, I am not sure we can
> > change this, and both PTRACE_CONT-doesnt-resume-until-SIGCONT and
> > PTRACE_CONT-acts-as-SIGCONT are not "perfect" too.
>
> Can you enumerate reasons why each of them are not perfect?
> I want to understand your thinking better here.

Standard answer: this can break things ;)

Also, PTRACE_CONT-acts-as-SIGCONT looks a bit ugly, it can wakeup
other tracees (or we can turn them into TASK_TRACED, I dunno).

> > Yes, and this race is already here, ptracer should take care.
>
> From the API POV, there is no race,

Sorry for confusion... I just meant that if the tracee is TASK_STOPPED
then ptrace(PTRACE_WHATEVER) can always fail if it races with SIGCONT
from the third party.

> > > In either case, the fundamentals of ptrace operation don't really
> > > change.  All ptrace operations are still per-task and ptracer almost
> > > always has control over execution of the tracee.  Sure, it allows
> > > ptraced task to escape group stop but it seems defined clear enough
> > > and IMHO actually is a helpful debugging feature.
> >
> > Heh, I think we found the place where we can't convince each other.
> > What if we toss a coin?
>
> I'm with Oleg on this. If debugger wants to terminate group-stop,
> it should just send SIGCONT, not depend on the obscure feature (it is not
> documented, right?) that PTRACE_CONT somehow affects group-stop state.

Yes, this is PTRACE_CONT-doesnt-resume-until-SIGCONT suggested by Roland.

But Tejun rightly points this can confuse gdb (and nobody knows what
else ;) Can we do this change and require the applications to learn
the new rules? I do not know.

> > I hate this from the time when I noticed that the application doesn't
> > respond to ^Z under strace. And I used strace exactly because I wanted
> > do debug some (I can't recall exactly) problems with jctl. That is all.
>
> Recently I had exactly this experience too. It's frustrating.

Agreed.

> You just succeeded :)

Thanks ;)

Oleg.

