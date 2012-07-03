Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab2GCRHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:07:43 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51298 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab2GCRHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:07:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@vger.kernel.org
Subject: Re: Build failures in -next due to move of disable
Date: Tue, 3 Jul 2012 19:13:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: ShuoX Liu <shuox.liu@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Colin Cross <ccross@android.com>
References: <20120702123740.GA11168@sirena.org.uk> <201207022216.01993.rjw@sisk.pl> <201207022337.33051.rjw@sisk.pl>
In-Reply-To: <201207022337.33051.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201207031913.12965.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 02, 2012, Rafael J. Wysocki wrote:
> On Monday, July 02, 2012, Rafael J. Wysocki wrote:
> > On Monday, July 02, 2012, Andrew Morton wrote:
> > > On Mon, 2 Jul 2012 21:54:35 +0200
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > On Monday, July 02, 2012, Mark Brown wrote:
> > > > > Today's -next is failing to build for me because commit 9f419c (PM /
> > > > > Domains: Add preliminary support for cpuidle) and commit b32e30
> > > > > (cpuidle: move field disable from per-driver to per-cpu) disagree about
> > > > > where the disable field should be:
> > > > 
> > > > Hmm, do you know what tree commit b32e30 comes from?
> > > 
> > > 
> > > From: ShuoX Liu <shuox.liu@intel.com>
> > > Subject: cpuidle: move field disable from per-driver to per-cpu
> > > 
> > > Andrew J.Schorr raises a question.  When he changes the disable setting on
> > > a single CPU, it affects all the other CPUs.  Basically, currently, the
> > > disable field is per-driver instead of per-cpu.  All the C states of the
> > > same driver are shared by all CPU in the same machine.
> > > 
> > > The patch changes the `disable' field to per-cpu, so we could set this
> > > separately for each cpu.
> > > 
> > > Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> > > Reported-by: Andrew J.Schorr <aschorr@telemetry-investments.com>
> > > Reviewed-by: Yanmin Zhang <yanmin_zhang@intel.com>
> > > Cc: Len Brown <lenb@kernel.org>
> > > Cc: "Brown, Len" <len.brown@intel.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > I see, thanks.  I guess I'll take this patch to linux-pm, then, and
> > rebase my patches on top of it.
> > 
> > Does anyone have any objections?
> 
> Well, if I do that, I pretty much will have to add the disable field to
> struct cpuidle_state to make commit 9f419c work again.
> 
> The new patch (commit 9f419c replacement) follows, but does anyone have a
> better idea?

>From the lack of response I'm inferring that the answer is "no", so I'm
going to use the patch below.

Thanks,
Rafael


> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Domains: Add preliminary support for cpuidle, v2
> 
> On some systems there are CPU cores located in the same power
> domains as I/O devices.  Then, power can only be removed from the
> domain if all I/O devices in it are not in use and the CPU core
> is idle.  Add preliminary support for that to the generic PM domains
> framework.
> 
> First, the platform is expected to provide a cpuidle driver with one
> extra state designated for use with the generic PM domains code.
> This state should be initially disabled and its exit_latency value
> should be set to whatever time is needed to bring up the CPU core
> itself after restoring power to it, not including the domain's
> power on latency.  Its .enter() callback should point to a procedure
> that will remove power from the domain containing the CPU core at
> the end of the CPU power transition.
> 
> The remaining characteristics of the extra cpuidle state, referred to
> as the "domain" cpuidle state below, (e.g. power usage, target
> residency) should be populated in accordance with the properties of
> the hardware.
> 
> Next, the platform should execute genpd_attach_cpuidle() on the PM
> domain containing the CPU core.  That will cause the generic PM
> domains framework to treat that domain in a special way such that:
> 
>  * When all devices in the domain have been suspended and it is about
>    to be turned off, the states of the devices will be saved, but
>    power will not be removed from the domain.  Instead, the "domain"
>    cpuidle state will be enabled so that power can be removed from
>    the domain when the CPU core is idle and the state has been chosen
>    as the target by the cpuidle governor.
> 
>  * When the first I/O device in the domain is resumed and
>    __pm_genpd_poweron(() is called for the first time after
>    power has been removed from the domain, the "domain" cpuidle
>    state will be disabled to avoid subsequent surprise power removals
>    via cpuidle.
> 
> The effective exit_latency value of the "domain" cpuidle state
> depends on the time needed to bring up the CPU core itself after
> restoring power to it as well as on the power on latency of the
> domain containing the CPU core.  Thus the "domain" cpuidle state's
> exit_latency has to be recomputed every time the domain's power on
> latency is updated, which may happen every time power is restored
> to the domain, if the measured power on latency is greater than
> the latency stored in the corresponding generic_pm_domain structure.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> ---
>  drivers/base/power/domain.c      |  117 +++++++++++++++++++++++++++++++++++++++
>  drivers/cpuidle/cpuidle.c        |    1 
>  drivers/cpuidle/governors/menu.c |    3 -
>  include/linux/cpuidle.h          |    1 
>  include/linux/pm_domain.h        |   17 +++++
>  5 files changed, 138 insertions(+), 1 deletion(-)
> 
> Index: linux/include/linux/pm_domain.h
> ===================================================================
> --- linux.orig/include/linux/pm_domain.h
> +++ linux/include/linux/pm_domain.h
> @@ -15,6 +15,7 @@
>  #include <linux/err.h>
>  #include <linux/of.h>
>  #include <linux/notifier.h>
> +#include <linux/cpuidle.h>
>  
>  enum gpd_status {
>  	GPD_STATE_ACTIVE = 0,	/* PM domain is active */
> @@ -45,6 +46,11 @@ struct gpd_dev_ops {
>  	bool (*active_wakeup)(struct device *dev);
>  };
>  
> +struct gpd_cpu_data {
> +	unsigned int saved_exit_latency;
> +	struct cpuidle_state *idle_state;
> +};
> +
>  struct generic_pm_domain {
>  	struct dev_pm_domain domain;	/* PM domain operations */
>  	struct list_head gpd_list_node;	/* Node in the global PM domains list */
> @@ -75,6 +81,7 @@ struct generic_pm_domain {
>  	bool max_off_time_changed;
>  	bool cached_power_down_ok;
>  	struct device_node *of_node; /* Node in device tree */
> +	struct gpd_cpu_data *cpu_data;
>  };
>  
>  static inline struct generic_pm_domain *pd_to_genpd(struct dev_pm_domain *pd)
> @@ -155,6 +162,8 @@ extern int pm_genpd_add_callbacks(struct
>  				  struct gpd_dev_ops *ops,
>  				  struct gpd_timing_data *td);
>  extern int __pm_genpd_remove_callbacks(struct device *dev, bool clear_td);
> +extern int genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state);
> +extern int genpd_detach_cpuidle(struct generic_pm_domain *genpd);
>  extern void pm_genpd_init(struct generic_pm_domain *genpd,
>  			  struct dev_power_governor *gov, bool is_off);
>  
> @@ -211,6 +220,14 @@ static inline int __pm_genpd_remove_call
>  {
>  	return -ENOSYS;
>  }
> +static inline int genpd_attach_cpuidle(struct generic_pm_domain *genpd, int st)
> +{
> +	return -ENOSYS;
> +}
> +static inline int genpd_detach_cpuidle(struct generic_pm_domain *genpd)
> +{
> +	return -ENOSYS;
> +}
>  static inline void pm_genpd_init(struct generic_pm_domain *genpd,
>  				 struct dev_power_governor *gov, bool is_off)
>  {
> Index: linux/drivers/base/power/domain.c
> ===================================================================
> --- linux.orig/drivers/base/power/domain.c
> +++ linux/drivers/base/power/domain.c
> @@ -139,6 +139,19 @@ static void genpd_set_active(struct gene
>  		genpd->status = GPD_STATE_ACTIVE;
>  }
>  
> +static void genpd_recalc_cpu_exit_latency(struct generic_pm_domain *genpd)
> +{
> +	s64 usecs64;
> +
> +	if (!genpd->cpu_data)
> +		return;
> +
> +	usecs64 = genpd->power_on_latency_ns;
> +	do_div(usecs64, NSEC_PER_USEC);
> +	usecs64 += genpd->cpu_data->saved_exit_latency;
> +	genpd->cpu_data->idle_state->exit_latency = usecs64;
> +}
> +
>  /**
>   * __pm_genpd_poweron - Restore power to a given PM domain and its masters.
>   * @genpd: PM domain to power up.
> @@ -176,6 +189,13 @@ int __pm_genpd_poweron(struct generic_pm
>  		return 0;
>  	}
>  
> +	if (genpd->cpu_data) {
> +		cpuidle_pause_and_lock();
> +		genpd->cpu_data->idle_state->disabled = true;
> +		cpuidle_resume_and_unlock();
> +		goto out;
> +	}
> +
>  	/*
>  	 * The list is guaranteed not to change while the loop below is being
>  	 * executed, unless one of the masters' .power_on() callbacks fiddles
> @@ -215,6 +235,7 @@ int __pm_genpd_poweron(struct generic_pm
>  		if (elapsed_ns > genpd->power_on_latency_ns) {
>  			genpd->power_on_latency_ns = elapsed_ns;
>  			genpd->max_off_time_changed = true;
> +			genpd_recalc_cpu_exit_latency(genpd);
>  			if (genpd->name)
>  				pr_warning("%s: Power-on latency exceeded, "
>  					"new value %lld ns\n", genpd->name,
> @@ -222,6 +243,7 @@ int __pm_genpd_poweron(struct generic_pm
>  		}
>  	}
>  
> + out:
>  	genpd_set_active(genpd);
>  
>  	return 0;
> @@ -458,6 +480,21 @@ static int pm_genpd_poweroff(struct gene
>  		}
>  	}
>  
> +	if (genpd->cpu_data) {
> +		/*
> +		 * If cpu_data is set, cpuidle should turn the domain off when
> +		 * the CPU in it is idle.  In that case we don't decrement the
> +		 * subdomain counts of the master domains, so that power is not
> +		 * removed from the current domain prematurely as a result of
> +		 * cutting off the masters' power.
> +		 */
> +		genpd->status = GPD_STATE_POWER_OFF;
> +		cpuidle_pause_and_lock();
> +		genpd->cpu_data->idle_state->disabled = false;
> +		cpuidle_resume_and_unlock();
> +		goto out;
> +	}
> +
>  	if (genpd->power_off) {
>  		ktime_t time_start;
>  		s64 elapsed_ns;
> @@ -1606,6 +1643,86 @@ int __pm_genpd_remove_callbacks(struct d
>  }
>  EXPORT_SYMBOL_GPL(__pm_genpd_remove_callbacks);
>  
> +int genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state)
> +{
> +	struct cpuidle_driver *cpuidle_drv;
> +	struct gpd_cpu_data *cpu_data;
> +	struct cpuidle_state *idle_state;
> +	int ret = 0;
> +
> +	if (IS_ERR_OR_NULL(genpd) || state < 0)
> +		return -EINVAL;
> +
> +	genpd_acquire_lock(genpd);
> +
> +	if (genpd->cpu_data) {
> +		ret = -EEXIST;
> +		goto out;
> +	}
> +	cpu_data = kzalloc(sizeof(*cpu_data), GFP_KERNEL);
> +	if (!cpu_data) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	cpuidle_drv = cpuidle_driver_ref();
> +	if (!cpuidle_drv) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +	if (cpuidle_drv->state_count <= state) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +	idle_state = &cpuidle_drv->states[state];
> +	if (!idle_state->disabled) {
> +		ret = -EAGAIN;
> +		goto err;
> +	}
> +	cpu_data->idle_state = idle_state;
> +	cpu_data->saved_exit_latency = idle_state->exit_latency;
> +	genpd->cpu_data = cpu_data;
> +	genpd_recalc_cpu_exit_latency(genpd);
> +
> + out:
> +	genpd_release_lock(genpd);
> +	return ret;
> +
> + err:
> +	cpuidle_driver_unref();
> +	goto out;
> +}
> +
> +int genpd_detach_cpuidle(struct generic_pm_domain *genpd)
> +{
> +	struct gpd_cpu_data *cpu_data;
> +	struct cpuidle_state *idle_state;
> +	int ret = 0;
> +
> +	if (IS_ERR_OR_NULL(genpd))
> +		return -EINVAL;
> +
> +	genpd_acquire_lock(genpd);
> +
> +	cpu_data = genpd->cpu_data;
> +	if (!cpu_data) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +	idle_state = cpu_data->idle_state;
> +	if (!idle_state->disabled) {
> +		ret = -EAGAIN;
> +		goto out;
> +	}
> +	idle_state->exit_latency = cpu_data->saved_exit_latency;
> +	cpuidle_driver_unref();
> +	genpd->cpu_data = NULL;
> +	kfree(cpu_data);
> +
> + out:
> +	genpd_release_lock(genpd);
> +	return ret;
> +}
> +
>  /* Default device callbacks for generic PM domains. */
>  
>  /**
> Index: linux/drivers/cpuidle/cpuidle.c
> ===================================================================
> --- linux.orig/drivers/cpuidle/cpuidle.c
> +++ linux/drivers/cpuidle/cpuidle.c
> @@ -265,6 +265,7 @@ static void poll_idle_init(struct cpuidl
>  	state->power_usage = -1;
>  	state->flags = 0;
>  	state->enter = poll_idle;
> +	state->disabled = false;
>  }
>  #else
>  static void poll_idle_init(struct cpuidle_driver *drv) {}
> Index: linux/include/linux/cpuidle.h
> ===================================================================
> --- linux.orig/include/linux/cpuidle.h
> +++ linux/include/linux/cpuidle.h
> @@ -47,6 +47,7 @@ struct cpuidle_state {
>  	unsigned int	exit_latency; /* in US */
>  	int		power_usage; /* in mW */
>  	unsigned int	target_residency; /* in US */
> +	bool		disabled; /* disabled on all CPUs */
>  
>  	int (*enter)	(struct cpuidle_device *dev,
>  			struct cpuidle_driver *drv,
> Index: linux/drivers/cpuidle/governors/menu.c
> ===================================================================
> --- linux.orig/drivers/cpuidle/governors/menu.c
> +++ linux/drivers/cpuidle/governors/menu.c
> @@ -281,6 +281,7 @@ static int menu_select(struct cpuidle_dr
>  	 * unless the timer is happening really really soon.
>  	 */
>  	if (data->expected_us > 5 &&
> +	    !drv->states[CPUIDLE_DRIVER_STATE_START].disabled &&
>  		dev->states_usage[CPUIDLE_DRIVER_STATE_START].disable == 0)
>  		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
>  
> @@ -292,7 +293,7 @@ static int menu_select(struct cpuidle_dr
>  		struct cpuidle_state *s = &drv->states[i];
>  		struct cpuidle_state_usage *su = &dev->states_usage[i];
>  
> -		if (su->disable)
> +		if (s->disabled || su->disable)
>  			continue;
>  		if (s->target_residency > data->predicted_us)
>  			continue;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

