Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0IWTur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:50:47 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43914 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0IWTup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:50:45 -0400
Subject: Re: [PATCH 1/8] posix clocks: introduce a syscall for clock tuning.
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <b94ef1cd9c04ef3ad5964408bd0af7251add78de.1285261534.git.richard.cochran@omicron.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
	 <b94ef1cd9c04ef3ad5964408bd0af7251add78de.1285261534.git.richard.cochran@omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 12:48:51 -0700
Message-ID: <1285271331.2587.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 19:31 +0200, Richard Cochran wrote:
> A new syscall is introduced that allows tuning of a POSIX clock. The
> syscall is implemented for four architectures: arm, blackfin, powerpc,
> and x86.
> 
> The new syscall, clock_adjtime, takes two parameters, the clock ID,
> and a pointer to a struct timex. The semantics of the timex struct
> have been expanded by one additional mode flag, which allows an
> absolute offset correction. When specificied, the clock offset is
> immediately corrected by adding the given time value to the current
> time value.


So I'd still split this patch up a little bit more.

1) Patch that implements the ADJ_SETOFFSET  (*and its implementation*)
in do_adjtimex.

2) Patch that adds the new syscall and clock_id multiplexing.

3) Patches that wire it up to the rest of the architectures (there's
still a bunch missing here).



And one little nit in the code:

> diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
> index 9ca4973..446b566 100644
> --- a/kernel/posix-timers.c
> +++ b/kernel/posix-timers.c
> @@ -197,6 +197,14 @@ static int common_timer_create(struct k_itimer *new_timer)
>  	return 0;
>  }
> 
> +static inline int common_clock_adj(const clockid_t which_clock, struct timex *t)
> +{
> +	if (CLOCK_REALTIME == which_clock)
> +		return do_adjtimex(t);
> +	else
> +		return -EOPNOTSUPP;
> +}


Would it make sense to point to the do_adjtimex() in the k_clock
definition for CLOCK_REALTIME rather then conditionalizing it here?



thanks
-john

