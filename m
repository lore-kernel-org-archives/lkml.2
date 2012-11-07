Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2KGEhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 23:37:35 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47310 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab2KGEhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 23:37:34 -0500
MIME-Version: 1.0
In-Reply-To: <1352207399-29497-3-git-send-email-alex.shi@intel.com>
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
	<1352207399-29497-3-git-send-email-alex.shi@intel.com>
Date: Wed, 7 Nov 2012 10:07:33 +0530
Message-ID: <CAM4v1pMLkzN5Fhmkb8brExh=OxMZ_YrvLnsZGEpG+AtBB8UDDQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] sched: power aware load balance,
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, cl@linux.com,
        pjt@google.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

What I am concerned about in this patchset as Peter also
mentioned in the previous discussion of your approach
(https://lkml.org/lkml/2012/8/13/139)
is that:

1.Using nr_running of two different sched groups to decide which one
can be group_leader or group_min might not be be the right approach,
as this might mislead us to think that a group running one task is less
loaded than the group running three tasks although the former task is
a cpu hogger.

2.Comparing the number of cpus with the number of tasks running in a sched
group to decide if the group is underloaded or overloaded again faces
the same issue.The tasks might be short running,not utilizing cpu much.

I also feel before we introduce another side to the scheduler called
'power aware',why not try and see if the current scheduler itself can
perform better? We have an opportunity in terms of PJT's patches which
can help scheduler make more realistic decisions in load balance.Also
since PJT's metric is a statistical one,I believe we could vary it to
allow scheduler to do more rigorous or less rigorous power savings.

It is true however that this approach will not try and evacuate nearly idle
cpus over to nearly full cpus.That is definitely one of the benefits of your
patch,in terms of power savings,but I believe your patch is not making use
of the right metric to decide that.

IMHO,the appraoch towards power aware scheduler should take the following steps:

1.Make use of PJT's per-entity-load tracking metric to allow scheduler to make
more intelligent decisions in load balancing.Test the performance and power save
numbers.

2.If the above shows some characteristic change in behaviour over the earlier
scheduler,it should be either towards power save or towards performance.If found
positive towards one of them, try varying the calculation of
per-entity-load to see
if it can lean towards the other behaviour.If it can,then there you
go,you have a
knob to change between policies right there!

3.If you don't get enough power savings with the above approach then
add your patchset
to evacuate nearly idle towards nearly busy groups,but by using PJT's metric to
make the decision.

What do you think?

Regards
Preeti U Murthy
On Tue, Nov 6, 2012 at 6:39 PM, Alex Shi <alex.shi@intel.com> wrote:
> This patch enabled the power aware consideration in load balance.
>
> As mentioned in the power aware scheduler proposal, Power aware
> scheduling has 2 assumptions:
> 1, race to idle is helpful for power saving
> 2, shrink tasks on less sched_groups will reduce power consumption
>
> The first assumption make performance policy take over scheduling when
> system busy.
> The second assumption make power aware scheduling try to move
> disperse tasks into fewer groups until that groups are full of tasks.
>
> This patch reuse lots of Suresh's power saving load balance code.
> Now the general enabling logical is:
> 1, Collect power aware scheduler statistics with performance load
> balance statistics collection.
> 2, if domain is eligible for power load balance do it and forget
> performance load balance, else do performance load balance.
>
> Has tried on my 2 sockets * 4 cores * HT NHM EP machine.
> and 2 sockets * 8 cores * HT SNB EP machine.
> In the following checking, when I is 2/4/8/16, all tasks are
> shrank to run on single core or single socket.
>
> $for ((i=0; i < I; i++)) ; do while true; do : ; done & done
>
> Checking the power consuming with a powermeter on the NHM EP.
>         powersaving     performance
> I = 2   148w            160w
> I = 4   175w            181w
> I = 8   207w            224w
> I = 16  324w            324w
>
> On a SNB laptop(4 cores *HT)
>         powersaving     performance
> I = 2   28w             35w
> I = 4   38w             52w
> I = 6   44w             54w
> I = 8   56w             56w
>
> On the SNB EP machine, when I = 16, power saved more than 100 Watts.
>
> Also tested the specjbb2005 with jrockit, kbuild, their peak performance
> has no clear change with powersaving policy on all machines. Just
> specjbb2005 with openjdk has about 2% drop on NHM EP machine with
> powersaving policy.
>
> This patch seems a bit long, but seems hard to split smaller.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
