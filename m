Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2B0KS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:18:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54394 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2B0KSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:18:25 -0500
Message-ID: <1330337881.11248.47.camel@twins>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling
 related to cpusets
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        paul@paulmenage.org, tj@kernel.org, frank.rowand@am.sony.com,
        pjt@google.com, tglx@linutronix.de, lizf@cn.fujitsu.com,
        prashanth@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Mon, 27 Feb 2012 11:18:01 +0100
In-Reply-To: <4F460D7B.1020703@linux.vnet.ibm.com>
References: <Pine.LNX.4.44L0.1202101647440.1179-100000@iolanthe.rowland.org>
	 <201202102339.02702.rjw@sisk.pl> <1328926042.2476.3.camel@laptop>
	 <4F35EE11.5010202@linux.vnet.ibm.com> <4F394CA0.9020902@linux.vnet.ibm.com>
	 <4F3E44DB.20201@linux.vnet.ibm.com> <1329742145.2293.337.camel@twins>
	 <4F4243B6.8070507@linux.vnet.ibm.com> <4F460D7B.1020703@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 15:27 +0530, Srivatsa S. Bhat wrote:
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

Fair enough, I'll take it and push it through sched/urgent so that it
should still make 3.4.

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
>                              void *hcpu)
>  {
> -       switch (action & ~CPU_TASKS_FROZEN) {
> +       switch (action) {
>         case CPU_ONLINE:
>         case CPU_DOWN_FAILED:
>                 cpuset_update_active_cpus();
> @@ -6741,7 +6741,7 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
>  static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
>                                void *hcpu)
>  {
> -       switch (action & ~CPU_TASKS_FROZEN) {
> +       switch (action) {
>         case CPU_DOWN_PREPARE:
>                 cpuset_update_active_cpus();
>                 return NOTIFY_OK;
> 
> 
> 
