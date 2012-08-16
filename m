Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2HPMqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:46:05 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:52009 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755302Ab2HPMpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <502C98E8.20800@linux.vnet.ibm.com>
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <502C98E8.20800@linux.vnet.ibm.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 16 Aug 2012 18:15:30 +0530
Message-ID: <CAMQu2gxKKFFNhBQ6P-dYKpXCm740de1VjcKLV5iSB03kWkUeUQ@mail.gmail.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in scheduler
To: preeti <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 12:23 PM, preeti <preeti@linux.vnet.ibm.com> wrote:
>
> Hi everyone,
>
> From what I have understood so far,I try to summarise pin pointed
> differences between the performance and power policies as found
> relevant to the scheduler-load balancing mechanism.Any thoughts?
>
> *Performance policy*:
>
> Q1.Who triggers load_balance?
> Load balance is triggered when a cpu is found to be idle.(Pull mechanism)
>
> Q2.How is load_balance handled?
> When triggered,the load is looked to be pulled from its sched domain.
> First the sched groups in the domain the cpu belongs to is queried
> followed by the runqueues in the busiest group.then the tasks are moved.
>
> This course of action is found analogous to the performance policy because:
>
> 1.First the idle cpu initiates the pull action
> 2.The busiest cpu hands over the load to this cpu.A person who can
> handle any work is querying as to who cannot handle more work.
>
> *Power policy*:
>
> So how is power policy different? As Peter says,'pack more than spread
> more'.
>
> Q1.Who triggers load balance?
> It is the cpu which cannot handle more work.Idle cpu is left to remain
> idle.(Push mechanism)
>
> Q2.How is load_balance handled?
> First the least busy runqueue,from within the sched_group that the busy
> cpu belongs to is queried.if none exist,ie all the runqueues are equally
> busy then move on to the other sched groups.
>
> Here again the 'least busy' policy should be applied,first at
> group level then at the runqueue level.
>
> This course of action is found analogous to the power policy because as
> much as possible busy and capable cpus within a small range try to
> handle the existing load.
>
Not to complicate the power policy scheme but always *packing* may
not be the best approach for all CPU packages. As mentioned, packing
ensures that least number of power domains are in use and effectively
reduce the active power consumption on paper but there are few
considerations which might conflict with this assumption.

--  Many architectures get best power saving when the entire CPU cluster
or SD is idle. Intel folks already mentioned this and also extended this
concept for attached memory with the CPU domain from self refresh point
of view. This is true for the CPUs who have very little active leakage and
hence "race to idle" would be better so that cluster can hit the deeper
C-state to save more power.

-- Spreading vs Packing actually can be made OPP(CPU operating point)
dependent. Some of the mobile workload and power numbers measured in
the past shown that when CPU operating at lower OPP(considering the
load is less),
packing would be the best option to have higher opportunity for cluster to idle
where as while operating at higher operating point(assuming the higher CPU load
and possibly more threads), a spread with race to idle in mind might
be beneficial.
Of-course this is going to be bit messy since the CPUFreq and scheduler needs
to be linked.

-- May be this is already possible but for architectures like big.LITTLE,
the power consumption and active leakage can be significantly different
across big and little CPU packages.
Meaning the big CPU cluster or SD might be more power efficient
with packing where as Little CPU cluster would be power efficient
with spreading. Hence the possible need of per SD configurability.

Ofcourse all of this can be done step by step starting with most simple
power policy as stated by Peter.

Regards
Santosh











been used whenever possible in sd.
