Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2GKLQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:16:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab2GKLQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:16:53 -0400
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4FFD5DA3.3010001@redhat.com>
Date: Wed, 11 Jul 2012 13:16:41 +0200
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
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
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <39DA3B9A-87D6-4EA5-B1FF-B6E30733EF7B@suse.de>
References: <20120709062012.24030.37154.sendpatchset@codeblue> <4FFA8E5E.3070108@de.ibm.com> <4FFD422B.9060008@redhat.com> <4FFD52CD.7040403@de.ibm.com> <4FFD5DA3.3010001@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11.07.2012, at 13:04, Avi Kivity wrote:

> On 07/11/2012 01:17 PM, Christian Borntraeger wrote:
>> On 11/07/12 11:06, Avi Kivity wrote:
>> [...]
>>>> Almost all s390 kernels use diag9c (directed yield to a given guest cpu) for spinlocks, though.
>>> 
>>> Perhaps x86 should copy this.
>> 
>> See arch/s390/lib/spinlock.c
>> The basic idea is using several heuristics:
>> - loop for a given amount of loops
>> - check if the lock holder is currently scheduled by the hypervisor
>>  (smp_vcpu_scheduled, which uses the sigp sense running instruction)
>>  Dont know if such thing is available for x86. It must be a lot cheaper
>>  than a guest exit to be useful
> 
> We could make it available via shared memory, updated using preempt
> notifiers.  Of course piling on more pv makes this less attractive.
> 
>> - if lock holder is not running and we looped for a while do a directed
>>  yield to that cpu.
>> 
>>> 
>>>> So there is no win here, but there are other cases were diag44 is used, e.g. cpu_relax.
>>>> I have to double check with others, if these cases are critical, but for now, it seems 
>>>> that your dummy implementation  for s390 is just fine. After all it is a no-op until 
>>>> we implement something.
>>> 
>>> Does the data structure make sense for you?  If so we can move it to
>>> common code (and manage it in kvm_vcpu_on_spin()).  We can guard it with
>>> CONFIG_KVM_HAVE_CPU_RELAX_INTERCEPT or something, so other archs don't
>>> have to pay anything.
>> 
>> Ignoring the name,
> 
> What name would you suggest?
> 
>> yes the data structure itself seems based on the algorithm
>> and not on arch specific things. That should work. If we move that to common 
>> code then s390 will use that scheme automatically for the cases were we call 
>> kvm_vcpu_on_spin(). All others archs as well.
> 
> ARM doesn't have an instruction for cpu_relax(), so it can't intercept
> it.  Given ppc's dislike of overcommit,

What dislike of overcommit?

> and the way it implements cpu_relax() by adjusting hw thread priority,

Yeah, I don't think we can intercept relaxing. It's basically a nop-like instruction that gives hardware hints on its current priorities.
That said, we can always add PV code.


Alex

