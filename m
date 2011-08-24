Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab1HXDnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 23:43:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53299 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752296Ab1HXDnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 23:43:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/NOPJq3nDN5L6BfgZDzxk2/OMD1VqOwOufOgUN3H
	sSQTGs5wGsW6Ne
Subject: Re: Possible scheduler bug
From: Mike Galbraith <efault@gmx.de>
To: seth bollinger <seth.boll@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CA+JN8xP1FsjhNzgV5-0MNLewuJdbW1SxQXVxAeEOXcGwOLyKHg@mail.gmail.com>
References: <CA+JN8xP1FsjhNzgV5-0MNLewuJdbW1SxQXVxAeEOXcGwOLyKHg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 05:43:30 +0200
Message-ID: <1314157410.6220.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 20:58 -0500, seth bollinger wrote:
> Hello All,
> 
> We recently ran into an interesting scheduler problem when testing one
> of our products. It manifested itself as a user space lockup.  When I
> enabled/printed scheduler stats I noticed that the scheduler was
> always picking the same task to run, and no task stats were being
> updated(clock, sum_exec, sum_sleep, etc.). The scheduler would become
> stuck in this state permanently. This problem was ultimately resolved
> by the following patch to sched.c
> 
> @@ -564,7 +569,7 @@ void check_preempt_curr(struct rq *rq, struct
> task_struct *p, int flags)
>          * A queue event has occurred, and we're going to schedule.  In
>          * this case, we can save a useless back to back clock update.
>          */
> -       if (test_tsk_need_resched(p))
> +       if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
>                 rq->skip_clock_update = 1;
>  }

Yeah, that's correct, but see f26f9aff6aaf67e9a430d16c266f91b13a5bff64.
You'll also want the other bits as well.  (but not the WARN_ON()) 

> I have two questions regarding this patch.
> 
> 1. How was it possible to get the scheduler locked up like that (prior
> to patch application)?

If the clock isn't updated, vruntimes don't advance, so you could end up
selecting the same task repeatedly.

> 2. After patch, is it possible that the scheduler could spin in this
> loop until a sched_clock() tick (our clock resolution is unfortunately
> 10ms)?

If you take the rest of the fix, that shouldn't happen.

	-Mike

