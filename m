Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab0HIUC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:02:56 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52964 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab0HIUCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:02:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vDqflKEOi0S/TYNRP189zqH3s8PeqXLcHpcTCsBWEqjvmQZX5dxM14Sr6aetUzMY53
         49sMo9ucy63NVUWulk1QTxSvkByb0PSRFCZt3q9nmcRCIc4Wvz7AbYgJk8FY+eAGcfcq
         y/K2U5MplqecoR7lf79MPS49N9HZ287T5f3Ek=
Date: Tue, 10 Aug 2010 00:02:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100809200245.GF6056@lenovo>
References: <20100804151858.GB5130@lenovo> <20100804155002.GS3353@redhat.com> <20100804161046.GC5130@lenovo> <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo> <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809194829.GB26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 09:48:29PM +0200, Robert Richter wrote:
> On 06.08.10 10:21:31, Don Zickus wrote:
> > On Fri, Aug 06, 2010 at 08:52:03AM +0200, Robert Richter wrote:
> 
> > > I was playing around with it yesterday trying to fix this. My idea is
> > > to skip an unkown nmi if the privious nmi was a *handled* perfctr
> > 
> > You might want to add a little more logic that says *handled* _and_ had
> > more than one perfctr trigger.  Most of the time only one perfctr is
> > probably triggering, so you might be eating unknown_nmi's needlessly.
> > 
> > Just a thought.
> 
> Yes, that's true. It could be implemented on top of the patch below.
> 
> > 
> > > nmi. I will probably post an rfc patch early next week.
> 
> Here it comes:
> 

Thanks Robert! Looks good to me, one nit below.

> From d2739578199d881ae6a9537c1b96a0efd1cdea43 Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Thu, 5 Aug 2010 16:19:59 +0200
> Subject: [PATCH] perf, x86: try to handle unknown nmis with running perfctrs
>
... 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index f2da20f..c3cd159 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1200,12 +1200,16 @@ void perf_events_lapic_init(void)
>  	apic_write(APIC_LVTPC, APIC_DM_NMI);
>  }
>  
> +static DEFINE_PER_CPU(unsigned int, perfctr_handled);
> +
>  static int __kprobes
>  perf_event_nmi_handler(struct notifier_block *self,
>  			 unsigned long cmd, void *__args)
>  {
>  	struct die_args *args = __args;
>  	struct pt_regs *regs;
> +	unsigned int this_nmi;
> +	unsigned int prev_nmi;
>  
>  	if (!atomic_read(&active_events))
>  		return NOTIFY_DONE;
> @@ -1214,7 +1218,26 @@ perf_event_nmi_handler(struct notifier_block *self,
>  	case DIE_NMI:
>  	case DIE_NMI_IPI:
>  		break;
> -
> +	case DIE_NMIUNKNOWN:
> +		/*
> +		 * This one could be our NMI, two events could trigger
> +		 * 'simultaneously' raising two back-to-back NMIs. If
> +		 * the first NMI handles both, the latter will be
> +		 * empty and daze the CPU.
> +		 *
> +		 * So, we drop this unknown NMI if the previous NMI
> +		 * was handling a perfctr. Otherwise we pass it and
> +		 * let the kernel handle the unknown nmi.
> +		 *
> +		 * Note: this could be improved if we drop unknown
> +		 * NMIs only if we handled more than one perfctr in
> +		 * the previous NMI.
> +		 */
> +		this_nmi = percpu_read(irq_stat.__nmi_count);
> +		prev_nmi = __get_cpu_var(perfctr_handled);
> +		if (this_nmi == prev_nmi + 1)
> +			return NOTIFY_STOP;
> +		return NOTIFY_DONE;
>  	default:
>  		return NOTIFY_DONE;
>  	}
> @@ -1222,14 +1245,12 @@ perf_event_nmi_handler(struct notifier_block *self,
>  	regs = args->regs;
>  
>  	apic_write(APIC_LVTPC, APIC_DM_NMI);

If only I'm not missing something this apic_write should go up to
"case DIE_NMIUNKNOWN" site, no?

	-- Cyrill
