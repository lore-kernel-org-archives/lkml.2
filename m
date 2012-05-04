Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2EDT7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:59:15 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:36438 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2EDT7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:59:12 -0400
Message-ID: <4FA434E9.6000305@linux.vnet.ibm.com>
Date: Sat, 05 May 2012 01:28:33 +0530
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
References: <20120504191535.4603.83236.stgit@srivatsabhat> <1336159496.6509.51.camel@twins>
In-Reply-To: <1336159496.6509.51.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050419-4790-0000-0000-0000027AF2B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 12:54 AM, Peter Zijlstra wrote:

> 
>>   Documentation/cgroups/cpusets.txt |   43 +++--
>>  include/linux/cpuset.h            |    4 
>>  kernel/cpuset.c                   |  317 ++++++++++++++++++++++++++++---------
>>  kernel/sched/core.c               |    4 
>>  4 files changed, 274 insertions(+), 94 deletions(-)
> 
> Bah, I really hate this complexity you've created for a problem that
> really doesn't exist.
> 


Doesn't exist? Well, I believe we do have a problem and a serious one
at that too!

The heart of the problem can be summarized in 2 sentences:

o	During a CPU hotplug, tasks can move between cpusets, and never
	come back to their original cpuset.
o	Tasks might get pinned to lesser number of cpus, unreasonably.

Both these are undesirable from a system-admin point of view.
Moreover, having workarounds for this from userspace is way too messy and
ugly, if not impossible.

> So why not fix the active mask crap?


Because I doubt if that is the right way to approach this problem.

An updated cpu_active_mask not being the necessary and sufficient condition
for all scheduler related activities, is a different problem altogether, IMHO.

(Btw, Ingo had also suggested reworking this whole cpuset thing, while
reviewing the previous version of this fix.
http://thread.gmane.org/gmane.linux.kernel/1250097/focus=1252133)

Also, we need to fix this problem at the CPU Hotplug level itself, and
not just for the suspend/resume case. Because, we have had numerous bug
reports and people complaining about this issue, in various scenarios,
including those that didn't involve suspend/resume.

I am sure some of the people in Cc will have more to add to this, but in
general, when the CPU hotplug (maybe even cpu offline + online) and the
cpuset administration are done asynchronously, it leads to nasty surprises.
In fact, there have been reports where people spent inordinate amounts of
time before they figured out that a long-forgotten cpu hotplug operation
which was performed, was the root-cause of a low-performing workload!.

All these only suggest that it is time that we cleaned this up thoroughly,
and at the root cause level itself.

Btw, though there are 7 patches in this series, I don't think this patchset
increases the complexity of the code.. In fact, it makes many things simpler
and saner/cleaner, IMHO.

Regards,
Srivatsa S. Bhat

