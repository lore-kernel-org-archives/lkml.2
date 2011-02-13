Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1BMPNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:13:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab1BMPNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:13:19 -0500
Message-ID: <4D57F4CE.2090804@redhat.com>
Date: Sun, 13 Feb 2011 17:12:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 6/6] KVM: X86: Implement userspace interface to set virtual_tsc_khz
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com> <1297272584-22689-7-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1297272584-22689-7-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 07:29 PM, Joerg Roedel wrote:
> This patch implements two new vm-ioctls to get and set the
> virtual_tsc_khz if the machine supports tsc-scaling. Setting
> the tsc-frequency is only possible before userspace creates
> any vcpu.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/include/asm/kvm_host.h |    1 +
>   arch/x86/kvm/svm.c              |    3 +++
>   arch/x86/kvm/x86.c              |   38 ++++++++++++++++++++++++++++++++++++++
>   include/linux/kvm.h             |    4 ++++
>   4 files changed, 46 insertions(+), 0 deletions(-)
>

Documentation/kvm/api.txt +++++++++++++

> @@ -633,6 +633,7 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
>   u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
>
>   extern bool tdp_enabled;
> +extern int kvm_has_tsc_control;

bool


> +	case KVM_SET_TSC_KHZ: {
> +		u32 user_tsc_khz;
> +
> +		if (!kvm_has_tsc_control)
> +			break;
> +
> +		/*
> +		 * We force the tsc frequency to be set before any
> +		 * vcpu is created
> +		 */
> +		if (atomic_read(&kvm->online_vcpus)>  0)
> +			goto out;

What if a vcpu is created here?  No locking AFAICS.

> +
> +		user_tsc_khz = arg;
> +
> +		kvm_arch_set_tsc_khz(kvm, user_tsc_khz);
> +

Error check for impossible values (0, values the tsc multiplier can't 
reach)?

> +		r = 0;
> +		goto out;
> +	}
> +	case KVM_GET_TSC_KHZ: {
> +
> +		if (!kvm_has_tsc_control)
> +			break;
> +
> +		r = -EFAULT;
> +		if (copy_to_user(argp,&kvm->arch.virtual_tsc_khz, sizeof(__u32)))
> +			goto out;

Should be the return value, no?

> +
> +		r = 0;
> +		goto out;
> +	}
>
>   	default:
>   		;
>
>
> @@ -677,6 +678,9 @@ struct kvm_clock_data {
>   #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
>   /* Available with KVM_CAP_PPC_GET_PVINFO */
>   #define KVM_PPC_GET_PVINFO	  _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
> +/* Available with KVM_CAP_TSC_CONTROL */
> +#define KVM_SET_TSC_KHZ           _IOW(KVMIO,  0xa2, __u32)
> +#define KVM_GET_TSC_KHZ           _IOR(KVMIO,  0xa3, __u32)
>   

_IO() - use arg or return value
_IOW/_IOR - copy_to/from_user()

pick one, but don't mix.

-- 
error compiling committee.c: too many arguments to function

