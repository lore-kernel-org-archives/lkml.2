Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab0DOBE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 21:04:57 -0400
Received: from mga06.intel.com ([134.134.136.21]:32915 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755890Ab0DOBE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 21:04:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,208,1270450800"; 
   d="scan'208";a="613252173"
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os
 statistics from host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <4BC588CF.5010507@redhat.com>
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com>
	 <4BC588CF.5010507@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 15 Apr 2030 09:04:39 +0800
Message-Id: <1902445479.2078.458.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 12:20 +0300, Avi Kivity wrote:
> On 04/14/2030 12:05 PM, Zhang, Yanmin wrote:
> > Here is the new patch of V3 against tip/master of April 13th
> > if anyone wants to try it.
> >
> >    
> 
> Thanks for persisting despite the flames.
> 
> Can you please separate arch/x86/kvm part of the patch?  That will make 
> for easier reviewing, and will need to go through separate trees.
I should do so definitely, and will do so in next version which also fixes
some issues pointed by Ingo.

> 
> Sheng, did you make any progress with the NMI injection issue?
> 
> > +
> > diff -Nraup linux-2.6_tip0413/arch/x86/kvm/x86.c linux-2.6_tip0413_perfkvm/arch/x86/kvm/x86.c
> > --- linux-2.6_tip0413/arch/x86/kvm/x86.c	2010-04-14 11:11:04.341042024 +0800
> > +++ linux-2.6_tip0413_perfkvm/arch/x86/kvm/x86.c	2010-04-14 11:32:45.841278890 +0800
> > @@ -3765,6 +3765,35 @@ static void kvm_timer_init(void)
> >   	}
> >   }
> >
> > +static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
> > +
> > +static int kvm_is_in_guest(void)
> > +{
> > +	return percpu_read(current_vcpu) != NULL;
> >    
> 
> An even more accurate way to determine this is to check whether the 
> interrupt frame points back at the 'int $2' instruction.  However we 
> plan to switch to a self-IPI method to inject the NMI, and I'm not sure 
> wether APIC NMIs are accepted on an instruction boundary or whether 
> there's some latency involved.
Yes. But the frame pointer checking seems a little complicated.

> 
> > +static unsigned long kvm_get_guest_ip(void)
> > +{
> > +	unsigned long ip = 0;
> > +	if (percpu_read(current_vcpu))
> > +		ip = kvm_rip_read(percpu_read(current_vcpu));
> > +	return ip;
> > +}
> >    
> 
> This may be racy.  kvm_rip_read() accesses a cache in memory; if we're 
> in the process of updating the cache, then we may read a stale value.  
> See below.
Right. The racy window seems too big.

> 
> >
> >   	trace_kvm_entry(vcpu->vcpu_id);
> > +
> > +	percpu_write(current_vcpu, vcpu);
> >   	kvm_x86_ops->run(vcpu);
> > +	percpu_write(current_vcpu, NULL);
> >    
> 
> If you move this around the 'int $2' instructions you will close the 
> race, as a stray NMI won't catch us updating the rip cache.  But that 
> depends on whether self-IPI is accepted on the next instruction or not.
Right. The kernel part has dependency on the self-IPI implementation.
I will move above percpu_write(current_vcpu, vcpu) (or a new wrapper function)
just around 'int $2'.

Sheng would find a solution on the self-IPI delivery. Let's separate my patch
and self-IPI as 2 issues as we don't know when the self-IPI delivery would be
resolved.

Thanks,
Yanmin


