Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1FSJ6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 05:58:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab1FSJ6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 05:58:12 -0400
Message-ID: <4DFDC821.2090905@redhat.com>
Date: Sun, 19 Jun 2011 12:57:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v2 3/7] KVM-HV: KVM Steal time implementation
References: <1308262856-5779-1-git-send-email-glommer@redhat.com> <1308262856-5779-4-git-send-email-glommer@redhat.com>
In-Reply-To: <1308262856-5779-4-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 01:20 AM, Glauber Costa wrote:
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
>
> +#define KVM_STEAL_ALIGNMENT_BITS 5
> +#define KVM_STEAL_VALID_BITS ((-1ULL<<  (KVM_STEAL_ALIGNMENT_BITS + 1)))
> +#define KVM_STEAL_RESERVED_MASK (((1<<  KVM_STEAL_ALIGNMENT_BITS) - 1 )<<  1)

Clumsy, but okay.

> +static void record_steal_time(struct kvm_vcpu *vcpu)
> +{
> +	u64 delta;
> +
> +	if (vcpu->arch.st.stime&&  vcpu->arch.st.this_time_out) {

0 is a valid value for stime.

> +
> +		if (unlikely(kvm_read_guest(vcpu->kvm, vcpu->arch.st.stime,
> +			&vcpu->arch.st.steal, sizeof(struct kvm_steal_time)))) {
> +
> +			vcpu->arch.st.stime = 0;
> +			return;
> +		}
> +
> +		delta = (get_kernel_ns() - vcpu->arch.st.this_time_out);
> +
> +		vcpu->arch.st.steal.steal += delta;
> +		vcpu->arch.st.steal.version += 2;
> +
> +		if (unlikely(kvm_write_guest(vcpu->kvm, vcpu->arch.st.stime,
> +			&vcpu->arch.st.steal, sizeof(struct kvm_steal_time)))) {
> +
> +			vcpu->arch.st.stime = 0;
> +			return;
> +		}
> +	}
> +
> +}
> +
>
> @@ -2158,6 +2206,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   			kvm_migrate_timers(vcpu);
>   		vcpu->cpu = cpu;
>   	}
> +
> +	record_steal_time(vcpu);
>   }

This records time spent in userspace in the vcpu thread as steal time.  
Is this what we want?  Or just time preempted away?


-- 
error compiling committee.c: too many arguments to function

