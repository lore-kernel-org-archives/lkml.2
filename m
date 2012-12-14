Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab2LNByu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:54:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:13782 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab2LNBys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:54:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,277,1355126400"; 
   d="scan'208";a="263798361"
Message-ID: <50CA8746.5050604@intel.com>
Date: Fri, 14 Dec 2012 09:56:22 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Alex Shi <lkml.alex@gmail.com>, rob@landley.net, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        vincent.guittot@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into
 LB and power awareness scheduling
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com> <50C722AC.3080806@intel.com> <20121211154819.GC8873@liondog.tnic> <50C75935.1040004@linux.intel.com> <20121211161320.GA28827@liondog.tnic> <50C76208.107@linux.intel.com> <20121212144140.GD8760@liondog.tnic> <50C9467F.3020205@intel.com> <20121213113549.GB31485@liondog.tnic>
In-Reply-To: <20121213113549.GB31485@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 07:35 PM, Borislav Petkov wrote:
> On Thu, Dec 13, 2012 at 11:07:43AM +0800, Alex Shi wrote:
>>>> now, on the other hand, if you have two threads of a process that
>>>> share a bunch of data structures, and you'd spread these over 2
>>>> sockets, you end up bouncing data between the two sockets a lot,
>>>> running inefficient --> bad for power.
>>>
>>> Yeah, that should be addressed by the NUMA patches people are
>>> working on right now.
>>
>> Yes, as to balance/powersaving policy, we can tight pack tasks
>> firstly, then NUMA balancing will make memory follow us.
>>
>> BTW, NUMA balancing is more related with page in memory. not LLC.
> 
> Sure, let's look at the worst and best cases:
> 
> * worst case: you have memory shared by multiple threads on one node
> *and* working set doesn't fit in LLC.
> 
> Here, if you pack threads tightly only on one node, you still suffer the
> working set kicking out parts of itself out of LLC.
> 
> If you spread threads around, you still cannot avoid the LLC thrashing
> because the LLC of the node containing the shared memory needs to cache
> all those transactions. *In* *addition*, you get the cross-node traffic
> because the shared pages are on the first node.
> 
> Major suckage.
> 
> Does it matter? I don't know. It can be decided on a case-by-case basis.
> If people care about singlethread perf, they would likely want to spread
> around and buy in the cross-node traffic.
> 
> If they care for power, then maybe they don't want to turn on the second
> socket yet.
> 
> * the optimal case is where memory follows threads and gets spread
> around such that LLC doesn't get thrashed and cross-node traffic gets
> avoided.
> 
> Now, you can think of all those other scenarios in between :-/

You are right. thanks for explanation! :)

Actually, what I went to say is that numa balancing target is pages in
different node memory, but of course, it may improve LLC performance.
> 
> Thanks.
> 

