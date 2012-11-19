Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2KSPtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:49:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2KSPtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:49:14 -0500
Date: Mon, 19 Nov 2012 16:49:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [REPOST-v2] sched: Prevent wakeup to enter critical section
	needlessly
Message-ID: <20121119154940.GA6354@redhat.com>
References: <1351159974-980-1-git-send-email-meltedpianoman@gmail.com> <1353310211-3011-1-git-send-email-meltedpianoman@gmail.com> <20121119151050.GA4270@redhat.com> <CAMSQXEF9BGBVRRtuz88XFqVmPBdbWisepq4qjah3vM05_7hztw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMSQXEF9BGBVRRtuz88XFqVmPBdbWisepq4qjah3vM05_7hztw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Ivo Sieben wrote:
>
> Hi
>
> 2012/11/19 Oleg Nesterov <oleg@redhat.com>:
> >
> > I am wondering if it makes sense unconditionally. A lot of callers do
> >
> >         if (waitqueue_active(q))
> >                 wake_up(...);
> >
> > this patch makes the optimization above pointless and adds mb().
> >
> >
> > But I won't argue.
> >
> > Oleg.
> >
>
> This patch solved an issue for me that I had with the TTY line
> discipline idle handling:
> Testing on a PREEMPT_RT system with TTY serial communication. Each
> time the TTY line discipline is dereferenced the Idle handling wait
> queue is woken up (see function put_ldisc in /drivers/tty/tty_ldisc.c)
> However line discipline idle handling is not used very often so the
> wait queue is empty most of the time. But still the wake_up() function
> enters the critical section guarded by spin locks. This causes
> additional scheduling overhead when a lower priority thread has
> control of that same lock.
>
> The /drivers/tty/tty_ldisc.c did not use the waitqueue_active() call
> to check if the waitqueue was filled.... maybe I should solve this
> problem the other way around: and make tty_ldisc.c first do the
> waitqueue_active() call?

IMHO yes...

Because on a second thought I suspect this change is wrong.

Just for example, please look at kauditd_thread(). It does

	set_current_state(TASK_INTERRUPTIBLE);

	add_wait_queue(&kauditd_wait, &wait);

	if (!CONDITION)		// <-- LOAD
		schedule();

And the last LOAD can leak into the critical section protected by
wait_queue_head_t->lock, and it can be reordered with list_add()
inside this critical section. In this case we can race with wake_up()
unless it takes the same lock.

Oleg.

