Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab2GCDcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 23:32:39 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46225 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2GCDch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 23:32:37 -0400
Message-ID: <4FF26765.5040508@linux.vnet.ibm.com>
Date: Tue, 03 Jul 2012 09:00:45 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, "Vinod, Chegu" <chegu_vinod@hp.com>
CC: Andrew Jones <drjones@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case
References: <168f205d-d65f-4864-99c8-363b12818a9b@zmail17.collab.prod.int.phx2.redhat.com> <4FEC84BD.6030304@linux.vnet.ibm.com> <C4FA8004DBDF864387014E5EA4383B0F580BD0F5E7@GVW1336EXC.americas.hpqcorp.net> <4FF1B4E4.2010801@redhat.com>
In-Reply-To: <4FF1B4E4.2010801@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12070217-0260-0000-0000-000001710F7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 08:19 PM, Rik van Riel wrote:
> On 06/28/2012 06:55 PM, Vinod, Chegu wrote:
>> Hello,
>>
>> I am just catching up on this email thread...
>>
>> Perhaps one of you may be able to help answer this query.. preferably
>> along with some data. [BTW, I do understand the basic intent behind
>> PLE in a typical [sweet spot] use case where there is over
>> subscription etc. and the need to optimize the PLE handler in the host
>> etc. ]
>>
>> In a use case where the host has fewer but much larger guests (say
>> 40VCPUs and higher) and there is no over subscription (i.e. # of vcpus
>> across guests<= physical cpus in the host and perhaps each guest has
>> their vcpu's pinned to specific physical cpus for other reasons), I
>> would like to understand if/how the PLE really helps ? For these use
>> cases would it be ok to turn PLE off (ple_gap=0) since is no real need
>> to take an exit and find some other VCPU to yield to ?
>
> Yes, that should be ok.

I think this should be true when we have ple_window tuned to correct
value for guest. (same what you raised)

But otherwise, IMO, it is a very tricky question to answer. PLE is
currently benefiting even flush_tlb_ipi etc apart from spinlock. Having
a properly tuned value for all types of workload, (+load) is really
complicated.
Coming back to ple_handler, IMHO, if we have slight increase in
run_queue length, having directed yield may worsen the scenario.

(In the case Vinod explained, even-though we will succeed in setting
other vcpu task as next_buddy, caller itself gets scheduled out, so
ganging effect reduces. on top of this we always have a question, have 
we chosen right guy OR a really bad guy for yielding.)

>
> On a related note, I wonder if we should increase the ple_gap
> significantly.

Did you mean ple_window?

>
> After all, 4096 cycles of spinning is not that much, when you
> consider how much time is spent doing the subsequent vmexit,
> scanning the other VCPU's status (200 cycles per cache miss),
> deciding what to do, maybe poking another CPU, and eventually
> a vmenter.
>
> A factor 4 increase in ple_gap might be what it takes to
> get the amount of time spent spinning equal to the amount of
> time spent on the host side doing KVM stuff...
>

I agree, I am experimenting with all these things left and right, along
with several optimization ideas I have. Hope to comeback on the
experiments soon.

