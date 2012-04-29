Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2D2N0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 09:26:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab2D2N0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 09:26:10 -0400
Message-ID: <4F9D415B.7010103@redhat.com>
Date: Sun, 29 Apr 2012 16:25:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V6 1/5] kvm hypervisor : Add a hypercall to KVM hypervisor
 to support pv-ticketlocks
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com> <20120423095947.30893.84029.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120423095947.30893.84029.sendpatchset@codeblue.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 12:59 PM, Raghavendra K T wrote:
> From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>
> KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu out of halt state.
>     
> The presence of these hypercalls is indicated to guest via
> KVM_FEATURE_PV_UNHALT/KVM_CAP_PV_UNHALT.
>
>  #endif
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e216ba0..dad475b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -481,6 +481,10 @@ struct kvm_vcpu_arch {
>  		u64 length;
>  		u64 status;
>  	} osvw;
> +	/* pv related host specific info */
> +	struct {
> +		int pv_unhalted;
> +	} pv;
>  };

'bool'.  Or maybe push into vcpu->requests.

>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4044ce0..7fc9be6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2147,6 +2147,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_ASYNC_PF:
>  	case KVM_CAP_GET_TSC_KHZ:
>  	case KVM_CAP_PCI_2_3:
> +	case KVM_CAP_PV_UNHALT:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:

Redundant, since we can infer this from KVM_GET_SUPPORTED_CPUID.  But
please indicate this in the documentation.

>  
> +/*
> + * kvm_pv_kick_cpu_op:  Kick a vcpu.
> + *
> + * @apicid - apicid of vcpu to be kicked.
> + */
> +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
> +{
> +	struct kvm_vcpu *vcpu = NULL;
> +	int i;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!kvm_apic_present(vcpu))
> +			continue;
> +
> +		if (kvm_apic_match_dest(vcpu, 0, 0, apicid, 0))
> +			break;
> +	}
> +	if (vcpu) {
> +		/*
> +		 * Setting unhalt flag here can result in spurious runnable
> +		 * state when unhalt reset does not happen in vcpu_block.
> +		 * But that is harmless since that should soon result in halt.
> +		 */
> +		vcpu->arch.pv.pv_unhalted = 1;
> +		/* We need everybody see unhalt before vcpu unblocks */
> +		smp_mb();

smp_wmb().

> +		kvm_vcpu_kick(vcpu);
> +	}
> +}
> +
>
>  /*
>   * hypercalls use architecture specific
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 42b7393..edf56d4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1500,6 +1500,14 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
>  
>  		if (kvm_arch_vcpu_runnable(vcpu)) {
> +			/*
> +			 * This is the only safe place to reset unhalt flag.
> +			 * otherwise it results in loosing the notification
> +			 * which eventually can result in vcpu hangs.
> +			 */
> +			kvm_arch_vcpu_reset_pv_unhalted(vcpu);
> +			/* preventing reordering should be enough here */
> +			barrier();
>  			kvm_make_request(KVM_REQ_UNHALT, vcpu);
>  			break;
>  		}
>

Hm, what about reusing KVM_REQ_UNHALT?

-- 
error compiling committee.c: too many arguments to function

