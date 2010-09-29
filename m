Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0I2NNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:13:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab0I2NNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=k4snLLy1xasbzeE3rIiuS6lED95iGxo5bRlzN+y+JZWKp0VDXncAKA4QC1qMLF3cdU
         fbxhEz+cGVNXy2V+vwZg==
MIME-Version: 1.0
In-Reply-To: <20100929125453.GH13563@erda.amd.com>
References: <20100915162034.GO13563@erda.amd.com>
	<tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
	<AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
	<20100929125301.GG13563@erda.amd.com>
	<20100929125453.GH13563@erda.amd.com>
Date: Wed, 29 Sep 2010 15:13:30 +0200
Message-ID: <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 2:54 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 29.09.10 14:53:01, Robert Richter wrote:
>> Stephane,
>>
>> On 29.09.10 08:26:41, Stephane Eranian wrote:
>> > You've applied the fix only to the generic X86 interrupt handler
>> > which is currently used by AMD64 processors.
>>
>> (... and P4).
>>
>> > It seems to me that this "in-flight interrupt after disable" problem
>> > may also happen on Intel and should therefore also be added
>> > to intel_pmu_handle_irq(). Don't you think so?
>>
>> It only happens if the active_mask is used for checking single
>> counters for overflows.
>>
On Intel there is a double-check. You obtain the overflow mask
from HW. For each bit set, you verify it corresponds to an active
event. If not, you ignore:

for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
                struct perf_event *event = cpuc->events[bit];

                handled++;

                if (!test_bit(bit, cpuc->active_mask))
                    continue;
}

I think the logic is similar. What makes the difference, it seems, is that
handled is incremented unconditionally if the ovfl_mask says it has
an overflow, i.e., before active_mask is checked.

On Westmere, we've seen situations where the overflow mask and active
mask did not agree.

On counter disable, the overflow mask bit is not cleared, thus one may iterate
in the loop and fail the active_mask. But handled would be incremented in that
case, so that would behave like in your patch.




>> Systems with Intel Architectural Perfmon use the status mask msr to
>> determine which counter overflowed. In intel_pmu_handle_irq() the
>> handled counter is incremented in this case even if the counter is not
>
> I mean handled count (variable 'handled').
>
>> active, so everything should be fine here.
>>
>> -Robert
>>
>> --
>> Advanced Micro Devices, Inc.
>> Operating System Research Center
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
>
>
