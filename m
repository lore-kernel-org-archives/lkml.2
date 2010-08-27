Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0H0MQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:16:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:41269 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0H0MQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:16:23 -0400
Message-ID: <4C77ADC1.5030502@windriver.com>
Date: Fri, 27 Aug 2010 20:21:21 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, fweisbec@gmail.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix possible divide-by-zero in perf_swevent_overflow()
References: <1282824438-13970-1-git-send-email-dongdong.deng@windriver.com>	 <1282824727.1975.747.camel@laptop>  <4C765FD3.9060904@windriver.com> <1282827486.1975.845.camel@laptop>
In-Reply-To: <1282827486.1975.845.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2010 12:15:50.0636 (UTC) FILETIME=[9692EAC0:01CB45E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2010-08-26 at 20:36 +0800, DDD wrote:
>> Peter Zijlstra wrote:
>>> On Thu, 2010-08-26 at 20:07 +0800, Dongdong Deng wrote:
>>>> The event->hw.last_period is possible to zero, thus it will
>>>> cause divide_by_zero later in perf_swevent_set_period().
>>> How can it be zero?
>> When I am running the kgdbts to test the hw_breakpoint_layer with kgdb,
>> I get a call trace as following and this problem is hardly to reproduce.
>>
>> Maybe the root cause was from kgdb/hw_breakpoint_layer,
> 
> Yeah, I think there's a bug in the hw_breakpoint stuff, does something
> like the below fix it?

hello Peter,

Thanks for your patch, but I still could reproduce the problem with your 
patch.


Thanks,
Dongdong




> 
> 
>> but add a checking is good to us and harmless. :-)
> 
> Except that code path is already too bloated and should be reduced not
> added to and conditionals are expensive.
> 
> 
> ---
>  kernel/hw_breakpoint.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
> index d71a987..f57ebee 100644
> --- a/kernel/hw_breakpoint.c
> +++ b/kernel/hw_breakpoint.c
> @@ -600,9 +600,20 @@ static int __init init_hw_breakpoint(void)
>  }
>  core_initcall(init_hw_breakpoint);
>  
> +static int hw_breakpoint_enable(struct perf_event *event)
> +{
> +	struct hw_perf_event *hwc = &event->hw;
> +
> +	if (hwc->sample_period) {
> +		hwc->last_period = hwc->sample_period;
> +		perf_swevent_set_period(event);
> +	}
> +
> +	return arch_install_hw_breakpoint(event);
> +}
>  
>  struct pmu perf_ops_bp = {
> -	.enable		= arch_install_hw_breakpoint,
> +	.enable		= hw_breakpoint_enable,
>  	.disable	= arch_uninstall_hw_breakpoint,
>  	.read		= hw_breakpoint_pmu_read,
>  };
> 
> 

