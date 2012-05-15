Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2EOMLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:11:46 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48273 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab2EOMLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:11:31 -0400
Message-ID: <4FB247BC.3020400@linux.vnet.ibm.com>
Date: Tue, 15 May 2012 17:40:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 0/5] CPU hotplug, cpusets: Fix issues with cpusets
 handling during suspend/resume
References: <20120513231325.3566.37740.stgit@srivatsabhat> <alpine.DEB.2.00.1205141654080.25235@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205141654080.25235@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051502-3568-0000-0000-000001C5632A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 05:28 AM, David Rientjes wrote:

> On Mon, 14 May 2012, Srivatsa S. Bhat wrote:
> 
>> Currently the kernel doesn't handle cpusets properly during suspend/resume.
>> After a resume, all non-root cpusets end up having only 1 cpu (the boot cpu),
>> causing massive performance degradation of workloads. One major user of cpusets
>> is libvirt, which means that after a suspend/hibernation cycle, all VMs
>> suddenly end up running terribly slow!
>>
>> Also, the kernel moves the tasks from one cpuset to another during CPU hotplug
>> in the suspend/resume path, leading to a task-management nightmare after
>> resume.
>>
> 
> To deal with mempolicy rebinding when a cpuset changes, I made a change to 
> mempolicies to store the user nodemask passed to set_mempolicy() or 
> mbind() so the intention of the user could be preserved.  It seems like 
> you should do the same thing for cpusets to store the "intended" set of 
> cpus and respect that during cpu online?
> 


Well, I think Nishanth addressed this one already.. As he said, that idea was
implemented in v2 of the patchset[1], and it turned out to be against hotplug
semantics, as pointed out by Peter Zijlstra.

[1]. http://thread.gmane.org/gmane.linux.documentation/4805

>> Patches 1 & 2 are cleanups that separate out hotplug handling so that we can
>> implement different logic for different hotplug events (CPU/Mem
>> online/offline). This also leads to some optimizations and more importantly
>> prepares the ground for any further work dealing with cpusets during hotplug.
>>
>> Patch 3 is a bug fix - it ensures that the tasks attached to the root cpuset
>> see the updated cpus_allowed mask upon CPU hotplug.
>>
>> Patches 4 and 5 implement the fix for cpusets handling during suspend/resume.
> 
> All of your patches are labeled to stable@vger.kernel.org, but I seriously 
> doubt any of this is stable material since it has been a long-standing 
> issue (and perhaps intentional in some cases)


Yes, it is a long-standing issue (bug), but it is not intentional.
People are struggling to deal with this kernel bug for suspend/resume and
there have been numerous bug-reports and stuff everywhere. It is high-time we
fix this in the kernel and get it into stable kernels too (because they too have
this bug).

> and your series includes 
> cleanups and optimizations that wouldn't be stable candidates, so I'd 
> suggest removing that annotation.
> 


Well, the existing code was so messed up that I didn't have a choice but to
clean it up before fixing the suspend/resume case. Had I tried to implement
the fix without cleaning it up, it would have been absolutely horrible, I believe.

And the optimizations? those are just side effects of that cleanup! That really
tells the extent to which it was messed up in the first place!

Regards,
Srivatsa S. Bhat

