Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab2HIOFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:05:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45158 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932626Ab2HIOFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:05:11 -0400
MIME-Version: 1.0
In-Reply-To: <50235ED0.5010107@intel.com>
References: <CABPqkBRWLcP_9WOL_VvucnY7A2AcpzuvsUt4_ZUgYMREo-65dA@mail.gmail.com>
	<50235ED0.5010107@intel.com>
Date: Thu, 9 Aug 2012 16:05:09 +0200
Message-ID: <CABPqkBT-pvmhyOHfMXs7dXsJXpEVmaSST1xFFHzCu4CDBf7baw@mail.gmail.com>
Subject: Re: [BUG] perf: sharing of cpuctx between core and ibs PMU causes problems
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 8:55 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> On 08/09/2012 08:51 AM, Stephane Eranian wrote:
>> Hi,
>>
>> I ran into a problem on my AMD box whereby I would hit the
>> WARN_ON_ONCE(cpuctx->cgrp) in perf_cgroup_switch().
>>
>> It took me a while to track this down. It turns out that the
>> list_for_each_entry_rcu() loop had multiple iterations. That's
>> normal, we have CPU PMU and IBS PMU.  But what caused
>> the warning to fire is that both the core and IBS PMU were
>> pointing to the same cpuctx struct. Thus, the cpuctx->cgrp
>> was already set  in the second iteration.
>>
>> Is the warning a false positive?
>
> I think it's a false positive, I'm not sure.
>
Well, but then you're doing the same work twice.

>>
>> In perf_pmu_register(), there is a search for a matching
>> pmu->task_ctx_nr. Given that the field is pointing to
>> perf_hw_context for both cpu and IBS PMU, there is
>> a match and therefore the cpuctx are shared.
>>
>> The question is: why do we have to share the cpuctx?
>>
>> Note that the same issue probably exists with the Intel
>> uncore PMU.
>
> uncore PMU does not have this issue because uncore_pmu->task_ctx_nr
> is 'perf_invalid_context'. find_pmu_context() always return NULL in
> that case.
>
Yes, I think IBS should do the same and that should fix the problem
there too. Will try that.
