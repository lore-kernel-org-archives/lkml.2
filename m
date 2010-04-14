Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0DNJUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:20:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab0DNJUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:20:35 -0400
Message-ID: <4BC588CF.5010507@redhat.com>
Date: Wed, 14 Apr 2010 12:20:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os statistics
 from host side
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com>
In-Reply-To: <1902387910.2078.435.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2030 12:05 PM, Zhang, Yanmin wrote:
> Here is the new patch of V3 against tip/master of April 13th
> if anyone wants to try it.
>
>    

Thanks for persisting despite the flames.

Can you please separate arch/x86/kvm part of the patch?  That will make 
for easier reviewing, and will need to go through separate trees.

Sheng, did you make any progress with the NMI injection issue?

> +
> diff -Nraup linux-2.6_tip0413/arch/x86/kvm/x86.c linux-2.6_tip0413_perfkvm/arch/x86/kvm/x86.c
> --- linux-2.6_tip0413/arch/x86/kvm/x86.c	2010-04-14 11:11:04.341042024 +0800
> +++ linux-2.6_tip0413_perfkvm/arch/x86/kvm/x86.c	2010-04-14 11:32:45.841278890 +0800
> @@ -3765,6 +3765,35 @@ static void kvm_timer_init(void)
>   	}
>   }
>
> +static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
> +
> +static int kvm_is_in_guest(void)
> +{
> +	return percpu_read(current_vcpu) != NULL;
>    

An even more accurate way to determine this is to check whether the 
interrupt frame points back at the 'int $2' instruction.  However we 
plan to switch to a self-IPI method to inject the NMI, and I'm not sure 
wether APIC NMIs are accepted on an instruction boundary or whether 
there's some latency involved.

> +static unsigned long kvm_get_guest_ip(void)
> +{
> +	unsigned long ip = 0;
> +	if (percpu_read(current_vcpu))
> +		ip = kvm_rip_read(percpu_read(current_vcpu));
> +	return ip;
> +}
>    

This may be racy.  kvm_rip_read() accesses a cache in memory; if we're 
in the process of updating the cache, then we may read a stale value.  
See below.

>
>   	trace_kvm_entry(vcpu->vcpu_id);
> +
> +	percpu_write(current_vcpu, vcpu);
>   	kvm_x86_ops->run(vcpu);
> +	percpu_write(current_vcpu, NULL);
>    

If you move this around the 'int $2' instructions you will close the 
race, as a stray NMI won't catch us updating the rip cache.  But that 
depends on whether self-IPI is accepted on the next instruction or not.


-- 
error compiling committee.c: too many arguments to function

