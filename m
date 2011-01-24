Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1AXUc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:32:59 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:33148 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1AXUc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:32:58 -0500
Subject: Re: [PATCH 01/18] move do_timer() from kernel/timer.c into
 kernel/time/timekeeping.c
From: john stultz <johnstul@us.ibm.com>
To: Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hch@infradead.org,
        yong.zhang0@gmail.com
In-Reply-To: <1295651224-29823-2-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
	 <1295651224-29823-2-git-send-email-torbenh@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 12:32:49 -0800
Message-ID: <1295901169.4845.29.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-22 at 00:06 +0100, Torben Hohn wrote:
> Signed-off-by: Torben Hohn <torbenh@gmx.de>
> ---
>  kernel/time/timekeeping.c |   12 ++++++++++++
>  kernel/timer.c            |   13 -------------
>  2 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index d27c756..546d82f 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -946,3 +946,15 @@ struct timespec get_monotonic_coarse(void)
>  				now.tv_nsec + mono.tv_nsec);
>  	return now;
>  }
> +
> +/*
> + * The 64-bit jiffies value is not atomic - you MUST NOT read it
> + * without sampling the sequence number in xtime_lock.
> + * jiffies is defined in the linker script...
> + */
> +void do_timer(unsigned long ticks)
> +{
> +	jiffies_64 += ticks;
> +	update_wall_time();
> +	calc_global_load(ticks);
> +}


I know Thomas suggested this move, but I'm not sure I agree (yet).
Jiffies updates, and load calculations really have much more to do with
the timer irq then with timekeeping, so I'd be prone to leave them in
place. Or maybe move them to the tick scheduling code?

I'm guessing Thomas is thinking to move these bits into timekeeping.c so
xtime_lock can be made static there, it just strikes me oddly.
Especially since jiffies access is still going to need the xtime_lock,
so we'd have to move all the jiffies code into timekeeping.c to do so.

Splitting the xtime_lock int a static timekeeper.lock and a static
jiffies_lock might be the clean way to divide things, but that really
just adds extra locking overhead. But maybe that's not much of an issue.

Thomas: I suspect I'm just not seeing where you're going with this.
Could you clarify a bit? :)

thanks
-john



