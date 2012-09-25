Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2IYHj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:39:56 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:51819 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2IYHjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:39:54 -0400
Message-ID: <50615EE4.1040809@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2012 13:06:04 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com>
In-Reply-To: <50607F1F.2040704@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092507-7014-0000-0000-000001F123FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 09:11 PM, Avi Kivity wrote:
> On 09/21/2012 08:24 PM, Raghavendra K T wrote:
>> On 09/21/2012 06:32 PM, Rik van Riel wrote:
>>> On 09/21/2012 08:00 AM, Raghavendra K T wrote:
>>>> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>>>
>>>> When total number of VCPUs of system is less than or equal to physical
>>>> CPUs,
>>>> PLE exits become costly since each VCPU can have dedicated PCPU, and
>>>> trying to find a target VCPU to yield_to just burns time in PLE handler.
>>>>
>>>> This patch reduces overhead, by simply doing a return in such
>>>> scenarios by
>>>> checking the length of current cpu runqueue.
>>>
>>> I am not convinced this is the way to go.
>>>
>>> The VCPU that is holding the lock, and is not releasing it,
>>> probably got scheduled out. That implies that VCPU is on a
>>> runqueue with at least one other task.
>>
>> I see your point here, we have two cases:
>>
>> case 1)
>>
>> rq1 : vcpu1->wait(lockA) (spinning)
>> rq2 : vcpu2->holding(lockA) (running)
>>
>> Here Ideally vcpu1 should not enter PLE handler, since it would surely
>> get the lock within ple_window cycle. (assuming ple_window is tuned for
>> that workload perfectly).
>>
>> May be this explains why we are not seeing benefit with kernbench.
>>
>> On the other side, Since we cannot have a perfect ple_window tuned for
>> all type of workloads, for those workloads, which may need more than
>> 4096 cycles, we gain. thinking is it that we are seeing in benefited
>> cases?
>
> Maybe we need to increase the ple window regardless.  4096 cycles is 2
> microseconds or less (call it t_spin).  The overhead from
> kvm_vcpu_on_spin() and the associated task switches is at least a few
> microseconds, increasing as contention is added (call it t_tield).  The
> time for a natural context switch is several milliseconds (call it
> t_slice).  There is also the time the lock holder owns the lock,
> assuming no contention (t_hold).
>
> If t_yield>  t_spin, then in the undercommitted case it dominates
> t_spin.  If t_hold>  t_spin we lose badly.
>
> If t_spin>  t_yield, then the undercommitted case doesn't suffer as much
> as most of the spinning happens in the guest instead of the host, so it
> can pick up the unlock timely.  We don't lose too much in the
> overcommitted case provided the values aren't too far apart (say a
> factor of 3).
>
> Obviously t_spin must be significantly smaller than t_slice, otherwise
> it accomplishes nothing.
>
> Regarding t_hold: if it is small, then a larger t_spin helps avoid false
> exits.  If it is large, then we're not very sensitive to t_spin.  It
> doesn't matter if it takes us 2 usec or 20 usec to yield, if we end up
> yielding for several milliseconds.
>
> So I think it's worth trying again with ple_window of 20000-40000.
>

Agree that spinning is not costly and  I have tried increasing
ple_window earlier. I 'll give one more shot.

I was thinking, unnessary spinning of vcpus (spinning when lockholder
is preempted), add up to degradation significantly, especially in
ticketlock scenario is more problemtic. no?

