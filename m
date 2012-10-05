Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2JESFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:05:51 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63369 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JESFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:05:47 -0400
Subject: Re: interrupt context
From: anish kumar <anish198519851985@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Iain Fraser <iainkfraser@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20121005132714.GB21358@thunk.org>
References: <CA+bLfK5FPqFvU2xy7xKdV4LkAvmY6GAPFrB-4UBzn-cOunQ6Xg@mail.gmail.com>
	 <CA+bLfK44cYvhMbrK8ZrZ0BiEo3V=FB2UavCpL1CaRgjKqtN9Yw@mail.gmail.com>
	 <20121005132714.GB21358@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Oct 2012 23:35:37 +0530
Message-ID: <1349460337.1440.70.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 09:27 -0400, Theodore Ts'o wrote:
> On Fri, Oct 05, 2012 at 09:51:55AM +0100, Iain Fraser wrote:
> > 
> > I understand the interrupts and softirq's run in interrupt context (
> > as opposed to process context ). But what I
> > don't understand is why you cannot sleep in interrupt context?
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
Just to get it right for me.Most of the time spinlock disables the local
core interrupts(or all cores interrupts) and when you call the sleep
function after holding the spinlock the interrupts will be  enabled
again(Am I right?).This is not desired and will have unknown results.
> holding a spinlock, then it simply may not sleep without triggering
> all sorts of other problems.
> 
> > What I have read it states that it doesn't have a process to schedule
> > out. But interrupts use the interrupted processes
> > kernel stack just like a syscall. So surely it is possible to sleep
> > using that stack. Understandably It would be unfair on the process
> > that blocked through no fault of its own.
> > 
> > Also if you are not allowed to sleep / schedule during interrupt
> > context. Then how does the  system timer pre-empt processes by
> > calling schedule?
> 
> The system timer sets the "need to reschedule" flag for that
> particular process.  Then as the system timer returns from the
> interrupt, there is a common code path which is checked on the way out
set_tsk_need_resched is the call?
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
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


