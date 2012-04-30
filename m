Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2D3HpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 03:45:22 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:38692 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab2D3HpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 03:45:20 -0400
Message-ID: <4F9E42F6.8050108@linux.vnet.ibm.com>
Date: Mon, 30 Apr 2012 13:14:54 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
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
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com> <20120423095947.30893.84029.sendpatchset@codeblue.in.ibm.com> <4F9D415B.7010103@redhat.com>
In-Reply-To: <4F9D415B.7010103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12043007-4790-0000-0000-00000267226B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Avi, for the review.

On 04/29/2012 06:55 PM, Avi Kivity wrote:
> On 04/23/2012 12:59 PM, Raghavendra K T wrote:
>> From: Srivatsa Vaddagiri<vatsa@linux.vnet.ibm.com>
>>
>> KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu out of halt state.
>>
>> The presence of these hypercalls is indicated to guest via
>> KVM_FEATURE_PV_UNHALT/KVM_CAP_PV_UNHALT.
>>
>>   #endif
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index e216ba0..dad475b 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -481,6 +481,10 @@ struct kvm_vcpu_arch {
>>   		u64 length;
>>   		u64 status;
>>   	} osvw;
>> +	/* pv related host specific info */
>> +	struct {
>> +		int pv_unhalted;
>> +	} pv;
>>   };
>
> 'bool'.  Or maybe push into vcpu->requests.

Ok. I think you meant
+	struct {
+		bool pv_unhalted;
+	} pv;

and as discussed in old series (V4), cleaner implementation having
vcpu request, would still need a flag to prevent vcpu hang, so back to
having one flag.

>
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 4044ce0..7fc9be6 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2147,6 +2147,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>>   	case KVM_CAP_ASYNC_PF:
>>   	case KVM_CAP_GET_TSC_KHZ:
>>   	case KVM_CAP_PCI_2_3:
>> +	case KVM_CAP_PV_UNHALT:
>>   		r = 1;
>>   		break;
>>   	case KVM_CAP_COALESCED_MMIO:
>
> Redundant, since we can infer this from KVM_GET_SUPPORTED_CPUID.  But
> please indicate this in the documentation.
>

Ok. will mention that in documentation added for KVM_CAP_PV_UNHALT.

>>
>> +/*
>> + * kvm_pv_kick_cpu_op:  Kick a vcpu.
>> + *
>> + * @apicid - apicid of vcpu to be kicked.
>> + */
>> +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
>> +{
>> +	struct kvm_vcpu *vcpu = NULL;
>> +	int i;
>> +
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		if (!kvm_apic_present(vcpu))
>> +			continue;
>> +
>> +		if (kvm_apic_match_dest(vcpu, 0, 0, apicid, 0))
>> +			break;
>> +	}
>> +	if (vcpu) {
>> +		/*
>> +		 * Setting unhalt flag here can result in spurious runnable
>> +		 * state when unhalt reset does not happen in vcpu_block.
>> +		 * But that is harmless since that should soon result in halt.
>> +		 */
>> +		vcpu->arch.pv.pv_unhalted = 1;
>> +		/* We need everybody see unhalt before vcpu unblocks */
>> +		smp_mb();
>
> smp_wmb().
>

Done.

>> +		kvm_vcpu_kick(vcpu);
>> +	}
>> +}
>> +
>>
>>   /*
>>    * hypercalls use architecture specific
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 42b7393..edf56d4 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1500,6 +1500,14 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>>   		prepare_to_wait(&vcpu->wq,&wait, TASK_INTERRUPTIBLE);
>>
>>   		if (kvm_arch_vcpu_runnable(vcpu)) {
>> +			/*
>> +			 * This is the only safe place to reset unhalt flag.
>> +			 * otherwise it results in loosing the notification
>> +			 * which eventually can result in vcpu hangs.
>> +			 */
>> +			kvm_arch_vcpu_reset_pv_unhalted(vcpu);
>> +			/* preventing reordering should be enough here */
>> +			barrier();
>>   			kvm_make_request(KVM_REQ_UNHALT, vcpu);
>>   			break;
>>   		}
>>
>
> Hm, what about reusing KVM_REQ_UNHALT?
>

Yes, I had experimented this for some time without success.
For e.g. having
make_request(KVM_REQ_UNHALT, vcpu) directly from kick hypercall.

It would still need a flag. (did not get any alternative so far except
the  workaround posted in V4) :(

