Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab0FVJZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:25:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:21678 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759094Ab0FVJZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:25:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,459,1272870000"; 
   d="scan'208";a="810247417"
Subject: Re: [PATCH V2 2/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4C207E63.5010504@redhat.com>
References: <1277112686.2096.510.camel@ymzhang.sh.intel.com>
	 <4C1F5452.3000107@redhat.com>
	 <1277172510.2096.585.camel@ymzhang.sh.intel.com>
	 <4C207E63.5010504@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 22 Jun 2010 17:25:52 +0800
Message-Id: <1277198752.2096.721.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 12:12 +0300, Avi Kivity wrote:
> On 06/22/2010 05:08 AM, Zhang, Yanmin wrote:
> >
> >> Something that is worrying is that we don't expose group information.
> >> perf will multiplex the events for us, but there will be a loss in accuracy.
> >>
> >>      
> >>>    #ifdef CONFIG_HAVE_HW_BREAKPOINT
> >>>    #include<asm/hw_breakpoint.h>
> >>>    #endif
> >>> @@ -753,6 +752,20 @@ struct perf_event {
> >>>
> >>>    	perf_overflow_handler_t		overflow_handler;
> >>>
> >>> +	/*
> >>> +	 * pointers used by kvm perf paravirt interface.
> >>> +	 *
> >>> +	 * 1) Used in host kernel and points to host_perf_shadow which
> >>> +	 * has information about guest perf_event
> >>> +	 */
> >>> +	void				*host_perf_shadow;
> >>>
> >>>        
> >> Can we have real types instead of void pointers?
> >>      
> > I just want perf generic codes have less dependency on KVM codes.
> >    
> 
> One way to do that and retain type safety is to have
> 
>      struct perf_client {
>            struct perf_client_ops *ops;
>            ...
>      }
> 
> The client (kvm) can do
> 
>     struct kvm_perf_client {
>           struct perf_client pc;
>           // kvm specific stuff
>     };
> 
> the callbacks receive struct perf_client and use container_of to reach 
> the kvm_perf_client that contains it.
Let me double check it.

> 
> >>> +	/*
> >>> +	 * 2) Used in guest kernel and points to guest_perf_shadow which
> >>> +	 * is used as a communication area with host kernel. Host kernel
> >>> +	 * copies overflow data to it when an event overflows.
> >>> +	 */
> >>> +	void				*guest_perf_shadow;
> >>>
> >>>        
> >> It's strange to see both guest and host parts in the same patch.
> >> Splitting to separate patches will really help review.
> >>      
> > It's a little hard to split the patches if they change the same file. Perhaps
> > I could add more statements before the patch when I send it out.
> >    
> 
> With git, it's easy (once you're used to it):
> 
>    # go back one commit:
>    git reset HEAD^
>    # selectively add bits:
>    git add -p
>    # commit first patch
>    git commit -s
>    # selectively add bits:
>    git add -p
>    # commit second patch
>    git commit -s
Thanks for your teaching.

> 
> 
> >>> @@ -1626,9 +1629,22 @@ void perf_event_task_tick(struct task_st
> >>>    	if (ctx&&   ctx->nr_events&&   ctx->nr_events != ctx->nr_active)
> >>>    		rotate = 1;
> >>>
> >>> -	perf_ctx_adjust_freq(&cpuctx->ctx);
> >>> -	if (ctx)
> >>> -		perf_ctx_adjust_freq(ctx);
> >>> +#ifdef CONFIG_KVM_PERF
> >>> +	if (kvm_para_available()) {
> >>> +		/*
> >>> +		 * perf_ctx_adjust_freq causes lots of pmu->read which would
> >>> +		 * trigger too many vmexit to host kernel. We disable it
> >>> +		 * under para virt situation
> >>> +		 */
> >>> +		adjust_freq = 0;
> >>> +	}
> >>> +#endif
> >>>
> >>>        
> >> Perhaps we can have a batch read interface which will read many counters
> >> at once.
> >>      
> > It's a good idea. But that will touch many perf generic codes which causes it's hard
> > to maintain or follow future changes.
> >    
> 
> I'm talking about the guest/host interface.  So you have one vmexit and 
> many host perf calls.
I understood what you were speaking. I mean, perf generic codes operate perf_event
one by one. At low layer, we just know one perf_event before calling hypercall to
vmexit to host kernel.



