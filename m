Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab2ADOIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 09:08:05 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37057 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2ADOIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 09:08:04 -0500
MIME-Version: 1.0
X-Originating-IP: [87.66.59.69]
In-Reply-To: <1324426147-16735-2-git-send-email-ccross@android.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
	<1324426147-16735-2-git-send-email-ccross@android.com>
Date: Wed, 4 Jan 2012 15:08:02 +0100
Message-ID: <CAORVsuV-=h9qVcFB7ezEOV2ptLMT=FJcdvaspLj-qAzFK4-NEQ@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 1/3] cpuidle: refactor out cpuidle_enter_state
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,

On Wed, Dec 21, 2011 at 1:09 AM, Colin Cross <ccross@android.com> wrote:
> Split the code to enter a state and update the stats into a helper
> function, cpuidle_enter_state, and export it.  This function will
> be called by the coupled state code to handle entering the safe
> state and the final coupled state.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  drivers/cpuidle/cpuidle.c |   43 +++++++++++++++++++++++++++++--------------
>  drivers/cpuidle/cpuidle.h |    2 ++
>  2 files changed, 31 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 06ce268..1486b3c 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -54,6 +54,34 @@ static void cpuidle_kick_cpus(void) {}
>  static int __cpuidle_register_device(struct cpuidle_device *dev);
>
>  /**
> + * cpuidle_enter_state
> + *
> + * enter the state and update stats
> + */
> +int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
> +               int next_state)
> +{
> +       int entered_state;
> +       struct cpuidle_state *target_state;
> +
> +       target_state = &drv->states[next_state];
> +
> +       entered_state = target_state->enter(dev, drv, next_state);
> +
> +       if (entered_state >= 0) {
> +               /* Update cpuidle counters */
> +               /* This can be moved to within driver enter routine
> +                * but that results in multiple copies of same code.
> +                */
> +               dev->states_usage[entered_state].time +=
> +                               (unsigned long long)dev->last_residency;
> +               dev->states_usage[entered_state].usage++;
> +       }
> +
> +       return entered_state;
> +}
> +
> +/**
>  * cpuidle_idle_call - the main idle loop
>  *
>  * NOTE: no locks or semaphores should be used here
> @@ -63,7 +91,6 @@ int cpuidle_idle_call(void)
>  {
>        struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
>        struct cpuidle_driver *drv = cpuidle_get_driver();
> -       struct cpuidle_state *target_state;
>        int next_state, entered_state;
>
>        if (off)
> @@ -92,26 +119,14 @@ int cpuidle_idle_call(void)
>                return 0;
>        }
>
> -       target_state = &drv->states[next_state];
> -
>        trace_power_start(POWER_CSTATE, next_state, dev->cpu);
>        trace_cpu_idle(next_state, dev->cpu);
>
> -       entered_state = target_state->enter(dev, drv, next_state);
> +       entered_state = cpuidle_enter_state(dev, drv, next_state);
>
>        trace_power_end(dev->cpu);
>        trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
The cpu_idle traces are only present in this function and not in
cpuidle_enter_state. Is that expected? Can all the transitions from
all the cpus get traced that way?

Regards,
Jean
