Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2KBFR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 01:17:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:3816 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab2KBFRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 01:17:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,696,1344236400"; 
   d="scan'208";a="163635556"
Message-ID: <50935756.4090405@intel.com>
Date: Fri, 02 Nov 2012 13:17:10 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 5/7] ACPI / PM: Provide device PM functions operating
 on struct acpi_device
References: <1766582.8gdQKXoi0K@vostro.rjw.lan> <3903921.4RDYB7KMxW@vostro.rjw.lan> <20121030072844.GA6154@aaronlu.sh.intel.com> <2204038.IsGMuMD7u4@vostro.rjw.lan>
In-Reply-To: <2204038.IsGMuMD7u4@vostro.rjw.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 11:20 PM, Rafael J. Wysocki wrote:
> On Tuesday, October 30, 2012 03:28:45 PM Aaron Lu wrote:
>> On Mon, Oct 29, 2012 at 10:11:20AM +0100, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> If the caller of acpi_bus_set_power() already has a pointer to the
>>> struct acpi_device object corresponding to the device in question, it
>>> doesn't make sense for it to go through acpi_bus_get_device(), which
>>> may be costly, because it involves acquiring the global ACPI
>>> namespace mutex.
>>>
>>> For this reason, export the function operating on struct acpi_device
>>> objects used internally by acpi_bus_set_power(), so that it may be
>>> called instead of acpi_bus_set_power() in the above case, and change
>>> its name to acpi_device_set_power().
>>>
>>> Additionally, introduce two inline wrappers for checking ACPI PM
>>> capabilities of devices represented by struct acpi_device objects.
>>
>> What about adding yet another wrapper to check power off capability of
>> the device? If device has _PS3 or _PRx, it means the device can be
>> powered off from ACPI's perspective. This is useful for ZPODD when
>> deciding if platform has the required ability to support it.
> 
> Sure, no problem with that.  Perhaps you can cut a patch for that
> on top of this series?

Do you think it is reasonable to add a new field to acpi_state.flags to
represent if we, as OSPM, have a way to put the device into a ACPI
device state? This field can be set once in acpi_bus_get_power_flags and
used afterwards.

The valid field of acpi_state.flags is what we have today, and it means
whether this ACPI device state is valid for the device, but not that if
OSPM can actually put the device into that power state.

Thanks,
Aaron

> 
> Rafael
> 
> 
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> ---
>>>  drivers/acpi/bus.c      |   15 ++++++++++++---
>>>  include/acpi/acpi_bus.h |   11 +++++++++++
>>>  2 files changed, 23 insertions(+), 3 deletions(-)
>>>
>>> Index: linux/drivers/acpi/bus.c
>>> ===================================================================
>>> --- linux.orig/drivers/acpi/bus.c
>>> +++ linux/drivers/acpi/bus.c
>>> @@ -257,7 +257,15 @@ static int __acpi_bus_get_power(struct a
>>>  }
>>>  
>>>  
>>> -static int __acpi_bus_set_power(struct acpi_device *device, int state)
>>> +/**
>>> + * acpi_device_set_power - Set power state of an ACPI device.
>>> + * @device: Device to set the power state of.
>>> + * @state: New power state to set.
>>> + *
>>> + * Callers must ensure that the device is power manageable before using this
>>> + * function.
>>> + */
>>> +int acpi_device_set_power(struct acpi_device *device, int state)
>>>  {
>>>  	int result = 0;
>>>  	acpi_status status = AE_OK;
>>> @@ -341,6 +349,7 @@ static int __acpi_bus_set_power(struct a
>>>  
>>>  	return result;
>>>  }
>>> +EXPORT_SYMBOL(acpi_device_set_power);
>>>  
>>>  
>>>  int acpi_bus_set_power(acpi_handle handle, int state)
>>> @@ -359,7 +368,7 @@ int acpi_bus_set_power(acpi_handle handl
>>>  		return -ENODEV;
>>>  	}
>>>  
>>> -	return __acpi_bus_set_power(device, state);
>>> +	return acpi_device_set_power(device, state);
>>>  }
>>>  EXPORT_SYMBOL(acpi_bus_set_power);
>>>  
>>> @@ -402,7 +411,7 @@ int acpi_bus_update_power(acpi_handle ha
>>>  	if (result)
>>>  		return result;
>>>  
>>> -	result = __acpi_bus_set_power(device, state);
>>> +	result = acpi_device_set_power(device, state);
>>>  	if (!result && state_p)
>>>  		*state_p = state;
>>>  
>>> Index: linux/include/acpi/acpi_bus.h
>>> ===================================================================
>>> --- linux.orig/include/acpi/acpi_bus.h
>>> +++ linux/include/acpi/acpi_bus.h
>>> @@ -338,6 +338,7 @@ acpi_status acpi_bus_get_status_handle(a
>>>  				       unsigned long long *sta);
>>>  int acpi_bus_get_status(struct acpi_device *device);
>>>  int acpi_bus_set_power(acpi_handle handle, int state);
>>> +int acpi_device_set_power(struct acpi_device *device, int state);
>>>  int acpi_bus_update_power(acpi_handle handle, int *state_p);
>>>  bool acpi_bus_power_manageable(acpi_handle handle);
>>>  bool acpi_bus_can_wakeup(acpi_handle handle);
>>> @@ -482,6 +483,16 @@ static inline int acpi_pm_device_sleep_w
>>>  }
>>>  #endif
>>>  
>>> +static inline bool acpi_device_power_manageable(struct acpi_device *adev)
>>> +{
>>> +	return adev->flags.power_manageable;
>>> +}
>>> +
>>> +static inline bool acpi_device_can_wakeup(struct acpi_device *adev)
>>> +{
>>> +	return adev->wakeup.flags.valid;
>>> +}
>>> +
>>>  #else	/* CONFIG_ACPI */
>>>  
>>>  static inline int register_acpi_bus_type(void *bus) { return 0; }
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

