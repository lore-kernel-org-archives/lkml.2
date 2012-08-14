Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2HNHfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 03:35:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:37692 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab2HNHfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 03:35:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,764,1336374000"; 
   d="scan'208";a="200459681"
Message-ID: <5029FFB0.4020309@intel.com>
Date: Tue, 14 Aug 2012 15:35:12 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com>
In-Reply-To: <5028F12C.7080405@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 08:21 PM, Alex Shi wrote:

> Since there is no power saving consideration in scheduler CFS, I has a
> very rough idea for enabling a new power saving schema in CFS.
> 
> It bases on the following assumption:
> 1, If there are many task crowd in system, just let few domain cpus
> running and let other cpus idle can not save power. Let all cpu take the
> load, finish tasks early, and then get into idle. will save more power
> and have better user experience.
> 
> 2, schedule domain, schedule group perfect match the hardware, and
> the power consumption unit. So, pull tasks out of a domain means
> potentially this power consumption unit idle.
> 
> So, according Peter mentioned in commit 8e7fbcbc22c(sched: Remove stale
> power aware scheduling), this proposal will adopt the
> sched_balance_policy concept and use 2 kind of policy: performance, power.
> 
> And in scheduling, 2 place will care the policy, load_balance() and in
> task fork/exec: select_task_rq_fair().



Any comments for this rough proposal, specially for the assumptions?

> 
> Here is some pseudo code try to explain the proposal behaviour in
> load_balance() and select_task_rq_fair();
> 
> 
> load_balance() {
> 	update_sd_lb_stats(); //get busiest group, idlest group data.
> 
> 	if (sd->nr_running > sd's capacity) {
> 		//power saving policy is not suitable for
> 		//this scenario, it runs like performance policy
> 		mv tasks from busiest cpu in busiest group to
> 		idlest 	cpu in idlest group;
> 	} else {// the sd has enough capacity to hold all tasks.
> 		if (sg->nr_running > sg's capacity) {
> 			//imbalanced between groups
> 			if (schedule policy == performance) {
> 				//when 2 busiest group at same busy
> 				//degree, need to prefer the one has
> 				// softest group??
> 				move tasks from busiest group to
> 					idletest group;
> 			} else if (schedule policy == power)
> 				move tasks from busiest group to
> 				idlest group until busiest is just full
> 				of capacity.
> 				//the busiest group can balance
> 				//internally after next time LB,
> 		} else {
> 			//all groups has enough capacity for its tasks.
> 			if (schedule policy == performance)
> 				//all tasks may has enough cpu
> 				//resources to run,
> 				//mv tasks from busiest to idlest group?
> 				//no, at this time, it's better to keep
> 				//the task on current cpu.
> 				//so, it is maybe better to do balance
> 				//in each of groups
> 				for_each_imbalance_groups()
> 					move tasks from busiest cpu to
> 					idlest cpu in each of groups;
> 			else if (schedule policy == power) {
> 				if (no hard pin in idlest group)
> 					mv tasks from idlest group to
> 					busiest until busiest full.
> 				else
> 					mv unpin tasks to the biggest
> 					hard pin group.
> 			}
> 		}
> 	}
> }
> 
> select_task_rq_fair()
> {
> 	for_each_domain(cpu, tmp) {
> 		if (policy == power && tmp_has_capacity &&
> 			 tmp->flags & sd_flag) {
> 			sd = tmp;
> 			//It is fine to got cpu in the domain
> 			break;
> 		}
> 	}
> 
> 	while(sd) {
> 		if policy == power
> 			find_busiest_and_capable_group()
> 		else
> 			find_idlest_group();
> 		if (!group) {
> 			sd = sd->child;
> 			continue;
> 		}
> 		...
> 	}
> }
> 
> sub proposal:
> 1, If it's possible to balance task on idlest cpu not appointed 'balance
> cpu'. If so, it may can reduce one more time balancing.
> The idlest cpu can prefer the new idle cpu;  and is the least load cpu;
> 2, se or task load is good for running time setting.
> but it should the second basis in load balancing. The first basis of LB
> is running tasks' number in group/cpu. Since whatever of the weight of
> groups is, if the tasks number is less than cpu number, the group is
> still has capacity to take more tasks. (will consider the SMT cpu power
> or other big/little cpu capacity on ARM.)
> 
> unsolved issues:
> 1, like current scheduler, it didn't handled cpu affinity well in
> load_balance.
> 2, task group that isn't consider well in this rough proposal.
> 
> It isn't consider well and may has mistaken . So just share my ideas and
> hope it become better and workable in your comments and discussion.
> 
> Thanks
> Alex


