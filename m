Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2DNIBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 04:01:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47533 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab2DNIBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 04:01:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120414033953.GA29189@redhat.com>
References: <20120414021201.GA23385@redhat.com> <20120414021220.GA23393@redhat.com>
 <CA+55aFyxV8v2mOjb1Ly=1ttPyLvUt6RZO8wgjD_9owtO=VM0hw@mail.gmail.com> <20120414033953.GA29189@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 01:00:46 -0700
X-Google-Sender-Auth: iU8FnRORybyAaMXzFSuRetqrTO0
Message-ID: <CA+55aFxSyCmxv=fZTMgnq3OSTQjj5R4izKFotBExpAu1M5BsQg@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] task_work_add: generic process-context callbacks
To: Oleg Nesterov <oleg@redhat.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 8:39 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>>
>> Alternatively, you must make the rule be that the data can only be
>> freed by the caller *if* it was returned from "task_work_cancel()".
>
> Exactly.
>
> Once the caller does task_work_add(twork), it no longer "owns" this
> twork.
>
> But, if task_work_cancel() succeeds - you own it again.

*IF* it succeeds.

My argument was that it might race, and not successfully remove the
work entry at all - but because it was allocated on the stack, it gets
freed *regardless* of whether the cancel got it or not.

>> But then you can't allocate it on the stack any more, and have to
>> allocate it separately.
>
> Yes, unless you do task_work_add/cancel(current).

Ok, your argument seems to be that "current" is special, and can not
race, because the work execution is always synchronous with the task
it got scheduled on.

I can buy that. But if so, it needs some big honking comment. Maybe
the whole "add yourself onto your *own* task work" should be an
explicit separate interface.

And that whole "run_task_work()" function should *not* take a "task"
pointer, because it would be horribly horribly wrong to ever run it in
any context than "current".

                 Linus
