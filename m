Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab2JESP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:15:26 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65061 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2JESPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <20121005132714.GB21358@thunk.org>
References: <CA+bLfK5FPqFvU2xy7xKdV4LkAvmY6GAPFrB-4UBzn-cOunQ6Xg@mail.gmail.com>
	<CA+bLfK44cYvhMbrK8ZrZ0BiEo3V=FB2UavCpL1CaRgjKqtN9Yw@mail.gmail.com>
	<20121005132714.GB21358@thunk.org>
Date: Fri, 5 Oct 2012 19:15:24 +0100
Message-ID: <CA+bLfK6wP6_ymjhdnQ2uX7dpsR8ba980ScsZHVGjFHxo=hGtLQ@mail.gmail.com>
Subject: Re: interrupt context
From: Iain Fraser <iainkfraser@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Iain Fraser <iainkfraser@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually Theodore I've been thinking about your reply. Surely the
kernel doesn't care about a processes locks. Because a process can be
pre-empted at any-time. Isn't that the same as allowing
a process to be scheduled in interrupt context?

I understand the other reason, i.e. not allowing the idle process to
sleep is critical. And also appreciate that async scheduling a process
( other than preemption ) is very unfair to say the least :)

Cheers
Iain

On Fri, Oct 5, 2012 at 2:27 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Oct 05, 2012 at 09:51:55AM +0100, Iain Fraser wrote:
>>
>> I understand the interrupts and softirq's run in interrupt context (
>> as opposed to process context ). But what I
>> don't understand is why you cannot sleep in interrupt context?
>
> Consider what happens with nested locks (and yes, we definitely need
> nested locks).  In order to prevent deadlocks, it is critical to have
> lock ordering; that is, you always take locks in a certain order.  If
> all processes take lock A, and then lock B, etc., then you won't have
> a problem where one process as lock A, and tries to get lock B, and
> another process has lock B, and tries to take lock A, and they wait
> for each other forever.
>
> If a process has a lock when it gets interrupted, the interrupt
> handler has no idea what locks may have already been taken.  So if a
> process has taken a mutex (or some other sleeping lock) B, and then
> the interrupt handler tries to take lock A, that's a perscription for
> deadlock.
>
> In addition, you must never sleep while holding a (non-sleeping)
> spinlock.  If the interrupt handler has interrupted a process which is
> holding a spinlock, then it simply may not sleep without triggering
> all sorts of other problems.
>
>> What I have read it states that it doesn't have a process to schedule
>> out. But interrupts use the interrupted processes
>> kernel stack just like a syscall. So surely it is possible to sleep
>> using that stack. Understandably It would be unfair on the process
>> that blocked through no fault of its own.
>>
>> Also if you are not allowed to sleep / schedule during interrupt
>> context. Then how does the system timer pre-empt processes by
>> calling schedule?
>
> The system timer sets the "need to reschedule" flag for that
> particular process.  Then as the system timer returns from the
> interrupt, there is a common code path which is checked on the way out
> of any interrupt handler or system call.  This code path checks to see
> if the "need to schedule" flag is set, and if so, at that point
> instead of returning to the original process, the kernel will simply
> return to some other process.
>
> I would suggest that you get a good introductory Linux book, such as
> "Linux Kernel Development" by Robert Love.  You might also check out
> the kernelnewbies.org website and mailing list, where you are more
> likely to get answers to basic introductory questions like this.
>
> Regards,
>
>                                                 - Ted
