Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab2IYNww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:52:52 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55980 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2IYNwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:52:50 -0400
Message-ID: <5061B64F.9010706@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2012 19:19:03 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
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
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <5060851E.1030404@redhat.com> <506166B4.4010207@linux.vnet.ibm.com> <5061713D.5060406@redhat.com>
In-Reply-To: <5061713D.5060406@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092513-6102-0000-0000-0000024A14D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 02:24 PM, Avi Kivity wrote:
> On 09/25/2012 10:09 AM, Raghavendra K T wrote:
>> On 09/24/2012 09:36 PM, Avi Kivity wrote:
>>> On 09/24/2012 05:41 PM, Avi Kivity wrote:
>>>>
>>>>>
>>>>> case 2)
>>>>> rq1 : vcpu1->wait(lockA) (spinning)
>>>>> rq2 : vcpu3 (running) ,  vcpu2->holding(lockA) [scheduled out]
>>>>>
>>>>> I agree that checking rq1 length is not proper in this case, and as
>>>>> you
>>>>> rightly pointed out, we are in trouble here.
>>>>> nr_running()/num_online_cpus() would give more accurate picture here,
>>>>> but it seemed costly. May be load balancer save us a bit here in not
>>>>> running to such sort of cases. ( I agree load balancer is far too
>>>>> complex).
>>>>
>>>> In theory preempt notifier can tell us whether a vcpu is preempted or
>>>> not (except for exits to userspace), so we can keep track of whether
>>>> it's we're overcommitted in kvm itself.  It also avoids false positives
>>>> from other guests and/or processes being overcommitted while our vm
>>>> is fine.
>>>
>>> It also allows us to cheaply skip running vcpus.
>>
>> Hi Avi,
>>
>> Could you please elaborate on how preempt notifiers can be used
>> here to keep track of overcommit or skip running vcpus?
>>
>> Are we planning set some flag in sched_out() handler etc?
>>
>
> Keep a bitmap kvm->preempted_vcpus.
>
> In sched_out, test whether we're TASK_RUNNING, and if so, set a vcpu
> flag and our bit in kvm->preempted_vcpus.  On sched_in, if the flag is
> set, clear our bit in kvm->preempted_vcpus.  We can also keep a counter
> of preempted vcpus.
>
> We can use the bitmap and the counter to quickly see if spinning is
> worthwhile (if the counter is zero, better to spin).  If not, we can use
> the bitmap to select target vcpus quickly.
>
> The only problem is that in order to keep this accurate we need to keep
> the preempt notifiers active during exits to userspace.  But we can
> prototype this without this change, and add it later if it works.
>

Avi, Thanks for the idea.. I want to try this some time soon.

So ideally it means if we are under-committed the counter/ bitmap
effective value is zero.

