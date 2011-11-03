Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1KCARh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:17:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47171 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab1KCARd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:17:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v5] CPU hotplug, Freezer: Fix race between CPU hotplug and freezer
Date: Thu, 3 Nov 2011 01:20:07 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: a.p.zijlstra@chello.nl, stern@rowland.harvard.edu, pavel@ucw.cz,
        len.brown@intel.com, mingo@elte.hu, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        linux-pm@vger.kernel.org, rusty@rustcorp.com.au,
        vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org, tj@kernel.org
References: <20111031205125.26694.5730.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111031205125.26694.5730.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111030120.07857.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 31, 2011, Srivatsa S. Bhat wrote:
> The CPU hotplug notifications sent out by the _cpu_up() and _cpu_down()
> functions depend on the value of the 'tasks_frozen' argument passed to them
> (which indicates whether tasks have been frozen or not).
> (Examples for such CPU hotplug notifications: CPU_ONLINE, CPU_ONLINE_FROZEN,
> CPU_DEAD, CPU_DEAD_FROZEN).
> 
> Thus, it is essential that while the callbacks for those notifications are
> running, the state of the system with respect to the tasks being frozen or
> not remains unchanged, *throughout that duration*. Hence there is a need for
> synchronizing the CPU hotplug code with the freezer subsystem.
> 
> Since the freezer is involved only in the Suspend/Hibernate call paths, this
> patch hooks the CPU hotplug code to the suspend/hibernate notifiers
> PM_[SUSPEND|HIBERNATE]_PREPARE and PM_POST_[SUSPEND|HIBERNATE] to prevent
> the race between CPU hotplug and freezer, thus ensuring that CPU hotplug
> notifications will always be run with the state of the system really being
> what the notifications indicate, _throughout_ their execution time.
> 
> v5: * Removed the new freezer notifiers since freezer is used only in suspend
>       and hibernate call paths. Used the suspend/hibernate notifier events
>       to synchronize CPU hotplug and freezer.
> 
> v4: * Retained the value 0 for the 'tasks_frozen' argument, while calling
>       _cpu_up() and _cpu_down().
>       Removed the unnecessary PM_POST_FREEZE and PM_THAW_PREPARE notifications.
> 
> v3: * Added synchronization between CPU hotplug and the freezer subsystem
>       without introducing any new locks in the CPU hotplug call path.
> 
> v2: * Removed the atomic_t declaration of tasks_frozen flag and the
>       atomic_[set|read] functions since they were unnecessary.
>     * Updated the changelog to give an example scenario where things could go
>       wrong due to the bug in the CPU hotplug call path.
> 
> References:
> v1 -> http://thread.gmane.org/gmane.linux.kernel/1198312/
> v2 -> http://thread.gmane.org/gmane.linux.kernel/1198312/focus=1199087
> v3 -> http://thread.gmane.org/gmane.linux.documentation/3472
> v4 -> http://thread.gmane.org/gmane.linux.documentation/3485
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
> 
>  kernel/cpu.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 74 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 12b7458..aa39dd7 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -15,6 +15,7 @@
>  #include <linux/stop_machine.h>
>  #include <linux/mutex.h>
>  #include <linux/gfp.h>
> +#include <linux/suspend.h>
>  
>  #ifdef CONFIG_SMP
>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
> @@ -476,6 +477,79 @@ static int alloc_frozen_cpus(void)
>  	return 0;
>  }
>  core_initcall(alloc_frozen_cpus);
> +
> +/*
> + * Prevent regular CPU hotplug from racing with the freezer, by disabling CPU
> + * hotplug when tasks are about to be frozen. Also, don't allow the freezer
> + * to continue until any currently running CPU hotplug operation gets
> + * completed.
> + * To modify the 'cpu_hotplug_disabled' flag, we need to acquire the
> + * 'cpu_add_remove_lock'. And this same lock is also taken by the regular
> + * CPU hotplug path and released only after it is complete. Thus, we
> + * (and hence the freezer) will block here until any currently running CPU
> + * hotplug operation gets completed.
> + */
> +void cpu_hotplug_disable_before_freeze(void)
> +{
> +	cpu_maps_update_begin();
> +	cpu_hotplug_disabled = 1;
> +	cpu_maps_update_done();
> +}
> +
> +
> +/*
> + * When tasks have been thawed, re-enable regular CPU hotplug (which had been
> + * disabled while beginning to freeze tasks).
> + */
> +void cpu_hotplug_enable_after_thaw(void)
> +{
> +	cpu_maps_update_begin();
> +	cpu_hotplug_disabled = 0;
> +	cpu_maps_update_done();
> +}
> +
> +/*
> + * When callbacks for CPU hotplug notifications are being executed, we must
> + * ensure that the state of the system with respect to the tasks being frozen
> + * or not, as reported by the notification, remains unchanged *throughout the
> + * duration* of the execution of the callbacks.
> + * Hence we need to prevent the freezer from racing with regular CPU hotplug.
> + *
> + * This synchronization is implemented by mutually excluding regular CPU
> + * hotplug and Suspend/Hibernate call paths by hooking onto the Suspend/
> + * Hibernate notifications.
> + */
> +static int
> +cpu_hotplug_pm_callback(struct notifier_block *nb,
> +			unsigned long action, void *ptr)
> +{
> +	switch (action) {
> +
> +	case PM_SUSPEND_PREPARE:
> +	case PM_HIBERNATION_PREPARE:
> +		cpu_hotplug_disable_before_freeze();
> +		break;
> +
> +	case PM_POST_SUSPEND:
> +	case PM_POST_HIBERNATION:
> +		cpu_hotplug_enable_after_thaw();
> +		break;
> +
> +	default:
> +		return NOTIFY_DONE;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +
> +int cpu_hotplug_pm_sync_init(void)
> +{
> +	pm_notifier(cpu_hotplug_pm_callback, 0);
> +	return 0;
> +}
> +core_initcall(cpu_hotplug_pm_sync_init);
> +
>  #endif /* CONFIG_PM_SLEEP_SMP */
>  
>  /**
> 
> 
> 

