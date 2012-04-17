Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2DQDtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:49:16 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:56909 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2DQDtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:49:15 -0400
Message-ID: <4F8CE82D.80503@linux.vnet.ibm.com>
Date: Tue, 17 Apr 2012 09:19:01 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 <x86@kernel.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V5 2/6] kvm hypervisor : Add a hypercall to KVM hypervisor
 to support pv-ticketlocks
References: <20120323080503.14568.43092.sendpatchset@codeblue> <20120323080701.14568.97779.sendpatchset@codeblue> <20120412000629.GA32051@amt.cnet>
In-Reply-To: <20120412000629.GA32051@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12041703-5816-0000-0000-00000229DD78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for late reply,
was on vacation for a week (without IMAP access :( )

On 04/12/2012 05:36 AM, Marcelo Tosatti wrote:
> On Fri, Mar 23, 2012 at 01:37:04PM +0530, Raghavendra K T wrote:
>> From: Srivatsa Vaddagiri<vatsa@linux.vnet.ibm.com>
[snip]
>> @@ -1567,6 +1568,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>>   		prepare_to_wait(&vcpu->wq,&wait, TASK_INTERRUPTIBLE);
>>
>>   		if (kvm_arch_vcpu_runnable(vcpu)) {
>> +			vcpu->pv_unhalted = 0;
>> +			/* preventing reordering should be enough here */
>> +			barrier();
>
> Is it always OK to erase the notification, even in case an unrelated
> event such as interrupt was the source of wakeup?


Erasing notification is not good, But I think in this case,

kvm_make_request(KVM_REQ_UNHALT, vcpu);

below this would take care of the rest.

>
> It would be easier to verify that notifications are not lost with atomic
>
> test_and_clear(pv_unhalted).

true, I 'll verify that (with pv_unhalt as atomic variable). my heart
says  current code is just fine, since we are about to unblock.

>
> Also x86 specific code should remain in arch/x86/kvm/
>

I agree. 'll have clear function in arch/x86/kvm and add stub to rest
of the archs

>

