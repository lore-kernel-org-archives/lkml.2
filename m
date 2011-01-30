Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1A3NN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 08:13:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab1A3NN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 08:13:27 -0500
Message-ID: <4D4563EB.3000203@redhat.com>
Date: Sun, 30 Jan 2011 15:13:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 2/6] KVM-HV: KVM Steal time implementation
References: <1296244340-15173-1-git-send-email-glommer@redhat.com> <1296244340-15173-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1296244340-15173-3-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2011 09:52 PM, Glauber Costa wrote:
> To implement steal time, we need the hypervisor to pass the guest information
> about how much time was spent running other processes outside the VM.
> This is per-vcpu, and using the kvmclock structure for that is an abuse
> we decided not to make.
>
> In this patchset, I am introducing a new msr, KVM_MSR_STEAL_TIME, that
> holds the memory area address containing information about steal time
>
> This patch contains the hypervisor part for it. I am keeping it separate from
> the headers to facilitate backports to people who wants to backport the kernel
> part but not the hypervisor, or the other way around.
>
>
> @@ -1528,16 +1528,23 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>   		vcpu->arch.time_page =
>   				gfn_to_page(vcpu->kvm, data>>  PAGE_SHIFT);
>
> -		if (is_error_page(vcpu->arch.time_page)) {
> -			kvm_release_page_clean(vcpu->arch.time_page);
> -			vcpu->arch.time_page = NULL;
> -		}
>   		break;
>   	}

Unrelated?

> @@ -2106,6 +2120,25 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   			kvm_migrate_timers(vcpu);
>   		vcpu->cpu = cpu;
>   	}
> +
> +	if (vcpu->arch.this_time_out) {
> +		u64 to = (get_kernel_ns() - vcpu->arch.this_time_out);
> +		/*
> +		 * using nanoseconds introduces noise, which accumulates easily
> +		 * leading to big steal time values. We want, however, to keep the
> +		 * interface nanosecond-based for future-proofness.
> +		 */
> +		to /= NSEC_PER_USEC;
> +		to *= NSEC_PER_USEC;

Seems there is a real problem and that this is just papering it over.  
I'd like to understand the root cause.

> +		vcpu->arch.time_out += to;
> +		kvm_write_guest(vcpu->kvm, (gpa_t)&st->steal,
> +				&vcpu->arch.time_out, sizeof(st->steal));

Error check.

> +		vcpu->arch.sversion += 2;

Doesn't survive live migration.  You need to use the version from the 
guest area.

> +		kvm_write_guest(vcpu->kvm, (gpa_t)&st->version,
> +				&vcpu->arch.sversion, sizeof(st->version));
> +		/* is it possible to have 2 loads in sequence? */
> +		vcpu->arch.this_time_out = 0;
> +	}
>   }
>

-- 
error compiling committee.c: too many arguments to function

