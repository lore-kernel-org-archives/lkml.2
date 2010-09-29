Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0I2N4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:56:16 -0400
Received: from smtp-out.google.com ([74.125.121.35]:10797 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab0I2N4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rzo53zqcOpt0mZa/TOAoaxtIm4q96XVA392qhwmed+FxCR3+4eCn/4V2jP0OxiYklz
         oYoYXsK3iFCJQ1Imh5EA==
MIME-Version: 1.0
In-Reply-To: <20100929133923.GI13563@erda.amd.com>
References: <20100915162034.GO13563@erda.amd.com>
	<tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
	<AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
	<20100929125301.GG13563@erda.amd.com>
	<20100929125453.GH13563@erda.amd.com>
	<AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
	<20100929133923.GI13563@erda.amd.com>
Date: Wed, 29 Sep 2010 15:56:08 +0200
Message-ID: <AANLkTin2QnqsfxdZa2D07DKCM0n5bX43Ch6KqumaDW=O@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 3:39 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 29.09.10 09:13:30, Stephane Eranian wrote:
>
>> for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
>>                 struct perf_event *event = cpuc->events[bit];
>>
>>                 handled++;
>>
>>                 if (!test_bit(bit, cpuc->active_mask))
>
>                        /* spurious interrupt here */
>
>>                     continue;
>> }
>>
>> I think the logic is similar. What makes the difference, it seems, is that
>> handled is incremented unconditionally if the ovfl_mask says it has
>> an overflow, i.e., before active_mask is checked.
>
> Note that we can use here for_each_set_bit() since we have the status
> mask. So we may increment handled always.
>
> On AMD we use for_each_counter(), but only check active counters to
> avoid unnecessary rdmsrl()s for unused counters. But here, we only can
> increment handled if we detect an overflow or if we know a counter was
> disabled.
>
>> On Westmere, we've seen situations where the overflow mask and active
>> mask did not agree.
>
> It's the 'spurious interrupt' branch above.
>
>> On counter disable, the overflow mask bit is not cleared, thus one may iterate
>> in the loop and fail the active_mask. But handled would be incremented in that
>> case, so that would behave like in your patch.
>
> Right, spurious interrupts are counted and a 'handled' is returned.
>
Ok, I think we agree on this. It is handled in the Intel case, though it
is not clearly explained with a comment.
The P4 case needs to be fixed.

Here is another difference I noticed in x86_handle_irq() vs.
intel_pmu_handle_irq().
For Intel, handled is incremented even if there is no 64-bit overflow.

With generic X86, it is incremented only when you have a 64-bit
overflow. I think that's wrong. You don't hit that condition very often
on AMD because counters are 47 bits wide, but this is generic code
and on P6 you definitively will. I believe you need to hoist handled++
just after the check on active_mask.


What do you think?

> -Robert
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
>
>
