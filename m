Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab2AGXLM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 18:11:12 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42740 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521Ab2AGXLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 18:11:11 -0500
MIME-Version: 1.0
In-Reply-To: <1325955818.2442.29.camel@twins>
References: <20120106181912.GA5564@quad>
	<1325955818.2442.29.camel@twins>
Date: Sun, 8 Jan 2012 00:11:08 +0100
Message-ID: <CABPqkBSmDHHJsSQo8hhe0a9zxr+YX1yWNr3hZoWEU-OShu7=wA@mail.gmail.com>
Subject: Re: [PATCH] perf_events: proposed fix for broken intr throttling (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, mingo@elte.hu,
        asharma@fb.com, vince@deater.net, wcohen@redhat.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q07NBnW8031170

On Sat, Jan 7, 2012 at 6:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-01-06 at 19:19 +0100, Stephane Eranian wrote:
>> The throttling mechanism REQUIRES that the hwc->interrupts counter be reset
>> at EACH timer tick.
>
> Just to be contrary.. :-)
>
I'll look into that one. But at first glance, it does not address the issue
of adjusting the period at each timer tick. Only multiplexing (rotation) should
happen at the multiplier rate.

> ---
>  include/linux/perf_event.h |    1 +
>  kernel/events/core.c       |   76 +++++++++++++++++++++++++++++++-------------
>  2 files changed, 55 insertions(+), 22 deletions(-)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 0b91db2..29dedf4 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -589,6 +589,7 @@ struct hw_perf_event {
>        u64                             sample_period;
>        u64                             last_period;
>        local64_t                       period_left;
> +       u64                             interrupts_seq;
>        u64                             interrupts;
>
>        u64                             freq_time_stamp;
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 91fb68a..693e1ce 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2325,11 +2325,14 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
>        }
>  }
>
> +static DEFINE_PER_CPU(int, perf_throttled_count);
> +static DEFINE_PER_CPU(u64, perf_throttled_seq);
> +
>  static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
>  {
>        struct perf_event *event;
>        struct hw_perf_event *hwc;
> -       u64 interrupts, now;
> +       u64 now;
>        s64 delta;
>
>        if (!ctx->nr_freq)
> @@ -2342,22 +2345,11 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
>                if (!event_filter_match(event))
>                        continue;
>
> -               hwc = &event->hw;
> -
> -               interrupts = hwc->interrupts;
> -               hwc->interrupts = 0;
> -
> -               /*
> -                * unthrottle events on the tick
> -                */
> -               if (interrupts == MAX_INTERRUPTS) {
> -                       perf_log_throttle(event, 1);
> -                       event->pmu->start(event, 0);
> -               }
> -
>                if (!event->attr.freq || !event->attr.sample_freq)
>                        continue;
>
> +               hwc = &event->hw;
> +
>                event->pmu->read(event);
>                now = local64_read(&event->count);
>                delta = now - hwc->freq_count_stamp;
> @@ -2441,14 +2433,45 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
>                list_del_init(&cpuctx->rotation_list);
>  }
>
> +static void perf_unthrottle_context(struct perf_event_context *ctx)
> +{
> +       raw_spin_lock(&ctx->lock);
> +       list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
> +               if (event->state != PERF_EVENT_STATE_ACTIVE)
> +                       continue;
> +
> +               if (!event_filter_match(event))
> +                       continue;
> +
> +               if (event->hw.interrupts == MAX_INTERRUPTS) {
> +                       perf_log_throttle(event, 1);
> +                       event->pmu->start(event, 0);
> +               }
> +       }
> +       raw_spin_unlock(&ctx->lock);
> +}
> +
>  void perf_event_task_tick(void)
>  {
>        struct list_head *head = &__get_cpu_var(rotation_list);
>        struct perf_cpu_context *cpuctx, *tmp;
> +       int throttle;
>
>        WARN_ON(!irqs_disabled());
>
> +       __this_cpu_inc(perf_throttled_seq);
> +       throttled = __this_cpu_xchg(perf_throttled_count, 0);
> +
>        list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
> +               if (throttled) {
> +                       struct perf_event_context *ctx;
> +
> +                       perf_unthrottle_context(&cpuctx->ctx);
> +                       ctx = cpuctx->task_ctx;
> +                       if (ctx)
> +                               perf_unthrottle_context(ctx);
> +               }
> +
>                if (cpuctx->jiffies_interval == 1 ||
>                                !(jiffies % cpuctx->jiffies_interval))
>                        perf_rotate_context(cpuctx);
> @@ -4514,6 +4537,7 @@ static int __perf_event_overflow(struct perf_event *event,
>  {
>        int events = atomic_read(&event->event_limit);
>        struct hw_perf_event *hwc = &event->hw;
> +       u64 seq;
>        int ret = 0;
>
>        /*
> @@ -4523,14 +4547,22 @@ static int __perf_event_overflow(struct perf_event *event,
>        if (unlikely(!is_sampling_event(event)))
>                return 0;
>
> -       if (unlikely(hwc->interrupts >= max_samples_per_tick)) {
> -               if (throttle) {
> -                       hwc->interrupts = MAX_INTERRUPTS;
> -                       perf_log_throttle(event, 0);
> -                       ret = 1;
> -               }
> -       } else
> -               hwc->interrupts++;
> +       seq = ACCESS_ONCE(__this_cpu_read(perf_throttled_seq));
> +
> +       if (seq != hwc->interrupts_seq) {
> +               hwc->interrupts_seq = seq;
> +               hwc->interrupts = 1;
> +       } else {
> +               if (unlikely(hwc->interrupts >= max_samples_per_tick)) {
> +                       if (throttle) {
> +                               __this_cpu_inc(perf_throttled_count);
> +                               hwc->interrupts = MAX_INTERRUPTS;
> +                               perf_log_throttle(event, 0);
> +                               ret = 1;
> +                       }
> +               } else
> +                       hwc->interrupts++;
> +       }
>
>        if (event->attr.freq) {
>                u64 now = perf_clock();
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
