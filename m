Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2KGN1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 08:27:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:2610 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab2KGN1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 08:27:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,730,1344236400"; 
   d="scan'208";a="245293083"
Message-ID: <509A61B0.2040105@intel.com>
Date: Wed, 07 Nov 2012 21:27:12 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti Murthy <preeti.lkml@gmail.com>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, cl@linux.com,
        pjt@google.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: power aware load balance,
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com> <1352207399-29497-3-git-send-email-alex.shi@intel.com> <CAM4v1pMLkzN5Fhmkb8brExh=OxMZ_YrvLnsZGEpG+AtBB8UDDQ@mail.gmail.com>
In-Reply-To: <CAM4v1pMLkzN5Fhmkb8brExh=OxMZ_YrvLnsZGEpG+AtBB8UDDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 12:37 PM, Preeti Murthy wrote:
> Hi Alex,
> 
> What I am concerned about in this patchset as Peter also
> mentioned in the previous discussion of your approach
> (https://lkml.org/lkml/2012/8/13/139)
> is that:
> 
> 1.Using nr_running of two different sched groups to decide which one
> can be group_leader or group_min might not be be the right approach,
> as this might mislead us to think that a group running one task is less
> loaded than the group running three tasks although the former task is
> a cpu hogger.
> 
> 2.Comparing the number of cpus with the number of tasks running in a sched
> group to decide if the group is underloaded or overloaded again faces
> the same issue.The tasks might be short running,not utilizing cpu much.

Yes, maybe nr task is not the best indicator. But as first step, it can
approve the proposal is a correct path and worth to try more.
Considering the old powersaving implement is also judge on nr tasks, and
my testing result of this. It may be still a option.
> 
> I also feel before we introduce another side to the scheduler called
> 'power aware',why not try and see if the current scheduler itself can
> perform better? We have an opportunity in terms of PJT's patches which
> can help scheduler make more realistic decisions in load balance.Also
> since PJT's metric is a statistical one,I believe we could vary it to
> allow scheduler to do more rigorous or less rigorous power savings.

will study the PJT's approach.
Actually, current patch set is also a kind of load balance modification,
right? :)
> 
> It is true however that this approach will not try and evacuate nearly idle
> cpus over to nearly full cpus.That is definitely one of the benefits of your
> patch,in terms of power savings,but I believe your patch is not making use
> of the right metric to decide that.

If one sched group just has one task, and another group just has one
LCPU idle, my patch definitely will pull the task to the nearly full
sched group. So I didn't understand what you mean 'will not try and
evacuate nearly idle cpus over to nearly full cpus'.


> 
> IMHO,the appraoch towards power aware scheduler should take the following steps:
> 
> 1.Make use of PJT's per-entity-load tracking metric to allow scheduler to make
> more intelligent decisions in load balancing.Test the performance and power save
> numbers.
> 
> 2.If the above shows some characteristic change in behaviour over the earlier
> scheduler,it should be either towards power save or towards performance.If found
> positive towards one of them, try varying the calculation of
> per-entity-load to see
> if it can lean towards the other behaviour.If it can,then there you
> go,you have a
> knob to change between policies right there!
> 
> 3.If you don't get enough power savings with the above approach then
> add your patchset
> to evacuate nearly idle towards nearly busy groups,but by using PJT's metric to
> make the decision.
> 
> What do you think?

Will consider this. thanks!
> 
> Regards
> Preeti U Murthy
> On Tue, Nov 6, 2012 at 6:39 PM, Alex Shi <alex.shi@intel.com> wrote:
>> This patch enabled the power aware consideration in load balance.
>>
>> As mentioned in the power aware scheduler proposal, Power aware
>> scheduling has 2 assumptions:
>> 1, race to idle is helpful for power saving
>> 2, shrink tasks on less sched_groups will reduce power consumption
>>
>> The first assumption make performance policy take over scheduling when
>> system busy.
>> The second assumption make power aware scheduling try to move
>> disperse tasks into fewer groups until that groups are full of tasks.
>>
>> This patch reuse lots of Suresh's power saving load balance code.
>> Now the general enabling logical is:
>> 1, Collect power aware scheduler statistics with performance load
>> balance statistics collection.
>> 2, if domain is eligible for power load balance do it and forget
>> performance load balance, else do performance load balance.
>>
>> Has tried on my 2 sockets * 4 cores * HT NHM EP machine.
>> and 2 sockets * 8 cores * HT SNB EP machine.
>> In the following checking, when I is 2/4/8/16, all tasks are
>> shrank to run on single core or single socket.
>>
>> $for ((i=0; i < I; i++)) ; do while true; do : ; done & done
>>
>> Checking the power consuming with a powermeter on the NHM EP.
>>         powersaving     performance
>> I = 2   148w            160w
>> I = 4   175w            181w
>> I = 8   207w            224w
>> I = 16  324w            324w
>>
>> On a SNB laptop(4 cores *HT)
>>         powersaving     performance
>> I = 2   28w             35w
>> I = 4   38w             52w
>> I = 6   44w             54w
>> I = 8   56w             56w
>>
>> On the SNB EP machine, when I = 16, power saved more than 100 Watts.
>>
>> Also tested the specjbb2005 with jrockit, kbuild, their peak performance
>> has no clear change with powersaving policy on all machines. Just
>> specjbb2005 with openjdk has about 2% drop on NHM EP machine with
>> powersaving policy.
>>
>> This patch seems a bit long, but seems hard to split smaller.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>


-- 
Thanks
    Alex
