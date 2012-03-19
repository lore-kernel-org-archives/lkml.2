Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab2CSLp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:45:58 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47082 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab2CSLp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:45:56 -0400
Message-ID: <4F671C64.5020803@linux.vnet.ibm.com>
Date: Mon, 19 Mar 2012 17:15:40 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
CC: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        patches@linaro.org, eduardo.valentin@ti.com, durgadoss.r@intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 3/6] thermal: Add generic cpuhotplug cooling implementation
References: <1332137864-12943-1-git-send-email-amit.kachhap@linaro.org> <1332137864-12943-4-git-send-email-amit.kachhap@linaro.org>
In-Reply-To: <1332137864-12943-4-git-send-email-amit.kachhap@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12031901-7014-0000-0000-000000BF346E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 11:47 AM, Amit Daniel Kachhap wrote:

> This patch adds support for generic cpu thermal cooling low level
> implementations using cpuhotplug based on the thermal level requested
> from user. Different cpu related cooling devices can be registered by the
> user and the binding of these cooling devices to the corresponding
> trip points can be easily done as the registration APIs return the
> cooling device pointer. The user of these APIs are responsible for
> passing the cpumask.
> 


I am really not aware of the cpu thermal cooling stuff, but since this patch
deals with CPU Hotplug (which I am interested in), I have some questions
below..
 

> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> +
> +static int cpuhotplug_get_cur_state(struct thermal_cooling_device *cdev,
> +				 unsigned long *state)
> +{
> +	int ret = -EINVAL;
> +	struct hotplug_cooling_device *hotplug_dev;
> +
> +	mutex_lock(&cooling_cpuhotplug_lock);
> +	list_for_each_entry(hotplug_dev, &cooling_cpuhotplug_list, node) {
> +		if (hotplug_dev && hotplug_dev->cool_dev == cdev) {
> +			*state = hotplug_dev->hotplug_state;
> +			ret = 0;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&cooling_cpuhotplug_lock);
> +	return ret;
> +}
> +
> +/*This cooling may be as ACTIVE type*/
> +static int cpuhotplug_set_cur_state(struct thermal_cooling_device *cdev,
> +				 unsigned long state)
> +{
> +	int cpuid, this_cpu = smp_processor_id();


What prevents this task from being migrated to another CPU?
IOW, what ensures that 'this_cpu' remains valid throughout this function?

I see that you are acquiring mutex locks below.. So this is definitely not
a preempt disabled section.. so I guess my question above is valid..

Or is this code bound to a particular cpu?

> +	struct hotplug_cooling_device *hotplug_dev;
> +
> +	mutex_lock(&cooling_cpuhotplug_lock);
> +	list_for_each_entry(hotplug_dev, &cooling_cpuhotplug_list, node)
> +		if (hotplug_dev && hotplug_dev->cool_dev == cdev)
> +			break;
> +
> +	mutex_unlock(&cooling_cpuhotplug_lock);
> +	if (!hotplug_dev || hotplug_dev->cool_dev != cdev)
> +		return -EINVAL;
> +
> +	if (hotplug_dev->hotplug_state == state)
> +		return 0;
> +
> +	/*
> +	* This cooling device may be of type ACTIVE, so state field can
> +	* be 0 or 1
> +	*/
> +	if (state == 1) {
> +		for_each_cpu(cpuid, hotplug_dev->allowed_cpus) {
> +			if (cpu_online(cpuid) && (cpuid != this_cpu))


What prevents the cpu numbered cpuid from being taken down right at this moment?
Don't you need explicit synchronization with CPU Hotplug using something like
get_online_cpus()/put_online_cpus() here?

> +				cpu_down(cpuid);
> +		}
> +	} else if (state == 0) {
> +		for_each_cpu(cpuid, hotplug_dev->allowed_cpus) {
> +			if (!cpu_online(cpuid) && (cpuid != this_cpu))


Same here.

> +				cpu_up(cpuid);
> +		}
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	hotplug_dev->hotplug_state = state;
> +
> +	return 0;
> +}
> +/* bind hotplug callbacks to cpu hotplug cooling device */
> +static struct thermal_cooling_device_ops cpuhotplug_cooling_ops = {
> +	.get_max_state = cpuhotplug_get_max_state,
> +	.get_cur_state = cpuhotplug_get_cur_state,
> +	.set_cur_state = cpuhotplug_set_cur_state,
> +};
> +

