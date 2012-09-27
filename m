Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab2I0KZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:25:28 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51485 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab2I0KZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:25:26 -0400
Message-ID: <506428B1.9040007@linux.vnet.ibm.com>
Date: Thu, 27 Sep 2012 15:51:37 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com> <1348490165.11847.58.camel@twins> <20120926125727.GA7633@turtle.usersys.redhat.com>
In-Reply-To: <20120926125727.GA7633@turtle.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092710-5816-0000-0000-000004A4BA58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 06:27 PM, Andrew Jones wrote:
> On Mon, Sep 24, 2012 at 02:36:05PM +0200, Peter Zijlstra wrote:
>> On Mon, 2012-09-24 at 17:22 +0530, Raghavendra K T wrote:
>>> On 09/24/2012 05:04 PM, Peter Zijlstra wrote:
>>>> On Fri, 2012-09-21 at 17:29 +0530, Raghavendra K T wrote:
>>>>> In some special scenarios like #vcpu<= #pcpu, PLE handler may
>>>>> prove very costly, because there is no need to iterate over vcpus
>>>>> and do unsuccessful yield_to burning CPU.
>>>>
>>>> What's the costly thing? The vm-exit, the yield (which should be a nop
>>>> if its the only task there) or something else entirely?
>>>>
>>> Both vmexit and yield_to() actually,
>>>
>>> because unsuccessful yield_to() overall is costly in PLE handler.
>>>
>>> This is because when we have large guests, say 32/16 vcpus, and one
>>> vcpu is holding lock, rest of the vcpus waiting for the lock, when they
>>> do PL-exit, each of the vcpu try to iterate over rest of vcpu list in
>>> the VM and try to do directed yield (unsuccessful). (O(n^2) tries).
>>>
>>> this results is fairly high amount of cpu burning and double run queue
>>> lock contention.
>>>
>>> (if they were spinning probably lock progress would have been faster).
>>> As Avi/Chegu Vinod had felt it is better to avoid vmexit itself, which
>>> seems little complex to achieve currently.
>>
>> OK, so the vmexit stays and we need to improve yield_to.
>
> Can't we do this check sooner as well, as it only requires per-cpu data?
> If we do it way back in kvm_vcpu_on_spin, then we avoid get_pid_task()
> and a bunch of read barriers from kvm_for_each_vcpu. Also, moving the test
> into kvm code would allow us to do other kvm things as a result of the
> check in order to avoid some vmexits. It looks like we should be able to
> avoid some without much complexity by just making a per-vm ple_window
> variable, and then, when we hit the nr_running == 1 condition, also doing
> vmcs_write32(PLE_WINDOW, (kvm->ple_window += PLE_WINDOW_BUMP))
> Reset the window to the default value when we successfully yield (and
> maybe we should limit the number of bumps).

We indeed checked early in original undercommit patch and it has given
result closer to PLE disabled case. But Agree with Peter that it is ugly 
to export nr_running info to ple handler.

Looking at the result and comparing result of A and C,
> Base = 3.6.0-rc5 + ple handler optimization patches
> A = Base + checking rq_running in vcpu_on_spin() patch
> B = Base + checking rq->nr_running in sched/core
> C = Base - PLE
>
>    % improvements w.r.t BASE
> ---+------------+------------+------------+
>    |      A     |    B       |     C      |
> ---+------------+------------+------------+
> 1x | 206.37603  |  139.70410 |  210.19323 |

I have a feeling that vmexit has not caused significant overhead
compared to iterating over vcpus in PLE handler.. Does it not sound so?

But
> vmcs_write32(PLE_WINDOW, (kvm->ple_window += PLE_WINDOW_BUMP))

is worth trying. I will have to see it eventually.





