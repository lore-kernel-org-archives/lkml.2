Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2ICQDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 12:03:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab2ICQDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 12:03:12 -0400
Date: Mon, 3 Sep 2012 18:05:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] semantics of singlestepping vs. tracer exiting
Message-ID: <20120903160538.GA10114@redhat.com>
References: <20120903001436.GG23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903001436.GG23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Al Viro wrote:
>
> 	When tracer exits, everything that had been ptraced by it
> gets its ->ptrace reset to 0 and woken up to run.  Fine, but...
> what should happen if the last thing that had been done to the
> child was PTRACE_SINGLESTEP?

Yes. If the tracer exits "unexpectedly", it can leave the tracee in
the inconsistent state.

IIRC, we already discussed this, but I can't recall the result.

> Is that a bug or deliberate
> behaviour?

This is not easy to fix. ptrace_disable() and user_disable_single_step()
is arch dependant, but at least on x86 it assumes that the tracee is not
running, so exit_ptrace() can't do this.

And (iirc) it can even sleep, but this is fixable. We can change
exit_ptrace() to drop/re-acquire tasklist.

And this also complicates PTRACE_DETACH_ASYNC which (imho) we need.
Currently the tracer can't detach the running tracee. And worse, it
can't detach a zombie. It should do wait() but if this process has
alive sub-threads it can do nothing.


This is another reason to move enable/disable step into ptrace_stop().
And in fact I had the patches a loong ago, but we need to cleanup
the usage of PT_SINGLESTEP/PT_BLOCKSTEP first. The tracer should
simply set/clear these PT_ flags and resume the tracee which should
check them and do user_*_single_step() in response.

But. Whatever we do, exit_ptrace() can race with SIGTRAP anyway.

> 	Related question: should execve(2) clear (ptrace-inflicted)
> singlestepping?

Perhaps, but

> Tracer
> exit(), however, does *not* do that right now, so the state after
> execve(2) is theoretically observable.

... why execve() is special?

Olef.

