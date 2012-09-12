Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab2ILG7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:59:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:48738 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab2ILG7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:59:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,408,1344236400"; 
   d="scan'208";a="144090057"
Date: Wed, 12 Sep 2012 14:59:04 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / PM: Infer parent power state from child if
 unknown, v2
Message-ID: <20120912065902.GA2229@mint-spring.sh.intel.com>
References: <1346053126-7646-1-git-send-email-aaron.lu@intel.com>
 <201209102150.22738.rjw@sisk.pl>
 <20120911053305.GA2130@mint-spring.sh.intel.com>
 <201209112238.06658.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209112238.06658.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 10:38:06PM +0200, Rafael J. Wysocki wrote:
> It turns out that there are ACPI BIOSes defining device objects with
> _PSx and without either _PSC or _PRx.  For devices corresponding to
> those ACPI objetcs __acpi_bus_get_power() returns ACPI_STATE_UNKNOWN
> and their initial power states are regarded as unknown as a result.
> If such a device is a parent of another power-manageable device, the
> child cannot be put into a low-power state through ACPI, because
> __acpi_bus_set_power() refuses to change power states of devices
> whose parents' power states are unknown.
> 
> To work around this problem, observe that the ACPI power state of
> a device cannot be higher-power (lower-number) than the power state
> of its parent.  Thus, if the device's _PSC method or the
> configuration of its power resources indicates that the device is
> in D0, the device's parent has to be in D0 as well.  Consequently,
> if the parent's power state is unknown when we've just learned that
> its child's power state is D0, we can safely set the parent's
> power.state field to ACPI_STATE_D0.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Tested-by: Aaron Lu <aaron.lu@intel.com>

-Aaron

> ---
>  drivers/acpi/bus.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux/drivers/acpi/bus.c
> ===================================================================
> --- linux.orig/drivers/acpi/bus.c
> +++ linux/drivers/acpi/bus.c
> @@ -237,6 +237,16 @@ static int __acpi_bus_get_power(struct a
>  	} else if (result == ACPI_STATE_D3_HOT) {
>  		result = ACPI_STATE_D3;
>  	}
> +
> +	/*
> +	 * If we were unsure about the device parent's power state up to this
> +	 * point, the fact that the device is in D0 implies that the parent has
> +	 * to be in D0 too.
> +	 */
> +	if (device->parent && device->parent->power.state == ACPI_STATE_UNKNOWN
> +	    && result == ACPI_STATE_D0)
> +		device->parent->power.state = ACPI_STATE_D0;
> +
>  	*state = result;
>  
>   out:
