Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2LTLnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:43:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:49086 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LTLnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:43:46 -0500
Date: Thu, 20 Dec 2012 12:43:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH] time: create __getnstimeofday for WARNless calls
In-Reply-To: <1355770314-9167-1-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.LFD.2.02.1212201235570.3148@ionos>
References: <1355770314-9167-1-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012, John Stultz wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> Hey Thomas, 
>    Wanted to see if maybe there was still time for this for 3.8?
> thanks
> -john
> 
> The pstore RAM backend can get called during resume, and must be defensive
> against a suspended time source. Expose getnstimeofday logic that returns
> an error instead of a WARN. This can be detected and the timestamp can
> be zeroed out.

Shouldn't we zero out the time stamp in the core code ?

Thanks,

	tglx

> Reported-by: Doug Anderson <dianders@chromium.org>
> Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  fs/pstore/ram.c           |   10 +++++++---
>  include/linux/time.h      |    1 +
>  kernel/time/timekeeping.c |   29 ++++++++++++++++++++++++-----
>  3 files changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 1a4f6da..dacfe78 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -168,12 +168,16 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>  static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
>  {
>  	char *hdr;
> -	struct timeval timestamp;
> +	struct timespec timestamp;
>  	size_t len;
>  
> -	do_gettimeofday(&timestamp);
> +	/* Report zeroed timestamp if called before timekeeping has resumed. */
> +	if (__getnstimeofday(&timestamp)) {
> +		timestamp.tv_sec = 0;
> +		timestamp.tv_nsec = 0;
> +	}
>  	hdr = kasprintf(GFP_ATOMIC, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
> -		(long)timestamp.tv_sec, (long)timestamp.tv_usec);
> +		(long)timestamp.tv_sec, (long)(timestamp.tv_nsec / 1000));
>  	WARN_ON_ONCE(!hdr);
>  	len = hdr ? strlen(hdr) : 0;
>  	persistent_ram_write(prz, hdr, len);
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 4d358e9..0015aea 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -158,6 +158,7 @@ extern int do_setitimer(int which, struct itimerval *value,
>  			struct itimerval *ovalue);
>  extern unsigned int alarm_setitimer(unsigned int seconds);
>  extern int do_getitimer(int which, struct itimerval *value);
> +extern int __getnstimeofday(struct timespec *tv);
>  extern void getnstimeofday(struct timespec *tv);
>  extern void getrawmonotonic(struct timespec *ts);
>  extern void getnstime_raw_and_real(struct timespec *ts_raw,
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 4c7de02..dfc7f87 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -214,19 +214,18 @@ static void timekeeping_forward_now(struct timekeeper *tk)
>  }
>  
>  /**
> - * getnstimeofday - Returns the time of day in a timespec
> + * __getnstimeofday - Returns the time of day in a timespec.
>   * @ts:		pointer to the timespec to be set
>   *
> - * Returns the time of day in a timespec.
> + * Updates the time of day in the timespec.
> + * Returns 0 on success, or -ve when suspended (timespec will be undefined).
>   */
> -void getnstimeofday(struct timespec *ts)
> +int __getnstimeofday(struct timespec *ts)
>  {
>  	struct timekeeper *tk = &timekeeper;
>  	unsigned long seq;
>  	s64 nsecs = 0;
>  
> -	WARN_ON(timekeeping_suspended);
> -
>  	do {
>  		seq = read_seqbegin(&tk->lock);
>  
> @@ -237,6 +236,26 @@ void getnstimeofday(struct timespec *ts)
>  
>  	ts->tv_nsec = 0;
>  	timespec_add_ns(ts, nsecs);
> +
> +	/*
> +	 * Do not bail out early, in case there were callers still using
> +	 * the value, even in the face of the WARN_ON.
> +	 */
> +	if (unlikely(timekeeping_suspended))
> +		return -EAGAIN;
> +	return 0;
> +}
> +EXPORT_SYMBOL(__getnstimeofday);
> +
> +/**
> + * getnstimeofday - Returns the time of day in a timespec.
> + * @ts:		pointer to the timespec to be set
> + *
> + * Returns the time of day in a timespec (WARN if suspended).
> + */
> +void getnstimeofday(struct timespec *ts)
> +{
> +	WARN_ON(__getnstimeofday(ts));
>  }
>  EXPORT_SYMBOL(getnstimeofday);
>  
> -- 
> 1.7.9.5
> 
> 
