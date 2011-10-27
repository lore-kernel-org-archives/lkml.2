Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1J0UKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:10:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36321 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab1J0UKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:10:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] CPU hotplug, Freezer: Synchronize CPU hotplug and Freezer
Date: Thu, 27 Oct 2011 22:13:06 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: a.p.zijlstra@chello.nl, stern@rowland.harvard.edu, pavel@ucw.cz,
        len.brown@intel.com, mingo@elte.hu, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        linux-pm@vger.kernel.org, rusty@rustcorp.com.au,
        vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net
References: <20111027134824.20916.46845.stgit@srivatsabhat.in.ibm.com> <20111027134926.20916.21637.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111027134926.20916.21637.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110272213.06736.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, October 27, 2011, Srivatsa S. Bhat wrote:
> Prevent CPU hotplug and the freezer from racing with each other, to ensure
> that during the *entire duration* for which the callbacks for CPU hotplug
> notifications such as CPU_ONLINE[_FROZEN], CPU_DEAD[_FROZEN] etc are being
> executed, the state of the system (with respect to the tasks being frozen
> or not) remains constant.
> 
> This patches hooks the CPU hotplug infrastructure onto the freezer
> notifications (PM_FREEZE_PREPARE and PM_POST_THAW) and thus synchronizes
> with the freezer.
> 
> Specifically,
> 
> * Upon the PM_FREEZE_PREPARE notification, the CPU hotplug callback disables
>   future (regular) CPU hotplugging and also ensures that any currently running
>   CPU hotplug operation is completed before allowing the freezer to continue
>   any further.
> 
> * Upon the PM_POST_THAW notification, the CPU hotplug callback re-enables
>   regular CPU hotplug.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  kernel/cpu.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 76 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 12b7458..61985ce 100644
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
> @@ -478,6 +479,81 @@ static int alloc_frozen_cpus(void)
>  core_initcall(alloc_frozen_cpus);
>  #endif /* CONFIG_PM_SLEEP_SMP */
>  
> +
> +#ifdef CONFIG_FREEZER
> +
> +/*
> + * Avoid CPU hotplug racing with the freezer subsystem, by disabling CPU
> + * hotplug when tasks are about to be frozen.
> + *
> + * Also, don't allow the freezer subsystem to continue until any currently
> + * running CPU hotplug operation gets completed.
> + * To modify the 'cpu_hotplug_disabled' flag, we need to acquire the
> + * 'cpu_add_remove_lock'. And this same lock is also taken by the regular
> + * CPU hotplug path and released only after it is complete. Thus, we
> + * (and hence the freezer) will block here until any currently running CPU
> + * hotplug operation is completed.
> + */
> +static void cpu_hotplug_freezer_block_begin(void)
> +{
> +	cpu_maps_update_begin();
> +	cpu_hotplug_disabled = 1;
> +	cpu_maps_update_done();
> +}
> +
> +
> +/*
> + * When thawing of tasks is complete, re-enable CPU hotplug (which had been
> + * disabled while beginning to freeze tasks).
> + */
> +static void cpu_hotplug_freezer_block_done(void)
> +{
> +	cpu_maps_update_begin();
> +	cpu_hotplug_disabled = 0;
> +	cpu_maps_update_done();
> +}
> +

I wonder if the new PM notifier events are really necessary?

Why don't you just call cpu_hotplug_freezer_block_begin() (perhaps
with a better name?) directly from freeze_processes()?  And analogously
for cpu_hotplug_freezer_block_done() and thaw_processes()?

Rafael


> +
> +/*
> + * Avoid CPU hotplug and the freezer subsystem from racing with each other,
> + * so that when CPU hotplug notifications are being sent (i.e., the
> + * registered callbacks being executed), the state of the system reported
> + * by the notifier (with respect to the tasks being frozen or not) is
> + * consistent with the actual state of the system, *throughout the duration*
> + * during which the CPU hotplug notifications are active.
> + */
> +static int
> +cpu_hotplug_freezer_callback(struct notifier_block *nb,
> +				unsigned long action, void *ptr)
> +{
> +	switch (action) {
> +
> +	case PM_FREEZE_PREPARE:
> +		cpu_hotplug_freezer_block_begin();
> +		break;
> +
> +	case PM_POST_THAW:
> +		cpu_hotplug_freezer_block_done();
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
> +int cpu_hotplug_freezer_sync_init(void)
> +{
> +	pm_notifier(cpu_hotplug_freezer_callback, 0);
> +	return 0;
> +}
> +core_initcall(cpu_hotplug_freezer_sync_init);
> +
> +#endif /* CONFIG_FREEZER */
> +
> +
>  /**
>   * notify_cpu_starting(cpu) - call the CPU_STARTING notifiers
>   * @cpu: cpu that just started
> 
> 
> 

