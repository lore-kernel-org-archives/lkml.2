Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2LXTak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 14:30:40 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61188 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab2LXTah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 14:30:37 -0500
X-Originating-IP: 108.223.40.66
Date: Mon, 24 Dec 2012 11:30:38 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: "Simon J. Rowe" <srowe@mose.org.uk>
Cc: lm-sensors@lm-sensors.org, Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] RFC: Intel QST driver
Message-ID: <20121224193038.GA7786@roeck-us.net>
References: <50D81465.9060802@mose.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D81465.9060802@mose.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 08:37:57AM +0000, Simon J. Rowe wrote:
> I've written a driver for the Intel Quiet System Technology (QST)
> function of the Management Engine Interface found on recent Intel
> chipsets.
> 
> The git repo can be found here:
> 
>     http://mose.dyndns.org/mei.git
> 
> A few questions / observations,
> 
> 1) The code was developed and tested on 2.6.39. I would hope it
> compiles and runs on 3.x but I haven't tried it.
> 
Hi Simon,

2.6.39 is pretty old. It doesn't include the new mei driver (which is now
in drivers/misc/mei).

> 2) The main hwmon code is in qst-hwmon.c. This implements QST v1, I
> don't have access to hardware that supports v2. I would imagine that
> implementing v2 would result in a new module (qst2-hwmon) which would
> be almost identical.
> 
Is it that much different that it would require a separate driver, especially
if it is almost identical ?

> 3) I've gone a bit overboard with preprocessor macros but it does mean
> that the amount of duplicated code is kept to a minimum.
> 
It also hides possible error cases, though, and makes review very complicated.
You would be better off using function parameters as much as possible. Plus,
after all, it is not correct that you avoid duplicate code. You only avoid
duplicate source code. Fore that, the additional cost (in terms of risk and
maintainability) is pretty high.

> 3) I've not implemented any PWM methods yet.
> 
> 4) I don't believe the MEI (HECI) implementation that Intel have
> already submitted to the mainline kernel is usable by other kernel
> modules. I have re-implemented it in a way that is accessible to
> either the kernel or userspace.
> 
2.6.39 does not include the new mei driver, so I don't think you can make
that claim.

I would suggest to have a look into the new driver and work with its
maintainer to make it better suitable for other drivers if needed.
Its main deficiency, as far as I could see when I looked into it, is that it
doesn't support out-of-directory drivers very well - which means the hwmon
driver might have to reside in drivers/misc/mei instead of drivers/hwmon.
Not an optimal solution, but better than nothing.

> 5) I had to patch libsensors to work with a new bus type
> 
> diff -ur lm_sensors-3.3.1.org//lib/sysfs.c lm_sensors-3.3.1/lib/sysfs.c
> --- lm_sensors-3.3.1.org//lib/sysfs.c   2011-03-04 20:37:43.000000000 +0000
> +++ lm_sensors-3.3.1/lib/sysfs.c        2012-11-14 21:48:52.144860375 +0000
> @@ -701,6 +701,12 @@
>                 /* As of kernel 2.6.32, the hid device names don't
> look good */
>                 entry.chip.bus.nr = bus;
>                 entry.chip.addr = id;
> +       } else
> +       if (subsys && !strcmp(subsys, "intel-mei") &&
> +           sscanf(dev_name, "mei%d:%d", &bus, &fn) == 2) {
> +               entry.chip.bus.type = SENSORS_BUS_TYPE_PCI;
> +               entry.chip.bus.nr = bus;
> +               entry.chip.addr = fn;
>         } else {
>                 /* Ignore unknown device */
>                 err = 0;
> 
Is that really necessary ? Changing the ABI/API to userland is always
problematic.

> surely this sort of knowledge belongs in the driver not userspace?
> Could drivers not provide another set of sysfs attributes which expose
> bus type, number, addr etc?
> 
> Please let me know if there's any changes or improvements I can make
> to it.
> 
You might want to run your code through checkpatch and fix all errors and
warnings. The major problem, though, is that we can not have two instances
of mei core code in the kernel.

Copying the mei driver maintainer and the kernel mailing list for additional
input.

Thanks,
Guenter
