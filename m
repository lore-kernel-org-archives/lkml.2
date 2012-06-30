Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab2F3DXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 23:23:40 -0400
Received: from mail-yw0-f42.google.com ([209.85.213.42]:43150 "EHLO
	mail-yw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2F3DXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 23:23:39 -0400
Date: Fri, 29 Jun 2012 23:23:33 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Boie <andrew.p.boie@intel.com>
Cc: ccross@android.com, arve@android.com, rebecca@android.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcb: Android bootloader control block driver
Message-ID: <20120630032333.GB3972@kroah.com>
References: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 12:36:30PM -0700, Andrew Boie wrote:
> Android userspace tells the kernel that it wants to boot into recovery
> or some other non-default OS environment by passing a string argument
> to reboot(). It is left to the OEM to hook this up to their specific
> bootloader.

How does userspace "tell" the kernel this?  You are creating a new
user/kernel api here, and haven't documented it at all.  That's not
generally a wise idea.

> This driver uses the bootloader control block (BCB) in the 'misc'
> partition, which is the AOSP mechanism used to communicate with
> the bootloader. Writing 'bootonce-NNN' to the command field
> will cause the bootloader to do a oneshot boot into an alternate
> boot label NNN if it exists. The device and partition number are
> passed in via kernel command line.

I don't understand still, why userspace can't just do this as it is the
one that knws where the device and partition is, and it knows what it
wants to have written in this area, why have the kernel do this?  Why
not just modify userspace to do it instead?

> It is the bootloader's job to guard against this area being uninitialzed
> or containing an invalid boot label, and just boot normally if that
> is the case. The bootloader will always populate a magic signature in
> the BCB; the driver will refuse to update it if not present.

That sounds like something that userspace should be doing, not the
kernel.

> Signed-off-by: Andrew Boie <andrew.p.boie@intel.com>
> ---
>  drivers/staging/android/Kconfig  |   11 ++
>  drivers/staging/android/Makefile |    1 +
>  drivers/staging/android/bcb.c    |  232 ++++++++++++++++++++++++++++++++++++++

Why is this being proposed for drivers/staging/?  What is wrong with the
code that is keeping it out of the "real" part of the kernel (well,
except for the above questions that is)?

What would need to be done to it to get it out of staging, and why
hasn't that been done to the code already?


> 
> diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
> index 9a99238..c30fd20 100644
> --- a/drivers/staging/android/Kconfig
> +++ b/drivers/staging/android/Kconfig
> @@ -78,6 +78,17 @@ config ANDROID_INTF_ALARM_DEV
>  	  elapsed realtime, and a non-wakeup alarm on the monotonic clock.
>  	  Also exports the alarm interface to user-space.
>  
> +config BOOTLOADER_CONTROL
> +	tristate "Bootloader Control Block module"
> +	default n
> +	help
> +	  This driver installs a reboot hook, such that if reboot() is invoked
> +	  with a string argument NNN, "bootonce-NNN" is copied to the command
> +	  field in the Bootloader Control Block on the /misc partition, to be
> +	  read by the bootloader. If the string matches one of the boot labels
> +	  defined in its configuration, it will boot once into that label. The
> +	  device and partition number are specified on the kernel command line.
> +
>  endif # if ANDROID
>  
>  endmenu
> diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
> index 8e18d4e..a27707f 100644
> --- a/drivers/staging/android/Makefile
> +++ b/drivers/staging/android/Makefile
> @@ -9,5 +9,6 @@ obj-$(CONFIG_ANDROID_LOW_MEMORY_KILLER)	+= lowmemorykiller.o
>  obj-$(CONFIG_ANDROID_SWITCH)		+= switch/
>  obj-$(CONFIG_ANDROID_INTF_ALARM_DEV)	+= alarm-dev.o
>  obj-$(CONFIG_PERSISTENT_TRACER)		+= trace_persistent.o
> +obj-$(CONFIG_BOOTLOADER_CONTROL)	+= bcb.o
>  
>  CFLAGS_REMOVE_trace_persistent.o = -pg
> diff --git a/drivers/staging/android/bcb.c b/drivers/staging/android/bcb.c
> new file mode 100644
> index 0000000..af75257
> --- /dev/null
> +++ b/drivers/staging/android/bcb.c
> @@ -0,0 +1,232 @@
> +/*
> + * bcb.c: Reboot hook to write bootloader commands to
> + *        the Android bootloader control block
> + *
> + * (C) Copyright 2012 Intel Corporation
> + * Author: Andrew Boie <andrew.p.boie@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/blkdev.h>
> +#include <linux/reboot.h>
> +
> +#define BCB_MAGIC	0xFEEDFACE
> +
> +/* Persistent area written by Android recovery console and Linux bcb driver
> + * reboot hook for communication with the bootloader. Bootloader must
> + * gracefully handle this area being unitinitailzed */
> +struct bootloader_message {
> +	/* Directive to the bootloader on what it needs to do next.
> +	 * Possible values:
> +	 *   boot-NNN - Automatically boot into label NNN
> +	 *   bootonce-NNN - Automatically boot into label NNN, clearing this
> +	 *     field afterwards
> +	 *   anything else / garbage - Boot default label */
> +	char command[32];
> +
> +	/* Storage area for error codes when using the BCB to boot into special
> +	 * boot targets, e.g. for baseband update. Not used here. */
> +	char status[32];
> +
> +	/* Area for recovery console to stash its command line arguments
> +	 * in case it is reset and the cache command file is erased.
> +	 * Not used here. */
> +	char recovery[1024];
> +
> +	/* Magic sentinel value written by the bootloader; don't update this
> +	 * if not equalto to BCB_MAGIC */
> +	uint32_t magic;
> +};

Ick, you are tacking this onto the reboot() syscall?  And doing so
without setting any of those fields to 0?  How do you handle null
terminating the command line arguments, or the command or the status
fields properly?  Pad them out with spaces?  You better document the
heck out of this as you just essencially are creating a whole new
syscall, and we can't do that without lots of documentation and review.

Actually, why not just create a new syscall?  That's what you really
want here, right?

> +/* TODO: device names/partition numbers are unstable. Add support for looking
> + * by GPT partition UUIDs */

They are more than just "unstable" they are not stable at all and should
not be used at all for something like this.

> +static char *bootdev = "sda";
> +module_param(bootdev, charp, S_IRUGO);
> +MODULE_PARM_DESC(bootdev, "Block device for bootloader communication");
> +
> +static int partno;
> +module_param(partno, int, S_IRUGO);
> +MODULE_PARM_DESC(partno, "Partition number for bootloader communication");

So, by default, you write over sda.  Not very nice.  And a module
parameter?  Really?  That's not a good way to talk to a module, who is
going to set these options and how are they going to know how to do it?
And who is going to give them the permission to set these options?

Why are these module parameters, and the other information tacked on in
a string to the reboot syscall?  Wouldn't it make more sense to put it
all in the syscall?  That way you could build the code into the
kernel...

Note, none of this review should be construed as me saying this is a
valid option to be putting into the kernel at all.  I still think it
should be done in userspace and see no reason why it can not be done
that way.

thanks,

greg k-h
