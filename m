Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab2AEShn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:37:43 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:12819
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186Ab2AEShl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:37:41 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzzz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LXC92O-02-7CG-02
X-M-MSG: 
Message-ID: <4F05EDF0.6040007@amd.com>
Date: Thu, 5 Jan 2012 13:37:36 -0500
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Boris Ostrovsky <ostr@amd64.org>, <avi@redhat.com>, <joerg.roedel@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: SVM: Add support for AMD's OSVW feature in guests
References: <1325651893-7487-1-git-send-email-ostr@amd64.org> <20120105112018.GA1901@amt.cnet>
In-Reply-To: <20120105112018.GA1901@amt.cnet>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/12 06:20, Marcelo Tosatti wrote:
> On Tue, Jan 03, 2012 at 11:38:13PM -0500, Boris Ostrovsky wrote:
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index e32243e..b19769d 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -110,6 +110,13 @@ struct nested_state {
>>   #define MSRPM_OFFSETS	16
>>   static u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>>
>> +/*
>> + * Set osvw_len to higher value when updated Revision Guides
>> + * are published and we know what the new status bits are
>> + */
>> +static uint64_t osvw_len = 4, osvw_status;
>> +static DEFINE_SPINLOCK(svm_lock);
>
> No need for this lock, operation already serialized by kvm_lock.

Will remove the lock.

>
>>   struct vcpu_svm {
>>   	struct kvm_vcpu vcpu;
>>   	struct vmcb *vmcb;
>> @@ -556,6 +563,20 @@ static void svm_init_erratum_383(void)
>>   	erratum_383_found = true;
>>   }
>>
>> +static void svm_init_osvw(struct kvm_vcpu *vcpu)
>> +{
>> +	/*
>> +	 * Guests should see errata 400 and 415 as fixed (assuming that
>> +	 * HLT and IO instructions are intercepted).
>> +	 */
>> +	vcpu->arch.osvw.length = (osvw_len>= 3) ? (osvw_len) : 3;
>> +	vcpu->arch.osvw.status = osvw_status&  ~(6ULL);
>
> Do you really want to expose the hosts osvw_status and osvw_len? If
> only exposure of 400 and 415 as fixed is necessary, then dealing with
> migration is simpler (that is, you control what workarounds are applied
> in the guest instead of making it dependent on particular hosts).

I do think we should (selectively) expose osvw information to the host. 
As of today we have 4 errata described by these bits. Two of them (400 
and 415) don't need to be seen by the guest and the patch would mask 
them off. As for the other two (errata 383 and 298) --- the guest should 
be aware of them and the patch passes them through.

Since osvw_len is initialized to 4 and cannot become larger no other 
bits will be passed to guests until we update the initial value (by a 
future patch).

If we are concerned about migration we can always ovewrite 
vcpu->arch.osvw registers from userspace when creating a guest.

>
>> +	/* Mark erratum 298 as present */
>> +	if (osvw_len == 0&&  boot_cpu_data.x86 == 0x10)
>> +		vcpu->arch.osvw.status |= 1;
>> +}
>
> Why is it necessary to explicitly do this? Please add documentation.

That's because we may have bumped vcpu->arch.osvw.length to 3 in order 
to signal the guest that 400 and 415 are fixed. By doing this we are 
also telling the guest that it can rely on state of bit0.

If we leave bit0 as 0 the guest will assume that 298 is fixed. However, 
if host's osvw_length is 0 it means that the physical HW *may* still be 
affected. So we take conservative approach and tell the guest that it 
should work around 298.

I'll add a comment to that effect.

>
>> +	case MSR_AMD64_OSVW_ID_LENGTH:
>> +		if (!guest_cpuid_has_osvw(vcpu))
>> +			return 1;
>> +		vcpu->arch.osvw.length = data;
>> +		break;
>> +	case MSR_AMD64_OSVW_STATUS:
>> +		if (!guest_cpuid_has_osvw(vcpu))
>> +			return 1;
>> +		vcpu->arch.osvw.status = data;
>> +		break;
>
> If writes are allowed, it is necessary to migrate this.

Not sure I understand what you mean here. Isn't vcpu->arch state 
migrated with the guest?

Thanks.
-boris

