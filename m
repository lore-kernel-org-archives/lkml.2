Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab0IWAEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:04:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60873 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab0IWAES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:04:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH v3] power: introduce library for device-specific OPPs
Date: Thu, 23 Sep 2010 02:03:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@lists.linux-foundation.org>,
        "l-o" <linux-omap@vger.kernel.org>,
        "l-a" <linux-arm-kernel@lists.infradead.org>,
        "linux-doc" <linux-doc@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
References: <[PATCH] opp: introduce library for device-specific OPPs> <1285192054-454-1-git-send-email-nm@ti.com>
In-Reply-To: <1285192054-454-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009230203.09230.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trimming the CC list slightly.]

Hi,

On Wednesday, September 22, 2010, Nishanth Menon wrote:
> SOCs have a standard set of tuples consisting of frequency and
> voltage pairs that the device will support per voltage domain. These
> are called Operating Performance Points or OPPs. The actual
> definitions of OPP varies over silicon versions. For a specific domain,
> we can have a set of {frequency, voltage} pairs. As the kernel boots
> and more information is available, a default set of these are activated
> based on the precise nature of device. Further on operation, based on
> conditions prevailing in the system (such as temperature), some OPP
> availability may be temporarily controlled by the SoC frameworks.
> 
> To implement an OPP, some sort of power management support is necessary
> hence this library depends on CONFIG_PM.
...
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> ---
...

First, thanks for addressing the previous comments, things look much better
now.  In particular the documentation has been improved a lot in my view.

>  Documentation/power/00-INDEX |    2 +
>  Documentation/power/opp.txt  |  330 ++++++++++++++++++++++++++
>  drivers/base/power/Makefile  |    1 +
>  drivers/base/power/opp.c     |  534 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/opp.h          |  103 ++++++++
>  kernel/power/Kconfig         |   14 ++
>  6 files changed, 984 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/power/opp.txt
>  create mode 100644 drivers/base/power/opp.c
>  create mode 100644 include/linux/opp.h
> 
> diff --git a/Documentation/power/00-INDEX b/Documentation/power/00-INDEX
> index fb742c2..45e9d4a 100644
> --- a/Documentation/power/00-INDEX
> +++ b/Documentation/power/00-INDEX
> @@ -14,6 +14,8 @@ interface.txt
>  	- Power management user interface in /sys/power
>  notifiers.txt
>  	- Registering suspend notifiers in device drivers
> +opp.txt
> +	- Operating Performance Point library
>  pci.txt
>  	- How the PCI Subsystem Does Power Management
>  pm_qos_interface.txt
> diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
> new file mode 100644
> index 0000000..7e41e33
> --- /dev/null
> +++ b/Documentation/power/opp.txt
> @@ -0,0 +1,330 @@
> +*=============*
> +* OPP Library *
> +*=============*
> +
> +Contents
> +--------
> +1. Introduction
> +2. Initial OPP List Registration
> +3. OPP Search Functions
> +4. OPP Availability Control Functions
> +5. OPP Data Retrieval Functions
> +6. Cpufreq Table Generation
> +7. Data Structures
> +
> +1. Introduction
> +===============
> +Complex SOCs of today consists of a multiple sub-modules working in conjunction.
> +In an operational system executing varied use cases, not all modules in the SoC
> +need to function at their highest performing frequency all the time. To
> +facilitate this, sub-modules in a SoC are grouped into domains, allowing some
> +domains to run at lower voltage and frequency while other domains are loaded
> +more. The set of discrete tuples consisting of frequency and voltage pairs that
> +the device will support per domain are called Operating Performance Points or
> +OPPs.
> +
> +OPP library provides a set of helper functions to organize and query the OPP
> +information. The library is located in drivers/base/power/opp.c and the header
> +is located in include/linux/opp.h. OPP library can be enabled by enabling
> +CONFIG_PM_OPP from power management menuconfig menu. OPP library depends on
> +CONFIG_PM as certain SOCs such as Texas Instrument's OMAP framework allows to
> +optionally boot at a certain OPP without needing cpufreq.
> +
> +Typical usage of the OPP library is as follows:
> +(users)		-> registers a set of default OPPs		-> (library)
> +SoC framework	-> modifies on required cases certain OPPs	-> OPP layer
> +		-> queries to search/retrieve information	->
> +
> +OPP layer expects each domain to be represented by a unique device pointer. SoC
> +framework registers a set of initial OPPs per device with the OPP layer. This
> +list is expected to be an optimally small number typically around 5 per device.
> +This initial list contains a set of OPPs that the framework expects to be safely
> +enabled by default in the system.
> +
> +Note on OPP Availability:
> +------------------------
> +As the system proceeds to operate, SoC framework may choose to make certain
> +OPPs available or not available on each device based on various external
> +factors. Example usage: Thermal management or other exceptional situations where
> +SoC framework might choose to disable a higher frequency OPP to safely continue
> +operations until that OPP could be re-enabled if possible.
> +
> +OPP library facilitates this concept in it's implementation. The following
> +operational functions operate only on available opps:
> +opp_find_freq_{ceil, floor}, opp_get_voltage, opp_get_freq, opp_get_opp_count
> +and opp_init_cpufreq_table
> +
> +opp_find_freq_exact is meant to be used to find the opp pointer which can then
> +be used for opp_enable/disable functions to make an opp available as required.
> +
> +WARNING: Users of OPP library should refresh their availability count using
> +get_opp_count if opp_enable/disable functions are invoked for a device, the
> +exact mechanism to trigger these or the notification mechanism to other
> +dependent subsystems such as cpufreq are left to the discretion of the SoC
> +specific framework which uses the OPP library. Similar care needs to be taken
> +care to refresh the cpufreq table in cases of these operations.
> +
> +WARNING on OPP List Modification Vs Query operations:
> +----------------------------------------------------
> +The OPP layer's query functions are expected to be used in multiple contexts
> +(including calls from interrupt locked context) based on SoC framework
> +implementation. Only OPP modification functions are guaranteed exclusivity by
> +the OPP library. Exclusivity between query functions and modification functions
> +should be handled by the users such as the SoC framework appropriately; else,
> +there is a risk for the query functions to retrieve stale data.

