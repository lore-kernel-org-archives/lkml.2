Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0EKI3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:29:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0EKI3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:29:10 -0400
Message-ID: <4BE91554.2030503@redhat.com>
Date: Tue, 11 May 2010 11:29:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zamsden@redhat.com
Subject: Re: [PATCH v3 5/8] export paravirtual cpuid flags in KVM_GET_SUPPORTED_CPUID
References: <1273094839-18655-1-git-send-email-glommer@redhat.com> <1273094839-18655-2-git-send-email-glommer@redhat.com> <1273094839-18655-3-git-send-email-glommer@redhat.com> <1273094839-18655-4-git-send-email-glommer@redhat.com> <1273094839-18655-5-git-send-email-glommer@redhat.com> <1273094839-18655-6-git-send-email-glommer@redhat.com>
In-Reply-To: <1273094839-18655-6-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 12:27 AM, Glauber Costa wrote:
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
>
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1971,6 +1971,23 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>   		}
>   		break;
>   	}
> +	case KVM_CPUID_SIGNATURE: {
> +		char signature[12] = "KVMKVMKVM\0\0";
> +		u32 *sigptr = (u32 *)signature;
> +		entry->eax = 1;
>    

Don't understand where the value for eax comes from.  qemu-kvm-x86.c has 0.

> @@ -2017,6 +2034,19 @@ static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
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
> +	do_cpuid_ent(&cpuid_entries[nent], KVM_CPUID_SIGNATURE, 0,&nent,
> +		     cpuid->nent);
>    

Need a check here too, or the next call can overflow.  Would have been 
better to make do_cpuid_ent() check and return an error.

> +
> +	do_cpuid_ent(&cpuid_entries[nent], KVM_CPUID_FEATURES, 0,&nent,
> +		     cpuid->nent);
> +
>   	r = -E2BIG;
>   	if (nent>= cpuid->nent)
>   		goto out_free;
>    


-- 
error compiling committee.c: too many arguments to function

