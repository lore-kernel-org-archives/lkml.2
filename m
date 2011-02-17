Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab1BQT2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:28:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211Ab1BQT2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:28:06 -0500
Date: Thu, 17 Feb 2011 20:19:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110217191952.GA13611@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110216215157.GA6054@host1.dyn.jankratochvil.net> <201102170437.51382.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102170437.51382.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Denys Vlasenko wrote:
>
> Hi Jan,
>
> Thanks for joining!

Yep ;)

> On Wednesday 16 February 2011 22:51, Jan Kratochvil wrote:
>
> > The current upstream GDB trick of
> >   PTRACE_ATTACH
> >   if /proc/PID/status->State: == `T (stopped)'
> >     tgkill(SIGSTOP)
> >     PTRACE_CONT(0)
> >   waitpid->SIGSTOP (or preceded by some other signal but 1x SIGSTOP will come)
>
> I don't fully understand the steps of the trick.

Please see my reply to Jan. In short: ->exit_code can be zero after
attach. This is unlikely case after 90bc8d8b, but still possible.

> I believe there is a proposal to add PTRACE_ATTACH_NOSTOP+PTRACE_INTERRUPT,

(This is more or less orthogonal to the discussed problem, I think
 we should discuss this separately).

> > That is after PTRACE_DETACH(0) the process should remain `T (stopped)'
> > iff the process was `T (stopped)' before PTRACE_ATTACH.
> >  - PTRACE_DETACH(0)       should preserve `T (stopped)'.
>
> I assume you are thinking about PTRACE_ATTACH + wait():SIGSTOP
> + PTRACE_DETACH(0) sequence.

plus it should be stopped before attach, I assume. Otherwise this
not true with the current code.

> It looks logical to use 0 in *this* sequence, but consider
> the following sequence:
>
> ....
> ptrace(PTRACE_CONT, 0)
> waitpid(): got SIGFOO
> ptrace(PTRACE_CONT/SYSCALL/DETACH, 0)

Agreed, and this matches (I hope) my reply.

> Regarding PTRACE_ATTACH + wait():SIGSTOP + PTRACE_DETACH(???)
> sequence. I think this SIGSTOP should be considered by kernel
> not to be a signal delivery ptrace stop - because this SIGSTOP
> is "artificial".

Well, this is another case when we have what we have. Unfortunately
it is not artificial. We can add the new PTRACE_ATTACH_* requests
(and we are going to do this), but I don't think we can change this.

> Actually, if you do waitpid():SIGTRAP + ptrace(PTRACE_DETACH, <anything>),
> <anything> will be ignored, because tracee is not in signal delivery ptrace stop,

Well, to clarify, this depends on SIGTRAP above. But in general yes,
<anything> can be ignored. In particular, it _is_ ignored when the
tracee is stopped (T (stopped)). I do not know was it supposed or not,
but this is how the code currently works.

Perhaps ptrace interface should give more respect to SIGXXX argument,
I have no idea. But let me repeat, imho this is another issue.

> So, the only special trick you seem to want is to make ptrace(PTRACE_DETACH, SIGCONT)
> to forcibly unpause stopped task, even if done from non-signal ptrace stop. Right?
>
> I guess this can be special-cased, but can't the same be trivially achieved by
> kill(SIGCONT) + ptrace(PTRACE_DETACH, SIGCONT)?

Hmm. Agreed. Contrary to what I said in the previous email.

> This will avoid the need to special case in the kernel...

And note that this currently doesn't work anyway.

Oleg.

