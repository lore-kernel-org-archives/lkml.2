Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1BNRkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:40:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1BNRkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:40:40 -0500
Date: Mon, 14 Feb 2011 18:32:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214173231.GC14528@redhat.com>
References: <20110204130455.GA3671@redhat.com> <201102140001.47218.vda.linux@googlemail.com> <20110214090356.GA21979@host1.dyn.jankratochvil.net> <201102141239.53893.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102141239.53893.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Denys Vlasenko wrote:
>
> On Monday 14 February 2011 10:03, Jan Kratochvil wrote:
> > On Mon, 14 Feb 2011 00:01:47 +0100, Denys Vlasenko wrote:
> > > * sleep runs in nanosleep
> > > * SIGSTOP arrives, strace sees it
> > > * strace logs it and allows it via ptrace(PTRACE_SYSCALL, ..., SIGSTOP)
> > > * sleep process enters group-stop
> >
> > The last point breaks the documented behavior of ptrace:
> > 	If data is nonzero and not SIGSTOP, it is interpreted as a signal to
> > 	be delivered to the child; otherwise, no signal is delivered.
>
> But SIGSTOP _is_ delivered - that's why sleep process stops.

Yes.

> > What if other signal arrives?  The tracer probably should not be notified as
> > the tracee is in a group-stop.
>
> The behavior here ideally should be the same as for non-traced process:
> the signals are remembered while process is stopped, and it sees them
> only after SIGCONT, as demonstrated by the following program

Agreed. And this is what we currently do.

> I believe it would be best if debugger sees signals immediately,
> but when it does ptrace(PTRACE_CONT/SYSCALL, ..., <sig>)
> in order to send signals to group-stopped tracee, they are queued
> to it without terminating group-stop. When SIGCONT arrives,
> ptrace(PTRACE_CONT/SYSCALL, ..., SIGCONT) terminates group-stop
> and causes all queued signals to be handled (in random order,
> not necessarily in the order of arrival. Even CONT handler is
> not guaranteed to be called first, as you see above).

Yes, personaly I think this would the best behaviour.

But, damn, again, again, again, yes this change is very noticable.
Tejun is right too.

Oleg.

