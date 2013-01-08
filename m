Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3AHAKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 19:10:06 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48563 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab3AHAKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 19:10:02 -0500
Date: Mon, 7 Jan 2013 16:09:58 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 13/32] wait: Add wait_event_hrtimeout()
Message-ID: <20130108000958.GL26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-15-git-send-email-koverstreet@google.com>
 <20130103150816.f0dda169.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103150816.f0dda169.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 03:08:16PM -0800, Andrew Morton wrote:
> On Wed, 26 Dec 2012 17:59:51 -0800
> Kent Overstreet <koverstreet@google.com> wrote:
> 
> > Analagous to wait_event_timeout() and friends, this adds
> > wait_event_hrtimeout() and wait_event_interruptible_hrtimeout().
> > 
> > Note that unlike the versions that use regular timers, these don't
> > return the amount of time remaining when they return - instead, they
> > return 0 or -ETIME if they timed out.
> 
> Why is this?

I was uncomfortable with the semantics of doing it the other way (that I
could get it right, anyways).

If the timer expires, there's no real guarantee that expire_time -
current_time would be <= 0 - due to timer slack certainly, and I'm not
sure I want to know the implications of the different clock bases in
hrtimers.

If the timer does expire and the code calculates that the time remaining
is nonnegative, that could be even worse if the calling code then reuses
that timeout. Probably safer to just return 0 then, but I could imagine
weird bugs or at least unintended behaviour arising from that too.

I came to the conclusion that if other users end up actually needing the
amount of time remaining, the sanest thing to do would be to create a
version that uses absolute timeouts instead of relative.

> 
> > +/**
> > + * wait_event_hrtimeout - sleep until a condition gets true or a timeout elapses
> > + * @wq: the waitqueue to wait on
> > + * @condition: a C expression for the event to wait for
> > + * @timeout: timeout, in jiffies
> > + *
> > + * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
> > + * @condition evaluates to true or a signal is received.
> > + * The @condition is checked each time the waitqueue @wq is woken up.
> > + *
> > + * wake_up() has to be called after changing any variable that could
> > + * change the result of the wait condition.
> > + *
> > + * The function returns 0 if @condition became true, or -ETIME if the timeout
> > + * elapsed.
> > + */
> 
> this, methinks:

Whoops, yes.

> --- a/include/linux/wait.h~wait-add-wait_event_hrtimeout-fix
> +++ a/include/linux/wait.h
> @@ -370,7 +370,7 @@ do {									\
>   * wait_event_hrtimeout - sleep until a condition gets true or a timeout elapses
>   * @wq: the waitqueue to wait on
>   * @condition: a C expression for the event to wait for
> - * @timeout: timeout, in jiffies
> + * @timeout: timeout, as a ktime_t
>   *
>   * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
>   * @condition evaluates to true or a signal is received.
> @@ -395,7 +395,7 @@ do {									\
>   * wait_event_interruptible_hrtimeout - sleep until a condition gets true or a timeout elapses
>   * @wq: the waitqueue to wait on
>   * @condition: a C expression for the event to wait for
> - * @timeout: timeout, in jiffies
> + * @timeout: timeout, as a ktime_t
>   *
>   * The process is put to sleep (TASK_INTERRUPTIBLE) until the
>   * @condition evaluates to true or a signal is received.
> _
> 
