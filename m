Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107Ab2D0KqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 06:46:22 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47697 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559Ab2D0KqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 06:46:19 -0400
Message-ID: <4F9A78CF.7070005@linux.vnet.ibm.com>
Date: Fri, 27 Apr 2012 16:15:35 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        X86 <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V6 1/5] kvm hypervisor : Add a hypercall to KVM hypervisor
 to support pv-ticketlocks
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com> <20120423095947.30893.84029.sendpatchset@codeblue.in.ibm.com> <20120424095923.GS15413@redhat.com>
In-Reply-To: <20120424095923.GS15413@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12042701-3568-0000-0000-0000019D4E88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 03:29 PM, Gleb Natapov wrote:
> On Mon, Apr 23, 2012 at 03:29:47PM +0530, Raghavendra K T wrote:
>> From: Srivatsa Vaddagiri<vatsa@linux.vnet.ibm.com>
>>
>> KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu out of halt state.
>>
>> The presence of these hypercalls is indicated to guest via
>> KVM_FEATURE_PV_UNHALT/KVM_CAP_PV_UNHALT.
>>
>> Signed-off-by: Srivatsa Vaddagiri<vatsa@linux.vnet.ibm.com>
>> Signed-off-by: Suzuki Poulose<suzuki@in.ibm.com>
>> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>> ---
[...]
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
>> +		kvm_vcpu_kick(vcpu);
>> +	}
>> +}
> This is too similar to kvm_irq_delivery_to_apic(). Why not reuse it. We
> can use one of reserved delivery modes as PV delivery mode. We will
> disallow guest to trigger it through apic interface, so this will not be
> part of ABI and can be changed at will.
>

I think it is interesting ( Perhaps more reasonable way of doing it).
I am not too familiar with lapic source. So, pardon me if my questions 
are stupid.

Something like below is what I deciphered from your suggestion which is 
working.

kvm/x86.c
=========
kvm_pv_kick_cpu_op()
{

  struct kvm_lapic_irq lapic_irq;

  lapic_irq.shorthand = 0;
  lapic_irq.dest_mode = 0;
  lapic_irq.dest_id = apicid;

  lapic_irq.delivery_mode = PV_DELIVERY_MODE;
  kvm_irq_delivery_to_apic(kvm, 0, &lapic_irq );

}

kvm/lapic.c
==========
_apic_accept_irq()
{
...
case APIC_DM_REMRD:
                 result = 1;
                 vcpu->pv_unhalted = 1
                 smp_mb();
                 kvm_make_request(KVM_REQ_EVENT, vcpu);
                 kvm_vcpu_kick(vcpu);
                 break;

...
}

here using PV_DELIVERY_MODE = APIC_DM_REMRD, which was unused.

OR
1) Are you asking to remove vcpu->pv_unhalted flag and replace with an irq?
2) are you talking about some reserved fields in struct local_apic instead
of APIC_DM_REMRD what I have used above?
[ Honestly, arch/x86/include/asm/apicdef.h had too much of info to 
digest :( ]

3) I am not sure about: disallow guest to trigger it through apic 
interface part also.(mean howto?)
4) And one more question, So you think it takes care of migration part
   (in case we are removing pv_unhalted flag)?

It would be helpful if you can give little more explanation/ pointer to 
Documentation.

Ingo is keen to see whole ticketlock/Xen/KVM patch in one go.
and anyhow since this does not cause any ABI change, I hope you don't 
mind if
I do only the vcpu->pv_unhalted change you suggested now [ having 
pv_unhalted reset  in vcpu_run if
you meant something else than code I have above ], so that whole series 
get fair amount time for testing.

