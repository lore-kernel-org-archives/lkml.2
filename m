Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab2BHCYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 21:24:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45640 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab2BHCYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 21:24:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAMsRxfJH+9MS=Svmh0BvDSb8xqsPe2HPobkeKcn8JO35npjhwQ@mail.gmail.com>
References: <1328578047.1724.17.camel@dave-Dell-System-XPS-L502X>
	<CAMQu2gwfo5JXAqQaLUNs7C7J3TUhEO2zOcyD0Rk-D_O61Yrfag@mail.gmail.com>
	<CAMsRxfLNBbQO5XF+EHJqNsnW+s=ay3mjSV5dh=sxdwzktUu03g@mail.gmail.com>
	<CAMQu2gzfNAwtf1c6jrTZpfGMSqBgBrQKmFTeCFzbvMh9ESBDUg@mail.gmail.com>
	<CAMsRxfKR1ODH56BtcUT5Dv6qOVEYGVheEcW9ugXsZmLKok==bg@mail.gmail.com>
	<CAMQu2gwWt6oQPjxc1YHgOoxVkHdck_q78Xf==7ncwRj0_uS-JQ@mail.gmail.com>
	<CAMQu2gyCPtbNfBa5V8ve2JORN+sDeAY+hvR0g0_9U354JgcuiA@mail.gmail.com>
	<CAMsRxfJVEgVJoHcaPQbMg5mwz=tZUce4oibDUxtnevSF8bGY9g@mail.gmail.com>
	<CAMQu2gxVUqDF2HkPD=QeX0N_tUd=9FTd+T+1LHCR0tsCgQxC8Q@mail.gmail.com>
	<CAMsRxfJH+9MS=Svmh0BvDSb8xqsPe2HPobkeKcn8JO35npjhwQ@mail.gmail.com>
Date: Wed, 8 Feb 2012 10:24:00 +0800
Message-ID: <CACVXFVMx9Zx3ZQr6Q-17x5NVL8iuBJjOjtw39FJiWX=fGkZNZA@mail.gmail.com>
Subject: Re: oprofile and ARM A9 hardware counter
From: Ming Lei <ming.lei@canonical.com>
To: eranian@gmail.com
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        David Long <dave.long@linaro.org>, b-cousson@ti.com, mans@mansr.com,
        will.deacon@arm.com, linux-arm <linux-arm-kernel@lists.infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CC lkml and perf guys, since looks it is related with perf core.

On Tue, Feb 7, 2012 at 7:59 PM, stephane eranian <eranian@googlemail.com> wrote:
> An easier way to verify we're getting the right number of samples is
> to use perf top:
>
> $ taskset -c 1 noploop 1000 &
> $ sudo perf top
>
> You'll see around 850 irqs/sec, should be closer to 1000.
> But if I drop the rate to 100Hz, then it works:
>
> $ sudo perf top -F 100
>
> That leads me to believe there is too much overhead somewhere.
> Could be in perf_event itself.

Looks like the issue is caused by perf_event itself, but nothing to do
with much overhead
somewhere.

On OMAP4, HZ is 128, and perf_rotate_context may set a new sample period(~8ms),
which is much longer than 1ms in 1000HZ freq mode, so less sample events are
observed. X86 isn't affected since its HZ is 1000.

With patch[1], about 10000 sample events can be generated after running
'perf record -e cycles  ./noploop 10' and 'perf report -D | tail -20'
on panda board.

I am not sure if patch[1] is a right fix, but it can verify the problem.

thanks,
--
Ming Lei

[1], fix adjusting frequency in perf_rotate_context

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 32b48c8..db4faf2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2300,14 +2300,12 @@ do {					\
 	return div64_u64(dividend, divisor);
 }

-static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
+static void perf_adjust_period(struct perf_event *event, u64 period, u64 count)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	s64 period, sample_period;
+	s64 sample_period;
 	s64 delta;

-	period = perf_calculate_period(event, nsec, count);
-
 	delta = (s64)(period - hwc->sample_period);
 	delta = (delta + 7) / 8; /* low pass filter */

@@ -2363,8 +2361,13 @@ static void perf_ctx_adjust_freq(struct
perf_event_context *ctx, u64 period)
 		delta = now - hwc->freq_count_stamp;
 		hwc->freq_count_stamp = now;

-		if (delta > 0)
+		if (delta > 0) {
+			period = perf_calculate_period(event, period, delta);
+
+			if (period > 4*hwc->sample_period)
+				period = hwc->sample_period;
 			perf_adjust_period(event, period, delta);
+		}
 	}
 }

@@ -4533,8 +4536,10 @@ static int __perf_event_overflow(struct
perf_event *event,

 		hwc->freq_time_stamp = now;

-		if (delta > 0 && delta < 2*TICK_NSEC)
+		if (delta > 0 && delta < 2*TICK_NSEC) {
+			delta = perf_calculate_period(event, delta, hwc->last_period);
 			perf_adjust_period(event, delta, hwc->last_period);
+		}
 	}

 	/*
