Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0DNJnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:43:47 -0400
Received: from mga05.intel.com ([192.55.52.89]:12964 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754564Ab0DNJnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:43:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,203,1270450800"; 
   d="scan'208";a="789069878"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os statistics from host side
Date: Wed, 14 Apr 2010 17:43:32 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; x86_64; ; )
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <4BC588CF.5010507@redhat.com>
In-Reply-To: <4BC588CF.5010507@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004141743.32393.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 April 2010 17:20:15 Avi Kivity wrote:
> On 04/14/2030 12:05 PM, Zhang, Yanmin wrote:
> > Here is the new patch of V3 against tip/master of April 13th
> > if anyone wants to try it.
> 
> Thanks for persisting despite the flames.
> 
> Can you please separate arch/x86/kvm part of the patch?  That will make
> for easier reviewing, and will need to go through separate trees.
> 
> Sheng, did you make any progress with the NMI injection issue?

Yes, though some other works interrupt me lately...

The very first version has issue due to SELF_IPI mode can't be used to send 
NMI according to SDM. That's the reason why x2apic don't have way to do this.

But later I found another issue of fail to inspect inside the guest. I think 
it's due to NMI is asynchronous event, though it should be triggered very 
quickly, you can't guarantee that the handler would be triggered before the 
state(current_vcpu) is cleared with current code.

Maybe just extended the "guest state" region would be fine, if the latency is 
stable enough(though I think it maybe platform depended). I am working on this 
now. 

-- 
regards
Yang, Sheng

> 
> > +
> > diff -Nraup linux-2.6_tip0413/arch/x86/kvm/x86.c
> > linux-2.6_tip0413_perfkvm/arch/x86/kvm/x86.c ---
> > linux-2.6_tip0413/arch/x86/kvm/x86.c	2010-04-14 11:11:04.341042024 +0800
> > +++ linux-2.6_tip0413_perfkvm/arch/x86/kvm/x86.c	2010-04-14
> > 11:32:45.841278890 +0800 @@ -3765,6 +3765,35 @@ static void
> > kvm_timer_init(void)
> >   	}
> >   }
> >
> > +static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
> > +
> > +static int kvm_is_in_guest(void)
> > +{
> > +	return percpu_read(current_vcpu) != NULL;
> 
> An even more accurate way to determine this is to check whether the
> interrupt frame points back at the 'int $2' instruction.  However we
> plan to switch to a self-IPI method to inject the NMI, and I'm not sure
> wether APIC NMIs are accepted on an instruction boundary or whether
> there's some latency involved.
> 
> > +static unsigned long kvm_get_guest_ip(void)
> > +{
> > +	unsigned long ip = 0;
> > +	if (percpu_read(current_vcpu))
> > +		ip = kvm_rip_read(percpu_read(current_vcpu));
> > +	return ip;
> > +}
> 
> This may be racy.  kvm_rip_read() accesses a cache in memory; if we're
> in the process of updating the cache, then we may read a stale value.
> See below.
> 
> >   	trace_kvm_entry(vcpu->vcpu_id);
> > +
> > +	percpu_write(current_vcpu, vcpu);
> >   	kvm_x86_ops->run(vcpu);
> > +	percpu_write(current_vcpu, NULL);
> 
> If you move this around the 'int $2' instructions you will close the
> race, as a stray NMI won't catch us updating the rip cache.  But that
> depends on whether self-IPI is accepted on the next instruction or not.
> 
