Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0I2TBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:01:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab0I2TBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:01:45 -0400
Date: Wed, 29 Sep 2010 15:01:14 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20100929190114.GZ26290@redhat.com>
References: <20100915162034.GO13563@erda.amd.com>
 <tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
 <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
 <20100929125301.GG13563@erda.amd.com>
 <20100929125453.GH13563@erda.amd.com>
 <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
 <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com>
 <20100929150140.GK13563@erda.amd.com>
 <20100929151253.GL13563@erda.amd.com>
 <20100929152745.GC9440@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929152745.GC9440@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 07:27:45PM +0400, Cyrill Gorcunov wrote:
> 
>   Cyrill
> ---
> Subject: [PATCH -tip] perf, x86: Handle in flight IRQs on P4 platform
> 
> Stephane reported we've missed to guard P4 platform
> against spurious in-flight performance IRQs. Fix it.
> 
> [ the patch is a complement to commit 63e6be6d98e1 ]
> 
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Robert Richter <robert.richter@amd.com>
> CC: Lin Ming <ming.m.lin@intel.com>

Thanks Cyrill,

I'll test it quickly and try to send it to Ingo.

Cheers,
Don
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -904,8 +904,12 @@ static int p4_pmu_handle_irq(struct pt_r
>  	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
>  		int overflow;
>  
> -		if (!test_bit(idx, cpuc->active_mask))
> +		if (!test_bit(idx, cpuc->active_mask)) {
> +			/* catch in-flight IRQs */
> +			if (__test_and_clear_bit(idx, cpuc->running))
> +				handled++;
>  			continue;
> +		}
>  
>  		event = cpuc->events[idx];
>  		hwc = &event->hw;
