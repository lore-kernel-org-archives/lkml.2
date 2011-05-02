Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1EBPo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:44:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:37320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab1EBPow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:44:52 -0400
Date: Mon, 2 May 2011 08:43:22 -0700
From: Greg KH <gregkh@suse.de>
To: wanlong.gao@gmail.com
Cc: rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] KernelDoc:Add the device driver-model structures to
 kerneldoc
Message-ID: <20110502154322.GB8098@suse.de>
References: <1304348681-24950-1-git-send-email-wanlong.gao@gmail.com>
 <1304348681-24950-2-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304348681-24950-2-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 11:04:40PM +0800, wanlong.gao@gmail.com wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> Add the comment the structure bus_type, device_driver, device,
> class for generating the driver-model kerneldoc.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> ---
>  Documentation/DocBook/device-drivers.tmpl |    6 +-
>  include/linux/device.h                    |  104 ++++++++++++++++++++++++++++-
>  2 files changed, 104 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> index 36f63d4..5e482e0 100644
> --- a/Documentation/DocBook/device-drivers.tmpl
> +++ b/Documentation/DocBook/device-drivers.tmpl
> @@ -96,10 +96,10 @@ X!Iinclude/linux/kobject.h
>  
>    <chapter id="devdrivers">
>       <title>Device drivers infrastructure</title>
> +     <sect1><title>The Basic Device Driver-Model Structure </title>
> +!Iinclude/linux/device.h
> +     </sect1>
>       <sect1><title>Device Drivers Base</title>
> -<!--
> -X!Iinclude/linux/device.h
> --->
>  !Edrivers/base/driver.c
>  !Edrivers/base/core.c
>  !Edrivers/base/class.c
> diff --git a/include/linux/device.h b/include/linux/device.h
> index ab8dfc0..5258d5d 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -47,6 +47,23 @@ extern int __must_check bus_create_file(struct bus_type *,
>  					struct bus_attribute *);
>  extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
>  
> +/**
> + * struct bus_type - The bus type of the device .
> + *
> + * @name:	The name of the bus
> + * @bus_attrs:	The attributes of the bus

Default attributes of the bus.

> + * @dev_attrs:	The default attributes of the devices on the bus
> + * @drv_attrs:	The default attributes of the device drivers on the bus
> + * @match:	Attaching drivers to devices

No, this is called when the driver core wants to know if this driver can
accept this device.  It does not do an "attach" here.

> + * @uevent:	Add the environment variable for device plug

"device plug"?  No, not always, it is for when a device is added,
removed, or a few other things that generate uevents.

> + * @probe:	Probe the device
> + * @remove:	Remove the device
> + * @shutdown:	Shutdown method
> + * @suspend:	Suspend method
> + * @resume:	Resume method

All of these can get more descriptions, right?

> + * @pm:		Device power management operations
> + * @p:		The private data the subsystem

p is private to the driver core, not to the subsystem.  Only the driver
core can touch this.

> + */ 
>  struct bus_type {
>  	const char		*name;
>  	struct bus_attribute	*bus_attrs;
> @@ -119,6 +136,23 @@ extern int bus_unregister_notifier(struct bus_type *bus,
>  extern struct kset *bus_get_kset(struct bus_type *bus);
>  extern struct klist *bus_get_device_klist(struct bus_type *bus);
>  
> +/**
> + * struct device_driver - The basic device driver structure
> + * @name:	Name of the device driver
> + * @bus:	The bus the device driver belongs to
> + * @owner:	The driver's owner

The module owner.

> + * @mod_name:	Used for built-in modules

Huh?

> + * @suppress_bind_attrs:Disables bind/unbind via sysfs
> + * @of_match_table:Id table for matching the driver to device

No, this is an open firmware table.

> + * @probe:	Called to bound a driver to the device

To bind.

> + * @remove:	Called to unbind a driver from a device
> + * @shutdown:	Called when shutdown
> + * @suspend:	Called to put the device in a low power state

Suspend is more than a "low power state"

> + * @resume:	Used to bring a device from a low power state

Same here.

> + * @groups:	Driver's attribute groups

Default attributes that get created by the driver core automatically.

> + * @pm:		Device's power management operations
> + * @p:		Driver's private data

Again, the driver core's private data, not the driver's private data,
very big difference.  No one other than the driver core can touch this.

Same goes for the other comments you added...

I think this needs a whole lot more description than what you have
provided in order for it to be acceptable.

Care to work on it?

thanks,

greg k-h
