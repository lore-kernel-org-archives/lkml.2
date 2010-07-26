Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0GZRTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 13:19:44 -0400
Received: from claw.goop.org ([74.207.240.146]:49514 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab0GZRTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 13:19:43 -0400
Message-ID: <4C4DC3AD.7010404@goop.org>
Date: Mon, 26 Jul 2010 10:19:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: avi@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        npiggin@suse.de, kvm@vger.kernel.org, bharata@in.ibm.com,
        Balbir Singh <balbir@in.ibm.com>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 2/4] Add yield hypercall for KVM guests
References: <20100726061150.GB21699@linux.vnet.ibm.com> <20100726061445.GB8402@linux.vnet.ibm.com>
In-Reply-To: <20100726061445.GB8402@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/25/2010 11:14 PM, Srivatsa Vaddagiri wrote:
> Add KVM hypercall for yielding vcpu timeslice.

Can you do a directed yield?

     J

> Signed-off-by: Srivatsa Vaddagiri<vatsa@linux.vnet.ibm.com>
>
> ---
>   arch/x86/include/asm/kvm_para.h |    1 +
>   arch/x86/kvm/x86.c              |    7 ++++++-
>   include/linux/kvm.h             |    1 +
>   include/linux/kvm_para.h        |    1 +
>   4 files changed, 9 insertions(+), 1 deletion(-)
>
> Index: current/arch/x86/include/asm/kvm_para.h
> ===================================================================
> --- current.orig/arch/x86/include/asm/kvm_para.h
> +++ current/arch/x86/include/asm/kvm_para.h
> @@ -16,6 +16,7 @@
>   #define KVM_FEATURE_CLOCKSOURCE		0
>   #define KVM_FEATURE_NOP_IO_DELAY	1
>   #define KVM_FEATURE_MMU_OP		2
> +#define KVM_FEATURE_YIELD		4
>   /* This indicates that the new set of kvmclock msrs
>    * are available. The use of 0x11 and 0x12 is deprecated
>    */
> Index: current/arch/x86/kvm/x86.c
> ===================================================================
> --- current.orig/arch/x86/kvm/x86.c
> +++ current/arch/x86/kvm/x86.c
> @@ -1618,6 +1618,7 @@ int kvm_dev_ioctl_check_extension(long e
>   	case KVM_CAP_PCI_SEGMENT:
>   	case KVM_CAP_DEBUGREGS:
>   	case KVM_CAP_X86_ROBUST_SINGLESTEP:
> +	case KVM_CAP_YIELD_HYPERCALL:
>   		r = 1;
>   		break;
>   	case KVM_CAP_COALESCED_MMIO:
> @@ -1993,7 +1994,8 @@ static void do_cpuid_ent(struct kvm_cpui
>   		entry->eax = (1<<  KVM_FEATURE_CLOCKSOURCE) |
>   			     (1<<  KVM_FEATURE_NOP_IO_DELAY) |
>   			     (1<<  KVM_FEATURE_CLOCKSOURCE2) |
> -			     (1<<  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
> +			     (1<<  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
> +			     (1<<  KVM_FEATURE_YIELD);
>   		entry->ebx = 0;
>   		entry->ecx = 0;
>   		entry->edx = 0;
> @@ -4245,6 +4247,9 @@ int kvm_emulate_hypercall(struct kvm_vcp
>   	case KVM_HC_MMU_OP:
>   		r = kvm_pv_mmu_op(vcpu, a0, hc_gpa(vcpu, a1, a2),&ret);
>   		break;
> +	case KVM_HC_YIELD:
> +		ret = 0;
> +		yield();
>   	default:
>   		ret = -KVM_ENOSYS;
>   		break;
> Index: current/include/linux/kvm.h
> ===================================================================
> --- current.orig/include/linux/kvm.h
> +++ current/include/linux/kvm.h
> @@ -524,6 +524,7 @@ struct kvm_enable_cap {
>   #define KVM_CAP_PPC_OSI 52
>   #define KVM_CAP_PPC_UNSET_IRQ 53
>   #define KVM_CAP_ENABLE_CAP 54
> +#define KVM_CAP_YIELD_HYPERCALL	55
>
>   #ifdef KVM_CAP_IRQ_ROUTING
>
> Index: current/include/linux/kvm_para.h
> ===================================================================
> --- current.orig/include/linux/kvm_para.h
> +++ current/include/linux/kvm_para.h
> @@ -17,6 +17,7 @@
>
>   #define KVM_HC_VAPIC_POLL_IRQ		1
>   #define KVM_HC_MMU_OP			2
> +#define KVM_HC_YIELD                    3
>
>   /*
>    * hypercalls use architecture specific
>

