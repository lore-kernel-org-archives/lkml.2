Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab2B0PI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 10:08:29 -0500
Received: from thoth.sbs.de ([192.35.17.2]:22488 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab2B0PI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 10:08:27 -0500
Message-ID: <4F4B9C57.3010407@siemens.com>
Date: Mon, 27 Feb 2012 16:08:07 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
References: <4F4AF1FB.6000903@cn.fujitsu.com>
In-Reply-To: <4F4AF1FB.6000903@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-27 04:01, Wen Congyang wrote:
> We can know the guest is paniced when the guest runs on xen.
> But we do not have such feature on kvm. This patch implemnts
> this feature, and the implementation is the same as xen:
> register panic notifier, and call hypercall when the guest
> is paniced.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  arch/x86/kernel/kvm.c    |   12 ++++++++++++
>  arch/x86/kvm/svm.c       |    8 ++++++--
>  arch/x86/kvm/vmx.c       |    8 ++++++--
>  arch/x86/kvm/x86.c       |   13 +++++++++++--
>  include/linux/kvm.h      |    1 +
>  include/linux/kvm_para.h |    1 +
>  6 files changed, 37 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index f0c6fd6..b928d1d 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -331,6 +331,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
>  	.notifier_call = kvm_pv_reboot_notify,
>  };
>  
> +static int
> +kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
> +{
> +	kvm_hypercall0(KVM_HC_GUEST_PANIC);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block kvm_pv_panic_nb = {
> +	.notifier_call = kvm_pv_panic_notify,
> +};
> +

You should split up host and guest-side changes.

>  static u64 kvm_steal_clock(int cpu)
>  {
>  	u64 steal;
> @@ -417,6 +428,7 @@ void __init kvm_guest_init(void)
>  
>  	paravirt_ops_setup();
>  	register_reboot_notifier(&kvm_pv_reboot_nb);
> +	atomic_notifier_chain_register(&panic_notifier_list, &kvm_pv_panic_nb);
>  	for (i = 0; i < KVM_TASK_SLEEP_HASHSIZE; i++)
>  		spin_lock_init(&async_pf_sleepers[i].lock);
>  	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 0b7690e..38b4705 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1900,10 +1900,14 @@ static int halt_interception(struct vcpu_svm *svm)
>  
>  static int vmmcall_interception(struct vcpu_svm *svm)
>  {
> +	int ret;
> +
>  	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
>  	skip_emulated_instruction(&svm->vcpu);
> -	kvm_emulate_hypercall(&svm->vcpu);
> -	return 1;
> +	ret = kvm_emulate_hypercall(&svm->vcpu);
> +
> +	/* Ignore the error? */
> +	return ret == 0 ? 0 : 1;

Why can't kvm_emulate_hypercall return the right value?

>  }
>  
>  static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 66147ca..1b57ebb 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -4582,9 +4582,13 @@ static int handle_halt(struct kvm_vcpu *vcpu)
>  
>  static int handle_vmcall(struct kvm_vcpu *vcpu)
>  {
> +	int ret;
> +
>  	skip_emulated_instruction(vcpu);
> -	kvm_emulate_hypercall(vcpu);
> -	return 1;
> +	ret = kvm_emulate_hypercall(vcpu);
> +
> +	/* Ignore the error? */
> +	return ret == 0 ? 0 : 1;
>  }
>  
>  static int handle_invd(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c9d99e5..3fc2853 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4923,7 +4923,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  	u64 param, ingpa, outgpa, ret;
>  	uint16_t code, rep_idx, rep_cnt, res = HV_STATUS_SUCCESS, rep_done = 0;
>  	bool fast, longmode;
> -	int cs_db, cs_l;
> +	int cs_db, cs_l, r = 1;
>  
>  	/*
>  	 * hypercall generates UD from non zero cpl and real mode
> @@ -4964,6 +4964,10 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  	case HV_X64_HV_NOTIFY_LONG_SPIN_WAIT:
>  		kvm_vcpu_on_spin(vcpu);
>  		break;
> +	case KVM_HC_GUEST_PANIC:
> +		vcpu->run->exit_reason = KVM_EXIT_GUEST_PANIC;
> +		r = 0;
> +		break;

That's the wrong place. This is a KVM hypercall, not a HyperV one.

>  	default:
>  		res = HV_STATUS_INVALID_HYPERCALL_CODE;
>  		break;
> @@ -4977,7 +4981,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  		kvm_register_write(vcpu, VCPU_REGS_RAX, ret & 0xffffffff);
>  	}
>  
> -	return 1;
> +	return r;
>  }
>  
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> @@ -5013,6 +5017,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  	case KVM_HC_VAPIC_POLL_IRQ:
>  		ret = 0;
>  		break;
> +	case KVM_HC_GUEST_PANIC:
> +		ret = 0;
> +		vcpu->run->exit_reason = KVM_EXIT_GUEST_PANIC;
> +		r = 0;
> +		break;
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index acbe429..8f0e31b 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -163,6 +163,7 @@ struct kvm_pit_config {
>  #define KVM_EXIT_OSI              18
>  #define KVM_EXIT_PAPR_HCALL	  19
>  #define KVM_EXIT_S390_UCONTROL	  20
> +#define KVM_EXIT_GUEST_PANIC	  21
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  #define KVM_INTERNAL_ERROR_EMULATION 1
> diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
> index ff476dd..cf94023 100644
> --- a/include/linux/kvm_para.h
> +++ b/include/linux/kvm_para.h
> @@ -19,6 +19,7 @@
>  #define KVM_HC_MMU_OP			2
>  #define KVM_HC_FEATURES			3
>  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
> +#define KVM_HC_GUEST_PANIC		5
>  
>  /*
>   * hypercalls use architecture specific

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
