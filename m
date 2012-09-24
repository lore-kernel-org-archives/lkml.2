Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2IXImm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:42:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2IXImj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:42:39 -0400
Message-ID: <50601CE7.60801@redhat.com>
Date: Mon, 24 Sep 2012 10:42:15 +0200
From: Dor Laor <dlaor@redhat.com>
Reply-To: dlaor@redhat.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Chegu Vinod <chegu_vinod@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <505C691D.4080801@hp.com> <505CA5BA.4020801@linux.vnet.ibm.com>
In-Reply-To: <505CA5BA.4020801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to help PLE and pvticketlock converge I thought that a small 
test code should be developed to test this in a predictable, 
deterministic way.

The idea is to have a guest kernel module that spawn a new thread each 
time you write to a /sys/.... entry.

Each such a thread spins over a spin lock. The specific spin lock is 
also chosen by the /sys/ interface. Let's say we have an array of spin 
locks *10 times the amount of vcpus.

All the threads are running a
  while (1) {

    spin_lock(my_lock);
    sum += execute_dummy_cpu_computation(time);
    spin_unlock(my_lock);

    if (sys_tells_thread_to_die()) break;
  }

  print_result(sum);

Instead of calling the kernel's spin_lock functions, clone them and make 
the ticket lock order deterministic and known (like a linear walk of all 
the threads trying to catch that lock).

This way you can easy calculate:
  1. the score of a single vcpu running a single thread
  2. the score of sum of all thread scores when #thread==#vcpu all
     taking the same spin lock. The overall sum should be close as
     possible to #1.
  3. Like #2 but #threads > #vcpus and other versions of #total vcpus
     (belonging to all VMs)  > #pcpus.
  4. Create #thread == #vcpus but let each thread have it's own spin
     lock
  5. Like 4 + 2

Hopefully this way will allows you to judge and evaluate the exact 
overhead of scheduling VMs and threads since you have the ideal result 
in hand and you know what the threads are doing.

My 2 cents, Dor

On 09/21/2012 08:36 PM, Raghavendra K T wrote:
> On 09/21/2012 06:48 PM, Chegu Vinod wrote:
>> On 9/21/2012 4:59 AM, Raghavendra K T wrote:
>>> In some special scenarios like #vcpu <= #pcpu, PLE handler may
>>> prove very costly,
>>
>> Yes.
>>> because there is no need to iterate over vcpus
>>> and do unsuccessful yield_to burning CPU.
>>>
>>> An idea to solve this is:
>>> 1) As Avi had proposed we can modify hardware ple_window
>>> dynamically to avoid frequent PL-exit.
>>
>> Yes. We had to do this to get around some scaling issues for large
>> (>20way) guests (with no overcommitment)
>
> Do you mean you already have some solution tested for this?
>
>>
>> As part of some experimentation we even tried "switching off" PLE too :(
>>
>
> Honestly,
> Your this experiment and Andrew Theurer's observations were the
> motivation for this patch.
>
>>
>>
>>> (IMHO, it is difficult to
>>> decide when we have mixed type of VMs).
>>
>> Agree.
>>
>> Not sure if the following alternatives have also been looked at :
>>
>> - Could the behavior associated with the "ple_window" be modified to be
>> a function of some [new] per-guest attribute (which can be conveyed to
>> the host as part of the guest launch sequence). The user can choose to
>> set this [new] attribute for a given guest. This would help avoid the
>> frequent exits due to PLE (as Avi had mentioned earlier) ?
>
> Ccing Drew also. We had a good discussion on this idea last time.
> (sorry that I forgot to include in patch series)
>
> May be a good idea when we know the load in advance..
>
>>
>> - Can the PLE feature ( in VT) be "enhanced" to be made a per guest
>> attribute ?
>>
>>
>> IMHO, the approach of not taking a frequent exit is better than taking
>> an exit and returning back from the handler etc.
>
> I entirely agree on this point. (though have not tried above
> approaches). Hope to see more expert opinions pouring in.
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

