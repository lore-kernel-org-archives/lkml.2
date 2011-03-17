Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1CQTaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:30:46 -0400
Received: from kroah.org ([198.145.64.141]:56355 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab1CQTaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:30:35 -0400
Date: Thu, 17 Mar 2011 12:30:23 -0700
From: Greg KH <greg@kroah.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH]: SMBIOS: Add initial code and export version via sysfs
Message-ID: <20110317193023.GA16790@kroah.com>
References: <20110317135754.25241.88177.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317135754.25241.88177.sendpatchset@prarit.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 09:57:54AM -0400, Prarit Bhargava wrote:
> The existing DMI code, drivers/firmware/dmi.c, is not really parsing DMI.  It
> is actually SMBIOS code that is using the old DMI infrastructure to expose
> SMBIOS entries.
> 
> We should be doing the following:
> 
> 1.  Looking for SMBIOS (either EFI or mapped to it's standard location,
>     0xF0000)
> 2.  If found, look for the SMBIOS' Intermediate Structure (aka "DMI" entry)
> 3.  If not found, look for an "old" DMI structure.
> 
> DMI is a predecessor of SMBIOS, so we should start treating it as such.

Why?  What is this change going to buy us in the end?  Heck, right now,
what's the benefit?

> For this patch I have introduced drivers/firmware/smbios.c, exported the
> SMBIOS version through sysfs, and modified the DMI code such that
> 
> a) dmi_scan_machine() is now called from init_smbios(), and
> b) if an SMBIOS is found, the values in the SMBIOS STEP structure are used
> in dmi_scan_machine().
> 
> Right now, removing the DMI code is not an option.  It is used by common
> initscripts, etc., to bringup the system.  Later modifications in this area will
> include additional parsing of the SMBIOS structs and a simultaneous cleanup
> of the DMI code.

Care to show follow-on patches that convert things to a manner which you
think it should look like?

> --- /dev/null
> +++ b/drivers/firmware/smbios.c
> @@ -0,0 +1,175 @@
> +#include <linux/dmi.h>
> +#include <linux/efi.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/smbios.h>
> +
> +#include <asm/setup.h>
> +
> +int smbios_present = 0;
> +struct smbios_step *smbios_step;
> +static struct device *smbios_dev;

A "raw" struct device?  Why?  You should never do this, that's not the
way to use a 'struct device'.

Let's back up here, what exactly are you trying to show in sysfs?  Where
are your Documentation/ABI/ entries that show these new files, what they
contain, and how to use them?

> +/* The actual address of the SMBIOS */
> +static unsigned long smbios_addr = 0;
> +
> +#ifdef CONFIG_SYSFS

You should never need this in your .c file.

> +static ssize_t version_show(struct device *dev,
> +			    struct device_attribute *attr, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%u.%u\n", smbios_step->major,
> +		       smbios_step->minor);

As you "know" you are only returning a simple value, why the snprintf()?
Hint, don't, it's overkill and how do you "know" that the buffer is
PAGE_SIZE big?  Hint, you don't, so stick to a small buffer like you
are, and all is fine.

> +}
> +
> +/* add additional sysfs files here */
> +static struct device_attribute smbios_attrs[] = {
> +	__ATTR_RO(version),
> +};

So a whole new class just for a single version file in sysfs?

I'm confused, what exactly are you trying to show here that you can't
show in the existing device/class structure?

> +
> +static struct class smbios_class = {
> +	.name = "smbios",
> +	.dev_release = (void(*)(struct device *)) kfree,

As stated before, nice try, but no. :)


> +};
> +
> +static struct device *smbios_dev;
> +
> +static int __init smbios_setup_sysfs(void)
> +{
> +	int attr, i, ret = 0;
> +
> +	ret = class_register(&smbios_class);
> +	if (ret)
> +		goto out;
> +
> +	smbios_dev = kzalloc(sizeof(*smbios_dev), GFP_KERNEL);
> +	if (!smbios_dev) {
> +		ret = -ENOMEM;
> +		goto out_cleanup_class;
> +	}
> +
> +	smbios_dev->class = &smbios_class;
> +	dev_set_name(smbios_dev, "id");
> +
> +	ret = device_register(smbios_dev);
> +	if (ret)
> +		goto out_cleanup_smbios_dev;
> +
> +	for (attr = 0; attr < ARRAY_SIZE(smbios_attrs); attr++) {
> +		ret = device_create_file(smbios_dev, &smbios_attrs[attr]);

You just raced userspace when you created this file, causing it massive
problems if it was expecting when the hotplug event happened that this
file would be present.  Please don't do that, we have the infrastructure
to do this properly, please use it.

thanks,

greg k-h
