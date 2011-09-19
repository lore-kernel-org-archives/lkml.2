Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1ISIWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 04:22:20 -0400
Received: from relay.parallels.com ([195.214.232.42]:60257 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab1ISIWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 04:22:19 -0400
From: Vladimir Davydov <VDavydov@parallels.com>
To: Paul Turner <pjt@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>,
        Jason Baron <jbaron@redhat.com>
Date: Mon, 19 Sep 2011 12:22:25 +0400
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
Thread-Topic: [patch 00/18] CFS Bandwidth Control v7.2
Thread-Index: Acx2pTuITJSA6AsdS6eYjoCxwONNxQ==
Message-ID: <BABF7462-9665-4BB1-B3BD-566A5A3D6F7A@parallels.com>
References: <20110721164325.231521704@google.com>
 <1315915848.1151.26.camel@dhcp-10-30-22-158.sw.ru>
 <4E730397.5030902@google.com>
In-Reply-To: <4E730397.5030902@google.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 16, 2011, at 12:06 PM, Paul Turner wrote:

>> Although in both cases the tasks will consume not more than one half of
>> overall CPU time, the first case (all tasks of the cgroup run on the
>> same CPU) is obviously better if the tasks are likely to communicate
>> with each other (e.g. through pipe) which is often the case when cgroups
>> are used for container virtualization.
>> 
> 
> This case is handled already by the affine wake-up path.

But communicating tasks do not necessarily wake each other even if they exchange data through the pipe. And of course, if they use shared memory (e.g. threads), it is not obligatory at all. Also, the wake-affine path is cpu-load aware, i.e. it tries not to overload a cpu it is going to wake a task on. For instance, if we run a context switch test on an idle host, the two tasks will be executing on different cpus although it is better to execute them together on the same cpu.

What I want to say is that sometimes it can be beneficial to constrain parallelism of a container. And if we are going to limit a container's cpu usage to, for example, one cpu, I guess it is better to make its tasks run on the same cpu instead of spreading them across the system because:

1) it can improve cpu caches utilization.

2) It can reduce the overhead of the CFS bandwidth control: the contention on the cgroup's quota pool obviously will be less and the number of throttlings/unthrottlings will be diminished (in the example above with the cpulimit = one cpu, we can forget about it at all).

4) It can improve the latency of a cgroup the cpu usage of which is limited. Consider a cgroup with one interactive and several cpu-bound tasks. Let the limit of the cgroup be 1 cpu (the cgroup should not consume more cpu power than it would if it ran on a UP host). If the tasks run on all the cpus of the host (provided the host is SMP), the cpu-hogs will consume all the quota soon, and the cgroup will be throttled till the end of the period when the quota is recharged. The interactive task will be throttled too so the cgroup's latency falls dramatically. However, if all the tasks run on the same cpu, the cgroup is never throttled, and the interactive task easily preempts cpu-hogs whenever it wants.

> 
>> In other words, I'd like to know if your code (or the scheduler code)
>> tries to gather all tasks of the same cgroup on such a subset of all
>> CPUs so that the tasks can't execute less CPUs without losing quota
>> during each period. And if not, are you going to address the issue?
>> 
> 
> Parallelism != Bandwidth
> 


I agree.

Nevertheless, theoretically the former can be implemented on top of the latter. This is exactly what we've done in the latest OpenVZ kernel where limiting the number of cpus a container can run on to N is equivalent to setting its limit to N*max-per-cpu-limit.

> no plans at this time.


It's a pity :(

