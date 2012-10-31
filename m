Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935565Ab2JaNUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:20:22 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:44611 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422803Ab2JaNUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:20:18 -0400
Message-ID: <50912463.3040201@linux.vnet.ibm.com>
Date: Wed, 31 Oct 2012 18:45:15 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH V2 RFC 2/3] kvm: Handle yield_to failure return code for
 potential undercommit case
References: <20121029140621.15448.92083.sendpatchset@codeblue> <20121029140702.15448.56932.sendpatchset@codeblue> <50911BC3.6080305@redhat.com> <50911C7D.5080307@linux.vnet.ibm.com>
In-Reply-To: <50911C7D.5080307@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12103113-5816-0000-0000-000005245EF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 06:11 PM, Raghavendra K T wrote:
> On 10/31/2012 06:08 PM, Avi Kivity wrote:
>> On 10/29/2012 04:07 PM, Raghavendra K T wrote:
>>> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>>>
>>> Also we do not update last boosted vcpu in failure cases.
>>>
>>>   #endif
>>> +
>>>   void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>>   {
>>>       struct kvm *kvm = me->kvm;
>>> @@ -1727,11 +1727,12 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>>                   continue;
>>>               if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
>>>                   continue;
>>> -            if (kvm_vcpu_yield_to(vcpu)) {
>>> +
>>> +            yielded = kvm_vcpu_yield_to(vcpu);
>>> +            if (yielded > 0)
>>>                   kvm->last_boosted_vcpu = i;
>>> -                yielded = 1;
>>> +            if (yielded)
>>>                   break;
>>> -            }
>>>           }
>>
>> If yielded == -ESRCH, should we not try to yield to another vcpu?
>>
>
>   Yes. plan is to abort the iteration. since it means we are mostly
> undercommitted.

Sorry if it was ambiguous. I wanted to say we do not want to continue
yield to another vcpu..

