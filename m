Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab2EPIVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:21:43 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48388 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab2EPIVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:21:38 -0400
Message-ID: <4FB36365.4000802@linux.vnet.ibm.com>
Date: Wed, 16 May 2012 13:50:53 +0530
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
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com> <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com> <20120515044539.GA25256@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com> <1337112653.27694.110.camel@twins> <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com> <1337116107.27694.114.camel@twins> <alpine.DEB.2.00.1205151414210.1656@chino.kir.corp.google.com> <4FB2CDAD.4020306@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151444260.1656@chino.kir.corp.google.com> <4FB2D5CB.6090209@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151527220.25449@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205151527220.25449@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051608-5564-0000-0000-000002BD7E0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 04:02 AM, David Rientjes wrote:

> On Wed, 16 May 2012, Srivatsa S. Bhat wrote:
> 
>>>  I know root is special 
>>> cased all over the cpuset code, but I think the real fix here is to figure 
>>> out why it can't be left as a superset and then we end up doing nothing 
>>> for s/r.
>>>
>>> I don't have a preference for cpu hotplug and whether cpuset.cpus = 1-3 
>>> remains 1-3 when cpu 2 is offlined or not, I think it could be argued both 
>>> ways, but I disagree with saving the cpumask, removing all suspended cpus, 
>>> and then reinstating it for no reason.
>>>
>>
>> I think there is a valid reason behind doing that.
>>
>> Cpusets translates to sched domains in scheduler terms. So whenever you update
>> cpusets, the sched domains are updated. IOW, if you don't touch cpusets during
>> hotplug (suspend/resume case), you allow them to have offline cpus, meaning,
>> you allow sched domains to have offline cpus. Hence sched domains are rendered
>> stale.
>>
> 
> It's not possible to update the sched domains for s/r to be a subset of 
> cpuset.cpus?


Subset? See below..

(Btw, the above statement reminds me of a different idea I had long back
which I will write about in a separate mail.)

>  It would be the same situation for a thread using 
> sched_setaffinity() while bound to a cpuset with a superset of allowed 
> nodes. 


First of all, sched domains are built by looking at the cpusets' ->cpus_allowed
mask, not individual task's ->cpus_allowed mask. So we would gain nothing by
altering individual task's ->cpus_allowed mask, like what sched_setaffinity()
does.

On top of that, the "subset" argument wouldn't hold good in the s/r case.
sched_setaffinity() tries its best to keep the ->cpus_allowed mask of a task
as a subset of the ->cpus_allowed mask of the cpuset it belongs to.
But with s/r, that's not the case - it can very well become a disjoint set.
Consider a cpuset having cpuset.cpus = 1. What happens during suspend/resume
then? Going by your suggestion, the tasks in that cpuset will have
->cpus_allowed = 0,2-3 or some other combination not having cpu 1 when cpu 1
gets offlined. And it will keep getting changed into other things depending
on which phase of suspend/resume we are in.

IOW, ->cpus_allowed of the cpuset and ->cpus_allowed of the tasks belonging
to the cpuset can go totally out-of-sync, with no relationship like
subset/superset being preserved between them. Which is not the case with
sched_setaffinity(), where we always try to maintain a superset-subset
relationship between the two.

And in any case, altering individual task's ->cpus_allowed wouldn't buy us
anything, as I mentioned above.

> If you do that, there's no reason to alter cpuset.cpus at all and 

> you don't need to carry another cpumask around for each cpuset.
> 


Regards,
Srivatsa S. Bhat

