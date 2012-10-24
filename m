Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934461Ab2JXIxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:53:16 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:60854 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab2JXIxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:53:13 -0400
MIME-Version: 1.0
In-Reply-To: <5087A8C8.2030200@intel.com>
References: <1351058350-9159-1-git-send-email-zheng.z.yan@intel.com>
	<1351058350-9159-2-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBRMo9o8bujM+aCqh-hWqVz1-Y1G_15Oovv+15SMBbK=aA@mail.gmail.com>
	<50879D71.3080108@intel.com>
	<CABPqkBQWvV5w-qyaWmbmqs9+7zaC8kBhmacuAF3FYvw-PCh=9A@mail.gmail.com>
	<5087A574.3040507@intel.com>
	<5087A8C8.2030200@intel.com>
Date: Wed, 24 Oct 2012 10:53:11 +0200
Message-ID: <CABPqkBS29OnR9N5bfRXTKOPvXx5A1rAx2rZdMk-2nHQHc=hBQg@mail.gmail.com>
Subject: Re: [PATCH V2 1/7] perf, x86: Reduce lbr_sel_map size
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 10:37 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> On 10/24/2012 04:23 PM, Yan, Zheng wrote:
>> On 10/24/2012 04:15 PM, Stephane Eranian wrote:
>>> On Wed, Oct 24, 2012 at 9:49 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>>>> On 10/24/2012 03:28 PM, Stephane Eranian wrote:
>>>>> On Wed, Oct 24, 2012 at 7:59 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>>>>>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>>>>>
>>>>>> The index of lbr_sel_map is bit value of perf branch_sample_type.
>>>>>> By using bit shift as index, we can reduce lbr_sel_map size.
>>>>>>
>>>>>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>>>>>> ---
>>>>>>  arch/x86/kernel/cpu/perf_event.h           |  4 +++
>>>>>>  arch/x86/kernel/cpu/perf_event_intel_lbr.c | 50 ++++++++++++++----------------
>>>>>>  include/uapi/linux/perf_event.h            | 42 +++++++++++++++++--------
>>>>>>  3 files changed, 56 insertions(+), 40 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
>>>>>> index d3b3bb7..ea6749a 100644
>>>>>> --- a/arch/x86/kernel/cpu/perf_event.h
>>>>>> +++ b/arch/x86/kernel/cpu/perf_event.h
>>>>>> @@ -412,6 +412,10 @@ struct x86_pmu {
>>>>>>         struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
>>>>>>  };
>>>>>>
>>>>>> +enum {
>>>>>> +       PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE = PERF_SAMPLE_BRANCH_MAX_SHIFT,
>>>>>> +};
>>>>>> +
>>>>> What's the point on the extraneous definition?
>>>>
>>>> because later patches will add map PERF_SAMPLE_BRANCH_CALL_STACK, it will make
>>>> "PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE != PERF_SAMPLE_BRANCH_MAX_SHIFT"
>>>>
>>> And you are not going to do:
>>>
>>> enum perf_branch_sample_type_shift {
>>> ...
>>> PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT = 10
>>> PERF_SAMPLE_BRANCH_MAX_SHIFT
>>> };
>>>
>>> PERF_SAMPLE_BRANCH_CALL_STACK = 1 << PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT
>>>
>>> Unless you're telling you are not going to add a mapping for
>>> PERF_SAMPLE_CALL_STACK to the
>>> lbr_sel_map[]?
>>>
>>
>> I think include/uapi/linux/perf_event.h should only contain definition for user API.
>> So I added PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT and PERF_SAMPLE_BRANCH_CALL_STACK to
>> arch/x86/kernel/cpu/perf_event.h. Please check patch 1.
>>
>
> Sorry, I mean patch 2.
>
Yeah, I figured that one. The part I was missing was that you're
trying to fit this
under PERF_SAMPLE_CALLCHAIN.

So now, looks like we have 3 different ways of getting user call stacks:
   - PERF_SAMPLE_CALLCHAIN via frame pointer
   - PERF_SAMPLE_CALLCHAIN via LBR cstack on HSW
   - PERF_SAMPLE_USER_CSTACK via stack copying + dwarf

And presumably all are available under perf record -g.

The difference I see with LBR cstack is that the callstack is much
smaller, max 16 deep
and it has the limitations you mentioned in the cover message.
