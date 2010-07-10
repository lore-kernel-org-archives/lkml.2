Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0GJNhF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 09:37:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44343 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab0GJNhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 09:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wAlZhAPp4I1Bat4tPeSE0tJ3CZpRpHt4iKELjv3P4E59+UvHeur6WDdiGMicJxsDN7
         wM3ixyiswVTil6kY0BnsJQAytp8FSFa/Zst2Lm/v8/JKyNtmLbNhzWkNabfsznT19pF4
         J224LBIy8/ciZj50BSmvtDcLDtSG6HnQwD9YU=
Date: Sat, 10 Jul 2010 15:36:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 13/13] perf: Rework the PMU methods
Message-ID: <20100710133647.GA5306@nowhere>
References: <20100709082117.631541128@chello.nl> <20100709083248.337539831@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100709083248.337539831@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 10:21:30AM +0200, Peter Zijlstra wrote:
> -static void x86_pmu_pmu_enable(struct pmu *pmu)
> +static void x86_pmu_enable(struct pmu *pmu)
>  {
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>  	struct perf_event *event;
> @@ -839,7 +839,14 @@ static void x86_pmu_pmu_enable(struct pm
>  			    match_prev_assignment(hwc, cpuc, i))
>  				continue;
>  
> -			x86_pmu_stop(event);
> +			/*
> +			 * Ensure we don't accidentally enable a stopped
> +			 * counter simply because we rescheduled.
> +			 */
> +			if (hwc->state & PERF_HES_STOPPED)
> +				hwc->state |= PERF_HES_ARCH;



So, if I understood well, this is to avoid enabling an event from perf_pmu_enable()
while the event was already stopped.

Looks good but why this ARCH name then? This should be a kind of PERF_HES_ONCPU
or so.

