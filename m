Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab2GKLjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:39:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab2GKLjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:39:42 -0400
Message-ID: <4FFD65E0.500@redhat.com>
Date: Wed, 11 Jul 2012 14:39:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
References: <20120709062012.24030.37154.sendpatchset@codeblue> <4FFA8E5E.3070108@de.ibm.com> <4FFD422B.9060008@redhat.com> <4FFD52CD.7040403@de.ibm.com> <4FFD5DA3.3010001@redhat.com> <4FFD6100.8050202@de.ibm.com>
In-Reply-To: <4FFD6100.8050202@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 02:18 PM, Christian Borntraeger wrote:
> On 11/07/12 13:04, Avi Kivity wrote:
>> On 07/11/2012 01:17 PM, Christian Borntraeger wrote:
>>> On 11/07/12 11:06, Avi Kivity wrote:
>>> [...]
>>>>> Almost all s390 kernels use diag9c (directed yield to a given guest cpu) for spinlocks, though.
>>>>
>>>> Perhaps x86 should copy this.
>>>
>>> See arch/s390/lib/spinlock.c
>>> The basic idea is using several heuristics:
>>> - loop for a given amount of loops
>>> - check if the lock holder is currently scheduled by the hypervisor
>>>   (smp_vcpu_scheduled, which uses the sigp sense running instruction)
>>>   Dont know if such thing is available for x86. It must be a lot cheaper
>>>   than a guest exit to be useful
>> 
>> We could make it available via shared memory, updated using preempt
>> notifiers.  Of course piling on more pv makes this less attractive.
>> 
>>> - if lock holder is not running and we looped for a while do a directed
>>>   yield to that cpu.
>>>
>>>>
>>>>> So there is no win here, but there are other cases were diag44 is used, e.g. cpu_relax.
>>>>> I have to double check with others, if these cases are critical, but for now, it seems 
>>>>> that your dummy implementation  for s390 is just fine. After all it is a no-op until 
>>>>> we implement something.
>>>>
>>>> Does the data structure make sense for you?  If so we can move it to
>>>> common code (and manage it in kvm_vcpu_on_spin()).  We can guard it with
>>>> CONFIG_KVM_HAVE_CPU_RELAX_INTERCEPT or something, so other archs don't
>>>> have to pay anything.
>>>
>>> Ignoring the name,
>> 
>> What name would you suggest?
> 
> maybe vcpu_no_progress instead of pause_loop_exited

Ah, I thouht you objected to the CONFIG var.  Maybe call it
cpu_relax_intercepted since that's the linuxy name for the instruction.

-- 
error compiling committee.c: too many arguments to function


