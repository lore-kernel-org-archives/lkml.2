Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2JTVue (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 17:50:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55047 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2JTVuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 17:50:32 -0400
Message-ID: <50831CA3.2020602@linaro.org>
Date: Sat, 20 Oct 2012 23:50:27 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: linux-kernel@vger.kernel.org, len.brown@intel.com, khilman@ti.com,
        rjw@sisk.pl, deepthi@linux.vnet.ibm.com, akpm@linux-foundation.org,
        g.trinabh@gmail.com, snanda@chromium.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] acpi/cpuidle: reinitialize power_usage values when adding/removing
 C-states
References: <507FBC20.50004@linaro.org> <1350683446-8244-1-git-send-email-jwerner@chromium.org>
In-Reply-To: <1350683446-8244-1-git-send-email-jwerner@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 11:50 PM, Julius Werner wrote:
> When cpuidle drivers do not supply explicit power_usage values,
> cpuidle/driver.c inserts dummy values instead. When a running processor
> dynamically gains new C-states (e.g. after ACPI events), the power_usage
> values of those states will stay uninitialized, and cpuidle governors
> will never choose to enter them.
> 
> This patch ensures that the ACPI cpuidle driver sets those dummy power
> values itself whenever it (re-)initializes its idle states.
> Tested and verified on an Acer AC700 Chromebook, which supports the C3
> state only when it switches from AC to battery power.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---

I am not against this patch but I am wondering if it is not time to do
some cleanup around this.

The flag 'power_specified' is never used in any driver.

And the field 'power_usage' is used only in the tegra3 driver where
logically as power_specified is not set, it will be overwritten at the
init (could someone could check the
/sys/devices/system/cpu/cpu0/cpuidle/state1/power is different from 600
on tegra3 ?)

The drivers define their states in a power consumption descendant order
making de facto the same ordering than the 'set_power_state' function in
driver.c

The governor looks at the power_usage (which is always filled by
'set_power_state').

static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device
*dev)
		
		[ ... ]

                if (s->power_usage < power_usage) {
                        power_usage = s->power_usage;
                        data->last_state_idx = i;
                        data->exit_us = s->exit_latency;
                }

		[ ... ]

Could we just say this is always true because state[i+1] consumes less
than state[i] ?

And then just remove the 'set_power_state' function, and the field
'driver->power_specified' ?

That will cleanup the code and fix this problem, no ?

Thanks
  -- Daniel

>  drivers/acpi/processor_idle.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index e8086c7..078e22f 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -1090,6 +1090,9 @@ static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
>  		state->exit_latency = cx->latency;
>  		state->target_residency = cx->latency * latency_factor;
>  
> +		/* reinitialize this in case new states are added after boot */
> +		state->power_usage = -1 - count;
> +
>  		state->flags = 0;
>  		switch (cx->type) {
>  			case ACPI_STATE_C1:


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

