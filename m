Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab2GKLxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:53:11 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36290 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab2GKLxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:53:08 -0400
Message-ID: <4FFD68AA.1000607@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2012 17:21:06 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
References: <20120709062012.24030.37154.sendpatchset@codeblue> <4FFA8E5E.3070108@de.ibm.com> <4FFD422B.9060008@redhat.com> <4FFD52CD.7040403@de.ibm.com>
In-Reply-To: <4FFD52CD.7040403@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071101-0260-0000-0000-0000017DFCE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 03:47 PM, Christian Borntraeger wrote:
> On 11/07/12 11:06, Avi Kivity wrote:
> [...]
>>> Almost all s390 kernels use diag9c (directed yield to a given guest cpu) for spinlocks, though.
>>
>> Perhaps x86 should copy this.
>
> See arch/s390/lib/spinlock.c
> The basic idea is using several heuristics:
> - loop for a given amount of loops
> - check if the lock holder is currently scheduled by the hypervisor
>    (smp_vcpu_scheduled, which uses the sigp sense running instruction)
>    Dont know if such thing is available for x86. It must be a lot cheaper
>    than a guest exit to be useful

Unfortunately we do not have information on lock-holder.

> - if lock holder is not running and we looped for a while do a directed
>    yield to that cpu.
>
>>
>>> So there is no win here, but there are other cases were diag44 is used, e.g. cpu_relax.
>>> I have to double check with others, if these cases are critical, but for now, it seems
>>> that your dummy implementation  for s390 is just fine. After all it is a no-op until
>>> we implement something.
>>
>> Does the data structure make sense for you?  If so we can move it to
>> common code (and manage it in kvm_vcpu_on_spin()).  We can guard it with
>> CONFIG_KVM_HAVE_CPU_RELAX_INTERCEPT or something, so other archs don't
>> have to pay anything.
>
> Ignoring the name, yes the data structure itself seems based on the algorithm
> and not on arch specific things. That should work.

Ok. can you please elaborate, on the flow.

  If we move that to common
> code then s390 will use that scheme automatically for the cases were we call
> kvm_vcpu_on_spin(). All others archs as well.
>
> So this would probably improve guests that uses cpu_relax, for example
> stop_machine_run. I have no measurements, though.
>
> Christian
>

