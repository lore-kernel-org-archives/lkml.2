Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0KXQ4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:56:11 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15699 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0KXQ4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:56:09 -0500
Message-ID: <4CED43A1.7020402@caviumnetworks.com>
Date: Wed, 24 Nov 2010 08:56:01 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, rostedt@goodmis.org, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump	label
 key entries
References: <cover.1290546539.git.jbaron@redhat.com> <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com> <1290586809.2072.424.camel@laptop> <20101124145401.GA2815@redhat.com> <1290611478.2072.482.camel@laptop> <20101124151936.GB2815@redhat.com> <1290612245.2072.486.camel@laptop> <20101124154200.GD2815@redhat.com>
In-Reply-To: <20101124154200.GD2815@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2010 16:57:01.0855 (UTC) FILETIME=[9D5E62F0:01CB8BF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 07:42 AM, Jason Baron wrote:
> On Wed, Nov 24, 2010 at 04:24:05PM +0100, Peter Zijlstra wrote:
>> On Wed, 2010-11-24 at 10:19 -0500, Jason Baron wrote:
>>> On Wed, Nov 24, 2010 at 04:11:18PM +0100, Peter Zijlstra wrote:
>>>> On Wed, 2010-11-24 at 09:54 -0500, Jason Baron wrote:
>>>>> On Wed, Nov 24, 2010 at 09:20:09AM +0100, Peter Zijlstra wrote:
>>>>>> On Tue, 2010-11-23 at 16:27 -0500, Jason Baron wrote:
>>>>>>>          struct hlist_head modules;
>>>>>>>          unsigned long key;
>>>>>>> +       u32 nr_entries : 31,
>>>>>>> +              enabled :  1;
>>>>>>>   };
>>>>>>
>>>>>> I still don't see why you do this, why not simply mandate that the key
>>>>>> is of type atomic_t* and use *key as enabled state?
>>>>>>
>>>>>
>>>>> Because I want to use *key as a pointer directly to 'struct jump_label_entry'.
>>>>> In this way jump_label_enable(), jump_label_disable(), become O(1) operations.
>>>>> That way we don't need any hashing.
>>>>
>>>> But but but, you're doing a friggin stop_machine to poke text, that's
>>>> way more expensive than anything else.
>>>>
>>>
>>> Yes, but other arches do not require stop_machine(). Also, there is work
>>> for x86 to make the code patching happen without stop_machine().
>>
>> Even without stop machine you're sending IPIs to all CPUs, that's not
>> free either.
>>
>> And I think the only arch where you can do text pokes without cross-cpu
>> synchronization is one that doesn't have SMP support.
>>
>>
>
> is this really true?
>

For MIPS SMP it is.  ICache invalidation is done per CPU.  If you need 
the change to be visible on all CPUs, you have to do an IPI to get all 
CPUs to do their own ICache invalidation.


> The powerpc implementation uses patch_instruction():
>
>
> arch/powerpc/lib/code-patching.c:
>
> void patch_instruction(unsigned int *addr, unsigned int instr)
> {
>          *addr = instr;
>          asm ("dcbst 0, %0; sync; icbi 0,%0; sync; isync" : : "r"
> (addr));
> }
>
>
> And sparc does uses flushi():
>
>
> include/asm/system_64.h:
>
> #define flushi(addr)    __asm__ __volatile__ ("flush %0" : : "r" (addr)
> : "memory")
>

I don't know how SPARC and PPC work, but does that really work on SMP 
(or even NUMA) machines?

David Daney
