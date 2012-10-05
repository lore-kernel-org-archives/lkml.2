Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab2JEN1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:27:22 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53965 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab2JEN1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:27:16 -0400
Date: Fri, 5 Oct 2012 09:27:14 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Iain Fraser <iainkfraser@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: interrupt context
Message-ID: <20121005132714.GB21358@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Iain Fraser <iainkfraser@gmail.com>, linux-kernel@vger.kernel.org
References: <CA+bLfK5FPqFvU2xy7xKdV4LkAvmY6GAPFrB-4UBzn-cOunQ6Xg@mail.gmail.com>
 <CA+bLfK44cYvhMbrK8ZrZ0BiEo3V=FB2UavCpL1CaRgjKqtN9Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+bLfK44cYvhMbrK8ZrZ0BiEo3V=FB2UavCpL1CaRgjKqtN9Yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 09:51:55AM +0100, Iain Fraser wrote:
> 
> I understand the interrupts and softirq's run in interrupt context (
> as opposed to process context ). But what I
> don't understand is why you cannot sleep in interrupt context?

Consider what happens with nested locks (and yes, we definitely need
nested locks).  In order to prevent deadlocks, it is critical to have
lock ordering; that is, you always take locks in a certain order.  If
all processes take lock A, and then lock B, etc., then you won't have
a problem where one process as lock A, and tries to get lock B, and
another process has lock B, and tries to take lock A, and they wait
for each other forever.

If a process has a lock when it gets interrupted, the interrupt
handler has no idea what locks may have already been taken.  So if a
process has taken a mutex (or some other sleeping lock) B, and then
the interrupt handler tries to take lock A, that's a perscription for
deadlock.

In addition, you must never sleep while holding a (non-sleeping)
spinlock.  If the interrupt handler has interrupted a process which is
holding a spinlock, then it simply may not sleep without triggering
all sorts of other problems.

> What I have read it states that it doesn't have a process to schedule
> out. But interrupts use the interrupted processes
> kernel stack just like a syscall. So surely it is possible to sleep
> using that stack. Understandably It would be unfair on the process
> that blocked through no fault of its own.
> 
> Also if you are not allowed to sleep / schedule during interrupt
> context. Then how does the system timer pre-empt processes by
> calling schedule?

The system timer sets the "need to reschedule" flag for that
particular process.  Then as the system timer returns from the
interrupt, there is a common code path which is checked on the way out
of any interrupt handler or system call.  This code path checks to see
if the "need to schedule" flag is set, and if so, at that point
instead of returning to the original process, the kernel will simply
return to some other process.

I would suggest that you get a good introductory Linux book, such as
"Linux Kernel Development" by Robert Love.  You might also check out
the kernelnewbies.org website and mailing list, where you are more
likely to get answers to basic introductory questions like this.

Regards,

						- Ted
