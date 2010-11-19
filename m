Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab0KSJoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 04:44:20 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56312 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804Ab0KSJoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 04:44:19 -0500
Subject: Re: [PATCH 3/5] MIPS/Perf-events: Check event state in
 validate_event()
From: Will Deacon <will.deacon@arm.com>
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com
In-Reply-To: <1290063401-25440-4-git-send-email-dengcheng.zhu@gmail.com>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
	 <1290063401-25440-4-git-send-email-dengcheng.zhu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 09:43:26 +0000
Message-ID: <1290159806.9342.7.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2010 09:43:30.0259 (UTC) FILETIME=[392F1230:01CB87CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Deng-Cheng,

On Thu, 2010-11-18 at 06:56 +0000, Deng-Cheng Zhu wrote:
> Ignore events that are not for this PMU or are in off/error state.
> 
Sorry I didn't see this before, thanks for pointing out that you
had included it for MIPS.

> Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
> ---
>  arch/mips/kernel/perf_event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
> index 1ee44a3..9c6442a 100644
> --- a/arch/mips/kernel/perf_event.c
> +++ b/arch/mips/kernel/perf_event.c
> @@ -486,7 +486,7 @@ static int validate_event(struct cpu_hw_events *cpuc,
>  {
>         struct hw_perf_event fake_hwc = event->hw;
> 
> -       if (event->pmu && event->pmu != &pmu)
> +       if (event->pmu != &pmu || event->state <= PERF_EVENT_STATE_OFF)
>                 return 0;
> 
>         return mipspmu->alloc_counter(cpuc, &fake_hwc) >= 0;

So this is the opposite of what we're doing on ARM. Our
approach is to ignore events that are OFF (or in the ERROR
state) or that belong to a different PMU. We do this by
allowing them to *pass* validation (i.e. by returning 1 above).
This means that we won't unconditionally fail a mixed event group.

x86 does something similar in the collect_events function.

Will

