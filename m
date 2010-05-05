Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537Ab0EEIXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 04:23:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab0EEIXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:23:31 -0400
Message-ID: <4BE12B00.803@redhat.com>
Date: Wed, 05 May 2010 11:23:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zamsden@redhat.com
Subject: Re: [PATCH v2 4/7] export paravirtual cpuid flags in KVM_GET_SUPPORTED_CPUID
References: <1272901927-829-1-git-send-email-glommer@redhat.com> <1272901927-829-2-git-send-email-glommer@redhat.com> <1272901927-829-3-git-send-email-glommer@redhat.com> <1272901927-829-4-git-send-email-glommer@redhat.com> <1272901927-829-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1272901927-829-5-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 06:52 PM, Glauber Costa wrote:
> Right now, we were using individual KVM_CAP entities to communicate
> userspace about which cpuids we support. This is suboptimal, since it
> generates a delay between the feature arriving in the host, and
> being available at the guest.
>
> A much better mechanism is to list para features in KVM_GET_SUPPORTED_CPUID.
> This makes userspace automatically aware of what we provide. And if we
> ever add a new cpuid bit in the future, we have to do that again,
> which create some complexity and delay in feature adoption.
>
> Signed-off-by: Glauber Costa<glommer@redhat.com>
> ---
>   arch/x86/include/asm/kvm_para.h |    4 ++++
>   arch/x86/kvm/x86.c              |   27 +++++++++++++++++++++++++++
>   2 files changed, 31 insertions(+), 0 deletions(-)
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

Separate patch.

>
>   #define MSR_KVM_WALL_CLOCK  0x11
>   #define MSR_KVM_SYSTEM_TIME 0x12
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb84947..8a7cdda 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1971,6 +1971,20 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>   		}
>   		break;
>   	}
> +	case 0x40000000: {
>    

Use symbolic name, please.

> +		char signature[] = "KVMKVMKVM";
> +		u32 *sigptr = (u32 *)signature;
> +		entry->eax = 1;
>    

Where did this come from?

> +		entry->ebx = sigptr[0];
> +		entry->ecx = sigptr[1];
> +		entry->edx = sigptr[2];
>    

Overflow, you're reading 12 bytes from a 10-byte variable.

> +		break;
> +	}
> +	case 0x40000001:
> +		entry->eax = (1<<  KVM_FEATURE_CLOCKSOURCE) |
> +		(1<<  KVM_FEATURE_NOP_IO_DELAY) |
> +		(1<<  KVM_FEATURE_CLOCKSOURCE2);
>    

Indentation...

Also, have to initialize all fields, since the real cpu won't initialize 
them for you.

Sidenote: the real cpu may be a kvm vcpu, so it may in fact support 
those features.

> +		break;
>   	case 0x80000000:
>   		entry->eax = min(entry->eax, 0x8000001a);
>   		break;
> @@ -2017,6 +2031,19 @@ static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
>   	for (func = 0x80000001; func<= limit&&  nent<  cpuid->nent; ++func)
>   		do_cpuid_ent(&cpuid_entries[nent], func, 0,
>   			&nent, cpuid->nent);
> +
> +	
> +
> +	r = -E2BIG;
> +	if (nent>= cpuid->nent)
> +		goto out_free;
> +
> +	do_cpuid_ent(&cpuid_entries[nent], 0x40000000, 0,&nent, cpuid->nent);
> +	limit = cpuid_entries[nent - 1].eax;
>    

The kvm cpuid does not follow the limit thing.

> +	for (func = 0x40000001; func<= limit&&  nent<  cpuid->nent; ++func)
> +		do_cpuid_ent(&cpuid_entries[nent], func, 0,
> +			&nent, cpuid->nent);
> +
>   	r = -E2BIG;
>    

To avoid confusion, please write Documentation/kvm/cpuid.txt based on 
the current qemu-kvm code, and implement this patch according to the 
documentation.

-- 
error compiling committee.c: too many arguments to function

