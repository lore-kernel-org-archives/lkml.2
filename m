Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2ETN7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:59:07 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:46806 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab2ETN7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:59:04 -0400
Message-ID: <4FB8F86B.1080906@linux.vnet.ibm.com>
Date: Sun, 20 May 2012 19:28:03 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, rientjes@google.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 0/5] CPU hotplug, cpusets, suspend/resume: Fixes, cleanups
 and optimizations
References: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052013-8878-0000-0000-000002846A38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Did you get a chance to take a look at this patchset?

(I have added a summary of the changes between the versions below.)

Thanks a lot!

On 05/17/2012 10:29 PM, Srivatsa S. Bhat wrote:

> Currently the kernel doesn't handle cpusets properly during suspend/resume.
> After a resume, all non-root cpusets end up having only 1 cpu (the boot cpu),
> causing massive performance degradation of workloads. One major user of cpusets
> is libvirt, which means that after a suspend/hibernation cycle, all VMs
> suddenly end up running terribly slow!
> 
> Also, the kernel moves the tasks from one cpuset to another during CPU hotplug
> in the suspend/resume path, leading to a task-management nightmare after
> resume.
> 
> Patch 1 fixes this by keeping cpusets unmodified in the suspend/resume path.
> But to ensure we don't trip over, it keeps the sched domains updated during
> every CPU hotplug in the s/r path.
> This is a long standing issue and we need to fix up stable kernels too.
> 
> The rest of the patches in the series are mostly cleanups/optimizations
> (except patch 4 which is a non-critical bug fix).
>


Changelog:

v5 : Don't do explicit save/restore of cpusets' cpu masks during s/r, to avoid
     the overhead of a new per-cpuset cpu mask to help with that. Also, ensure
     that the sched domains are updated on each hotplug.
     The s/r fix (patch 1) is now distinct from the cleanups (patches 2-5).

v4 : (Never had this version. I skipped from v3 to v5 accidentally).

v3 : Explicitly save and restore cpusets' cpu masks during s/r. Don't alter
     the semantics of regular cpu hotplug.
     http://thread.gmane.org/gmane.linux.kernel/1296339

v2 : http://thread.gmane.org/gmane.linux.documentation/4805/

v1 : thread.gmane.org/gmane.linux.kernel/1250097/
 

> --
>  Srivatsa S. Bhat (5):
>       CPU hotplug, cpusets, suspend: Don't modify cpusets during suspend/resume
>       cpusets, hotplug: Implement cpuset tree traversal in a helper function
>       cpusets, hotplug: Restructure functions that are invoked during hotplug
>       cpusets: Update tasks' cpus_allowed mask upon updates to root cpuset
>       cpusets: Remove/update outdated comments
> 
> 
>   include/linux/cpuset.h |    4 +
>  kernel/cpuset.c        |  161 +++++++++++++++++++++++++++++++++++-------------
>  kernel/sched/core.c    |   44 +++++++++++--
>  3 files changed, 159 insertions(+), 50 deletions(-)


Regards,
Srivatsa S. Bhat

