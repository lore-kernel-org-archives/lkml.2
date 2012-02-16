Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab2BPKZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:25:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52011 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2BPKZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:25:08 -0500
MIME-Version: 1.0
In-Reply-To: <1329323900.2293.150.camel@twins>
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
	<CACVXFVMx9Zx3ZQr6Q-17x5NVL8iuBJjOjtw39FJiWX=fGkZNZA@mail.gmail.com>
	<1329323900.2293.150.camel@twins>
Date: Thu, 16 Feb 2012 18:25:05 +0800
Message-ID: <CACVXFVPce0A3LfL=mFo3UbN-Om7xLOo_d-LfKXDjdN5dFQdhiA@mail.gmail.com>
Subject: Re: oprofile and ARM A9 hardware counter
From: Ming Lei <ming.lei@canonical.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        David Long <dave.long@linaro.org>, b-cousson@ti.com, mans@mansr.com,
        will.deacon@arm.com, linux-arm <linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 16, 2012 at 12:38 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> So what this patch seems to do is put that filter on period in
> perf_ctx_adjust_freq(). Not making sense.. nor can I see a HZ
> dependency, perf_ctx_adjust_freq() uses TICK_NSEC as time base.

Yes, you are right, I remembered it was observed it on -rc1, and
Stephane's unthrottling
patch was not merged at that time. Today I investigated the problem
further on -rc3 and found that seems the problem is caused by arm pmu code.

The patch below may fix the problem, now about 40000 sample events
can be generated on the command:

	'perf record -e cycles -F 4000  ./noploop 10&& perf report -D | tail -20'

armpmu_event_update may be called in tick path, so the running counter
will be overflowed and produce a great value of 'delta', then a mistaken
count is stored into event->count and event->hw.freq_count_stamp. Finally
the two variables are not synchronous, then a invalid and large period is
computed and written to pmu, and sample events are decreased much.

Will, this patch simplifies the 'delta' computation and doesn't use the
overflow flag, even though which can be read directly from PMOVSR, could you
comment on the patch?

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 5bb91bf..789700a 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -193,13 +193,8 @@ again:
 			     new_raw_count) != prev_raw_count)
 		goto again;

-	new_raw_count &= armpmu->max_period;
-	prev_raw_count &= armpmu->max_period;
-
-	if (overflow)
-		delta = armpmu->max_period - prev_raw_count + new_raw_count + 1;
-	else
-		delta = new_raw_count - prev_raw_count;
+	delta = (armpmu->max_period - prev_raw_count + new_raw_count
+				+ 1) & armpmu->max_period;

 	local64_add(delta, &event->count);
 	local64_sub(delta, &hwc->period_left);


thanks,
--
Ming Lei
