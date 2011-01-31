Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1AaLi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:38:58 -0500
Received: from www.tglx.de ([62.245.132.106]:52513 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609Ab1AaLi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:38:56 -0500
Date: Mon, 31 Jan 2011 12:38:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torben Hohn <torbenh@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        johnstul@us.ibm.com, yong.zhang0@gmail.com, hch@infradead.org
Subject: Re: [PATCH v2 03/20] provide get_xtime_and_monotonic_offset() and
 use it in hrtimer.c
In-Reply-To: <20110127145905.23248.30458.stgit@localhost>
Message-ID: <alpine.LFD.2.00.1101311236440.31804@localhost6.localdomain6>
References: <20110127145741.23248.68098.stgit@localhost> <20110127145905.23248.30458.stgit@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011, Torben Hohn wrote:

> 2 places in hrtimer need to take the xtime_lock, but we want it
> to be private to kernel/time...
> 
> we just provide a function, which gets the values with proper
> read locking the xtime_lock.

Proper sentences start with an uppercase letter.
 
> @@ -617,10 +612,7 @@ static void retrigger_next_event(void *arg)
>  	if (!hrtimer_hres_active())
>  		return;
>  
> -	do {
> -		seq = read_seqbegin(&xtime_lock);
> -		wtm = __get_wall_to_monotonic();
> -	} while (read_seqretry(&xtime_lock, seq));
> +	get_xtime_and_monotonic_offset(NULL, &wtm);
>  	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);

Leaves an unused variable seq. Please do NOT ignore compiler warnings.
 
>  	base = &__get_cpu_var(hrtimer_bases);
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index e4fd957..6085fa5 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -957,3 +957,24 @@ void do_timer(unsigned long ticks)
>  	jiffies_64 += ticks;
>  	update_wall_time();
>  }
> +
> +/**
> + * get_xtime_and_monotonic_offset() - get xtime and wall_to_monotonic
> + * @xts: pointer to struct timespec, filled with the current_time
> + * @tom: pointer to struct timespec, filled with the wall_to_monotonic offset
> + *
> + * this function does proper locking.
> + * and it allows passing NULL, when one is not interested in the value.
> + */
> +void get_xtime_and_monotonic_offset(struct timespec *xts, struct timespec *tom)
> +{
> +	unsigned long seq;
> +
> +	do {
> +		seq = read_seqbegin(&xtime_lock);
> +		if (xts)
> +			*xts = xtime;
> +		if (tom)
> +			*tom = wall_to_monotonic;

That's silly. We can hand in realtime_offset in
retrigger_next_event(). No need for these conditionals.

> +	} while (read_seqretry(&xtime_lock, seq));
> +}

Thanks,

	tglx
 
