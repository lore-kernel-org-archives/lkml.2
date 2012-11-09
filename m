Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab2KIOJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:09:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:45418 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab2KIOJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:09:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,745,1344236400"; 
   d="scan'208";a="217282606"
Message-ID: <509D0F1F.70001@linux.intel.com>
Date: Fri, 09 Nov 2012 16:11:43 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <1351928793-14375-2-git-send-email-mika.westerberg@linux.intel.com> <CACxGe6tVcqoSg03JtcTdLP5GakyKM-24D8uK2mQj+1iiSE8Yog@mail.gmail.com> <20121108193808.GB16012@intel.com>
In-Reply-To: <20121108193808.GB16012@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 09:38 PM, Mika Westerberg wrote:
...
>>> +#include<linux/errno.h>
>>> +#include<linux/gpio.h>
>>> +#include<linux/module.h>
>>> +#include<linux/acpi_gpio.h>
>>> +#include<linux/acpi.h>
>>> +
>>> +static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
>>> +{
>>> +       acpi_handle handle = data;
>>> +       acpi_handle gc_handle;
>>> +
>>> +       if (!gc->dev)
>>> +               return false;
>>> +
>>> +       gc_handle = gc->dev->acpi_handle;
>>> +       if (!gc_handle)
>>> +               return false;
>>
>> This test is redundant with the next one... unless 'handle' is also NULL :-)
>>
>> Is it at all possible for multiple gpiochips to be used for a single
>> ACPI gpio controller node? Such as if the gpio controller has multiple
>> banks that should be controlled separately? If so then this won't be
>> sufficient. I've got the same issue with DT support where the find
>> function needs to also check if the pin is provided by that specific
>> gpiochip.
>
> AFAIK no but I'll let Mathias to answer that as he knows this better.

I'm interpreting it the same way as Mika, max one actual controller per 
ACPI device node

The path (called ResourceSource in ACPI5 specs) in GpioIO/GpioInt 
resources is a "string which uniquely identifies the GPIO controller 
referred to by this descriptor."  The pin number is zero based 
controller relative.

The  ACPI device controller node includes all other resources needed by 
the controller driver (ioport/mem base, range, interrupt, and Hardware 
ID used to pair with a driver)

Checked a board with two identical gpio controllers on it and it had two 
separate ACPI device node entries. (with only different io address base 
and interrupt resources)

-Mathias

>
>> Overall the patch looks good, but I need to see how it is used. It
>> would be really nice if device drivers could use basically the same
>> interface to obtain Linux gpio numbers regardless of if the backing
>> data was ACPI or DT. This API is one level below that.
>
> Yeah, this patch just mimics the DT version but in general it would be
> better if there was only one API to get the GPIO. There has been discussion
> about adding gpio_get() or something similar which could perhaps be used to
> abstract away DT or ACPI.
>
> We use this in a driver so that we walk through the ACPI resources for a
> given device (if we have the ACPI handle) and parse the GpioIO/GpioInt
> resources like:
>
> 	struct acpi_resource_gpio *acpi_gpio;
> 	struct acpi_device *adev;
> 	acpi_resource *res;
> 	int gpio;
>
> 	/* obtain the ACPI device from handle */
> 	...
>
> 	/* walk through the resources attached to adev */
> 	...
> 		switch (res->type) {
> 		case ACPI_RESOURCE_TYPE_GPIO:
> 			acpi_gpio =&res->data.gpio;
>
> 			gpio = acpi_get_gpio(acpi_gpio->resource_source.string_ptr,
> 					     acpi_gpio->pin_table[0]);
> 			...
> 		}

