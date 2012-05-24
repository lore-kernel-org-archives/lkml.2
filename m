Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2EXKel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:34:41 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44585 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2EXKej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:34:39 -0400
Message-ID: <4FBE02F3.3030809@linux.vnet.ibm.com>
Date: Thu, 24 May 2012 15:14:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        rientjes@google.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 4/5] cpusets: Update tasks' cpus_allowed mask upon
 updates to root cpuset
References: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com> <20120517170055.3011.18690.stgit@srivatsabhat.in.ibm.com> <1337850827.9783.77.camel@laptop>
In-Reply-To: <1337850827.9783.77.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052409-4790-0000-0000-000002EC2D4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 02:43 PM, Peter Zijlstra wrote:

> On Thu, 2012-05-17 at 22:33 +0530, Srivatsa S. Bhat wrote:
>> +               /*
>> +                * Restore only the top_cpuset because it has to track
>> +                * cpu_active_mask always.
>> +                * (We don't need to do anything if we come here during resume
>> +                * from suspend, since top_cpuset.cpus_allowed will already be
>> +                * equal to cpu_active_mask.)
>> +                */
>> +               if (root == &top_cpuset && !cpumask_equal(root->cpus_allowed,
>> +                                                         cpu_active_mask)) {
>> +                       mutex_lock(&callback_mutex);
>> +                       cpumask_copy(root->cpus_allowed, cpu_active_mask);
>> +                       mutex_unlock(&callback_mutex);
>> +                       update_tasks_cpumask(root, NULL);
>> +               } 
> 
> This looks absolutely broken.
> 
> Suppose I set an explicit cpu affinity mask on my task, which per not
> using cpusets is in the root group.
> 
> If I then do a hotplug cycle, I'll find my affinity mask is lost.
> 


Sorry, my bad, I hadn't considered that. Thanks for pointing it out!

So, I am wondering how we ought to deal with CPU hotplug for tasks attached
to the root cpuset..

Considering tasks attached to the root cpuset, if a cpu present in a task's
cpus_allowed mask goes offline, it should be removed from that mask right?
And if that cpu comes back online, it should not be put back to the task's
cpus_allowed mask (just like we don't put back cpus in non-root cpusets).

Is the above understanding correct?

In the current kernel, during cpu hotplug, we don't touch cpus_allowed mask
of the tasks attached to the root cpuset at all.. Whereas we update the
cpus_allowed mask of tasks belonging to non-root cpusets, during cpu offline.

So, is this differentiation intended?

Regards,
Srivatsa S. Bhat

