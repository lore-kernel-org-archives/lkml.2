Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab1DYMAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 08:00:16 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:36818 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab1DYMAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 08:00:14 -0400
Message-ID: <4DB56245.8050203@linux.vnet.ibm.com>
Date: Mon, 25 Apr 2011 17:30:05 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        venki@google.com, ak@linux.intel.com, len.brown@intel.com
CC: davinci-linux-open-source@linux.davincidsp.com, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [linux-pm] [RFC PATCH V3 4/4] cpuidle: Single/Global registration
 of idle states
References: <20110420065445.332.13688.stgit@tringupt.in.ibm.com> <20110420065608.332.30043.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110420065608.332.30043.stgit@tringupt.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[...]

> - * acpi_processor_setup_cpuidle - prepares and configures CPUIDLE
> + * acpi_processor_setup_cpuidle_cx - prepares and configures CPUIDLE
> + * device i.e. per-cpu data
> + *
>    * @pr: the ACPI processor
>    */
> -static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
> +static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr)
>   {
>   	int i, count = CPUIDLE_DRIVER_STATE_START;
>   	struct acpi_processor_cx *cx;
> -	struct cpuidle_state *state;
>   	struct cpuidle_state_usage *state_usage;
>   	struct cpuidle_device *dev =&pr->power.dev;
>
> @@ -1018,18 +1025,12 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
>   	}
>
>   	dev->cpu = pr->id;
> -	dev->safe_state_index = -1;
> -	for (i = 0; i<  CPUIDLE_STATE_MAX; i++) {
> -		dev->states[i].name[0] = '\0';
> -		dev->states[i].desc[0] = '\0';
> -	}
>
>   	if (max_cstate == 0)
>   		max_cstate = 1;
>
>   	for (i = 1; i<  ACPI_PROCESSOR_MAX_POWER&&  i<= max_cstate; i++) {
>   		cx =&pr->power.states[i];
> -		state =&dev->states[count];
>   		state_usage =&dev->states_usage[count];
>
>   		if (!cx->valid)
> @@ -1041,8 +1042,61 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
>   		    !(acpi_gbl_FADT.flags&  ACPI_FADT_C2_MP_SUPPORTED))
>   			continue;
>   #endif
> +
>   		cpuidle_set_statedata(state_usage, cx);
>
> +		count++;
> +		if (count == CPUIDLE_STATE_MAX)
> +			break;
> +	}
> +
> +	dev->state_count = count;
> +
> +	if (!count)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/**
> + * acpi_processor_setup_cpuidle states- prepares and configures cpuidle
> + * global state data i.e. idle routines
> + *
> + * @pr: the ACPI processor
> + */
> +static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
> +{
> +	int i, count = CPUIDLE_DRIVER_STATE_START;
> +	struct acpi_processor_cx *cx;
> +	struct cpuidle_state *state;
> +	struct cpuidle_driver *drv =&acpi_idle_driver;
> +
> +	if (!pr->flags.power_setup_done)
> +		return -EINVAL;
> +
> +	if (pr->flags.power == 0) {
> +		return -EINVAL;
> +	}
> +
> +	drv->safe_state_index = -1;
> +
> +	if (max_cstate == 0)
> +		max_cstate = 1;
> +
> +	for (i = 1; i<  ACPI_PROCESSOR_MAX_POWER&&  i<= max_cstate; i++) {
> +		cx =&pr->power.states[i];
> +
> +		if (!cx->valid)
> +			continue;
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +		if ((cx->type != ACPI_STATE_C1)&&  (num_online_cpus()>  1)&&
> +		    !pr->flags.has_cst&&
> +		    !(acpi_gbl_FADT.flags&  ACPI_FADT_C2_MP_SUPPORTED))
> +			continue;
> +#endif
> +
> +		state =&drv->states[count];
>   		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
>   		strncpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
>   		state->exit_latency = cx->latency;
> @@ -1055,13 +1109,13 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
>   				state->flags |= CPUIDLE_FLAG_TIME_VALID;
>
>   			state->enter = acpi_idle_enter_c1;
> -			dev->safe_state_index = count;
> +			drv->safe_state_index = count;
>   			break;
>
>   			case ACPI_STATE_C2:
>   			state->flags |= CPUIDLE_FLAG_TIME_VALID;
>   			state->enter = acpi_idle_enter_simple;
> -			dev->safe_state_index = count;
> +			drv->safe_state_index = count;
>   			break;
>
>   			case ACPI_STATE_C3:
> @@ -1077,7 +1131,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
>   			break;
>   	}
>
> -	dev->state_count = count;
> +	drv->state_count = count;
>
>   	if (!count)
>   		return -EINVAL;
> @@ -1106,7 +1160,15 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
>   	cpuidle_disable_device(&pr->power.dev);
>   	acpi_processor_get_power_info(pr);
>   	if (pr->flags.power) {
> -		acpi_processor_setup_cpuidle(pr);
> +		/*
> +		 * To Do: Currently state data within driver
> +		 * is not updated. So change this to also update
> +		 * actual state data i.e. what this routine is
> +		 * meant for. Maybe complete unregistration and
> +		 * re-registration.
> +		 *
> +		 */

Hi Len, Arjan

acpi_processor_cst_has_changed is called on switch between AC
power and battery for each cpu. As a result each cpu disables
the cpuidle device, populates the idle state info again and
enables the device. This all works fine for per-cpu registration.

But if we do global registration of idle states then during
the first notification itself we need to disable all devices,
re-populate the states structure and enable all devices. But because
currently each cpu is notified in no particular order this is
not possible. Do you have any suggestions on how to design this?

Reading through the ACPI notification code it looks as if
drivers/acpi/acpica/evxface.c:acpi_install_notify_handler()
registers the device notification for root object i.e. basically
all objects of type CPU. With global registration only one
notification is required and sufficient. Maybe we need to
change the event type to system notification just like
for sleep button?

Thanks,
-Trinabh



> +		acpi_processor_setup_cpuidle_cx(pr);
>   		ret = cpuidle_enable_device(&pr->power.dev);
>   	}
>   	cpuidle_resume_and_unlock();
> @@ -1118,7 +1180,7 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
>   			      struct acpi_device *device)
>   {
>   	acpi_status status = 0;
> -	static int first_run;
> +	static int first_run, acpi_processor_registered;
>
>   	if (disabled_by_idle_boot_param())
>   		return 0;
> @@ -1154,7 +1216,15 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
>   	 * platforms that only support C1.
>   	 */
>   	if (pr->flags.power) {
> -		acpi_processor_setup_cpuidle(pr);
> +		if (!acpi_processor_registered) {
> +			acpi_processor_setup_cpuidle_states(pr);
> +			if (!cpuidle_register_driver(&acpi_idle_driver)) {
> +				printk(KERN_DEBUG "ACPI: %s registered with cpuidle\n",
> +					acpi_idle_driver.name);
> +				acpi_processor_registered = 1;
> +			}
> +		}
> +		acpi_processor_setup_cpuidle_cx(pr);
>   		if (cpuidle_register_device(&pr->power.dev))
>   			return -EIO;
>   	}
> @@ -1168,6 +1238,11 @@ int acpi_processor_power_exit(struct acpi_processor *pr,
>   		return 0;
>
>   	cpuidle_unregister_device(&pr->power.dev);
> +	/* We will have to have unregister driver as well here
> +	 * since we move register_driver to power_init. Maybe
> +	 * just do an unregister everytime; which will be successful
> +	 * only during the last call.
> +	 */
>   	pr->flags.power_setup_done = 0;
>
>   	return 0;

[...]
