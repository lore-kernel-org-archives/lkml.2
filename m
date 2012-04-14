Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab2DNU1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 16:27:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875Ab2DNU1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 16:27:48 -0400
Date: Sat, 14 Apr 2012 22:27:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] task_work_add: generic process-context callbacks
Message-ID: <20120414202708.GA8656@redhat.com>
References: <20120414021201.GA23385@redhat.com> <20120414021220.GA23393@redhat.com> <CA+55aFyxV8v2mOjb1Ly=1ttPyLvUt6RZO8wgjD_9owtO=VM0hw@mail.gmail.com> <20120414033953.GA29189@redhat.com> <CA+55aFxSyCmxv=fZTMgnq3OSTQjj5R4izKFotBExpAu1M5BsQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxSyCmxv=fZTMgnq3OSTQjj5R4izKFotBExpAu1M5BsQg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Linus Torvalds wrote:
>
> On Fri, Apr 13, 2012 at 8:39 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >>
> > Once the caller does task_work_add(twork), it no longer "owns" this
> > twork.
> >
> > But, if task_work_cancel() succeeds - you own it again.
>
> *IF* it succeeds.

Sure.

> >> But then you can't allocate it on the stack any more, and have to
> >> allocate it separately.
> >
> > Yes, unless you do task_work_add/cancel(current).
>
> Ok, your argument seems to be that "current" is special, and can not
> race, because the work execution is always synchronous with the task
> it got scheduled on.

Yes, exactly.

> And that whole "run_task_work()" function should *not* take a "task"
> pointer, because it would be horribly horribly wrong to ever run it in
> any context than "current".

And it was task_work_queue(void) initially. But then I decided to
micro-optimize this, the callers already have this task_struct in
the register. And we have other examples like this, say, exit_mm().

However. I agree that it would be more understandable and clean
to use current in task_work_run(void), and percpu_read is cheap.

So I'll remove this argument and send v5 after David reviews 3/3.

Oleg.

