Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0JTPM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:12:28 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37574 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0JTPM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:12:27 -0400
Message-ID: <4CBF06D5.7020508@linux.vnet.ibm.com>
Date: Wed, 20 Oct 2010 20:42:21 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>, peterz@infradead.org
CC: lenb@kernel.org, suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [RFC V1] cpuidle: add idle routine registration and cleanup pm_idle
 pointer
References: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com> <4CBDE5AB.4040401@linux.intel.com> <AANLkTi=cetw_mdp_3s+T4OxTfcMT2u4cdVPKxOp7jbVU@mail.gmail.com> <4CBDEB14.2030304@linux.vnet.ibm.com>
In-Reply-To: <4CBDEB14.2030304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/20/2010 12:31 AM, Trinabh Gupta wrote:
>
>
> On 10/20/2010 12:19 AM, Venkatesh Pallipadi wrote:
>> On Tue, Oct 19, 2010 at 11:38 AM, Arjan van de Ven
>> <arjan@linux.intel.com> wrote:
>>> On 10/19/2010 11:36 AM, Trinabh Gupta wrote:
>>>>
>>>> The core of the kernel's idle routine on x86 presently depends on an
>>>> exported pm_idle function pointer that is unmanaged and causing
>>>> hazard to various subsystems when they save and restore it.
>>>> The first problem is that this exported pointer can be modified/flipped
>>>> by any subsystem. There is no tracking or notification mechanism.
>>>> Secondly and more importantly, various subsystems save the value of
>>>> this pointer, flip it and later restore to the saved value. There is
>>>> no guarantee that the saved value is still valid. The problem has
>>>> been discussed in [2,3] and Peter Zijlstra suggested removing pm_idle
>>>> and implementing a list based registration [1].
>>>>
>>>> This patch is an initial RFC implementation for x86 architecture
>>>> only. This framework can be generalised for other archs and also
>>>> include the current cpuidle framework for managing multiple idle
>>>> routines.
>>>>
>>>> Tests done with the patch:
>>>> ------------------------
>>>> 1. Build (on 2.6.36-rc7) and booted on x86 with C1E as deepest idle
>>>> state and current_idle was selected to be mwait_idle.
>>>>
>>>> 2. Build (on 2.5.36-rc8) and booted on x86 (Nehalem) with ACPI C3 as
>>>> deepest sleep state. The current_idle was selected to be
>>>> cpuidle_idle_call which is the cpuidle subsystem that will further
>>>> select idle routines from {C1,C2,C3}.
>>>>
>>>> Future implementation will try to eliminate this hirearchy and have
>>>> a single registration and menu/idle cpuidle governor for selection
>>>> of idle routine.
>>>
>>>
>>> looks like you're duplicating the cpuidle subsystem
>>>
>>> how about biting the bullet and just always and only use the cpuidle
>>> subsystem for all idle on x86 ?
>>>
>>
>> I agree with Arjan.
>> If we have a default_cpuidle driver which parses idle= params, handles
>> various mwait quirks in x86 process*.c and registers with cpuidle, we
>> can then always call cpuidle idle routine on x86.
>
> This wouldn't duplicate code. It would move parts/functionality of
> cpuidle into the kernel, keeping governors alone as modules.
>
> If we directly call cpuidle_idle_call() then this may be too much
> overhead for architectures that have single idle routine i.e cases where
> cpuidle is not used and will be seen as a bloat. (c.f goals 4a,b).

Hi Venki, Arjan

Building cpuidle into the kernel would add ~7KB for everyone, even
x86 architectures having only single idle state/routine. Andi Kleen had
pointed this out before. Please see http://lkml.org/lkml/2009/10/12/421.

% size drivers/cpuidle/built-in.o
text    data     bss     dec     hex filename
6054    1288      44    7386    1cda drivers/cpuidle/built-in.o

One solution is to move some of the functionality into the
kernel and keep governors as module. Currently this prototype
adds ~ 0.5KB and also does more robust management of idle routines.
The bottom line is that pm_idle needs to be removed one way or
the other.

% size arch/x86/kernel/built-in.o
ext    data     bss     dec     hex filename
Without this patch:
341328  445821  507713 1294862  13c20e arch/x86/kernel/built-in.o
With this patch:
341732  445885  507713 1295330  13c3e2 arch/x86/kernel/built-in.o
Increase: 468 Bytes

Thanks,
-Trinabh
