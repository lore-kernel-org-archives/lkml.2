Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2DZIwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:52:47 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:51560 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab2DZIwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:52:46 -0400
Message-ID: <4F990321.60208@linux.vnet.ibm.com>
Date: Thu, 26 Apr 2012 13:41:13 +0530
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
x-cbid: 12042522-0260-0000-0000-000000F192F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 03:29 PM, Gleb Natapov wrote:
> On Mon, Apr 23, 2012 at 03:29:47PM +0530, Raghavendra K T wrote:
>> From: Srivatsa Vaddagiri<vatsa@linux.vnet.ibm.com>
[...]
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
> Why this is the only safe place? Why clearing it in kvm/x86.c just after
> call to kvm_vcpu_block() if KVM_REQ_UNHALT is set is not safe enough?
>

Yes, You are Right. The acceptable window to reset the flag can be
extended till there. and Good point about that is it removes the need
for having the stubs for other archs and simplifies everything a lot. 
Thanks for that.

[ When I was experimenting with request bit, clearing request bit in the 
same place was causing vm hang after some 16 iteration of stress test. I 
had carried the same impression. Now I have done stress testing
to ensure that the change works.  Basically as you know, my fear was 
loosing kick(s) leads to vm hang eventually. ]

