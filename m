Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161136Ab2KWKKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:10:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:24775 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161082Ab2KWKKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:10:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,306,1352102400"; 
   d="scan'208";a="246138840"
Message-ID: <50AF4C39.4040209@intel.com>
Date: Fri, 23 Nov 2012 12:13:13 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chris Ball <cjb@laptop.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-mmc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add SDHCI ACPI driver
References: <1353573830-13006-1-git-send-email-adrian.hunter@intel.com> <87k3tdagim.fsf@octavius.laptop.org> <50AE3AB2.2070307@intel.com> <3578053.jWYihc5IJI@vostro.rjw.lan> <20121123093416.GR3867@intel.com>
In-Reply-To: <20121123093416.GR3867@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/11/12 11:34, Mika Westerberg wrote:
> On Thu, Nov 22, 2012 at 10:24:33PM +0100, Rafael J. Wysocki wrote:
>> On Thursday, November 22, 2012 04:46:10 PM Adrian Hunter wrote:
>>> On 22/11/12 15:55, Chris Ball wrote:
>>>> Hi,
>>>>
>>>> On Thu, Nov 22 2012, Adrian Hunter wrote:
>>>>> Here is SDHCI ACPI driver.  It is dependent on new ACPI Platform support
>>>>> so I suggest Rafael takes the patches with Chris' Ack.
>>>>>
>>>>> Please note that I would prefer this to be queued for 3.8
>>>>
>>>> Looks fine:
>>>>
>>>> Acked-by: Chris Ball <cjb@laptop.org>
>>>
>>> Thank you!
>>>
>>>>
>>>> I have some dumb questions, though -- what kind of platforms ship with
>>>> these devices?  Do they ever have the controller on PCI too, and what
>>>> happens with sdhci-pci vs. sdhci-acpi in that case?
>>>
>>> Since the arrival of ACPI5, platform devices can be configured using ACPI
>>> tables.  PCI can also be used, but the firmware ensures that the same
>>> device is not enumerated via both ACPI and PCI.
>>>
>>> Rafael can you take these patches?
>>
>> Well, I'd prefer pnpacpi/core.c to actually use acpi_platform_device_ids[]
>> directly in addition to excluded_id_list[], so that duplicate entries don't
>> have to be added to the both of them.
> 
> How about having pnpacpi to check if the ACPI device is already bound to a
> physical device and skip the device creation? Then we don't need to expose
> the acpi_platform_device_ids[] list, and this is what the ->find_device()
> code already does so why create the device in the first place?

Yes, I was going to suggest that too.  AFAICS pnpacpi has no concept of
multiple physical nodes.  Any objections?


> 
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index 5b17cc8..4dc2e64 100644
> --- a/drivers/pnp/pnpacpi/core.c
> +++ b/drivers/pnp/pnpacpi/core.c
> @@ -243,6 +243,10 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
>  	char *pnpid;
>  	struct acpi_hardware_id *id;
>  
> +	/* Skip devices that are already bound */
> +	if (device->physical_node_count)
> +		return 0;
> +
>  	/*
>  	 * If a PnPacpi device is not present , the device
>  	 * driver should not be loaded.
> 
> 

