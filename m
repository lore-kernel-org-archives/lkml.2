Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3ABUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:09:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab3ABUJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:09:53 -0500
Date: Wed, 2 Jan 2013 15:09:42 -0500
From: Don Zickus <dzickus@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] watchdog: Use local_clock for get_timestamp()
Message-ID: <20130102200942.GC88797@redhat.com>
References: <1356576585-28782-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356576585-28782-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 11:49:44AM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The get_timestamp() function is always called with current cpu, thus
> using local_clock() would be more appropriate and it makes the code
> shorter and cleaner IMHO.

Seems reasonable.  Can't think of why it wasn't implemented this way to
begin with.  

Acked-by: Don Zickus <dzickus@redhat.com>

> 
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/watchdog.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 75a2ab3d0b02..082ca6878a3f 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -112,9 +112,9 @@ static int get_softlockup_thresh(void)
>   * resolution, and we don't need to waste time with a big divide when
>   * 2^30ns == 1.074s.
>   */
> -static unsigned long get_timestamp(int this_cpu)
> +static unsigned long get_timestamp(void)
>  {
> -	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
> +	return local_clock() >> 30LL;  /* 2^30 ~= 10^9 */
>  }
>  
>  static void set_sample_period(void)
> @@ -132,9 +132,7 @@ static void set_sample_period(void)
>  /* Commands for resetting the watchdog */
>  static void __touch_watchdog(void)
>  {
> -	int this_cpu = smp_processor_id();
> -
> -	__this_cpu_write(watchdog_touch_ts, get_timestamp(this_cpu));
> +	__this_cpu_write(watchdog_touch_ts, get_timestamp());
>  }
>  
>  void touch_softlockup_watchdog(void)
> @@ -195,7 +193,7 @@ static int is_hardlockup(void)
>  
>  static int is_softlockup(unsigned long touch_ts)
>  {
> -	unsigned long now = get_timestamp(smp_processor_id());
> +	unsigned long now = get_timestamp();
>  
>  	/* Warn about unreasonable delays: */
>  	if (time_after(now, touch_ts + get_softlockup_thresh()))
> -- 
> 1.7.11.7
> 
