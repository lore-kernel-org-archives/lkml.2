Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1AUOvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:51:42 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52191 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1AUOvl (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 21 Jan 2011 09:51:41 -0500
Date: Fri, 21 Jan 2011 09:50:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] acpi_pm: Clear pmtmr_ioport if acpi_pm initialization
 fails
Message-ID: <20110121145008.GC27319@dumpdata.com>
References: <1295027246-11110-1-git-send-email-johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295027246-11110-1-git-send-email-johnstul@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 09:47:26AM -0800, John Stultz wrote:
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 

tgl,

Are you OK pushing this up to Linus or should I do it? We can
also delay this till the next merge window as the other fix
that John proposed solves the bootup issue so it is not that urgent.

> If the acpi pm timer throws invalid data, clear pmtmr_ioport
> so the pm timer won't accidentally be used.
> 
> This was found when using Xen where there is a acpi pm reported,
> but gives bogus values, and other code was continuing to try
> to use the pm timer after the initialization failed.
> 
> [jstultz: Catch additional failure and reword changelog message. ]

Thank you John.

> 
> CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> ---
>  drivers/clocksource/acpi_pm.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
> index cfb0f52..effe797 100644
> --- a/drivers/clocksource/acpi_pm.c
> +++ b/drivers/clocksource/acpi_pm.c
> @@ -202,17 +202,21 @@ static int __init init_acpi_pm_clocksource(void)
>  			printk(KERN_INFO "PM-Timer had inconsistent results:"
>  			       " 0x%#llx, 0x%#llx - aborting.\n",
>  			       value1, value2);
> +			pmtmr_ioport = 0;
>  			return -EINVAL;
>  		}
>  		if (i == ACPI_PM_READ_CHECKS) {
>  			printk(KERN_INFO "PM-Timer failed consistency check "
>  			       " (0x%#llx) - aborting.\n", value1);
> +			pmtmr_ioport = 0;
>  			return -ENODEV;
>  		}
>  	}
>  
> -	if (verify_pmtmr_rate() != 0)
> +	if (verify_pmtmr_rate() != 0){
> +		pmtmr_ioport = 0;
>  		return -ENODEV;
> +	}
>  
>  	return clocksource_register_hz(&clocksource_acpi_pm,
>  						PMTMR_TICKS_PER_SEC);
> -- 
> 1.7.3.2.146.gca209
