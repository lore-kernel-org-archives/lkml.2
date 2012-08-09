Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2HIGzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:55:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:36938 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab2HIGzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:55:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,738,1336374000"; 
   d="scan'208";a="205333400"
Message-ID: <50235ED0.5010107@intel.com>
Date: Thu, 09 Aug 2012 14:55:12 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, mingo@elte.hu
Subject: Re: [BUG] perf: sharing of cpuctx between core and ibs PMU causes
 problems
References: <CABPqkBRWLcP_9WOL_VvucnY7A2AcpzuvsUt4_ZUgYMREo-65dA@mail.gmail.com>
In-Reply-To: <CABPqkBRWLcP_9WOL_VvucnY7A2AcpzuvsUt4_ZUgYMREo-65dA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 08:51 AM, Stephane Eranian wrote:
> Hi,
> 
> I ran into a problem on my AMD box whereby I would hit the
> WARN_ON_ONCE(cpuctx->cgrp) in perf_cgroup_switch().
> 
> It took me a while to track this down. It turns out that the
> list_for_each_entry_rcu() loop had multiple iterations. That's
> normal, we have CPU PMU and IBS PMU.  But what caused
> the warning to fire is that both the core and IBS PMU were
> pointing to the same cpuctx struct. Thus, the cpuctx->cgrp
> was already set  in the second iteration.
> 
> Is the warning a false positive?

I think it's a false positive, I'm not sure.

> 
> In perf_pmu_register(), there is a search for a matching
> pmu->task_ctx_nr. Given that the field is pointing to
> perf_hw_context for both cpu and IBS PMU, there is
> a match and therefore the cpuctx are shared.
> 
> The question is: why do we have to share the cpuctx?
> 
> Note that the same issue probably exists with the Intel
> uncore PMU.

uncore PMU does not have this issue because uncore_pmu->task_ctx_nr
is 'perf_invalid_context'. find_pmu_context() always return NULL in
that case.

Regards
Yan, Zheng.

> 
> If we need to share, then the perf_cgroup_switch() code
> needs to change because, as it stands, it is doing the
> switching twice in this case.
> 


> Either way something looks wrong here.
> 
> Any idea?
> 

