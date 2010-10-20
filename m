Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0JTPSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:18:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:7147 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab0JTPSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:18:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,355,1283756400"; 
   d="scan'208";a="669173649"
Message-ID: <4CBF0854.6080903@linux.intel.com>
Date: Wed, 20 Oct 2010 08:18:44 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
CC: Venkatesh Pallipadi <venki@google.com>, peterz@infradead.org,
        lenb@kernel.org, suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [RFC V1] cpuidle: add idle routine registration and cleanup pm_idle
 pointer
References: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com> <4CBDE5AB.4040401@linux.intel.com> <AANLkTi=cetw_mdp_3s+T4OxTfcMT2u4cdVPKxOp7jbVU@mail.gmail.com> <4CBDEB14.2030304@linux.vnet.ibm.com> <4CBF06D5.7020508@linux.vnet.ibm.com>
In-Reply-To: <4CBF06D5.7020508@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/20/2010 8:12 AM, Trinabh Gupta wrote:
>
>
> On 10/20/2010 12:31 AM, Trinabh Gupta wrote:
>>
>>
>> On 10/20/2010 12:19 AM, Venkatesh Pallipadi wrote:
>>> On Tue, Oct 19, 2010 at 11:38 AM, Arjan van de Ven
>>> <arjan@linux.intel.com> wrote:
>>>> On 10/19/2010 11:36 AM, Trinabh Gupta wrote:
>>>>>
>>>>> The core of the kernel's idle routine on x86 presently depends on an
>>>>> exported pm_idle function pointer that is unmanaged and causing
>>>>> hazard to various subsystems when they save and restore it.
>>>>> The first problem is that this exported pointer can be 
>>>>> modified/flipped
>>>>> by any subsystem. There is no tracking or notification mechanism.
>>>>> Secondly and more importantly, various subsystems save the value of
>>>>> this pointer, flip it and later restore to the saved value. There is
>>>>> no guarantee that the saved value is still valid. The problem has
>>>>> been discussed in [2,3] and Peter Zijlstra suggested removing pm_idle
>>>>> and implementing a list based registration [1].
>>>>>
>>>>> This patch is an initial RFC implementation for x86 architecture
>>>>> only. This framework can be generalised for other archs and also
>>>>> include the current cpuidle framework for managing multiple idle
>>>>> routines.
>>>>>
>>>>> Tests done with the patch:
>>>>> ------------------------
>>>>> 1. Build (on 2.6.36-rc7) and booted on x86 with C1E as deepest idle
>>>>> state and current_idle was selected to be mwait_idle.
>>>>>
>>>>> 2. Build (on 2.5.36-rc8) and booted on x86 (Nehalem) with ACPI C3 as
>>>>> deepest sleep state. The current_idle was selected to be
>>>>> cpuidle_idle_call which is the cpuidle subsystem that will further
>>>>> select idle routines from {C1,C2,C3}.
>>>>>
>>>>> Future implementation will try to eliminate this hirearchy and have
>>>>> a single registration and menu/idle cpuidle governor for selection
>>>>> of idle routine.
>>>>
>>>>
>>>> looks like you're duplicating the cpuidle subsystem
>>>>
>>>> how about biting the bullet and just always and only use the cpuidle
>>>> subsystem for all idle on x86 ?
>>>>
>>>
>>> I agree with Arjan.
>>> If we have a default_cpuidle driver which parses idle= params, handles
>>> various mwait quirks in x86 process*.c and registers with cpuidle, we
>>> can then always call cpuidle idle routine on x86.
>>
>> This wouldn't duplicate code. It would move parts/functionality of
>> cpuidle into the kernel, keeping governors alone as modules.
>>
>> If we directly call cpuidle_idle_call() then this may be too much
>> overhead for architectures that have single idle routine i.e cases where
>> cpuidle is not used and will be seen as a bloat. (c.f goals 4a,b).
>
> Hi Venki, Arjan
>
> Building cpuidle into the kernel would add ~7KB for everyone, even
> x86 architectures having only single idle state/routine.

but now you're duplicating this functionality adding code for everyone.

99.999% of the people today run cpuidle... (especially embedded x86 
where they really care about power)
all x86 going forward also has > 1 idle option anyway.

and you're adding and extra layer in the middle that just duplicates the 
layer that's in use in practice above it.

seriously, this sounds like the wrong tradeoff to make.

