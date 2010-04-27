Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab0D0SMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:12:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab0D0SMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:12:51 -0400
Message-ID: <4BD7291F.6010809@redhat.com>
Date: Tue, 27 Apr 2010 21:12:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] export new cpuid KVM_CAP
References: <1272303988-21929-1-git-send-email-glommer@redhat.com> <1272303988-21929-2-git-send-email-glommer@redhat.com> <1272303988-21929-3-git-send-email-glommer@redhat.com> <1272303988-21929-4-git-send-email-glommer@redhat.com> <1272303988-21929-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1272303988-21929-5-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 08:46 PM, Glauber Costa wrote:
> Since we're changing the msrs kvmclock uses, we have to communicate
> that to the guest, through cpuid. We can add a new KVM_CAP to the
> hypervisor, and then patch userspace to recognize it.
>
> And if we ever add a new cpuid bit in the future, we have to do that again,
> which create some complexity and delay in feature adoption.
>
> Instead, what I'm proposing in this patch is a new capability, called
> KVM_CAP_X86_CPUID_FEATURE_LIST, that returns the current feature list
> currently supported by the hypervisor. If we ever want to add or remove
> some feature, we only need to tweak into the HV, leaving userspace untouched.
>
> Signed-off-by: Glauber Costa<glommer@redhat.com>
> ---
>   arch/x86/include/asm/kvm_para.h |    4 ++++
>   arch/x86/kvm/x86.c              |    6 ++++++
>   include/linux/kvm.h             |    1 +
>   3 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 9734808..f019f8c 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -16,6 +16,10 @@
>   #define KVM_FEATURE_CLOCKSOURCE		0
>   #define KVM_FEATURE_NOP_IO_DELAY	1
>   #define KVM_FEATURE_MMU_OP		2
> +/* This indicates that the new set of kvmclock msrs
> + * are available. The use of 0x11 and 0x12 is deprecated
> + */
> +#define KVM_FEATURE_CLOCKSOURCE2        3
>    

Please document this in Documentation/kvm/cpuid.txt (also /msr.txt).

>
>   #define MSR_KVM_WALL_CLOCK  0x11
>   #define MSR_KVM_SYSTEM_TIME 0x12
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a2ead7f..04f04aa 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1545,6 +1545,12 @@ int kvm_dev_ioctl_check_extension(long ext)
>   	case KVM_CAP_MCE:
>   		r = KVM_MAX_MCE_BANKS;
>   		break;
> +	case KVM_CAP_X86_CPUID_FEATURE_LIST:
> +		r = (1<<  KVM_FEATURE_CLOCKSOURCE) |
> +		(1<<  KVM_FEATURE_NOP_IO_DELAY) |
> +		(1<<  KVM_FEATURE_MMU_OP) |
> +		(1<<  KVM_FEATURE_CLOCKSOURCE2);
> +		break;
>   	default:
>   		r = 0;
>   		break;
>    

Hmm.  We already have an API to get cpuid bits: 
KVM_GET_SUPPORTED_CPUID2.  The nice thing about it is that it will mean 
-cpu host will work out of the box.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

