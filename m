Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab2JXLdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:33:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:36317 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266Ab2JXLdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:33:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,639,1344236400"; 
   d="scan'208";a="239459086"
Message-ID: <5087CF96.7010406@intel.com>
Date: Wed, 24 Oct 2012 19:23:02 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V2 6/7] perf, x86: Use LBR call stack to get user callchain
References: <1351058350-9159-1-git-send-email-zheng.z.yan@intel.com> <1351058350-9159-7-git-send-email-zheng.z.yan@intel.com> <CABPqkBRzwsmzaGFKK9+zOed8HK=Q9T9++hMHW+tSKh4EF0cKjg@mail.gmail.com>
In-Reply-To: <CABPqkBRzwsmzaGFKK9+zOed8HK=Q9T9++hMHW+tSKh4EF0cKjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 04:57 PM, Stephane Eranian wrote:
> On Wed, Oct 24, 2012 at 7:59 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> Try enabling the LBR call stack feature if event request recording
>> callchain. Try utilizing the LBR call stack to get user callchain
>> in case of there is no frame pointer.
>>
>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event.c           | 126 +++++++++++++++++++++--------
>>  arch/x86/kernel/cpu/perf_event.h           |   7 ++
>>  arch/x86/kernel/cpu/perf_event_intel.c     |  20 ++---
>>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |   3 +
>>  include/linux/perf_event.h                 |   6 ++
>>  kernel/events/core.c                       |  11 ++-
>>  6 files changed, 124 insertions(+), 49 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
>> index 8ae8044..3bf2100 100644
>> --- a/arch/x86/kernel/cpu/perf_event.c
>> +++ b/arch/x86/kernel/cpu/perf_event.c
>> @@ -398,35 +398,46 @@ int x86_pmu_hw_config(struct perf_event *event)
>>
>>                 if (event->attr.precise_ip > precise)
>>                         return -EOPNOTSUPP;
>> -               /*
>> -                * check that PEBS LBR correction does not conflict with
>> -                * whatever the user is asking with attr->branch_sample_type
>> -                */
>> -               if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
>> -                       u64 *br_type = &event->attr.branch_sample_type;
>> -
>> -                       if (has_branch_stack(event)) {
>> -                               if (!precise_br_compat(event))
>> -                                       return -EOPNOTSUPP;
>> -
>> -                               /* branch_sample_type is compatible */
>> -
>> -                       } else {
>> -                               /*
>> -                                * user did not specify  branch_sample_type
>> -                                *
>> -                                * For PEBS fixups, we capture all
>> -                                * the branches at the priv level of the
>> -                                * event.
>> -                                */
>> -                               *br_type = PERF_SAMPLE_BRANCH_ANY;
>> -
>> -                               if (!event->attr.exclude_user)
>> -                                       *br_type |= PERF_SAMPLE_BRANCH_USER;
>> -
>> -                               if (!event->attr.exclude_kernel)
>> -                                       *br_type |= PERF_SAMPLE_BRANCH_KERNEL;
>> -                       }
>> +       }
>> +       /*
>> +        * check that PEBS LBR correction does not conflict with
>> +        * whatever the user is asking with attr->branch_sample_type
>> +        */
>> +       if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
>> +               u64 *br_type = &event->attr.branch_sample_type;
>> +
>> +               if (has_branch_stack(event)) {
>> +                       if (!precise_br_compat(event))
>> +                               return -EOPNOTSUPP;
>> +
>> +                       /* branch_sample_type is compatible */
>> +
>> +               } else {
>> +                       /*
>> +                        * user did not specify  branch_sample_type
>> +                        *
>> +                        * For PEBS fixups, we capture all
>> +                        * the branches at the priv level of the
>> +                        * event.
>> +                        */
>> +                       *br_type = PERF_SAMPLE_BRANCH_ANY;
>> +
>> +                       if (!event->attr.exclude_user)
>> +                               *br_type |= PERF_SAMPLE_BRANCH_USER;
>> +
>> +                       if (!event->attr.exclude_kernel)
>> +                               *br_type |= PERF_SAMPLE_BRANCH_KERNEL;
>> +               }
>> +       } else if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) {
>> +               if (!has_branch_stack(event) && x86_pmu.attr_lbr_callstack) {
>> +                       /*
>> +                        * user did not specify branch_sample_type,
>> +                        * try using the LBR call stack facility to
>> +                        * record call chains in the user space.
>> +                        */
>> +                       event->attr.branch_sample_type =
>> +                               PERF_SAMPLE_BRANCH_USER |
>> +                               PERF_SAMPLE_BRANCH_CALL_STACK;
> 
> You are forcing user level here, but how do you know the user wanted
> ONLY user level
> callchains?
> 
> 

The LBR call stack is used only when the frame pointer approach doesn't work.
I think the kernel has frame pointer for the most cases. The second reason is
that the LBR call stack only has 16 entries. I think it's too small to record
both kernel and user call chains.

Regards
Yan, Zheng

