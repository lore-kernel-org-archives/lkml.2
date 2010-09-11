Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0IKIQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 04:16:27 -0400
Received: from mx9.orcon.net.nz ([219.88.242.59]:35890 "EHLO mx9.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab0IKIQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 04:16:24 -0400
Message-ID: <4C8B3AD3.5050309@orcon.net.nz>
Date: Sat, 11 Sep 2010 20:16:19 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: mingo@redhat.com, dengcheng.zhu@gmail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, gorcunov@gmail.com, fweisbec@gmail.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        eranian@googlemail.com, will.deacon@arm.com, lethal@linux-sh.org,
        davem@davemloft.net, mingo@elte.hu
CC: linux-alpha@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Rework the PMU methods
References: <new-submission> <tip-a4eaf7f14675cb512d69f0c928055e73d0c6d252@git.kernel.org>
In-Reply-To: <tip-a4eaf7f14675cb512d69f0c928055e73d0c6d252@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx9.orcon.net.nz on Sat, 11 Sep 2010 20:16:20 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat Sep 11 20:16:22 2010
X-DSPAM-Confidence: 0.7616
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/10 07:50, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  a4eaf7f14675cb512d69f0c928055e73d0c6d252
> Gitweb:     http://git.kernel.org/tip/a4eaf7f14675cb512d69f0c928055e73d0c6d252
> Author:     Peter Zijlstra<a.p.zijlstra@chello.nl>
> AuthorDate: Wed, 16 Jun 2010 14:37:10 +0200
> Committer:  Ingo Molnar<mingo@elte.hu>
> CommitDate: Thu, 9 Sep 2010 20:46:30 +0200
>
> perf: Rework the PMU methods
>
> Replace pmu::{enable,disable,start,stop,unthrottle} with
> pmu::{add,del,start,stop}, all of which take a flags argument.

Regarding the new function alpha_pmu_stop() in 
arch/alpha/kernel/perf_event.c:

> -static void alpha_pmu_unthrottle(struct perf_event *event)
> +static void alpha_pmu_stop(struct perf_event *event, int flags)
>   {
>   	struct hw_perf_event *hwc =&event->hw;
>   	struct cpu_hw_events *cpuc =&__get_cpu_var(cpu_hw_events);
>
> +	if (!(hwc->state&  PERF_HES_STOPPED)) {
> +		cpuc->idx_mask&= !(1UL<<hwc->idx);
                                  ^
Presumably ones complement (rather than logical not) is meant.

> +		hwc->state |= PERF_HES_STOPPED;
> +	}
> +
> +	if ((flags&  PERF_EF_UPDATE)&&  !(hwc->state&  PERF_HES_UPTODATE)) {
> +		alpha_perf_event_update(event, hwc, hwc->idx, 0);
> +		hwc->state |= PERF_HES_UPTODATE;
> +	}
> +
> +	if (cpuc->enabled)
> +		wrperfmon(PERFMON_CMD_ENABLE, (1UL<<hwc->idx));

By the name of the function (alpha_pmu_stop) I assume that the intent is 
to stop the specific PMC here.  The above fails to do that.  When 
wrperfmon() is used with PERFMON_CMD_ENABLE it enables the PMCs with set 
bits in the second argument.  It does not stop the others.  To do that 
wrperfmon() must be called with PERFMON_CMD_DISABLE and the 
corresponding PMC bits set to disable the PMC.

Cheers
Michael.
