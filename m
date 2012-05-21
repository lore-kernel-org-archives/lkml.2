Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab2EUS0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:26:47 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60329 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab2EUS0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:26:46 -0400
Message-ID: <4FBA879E.5070603@linaro.org>
Date: Mon, 21 May 2012 11:21:18 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai threshold
References: <cover.1337348892.git.richardcochran@gmail.com> <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com>
In-Reply-To: <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052118-3270-0000-0000-0000068447CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 07:09 AM, Richard Cochran wrote:
> This patch introduces time keeping variables to track the next
> mini-epoch between the UTC and TAI timescales. A leap second occurs
> one second before a mini-epoch. When no leap second is pending, then
> the epoch is set to the far future, LONG_MAX.
>
> This code will become useful later on for providing correct time
> surrounding a leap second.
>
> Signed-off-by: Richard Cochran<richardcochran@gmail.com>
> ---
>   kernel/time/timekeeping.c |   14 ++++++++++++++
>   1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index d66b213..ac04de4 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -70,6 +70,19 @@ struct timekeeper {
>   	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
>   	struct timespec raw_time;
>
> +	/* The current TAI - UTC offset */
> +	time_t tai_offset;
> +	/* The UTC time of the next leap second epoch */
> +	time_t utc_epoch;
> +	/* Tracks where we stand with regard to leap the second epoch. */
> +	enum {
> +		LEAP_IDLE,
> +		LEAP_INS_PENDING,
> +		LEAP_INS_DONE,
> +		LEAP_DEL_PENDING,
> +		LEAP_DEL_DONE,
> +	} leap_state;
> +
One other thing, I'd rather you break this patch set up logically as:
1) Move tai offset management into timeekeeping core
2) Move leap_state managment into timekeeping core.

Instead of:
1) Add unused values to timekeeper for tai and leapstate
2) Convert NTP code to use both these new values

I know its a pain to refactor a patch set in this way, but it makes it 
much more clear as to what each patch is doing and the complexity of 
each step.

thanks
-john



