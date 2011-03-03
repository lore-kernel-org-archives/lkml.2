Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502Ab1CCOuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:50:16 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:33571 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758473Ab1CCOuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:50:15 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/e1bE5HoHeOaI2iUt7DyoqUlUxULLjVsibzqJa/x
	HlCpkizjUlhdNF
Date: Thu, 3 Mar 2011 15:50:08 +0100
From: torbenh <torbenh@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 28/28] posix clocks: Introduce dynamic clocks
Message-ID: <20110303145008.GE4903@siel.b>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	John Stultz <john.stultz@linaro.org>,
	Richard Cochran <richard.cochran@omicron.at>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
References: <20110201134320.688829863@linutronix.de>
 <20110201134420.164172635@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201134420.164172635@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:52:35PM -0000, Thomas Gleixner wrote:
> From: Richard Cochran <richardcochran@gmail.com>
> 
> This patch adds support for adding and removing posix clocks. The
> clock lifetime cycle is patterned after usb devices. Each clock is
> represented by a standard character device. In addition, the driver
> may optionally implement custom character device operations.
> 
> The posix clock and timer system calls listed below now work with
> dynamic posix clocks, as well as the traditional static clocks.
> The following system calls are affected:
> 
>    - clock_adjtime (brand new syscall)
>    - clock_gettime
>    - clock_getres
>    - clock_settime
>    - timer_create
>    - timer_delete
>    - timer_gettime
>    - timer_settime
> 
> [ tglx: Adapted to the posix-timer cleanup. Moved clock_posix_dynamic
>   	to posix-clock.c and made all referenced functions static ]
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> Cc: John Stultz <john.stultz@linaro.org>
> LKML-Reference: <21258f45fcc5e08a595f411c7760f3ccc18964bb.1296124770.git.richard.cochran@omicron.at>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/posix-clock.h  |  150 ++++++++++++++
>  include/linux/posix-timers.h |    6 
>  kernel/posix-timers.c        |    4 
>  kernel/time/Makefile         |    3 
>  kernel/time/posix-clock.c    |  441 +++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 601 insertions(+), 3 deletions(-)
>  create mode 100644 include/linux/posix-clock.h
>  create mode 100644 kernel/time/posix-clock-syscalls.h
>  create mode 100644 kernel/time/posix-clock.c



> 
> +
> +static int pc_clock_adjtime(clockid_t id, struct timex *tx)
> +{
> +	struct posix_clock_desc cd;
> +	int err;
> +
> +	err = get_clock_desc(id, &cd);
> +	if (err)
> +		return err;

there is no permission check here.
if i get the clock fd in READ mode, i can still adjtime.
same for settime.

> +
> +	if (cd.clk->ops.clock_adjtime)
> +		err = cd.clk->ops.clock_adjtime(cd.clk, tx);
> +	else
> +		err = -EOPNOTSUPP;
> +
> +	put_clock_desc(&cd);
> +
> +	return err;
> +}




-- 
torben Hohn
