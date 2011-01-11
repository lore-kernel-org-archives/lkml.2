Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1AKM6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:58:14 -0500
Received: from www.tglx.de ([62.245.132.106]:51023 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab1AKM6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:58:11 -0500
Date: Tue, 11 Jan 2011 13:57:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V8 08/13] posix clocks: cleanup the CLOCK_DISPTACH
 macro
In-Reply-To: <503cd1fa268867573001cfc9bb5681ee3b5b32fa.1293820862.git.richard.cochran@omicron.at>
Message-ID: <alpine.LFD.2.00.1101111224280.12146@localhost6.localdomain6>
References: <cover.1293820862.git.richard.cochran@omicron.at> <503cd1fa268867573001cfc9bb5681ee3b5b32fa.1293820862.git.richard.cochran@omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010, Richard Cochran wrote:
> +static inline bool clock_is_posix_cpu(const clockid_t id)
> +{
> +	if ((id & CLOCKFD_MASK) == CLOCKFD)
> +		return false;
> +	else
> +		return true;
> +}
> +
> +static inline int dispatch_clock_getres(const clockid_t id, struct timespec *ts)
> +{
> +	if (id >= 0) {
> +		return posix_clocks[id].clock_getres ?
> +			posix_clocks[id].clock_getres(id, ts) : -EINVAL;
> +	}
> +
> +	if (clock_is_posix_cpu(id))
> +		return posix_cpu_clock_getres(id, ts);

I wonder whether we should be a bit more clever here and create an
extra entry for posix_cpu_timers in the posix_clocks array and do the
following:

/* These are local to posix-timer.c and not exposed to anything else */
#define POSIX_INV_CLOCK_ID	MAX_CLOCKS
#define POSIX_CPU_CLOCK_ID	(MAX_CLOCKS + 1)
#define NR_CLOCK_ENTRIES	(MAX_CLOCKS + 2)

static struct k_clock posix_clocks[NR_CLOCK_ENTRIES];

static __init int init_posix_timers(void)
{
	......
	/*
	 * We leave the POSIX_INV_CLOCK_ID entries zeroed out, so the 
	 * the dispatch code will return -EINVAL.
	 */

	init_posix_cpu_timer_entries();
}

static clockid_t clock_get_array_id(const clockid_t id)
{
	if (id >= 0)
	       return id < MAX_CLOCKS ? id : POSIX_INV_CLOCK_ID;

      	if (clock_is_posix_cpu(id))
		return POSIX_CPU_CLOCK_ID;

	return POSIX_INV_CLOCK_ID;
}

static inline int dispatch_clock_getres(const clockid_t id, struct timespec *ts)
{
	struct k_clock *clk = &posix_clocks[clock_get_array_id(id)];

	return clk->clock_getres ? clk->clock_getres(id, ts) : -EINVAL;
}

That reduces the code significantly and the MAX_CLOCKS check in
clock_get_array_id() replaces the invalid_clock() check in the
syscalls as well. It does not matter whether we check this before or
after copying stuff from user.

Adding your new stuff requires just another entry in the array, the
setup of the function pointers and the CLOCKFD check in
clock_get_array_id(). Everything else just falls in place.

> +
> +#define CLOCK_DISPATCH(clock, call, arglist) dispatch_##call arglist
> +

Can we get rid of this completely please ?

>  clock_nanosleep_restart(struct restart_block *restart_block)
>  {
> -	clockid_t which_clock = restart_block->arg0;
> -

How does that compile ?

>  	return CLOCK_DISPATCH(which_clock, nsleep_restart,
>  			      (restart_block));
>  }

Thanks,

	tglx
