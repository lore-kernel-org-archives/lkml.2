Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965906Ab2EOWR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:17:27 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:54478 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655Ab2EOWRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:17:25 -0400
Message-ID: <4FB2D5CB.6090209@linux.vnet.ibm.com>
Date: Wed, 16 May 2012 03:46:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets during
 suspend/resume
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com> <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com> <20120515044539.GA25256@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com> <1337112653.27694.110.camel@twins> <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com> <1337116107.27694.114.camel@twins> <alpine.DEB.2.00.1205151414210.1656@chino.kir.corp.google.com> <4FB2CDAD.4020306@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151444260.1656@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205151444260.1656@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051522-8256-0000-0000-000002741D2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 03:19 AM, David Rientjes wrote:

> On Wed, 16 May 2012, Srivatsa S. Bhat wrote:
> 
>> What you are suggesting was precisely the v1 of this patchset, which went
>> upstream as commit 8f2f748b06562 (CPU hotplug, cpusets, suspend: Don't touch
>> cpusets during suspend/resume).
>>
>> It got reverted due to a nasty suspend hang in some corner case, where the
>> sched domains not being up-to-date got the scheduler confused.
>> Here is the thread with that discussion:
>> http://thread.gmane.org/gmane.linux.kernel/1262802/focus=1286289
>>
>> As Peter suggested, I'll try to fix the issues at the 2 places that I found
>> where the scheduler gets confused despite the cpu_active mask being up-to-date.
>>
>> But, I really want to avoid that scheduler fix and this cpuset fix from
>> being tied together, for the fear that until we root-cause and fix all
>> scheduler bugs related to cpu_active mask, we can never get cpusets fixed
>> once and for all for suspend/resume. So, this patchset does an explicit
>> save and restore to be sure, and so that we don't depend on some other/unknown
>> factors to make this work reliably.
>>
> 
> Ok, so it seems like this is papering over an existing cpusets issue or an 
> interaction with the scheduler that is buggy.


Well, I don't think so. See below.

>  There's no reason why a 
> cpuset.cpus that is a superset of cpu_active_mask should cause an issue 
> since that's exactly what the root cpuset has.


No, even root cpuset is modified during hotplug (and hence during suspend/resume).
If you look at the code, the root cpuset's cpuset.cpus is always exactly equal
to cpu_active_mask (and it is updated during every hotplug, both online and
offline).

>  I know root is special 
> cased all over the cpuset code, but I think the real fix here is to figure 
> out why it can't be left as a superset and then we end up doing nothing 
> for s/r.
> 
> I don't have a preference for cpu hotplug and whether cpuset.cpus = 1-3 
> remains 1-3 when cpu 2 is offlined or not, I think it could be argued both 
> ways, but I disagree with saving the cpumask, removing all suspended cpus, 
> and then reinstating it for no reason.
> 


I think there is a valid reason behind doing that.

Cpusets translates to sched domains in scheduler terms. So whenever you update
cpusets, the sched domains are updated. IOW, if you don't touch cpusets during
hotplug (suspend/resume case), you allow them to have offline cpus, meaning,
you allow sched domains to have offline cpus. Hence sched domains are rendered
stale.

Now, from my point of view, keeping the sched domains stale and expecting
the scheduler to work flawlessly doesn't seem right.

However, the cpu_active_mask was introduced to handle situations where hotplug
transition is still in progress, and the scheduler needs to take appropriate
decisions even with some of its data-structures in an inconsistent/stale state.
But once the hotplug operation is completed, the scheduler doesn't need to
depend on cpu_active_mask.

Now coming to the suspend/resume/cpuset case, what you are suggesting will
essentially boil down to keeping the sched domains stale not just _during_
hotplug transitions, but also after that, in fact across multiple hotplug
operations in succession! So, from my point of view, the real bug is keeping
the sched domains stale for so long, across hotplug operations.
(And on those lines, making the scheduler work correctly even in such cases
is only a good-to-have as a robustness measure and not a "bugfix".)

So to avoid keeping the sched domains stale during suspend/resume, we need
to update cpusets for every hotplug as necessary, and this means we need to do
an explicit save and restore.

Regards,
Srivatsa S. Bhat

