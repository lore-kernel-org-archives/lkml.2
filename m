Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0EEQ5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:57:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64534 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab0EEQ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ec5eGCU2loMCTd/Egx0GuhDws/6uSisYRmu8d98dOZDv/s87YOcOtOhTRu62Zy2mqt
         Jb2oF5xoumhP3yp1JU3Ddk4P1ktDkAd1eHwgj9R3Gp3t6znTN+tYJgMDkhvC3llCZSRS
         Qqq02G0jXYU9755ZeXh5ifShw1IcZmGKFh/Sw=
Date: Wed, 5 May 2010 18:57:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -tip] x86,perf: P4 PMU -- protect sensible procedures
	from preemption
Message-ID: <20100505165731.GA6320@nowhere>
References: <20100505150740.GB5686@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505150740.GB5686@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 07:07:40PM +0400, Cyrill Gorcunov wrote:
> Steven reported
> |
> | I'm getting:
> |
> | Pid: 3477, comm: perf Not tainted 2.6.34-rc6 #2727
> | Call Trace:
> |  [<ffffffff811c7565>] debug_smp_processor_id+0xd5/0xf0
> |  [<ffffffff81019874>] p4_hw_config+0x2b/0x15c
> |  [<ffffffff8107acbc>] ? trace_hardirqs_on_caller+0x12b/0x14f
> |  [<ffffffff81019143>] hw_perf_event_init+0x468/0x7be
> |  [<ffffffff810782fd>] ? debug_mutex_init+0x31/0x3c
> |  [<ffffffff810c68b2>] T.850+0x273/0x42e
> |  [<ffffffff810c6cab>] sys_perf_event_open+0x23e/0x3f1
> |  [<ffffffff81009e6a>] ? sysret_check+0x2e/0x69
> |  [<ffffffff81009e32>] system_call_fastpath+0x16/0x1b
> |
> | When running perf record in latest tip/perf/core
> |
> 
> Due to the fact that p4 counters are shared between HT threads
> we synthetically divide the whole set of counters into two
> non-intersected subsets. And while we're borrowing counters
> from these subsets we should not be preempted. So use
> get_cpu/put_cpu pair.
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Tested-by: Steven Rostedt <rostedt@goodmis.org>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -421,7 +421,7 @@ static u64 p4_pmu_event_map(int hw_event
>  
>  static int p4_hw_config(struct perf_event *event)
>  {
> -	int cpu = raw_smp_processor_id();
> +	int cpu = get_cpu();
>  	u32 escr, cccr;
>  
>  	/*
> @@ -440,7 +440,7 @@ static int p4_hw_config(struct perf_even
>  		event->hw.config = p4_set_ht_bit(event->hw.config);
>  
>  	if (event->attr.type != PERF_TYPE_RAW)
> -		return 0;
> +		goto out;
>  
>  	/*
>  	 * We don't control raw events so it's up to the caller
> @@ -455,6 +455,8 @@ static int p4_hw_config(struct perf_even
>  		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
>  		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
>  
> +out:
> +	put_cpu();
>  	return 0;
>  }
>  
> @@ -741,7 +743,7 @@ static int p4_pmu_schedule_events(struct
>  {
>  	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
>  	unsigned long escr_mask[BITS_TO_LONGS(ARCH_P4_TOTAL_ESCR)];
> -	int cpu = raw_smp_processor_id();
> +	int cpu = get_cpu();
>  	struct hw_perf_event *hwc;
>  	struct p4_event_bind *bind;
>  	unsigned int i, thread, num;
> @@ -777,6 +779,7 @@ reserve:
>  	}
>  
>  done:
> +	put_cpu();
>  	return num ? -ENOSPC : 0;
>  }



That's no big deal. But I think the schedule_events() is called on
pmu::enable() time, when preemption is already disabled.

