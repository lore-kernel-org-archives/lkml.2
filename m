Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2KLVJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:09:43 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42977 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2KLVJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:09:41 -0500
MIME-Version: 1.0
In-Reply-To: <1352752016-3136-1-git-send-email-daniel.lezcano@linaro.org>
References: <50831CA3.2020602@linaro.org>
	<1352752016-3136-1-git-send-email-daniel.lezcano@linaro.org>
Date: Mon, 12 Nov 2012 13:09:40 -0800
X-Google-Sender-Auth: tDs-ukTwVgeaPPIysxrPSZbAyTo
Message-ID: <CAODwPW-yjzrAFRA4Bv-MZETFEfq+cpaLvHaYX5K5HBtQtJKZQA@mail.gmail.com>
Subject: Re: [RFC] cpuidle - remove the power_specified field in the driver
From: Julius Werner <jwerner@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org, khilman@ti.com, len.brown@intel.com,
        Trinabh Gupta <g.trinabh@gmail.com>, deepthi@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, akpm@linux-foundation.org,
        Sameer Nanda <snanda@chromium.org>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for moving this along, Daniel. I think this is the right
approach... the cpuidle driver shouldn't be more complex than
necessary.

Note that you are starting your loop too high in cpuidle_play_dead...
states[state_count] is not an actual state anymore, it should start at
state_count - 1. Also, I think you can go ahead and do the same
last-to-first loop transformation with immediate return in the menu
governor, for an extra tiny bit of performance.

On Mon, Nov 12, 2012 at 12:26 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> This patch follows the discussion about reinitializing the power usage
> when a C-state is added/removed.
>
>  https://lkml.org/lkml/2012/10/16/518
>
> We realized the power usage field is never filled and when it is
> filled for tegra, the power_specified flag is not set making all these
> values to be resetted when the driver is initialized with the set_power_state
> function.
>
> Julius and I feel this is over-engineered and the power_specified
> flag could be simply removed and continue assuming the states are
> backward sorted.
>
> The menu governor select function is simplified as the power is ordered.
> Actually the condition is always true with the current code.
>
> The cpuidle_play_dead function is also simplified by doing a reverse lookup
> on the array.
>
> The set_power_states function is removed as it does no make sense anymore.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  drivers/cpuidle/cpuidle.c        |   17 ++++-------------
>  drivers/cpuidle/driver.c         |   25 -------------------------
>  drivers/cpuidle/governors/menu.c |    8 ++------
>  include/linux/cpuidle.h          |    2 +-
>  4 files changed, 7 insertions(+), 45 deletions(-)
>
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 711dd83..f983262 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -69,24 +69,15 @@ int cpuidle_play_dead(void)
>  {
>         struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
>         struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
> -       int i, dead_state = -1;
> -       int power_usage = -1;
> +       int i;
>
>         if (!drv)
>                 return -ENODEV;
>
>         /* Find lowest-power state that supports long-term idle */
> -       for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
> -               struct cpuidle_state *s = &drv->states[i];
> -
> -               if (s->power_usage < power_usage && s->enter_dead) {
> -                       power_usage = s->power_usage;
> -                       dead_state = i;
> -               }
> -       }
> -
> -       if (dead_state != -1)
> -               return drv->states[dead_state].enter_dead(dev, dead_state);
> +       for (i = drv->state_count; i >= CPUIDLE_DRIVER_STATE_START; i--)
> +               if (drv->states[i].play_dead)
> +                       return drv->states[i].enter_dead(dev, i);
>
>         return -ENODEV;
>  }
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 3af841f..bb045f1 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -19,34 +19,9 @@ DEFINE_SPINLOCK(cpuidle_driver_lock);
>  static void __cpuidle_set_cpu_driver(struct cpuidle_driver *drv, int cpu);
>  static struct cpuidle_driver * __cpuidle_get_cpu_driver(int cpu);
>
> -static void set_power_states(struct cpuidle_driver *drv)
> -{
> -       int i;
> -
> -       /*
> -        * cpuidle driver should set the drv->power_specified bit
> -        * before registering if the driver provides
> -        * power_usage numbers.
> -        *
> -        * If power_specified is not set,
> -        * we fill in power_usage with decreasing values as the
> -        * cpuidle code has an implicit assumption that state Cn
> -        * uses less power than C(n-1).
> -        *
> -        * With CONFIG_ARCH_HAS_CPU_RELAX, C0 is already assigned
> -        * an power value of -1.  So we use -2, -3, etc, for other
> -        * c-states.
> -        */
> -       for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++)
> -               drv->states[i].power_usage = -1 - i;
> -}
> -
>  static void __cpuidle_driver_init(struct cpuidle_driver *drv)
>  {
>         drv->refcnt = 0;
> -
> -       if (!drv->power_specified)
> -               set_power_states(drv);
>  }
>
>  static int __cpuidle_register_driver(struct cpuidle_driver *drv, int cpu)
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 2efee27..14eb11f 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -312,7 +312,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  {
>         struct menu_device *data = &__get_cpu_var(menu_devices);
>         int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
> -       int power_usage = -1;
>         int i;
>         int multiplier;
>         struct timespec t;
> @@ -383,11 +382,8 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>                 if (s->exit_latency * multiplier > data->predicted_us)
>                         continue;
>
> -               if (s->power_usage < power_usage) {
> -                       power_usage = s->power_usage;
> -                       data->last_state_idx = i;
> -                       data->exit_us = s->exit_latency;
> -               }
> +               data->last_state_idx = i;
> +               data->exit_us = s->exit_latency;
>         }
>
>         /* not deepest C-state chosen for low predicted residency */
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 3711b34..24cd103 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -126,9 +126,9 @@ struct cpuidle_driver {
>         struct module           *owner;
>         int                     refcnt;
>
> -       unsigned int            power_specified:1;
>         /* set to 1 to use the core cpuidle time keeping (for all states). */
>         unsigned int            en_core_tk_irqen:1;
> +       /* states array must be ordered in decreasing power consumption */
>         struct cpuidle_state    states[CPUIDLE_STATE_MAX];
>         int                     state_count;
>         int                     safe_state_index;
> --
> 1.7.5.4
>
