Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab2KUN6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:58:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab2KUN6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:58:32 -0500
Date: Wed, 21 Nov 2012 14:58:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [REPOST-v2] sched: Prevent wakeup to enter critical section
	needlessly
Message-ID: <20121121135849.GA21030@redhat.com>
References: <1351159974-980-1-git-send-email-meltedpianoman@gmail.com> <1353310211-3011-1-git-send-email-meltedpianoman@gmail.com> <20121119151050.GA4270@redhat.com> <CAMSQXEF9BGBVRRtuz88XFqVmPBdbWisepq4qjah3vM05_7hztw@mail.gmail.com> <20121119154940.GA6354@redhat.com> <CAMSQXEGfQE_vcvk9MvP-aJD2jeF7vU+84yx_fEn==v2Jve9w0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMSQXEGfQE_vcvk9MvP-aJD2jeF7vU+84yx_fEn==v2Jve9w0A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21, Ivo Sieben wrote:
> Hi
>
> 2012/11/19 Oleg Nesterov <oleg@redhat.com>:
> >
> > Because on a second thought I suspect this change is wrong.
> >
> > Just for example, please look at kauditd_thread(). It does
> >
> >         set_current_state(TASK_INTERRUPTIBLE);
> >
> >         add_wait_queue(&kauditd_wait, &wait);
> >
> >         if (!CONDITION)         // <-- LOAD
> >                 schedule();
> >
> > And the last LOAD can leak into the critical section protected by
> > wait_queue_head_t->lock, and it can be reordered with list_add()
> > inside this critical section. In this case we can race with wake_up()
> > unless it takes the same lock.
> >
> > Oleg.
> >
>
> I agree that I should solve my problem using the waitqueue_active()
> function locally. I'll abandon this patch and fix it in the
> tty_ldisc.c.
>
> But we try to understand your fault scenario: How can the LOAD leak
> into the critical section? As far as we understand the spin_unlock()
> function also contains a memory barrier
                           ^^^^^^^^^^^^^^

Not really, in general unlock is a one-way barrier.

> to prevent such a reordering
> from happening.

Please look at the comment above prepare_to_wait(), for example. Or
look at wmb() in try_to_wake_up().

I guess this is not possible on x86, but in general

	X;
	LOCK();
	UNLOCK();
	Y;

can be reordered as

	LOCK();
	Y;
	X;
	UNLOCK();

UNLOCK + LOCK is the full memory barrier.

Oleg.

