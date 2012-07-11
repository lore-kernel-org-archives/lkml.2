Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab2GKKyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:54:37 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37926 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab2GKKyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:54:35 -0400
Message-ID: <4FFD5AED.3030307@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2012 16:22:29 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC 1/2] kvm vcpu: Note down pause loop exit
References: <20120709062012.24030.37154.sendpatchset@codeblue> <20120709062032.24030.10454.sendpatchset@codeblue> <4FFD3F10.5020900@redhat.com>
In-Reply-To: <4FFD3F10.5020900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071100-7014-0000-0000-0000018A8B6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 02:23 PM, Avi Kivity wrote:
> On 07/09/2012 09:20 AM, Raghavendra K T wrote:
>> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>
>> Noting pause loop exited vcpu helps in filtering right candidate to yield.
>> Yielding to same vcpu may result in more wastage of cpu.
>>
>>
>>   struct kvm_lpage_info {
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index f75af40..a492f5d 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -3264,6 +3264,7 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
>>
>>   static int pause_interception(struct vcpu_svm *svm)
>>   {
>> +	svm->vcpu.arch.plo.pause_loop_exited = true;
>>   	kvm_vcpu_on_spin(&(svm->vcpu));
>>   	return 1;
>>   }
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index 32eb588..600fb3c 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -4945,6 +4945,7 @@ out:
>>   static int handle_pause(struct kvm_vcpu *vcpu)
>>   {
>>   	skip_emulated_instruction(vcpu);
>> +	vcpu->arch.plo.pause_loop_exited = true;
>>   	kvm_vcpu_on_spin(vcpu);
>>
>
> This code is duplicated.  Should we move it to kvm_vcpu_on_spin?
>
> That means the .plo structure needs to be in common code, but that's not
> too bad perhaps.
>

Since PLE is very much tied to x86, and proposed changes are very much 
specific to PLE handler, I thought it is better to make arch specific.

So do you think it is good to move inside vcpu_on_spin and make ple
structure belong to common code?

>> index be6d549..07dbd14 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5331,7 +5331,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>
>>   	if (req_immediate_exit)
>>   		smp_send_reschedule(vcpu->cpu);
>> -
>> +	vcpu->arch.plo.pause_loop_exited = false;
>
> This adds some tiny overhead to vcpu entry.  You could remove it by
> using the vcpu->requests mechanism to clear the flag, since
> vcpu->requests is already checked on every entry.

So IIUC,  let's have request bit for indicating PLE,

pause_interception() /handle_pause()
{
  make_request(PLE_REQUEST)
  vcpu_on_spin()

}

check_eligibility()
  {
  !test_request(PLE_REQUEST) || ( test_request(PLE_REQUEST)  && 
dy_eligible())
.
.
}

vcpu_run()
{

check_request(PLE_REQUEST)
.
.
}

Is this is the expected flow you had in mind?

[ But my only concern was not resetting for cases where we do not do 
guest_enter(). will test how that goes].

>
>>   	kvm_guest_enter();
>>

