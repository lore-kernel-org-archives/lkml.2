Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918Ab1CDSZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:25:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758960Ab1CDSZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:25:04 -0500
Date: Fri, 4 Mar 2011 19:16:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304181630.GA28729@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org> <20110303173422.GA27960@redhat.com> <20110303202246.GB32152@redhat.com> <20110304082329.GA20499@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304082329.GA20499@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Tejun Heo wrote:
>
> > Tracee:
> >
> > 	int main(void)
> > 	{
> > 		kill(SIGSTOP, getpid());
> >
> > 		printf("I am running\n");
> >
> > 		for (;;)
> > 			;
> > 	}
> >
> > To simplify again, suppose that the debugger attaches when it is
> > already stopped, then it does PTRACE_CONT(0).
> >
> > In this case the tracee remains SIGNAL_STOP_STOPPED but prints
> > "I am running" and enters the endless loop.
> >
> > (the new debugger can do PTRACE_SEIZE after that and "return"
> >  it to the stopped state without affecting jctl state).
> >
> > Now, if SIGCONT comes (from anywhere) it clears SIGNAL_STOP_STOPPED,
> > the tracee traps and reports this event to debugger.
> >
> > Correct?
>
> * The above requires another ptrace trap site which can probably
>   shared with PTRACE_SEIZE.

OK, thanks. I was a bit confused by TASK_TRACED | TASK_STOPPED state
idea. Obviously the state can't be TASK_RUNNING | TASK_STOPPED.

> The question is whether to make group
>   stop state available for other trap sites too or just enable it in
>   the new trap site.  ATM, I'm leaning toward the latter.

Yes.

There is another corner case. Suppose that another SIGSTOP comes
while the tracee runs the endless loop above.

In this case nothing changes, the tracee should report this signal.
But what should it do if the debugger does PTRACE_CONT(SIGSTOP) after
that?

Should it stop and report another job control stop after that, or
should it ignore this signal? In the first case, at least we should
not notify the real parent again. In the latter case, perhaps the
naive debugger can be confused and this differs from the current
behaviour.

And, if it stops, should this also stop other PTRACE_CONT'ed threads
as well? Currently we do...

Not that I think this is terribly important, but I think it makes
sense to discuss/document this case anyway.


Anyway. I think this RFC is fine.

Oleg.

