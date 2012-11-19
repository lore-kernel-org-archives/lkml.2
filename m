Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab2KSQXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:23:42 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35641 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab2KSQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:23:39 -0500
Date: Mon, 19 Nov 2012 08:23:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI / platform: Initialize ACPI handles of platform
 devices in advance
Message-ID: <20121119162334.GA1653@kroah.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121118155539.GE17774@intel.com>
 <1758879.PKgPhTGcB7@vostro.rjw.lan>
 <676649340.5Y2WB7IFNB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <676649340.5Y2WB7IFNB@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 10:13:59PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The current platform device creation and registration code in
> acpi_create_platform_device() is quite convoluted.  This function
> takes an ACPI device node as an argument and eventually calls
> platform_device_register_resndata() to create and register a
> platform device object on the basis of the information contained
> in that code.  However, it doesn't associate the new platform
> device with the ACPI node directly, but instead it relies on
> acpi_platform_notify(), called from within device_add(), to find
> that ACPI node again with the help of acpi_platform_find_device()
> and acpi_platform_match() and then attach the new platform device
> to it.  This causes an additional ACPI namespace walk to happen and
> is clearly suboptimal.
> 
> Use the observation that it is now possible to initialize the ACPI
> handle of a device before calling device_add() for it to make this
> code more straightforward.  Namely, add a new field to struct
> platform_device_info allowing us to pass the ACPI handle of interest
> to platform_device_register_full(), which will then use it to
> initialize the new device's ACPI handle before registering it.
> This will cause acpi_platform_notify() to use the ACPI handle from
> the device structure directly instead of using the .find_device()
> routine provided by the device's bus type.  In consequence,
> acpi_platform_bus, acpi_platform_find_device(), and
> acpi_platform_match() are not necessary any more, so remove them.

Why can't you use the platform_data * that is already in struct device
for this, instead of adding an acpi-specific field to the
platform_device structure?

If not that, surely there is another field in struct device that you
could use that is free for this type of device?

>  struct platform_device_info {
>  		struct device *parent;
> +		void *acpi_handle;

Oh, and if I do accept this, I want a "real" structure pointer here
please, not a void * "handle".  That way is a slippery slope to the
Windows kernel programming style :)

thanks,

greg k-h
