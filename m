Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab0ENRQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 13:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab0ENRQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 13:16:36 -0400
Date: Fri, 14 May 2010 19:18:00 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>, Andrey Vagin <avagin@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 2/2] posix_timer: clean up properly if anything fails
 after *_timer_create
Message-ID: <20100514191800.3e3b6655@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20100514160357.GB3727@redhat.com>
References: <1273843731-12595-1-git-send-email-avagin@openvz.org>
	<1273843731-12595-2-git-send-email-avagin@openvz.org>
	<20100514160357.GB3727@redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 18:03:57 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 05/14, Andrey Vagin wrote:
> >
> > *_timer_create may allocate/get some resources, so need call *_timer_cleanup.
> >
> > https://bugzilla.sw.ru/show_bug.cgi?id=473702
> 
> Authorization Required
> 
> > --- a/kernel/posix-timers.c
> > +++ b/kernel/posix-timers.c
> > @@ -574,19 +574,19 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
> >  	if (copy_to_user(created_timer_id,
> >  			 &new_timer_id, sizeof (new_timer_id))) {
> >  		error = -EFAULT;
> > -		goto out;
> > +		goto out_cleanup;
> >  	}
> >  	if (timer_event_spec) {
> >  		if (copy_from_user(&event, timer_event_spec, sizeof (event))) {
> >  			error = -EFAULT;
> > -			goto out;
> > +			goto out_cleanup;
> >  		}
> >  		rcu_read_lock();
> >  		new_timer->it_pid = get_pid(good_sigevent(&event));
> >  		rcu_read_unlock();
> >  		if (!new_timer->it_pid) {
> >  			error = -EINVAL;
> > -			goto out;
> > +			goto out_cleanup;
> >  		}
> >  	} else {
> >  		event.sigev_notify = SIGEV_SIGNAL;
> > @@ -613,6 +613,8 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
> >  	 * and may cease to exist at any time.  Don't use or modify
> >  	 * new_timer after the unlock call.
> >  	 */
> > +out_cleanup:
> > +	CLOCK_DISPATCH(new_timer->it_clock, timer_cleanup, (new_timer));
> 
> But at first glance you are right, posix_cpu_timer_create() does
> get_task_struct(it.cpu.task).

If I understand problem correctly, seems to be fine to move
CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
after all possible EFAULT errors and solve leak without creating
new timer_cleanup() callback.

Stanislaw
