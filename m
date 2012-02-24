Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2BXXUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:20:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200Ab2BXXUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:20:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling related to cpusets
Date: Sat, 25 Feb 2012 00:24:17 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, paul@paulmenage.org, tj@kernel.org,
        frank.rowand@am.sony.com, pjt@google.com, tglx@linutronix.de,
        lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.1202101647440.1179-100000@iolanthe.rowland.org> <4F4243B6.8070507@linux.vnet.ibm.com> <4F460D7B.1020703@linux.vnet.ibm.com>
In-Reply-To: <4F460D7B.1020703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202250024.17644.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 23, 2012, Srivatsa S. Bhat wrote:
> On 02/20/2012 06:29 PM, Srivatsa S. Bhat wrote:
> 
> > Hi Peter,
> > 
> > On 02/20/2012 06:19 PM, Peter Zijlstra wrote:
> > 
> >> On Fri, 2012-02-17 at 17:45 +0530, Srivatsa S. Bhat wrote:
> >>
> >>>> Trivially removing CPU_TASKS_FROZEN as shown below doesn't look right to me:
> >>>>
> >>>> ---
> >>>>
> >>>>  kernel/sched/core.c |    4 ++--
> >>>>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>>
> >>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> >>>> index 5255c9d..43a166e 100644
> >>>> --- a/kernel/sched/core.c
> >>>> +++ b/kernel/sched/core.c
> >>>> @@ -6729,7 +6729,7 @@ int __init sched_create_sysfs_power_savings_entries(struct device *dev)
> >>>>  static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
> >>>>  			     void *hcpu)
> >>>>  {
> >>>> -	switch (action & ~CPU_TASKS_FROZEN) {
> >>>> +	switch (action) {
> >>>>  	case CPU_ONLINE:
> >>>>  	case CPU_DOWN_FAILED:
> >>>>  		cpuset_update_active_cpus();
> >>>> @@ -6742,7 +6742,7 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
> >>>>  static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
> >>>>  			       void *hcpu)
> >>>>  {
> >>>> -	switch (action & ~CPU_TASKS_FROZEN) {
> >>>> +	switch (action) {
> >>>>  	case CPU_DOWN_PREPARE:
> >>>>  		cpuset_update_active_cpus();
> >>>>  		return NOTIFY_OK;
> >>>>
> >>>>
> >>>> IMO, irrespective of whether we keep cpusets unaware of all CPU Hotplug or
> >>>> only unaware of the CPU hotplug in the suspend/resume path, I feel the
> >>>> scheduler should always know the true state of the system, ie., offline CPUs
> >>>> must not be part of any sched domain, at any point in time.
> >>
> >> That's really not a problem as long as they're not in the active mask.
> >>
> 
> 
> [...]
> 
> So, based on what you said above, I guess we can go with that simple patch.
> (See below, for the patch with changelog).
> 
> I thought about what Ingo suggested (ie., not touching cpusets during cpu
> hotplug, irrespective of whether it is part of suspend or not). And we can
> implement that by having a scheme something like:
> 
> o Currently if a cpuset's cpus_allowed mask becomes empty due to CPU offline,
>   all tasks in that cpuset is moved to a parent cpuset whose cpus_allowed mask
>   is non-empty.
>   Here, instead of *moving* the tasks to another cpuset, we could just change
>   the cpus_allowed mask of each task in that cpuset to reflect the non-empty
>   parent cpuset's cpus_allowed mask. IOW, during a CPU offline, we never touch
>   a cpuset's cpus_allowed mask, we only modify the cpus_allowed mask of the
>   *tasks* in that cpuset. Also, we never move a task from one cpuset to another
>   due to CPU offline.
> 
> o Since we never modify a cpuset's cpus_allowed mask due to CPU offline, it is
>   trivial to get back to original state when that CPU comes back online. Just
>   compare the cpuset's cpus_allowed mask with cpu_active_mask and update the
>   cpus_allowed masks of all the tasks in that cpuset.
> 
> We can definitely do all this, but I am not quite sure if this complexity is
> justified (ie., complexity in the sense that the cpus_allowed mask of the tasks
> in a cpuset might not always be the same as the cpus_allowed mask of that
> cpuset).
> 
> However, if somebody feels that the above mentioned approach looks good and
> the complexity is justified, please let me know.. But until then, the
> following simple fix for the suspend/resume bug should suffice.
> 
> ----
> 
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: CPU hotplug, cpusets, suspend: Don't touch cpusets during suspend/resume
> 
> Currently, during CPU hotplug, the cpuset callbacks modify the cpusets
> to reflect the state of the system, and this handling is asymmetric.
> That is, upon CPU offline, that CPU is removed from all cpusets. However
> when it comes back online, it is put back only to the root cpuset.
> 
> This gives rise to a significant problem during suspend/resume. During
> suspend, we offline all non-boot cpus and during resume we online them back.
> Which means, after a resume, all cpusets (except the root cpuset) will be
> restricted to just one single CPU (the boot cpu). But the whole point of
> suspend/resume is to restore the system to a state which is as close as
> possible to how it was before suspend.
> 
> So to fix this, don't touch cpusets during suspend/resume. That is, modify
> the cpuset-related CPU hotplug callback to just ignore CPU hotplug when it
> is initiated as part of the suspend/resume sequence.
> 
> Reported-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org

So I wonder what people think about this patch.  Are there any objections?
If not, I'd like to take it for v3.4 until there's a better fix.

Thanks,
Rafael


> ---
> 
>  kernel/sched/core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1169246..49ba9d4 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6728,7 +6728,7 @@ int __init sched_create_sysfs_power_savings_entries(struct device *dev)
>  static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
>  			     void *hcpu)
>  {
> -	switch (action & ~CPU_TASKS_FROZEN) {
> +	switch (action) {
>  	case CPU_ONLINE:
>  	case CPU_DOWN_FAILED:
>  		cpuset_update_active_cpus();
> @@ -6741,7 +6741,7 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
>  static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
>  			       void *hcpu)
>  {
> -	switch (action & ~CPU_TASKS_FROZEN) {
> +	switch (action) {
>  	case CPU_DOWN_PREPARE:
>  		cpuset_update_active_cpus();
>  		return NOTIFY_OK;
> 
> 
> 
> 

