Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab0IBT0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:26:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60935 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab0IBT0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qoIRl9Ijc6G9r2k/JRtFV0mHprixNNmMpCxaN/bHAPtvDWPLGbp9L2Z88zT17qYmG+
         WeRu9i8mdICIXpqPM1vPGJIYhBq4W3xeolyCd3T6WQEUGm2WqCPCO+ITx8d7bjtlmz7Y
         z8xML7fP9LRvktq/q/hjWuQQzP+5ZXLSjWBt4=
Date: Thu, 2 Sep 2010 23:26:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, robert.richter@amd.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        eranian@google.com
Subject: Re: [PATCH 1/3] perf, x86: Fix accidentally ack'ing a second event
	on intel perf counter
Message-ID: <20100902192627.GB5538@lenovo>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com> <1283454469-1909-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283454469-1909-2-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 03:07:47PM -0400, Don Zickus wrote:
> During testing of a patch to stop having the perf subsytem swallow nmis,
> it was uncovered that Nehalem boxes were randomly getting unknown nmis
> when using the perf tool.
> 
> Moving the ack'ing of the PMI closer to when we get the status allows
> the hardware to properly re-set the PMU bit signaling another PMI was
> triggered during the processing of the first PMI.  This allows the new
> logic for dealing with the shortcomings of multiple PMIs to handle the
> extra NMI by 'eat'ing it later.
> 
> Now one can wonder why are we getting a second PMI when we disable all
> the PMUs in the begining of the NMI handler to prevent such a case, for
> that I do not know.  But I know the fix below helps deal with this quirk.
> 
> Tested on multiple Nehalems where the problem was occuring.  With the
> patch, the code now loops a second time to handle the second PMI (whereas
> before it was not).
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 

Hi Don,

I might be missing something (I'm sure I'm actually) so enlighten me
a bit please

> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index d8d86d0..1297bf1 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -712,7 +712,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
>  	struct perf_sample_data data;
>  	struct cpu_hw_events *cpuc;
>  	int bit, loops;
> -	u64 ack, status;
> +	u64 status;
>  

Lets assume 1 counters is triggered and global bit is set as well

we have here

	status = intel_pmu_get_status();

>  	perf_sample_data_init(&data, 0);
>  
> @@ -728,6 +728,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
>  
>  	loops = 0;
>  again:
> +	intel_pmu_ack_status(status);

So here we write just being read value back to CTRL register and _if_ new
overflow happened in this window we've cleared it without processing.

>  	if (++loops > 100) {
>  		WARN_ONCE(1, "perfevents: irq loop stuck!\n");
>  		perf_event_print_debug();
> @@ -736,7 +737,6 @@ again:
>  	}
>  
>  	inc_irq_stat(apic_perf_irqs);
> -	ack = status;
>  
>  	intel_pmu_lbr_read();
>  
> @@ -761,8 +761,6 @@ again:
>  			x86_pmu_stop(event);
>  	}
>  
> -	intel_pmu_ack_status(ack);
> -

Here we cleared bits in "status" variable and then we read
status register again without cleaning bits in real physical
register which confuses me.

>  	/*
>  	 * Repeat if there is more work to be done:
>  	 */
> -- 
> 1.7.2.2
> 

	-- Cyrill
