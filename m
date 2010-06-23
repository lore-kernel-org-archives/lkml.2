Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab0FWBnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 21:43:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:6665 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab0FWBnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 21:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,464,1272870000"; 
   d="scan'208";a="810557158"
Subject: Re: [PATCH V2 3/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4C206EA0.3060101@redhat.com>
References: <1277112703.2096.511.camel@ymzhang.sh.intel.com>
	 <20100621135659.GL4689@redhat.com>
	 <1277185636.2096.675.camel@ymzhang.sh.intel.com>
	 <4C206EA0.3060101@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 23 Jun 2010 09:43:41 +0800
Message-Id: <1277257421.2096.758.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 11:04 +0300, Avi Kivity wrote:
> On 06/22/2010 08:47 AM, Zhang, Yanmin wrote:
> > On Mon, 2010-06-21 at 16:56 +0300, Gleb Natapov wrote:
> >    
> >> On Mon, Jun 21, 2010 at 05:31:43PM +0800, Zhang, Yanmin wrote:
> >>      
> >>> The 3rd patch is to implement para virt perf at host kernel.
> >>>
> >>> Signed-off-by: Zhang Yanmin<yanmin_zhang@linux.intel.com>
> >>>
> >>>        
> > <snip>
> >
> >    
> >>> +
> >>> +static void kvm_copy_event_to_guest(struct kvm_vcpu *vcpu,
> >>> +			struct perf_event *host_event)
> >>> +{
> >>> +	struct host_perf_shadow *shadow = host_event->host_perf_shadow;
> >>> +	struct guest_perf_event counter;
> >>> +	int ret;
> >>> +	s32 overflows;
> >>> +
> >>> +	ret = kvm_read_guest(vcpu->kvm, shadow->guest_event_addr,
> >>> +				&counter, sizeof(counter));
> >>> +	if (ret<  0)
> >>> +		return;
> >>> +
> >>> +again:
> >>> +	overflows = atomic_read(&shadow->counter.overflows);
> >>> +	if (atomic_cmpxchg(&shadow->counter.overflows, overflows, 0) !=
> >>> +			overflows)
> >>> +		goto again;
> >>> +
> >>> +	counter.count = shadow->counter.count;
> >>> +	atomic_add(overflows,&counter.overflows);
> >>> +
> >>> +	kvm_write_guest(vcpu->kvm,
> >>> +			shadow->guest_event_addr,
> >>> +			&counter,
> >>> +			sizeof(counter));
> >>>        
> >> Those kind of interfaces worry me since the can cause bugs that are
> >> very hard to catch.  What if guest enables some events and crashes into
> >> kdump kernel (or kexec new kernel) without reseting HW. Now host may
> >> write over guest memory without guest expecting it. Do you handle this
> >> scenario in a guest side? I think you need to register reboot notify
> >> and disable events from there.
> >>      
> > Sorry for missing your comments.
> >
> > My patch could take care of dead guest os by cleaning up all events in function
> > kvm_arch_destroy_vm, so all events are closed if host user kills the guest
> > qemu process.
> >
> >    
> 
> A reset does not involve destroying a vm; you have to clean up as part 
> of the rest process.
What does 'reset' here mean? Is it a reboot or halt? If it's a halt, it involves
destroying a vm. If a host user just kills the qemu process, is it a reset involving
destroying a vm?

> 
> Note MSRs are automatically cleared, so that's something in favour of an 
> MSR interface.
> 
> > As for your scenario, I will register reboot notify and add a new pv perf
> > hypercall interface to vmexit to host kernel to do cleanup.
> >    
> 
> You aren't guaranteed a reboot notifier will be called.  On the other 
> hand, we need a kexec handler.
ordinary kexec calls all reboot notifiers. Only crash kexec doesn't call them.
I will implement a machine_ops.crash_shutdown callback.


