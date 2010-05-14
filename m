Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab0ENSvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 14:51:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757758Ab0ENSvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 14:51:19 -0400
Date: Fri, 14 May 2010 20:48:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 2/2] posix_timer: clean up properly if anything fails
	after *_timer_create
Message-ID: <20100514184850.GA11352@redhat.com>
References: <1273843731-12595-1-git-send-email-avagin@openvz.org> <1273843731-12595-2-git-send-email-avagin@openvz.org> <20100514160357.GB3727@redhat.com> <20100514191800.3e3b6655@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514191800.3e3b6655@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14, Stanislaw Gruszka wrote:
>
> On Fri, 14 May 2010 18:03:57 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 05/14, Andrey Vagin wrote:
> > >
> > > @@ -613,6 +613,8 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
> > >  	 * and may cease to exist at any time.  Don't use or modify
> > >  	 * new_timer after the unlock call.
> > >  	 */
> > > +out_cleanup:
> > > +	CLOCK_DISPATCH(new_timer->it_clock, timer_cleanup, (new_timer));
> >
> > But at first glance you are right, posix_cpu_timer_create() does
> > get_task_struct(it.cpu.task).
>
> If I understand problem correctly, seems to be fine to move
> CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
> after all possible EFAULT errors and solve leak without creating
> new timer_cleanup() callback.

I thought about this too, we are doing copy_to_user(created_timer_id)
"in advance" anyway. Probably we can move all this code block

	new_timer->it_id = (timer_t) new_timer_id;
	new_timer->it_clock = which_clock;
	new_timer->it_overrun = -1;
	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
	if (error)
		goto out;

down, right before we take ->siglock.

But I don't understand the change in posix_cpu_timer_del() from 1/2.


Otoh, currently "The next step is hard to back out if there is an error"
comment is not right, release_posix_timer() does put_pid(). We can
move copy_to_user(created_timer_id) down after "if (timer_event_spec)"
block too. (but before CLOCK_DISPATCH(), of course).

Andrey, what do you think?

Oleg.

