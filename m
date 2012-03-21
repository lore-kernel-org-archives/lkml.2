Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031313Ab2CUOua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:50:30 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56659 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2CUOu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:50:28 -0400
Message-ID: <4F69EA8F.50208@linux.vnet.ibm.com>
Date: Wed, 21 Mar 2012 20:19:51 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
CC: Attilio Rao <attilio.rao@citrix.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH RFC V6 1/11]  x86/spinlock: replace pv spinlocks with
 pv ticketlocks
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <2425963.NBpIGX9T40@chlor> <4F69DC68.6080200@citrix.com> <1363312.nixp29LUbv@chlor> <4F69E6BB.508@citrix.com>
In-Reply-To: <4F69E6BB.508@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12032114-8878-0000-0000-000001CAC8F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 08:03 PM, Attilio Rao wrote:
> On 21/03/12 14:25, Stephan Diestelhorst wrote:
>> On Wednesday 21 March 2012, 13:49:28 Attilio Rao wrote:
>>> On 21/03/12 13:22, Stephan Diestelhorst wrote:
>>>> On Wednesday 21 March 2012, 13:04:25 Attilio Rao wrote:
>>>>
>>>>> On 21/03/12 10:20, Raghavendra K T wrote:
>>>>>
>>>>>> From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
>>>>>>
>>>>>> Rather than outright replacing the entire spinlock implementation in
>>>>>> order to paravirtualize it, keep the ticket lock implementation
>>>>>> but add
>>>>>> a couple of pvops hooks on the slow patch (long spin on lock,
>>>>>> unlocking
>>>>>> a contended lock).
>>>>>>
>>>>>> Ticket locks have a number of nice properties, but they also have
>>>>>> some
>>>>>> surprising behaviours in virtual environments. They enforce a strict
>>>>>> FIFO ordering on cpus trying to take a lock; however, if the
>>>>>> hypervisor
>>>>>> scheduler does not schedule the cpus in the correct order, the
>>>>>> system can
>>>>>> waste a huge amount of time spinning until the next cpu can take
>>>>>> the lock.
>>>>>>
>>>>>> (See Thomas Friebel's talk "Prevent Guests from Spinning Around"
>>>>>> http://www.xen.org/files/xensummitboston08/LHP.pdf for more details.)
>>>>>>
>>>>>> To address this, we add two hooks:
>>>>>> - __ticket_spin_lock which is called after the cpu has been
>>>>>> spinning on the lock for a significant number of iterations but has
>>>>>> failed to take the lock (presumably because the cpu holding the lock
>>>>>> has been descheduled). The lock_spinning pvop is expected to block
>>>>>> the cpu until it has been kicked by the current lock holder.
>>>>>> - __ticket_spin_unlock, which on releasing a contended lock
>>>>>> (there are more cpus with tail tickets), it looks to see if the next
>>>>>> cpu is blocked and wakes it if so.
>>>>>>
>>>>>> When compiled with CONFIG_PARAVIRT_SPINLOCKS disabled, a set of stub
>>>>>> functions causes all the extra code to go away.
>>>>>>
>>>>>>
>>>>> I've made some real world benchmarks based on this serie of patches
>>>>> applied on top of a vanilla Linux-3.3-rc6 (commit
>>>>> 4704fe65e55fb088fbcb1dc0b15ff7cc8bff3685), with both
>>>>> CONFIG_PARAVIRT_SPINLOCK=y and n, which means essentially 4 versions
>>>>> compared:
>>>>> * vanilla - CONFIG_PARAVIRT_SPINLOCK - patch
>>>>> * vanilla + CONFIG_PARAVIRT_SPINLOCK - patch
>>>>> * vanilla - CONFIG_PARAVIRT_SPINLOCK + patch
>>>>> * vanilla + CONFIG_PARAVIRT_SPINLOCK + patch
>>>>>
>>>>>
>>>> [...]
>>>>
>>>>> == Results
>>>>> This test points in the direction that Jeremy's rebased patches don't
>>>>> introduce a peformance penalty at all, but also that we could likely
>>>>> consider CONFIG_PARAVIRT_SPINLOCK option removal, or turn it on by
>>>>> default and suggest disabling just on very old CPUs (assuming a
>>>>> performance regression can be proven there).
>>>>>
>>>> Very interesting results, in particular knowing that in the one guest
>>>> case things do not get (significantly) slower due to the added logic
>>>> and LOCKed RMW in the unlock path.
>>>>
>>>> AFAICR, the problem really became apparent when running multiple guests
>>>> time sharing the physical CPUs, i.e., two guests with eight vCPUs each
>>>> on an eight core machine. Did you look at this setup with your tests?
>>>>
>>>>
>>> Please note that my tests are made on native Linux, without XEN
>>> involvement.
>>>
>>> You maybe meant that the spinlock paravirtualization became generally
>>> useful in the case you mentioned? (2 guests, 8vpcu + 8vcpu)?
>> Yes, that is what I meant. Just to clarify why you do not see any
>> speed-ups, and were wondering why. If the whole point of the exercise
>> was to see that there are no perforamnce regressions, fine. In that
>> case I misunderstood.
>
> Yes, that's right, I just wanted to measure (possible) overhead in
> native Linux and the cost of leaving CONFIG_PARAVIRT_SPINLOCK on.

True.  Even my result was only revolved around native overhead.

Till now main concern in the community was native overhead. So this time 
we have the results that proves CONFG_PARAVRT_SPINLOCK is now in par 
with corresponding vanilla because of ticketlock improvements.

Coming to Guest scenario, I intend to post KVM counterpart of the 
patches with results where we see huge improvement (around 90%) in 
contention scenario and almost zero overhead in normal case.



>

