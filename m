Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1BAOQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:16:26 -0500
Received: from www.tglx.de ([62.245.132.106]:57722 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab1BAOQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:16:25 -0500
Date: Tue, 1 Feb 2011 15:16:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 2/2] hrtimers: Add CLOCK_BOOTTIME clockid, hrtimerbase
 and posix interface
In-Reply-To: <1296531837-12879-3-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.LFD.2.00.1102011510570.31804@localhost6.localdomain6>
References: <1296531837-12879-1-git-send-email-john.stultz@linaro.org> <1296531837-12879-3-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, John Stultz wrote:

> CLOCK_MONOTONIC stops while the system is in suspend. This is because
> to applications system suspend is invisible. However, there is a
> growing set of applications that are wanting to be suspend-aware,
> but do not want to deal with the complicatoins of CLOCK_REALTIME
> (which might jump around if settimeofday is called).
> 
> For these applications, I propose a new clockid: CLOCK_BOOTTIME.
> CLOCK_BOOTTIME is idential to CLOCK_MONOTONIC, except it also
> includes any time spent in suspend.
> 
> This patch adds the new CLOCK_BOOTTIME clockid, as well as the
> infrastructure needed to support hrtimers against it, and the
> wiring to expose it out via the posix interface.

Can you please split that into parts:

    - Add the new functions
    - Wire up hrtimers, posix-timers

>  static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
>  {
> -	ktime_t xtim, tomono;
> -	struct timespec xts, tom;
> +	ktime_t xtim, tomono, sleep;
> +	struct timespec xts, tom, slp;
>  	unsigned long seq;
>  
>  	do {
>  		seq = read_seqbegin(&xtime_lock);
>  		xts = __current_kernel_time();
>  		tom = __get_wall_to_monotonic();
> +		slp = __get_sleep_time();
>  	} while (read_seqretry(&xtime_lock, seq));

Hmm, that conflicts with the xtime_lock cleanup in tip/timers/core.

>  /*
>   * Initialize everything, well, just everything in Posix clocks/timers ;)
>   */
> @@ -301,12 +309,18 @@ static __init int init_posix_timers(void)
>  		.timer_create = no_timer_create,
>  		.nsleep = no_nsleep,
>  	};
> +	struct k_clock clock_boottime = {
> +		.clock_getres = hrtimer_get_res,
> +		.clock_get = posix_get_boottime,
> +		.clock_set = do_posix_clock_nosettime,

That's going to conflict with the posix timer cleanup, but it's easy enough to fix.

Thanks,

	tglx
