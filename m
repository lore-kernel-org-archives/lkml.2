Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab1BRTp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:45:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab1BRTpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:45:24 -0500
Date: Fri, 18 Feb 2011 20:37:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110218193709.GA9700@redhat.com>
References: <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110214175144.GC15847@redhat.com> <AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com> <20110214190141.GA19221@redhat.com> <AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com> <20110214200130.GA21559@redhat.com> <20110215152448.GL3160@htj.dyndns.org> <20110215173149.239601807B7@magilla.sf.frob.com> <20110215202747.GA20560@redhat.com> <20110218170212.GS21209@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218170212.GS21209@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On 02/18, Tejun Heo wrote:
> Hello, Oleg.
>
> Still trying to follow the new discussion.

And how it goes?

As for me, I am not sure I can follow it ;)

> On Tue, Feb 15, 2011 at 09:27:47PM +0100, Oleg Nesterov wrote:
> > > The reason for the transition to TASK_TRACED is to prevent a race with
> > > SIGCONT waking the task.  There is always a race with SIGKILL waking it,
> > > but the circumstances where that can really matter are far fewer.
> > > You need to make sure that the work PTRACE_GETSIGINFO does to access
> > > last_siginfo cannot race with that pointer disappearing or the stack
> > > space it points to becoming invalid.  I think the use of siglock ensures
> > > that, but Oleg should verify it.
> >
> > Yes, I think this is safe.
> >
> > I do not really like this idea because it looks a bit strange to treat
> > PTRACE_GETSIGINFO specially, and this doesn't solve all problems. And,
> > once again, I still hope we can change ptrace_resume() so that it doesn't
> > wakeup the stopped (I mean, SIGNAL_STOP_STOPPED) tracee, in this case this
> > hack is not needed.
> >
> > And. We are going to add the new requests which doesn't need the stopped
> > tracee anyway. So we can just add PTRACE_HAS_SIGINFO which returns
> > child->last_siginfo != NULL. This looks simpler, and this is compatible.
> > Of course this check is racy, but this doesn't matter. PTRACE_GETSIGINFO
> > is equally racy if it doesn't change the state to TASK_TRACED.
>
> This is probably where we disagree the most but I think the weird part
> isn't making PTRACE_GETSIGINFO exempt from TASK_TRACE transition.  The
> weirdness starts when the tracee is put into TASK_STOPPED while being
> ptraced.  I think such dual modes of operation inherently lead to
> strange problems.
>
> Instead of having simple "a ptracer stops in TASK_TRACED and its
> execution is under the control of ptrace",

In fact, I am not sure I really disagree with this part, but see below.

> The patch which puts the tracee into TASK_TRACED
> on ATTACH already fix two problems discussed in this thread without
> doing anything wonky.  I think it says a lot.

Yes. One off-topice note... if we are talking about this patch only,
I do not think it makes sense to add the new member into task_struct
so that STOPPED/TRACED transition can always report the exactly correct
->exit_code. I think we can just use group_exit_code ?: SIGSTOP.
But, again, this is off-topic.


> As it currently stands, SIGSTOP/CONT while ptraced doesn't work

And this is probably where we disagree the most. I think this is bug,
and this should be fixed.

> and
> even if we bend the rules subtly and provide sneaky ways like the
> above, userland needs to be modified to make use of it anyway.

Yes. But with the current code we can't modify, say, strace so
that SIGSTOP/CONT can work "correctly".

> I
> think it would be far cleaner to simply make ptracee always stop in
> TASK_TRACED and give the ptracer a way to notice what's happening to
> the tracee

Well. If we accept the proposed PTRACE_CONT-needs-SIGCONT behaviour,
then I think this probably makes sense. The tracee stops under ptrace,
the possible SIGCONT shouldn't abuse debugger which wants to know, say,
the state of registers.

To be honest, I don't understand whether I changed my mind now, or
I was never against this particular change in behaviour.

Once debugger does PTRACE_CONT, the tracee becomes TASK_STOPPED and
now it is "visible" to SIGCONT (or the tracee resumes if SIGCONT has
come in between).

But I think you will equally blame this TRACED/STOPPED transition
as "behavioral subtleties" and I can understand you even if I disagree.
And yes, this leads to other questions. But note that this greatly
simplifies things. The tracee can never participate in the same
group-stop twice.

Oleg.

