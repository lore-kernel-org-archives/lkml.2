Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0EaNBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:01:12 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:6063 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751745Ab0EaNBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:01:11 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lab9bhzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L3AC5L-01-DFD-02
X-M-MSG: 
Date: Mon, 31 May 2010 15:00:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] perf, x86: Segregate PMU workaraunds into
 x86_pmu_quirk_ops structure
Message-ID: <20100531130058.GR21799@erda.amd.com>
References: <20100529182409.GJ5322@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100529182409.GJ5322@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.05.10 14:24:09, Cyrill Gorcunov wrote:
> Hi,
> 
> I would appreciate comments/complains on the following patch. The idea is to implement
> PMU quirks with minimal impact. At the moment two quirks are addressed -
> PEBS disabling on Clovertown and P4 performance counter double write.
> PEBS disabling already was there only moved to x86_pmu_quirk_ops. Note
> that I didn't use pointer to the structure intensionally but embed it into
> x86_pmu, if the structure grow we will need to use a pointer to the structure.

The quirk functions add additional code and ops structures to the
already existing model specific code. This quirks would be fine if we
would could merge model specific code and get unified code. But these
model specific code cannot be replaced. So I rather prefer to
implement cpu errata in model specific code.

> @@ -185,6 +185,11 @@ union perf_capabilities {
>  	u64	capabilities;
>  };
>  
> +struct x86_pmu_quirk_ops {
> +	void		(*pmu_init)(void);

This init quirk could be much better handled in the model specific
init code (intel_pmu_init()/amd_pmu_init()). I don't see a reason for
adding the quirk first and then immediately calling it. The quirk
function could be called directly instead.

> +	void		(*perfctr_write)(unsigned long addr, u64 value);

This one is difficult to avoid ...

> @@ -924,7 +930,11 @@ x86_perf_event_set_period(struct perf_ev
>  	 */
>  	atomic64_set(&hwc->prev_count, (u64)-left);
>  
> -	wrmsrl(hwc->event_base + idx,
> +	if (x86_pmu.quirks.perfctr_write)
> +		x86_pmu.quirks.perfctr_write(hwc->event_base + idx,
> +				(u64)(-left) & x86_pmu.cntval_mask);
> +	else
> +		wrmsrl(hwc->event_base + idx,

... but it introduces another check in the fast path. There are some
options to avoid this. First we could see if we rather implement this
in model specific interrupt handlers (there is p4_pmu_handle_irq()).
Or, we implement an optimized check for perf quirks, maybe using
ALTERNATIVE or jump labels.

I think we can handle both quirks, but if we start using and extending
it more, it will have a performance impact and code will also more
complicated. So, I think it is rather inappropriate as a general
approach.

-Robert

>  			(u64)(-left) & x86_pmu.cntval_mask);
>  
>  	perf_event_update_userpage(event);

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

