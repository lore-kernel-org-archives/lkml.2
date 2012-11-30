Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab2K3FGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:06:08 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38715 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2K3FGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:06:05 -0500
Message-ID: <50B83E64.1010907@linux.vnet.ibm.com>
Date: Fri, 30 Nov 2012 10:34:36 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH V3 RFC 2/2] kvm: Handle yield_to failure return code for
 potential undercommit case
References: <20121126120740.2595.33651.sendpatchset@codeblue> <20121126120804.2595.20280.sendpatchset@codeblue> <20121128011228.GH8295@amt.cnet> <50B59CE0.70305@linux.vnet.ibm.com> <20121129121636.GB9711@redhat.com>
In-Reply-To: <20121129121636.GB9711@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12113005-2674-0000-0000-000006EE4E1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 05:46 PM, Gleb Natapov wrote:
> On Wed, Nov 28, 2012 at 10:40:56AM +0530, Raghavendra K T wrote:
>> On 11/28/2012 06:42 AM, Marcelo Tosatti wrote:
>>>
>>> Don't understand the reasoning behind why 3 is a good choice.
>>
>> Here is where I came from. (explaining from scratch for
>> completeness, forgive me :))
>> In moderate overcommits, we can falsely exit from ple handler even when
>> we have preempted task of same VM waiting on other cpus. To reduce this
>> problem, we try few times before exiting.
>> The problem boils down to:
>> what is the probability that we exit ple handler even when we have more
>> than 1 task in other cpus. Theoretical worst case should be around 1.5x
>> overcommit (As also pointed by Andrew Theurer). [But practical
>> worstcase may be around 2x,3x overcommits as indicated by the results
>> for the patch series]
>>
>> So if p is the probability of finding rq length one on a particular cpu,
>> and if we do n tries, then probability of exiting ple handler is:
>>
>>   p^(n+1) [ because we would have come across one source with rq length
>> 1 and n target cpu rqs  with length 1 ]
>>
>> so
>> num tries:         probability of aborting ple handler (1.5x overcommit)
>>   1                 1/4
>>   2                 1/8
>>   3                 1/16
>>
>> We can increase this probability with more tries, but the problem is
>> the overhead.
> IIRC Avi (again) had an idea to track vcpu preemption. When vcpu thread
> is preempted we do kvm->preempted_vcpus++, when it runs again we do
> kvm->preempted_vcpus--. PLE handler can try harder if kvm->preempted_vcpus
> is big or do not try at all if it is zero.

Thanks for the reply Gleb.

Yes.. It was on my next TODO as you know and it make sense to weigh all 
these approaches (undercommit patches/throttled yield/preempt
notifier/pvspinlock and their combination) to good extent before going 
further. I am happy if these patches are now in 'good shape to compare'
state. (same reason I had posted dynamic PLE appaoch too).




