Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2LMSRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:17:21 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47265 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2LMSRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:17:19 -0500
MIME-Version: 1.0
In-Reply-To: <20121119182616.GA4557@www.outflux.net>
References: <20121119182616.GA4557@www.outflux.net>
Date: Thu, 13 Dec 2012 10:17:18 -0800
X-Google-Sender-Auth: fzWfPbc8mdVT9zzMvw6Tz-eyKVk
Message-ID: <CAGXu5jKdOsBUwZRwOQDeRdFjo-K=uEQdJNMgy4N1dyzrUGcAHw@mail.gmail.com>
Subject: Re: [PATCH] time: create __getnstimeofday for WARNless calls
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John, any feedback on this?

Thanks,

-Kees

On Mon, Nov 19, 2012 at 10:26 AM, Kees Cook <keescook@chromium.org> wrote:
> The pstore RAM backend can get called during resume, and must be defensive
> against a suspended time source. Expose getnstimeofday logic that returns
> an error instead of a WARN. This can be detected and the timestamp can
> be zeroed out.
>
> Reported-by: Doug Anderson <dianders@chromium.org>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
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
>         char *hdr;
> -       struct timeval timestamp;
> +       struct timespec timestamp;
>         size_t len;
>
> -       do_gettimeofday(&timestamp);
> +       /* Report zeroed timestamp if called before timekeeping has resumed. */
> +       if (__getnstimeofday(&timestamp)) {
> +               timestamp.tv_sec = 0;
> +               timestamp.tv_nsec = 0;
> +       }
>         hdr = kasprintf(GFP_ATOMIC, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
> -               (long)timestamp.tv_sec, (long)timestamp.tv_usec);
> +               (long)timestamp.tv_sec, (long)(timestamp.tv_nsec / 1000));
>         WARN_ON_ONCE(!hdr);
>         len = hdr ? strlen(hdr) : 0;
>         persistent_ram_write(prz, hdr, len);
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 4d358e9..0015aea 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -158,6 +158,7 @@ extern int do_setitimer(int which, struct itimerval *value,
>                         struct itimerval *ovalue);
>  extern unsigned int alarm_setitimer(unsigned int seconds);
>  extern int do_getitimer(int which, struct itimerval *value);
> +extern int __getnstimeofday(struct timespec *tv);
>  extern void getnstimeofday(struct timespec *tv);
>  extern void getrawmonotonic(struct timespec *ts);
>  extern void getnstime_raw_and_real(struct timespec *ts_raw,
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index e424970..84820dc 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -220,19 +220,18 @@ static void timekeeping_forward_now(struct timekeeper *tk)
>  }
>
>  /**
> - * getnstimeofday - Returns the time of day in a timespec
> + * __getnstimeofday - Returns the time of day in a timespec.
>   * @ts:                pointer to the timespec to be set
>   *
> - * Returns the time of day in a timespec.
> + * Updates the time of day in the timespec.
> + * Returns 0 on success, or -ve when suspended (timespec will be undefined).
>   */
> -void getnstimeofday(struct timespec *ts)
> +int __getnstimeofday(struct timespec *ts)
>  {
>         struct timekeeper *tk = &timekeeper;
>         unsigned long seq;
>         s64 nsecs = 0;
>
> -       WARN_ON(timekeeping_suspended);
> -
>         do {
>                 seq = read_seqbegin(&tk->lock);
>
> @@ -243,6 +242,26 @@ void getnstimeofday(struct timespec *ts)
>
>         ts->tv_nsec = 0;
>         timespec_add_ns(ts, nsecs);
> +
> +       /*
> +        * Do not bail out early, in case there were callers still using
> +        * the value, even in the face of the WARN_ON.
> +        */
> +       if (unlikely(timekeeping_suspended))
> +               return -EAGAIN;
> +       return 0;
> +}
> +EXPORT_SYMBOL(__getnstimeofday);
> +
> +/**
> + * getnstimeofday - Returns the time of day in a timespec.
> + * @ts:                pointer to the timespec to be set
> + *
> + * Returns the time of day in a timespec (WARN if suspended).
> + */
> +void getnstimeofday(struct timespec *ts)
> +{
> +       WARN_ON(__getnstimeofday(ts));
>  }
>  EXPORT_SYMBOL(getnstimeofday);
>
> --
> 1.7.9.5
>
>
> --
> Kees Cook
> Chrome OS Security



-- 
Kees Cook
Chrome OS Security
