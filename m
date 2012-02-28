Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2B1IGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:06:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56378 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab2B1IGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:06:42 -0500
Message-ID: <4F4C8B4D.5050704@cn.fujitsu.com>
Date: Tue, 28 Feb 2012 16:07:41 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: kvm list <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
References: <4F4AF1FB.6000903@cn.fujitsu.com> <4F4B9C57.3010407@siemens.com> <4F4C6596.8020903@cn.fujitsu.com>
In-Reply-To: <4F4C6596.8020903@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-28 16:04:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-28 16:04:53,
	Serialize complete at 2012-02-28 16:04:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 02/28/2012 01:26 PM, Wen Congyang Wrote:
> At 02/27/2012 11:08 PM, Jan Kiszka Wrote:
>> On 2012-02-27 04:01, Wen Congyang wrote:
>>> We can know the guest is paniced when the guest runs on xen.
>>> But we do not have such feature on kvm. This patch implemnts
>>> this feature, and the implementation is the same as xen:
>>> register panic notifier, and call hypercall when the guest
>>> is paniced.
>>>
>>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>>> ---
>>>  arch/x86/kernel/kvm.c    |   12 ++++++++++++
>>>  arch/x86/kvm/svm.c       |    8 ++++++--
>>>  arch/x86/kvm/vmx.c       |    8 ++++++--
>>>  arch/x86/kvm/x86.c       |   13 +++++++++++--
>>>  include/linux/kvm.h      |    1 +
>>>  include/linux/kvm_para.h |    1 +
>>>  6 files changed, 37 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>> index f0c6fd6..b928d1d 100644
>>> --- a/arch/x86/kernel/kvm.c
>>> +++ b/arch/x86/kernel/kvm.c
>>> @@ -331,6 +331,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
>>>  	.notifier_call = kvm_pv_reboot_notify,
>>>  };
>>>  
>>> +static int
>>> +kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
>>> +{
>>> +	kvm_hypercall0(KVM_HC_GUEST_PANIC);
>>> +	return NOTIFY_DONE;
>>> +}
>>> +
>>> +static struct notifier_block kvm_pv_panic_nb = {
>>> +	.notifier_call = kvm_pv_panic_notify,
>>> +};
>>> +
>>
>> You should split up host and guest-side changes.
> 
> OK
> 
>>
>>>  static u64 kvm_steal_clock(int cpu)
>>>  {
>>>  	u64 steal;
>>> @@ -417,6 +428,7 @@ void __init kvm_guest_init(void)
>>>  
>>>  	paravirt_ops_setup();
>>>  	register_reboot_notifier(&kvm_pv_reboot_nb);
>>> +	atomic_notifier_chain_register(&panic_notifier_list, &kvm_pv_panic_nb);
>>>  	for (i = 0; i < KVM_TASK_SLEEP_HASHSIZE; i++)
>>>  		spin_lock_init(&async_pf_sleepers[i].lock);
>>>  	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>> index 0b7690e..38b4705 100644
>>> --- a/arch/x86/kvm/svm.c
>>> +++ b/arch/x86/kvm/svm.c
>>> @@ -1900,10 +1900,14 @@ static int halt_interception(struct vcpu_svm *svm)
>>>  
>>>  static int vmmcall_interception(struct vcpu_svm *svm)
>>>  {
>>> +	int ret;
>>> +
>>>  	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
>>>  	skip_emulated_instruction(&svm->vcpu);
>>> -	kvm_emulate_hypercall(&svm->vcpu);
>>> -	return 1;
>>> +	ret = kvm_emulate_hypercall(&svm->vcpu);
>>> +
>>> +	/* Ignore the error? */
>>> +	return ret == 0 ? 0 : 1;
>>
>> Why can't kvm_emulate_hypercall return the right value?
> 
> Because before this patch, kvm always ignores the error.
> 
> After rereading the code, kvm_emulate_hypercall() will return -KVM_EPERM

Sorry for my miss. kvm_emulate_hypercall() does not return -KVM_EPERM.

> when vcpu's CPL is not 0. I think we should deal with this exception
> in kvm_emulate_hypercall(), and return 1. But I donot know
> how to do it. kvm_queue_exception(vcpu, UD_VECTOR)?
> 
>>
>>>  }
>>>  
>>>  static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>>> index 66147ca..1b57ebb 100644
>>> --- a/arch/x86/kvm/vmx.c
>>> +++ b/arch/x86/kvm/vmx.c
>>> @@ -4582,9 +4582,13 @@ static int handle_halt(struct kvm_vcpu *vcpu)
>>>  
>>>  static int handle_vmcall(struct kvm_vcpu *vcpu)
>>>  {
>>> +	int ret;
>>> +
>>>  	skip_emulated_instruction(vcpu);
>>> -	kvm_emulate_hypercall(vcpu);
>>> -	return 1;
>>> +	ret = kvm_emulate_hypercall(vcpu);
>>> +
>>> +	/* Ignore the error? */
>>> +	return ret == 0 ? 0 : 1;
>>>  }
>>>  
>>>  static int handle_invd(struct kvm_vcpu *vcpu)
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index c9d99e5..3fc2853 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -4923,7 +4923,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>>>  	u64 param, ingpa, outgpa, ret;
>>>  	uint16_t code, rep_idx, rep_cnt, res = HV_STATUS_SUCCESS, rep_done = 0;
>>>  	bool fast, longmode;
>>> -	int cs_db, cs_l;
>>> +	int cs_db, cs_l, r = 1;
>>>  
>>>  	/*
>>>  	 * hypercall generates UD from non zero cpl and real mode
>>> @@ -4964,6 +4964,10 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>>>  	case HV_X64_HV_NOTIFY_LONG_SPIN_WAIT:
>>>  		kvm_vcpu_on_spin(vcpu);
>>>  		break;
>>> +	case KVM_HC_GUEST_PANIC:
>>> +		vcpu->run->exit_reason = KVM_EXIT_GUEST_PANIC;
>>> +		r = 0;
>>> +		break;
>>
>> That's the wrong place. This is a KVM hypercall, not a HyperV one.
> 
> OK, I will remove it.
> 
> Thanks
> Wen Congyang
> 
>>
>>>  	default:
>>>  		res = HV_STATUS_INVALID_HYPERCALL_CODE;
>>>  		break;
>>> @@ -4977,7 +4981,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>>>  		kvm_register_write(vcpu, VCPU_REGS_RAX, ret & 0xffffffff);
>>>  	}
>>>  
>>> -	return 1;
>>> +	return r;
>>>  }
>>>  
>>>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>> @@ -5013,6 +5017,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>>  	case KVM_HC_VAPIC_POLL_IRQ:
>>>  		ret = 0;
>>>  		break;
>>> +	case KVM_HC_GUEST_PANIC:
>>> +		ret = 0;
>>> +		vcpu->run->exit_reason = KVM_EXIT_GUEST_PANIC;
>>> +		r = 0;
>>> +		break;
>>>  	default:
>>>  		ret = -KVM_ENOSYS;
>>>  		break;
>>> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
>>> index acbe429..8f0e31b 100644
>>> --- a/include/linux/kvm.h
>>> +++ b/include/linux/kvm.h
>>> @@ -163,6 +163,7 @@ struct kvm_pit_config {
>>>  #define KVM_EXIT_OSI              18
>>>  #define KVM_EXIT_PAPR_HCALL	  19
>>>  #define KVM_EXIT_S390_UCONTROL	  20
>>> +#define KVM_EXIT_GUEST_PANIC	  21
>>>  
>>>  /* For KVM_EXIT_INTERNAL_ERROR */
>>>  #define KVM_INTERNAL_ERROR_EMULATION 1
>>> diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
>>> index ff476dd..cf94023 100644
>>> --- a/include/linux/kvm_para.h
>>> +++ b/include/linux/kvm_para.h
>>> @@ -19,6 +19,7 @@
>>>  #define KVM_HC_MMU_OP			2
>>>  #define KVM_HC_FEATURES			3
>>>  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
>>> +#define KVM_HC_GUEST_PANIC		5
>>>  
>>>  /*
>>>   * hypercalls use architecture specific
>>
>> Jan
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

