Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2ALOJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:09:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab2ALOJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:09:29 -0500
Message-ID: <4F0EE98D.1090704@redhat.com>
Date: Thu, 12 Jan 2012 16:09:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] kvm: set affinity hint for assigned device msi
References: <cover.1318358229.git.mst@redhat.com> <7458f62a58ad7d4022eefba4333336ba268e4ef9.1318358229.git.mst@redhat.com>
In-Reply-To: <7458f62a58ad7d4022eefba4333336ba268e4ef9.1318358229.git.mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 08:38 PM, Michael S. Tsirkin wrote:
> To forward an interrupt to a vcpu that runs on
> a host cpu different from the current one,
> we need an ipi which likely will cost us as much
> as delivering the interrupt directly to that cpu would.
>
> Set irq affinity hint to point there, irq balancer
> can then take this into accound and balance
> interrupts accordingly.
>
>  
> +static void kvm_vcpu_host_irq_hint(struct kvm_vcpu *vcpu, int host_irq)
> +{
> +	const struct cpumask *mask;
> +	/* raw_smp_processor_id() is ok here: if we get preempted we can get a
> +	 * wrong value but we don't mind much. */
> +	if (host_irq >= 0 && unlikely(vcpu->cpu != raw_smp_processor_id())) {
> +		mask = get_cpu_mask(vcpu->cpu);
> +		irq_set_affinity_hint(host_irq, mask);
> +	}
> +}
> +	
>  int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>  		struct kvm_lapic_irq *irq, int host_irq)
>  {
> @@ -102,6 +114,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>  			if (r < 0)
>  				r = 0;
>  			r += kvm_apic_set_irq(vcpu, irq);
> +			kvm_vcpu_host_irq_hint(vcpu, host_irq);

Doing this every time seems excessive.  How about doing it every N
interrupts?  We can even collect information about which vcpus were
targeted, and then use a mask instead of just one vcpu.

-- 
error compiling committee.c: too many arguments to function

