Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab1CWOmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:42:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:37115 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab1CWOmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:42:11 -0400
Date: Wed, 23 Mar 2011 07:42:30 -0700
From: Greg KH <gregkh@suse.de>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] picoxcell-otp: add support for picoxcell OTP
 devices
Message-ID: <20110323144230.GD17369@suse.de>
References: <1300882619-19152-1-git-send-email-jamie@jamieiles.com>
 <1300882619-19152-2-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300882619-19152-2-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 12:16:58PM +0000, Jamie Iles wrote:
> picoxcell devices contain a block of OTP memory that can be used for
> storing first-stage bootloaders, cryptographic keys and other data to be
> kept onchip.  Different devices support a number of redundancy formats
> to cope with in-field programming errors and can be partitioned into
> regions to allow different redundancy formats with different effective
> sizes.
> 
> This patch implements an OTP device layer which different devices may
> register their OTP regions with.

Great, but why put it in drivers/char/?  Why not drivers/otp/?

> This provides sysfs entries that may
> be used to configure the number of regions, region format and access
> control such as write enable.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-picoxcell-otp  |   37 +
>  .../ABI/testing/sysfs-platform-picoxcell-otp       |   39 +
>  drivers/char/Kconfig                               |    8 +
>  drivers/char/Makefile                              |    1 +
>  drivers/char/picoxcellotp.c                        |  929 ++++++++++++++++++++
>  drivers/char/picoxcellotp.h                        |  230 +++++
>  6 files changed, 1244 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-picoxcell-otp
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-picoxcell-otp
>  create mode 100644 drivers/char/picoxcellotp.c
>  create mode 100644 drivers/char/picoxcellotp.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-picoxcell-otp b/Documentation/ABI/testing/sysfs-bus-picoxcell-otp
> new file mode 100644
> index 0000000..096b892
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-picoxcell-otp
> @@ -0,0 +1,37 @@
> +What:           /sys/bus/picoxcell-otp/

Shouldn't this just be sys/bus/otp/ ?

> +Date:           March 2011
> +KernelVersion:  2.6.40+
> +Contact:        Jamie Iles <jamie@jamieiles.com>
> +Description:
> +                The picoxcell-otp bus presents a number of devices where each
> +		device represents a region in the OTP device in the SoC. Each
> +		region will create a device node which allows the region to be
> +		written with read()/write() calls and the device on the bus
> +		has attributes for controlling the redundancy format and
> +		getting the region size.
> +
> +What:           /sys/bus/picoxcell-otp/devices/.../format
> +Date:           March 2011
> +KernelVersion:  2.6.40+
> +Contact:        Jamie Iles <jamie@jamieiles.com>
> +Description:
> +                The redundancy format of the region. Valid values are:
> +			- single-ended (1 bit of storage per data bit).
> +			- redundant (2 bits of storage, wire-OR'd per data
> +			  bit).
> +			- differential (2 bits of storage, differential
> +			  voltage per data bit).
> +			- differential-redundant (4 bits of storage, combining
> +			  redundant and differential).
> +		It is possible to increase redundancy of a region but care
> +		will be needed if there is data already in the region.
> +
> +What:           /sys/bus/picoxcell-otp/devices/.../size
> +Date:           March 2011
> +KernelVersion:  2.6.40+
> +Contact:        Jamie Iles <jamie@jamieiles.com>
> +Description:
> +                The effective storage size of the region. This is the amount
> +		of data that a user can store in the region taking into
> +		account the number of regions and the redundancy format of the
> +		region itself.
> diff --git a/Documentation/ABI/testing/sysfs-platform-picoxcell-otp b/Documentation/ABI/testing/sysfs-platform-picoxcell-otp
> new file mode 100644
> index 0000000..e5ee711
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-platform-picoxcell-otp
> @@ -0,0 +1,39 @@
> +What:		/sys/devices/platform/picoxcell-otp*/write_enable

Why are these in a platform subdirectory?  Shouldn't they be the devices
listed above in the previous file?

> +Date:		March 2011
> +KernelVersion:	2.6.40+
> +Contact:	"Jamie Iles" <jamie@jamieiles.com>
> +Description:
> +		This file controls whether the OTP in a Picochip PC3X3
> +		device can be written to. If set to "enabled" then the
> +		regions may be written, the number of regions may be
> +		changed and the format of any region may be changed.
> +
> +What:		/sys/devices/platform/picoxcell-otp*/num_regions
> +Date:		March 2011
> +KernelVersion:	2.6.40+
> +Contact:	"Jamie Iles" <jamie@jamieiles.com>
> +Description:
> +		This file controls the number of regions in the OTP device.
> +		Valid values are 1, 2, 4 and 8. The number of regions may be
> +		increased but never decreased. Increasing the number of
> +		regions will create new devices on the otp bus.
> +
> +What:		/sys/devices/platform/picoxcell-otp*/strict_programming
> +Date:		March 2011
> +KernelVersion:	2.6.40+
> +Contact:	"Jamie Iles" <jamie@jamieiles.com>
> +Description:
> +		This file indicates whether all words in a redundant format
> +		must be programmed correctly to indicate success.  Disabling
> +		this will mean that programming will be considered a success
> +		if the word can be read back correctly in it's redundant
> +		format.
> +
> +What:		/sys/devices/platform/picoxcell-otp*/bad_words
> +Date:		March 2011
> +KernelVersion:	2.6.40+
> +Contact:	"Jamie Iles" <jamie@jamieiles.com>
> +Description:
> +		Contains a space delimited list of raw addresses that have
> +		failed to program correctly.  This is non-persistent and may
> +		be used by userland to work around faulty words.

This isn't a valid sysfs file in that it contains more than a single
value.  Please fix it or remove it.

> +/*
> + * Add all of the device entries to sysfs. This also includes creating the
> + * region device nodes and sysfs entries.
> + */
> +static int otp_sysfs_add(struct device *dev)
> +{
> +	int err;
> +
> +	err = device_create_file(dev, &dev_attr_write_enable);
> +	if (err)
> +		goto out;
> +
> +	err = device_create_file(dev, &dev_attr_num_regions);
> +	if (err)
> +		goto num_regions_fail;
> +
> +	err = device_create_file(dev, &dev_attr_bad_words);
> +	if (err)
> +		goto bad_words_fail;
> +
> +	err = device_create_file(dev, &dev_attr_strict_programming);
> +	if (err)
> +		goto strict_programming_fail;
> +

Shouldn't all of these be in an attribute group like the other sysfs
files are in this driver?  That way you add/remove them all at once.

thanks,

greg k-h
