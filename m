Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0H0NO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:14:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:52343 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab0H0NOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:14:25 -0400
Message-ID: <4C77BB6B.9090706@windriver.com>
Date: Fri, 27 Aug 2010 21:19:39 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, fweisbec@gmail.com
CC: mingo@elte.hu, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix possible divide-by-zero in perf_swevent_overflow()
References: <1282824438-13970-1-git-send-email-dongdong.deng@windriver.com>	 <1282824727.1975.747.camel@laptop>  <4C765FD3.9060904@windriver.com>	 <1282827486.1975.845.camel@laptop>  <4C77ADC1.5030502@windriver.com> <1282913445.1975.2414.camel@laptop>
In-Reply-To: <1282913445.1975.2414.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2010 13:14:07.0891 (UTC) FILETIME=[BB19AE30:01CB45E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2010-08-27 at 20:21 +0800, DDD wrote:
> 
>>>> Maybe the root cause was from kgdb/hw_breakpoint_layer,
>>> Yeah, I think there's a bug in the hw_breakpoint stuff, does something
>>> like the below fix it?
> 
>> Thanks for your patch, but I still could reproduce the problem with your 
>> patch.
> 
> Frederic, any clue as to what makes hw breakpoints go funny and have
> last_period == 0?

Hi Peter,

Thanks for you take care of it, I have got the root cause of it now.

It is the kgdb using hw_breakpoint_layer's API problem, and I have a RFC 
patch for it.(maybe it is not correctly), I will contact with Jason to 
fix this problem.

Thank you very much,
Dongdong

> 
>>> ---
>>>  kernel/hw_breakpoint.c |   13 ++++++++++++-
>>>  1 files changed, 12 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
>>> index d71a987..f57ebee 100644
>>> --- a/kernel/hw_breakpoint.c
>>> +++ b/kernel/hw_breakpoint.c
>>> @@ -600,9 +600,20 @@ static int __init init_hw_breakpoint(void)
>>>  }
>>>  core_initcall(init_hw_breakpoint);
>>>  
>>> +static int hw_breakpoint_enable(struct perf_event *event)
>>> +{
>>> +     struct hw_perf_event *hwc = &event->hw;
>>> +
>>> +     if (hwc->sample_period) {
>>> +             hwc->last_period = hwc->sample_period;
>>> +             perf_swevent_set_period(event);
>>> +     }
>>> +
>>> +     return arch_install_hw_breakpoint(event);
>>> +}
>>>  
>>>  struct pmu perf_ops_bp = {
>>> -     .enable         = arch_install_hw_breakpoint,
>>> +     .enable         = hw_breakpoint_enable,
>>>       .disable        = arch_uninstall_hw_breakpoint,
>>>       .read           = hw_breakpoint_pmu_read,
>>>  };
>>>
>>>
> 

