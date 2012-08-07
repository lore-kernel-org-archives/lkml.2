Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2HGKY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 06:24:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37829 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2HGKYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 06:24:25 -0400
Message-ID: <5020ECF2.4040006@gmail.com>
Date: Tue, 07 Aug 2012 12:24:50 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Avi Kivity <avi@redhat.com>, paulmck@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mingo@kernel.org, a.p.zijlstra@chello.nl, prarit@redhat.com,
        tglx@linutronix.de, Dave Jones <davej@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: rcu: INFO: rcu_preempt detected stalls on CPUs/tasks on v3.6
References: <500ED719.2010002@gmail.com> <50112D3B.4020201@redhat.com> <50127B16.5040401@gmail.com> <50153138.4020304@redhat.com> <5015A5A8.7030601@gmail.com> <50161D5E.4030009@redhat.com> <50165046.9020705@gmail.com> <501654D3.7020504@redhat.com> <50168162.4010508@gmail.com> <50168981.3000001@redhat.com> <501EA58D.4090606@gmail.com> <501FFD2A.4010905@us.ibm.com> <50200AEF.5080904@us.ibm.com> <50200CE6.70009@gmail.com> <5020AA44.7010107@us.ibm.com>
In-Reply-To: <5020AA44.7010107@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 07:40 AM, John Stultz wrote:
> On 08/06/2012 11:28 AM, Sasha Levin wrote:
>> On 08/06/2012 08:20 PM, John Stultz wrote:
>>> On 08/06/2012 10:21 AM, John Stultz wrote:
>>>> On 08/05/2012 09:55 AM, Sasha Levin wrote:
>>>>> On 07/30/2012 03:17 PM, Avi Kivity wrote:
>>>>>> Possible causes:
>>>>>>    - the APIC calibration in the guest failed, so it is programming too
>>>>>> low values into the timer
>>>>>>    - it actually needs 1 us wakeups and then can't keep up (esp. as kvm
>>>>>> interrupt injection is slowing it down)
>>>>>>
>>>>>> You can try to find out by changing
>>>>>> arch/x86/kvm/lapic.c:start_lapic_timer() to impose a minimum wakeup of
>>>>>> (say) 20 microseconds which will let the guest live long enough for you
>>>>>> to ftrace it and see what kind of timers it is programming.
>>>>> I've kept trying to narrow it down, and found out It's triggerable using adjtimex().
>>> Sorry, one more question: Could you provide details on how is it trigger-able using adjtimex?
>> It triggers after a while of fuzzing using trinity of just adjtimex ('./trinity --quiet -l off -cadjtimex').
>>
>> Trinity is available here: http://git.codemonkey.org.uk/?p=trinity.git .
>>
>> Let me know if I can help further with reproducing this, I can probably copy over my testing environment to some other host if you'd like.
> 
> Ok. Finally I *think* got it reproduced.  (Had some trouble initially, as I think since the first time I ran it as a normal user, the socket cache isn't the same as if you run it the first time as root? Anyway, after doing a make clean and rebuilding it started to trigger).
> 
> I'm not seeing the rcu stall message, but I do manage to trigger two other behaviors: a hard hang and a sort of zombie state where memory isn't properly being freed & everything starts segfaulting.   So this may not be the exact same issue, but it triggers quickly as you described (within a few seconds of running trinity as root).
> 
> It looks like both of these issues are caused by adjtimex(ADJ_SETOFFSET), which  adds or subtracts a huge offset and that either goes negative or gets clamped to a ktime_t at KTIME_MAX (if you get clamped the system hangs, if it goes negative, the system barely functions, but sort of drags along).
> 
> An updated version of my KTIME_MAX sanity checking patch to handle both of these conditions is below.
> 
> Would you mind giving this patch a shot and letting me know if you still see problems?

This fixes the problem for me. Thanks!
