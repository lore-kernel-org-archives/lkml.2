Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0HCIQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:16:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab0HCIQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:16:41 -0400
Message-ID: <4C57D061.9030907@redhat.com>
Date: Tue, 03 Aug 2010 11:16:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: Check for nested vmrun intercept before
 emulating vmrun
References: <1280760405-22591-1-git-send-email-joerg.roedel@amd.com> <1280760405-22591-2-git-send-email-joerg.roedel@amd.com> <4C56E1B1.4070805@redhat.com> <20100802203344.GO23755@8bytes.org>
In-Reply-To: <20100802203344.GO23755@8bytes.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/02/2010 11:33 PM, Joerg Roedel wrote:
> On Mon, Aug 02, 2010 at 06:18:09PM +0300, Avi Kivity wrote:
>>   On 08/02/2010 05:46 PM, Joerg Roedel wrote:
>>> This patch lets the nested vmrun fail if the L1 hypervisor
>>> has not intercepted vmrun. This fixes the "vmrun intercept
>>> check" unit test.
>>> +
>>>    static bool nested_svm_vmrun(struct vcpu_svm *svm)
>>>    {
>>>    	struct vmcb *nested_vmcb;
>>> @@ -2029,6 +2037,17 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>>>    	if (!nested_vmcb)
>>>    		return false;
>>>
>>> +	if (!nested_vmcb_checks(nested_vmcb)) {
>>> +		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
>>> +		nested_vmcb->control.exit_code_hi = 0;
>>> +		nested_vmcb->control.exit_info_1  = 0;
>>> +		nested_vmcb->control.exit_info_2  = 0;
>>> +
>>> +		nested_svm_unmap(page);
>>> +
>>> +		return false;
>>> +	}
>>> +
>> Don't you have to transfer an injected event to exitintinfo?
> APM2 seems to be quiet about this.

Well, my copy says

> The VMRUN instruction then checks the guest state just loaded. If an 
> illegal state has been loaded, the
> processor exits back to the host (see “#VMEXIT” on page 374).

This matches "illegal state" and "#VMEXIT" but doesn't match "guest state".

> I just tried it out and event_inj
> still contains the event after a failed vmrun on real hardware. This
> makes sense because this is no real vmexit because the vm was never
> entered.

Okay; will apply the patches.

-- 
error compiling committee.c: too many arguments to function

