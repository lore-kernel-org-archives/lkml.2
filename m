Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2IKFdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 01:33:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:20323 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab2IKFdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 01:33:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,401,1344236400"; 
   d="scan'208";a="143635879"
Date: Tue, 11 Sep 2012 13:33:07 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / PM: Infer parent power state from child if unknown
Message-ID: <20120911053305.GA2130@mint-spring.sh.intel.com>
References: <1346053126-7646-1-git-send-email-aaron.lu@intel.com>
 <201209072032.55469.rjw@sisk.pl>
 <20120910003805.GA1590@mint-spring.sh.intel.com>
 <201209102150.22738.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209102150.22738.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 09:50:22PM +0200, Rafael J. Wysocki wrote:
>  drivers/acpi/bus.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> Index: linux/drivers/acpi/bus.c
> ===================================================================
> --- linux.orig/drivers/acpi/bus.c
> +++ linux/drivers/acpi/bus.c
> @@ -228,7 +228,16 @@ static int __acpi_bus_get_power(struct a
>  		result = psc;
>  	}
>  	/* The test below covers ACPI_STATE_UNKNOWN too. */
> -	if (result <= ACPI_STATE_D2) {
> +	if (result == ACPI_STATE_D0) {

Oops, I just realized that the check here is too early if device does
not have _PSC but _PRx, its parent will miss the chance to get power
state updated :-)

Sorry for not spotting this earlier.

-Aaron

> +		/*
> +		 * If we were unsure about the device parent's power state up to
> +		 * this point, the fact that the device is in D0 implies that
> +		 * the parent has to be in D0 too.
> +		 */
> +		if (device->parent
> +		    && device->parent->power.state == ACPI_STATE_UNKNOWN)
> +			device->parent->power.state = ACPI_STATE_D0;
> +	} else if (result <= ACPI_STATE_D2) {
>  	  ; /* Do nothing. */
>  	} else if (device->power.flags.power_resources) {
>  		int error = acpi_power_get_inferred_state(device, &result);
