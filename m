Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab0HLNu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:50:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51270 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0HLNuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=I1Gcj88uC6P8Zrotn7O88yphcs/uyEnqEh5GEZHcPqu7UBHsYlW7gapYIhdHXmixR3
         M7pN1JhlvfTkAC4LCpcfkaMUo3JBTzhJvT26/kYnUkB0tAtNYjwSrvH+S8lJC2P7st4R
         LUyWQuk9k03ZzzNHEgvxwwN3fp247tyZlfiQQ=
MIME-Version: 1.0
In-Reply-To: <1281606545-20017-1-git-send-email-mcree@orcon.net.nz>
References: <1281606545-20017-1-git-send-email-mcree@orcon.net.nz>
From: Matt Turner <mattst88@gmail.com>
Date: Thu, 12 Aug 2010 09:50:33 -0400
Message-ID: <AANLkTikWBky79bd5u78Bkm3P2KXrVU=0dWCehEU7sGZg@mail.gmail.com>
Subject: Re: [PATCH] alpha: convert perf_event to use local_t
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 5:49 AM, Michael Cree <mcree@orcon.net.nz> wrote:
> Updates the Alpha perf_event code to match the changes
> recently made to the core perf_event code in commit
> e78505958cf123048fb48cb56b79cebb8edd15fb.
>
> Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> ---
>  arch/alpha/kernel/perf_event.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
> index 51c39fa..85d8e4f 100644
> --- a/arch/alpha/kernel/perf_event.c
> +++ b/arch/alpha/kernel/perf_event.c
> @@ -241,20 +241,20 @@ static inline unsigned long alpha_read_pmc(int idx)
>  static int alpha_perf_event_set_period(struct perf_event *event,
>                                struct hw_perf_event *hwc, int idx)
>  {
> -       long left = atomic64_read(&hwc->period_left);
> +       long left = local64_read(&hwc->period_left);
>        long period = hwc->sample_period;
>        int ret = 0;
>
>        if (unlikely(left <= -period)) {
>                left = period;
> -               atomic64_set(&hwc->period_left, left);
> +               local64_set(&hwc->period_left, left);
>                hwc->last_period = period;
>                ret = 1;
>        }
>
>        if (unlikely(left <= 0)) {
>                left += period;
> -               atomic64_set(&hwc->period_left, left);
> +               local64_set(&hwc->period_left, left);
>                hwc->last_period = period;
>                ret = 1;
>        }
> @@ -269,7 +269,7 @@ static int alpha_perf_event_set_period(struct perf_event *event,
>        if (left > (long)alpha_pmu->pmc_max_period[idx])
>                left = alpha_pmu->pmc_max_period[idx];
>
> -       atomic64_set(&hwc->prev_count, (unsigned long)(-left));
> +       local64_set(&hwc->prev_count, (unsigned long)(-left));
>
>        alpha_write_pmc(idx, (unsigned long)(-left));
>
> @@ -300,10 +300,10 @@ static unsigned long alpha_perf_event_update(struct perf_event *event,
>        long delta;
>
>  again:
> -       prev_raw_count = atomic64_read(&hwc->prev_count);
> +       prev_raw_count = local64_read(&hwc->prev_count);
>        new_raw_count = alpha_read_pmc(idx);
>
> -       if (atomic64_cmpxchg(&hwc->prev_count, prev_raw_count,
> +       if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
>                             new_raw_count) != prev_raw_count)
>                goto again;
>
> @@ -316,8 +316,8 @@ again:
>                delta += alpha_pmu->pmc_max_period[idx] + 1;
>        }
>
> -       atomic64_add(delta, &event->count);
> -       atomic64_sub(delta, &hwc->period_left);
> +       local64_add(delta, &event->count);
> +       local64_sub(delta, &hwc->period_left);
>
>        return new_raw_count;
>  }
> @@ -636,7 +636,7 @@ static int __hw_perf_event_init(struct perf_event *event)
>        if (!hwc->sample_period) {
>                hwc->sample_period = alpha_pmu->pmc_max_period[0];
>                hwc->last_period = hwc->sample_period;
> -               atomic64_set(&hwc->period_left, hwc->sample_period);
> +               local64_set(&hwc->period_left, hwc->sample_period);
>        }
>
>        return 0;
> --
> 1.7.1
>
>

Thanks Michael. I'll apply this when I get back from vacation.
