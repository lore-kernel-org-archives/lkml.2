Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab2EIJNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:13:33 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:54864 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020Ab2EIJNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:13:31 -0400
Message-ID: <4FAA3513.1060906@linux.vnet.ibm.com>
Date: Wed, 09 May 2012 14:42:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, rob@landley.net, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
References: <20120504191535.4603.83236.stgit@srivatsabhat> <1336159496.6509.51.camel@twins> <4FA434E9.6000305@linux.vnet.ibm.com> <1336162456.6509.63.camel@twins>
In-Reply-To: <1336162456.6509.63.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050909-2674-0000-0000-00000455E191
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 01:44 AM, Peter Zijlstra wrote:

> On Sat, 2012-05-05 at 01:28 +0530, Srivatsa S. Bhat wrote:
>> On 05/05/2012 12:54 AM, Peter Zijlstra wrote:
>>
>>>
>>>>   Documentation/cgroups/cpusets.txt |   43 +++--
>>>>  include/linux/cpuset.h            |    4 
>>>>  kernel/cpuset.c                   |  317 ++++++++++++++++++++++++++++---------
>>>>  kernel/sched/core.c               |    4 
>>>>  4 files changed, 274 insertions(+), 94 deletions(-)
>>>
>>> Bah, I really hate this complexity you've created for a problem that
>>> really doesn't exist.
>>>
>>
>>
>> Doesn't exist? Well, I believe we do have a problem and a serious one
>> at that too!
> 
>>> So why not fix the active mask crap?
>>
>>
>> Because I doubt if that is the right way to approach this problem.
>>
>> An updated cpu_active_mask not being the necessary and sufficient condition
>> for all scheduler related activities, is a different problem altogether, IMHO.
> 
> It was the sole cause the previous, simple, patch didn't work. So fixing
> that seems like important.
> 


Some thoughts on this..

First of all, why would it be reasonable to expect the scheduler to work
flawlessly with half its infrastructure (sched domains for example) in a
stale/inconsistent/outdated state?  

IOW, I am finding it difficult to understand why you would consider it a bug if
the scheduler falters when cpu_active mask is up-to-date but the sched domains
are old/outdated.. Is it not expected? And hence, wouldn't it make sense to keep
the sched domains up-to-date so that the scheduler functions properly?

Also, to "fix" that, sprinkling checks for active cpu, wherever the sched domain
tree traversal is done, like:

	if (!cpu_active(cpu)) 
		/* Go out */

	for_each_domain(cpu, sd) {
	}

looks quite ugly/hacky to me, because, if the sched domains were up-to-date
(as they should be), then the domain traversal would automatically become a
nop since the sd pointer would have been NULL... Thus, there wouldn't be a
need for such checks.

Moreover, those checks for active cpu, if added, could also end up in hot
paths, such as schedule()..

Regards,
Srivatsa S. Bhat

