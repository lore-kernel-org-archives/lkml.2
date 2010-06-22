Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab0FVCIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 22:08:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:11584 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab0FVCIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 22:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,457,1272870000"; 
   d="scan'208";a="291440706"
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
       tim.c.chen@intel.com
In-Reply-To: <4C1F5452.3000107@redhat.com>
References: <1277112686.2096.510.camel@ymzhang.sh.intel.com>
	 <4C1F5452.3000107@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 22 Jun 2010 10:08:30 +0800
Message-Id: <1277172510.2096.585.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 15:00 +0300, Avi Kivity wrote:
> On 06/21/2010 12:31 PM, Zhang, Yanmin wrote:
> > The 2nd patch is to change the definition of perf_event to facilitate
> > perf attr copy when a hypercall happens.
> >
> > Signed-off-by: Zhang Yanmin<yanmin_zhang@linux.intel.com>
> >
> > ---
> >
> > --- linux-2.6_tip0620/include/linux/perf_event.h	2010-06-21 15:19:52.821999849 +0800
> > +++ linux-2.6_tip0620perfkvm/include/linux/perf_event.h	2010-06-21 16:53:49.283999849 +0800
> > @@ -188,7 +188,10 @@ struct perf_event_attr {
> >   	__u64			sample_type;
> >   	__u64			read_format;
> >
> >    
> 
> Assuming these flags are available to the guest?
These flags are used by generic perf codes. To match with host kernel, we wish
guest os also use the flags.

> 
> > -	__u64			disabled       :  1, /* off by default        */
> > +	union {
> > +		__u64		flags;
> > +		struct {
> > +			__u64	disabled       :  1, /* off by default        */
> >   				inherit	       :  1, /* children inherit it   */
> >    
> 
> inherit is meaningless for a guest.
Right. host kernel will reset it to 0 before create perf_event for guest os.
Here we couldn't delete the flag as it's used by perf generic codes.
I need separate the patch a little better. All definitions in include/linux/perf_event.h
are mostly perf generic code related. I'm very careful to change it.

> 
> >   				pinned	       :  1, /* must always be on PMU */
> >    
> 
> We cannot allow a guest to pin a counter.
Ok. I will reset it in function kvm_pv_perf_op_open.

> 
> The other flags are also problematic.  I'd like to see virt-specific 
> flags (probably we'll only need kernel/user and nested_hv for nested 
> virtualization).
How about to add more comments around struct guest_perf_attr->flags that
guest os developers should take a look at include/linux/perf_event.h?
BTW, I will reset more flags to 0 in kvm_pv_perf_op_open.

> 
> Something that is worrying is that we don't expose group information.  
> perf will multiplex the events for us, but there will be a loss in accuracy.
> 
> >   #ifdef CONFIG_HAVE_HW_BREAKPOINT
> >   #include<asm/hw_breakpoint.h>
> >   #endif
> > @@ -753,6 +752,20 @@ struct perf_event {
> >
> >   	perf_overflow_handler_t		overflow_handler;
> >
> > +	/*
> > +	 * pointers used by kvm perf paravirt interface.
> > +	 *
> > +	 * 1) Used in host kernel and points to host_perf_shadow which
> > +	 * has information about guest perf_event
> > +	 */
> > +	void				*host_perf_shadow;
> >    
> 
> Can we have real types instead of void pointers?
I just want perf generic codes have less dependency on KVM codes.

> 
> > +	/*
> > +	 * 2) Used in guest kernel and points to guest_perf_shadow which
> > +	 * is used as a communication area with host kernel. Host kernel
> > +	 * copies overflow data to it when an event overflows.
> > +	 */
> > +	void				*guest_perf_shadow;
> >    
> 
> It's strange to see both guest and host parts in the same patch.  
> Splitting to separate patches will really help review.
It's a little hard to split the patches if they change the same file. Perhaps
I could add more statements before the patch when I send it out.

> 
> > @@ -1626,9 +1629,22 @@ void perf_event_task_tick(struct task_st
> >   	if (ctx&&  ctx->nr_events&&  ctx->nr_events != ctx->nr_active)
> >   		rotate = 1;
> >
> > -	perf_ctx_adjust_freq(&cpuctx->ctx);
> > -	if (ctx)
> > -		perf_ctx_adjust_freq(ctx);
> > +#ifdef CONFIG_KVM_PERF
> > +	if (kvm_para_available()) {
> > +		/*
> > +		 * perf_ctx_adjust_freq causes lots of pmu->read which would
> > +		 * trigger too many vmexit to host kernel. We disable it
> > +		 * under para virt situation
> > +		 */
> > +		adjust_freq = 0;
> > +	}
> > +#endif
> >    
> 
> Perhaps we can have a batch read interface which will read many counters 
> at once.
It's a good idea. But that will touch many perf generic codes which causes it's hard
to maintain or follow future changes.

>   This would reduce the number of exits.  Also adjust the 
> frequency less frequently.
Here it depends on process scheduler frequency, CONFIG_HZ. 

> 
> > +
> > +	if (adjust_freq) {
> > +		perf_ctx_adjust_freq(&cpuctx->ctx);
> > +		if (ctx)
> > +			perf_ctx_adjust_freq(ctx);
> > +	}
> >
> >    
> 


