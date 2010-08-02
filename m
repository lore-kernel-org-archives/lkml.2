Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0HBUdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:33:49 -0400
Received: from 8bytes.org ([88.198.83.132]:42626 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab0HBUds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:33:48 -0400
Date: Mon, 2 Aug 2010 22:33:44 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: Check for nested vmrun intercept before
	emulating vmrun
Message-ID: <20100802203344.GO23755@8bytes.org>
References: <1280760405-22591-1-git-send-email-joerg.roedel@amd.com> <1280760405-22591-2-git-send-email-joerg.roedel@amd.com> <4C56E1B1.4070805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C56E1B1.4070805@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 06:18:09PM +0300, Avi Kivity wrote:
>  On 08/02/2010 05:46 PM, Joerg Roedel wrote:
>> This patch lets the nested vmrun fail if the L1 hypervisor
>> has not intercepted vmrun. This fixes the "vmrun intercept
>> check" unit test.
>
>> +
>>   static bool nested_svm_vmrun(struct vcpu_svm *svm)
>>   {
>>   	struct vmcb *nested_vmcb;
>> @@ -2029,6 +2037,17 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>>   	if (!nested_vmcb)
>>   		return false;
>>
>> +	if (!nested_vmcb_checks(nested_vmcb)) {
>> +		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
>> +		nested_vmcb->control.exit_code_hi = 0;
>> +		nested_vmcb->control.exit_info_1  = 0;
>> +		nested_vmcb->control.exit_info_2  = 0;
>> +
>> +		nested_svm_unmap(page);
>> +
>> +		return false;
>> +	}
>> +
>
> Don't you have to transfer an injected event to exitintinfo?

APM2 seems to be quiet about this. I just tried it out and event_inj
still contains the event after a failed vmrun on real hardware. This
makes sense because this is no real vmexit because the vm was never
entered.

	Joerg

