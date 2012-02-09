Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab2BIImf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:42:35 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:40523 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2BIImd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:42:33 -0500
Message-ID: <4F3386E9.7090606@linux.vnet.ibm.com>
Date: Thu, 09 Feb 2012 14:12:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, paul@paulmenage.org, rjw@sisk.pl,
        tj@kernel.org, frank.rowand@am.sony.com, pjt@google.com,
        tglx@linutronix.de, lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling related
 to cpusets
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com> <1328671335.2482.72.camel@laptop> <4F32174E.2050207@linux.vnet.ibm.com> <20120209075701.GE18387@elte.hu>
In-Reply-To: <20120209075701.GE18387@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12020908-4790-0000-0000-0000013F511A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On 02/09/2012 01:27 PM, Ingo Molnar wrote:

> 
> * Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>> IOW, consider:
>>
>> cpuset A has 0-10
>>
>> - Take CPU 10 offline
>>   [We are forced to remove CPU 10 from cpuset A, which becomes 0-9 now]
>>
>>
>>    <Userspace didn't request any change to cpuset A>
>>
>>
>> - Bring back CPU 10 online
>>
>> Now cpuset A is still 0-9! IMO, it should have been 0-10.
> 
> Why is CPU 10 taken out of the cpuset to begin with?
> 
> The cpuset code should be fixed to work with offline CPUs as 
> well - it can obviously not schedule to them, but otherwise it 
> should be fine to have a wider cpuset than the hw can support.
> 


My understanding of the code is that when a CPU is taken offline, it is
removed from all the cpusets and then the scan_for_empty_cpusets() function
is run to move tasks from empty cpusets to their parent cpusets.

And then update_tasks_cpumask() will update the cpus_allowed mask of each
task whose cpus_allowed mask needs an update (because it moved between
cpusets). (This is achieved by setting up cpuset_change_cpumask() as the
callback and calling cgroup_scan_tasks()).

So, from my point of view, cpusets seems to be handling CPU Offline pretty
well, and correctly too. The corresponding CPU online handling is what is
buggy, IMHO, and that is what I intended to fix with this patchset.
 
Regards,
Srivatsa S. Bhat