Well, this sounds like a good use case for RCU.

...
> diff --git a/drivers/base/power/Makefile b/drivers/base/power/Makefile
> index cbccf9a..abe46ed 100644
> --- a/drivers/base/power/Makefile
> +++ b/drivers/base/power/Makefile
> @@ -3,6 +3,7 @@ obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.o
>  obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
>  obj-$(CONFIG_PM_OPS)	+= generic_ops.o
>  obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
> +obj-$(CONFIG_PM_OPP)	+= opp.o
>  
>  ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
>  ccflags-$(CONFIG_PM_VERBOSE)   += -DDEBUG
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> new file mode 100644
> index 0000000..311fd7f
> --- /dev/null
> +++ b/drivers/base/power/opp.c
> @@ -0,0 +1,534 @@
> +/*
> + * Generic OPP Interface
> + *
> + * Copyright (C) 2009-2010 Texas Instruments Incorporated.
> + *	Nishanth Menon
> + *	Romit Dasgupta
> + *	Kevin Hilman
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/cpufreq.h>
> +#include <linux/list.h>
> +#include <linux/opp.h>
> +
> +/*
> + * Internal data structure organization with the OPP layer library is as
> + * follows:
> + * dev_opp_list (root)
> + *	|- device 1 (represents voltage domain 1)
> + *	|	|- opp 1 (availability, freq, voltage)
> + *	|	|- opp 2 ..
> + *	...	...
> + *	|	`- opp n ..
> + *	|- device 2 (represents the next voltage domain)
> + *	...
> + *	`- device m (represents mth voltage domain)
> + * device 1, 2.. are represented by dev_opp structure while each opp
> + * is represented by the opp structure.
> + */
> +
> +/**
> + * struct opp - Generic OPP description structure
> + * @node:	opp list node. The nodes are maintained throughout the lifetime
> + *		of boot. It is expected only an optimal set of OPPs are
> + *		added to the library by the SoC framework.
> + *		IMPORTANT: the opp nodes should be maintained in increasing
> + *		order
> + * @available:	true/false - marks if this OPP as available or not
> + * @rate:	Frequency in hertz
> + * @u_volt:	Nominal voltage in microvolts corresponding to this OPP
> + * @dev_opp:	points back to the device_opp struct this opp belongs to
> + *
> + * This structure stores the OPP information for a given device.
> + */
> +struct opp {
> +	struct list_head node;
> +
> +	bool available;
> +	unsigned long rate;
> +	unsigned long u_volt;
> +
> +	struct device_opp *dev_opp;
> +};
> +
> +/**
> + * struct device_opp - Device opp structure
> + * @node:	list node - contains the devices with OPPs that
> + *		have been registered
> + * @lock:	Lock to allow exclusive modification in the list for the device
> + * @dev:	device pointer
> + * @opp_list:	list of opps
> + * @available_opp_count: how many opps are actually available
> + *
> + * This is an internal data structure maintaining the link to opps attached to
> + * a device. This structure is not meant to be shared to users as it is
> + * meant for book keeping and private to OPP library
> + */
> +struct device_opp {
> +	struct list_head node;
> +	/* mutex for exclusive modification of device OPP list */
> +	struct mutex lock;
> +
> +	struct device *dev;
> +
> +	struct list_head opp_list;
> +	u32 available_opp_count;
> +};
> +
> +/*
> + * The root of the list of all devices. All device_opp structures branch off
> + * from here, with each device_opp containing the list of opp it supports in
> + * various states of availability.
> + */
> +static LIST_HEAD(dev_opp_list);
> +/* Lock to allow exclusive modification to the device list */
> +static DEFINE_MUTEX(dev_opp_list_lock);
> +
> +/**
> + * find_device_opp() - find device_opp struct using device pointer
> + * @dev:	device pointer used to lookup device OPPs
> + *
> + * Search list of device OPPs for one containing matching device.
> + *
> + * Returns pointer to 'struct device_opp' if found, otherwise -ENODEV or
> + * -EINVAL based on type of error.
> + */
> +static struct device_opp *find_device_opp(struct device *dev)
> +{
> +	struct device_opp *tmp_dev_opp, *dev_opp = ERR_PTR(-ENODEV);
> +
> +	if (unlikely(!dev || IS_ERR(dev))) {
> +		pr_err("%s: Invalid parameters being passed\n", __func__);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	list_for_each_entry(tmp_dev_opp, &dev_opp_list, node) {
> +		if (tmp_dev_opp->dev == dev) {
> +			dev_opp = tmp_dev_opp;
> +			break;
> +		}
> +	}

As I said, it seems you can use RCU read locking around the list traversal
to protect it from concurrent modification.

> +	return dev_opp;
> +}
> +
...

> +/**
> + * opp_find_freq_exact() - search for an exact frequency
> + * @dev:		device for which we do this operation
> + * @freq:		frequency to search for
> + * @is_available:	true/false - match for available opp
> + *
> + * Searches for exact match in the opp list and returns pointer to the matching
> + * opp if found, else returns ERR_PTR in case of error and should be handled
> + * using IS_ERR.
> + *
> + * Note: available is a modifier for the search. if available=true, then the
> + * match is for exact matching frequency and is available in the stored OPP
> + * table. if false, the match is for exact frequency which is not available.
> + *
> + * This provides a mechanism to enable an opp which is not available currently
> + * or the opposite as well.
> + *
> + * WARNING: using this api simultaneously with opp_add/enable/disable may
> + * result in stale data. To ensure sanity of results, callers must ensure
> + * exclusivity from mentioned functions in some form.
> + */
> +struct opp *opp_find_freq_exact(struct device *dev,
> +				     unsigned long freq, bool available)
> +{
> +	struct device_opp *dev_opp;
> +	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
> +
> +	dev_opp = find_device_opp(dev);
> +	if (IS_ERR(dev_opp))
> +		return opp;
> +
> +	list_for_each_entry(temp_opp, &dev_opp->opp_list, node) {
> +		if (temp_opp->available == available &&
> +				temp_opp->rate == freq) {
> +			opp = temp_opp;
> +			break;
> +		}
> +	}
> +

Same here.

> +	return opp;
> +}
> +
> +/**
> + * opp_find_freq_ceil() - Search for an rounded ceil freq
> + * @dev:	device for which we do this operation
> + * @freq:	Start frequency
> + *
> + * Search for the matching ceil *available* OPP from a starting freq
> + * for a device.
> + *
> + * Returns matching *opp and refreshes *freq accordingly, else returns
> + * ERR_PTR in case of error and should be handled using IS_ERR.
> + *
> + * Example usages:
> + *	* find match/next highest available frequency *
> + *	freq = 350000;
> + *	opp = opp_find_freq_ceil(dev, &freq))
> + *	if (IS_ERR(opp))
> + *		pr_err("unable to find a higher frequency\n");
> + *	else
> + *		pr_info("match freq = %ld\n", freq);
> + *
> + *	* print all supported frequencies in ascending order *
> + *	freq = 0; * Search for the lowest available frequency *
> + *	while (!IS_ERR(opp = opp_find_freq_ceil(OPP_MPU, &freq)) {
> + *		pr_info("freq = %ld\n", freq);
> + *		freq++; * for next higher match *
> + *	}

I think it's sufficient to put the examples into the doc (the ones below too).

> + * WARNING: using this api simultaneously with opp_add/enable/disable may
> + * result in stale data. To ensure sanity of results, callers must ensure
> + * exclusivity from mentioned functions in some form.
> + */
> +struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
> +{
> +	struct device_opp *dev_opp;
> +	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
> +
> +	if (!dev || !freq) {
> +		pr_err("%s: invalid param dev=%p freq=%p\n", __func__,
> +				dev, freq);
> +		return ERR_PTR(-EINVAL);
> +	}
> +	dev_opp = find_device_opp(dev);
> +	if (IS_ERR(dev_opp))
> +		return opp;
> +
> +	list_for_each_entry(temp_opp, &dev_opp->opp_list, node) {
> +		if (temp_opp->available && temp_opp->rate >= *freq) {
> +			opp = temp_opp;
> +			*freq = opp->rate;
> +			break;
> +		}
> +	}

This also may use read-side RCU to protect the list from concurrent
modification IMO.

> +	return opp;
> +}
> +
> +/**
> + * opp_find_freq_floor() - Search for a rounded floor freq
> + * @dev:	device for which we do this operation
> + * @freq:	Start frequency
> + *
> + * Search for the matching floor *available* OPP from a starting freq
> + * for a device.
> + *
...
> + */
> +struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
> +{
> +	struct device_opp *dev_opp;
> +	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
> +
> +	if (!dev || !freq) {
> +		pr_err("%s: invalid param dev=%p freq=%p\n", __func__,
> +				dev, freq);
> +		return ERR_PTR(-EINVAL);
> +	}
> +	dev_opp = find_device_opp(dev);
> +	if (IS_ERR(dev_opp))
> +		return opp;
> +
> +	list_for_each_entry_reverse(temp_opp, &dev_opp->opp_list, node) {
> +		if (temp_opp->available && temp_opp->rate <= *freq) {
> +			opp = temp_opp;
> +			*freq = opp->rate;
> +			break;
> +		}
> +	}

Same here.

> +	return opp;
> +}
> +
> +/**
> + * opp_add()  - Add an OPP table from a table definitions
> + * @dev:	device for which we do this operation
> + * @freq:	Frequency in Hz for this OPP
> + * @u_volt:	Voltage in uVolts for this OPP
> + *
> + * This function adds an opp definition to the opp list and returns status.
> + * The opp is made available by default and it can be controlled using
> + * opp_enable/disable functions.
> + *
> + * WARNING: This function should not be used in interrupt context.
> + */
> +int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
> +{
> +	struct device_opp *tmp_dev_opp, *dev_opp = NULL;
> +	struct opp *opp, *new_opp;
> +	struct list_head *head;
> +
> +	/* Check for existing list for 'dev' */
> +	list_for_each_entry(tmp_dev_opp, &dev_opp_list, node) {
> +		if (dev == tmp_dev_opp->dev) {
> +			dev_opp = tmp_dev_opp;
> +			break;
> +		}
> +	}

You need to ensure that the list won't change while you're traversing it here.
In fact, it should not change until the changes you're going to make are
complete, unless you can guarantee that no one will remove the
dev_opp you've just found (perhaps you can).

I think it would be sufficient to use a single spinlock to protect the entire
data structure from concurrent modification if memory allocations were
made upfront.

> +	/* allocate new OPP node */
> +	new_opp = kzalloc(sizeof(struct opp), GFP_KERNEL);
> +	if (!new_opp) {
> +		pr_warning("%s: unable to allocate new opp node\n",
> +			__func__);
> +		return -ENOMEM;
> +	}
> +
> +	if (!dev_opp) {
> +		/* Allocate a new device OPP table */
> +		dev_opp = kzalloc(sizeof(struct device_opp), GFP_KERNEL);
> +		if (!dev_opp) {
> +			kfree(new_opp);
> +			pr_warning("%s: unable to allocate device structure\n",
> +				__func__);
> +			return -ENOMEM;
> +		}
> +
> +		dev_opp->dev = dev;
> +		INIT_LIST_HEAD(&dev_opp->opp_list);
> +		mutex_init(&dev_opp->lock);
> +
> +		/* Secure the device list modification */
> +		mutex_lock(&dev_opp_list_lock);
> +		list_add(&dev_opp->node, &dev_opp_list);
> +		mutex_unlock(&dev_opp_list_lock);
> +	}
> +
> +	/* populate the opp table */
> +	new_opp->rate = freq;
> +	new_opp->u_volt = u_volt;
> +	new_opp->available = true;
> +
> +	/* make the dev_opp modification safe */
> +	mutex_lock(&dev_opp->lock);
> +	/* Insert new OPP in order of increasing frequency */
> +	head = &dev_opp->opp_list;
> +	list_for_each_entry_reverse(opp, &dev_opp->opp_list, node) {
> +		if (new_opp->rate >= opp->rate) {
> +			head = &opp->node;
> +			break;
> +		}
> +	}
> +	list_add(&new_opp->node, head);

It seems you should check if the OPP is still there, shouldn't you?

> +	if (new_opp->available)
> +		dev_opp->available_opp_count++;
> +	mutex_unlock(&dev_opp->lock);
> +
> +	return 0;
> +}
> +
> +/**
> + * opp_enable() - Enable a specific OPP
> + * @opp:	Pointer to opp
> + *
> + * Enables a provided opp. If the operation is valid, this returns 0, else the
> + * corresponding error value. It is meant to be used for users an OPP available
> + * after being temporarily made unavailable with opp_disable.
> + *
> + * OPP used here is from the opp_find_freq_* or other search functions
> + * WARNING: This function should not be used in interrupt context.
> + */
> +int opp_enable(struct opp *opp)
> +{
> +	if (unlikely(!opp || IS_ERR(opp))) {
> +		pr_err("%s: Invalid parameters being passed\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&opp->dev_opp->lock);
> +	if (!opp->available && opp->dev_opp)
> +		opp->dev_opp->available_opp_count++;
> +
> +	opp->available = true;
> +	mutex_unlock(&opp->dev_opp->lock);

If these operations don't occur too often, you can use a single lock for
all write-side operations.  That would simplify things quite a bit.

> +	return 0;
> +}
> +
...
> +void opp_init_cpufreq_table(struct device *dev,
> +			    struct cpufreq_frequency_table **table)
> +{
> +	struct device_opp *dev_opp;
> +	struct opp *opp;
> +	struct cpufreq_frequency_table *freq_table;
> +	int i = 0;
> +
> +	dev_opp = find_device_opp(dev);
> +	if (IS_ERR(dev_opp)) {
> +		pr_warning("%s: unable to find device\n", __func__);
> +		return;
> +	}
> +
> +	freq_table = kzalloc(sizeof(struct cpufreq_frequency_table) *
> +			     (dev_opp->available_opp_count + 1), GFP_ATOMIC);
> +	if (!freq_table) {
> +		pr_warning("%s: failed to allocate frequency table\n",
> +			   __func__);
> +		return;
> +	}
> +
> +	list_for_each_entry(opp, &dev_opp->opp_list, node) {
> +		if (opp->available) {
> +			freq_table[i].index = i;
> +			freq_table[i].frequency = opp->rate / 1000;
> +			i++;
> +		}
> +	}

That also may use read-side RCU for protection from concurrent modification.

> +	freq_table[i].index = i;
> +	freq_table[i].frequency = CPUFREQ_TABLE_END;
> +
> +	*table = &freq_table[0];
> +}
> +#endif		/* CONFIG_CPU_FREQ */

The rest looks fine to me.

Thanks,
Rafael
