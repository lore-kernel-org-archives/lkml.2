Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1IFWM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 18:12:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab1IFWMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 18:12:22 -0400
Date: Wed, 7 Sep 2011 00:08:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
Message-ID: <20110906220827.GA1800@redhat.com>
References: <20110904165658.GA23948@redhat.com> <20110904202907.GA3404@redhat.com> <20110906031411.GA24024@alboin.amr.corp.intel.com> <20110906145124.GA15390@redhat.com> <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LFD.2.02.1109061823100.2723@ionos> <20110906184926.GA25997@redhat.com> <alpine.LFD.2.02.1109062110090.2723@ionos> <20110906192626.GA27362@redhat.com> <alpine.LFD.2.02.1109062134010.2723@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109062134010.2723@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06, Thomas Gleixner wrote:
>
> On Tue, 6 Sep 2011, Oleg Nesterov wrote:
>
> > But how this can help? Suppose that the task is preempted right
> > after dequeue_signal() drops ->siglock. We need rcu_read_lock()
> > before unlock then, no?
>
> Crap, you are right, but that's fortunately an easy to solve one :)

Yes, this is solvable. But I think we can do something better.

> > And. This breaks the accounting logic. I mean the patch from Andi
> > which adds the limits.
>
> That's a different problem and really, it does not break it by any
> means. When the timer is released, then the count is decreased and we
> can safely assume that the memory is going to be freed in the next
> grace period.

Yes, but this means we need the counter which we do not have.

I think we can avoid this problems. Although I am not sure, I am
already sleeping.

	- we add rcu_read_lock() into dequeueu_signal().

	- we add the new "struct k_itimer *my_timer" member into
	 siginfo._timer. Like _sys_private it is not passed to
	 user, and perhaps we can kill _sys_private later.

	 It is initialized in sys_timer_create() along with
	 info.si_tid/etc

	- release_posix_timer() nullifies tmr->sigq->my_timer

	- do_schedule_next_timer() does

	 	timr = info->my_timer;
	 	if (!timr)
	 		return;

		// protected by rcu

	 	spin_lock_irq(timr->it_lock);
	 	if (!timr->it_signal) {
	 		spin_unlock_irq();
	 		return;
	 	}

	 	....

This also avoids idr_find(), and we do not need to delay idr_remove().

Possible?

Oleg.

