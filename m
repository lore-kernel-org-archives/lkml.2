Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab0GVR2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:28:31 -0400
Received: from imr1.ericy.com ([198.24.6.9]:51772 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0GVR23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:28:29 -0400
Date: Thu, 22 Jul 2010 10:27:26 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, Huaxu Wan <huaxu.wan@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 5/5] Package Level Thermal Control and Power Limit
 Notification: pkgtemp doc
Message-ID: <20100722172726.GA4914@ericsson.com>
References: <94E56C79ECC49A4B87113985F1FEBA8D03F8AE2A4B@bgsmsx502.gar.corp.intel.com>
 <4C485DF1.5050407@linux.intel.com>
 <20100722162222.GA22450@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100722162222.GA22450@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 12:22:23PM -0400, Fenghua Yu wrote:
> 
> Document for package level thermal hwmon driver.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Reviewed-by: Len Brown <len.brown@intel.com>
> ---
> 
>  pkgtemp |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+)
> 
> diff --git a/Documentation/hwmon/pkgtemp b/Documentation/hwmon/pkgtemp
> new file mode 100644
> index 0000000..a60d286
> --- /dev/null
> +++ b/Documentation/hwmon/pkgtemp
> @@ -0,0 +1,36 @@
> +Kernel driver pkgtemp
> +======================
> +
> +Supported chips:
> +  * Intel family
> +    Prefix: 'pkgtemp'
> +    CPUID:
> +    Datasheet: Intel 64 and IA-32 Architectures Software Developer's Manual
> +               Volume 3A: System Programming Guide
> +
> +Author: Fenghua Yu
> +
> +Description
> +-----------
> +
> +This driver permits reading package level temperature sensor embedded inside
> +Intel CPU package. The sensors can be in core, uncore, memroy controller, or

memroy --> memory

> +other componenets in a package. The feature is first implemented in Intel Sandy

componenets --> components

> +Bridge platform.
> +
Just for clarification - you mention a number of sensors, but unless
I am missing something only the package sensor is implemented. Is that correct ?

> +Temperature is measured in degrees Celsius and measurement resolution is
> +1 degree C. Valid temperatures are from 0 to TjMax degrees C, because the actual
> +value of temperature register is in fact a delta from TjMax.
> +
>From the code, it seems that negative values can be reported. Is it guaranteed 
by the chip that (TjMax - MSR_IA32_TEMPERATURE_TARGET) >= 0 ? Otherwise, the
minimum temperature would be (TjMax - 127).

> +Temperature known as TjMax is the maximum junction temperature of package.
> +Intel defines this temperature as 125C. At this temperature, protection

Your driver bails out at TjMax >= 120, so there is some inconsistency.
Also, it seems that this is not a constant, since you are reading
MSR_IA32_TEMPERATURE_TARGET to get the value.

Since the CPUs supporting the package sensor presumably also all support
reading TjMax, maybe you can reword the above text to reflect this.

> +mechanism will perform actions to forcibly cool down the processor. Alarm
> +may be raised, if the temperature grows enough (more than TjMax) to trigger
> +the Out-Of-Spec bit. Following table summarizes the exported sysfs files:
> +
> +temp1_input	 - Package temperature (in millidegrees Celsius).
> +temp1_crit	 - Maximum junction temperature (in millidegrees Celsius).
> +temp1_crit_alarm - Set when Out-of-spec bit is set, never clears.
> +		   Correct CPU operation is no longer guaranteed.
> +temp1_label	 - Contains string "Pysical package id X", where X is physical

Pysical --> Physical.
I would suggest to drop the "id" for consistency. Core sensor names don't
include "id" either.

I am not sure if "physical" should be included in the first place.
Also, above description suggests that future CPUs might add more sensors.
If so, the name should probably reflect the location of the current sensor,
ie be something like "Package core X" or "Core package X" or "Package X (core)".

> +		   package id.

