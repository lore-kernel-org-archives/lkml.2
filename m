Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab2KVUpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:45:15 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab2KVUoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:44:32 -0500
Message-ID: <1353585161.9806.37.camel@jlt4.sipsolutions.net>
Subject: Re: [POC] recoverable fault injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 22 Nov 2012 12:52:41 +0100
In-Reply-To: <CAC5umyibe0tb+HLxx3dbT7gF_nVAAHso1Y0Qb4Q_+y0KNrnvFg@mail.gmail.com> (sfid-20121122_124034_444494_4D7B6C5A)
References: <1353541455.20173.10.camel@jlt4.sipsolutions.net>
	 <CAC5umyibe0tb+HLxx3dbT7gF_nVAAHso1Y0Qb4Q_+y0KNrnvFg@mail.gmail.com>
	 (sfid-20121122_124034_444494_4D7B6C5A)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-22 at 20:40 +0900, Akinobu Mita wrote:

> > I was thinking: what if we could do fault injection during regular
> > testing, at least on those code paths that are not supposed to have side
> > effects when they fail? Now obviously this isn't all code paths, and
> > many probably erroneously *do* have side effects even if they're not
> > supposed to, but it does apply to a number of code paths.
> 
> It sounds interesting. I have never thought of this idea.

:-)
It also occurred to me that if the function is defined to not have side
effects when failing, this actually also lets you test that in a way.
Anyway, it's really just an idea at this point.

> > So I decided to play with this, and the result it the patch below. It
> > adds a new knob "recoverable-only" to the slab and page_alloc fault
> > attributes. If enabled, then a single fault can be injected if the task
> > executing it is in a "recoverable section", this is implemented by some
> > new fields in struct task_struct and the (very ugly!) macro
> > FAULT_INJECT_CALL_RECOVERABLE_FUNCTION.
> 
> I suggest introducing a pair of function like:
> 
> void fault_recoverable_enable(unsigned long fault_ids);
> void fault_recoverable_disable();
> [...]

I thought about something like that, I actually initially played with
macros like this:

#define FAULT_RECOVERABLE_START(ids)	\
	/* set up the task state */	\
 fault_recovery_retry:

#define FAULT_RECOVERABLE_END(ids)	\
	if (current->encountered_fault)	\
		goto fault_recovery_retry;

or so. However, the problem is that if you exit the function between
these points, and this is true for your functions as well, you leave the
task's fault injection enabled which isn't what you want. So adding
functions or macros like this didn't really seem right. Also, functions
(rather than macros) have the problem that the retry can't be
encapsulated -- note how my macro calls the function again if it failed.
So with functions like that, you introduce new manually-coded error and
retry paths, that seemed undesirable.

As you can see in my macro, it's also possible for an allocation to fail
but the function to succeed, so the function that is called must have a
return value indicating success or failure. I ran into this with debug
objects, their allocation failed all the time but obviously the function
succeeded as debug objects fail gracefully if they can't allocate
memory.

Now, I'm not saying I'm happy with this, but I haven't found a better
solution yet, but I'll admit that I haven't thought about it for long.
If this was python I'd add a decorator to the function ;-)

Oh another thing I realized: when a fault is injected, I currently set
current->fail_recoverable = 0, but I could just unset the failed bit
instead which would allow multiple different failures. Not sure which is
better though.

Thanks for looking at this :-)

johannes

